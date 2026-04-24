#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -lt 1 || $# -gt 2 ]]; then
  cat <<'EOF'
Usage:
  sync_python_guidance_symlinks.sh <target-repo-or-github-dir> [agents-root]

This is a compatibility wrapper around:
  sync_guidance_symlinks.sh python <target> [agents-root]
EOF
  exit 1
fi

target="$1"
if [[ $# -eq 2 ]]; then
  agents_root="$2"
  "$script_dir/sync_guidance_symlinks.sh" python "$target" "$agents_root"
else
  "$script_dir/sync_guidance_symlinks.sh" python "$target"
fi