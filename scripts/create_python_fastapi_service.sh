#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  create_python_fastapi_service.sh <repo-path> [agents-root]

Examples:
  ./scripts/create_python_fastapi_service.sh /workspaces/my-enterprise-service
  ./scripts/create_python_fastapi_service.sh /workspaces/my-enterprise-service /workspaces/agents
EOF
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

repo_path="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_agents_root="$(cd "${script_dir}/.." && pwd)"
agents_root="${2:-$default_agents_root}"

repo_name="$(basename "$repo_path")"
package_name="$(echo "$repo_name" | tr '-' '_' | tr -cd '[:alnum:]_')"

mkdir -p \
  "$repo_path/.github/workflows" \
  "$repo_path/src/$package_name/api/routes" \
  "$repo_path/src/$package_name/core" \
  "$repo_path/src/$package_name/models" \
  "$repo_path/src/$package_name/services" \
  "$repo_path/tests"

if [[ ! -d "$repo_path/.git" ]]; then
  git init "$repo_path" >/dev/null
fi

if [[ ! -f "$repo_path/README.md" ]]; then
  cat >"$repo_path/README.md" <<EOF
# $repo_name

Enterprise FastAPI service scaffold generated from the agents repository baseline.

## Setup

\`\`\`bash
export PATH="\$HOME/.local/bin:\$PATH"
uv venv .venv
source .venv/bin/activate
cp .env.example .env
uv sync
uv run pytest -v
uv run uvicorn $package_name.main:app --reload
\`\`\`

## Included Baseline

- FastAPI with lifespan-based startup
- JWT auth with bcrypt + SHA-256 pre-hash
- RBAC dependency guards
- TrustedHost, CORS, and security headers
- Rate limiting with slowapi
- Structured JSON logging
- Prometheus metrics and OpenTelemetry hooks
- SQLite-backed example domain service
- GitHub Actions CI workflow
EOF
fi

if [[ ! -f "$repo_path/.gitignore" ]]; then
  cat >"$repo_path/.gitignore" <<'EOF'
.venv/
__pycache__/
.pytest_cache/
*.pyc
*.db
dist/
build/
.DS_Store
EOF
fi

if [[ ! -f "$repo_path/.env.example" ]]; then
  cat >"$repo_path/.env.example" <<EOF
APP_NAME=$repo_name
ENV=dev
DEBUG=true
JWT_SECRET_KEY=CHANGE-ME-please-replace-with-32-plus-bytes-minimum
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=30
CORS_ORIGINS=http://localhost:3000
ALLOWED_HOSTS=localhost,127.0.0.1,testserver
RATE_LIMIT_AUTH=10/minute
RATE_LIMIT_GENERAL=120/minute
DATABASE_PATH=./app.db
OTEL_EXPORT_TO_CONSOLE=false
EOF
fi

if [[ ! -f "$repo_path/pyproject.toml" ]]; then
  cat >"$repo_path/pyproject.toml" <<EOF
[project]
name = "$repo_name"
version = "0.1.0"
description = "Enterprise FastAPI service scaffold created from agents baseline"
readme = "README.md"
requires-python = ">=3.12"
dependencies = [
  "bcrypt>=4.1.0,<5.0.0",
  "email-validator>=2.2.0,<3.0.0",
  "fastapi>=0.115.0,<1.0.0",
  "faker>=33.1.0,<34.0.0",
  "opentelemetry-api>=1.27.0,<2.0.0",
  "opentelemetry-sdk>=1.27.0,<2.0.0",
  "opentelemetry-instrumentation-fastapi>=0.48b0,<1.0.0",
  "prometheus-fastapi-instrumentator>=7.0.0,<8.0.0",
  "pydantic>=2.8.0,<3.0.0",
  "pydantic-settings>=2.4.0,<3.0.0",
  "pyjwt>=2.9.0,<3.0.0",
  "pyyaml>=6.0.2,<7.0.0",
  "slowapi>=0.1.9,<1.0.0",
  "structlog>=24.4.0,<25.0.0",
  "uvicorn>=0.30.0,<1.0.0",
]

[dependency-groups]
dev = [
  "httpx>=0.27.0,<1.0.0",
  "pytest>=8.3.0,<9.0.0",
  "pytest-asyncio>=0.24.0,<1.0.0",
]

[tool.pytest.ini_options]
pythonpath = ["src"]
asyncio_mode = "auto"
addopts = "-q"
EOF
fi

if [[ ! -f "$repo_path/.github/workflows/ci.yml" ]]; then
  cat >"$repo_path/.github/workflows/ci.yml" <<'EOF'
name: CI

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Install uv
        run: pip install uv
      - name: Sync dependencies
        run: uv sync
      - name: Run tests
        run: uv run pytest -v
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/__init__.py" ]]; then
  echo '"""Enterprise FastAPI service package."""' >"$repo_path/src/$package_name/__init__.py"
fi

if [[ ! -f "$repo_path/src/$package_name/api/__init__.py" ]]; then
    echo '"""API package."""' >"$repo_path/src/$package_name/api/__init__.py"
fi

if [[ ! -f "$repo_path/src/$package_name/core/__init__.py" ]]; then
    echo '"""Core application components."""' >"$repo_path/src/$package_name/core/__init__.py"
fi

if [[ ! -f "$repo_path/src/$package_name/models/__init__.py" ]]; then
    echo '"""Pydantic models."""' >"$repo_path/src/$package_name/models/__init__.py"
fi

if [[ ! -f "$repo_path/src/$package_name/services/__init__.py" ]]; then
    echo '"""Domain services."""' >"$repo_path/src/$package_name/services/__init__.py"
fi

if [[ ! -f "$repo_path/src/$package_name/core/config.py" ]]; then
  cat >"$repo_path/src/$package_name/core/config.py" <<EOF
from functools import lru_cache

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    app_name: str = Field(default="$repo_name", alias="APP_NAME")
    env: str = Field(default="dev", alias="ENV")
    debug: bool = Field(default=True, alias="DEBUG")

    jwt_secret_key: str = Field(
        default="CHANGE-ME-please-replace-with-32-plus-bytes-minimum",
        alias="JWT_SECRET_KEY",
    )
    jwt_algorithm: str = Field(default="HS256", alias="JWT_ALGORITHM")
    jwt_expire_minutes: int = Field(default=30, alias="JWT_EXPIRE_MINUTES")

    cors_origins: str = Field(default="http://localhost:3000", alias="CORS_ORIGINS")
    allowed_hosts: str = Field(default="localhost,127.0.0.1,testserver", alias="ALLOWED_HOSTS")

    rate_limit_auth: str = Field(default="10/minute", alias="RATE_LIMIT_AUTH")
    rate_limit_general: str = Field(default="120/minute", alias="RATE_LIMIT_GENERAL")

    database_path: str = Field(default="./app.db", alias="DATABASE_PATH")
    otel_export_to_console: bool = Field(default=False, alias="OTEL_EXPORT_TO_CONSOLE")

    @field_validator("jwt_secret_key")
    @classmethod
    def validate_jwt_secret_key(cls, value: str) -> str:
        if len(value.encode("utf-8")) < 32:
            raise ValueError("JWT_SECRET_KEY must be at least 32 bytes long.")
        return value

    @property
    def cors_origin_list(self) -> list[str]:
        return [value.strip() for value in self.cors_origins.split(",") if value.strip()]

    @property
    def allowed_host_list(self) -> list[str]:
        return [value.strip() for value in self.allowed_hosts.split(",") if value.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/core/logging.py" ]]; then
  cat >"$repo_path/src/$package_name/core/logging.py" <<'EOF'
import json
import logging
import sys
import time

import structlog
from fastapi import Request


class JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        payload = {
            "ts": int(time.time() * 1000),
            "level": record.levelname,
            "logger": record.name,
            "msg": record.getMessage(),
        }
        return json.dumps(payload)


def configure_logging() -> None:
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(JsonFormatter())
    root = logging.getLogger()
    root.handlers = [handler]
    root.setLevel(logging.INFO)

    structlog.configure(
        processors=[
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.add_log_level,
            structlog.processors.JSONRenderer(),
        ],
        logger_factory=structlog.stdlib.LoggerFactory(),
        cache_logger_on_first_use=True,
    )


async def request_logging_middleware(request: Request, call_next):
    logger = structlog.get_logger("http")
    start = time.perf_counter()
    response = await call_next(request)
    duration_ms = (time.perf_counter() - start) * 1000
    logger.info(
        "request.complete",
        method=request.method,
        path=request.url.path,
        status_code=response.status_code,
        duration_ms=round(duration_ms, 2),
    )
    return response
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/core/rate_limit.py" ]]; then
  cat >"$repo_path/src/$package_name/core/rate_limit.py" <<'EOF'
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/core/security.py" ]]; then
  cat >"$repo_path/src/$package_name/core/security.py" <<EOF
import hashlib
from datetime import UTC, datetime, timedelta

import bcrypt
import jwt
from fastapi import HTTPException, status

from $package_name.core.config import Settings


class TokenPayload(dict):
    @property
    def subject(self) -> str:
        return str(self["sub"])

    @property
    def role(self) -> str:
        return str(self["role"])


def _prehash(password: str) -> bytes:
    return hashlib.sha256(password.encode("utf-8")).digest()


def hash_password(password: str) -> str:
    return bcrypt.hashpw(_prehash(password), bcrypt.gensalt()).decode("utf-8")


def verify_password(password: str, password_hash: str) -> bool:
    return bcrypt.checkpw(_prehash(password), password_hash.encode("utf-8"))


def validate_password_strength(password: str) -> None:
    checks = [
        len(password) >= 8,
        any(char.isupper() for char in password),
        any(char.islower() for char in password),
        any(char.isdigit() for char in password),
    ]
    if not all(checks):
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Password must be at least 8 chars and include upper, lower, and digit.",
        )


def create_access_token(subject: str, role: str, settings: Settings) -> str:
    expires = datetime.now(UTC) + timedelta(minutes=settings.jwt_expire_minutes)
    payload = {"sub": subject, "role": role, "exp": expires}
    return jwt.encode(payload, settings.jwt_secret_key, algorithm=settings.jwt_algorithm)


def decode_token(token: str, settings: Settings) -> TokenPayload:
    try:
        payload = jwt.decode(token, settings.jwt_secret_key, algorithms=[settings.jwt_algorithm])
    except jwt.PyJWTError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials.",
        ) from exc
    return TokenPayload(payload)
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/core/telemetry.py" ]]; then
  cat >"$repo_path/src/$package_name/core/telemetry.py" <<'EOF'
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter


def configure_tracing(app, settings) -> None:
    provider = TracerProvider()
    if settings.otel_export_to_console:
        provider.add_span_processor(BatchSpanProcessor(ConsoleSpanExporter()))
    trace.set_tracer_provider(provider)
    FastAPIInstrumentor.instrument_app(app)
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/models/auth.py" ]]; then
  cat >"$repo_path/src/$package_name/models/auth.py" <<'EOF'
from pydantic import BaseModel, EmailStr, Field


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    full_name: str = Field(min_length=2, max_length=80, pattern=r"^[A-Za-z][A-Za-z\s'-]+$")


class UserLogin(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/models/customer.py" ]]; then
  cat >"$repo_path/src/$package_name/models/customer.py" <<'EOF'
from pydantic import BaseModel, Field


class CustomerResponse(BaseModel):
    id: int = Field(gt=0)
    first_name: str
    last_name: str
    address: str
    phone: str
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/services/auth_service.py" ]]; then
  cat >"$repo_path/src/$package_name/services/auth_service.py" <<EOF
from uuid import uuid4

from fastapi import HTTPException, status

from $package_name.core.config import Settings
from $package_name.core.security import (
    create_access_token,
    hash_password,
    validate_password_strength,
    verify_password,
)
from $package_name.models.auth import UserCreate, UserLogin


class AuthService:
    def __init__(self) -> None:
        self._users: dict[str, dict] = {}

    def seed_admin(self) -> None:
        if "admin@example.com" not in self._users:
            self._users["admin@example.com"] = {
                "id": str(uuid4()),
                "email": "admin@example.com",
                "full_name": "Admin User",
                "password_hash": hash_password("Admin123"),
                "role": "admin",
            }

    def register(self, payload: UserCreate) -> dict:
        validate_password_strength(payload.password)
        if payload.email in self._users:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Unable to process registration request.",
            )
        user = {
            "id": str(uuid4()),
            "email": payload.email,
            "full_name": payload.full_name,
            "password_hash": hash_password(payload.password),
            "role": "viewer",
        }
        self._users[payload.email] = user
        return user

    def login(self, payload: UserLogin, settings: Settings) -> str:
        user = self._users.get(payload.email)
        if not user or not verify_password(payload.password, user["password_hash"]):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials.",
            )
        return create_access_token(user["id"], user["role"], settings)

    def get_by_id(self, user_id: str) -> dict | None:
        for user in self._users.values():
            if user["id"] == user_id:
                return user
        return None
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/services/customer_service.py" ]]; then
  cat >"$repo_path/src/$package_name/services/customer_service.py" <<EOF
import sqlite3
from pathlib import Path

from faker import Faker
from fastapi import HTTPException, status

from $package_name.core.config import Settings


class CustomerService:
    def __init__(self, settings: Settings) -> None:
        self.db_path = Path(settings.database_path)
        self.db_path.parent.mkdir(parents=True, exist_ok=True)

    def _connect(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        return conn

    def initialize(self, reset: bool = False) -> None:
        with self._connect() as conn:
            cur = conn.cursor()
            cur.execute(
                """
                CREATE TABLE IF NOT EXISTS customers (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    first_name TEXT NOT NULL,
                    last_name TEXT NOT NULL,
                    address TEXT NOT NULL,
                    phone TEXT NOT NULL
                )
                """
            )
            if reset:
                cur.execute("DELETE FROM customers")
            count = cur.execute("SELECT COUNT(1) AS c FROM customers").fetchone()["c"]
            if count == 0:
                self._seed_customers(cur, count=100)
            conn.commit()

    def _seed_customers(self, cur: sqlite3.Cursor, count: int) -> None:
        fake = Faker("en_US")
        Faker.seed(42)
        for _ in range(count):
            cur.execute(
                "INSERT INTO customers (first_name, last_name, address, phone) VALUES (?, ?, ?, ?)",
                (
                    fake.first_name(),
                    fake.last_name(),
                    fake.address().replace("\n", ", "),
                    fake.phone_number(),
                ),
            )

    def list_customers(self, limit: int = 20, offset: int = 0) -> list[dict]:
        with self._connect() as conn:
            rows = conn.execute(
                "SELECT id, first_name, last_name, address, phone FROM customers ORDER BY id LIMIT ? OFFSET ?",
                (limit, offset),
            ).fetchall()
            return [dict(row) for row in rows]

    def get_customer(self, customer_id: int) -> dict:
        with self._connect() as conn:
            row = conn.execute(
                "SELECT id, first_name, last_name, address, phone FROM customers WHERE id = ?",
                (customer_id,),
            ).fetchone()
        if not row:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found.")
        return dict(row)
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/api/deps.py" ]]; then
  cat >"$repo_path/src/$package_name/api/deps.py" <<EOF
from collections.abc import Callable

from fastapi import Depends, Header, HTTPException, status

from $package_name.core.config import Settings, get_settings
from $package_name.core.security import decode_token
from $package_name.services.auth_service import AuthService
from $package_name.services.customer_service import CustomerService


auth_service = AuthService()
auth_service.seed_admin()


def get_auth_service() -> AuthService:
    return auth_service


def get_customer_service(settings: Settings = Depends(get_settings)) -> CustomerService:
    service = CustomerService(settings)
    service.initialize()
    return service


def get_current_user(
    authorization: str = Header(default=""),
    settings: Settings = Depends(get_settings),
    service: AuthService = Depends(get_auth_service),
) -> dict:
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing bearer token.")
    token = authorization.split(" ", 1)[1]
    payload = decode_token(token, settings)
    user = service.get_by_id(payload.subject)
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found.")
    return user


def require_roles(allowed_roles: set[str]) -> Callable:
    def _dep(user: dict = Depends(get_current_user)) -> dict:
        if user["role"] not in allowed_roles:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied.")
        return user

    return _dep
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/api/routes/__init__.py" ]]; then
  echo '"""API routes."""' >"$repo_path/src/$package_name/api/routes/__init__.py"
fi

if [[ ! -f "$repo_path/src/$package_name/api/routes/auth.py" ]]; then
  cat >"$repo_path/src/$package_name/api/routes/auth.py" <<EOF
from fastapi import APIRouter, Depends, Request

from $package_name.api.deps import get_auth_service
from $package_name.core.config import Settings, get_settings
from $package_name.core.rate_limit import limiter
from $package_name.models.auth import TokenResponse, UserCreate, UserLogin
from $package_name.services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register")
@limiter.limit(lambda: get_settings().rate_limit_auth)
def register(
    request: Request,
    payload: UserCreate,
    service: AuthService = Depends(get_auth_service),
) -> dict:
    user = service.register(payload)
    return {
        "id": user["id"],
        "email": user["email"],
        "full_name": user["full_name"],
        "role": user["role"],
    }


@router.post("/login", response_model=TokenResponse)
@limiter.limit(lambda: get_settings().rate_limit_auth)
def login(
    request: Request,
    payload: UserLogin,
    settings: Settings = Depends(get_settings),
    service: AuthService = Depends(get_auth_service),
) -> TokenResponse:
    token = service.login(payload, settings)
    return TokenResponse(access_token=token)
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/api/routes/customers.py" ]]; then
  cat >"$repo_path/src/$package_name/api/routes/customers.py" <<EOF
from fastapi import APIRouter, Depends, Query, Request

from $package_name.api.deps import get_customer_service, require_roles
from $package_name.core.config import get_settings
from $package_name.core.rate_limit import limiter
from $package_name.models.customer import CustomerResponse
from $package_name.services.customer_service import CustomerService

router = APIRouter(prefix="/customers", tags=["customers"])


@router.get("", response_model=list[CustomerResponse])
@limiter.limit(lambda: get_settings().rate_limit_general)
def list_customers(
    request: Request,
    limit: int = Query(default=20, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    _user: dict = Depends(require_roles({"viewer", "member", "admin"})),
    service: CustomerService = Depends(get_customer_service),
) -> list[CustomerResponse]:
    return [CustomerResponse(**row) for row in service.list_customers(limit=limit, offset=offset)]


@router.get("/{customer_id}", response_model=CustomerResponse)
@limiter.limit(lambda: get_settings().rate_limit_general)
def get_customer(
    request: Request,
    customer_id: int,
    _user: dict = Depends(require_roles({"viewer", "member", "admin"})),
    service: CustomerService = Depends(get_customer_service),
) -> CustomerResponse:
    return CustomerResponse(**service.get_customer(customer_id))
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/main.py" ]]; then
  cat >"$repo_path/src/$package_name/main.py" <<EOF
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

import yaml
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.responses import PlainTextResponse
from prometheus_fastapi_instrumentator import Instrumentator
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded

from $package_name.api.routes import auth, customers
from $package_name.core.config import get_settings
from $package_name.core.logging import configure_logging, request_logging_middleware
from $package_name.core.rate_limit import limiter
from $package_name.core.telemetry import configure_tracing
from $package_name.services.customer_service import CustomerService

settings = get_settings()
configure_logging()


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    CustomerService(settings).initialize()
    yield


app = FastAPI(
    title=settings.app_name,
    docs_url="/docs" if settings.debug else None,
    redoc_url="/redoc" if settings.debug else None,
    lifespan=lifespan,
)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

app.add_middleware(TrustedHostMiddleware, allowed_hosts=settings.allowed_host_list)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origin_list,
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Authorization", "Content-Type"],
)

app.middleware("http")(request_logging_middleware)


@app.middleware("http")
async def security_headers_middleware(request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["Cache-Control"] = "no-store"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    return response


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/openapi.yaml", include_in_schema=False)
def openapi_yaml() -> PlainTextResponse:
    return PlainTextResponse(yaml.safe_dump(app.openapi(), sort_keys=False), media_type="application/yaml")


app.include_router(auth.router)
app.include_router(customers.router)

Instrumentator().instrument(app).expose(app, endpoint="/metrics", include_in_schema=settings.debug)
configure_tracing(app, settings)
EOF
fi

if [[ ! -f "$repo_path/tests/conftest.py" ]]; then
  cat >"$repo_path/tests/conftest.py" <<EOF
from collections.abc import Generator
from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from $package_name.api.deps import auth_service
from $package_name.core.config import get_settings
from $package_name.main import app
from $package_name.services.customer_service import CustomerService


@pytest.fixture(autouse=True)
def reset_state(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Generator[None, None, None]:
    monkeypatch.setenv("DATABASE_PATH", str(tmp_path / "test.db"))
    monkeypatch.setenv("JWT_SECRET_KEY", "0123456789abcdef0123456789abcdef")
    get_settings.cache_clear()
    auth_service._users.clear()
    auth_service.seed_admin()
    CustomerService(get_settings()).initialize(reset=True)
    yield
    get_settings.cache_clear()


@pytest.fixture
def client() -> TestClient:
    return TestClient(app, raise_server_exceptions=False)


def register_and_login(client: TestClient, email: str, password: str, full_name: str) -> str:
    client.post(
        "/auth/register",
        json={"email": email, "password": password, "full_name": full_name},
    )
    response = client.post("/auth/login", json={"email": email, "password": password})
    return response.json()["access_token"]
EOF
fi

if [[ ! -f "$repo_path/tests/__init__.py" ]]; then
    echo '"""Test package."""' >"$repo_path/tests/__init__.py"
fi

if [[ ! -f "$repo_path/tests/test_auth_and_rbac.py" ]]; then
  cat >"$repo_path/tests/test_auth_and_rbac.py" <<'EOF'
from fastapi.testclient import TestClient

from tests.conftest import register_and_login


def test_register_login_and_customer_access(client: TestClient) -> None:
    token = register_and_login(client, "person@example.com", "Strong123", "Person Example")
    response = client.get("/customers", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 200
    payload = response.json()
    assert len(payload) > 0
    assert {"id", "first_name", "last_name", "address", "phone"} <= set(payload[0])


def test_missing_token_is_rejected(client: TestClient) -> None:
    response = client.get("/customers")
    assert response.status_code == 401


def test_admin_can_access_customer_detail(client: TestClient) -> None:
    response = client.post(
        "/auth/login",
        json={"email": "admin@example.com", "password": "Admin123"},
    )
    token = response.json()["access_token"]
    customer = client.get("/customers/1", headers={"Authorization": f"Bearer {token}"})
    assert customer.status_code == 200
    assert customer.json()["id"] == 1
EOF
fi

if [[ ! -f "$repo_path/tests/test_openapi_and_swagger.py" ]]; then
  cat >"$repo_path/tests/test_openapi_and_swagger.py" <<'EOF'
import yaml


def test_openapi_json_and_docs(client) -> None:
    openapi = client.get("/openapi.json")
    assert openapi.status_code == 200
    payload = openapi.json()
    assert "/customers" in payload["paths"]
    assert "/auth/login" in payload["paths"]

    docs = client.get("/docs")
    assert docs.status_code == 200


def test_openapi_yaml_endpoint(client) -> None:
    response = client.get("/openapi.yaml")
    assert response.status_code == 200
    spec = yaml.safe_load(response.text)
    assert "/customers/{customer_id}" in spec["paths"]
EOF
fi

if [[ ! -f "$repo_path/tests/test_rate_limit.py" ]]; then
  cat >"$repo_path/tests/test_rate_limit.py" <<'EOF'
def test_rate_limit_login(client) -> None:
    last = None
    for _ in range(11):
        last = client.post("/auth/login", json={"email": "none@example.com", "password": "Strong123"})
    assert last is not None
    assert last.status_code == 429
EOF
fi

"$script_dir/sync_guidance_files.sh" python "$repo_path" "$agents_root" copy

echo "Created enterprise FastAPI service scaffold at: $repo_path"
echo "Guidance files copied into: $repo_path/.github"