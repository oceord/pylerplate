# Makefile to gather common commands

.PHONY: build check clean docker-build-dev docker-build-prod docker-open-shell docker-run-dev docker-scan docker-test format help lint pipenv-dev-install run-dev run-prod test version
.DEFAULT_GOAL := help

# Project variables
MODULE:=mypackage
SRC:=src/$(MODULE)

# Command overrides
# In docker-related commands, provide DOCKER=podman to use podman instead of docker
DOCKER:=docker

# Fetch from git tags the current dev version string, if not found use seconds since epoch
TAG := $(shell git describe --tags --always --dirty --broken 2>/dev/null || date +%s)

help: ## Show this help menu
	$(info Available make commands:)
	@grep -e '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "\t%-23s %s\n", $$1, $$2};'

.print-phony:
	@echo -n "\n.PHONY: "
	@grep '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "%s ", $$1};'
	@echo "\n"

####### COMMANDS #######################################################################

build: ## Build a distribution for the package
	$(info Building distribution artifacts...)
	@python -m build --wheel
	@echo Done.

check: ## Check source-code for known security vulnerabilities
	$(info Checking code for known security vulnerabilities...)
	@pipenv check
	@echo Done.

clean: ## Clean up auxiliary and temporary files from the workspace
	$(info Cleaning auxiliary and temporary files...)
	@find . -maxdepth 1 -type d -name '.mypy_cache' -exec rm -r {} +
	@find . -maxdepth 1 -type d -name '.ruff_cache' -exec rm -r {} +
	@find . -maxdepth 1 -type d -name 'build'       -exec rm -r {} +
	@find . -maxdepth 1 -type d -name 'dist'        -exec rm -r {} +
	@find . -maxdepth 2 -type d -name '*.egg-info'  -exec rm -r {} +
	@echo Done.

docker-build-dev: ## Build a docker dev image. Example: make docker-build-dev VERSION=1.0.0
	$(if $(VERSION),,$(error VERSION is undefined.))
	$(info Building dev image '$(MODULE):$(VERSION)'...)
	@sed \
		-e 's|{NAME}|$(MODULE)|g' \
		-e 's|{VERSION}|$(VERSION)|g' \
		Dockerfile | \
		$(DOCKER) build -t $(MODULE):$(VERSION) --target dev -f- .
	@echo Done.

docker-build-prod: ## Build a docker prod image. Example: make docker-build-prod VERSION=1.0.0
	$(if $(VERSION),,$(error VERSION is undefined.))
	$(info Building prod image '$(MODULE)-prod:$(VERSION)'...)
	@sed \
		-e 's|{NAME}|$(MODULE)|g' \
		-e 's|{VERSION}|$(VERSION)|g' \
		Dockerfile | \
		$(DOCKER) build -t $(MODULE)-prod:$(VERSION) --target prod -f- .
	@echo Done.

docker-test: ## Test project in a docker image
	$(info Building and running test image '$(MODULE):$(TAG)'...)
	@sed \
		-e 's|{NAME}|$(MODULE)|g' \
		-e 's|{VERSION}|$(TAG)|g' \
		Dockerfile | \
		$(DOCKER) build -t $(MODULE):$(TAG) --target test -f- .
	@echo Done.

format: ## Format the entire codebase
	@if \
	type ruff >/dev/null 2>&1 ; then \
		echo Formatting source-code... && \
		echo Applying ruff... && \
		ruff format $(SRC) tests && \
		echo Done. ; \
	else echo "SKIPPED (ruff not found)" >&2 ; fi

lint: ## Perform a static code analysis
	@if \
	type ruff >/dev/null 2>&1 && \
	type mypy >/dev/null 2>&1 ; then \
		echo Linting source-code... && \
		echo Applying ruff... && \
		ruff check $(SRC) tests && \
		echo Applying mypy... && \
		mypy --show-error-context --show-column-numbers --pretty $(SRC) tests && \
		echo Done. ; \
	else echo "SKIPPED (ruff and/or mypy not found)" >&2 ; fi

pipenv-dev-install: ## Create dev venv
	@PIPENV_VERBOSITY=-1 pipenv run pip install --upgrade pip
	@if [ -f "Pipfile.lock" ]; then \
		PIPENV_VERBOSITY=-1 pipenv install --dev --ignore-pipfile --deploy; \
	else \
		PIPENV_VERBOSITY=-1 pipenv install --dev; \
	fi

run-dev: ## Run for a dev env
	@echo TODO: Not Implemented; exit 1;

run-prod: ## Run for a prod environment with the necessary precautions (e.g., no debug)
	@echo TODO: Not Implemented; exit 1;

test: ## Perform tests
	@echo TODO: Not Implemented; exit 1;

version: ## Display current dev version
	@echo Version: $(TAG)
