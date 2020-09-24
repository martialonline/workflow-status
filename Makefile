VERSION ?= latest
TAG ?= $(VERSION)
PREFIX ?= workflow-status

GIT_COMMIT = $(shell git rev-parse --short HEAD)

export DOCKER_BUILDKIT = 1

test: test.shell

test.shell:
	shellcheck entrypoint.sh

build.docker:
	docker build -t $(PREFIX):$(TAG) .

clean:
	docker stop ${PREFIX}:${TAG} || true
	docker rmi -f ${PREFIX}:${TAG} || true
	docker rmi -f $(docker images -q -f dangling=true) || true