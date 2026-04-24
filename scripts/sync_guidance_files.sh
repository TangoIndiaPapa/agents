#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  sync_guidance_files.sh <language> <target-repo-or-github-dir> [agents-root] [mode]

Modes:
  copy    (default) copy guidance files into target .github
  symlink create/update symlinks in target .github

Examples:
  ./scripts/sync_guidance_files.sh python /workspaces/agent-python-test-2
  ./scripts/sync_guidance_files.sh python /workspaces/agent-python-test-2 /workspaces/agents copy
  ./scripts/sync_guidance_files.sh python /workspaces/agent-python-test-2/.github /workspaces/agents symlink
EOF
}

if [[ $# -lt 2 || $# -gt 4 ]]; then
  usage
  exit 1
fi

language="$1"
target_path="$2"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_agents_root="$(cd "${script_dir}/.." && pwd)"

agents_root="$default_agents_root"
mode="copy"

if [[ $# -ge 3 ]]; then
  if [[ "$3" == "copy" || "$3" == "symlink" ]]; then
    mode="$3"
  else
    agents_root="$3"
  fi
fi

if [[ $# -eq 4 ]]; then
  mode="$4"
fi

if [[ "$mode" != "copy" && "$mode" != "symlink" ]]; then
  echo "Invalid mode '$mode'. Use copy or symlink." >&2
  exit 1
fi

if [[ ! -d "$target_path" ]]; then
  echo "Target path not found: $target_path" >&2
  exit 1
fi

src_language_root="$agents_root/config/$language"
src_instructions_dir="$src_language_root/instructions"
src_prompts_dir="$src_language_root/prompts"

if [[ ! -d "$src_language_root" ]]; then
  echo "Language config not found: $src_language_root" >&2
  exit 1
fi

if [[ "$(basename "$target_path")" == ".github" ]]; then
  dst_github_dir="$target_path"
else
  dst_github_dir="$target_path/.github"
fi

dst_instructions_dir="$dst_github_dir/instructions"
dst_prompts_dir="$dst_github_dir/prompts"
mkdir -p "$dst_instructions_dir" "$dst_prompts_dir"

synced_count=0
shopt -s nullglob

sync_item() {
  local src="$1"
  local dst="$2"
  if [[ "$mode" == "symlink" ]]; then
    ln -sfn "$src" "$dst"
    echo "Linked: $dst -> $src"
  else
    cp -f "$src" "$dst"
    echo "Copied: $src -> $dst"
  fi
}

for src in "$src_instructions_dir"/*.md; do
  src_name="$(basename "$src")"
  if [[ "$src_name" == *.instructions.md ]]; then
    dst_name="$src_name"
  elif [[ "$src_name" == *-instructions.md ]]; then
    dst_name="${src_name%-instructions.md}.instructions.md"
  else
    dst_name="${src_name%.md}.instructions.md"
  fi
  dst="$dst_instructions_dir/$dst_name"
  sync_item "$src" "$dst"
  synced_count=$((synced_count + 1))
done

for src in "$src_prompts_dir"/*.md; do
  src_name="$(basename "$src")"
  if [[ "$src_name" == *.prompt.md ]]; then
    dst_name="$src_name"
  else
    dst_name="${src_name%.md}.prompt.md"
  fi
  dst="$dst_prompts_dir/$dst_name"
  sync_item "$src" "$dst"
  synced_count=$((synced_count + 1))
done

shopt -u nullglob

if [[ $synced_count -eq 0 ]]; then
  echo "No guidance files found under: $src_language_root" >&2
  exit 1
fi

echo "Guidance sync completed for language '$language' into: $dst_github_dir (mode=$mode)"