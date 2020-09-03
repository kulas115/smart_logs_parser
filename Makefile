project_name = logs_parser

build: ## Build Docker image
	@echo does nothing
	docker image build \
		-t $(project_name) \
		.

run_shell: build ## Run and enter the Docker container's shell
	docker container run \
		-it \
		-v $(PWD):/app \
		--rm \
		$(project_name) \
		/bin/sh

run_test: build ## Run rspec tests inside Docker container
	docker container run \
		-it \
		-v $(PWD):/app \
		--rm \
		$(project_name) \
		/bin/sh -c 'rspec'

run_parser: build  ## Run parser with required log path, eg. make run_parser ./webserver.log
	docker container run \
		-v $(PWD):/app \
		--rm \
		$(project_name) \
		/bin/sh -c 'bin/parser $(path)'

help: ## Show this help
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
