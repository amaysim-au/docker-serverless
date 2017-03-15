IMAGE_NAME ?= aws-serverless
SERVERLESS_VERSION = v1.9.0

dockerBuild:
	docker build -t $(IMAGE_NAME) .
.PHONY: dockerBuild

dockerShell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) bash
.PHONY: dockerShell

gitTag:
	-git tag -d $(SERVERLESS_VERSION)
	-git push origin :refs/tags/$(SERVERLESS_VERSION)
	git tag $(SERVERLESS_VERSION)
	git push origin $(SERVERLESS_VERSION)
.PHONY: gitTag