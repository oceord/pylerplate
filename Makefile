# Makefile to gather common commands

.PHONY: build bump clean format help lint nox print-phony set-up-git-hooks test
.DEFAULT_GOAL := help

# Fetch from git tags the current dev version string, if not found use seconds since epoch
TAG := $(shell git describe --tags --always --dirty --broken 2>/dev/null || date +%s)

help: ## Show this help menu
	$(info Available make commands:)
	@grep -e '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "\t%-23s %s\n", $$1, $$2};'

print-phony:
	@echo -n "\n.PHONY: "
	@grep '^[a-z|_|-]*:.*' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.*"}; {printf "%s ", $$1};'
	@echo "\n"

set-up-git-hooks: ## Set up git hooks
	@mkdir -p .git/hooks
	@cp .githooks/* .git/hooks

####### COMMANDS #######################################################################

build: ## Build a distribution for the package
	$(info Building distribution artifacts...)
	@uv build
	@echo Done.

clean: ## Clean up auxiliary and temporary files from the workspace
	$(info Cleaning auxiliary and temporary files...)
	@find . -maxdepth 1 -type d -name '.mypy_cache' -exec rm -r {} +
	@find . -maxdepth 1 -type d -name '.ruff_cache' -exec rm -r {} +
	@find . -maxdepth 1 -type d -name 'build'       -exec rm -r {} +
	@find . -maxdepth 1 -type d -name 'dist'        -exec rm -r {} +
	@find . -maxdepth 2 -type d -name '*.egg-info'  -exec rm -r {} +
	@echo Done.

format: ## Format the entire codebase
	@echo Applying ruff... && \
	ruff format && \
	echo Done. ;

lint: ## Perform a static code analysis
	@echo Linting source-code... && \
	echo Applying ruff... && \
	ruff check && \
	echo Applying pyrefly... && \
	pyrefly check && \
	echo Done. ; \

nox: ## Run nox tests
	@echo Running nox tests... && \
	nox --default-venv-backend uv

test: nox ## Run tests

bump: ## Bump package version
	@echo TODO: Not Implemented; exit 1;
