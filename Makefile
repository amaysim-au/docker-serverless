SERVERLESS_VERSION = 1.14.0
IMAGE_NAME ?= aws-serverless:$(SERVERLESS_VERSION)
TAG = $(SERVERLESS_VERSION)

dockerBuild:
	docker build -t $(IMAGE_NAME) .
.PHONY: dockerBuild

dockerShell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) bash
.PHONY: dockerShell

gitTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
.PHONY: gitTag