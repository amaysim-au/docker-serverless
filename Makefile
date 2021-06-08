IMAGE_NAME ?= dnxsolutions/serverless:latest

build:
	docker build -t $(IMAGE_NAME) .

shell:
	docker run --rm -it --entrypoint=/bin/bash -v ~/.aws:/root/.aws -v $(PWD):/opt/app $(IMAGE_NAME)

lint:
	docker run --rm -i -v $(PWD)/hadolint.yaml:/.config/hadolint.yaml hadolint/hadolint < Dockerfile