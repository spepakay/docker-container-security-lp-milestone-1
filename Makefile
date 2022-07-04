default: build

build: Dockerfile
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder

website: build
	@echo "Stopping stale container..."
	- @docker container rm hugo-website -f
	@echo "Building website..."
	@docker container run --rm -it -v ${PWD}/orgdocs:/src lp/hugo-builder hugo
	##@echo "Starting website..."
	#@docker container run -d --name hugo-website -p 1313:1313 -v /Users/spepakay/work/manning/docker-container-security-lp/orgdocs:/src lp/hugo-builder /bin/sh -c "hugo && hugo serve -w --bind=0.0.0.0"

webserver: website
	@echo "Starting webserver..."
	@docker container run --rm -d --name hugo-website -p 1313:1313 -v ${PWD}/orgdocs:/src lp/hugo-builder hugo serve -w --bind=0.0.0.0

lint: Dockerfile
	@echo "Linting Dockerfile..."
	@docker run --rm -i -v ${PWD}:/src ghcr.io/hadolint/hadolint hadolint --ignore DL3018 /src/Dockerfile

.PHONY: build webserver website lint
