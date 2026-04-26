#!/usr/bin/env python3
"""Enforce .agent-state updates for autonomous plan runs.

This hook stores a start-of-session git status snapshot and, on session end,
blocks completion when non-.agent-state files changed but .agent-state artifacts
did not change in the same run.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any

SNAPSHOT_FILE = ".git/.agent_state_hook_snapshot.json"


def _load_hook_payload() -> dict[str, Any]:
    raw = sys.stdin.read().strip()
    if not raw:
        return {}
    try:
        data = json.loads(raw)
        return data if isinstance(data, dict) else {}
    except json.JSONDecodeError:
        return {}


def _print_json(payload: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(payload))


def _git(cmd: list[str], cwd: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *cmd],
        cwd=cwd,
        text=True,
        capture_output=True,
        check=False,
    )


def _resolve_repo_root(cwd: str) -> str | None:
    probe = _git(["rev-parse", "--show-toplevel"], cwd)
    if probe.returncode != 0:
        return None
    return probe.stdout.strip() or None


def _status_paths(repo_root: str) -> set[str]:
    status = _git(["status", "--porcelain"], repo_root)
    if status.returncode != 0:
        return set()

    paths: set[str] = set()
    for line in status.stdout.splitlines():
        if len(line) < 4:
            continue
        path = line[3:].strip()
        if " -> " in path:
            path = path.split(" -> ", 1)[1].strip()
        if path:
            paths.add(path)
    return paths


def _save_snapshot(repo_root: str, paths: set[str]) -> None:
    data = {"start_paths": sorted(paths)}
    Path(repo_root, SNAPSHOT_FILE).write_text(json.dumps(data, indent=2), encoding="utf-8")


def _load_snapshot(repo_root: str) -> set[str]:
    snapshot_path = Path(repo_root, SNAPSHOT_FILE)
    if not snapshot_path.exists():
        return set()
    try:
        data = json.loads(snapshot_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return set()
    paths = data.get("start_paths", [])
    if not isinstance(paths, list):
        return set()
    return {str(path) for path in paths}


def _is_agent_state_path(path: str) -> bool:
    return path == ".agent-state" or path.startswith(".agent-state/")


def _allow(message: str) -> int:
    _print_json({"continue": True, "systemMessage": message})
    return 0


def _deny(message: str) -> int:
    _print_json({"continue": False, "stopReason": message, "systemMessage": message})
    return 2


def main() -> int:
    mode = os.environ.get("AGENT_STATE_HOOK_MODE", "").strip().lower()
    payload = _load_hook_payload()
    cwd = str(payload.get("cwd") or os.getcwd())
    repo_root = _resolve_repo_root(cwd)

    if repo_root is None:
        return _allow("No git repository detected; skipping .agent-state enforcement.")

    if mode == "start":
        _save_snapshot(repo_root, _status_paths(repo_root))
        return _allow("Captured start-of-session git snapshot for .agent-state enforcement.")

    if mode == "stop":
        start_paths = _load_snapshot(repo_root)
        current_paths = _status_paths(repo_root)
        delta_paths = current_paths - start_paths

        delta_state = sorted(path for path in delta_paths if _is_agent_state_path(path))
        delta_non_state = sorted(path for path in delta_paths if not _is_agent_state_path(path))

        if delta_non_state and not delta_state:
            details = ", ".join(delta_non_state[:8])
            message = (
                "Blocked: run changed non-.agent-state files but did not update .agent-state artifacts. "
                f"Changed: {details}"
            )
            return _deny(message)

        return _allow(".agent-state enforcement passed.")

    return _allow("Unknown hook mode; skipping .agent-state enforcement.")


if __name__ == "__main__":
    raise SystemExit(main())
