# Makefile to gather common commands

.PHONY: build bump check dev format help hooks nox phony prune test
.DEFAULT_GOAL := help

# Fetch from git tags the current dev version string, if not found use seconds since epoch
TAG := $(shell git describe --tags --always --dirty --broken 2>/dev/null || date +%s)

help: ## Show this menu
	@echo "Available commands:"
	@grep -e '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "\t%-10s %s\n", $$1, $$2};'

phony: ## Update .PHONY
	@TARGETS=$$(grep -E '^[a-z|_|-]+:.*##' $(MAKEFILE_LIST) | cut -d: -f1 | sort | xargs); \
	sed -i "s/^\.PHONY: .*/.PHONY: $$TARGETS/" $(MAKEFILE_LIST)
	@echo "Successfully updated .PHONY line."

####### COMMANDS #######################################################################

dev: hooks ## Initialize local development
	@echo "Syncing environment..." && \
	uv sync && \
	echo "Environment ready."

hooks: ## Install git hooks
	@echo "Setting up pre-commit hooks..." && \
	uvx pre-commit install && \
	echo "Done."

build: ## Build distribution artifacts
	@echo "Building distribution artifacts..." && \
	uv build && \
	echo "Done."

prune: ## Clean workspace
	@echo "Cleaning workspace..." && \
	bash scripts/prune.sh && \
	echo "Done."

format: ## Format source code
	@echo "Applying ruff format..." && \
	uvx ruff format && \
	echo "Done."

check: ## Lint and static analysis
	@echo "Running static analysis (Ruff & Pyrefly)..." && \
	uvx ruff check && \
	uvx pyrefly check && \
	echo "Analysis complete."

nox: ## Run full test matrix
	@echo "Running nox tests..." && \
	uvx nox --default-venv-backend uv

test: nox ## Run tests

bump: ## Bump package version
	@echo "TODO: Not Implemented"; exit 1
