IMAGE_NAME ?= aws-serverless
SERVERLESS_VERSION = v1.4.0

docker-build:
	docker build -t $(IMAGE_NAME) .
.PHONY: docker-build

docker-shell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) bash
.PHONY: docker-shell

git-tag:
	git tag $(SERVERLESS_VERSION)
	git push origin $(SERVERLESS_VERSION)
.PHONY: git-tag