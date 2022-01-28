.PHONY: release
release: ## release docker image
	docker build -f internal/cgo.Dockerfile -t cgo:latest .
	docker tag cgo:latest luoxintt/cgo:latest
	docker push luoxintt/cgo:latest

.PHONY: build
build: ## build and move executable file to `ENPUTI_HOME`
	docker build -f internal/cgo.Dockerfile -t cgo:latest .

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

define print-target
	@printf "Executing target: \033[36m$@\033[0m\n"
endef
