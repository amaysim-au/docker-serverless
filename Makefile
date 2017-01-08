IMAGE_NAME ?= aws-serverless
SERVERLESS_VERSION = v1.5.0

docker-build:
	docker build -t $(IMAGE_NAME) .
.PHONY: docker-build

docker-shell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) bash
.PHONY: docker-shell

git-tag:
	-git tag -d $(SERVERLESS_VERSION)
	-git push origin :refs/tags/$(SERVERLESS_VERSION)
	git tag $(SERVERLESS_VERSION)
	git push origin $(SERVERLESS_VERSION)
.PHONY: git-tag