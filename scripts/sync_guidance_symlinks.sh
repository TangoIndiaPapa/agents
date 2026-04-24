#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -lt 2 || $# -gt 3 ]]; then
  cat <<'EOF'
Usage:
  sync_guidance_symlinks.sh <language> <target-repo-or-github-dir> [agents-root]

This is a compatibility wrapper around:
  sync_guidance_files.sh <language> <target> [agents-root] symlink
EOF
  exit 1
fi

language="$1"
target="$2"

if [[ $# -eq 3 ]]; then
  agents_root="$3"
  "$script_dir/sync_guidance_files.sh" "$language" "$target" "$agents_root" symlink
else
  "$script_dir/sync_guidance_files.sh" "$language" "$target" symlink
fi