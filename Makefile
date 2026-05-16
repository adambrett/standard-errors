export

VERBOSE ?= false
ifeq (${VERBOSE}, false)
	MAKEFLAGS += --silent
endif

SHELL := /bin/bash -o errexit -o nounset -o pipefail

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Variables
HUGO             ?= hugo
HUGO_CACHEDIR    ?= $(CURDIR)/.hugo_cache
HUGO_ENVIRONMENT ?= production
PUBLIC_DIR       := public

# Helpers

.PHONY: run
run: ## Start Hugo dev server with drafts
	$(HUGO) server -D --disableFastRender

# Dependencies

.PHONY: deps
deps: ## Check required tools are available
	command -v $(HUGO) >/dev/null || { echo "hugo not found"; exit 1; }
	$(HUGO) version

# Linting

.PHONY: lint
lint: lint-hugo ## Run all lints

.PHONY: lint-hugo
lint-hugo: ## Hugo template warnings
	$(HUGO) --gc --printPathWarnings --printUnusedTemplates

# Testing

.PHONY: test
test: ## Strict build. CI should run this.
	$(HUGO) --gc --minify --printPathWarnings

# Building

.PHONY: build
build: ## Build the production site into ./public
	$(HUGO) --gc --minify

# Cleaning

.PHONY: clean
clean: ## Remove build artifacts and caches
	rm -rf $(PUBLIC_DIR) resources .hugo_cache .hugo_build.lock

# Make

.PHONY: help
help: ## Show this help
	awk 'BEGIN {FS = ":.*##" } /^[a-zA-Z_-]+:.*?##/ { printf "\033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
