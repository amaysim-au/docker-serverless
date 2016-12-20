IMAGE_NAME ?= aws-serverless

docker-build:
	docker build -t $(IMAGE_NAME) .
.PHONY: docker-build

docker-shell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_LOCAL_NAME) bash
.PHONY: docker-shell