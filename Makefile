SERVERLESS_VERSION = 1.15.3
IMAGE_NAME ?= amaysim/serverless:$(SERVERLESS_VERSION)
TAG = $(SERVERLESS_VERSION)

build:
	docker build -t $(IMAGE_NAME) .

shell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) bash

gitTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)