#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <session-id> [workspaceStorageId] [out-file] [declared-model]" >&2
  echo "Example: $0 4a7dcb5e-d16b-4413-802c-b2d598e0edda 5f7c32407707cabaaa8911621f5390b4 .prompts/session-audit.md 'GPT-5.3-Codex'" >&2
  exit 1
fi

SID="$1"
WS_ID="${2:-5f7c32407707cabaaa8911621f5390b4}"
DECLARED_MODEL="${4:-unknown}"
BASE="/home/vscode/.vscode-server/data/User/workspaceStorage/${WS_ID}/GitHub.copilot-chat"
TRANSCRIPT="${BASE}/transcripts/${SID}.jsonl"
DEBUG_DIR="${BASE}/debug-logs/${SID}"
MAIN_JSONL="${DEBUG_DIR}/main.jsonl"
MODELS_JSON="${DEBUG_DIR}/models.json"
OUT="${3:-.prompts/session-audit-${SID}.md}"

if [[ ! -f "$TRANSCRIPT" ]]; then
  echo "Transcript not found: $TRANSCRIPT" >&2
  exit 2
fi

mkdir -p "$(dirname "$OUT")"

{
  echo "# AI Session Audit Export"
  echo
  echo "- Session ID: ${SID}"
  echo "- Exported At (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- Declared Model: ${DECLARED_MODEL}"
  echo "- Workspace Storage ID: ${WS_ID}"
  echo "- Transcript File: ${TRANSCRIPT}"
  echo "- Debug Log Dir: ${DEBUG_DIR}"
  echo
  echo "## Session Start"
  grep '"type":"session.start"' "$TRANSCRIPT" | sed -n '1,1p' || true
  echo
  echo "## Copilot Extension Session Metadata"
  if [[ -f "$MAIN_JSONL" ]]; then
    sed -n '1,5p' "$MAIN_JSONL"
  else
    echo "main.jsonl not found"
  fi
  echo
  echo "## Model Catalog Snapshot"
  if [[ -f "$MODELS_JSON" ]]; then
    echo "Stored model catalog file: $MODELS_JSON"
    echo "First 120 lines:"
    sed -n '1,120p' "$MODELS_JSON"
  else
    echo "models.json not found"
  fi
  echo
  echo "## Tool Calls (execution_start events)"
  grep '"type":"tool.execution_start"' "$TRANSCRIPT" || true
  echo
  echo "## Tool Results (execution_end events)"
  grep '"type":"tool.execution_end"' "$TRANSCRIPT" || true
  echo
  echo "## User Messages"
  grep '"type":"user.message"' "$TRANSCRIPT" || true
  echo
  echo "## Assistant Messages"
  grep '"type":"assistant.message"' "$TRANSCRIPT" || true
} > "$OUT"

echo "Wrote: $OUT"
