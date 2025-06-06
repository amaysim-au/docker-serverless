NODE_ALPINE_IMAGE ?= node:22.16.0-alpine3.21
SERVERLESS_VERSION = 4.14.4
INTERNAL_VERSION = 2.0.0
INSTALL_YARN_BERRY ?= true

# Define a suffix based on INSTALL_YARN_BERRY
ifeq ($(INSTALL_YARN_BERRY),true)
    YARN_BERRY_SUFFIX :=
else
    YARN_BERRY_SUFFIX := -yarn-v1
endif

# SERVERLESS_VERSION ?= $(shell docker run --rm $(NODE_ALPINE_IMAGE) npm show serverless version)
TIMESTAMP = $(shell date +%y%m%d%H%M)  # Timestamp in YYMMDDHHMM format
IMAGE_NAME ?= amaysim/serverless
IMAGE = $(IMAGE_NAME):$(SERVERLESS_VERSION)-$(INTERNAL_VERSION)$(YARN_BERRY_SUFFIX)-$(TIMESTAMP)
ROOT_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

ciTest: deps info build buildMultiArch clean
ciDeploy: deps info buildMultiArchAndPush

info:
	$(info Node alpine image: $(NODE_ALPINE_IMAGE))
	$(info Serverless version: $(SERVERLESS_VERSION))
	$(info Image: $(IMAGE))

# Dependencies for the project such as Docker Node Alpine image
deps:
	$(info Pull latest version of $(NODE_ALPINE_IMAGE))
	docker pull $(NODE_ALPINE_IMAGE)

# Builds a new image targetting the host architecture
# See `buildMultiArch` and `buildMultiArchAndPush` for multi-arch
build: env-SERVERLESS_VERSION
	docker build --no-cache \
		--build-arg NODE_ALPINE_IMAGE=$(NODE_ALPINE_IMAGE) \
		--build-arg SERVERLESS_VERSION=$(SERVERLESS_VERSION) \
		--build-arg INSTALL_YARN_BERRY=$(INSTALL_YARN_BERRY) \
		-t $(IMAGE) .

# Builds targetting linux/amd64 and linux/arm64 using buildx
# It will store the result in cache
buildMultiArch: env-SERVERLESS_VERSION
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg NODE_ALPINE_IMAGE=$(NODE_ALPINE_IMAGE) \
		--build-arg SERVERLESS_VERSION=$(SERVERLESS_VERSION) \
		--build-arg INSTALL_YARN_BERRY=$(INSTALL_YARN_BERRY) \
		-t $(IMAGE) .

# Builds targetting linux/amd64 and linux/arm64 using buildx
# And it pushes the images using `--push` flag
buildMultiArchAndPush: env-SERVERLESS_VERSION env-DOCKER_USERNAME env-DOCKER_ACCESS_TOKEN
	@echo "$(DOCKER_ACCESS_TOKEN)" | docker login --username "$(DOCKER_USERNAME)" --password-stdin docker.io
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg NODE_ALPINE_IMAGE=$(NODE_ALPINE_IMAGE) \
		--build-arg SERVERLESS_VERSION=$(SERVERLESS_VERSION) \
		--build-arg INSTALL_YARN_BERRY=$(INSTALL_YARN_BERRY) \
		--push \
		-t $(IMAGE) .
	docker logout

push: env-DOCKER_USERNAME env-DOCKER_ACCESS_TOKEN
	@echo "$(DOCKER_ACCESS_TOKEN)" | docker login --username "$(DOCKER_USERNAME)" --password-stdin docker.io
	docker push $(IMAGE)
	docker logout

pull:
	docker pull $(IMAGE)

# Run the image in interactive mode
shell:
	docker run --rm -it -v $(ROOT_DIR):/opt/app $(IMAGE) bash

clean:
	docker rmi -f $(IMAGE)

env-%:
	$(info Check if $* is not empty)
	@docker run --rm -e ENV_VAR=$($*) $(NODE_ALPINE_IMAGE) sh -c '[ -z "$$ENV_VAR" ] && echo "Error: $* is empty" && exit 1 || exit 0'
