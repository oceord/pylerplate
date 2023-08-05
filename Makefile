# Makefile to gather common commands

.PHONY: build check clean docker-build-dev docker-build-prod docker-open-shell docker-run-dev docker-scan docker-test format help lint pipenv-dev-install run-dev run-prod test version
.DEFAULT_GOAL := help

# Project variables
MODULE:=mypackage
SRC:=src/$(MODULE)

# Command overrides
DOCKER:=docker

# Fetch from git tags the current dev version string, if not found use seconds since epoch
TAG := $(shell git describe --tags --always --dirty --broken 2>/dev/null || date +%s)

help: ## Show this help menu
	$(info Available make commands:)
	@grep -e '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "\t%-23s %s\n", $$1, $$2};'

.print-phony:
	@echo -en "\n.PHONY: "
	@grep -e '^[a-z|_|-]*:.* ##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS=":.* ## "}; {printf "%s ", $$1};'
	@echo -e "\n"

####### COMMANDS #######################################################################

build: ## Build a distribution for the package
	$(info Checking code for known security vulnerabilities...)
	@python -m build --wheel
	@echo Done.

check: ## Check source-code for known security vulnerabilities
	$(info Checking code for known security vulnerabilities...)
	@pipenv check
	@echo Done.

clean: ## Clean up auxiliary and temporary files from the workspace
	$(info Cleaning aux and temp files...)
	@find . -maxdepth 1 -type d -name '.mypy_cache' -exec rm -r {} +
	@find . -maxdepth 1 -type d -name '.ruff_cache' -exec rm -r {} +
	@find . -maxdepth 1 -type d -name 'build'       -exec rm -r {} +
	@find . -maxdepth 1 -type d -name 'dist'        -exec rm -r {} +
	@find . -maxdepth 2 -type d -name '*.egg-info'  -exec rm -r {} +
#	@find .             -type f -name '*.py[cod]'   -delete
	@echo Done.

# NOTE: provide DOCKER=podman to use podman instead of docker
docker-build-dev: ## Build a docker dev image. Example: make docker-build-dev VERSION=1.0.0
	$(if $(VERSION),,$(error VERSION is undefined.))
	$(info Building dev image '$(MODULE):$(VERSION)'...)
	@sed \
		-e 's|{NAME}|$(MODULE)|g' \
		-e 's|{VERSION}|$(VERSION)|g' \
		Dockerfile | \
		$(DOCKER) build -t $(MODULE):$(VERSION) --target dev -f- .
	@echo Done.

# NOTE: provide DOCKER=podman to use podman instead of docker
docker-build-prod: ## Build a docker prod image. Example: make docker-build-prod VERSION=1.0.0
	$(if $(VERSION),,$(error VERSION is undefined.))
	$(info Building prod image '$(MODULE)-prod:$(VERSION)'...)
	@sed \
		-e 's|{NAME}|$(MODULE)|g' \
		-e 's|{VERSION}|$(VERSION)|g' \
		Dockerfile | \
		$(DOCKER) build -t $(MODULE)-prod:$(VERSION) --target prod -f- .
	@echo Done.

# NOTE: provide DOCKER=podman to use podman instead of docker
docker-open-shell: ## Open a shell inside a container. Example: make docker-open-shell VERSION=1.0.0
	$(if $(VERSION),,$(error VERSION is undefined.))
	$(info Cleaning aux and temp files...)
	@$(DOCKER) run -it --rm $(MODULE):$(VERSION) /bin/bash
	@echo Done.

# NOTE: provide DOCKER=podman to use podman instead of docker
docker-run-dev: ## Run dev image. Example: make docker-run VERSION=1.0.0
	$(if $(VERSION),,$(error VERSION is undefined.))
	@echo Running dev image...
	@$(DOCKER) run $(MODULE):$(VERSION)
	@echo Done.

# NOTE: provide DOCKER=podman to use podman instead of docker
docker-scan: ## Scan dev image for vulnerabilities. Example: make docker-scan VERSION=1.0.0 ENV=prod
	$(if $(VERSION),,$(error VERSION is undefined.))
	@echo Scanning dev image for known vulnerabilities...
	@$(DOCKER) scan $(MODULE)$(ENV):$(VERSION)
	@echo Done.

# NOTE: provide DOCKER=podman to use podman instead of docker
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
	type black >/dev/null 2>&1 ; then \
		echo Formatting source-code... && \
		echo Applying black... && \
		black $(SRC) tests && \
		echo Done. ; \
	else echo SKIPPED. Run 'make pipenv-dev-install' first. >&2 ; fi

lint: ## Perform a static code analysis
	@if \
	type ruff >/dev/null 2>&1 && \
	type mypy >/dev/null 2>&1 ; then \
		echo Linting source-code... && \
		echo Applying ruff... && \
		ruff $(SRC) tests && \
		echo Applying mypy... && \
		mypy --show-error-context --show-column-numbers --pretty $(SRC) tests && \
		echo Done. ; \
	else echo SKIPPED. Run 'make pipenv-dev-install' first. >&2 ; fi

pipenv-dev-install: ## Create dev venv
	@pipenv run pip install --upgrade pip
	@pipenv install --dev --ignore-pipfile --deploy

run-dev: ## Run for a dev env
	@echo TODO: Not Implemented; exit 1;

run-prod: ## Run for a prod environment with the necessary precautions (e.g., no debug)
	@echo TODO: Not Implemented; exit 1;

test: ## Perform tests
	@echo TODO: Not Implemented; exit 1;

version: ## Display current dev version
	@echo Version: $(TAG)
