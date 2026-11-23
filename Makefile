.PHONY: help all shell python lint

help:  ## Show this help
	@grep -E '^[a-z]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  %-8s %s\n", $$1, $$2}'

all: shell python  ## Set up everything

shell:  ## Install brew packages, oh-my-zsh, vim-plug, tpm and link the dotfiles
	./scripts/setup-shell.sh

python:  ## Install Python dev tools with pipx
	./scripts/setup-python.sh

lint:  ## Run pre-commit on all files
	pre-commit run --all-files
