IMAGE_NAME ?= aws-serverless
SERVERLESS_VERSION = v1.7.0

dockerBuild:
	docker build -t $(IMAGE_NAME) .
.PHONY: docker-build

dockerShell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) bash
.PHONY: docker-shell

gitTag:
	-git tag -d $(SERVERLESS_VERSION)
	-git push origin :refs/tags/$(SERVERLESS_VERSION)
	git tag $(SERVERLESS_VERSION)
	git push origin $(SERVERLESS_VERSION)
.PHONY: git-tag