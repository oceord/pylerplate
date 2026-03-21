# Makefile to gather common commands

.PHONY: build bump clean format help lint nox print-phony test
.DEFAULT_GOAL := help

# Fetch from git tags the current dev version string, if not found use seconds since epoch
TAG := $(shell git describe --tags --always --dirty --broken 2>/dev/null || date +%s)

help: ## Show this help menu
	@Available make commands: && \
	grep -e '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "\t%-23s %s\n", $$1, $$2};'

print-phony:
	@echo -n "\n.PHONY: " && \
	grep '^[a-z|_|-]*:.*' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.*"}; {printf "%s ", $$1};' && \
	echo "\n"

####### COMMANDS #######################################################################

build: ## Build a distribution for the package
	@Building distribution artifacts... && \
	uv build && \
	echo Done.

clean: ## Clean up auxiliary and temporary files from the workspace
	@Cleaning auxiliary and temporary files... && \
	bash scripts/prune.sh && \
	echo Done.

format: ## Format the entire codebase
	@echo Applying ruff... && \
	uvx ruff format && \
	echo Done.

lint: ## Perform a static code analysis
	@echo Linting source-code... && \
	echo Applying ruff... && \
	uvx ruff check && \
	echo Applying pyrefly... && \
	uvx pyrefly check && \
	echo Done.

nox: ## Run nox tests
	@echo Running nox tests... && \
	uvx nox --default-venv-backend uv

test: nox ## Run tests

bump: ## Bump package version
	@echo TODO: Not Implemented; exit 1
