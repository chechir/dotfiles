#!/usr/bin/env bash
# Installs Python dev tools with pipx, each in its own isolated environment.
# These are the formatters and linters nvim calls. Safe to re-run; upgrades existing ones.
set -euo pipefail

TOOLS=(black isort flake8 mypy pre-commit sqlfluff ipython)

main() {
  require_pipx
  for tool in "${TOOLS[@]}"; do
    pipx upgrade "$tool" 2>/dev/null || pipx install "$tool"
  done
  echo
  echo "Done. Tools are in ~/.local/bin"
}

require_pipx() {
  if ! command -v pipx >/dev/null; then
    echo "pipx is required: run 'make shell' first, or 'brew install pipx'" >&2
    exit 1
  fi
}

main "$@"
