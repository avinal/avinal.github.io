.PHONY: dev build preview clean install check fmt lint new-post help

# Default target
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	npm install

dev: ## Start dev server with hot reload
	npx astro dev

build: ## Build for production
	npx astro build

preview: ## Preview production build locally
	npx astro preview

check: ## Run Astro type checking
	npx astro check

clean: ## Remove build artifacts
	rm -rf dist .astro node_modules/.astro

nuke: ## Full clean (includes node_modules)
	rm -rf dist .astro node_modules

fresh: nuke install ## Clean install from scratch
