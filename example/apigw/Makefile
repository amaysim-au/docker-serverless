SERVERLESS_RUN = docker-compose run --rm serverless
PACKAGE_DIR = package/package
ARTIFACT_NAME = package.zip
ARTIFACT_PATH = package/$(ARTIFACT_NAME)
ifdef ENVFILE
	ENVFILE_TARGET = envfile
else
	ENVFILE_TARGET = .env
endif

all: $(ENVFILE_TARGET) deps test build clean

.env:
	$(MAKE) envfile ENVFILE=env.template

envfile:
	ENVFILE=$(ENVFILE) $(SERVERLESS_RUN) cp $(ENVFILE) .env

deps: $(ENVFILE_TARGET)
	$(SERVERLESS_RUN) make _deps

_deps:
	yarn --no-bin-links

test: $(ENVFILE_TARGET)
	$(SERVERLESS_RUN) make _testUnit

_testUnit:
	./node_modules/mocha/bin/mocha --require @babel/register --recursive test/unit

build: $(ENVFILE_TARGET)
	$(SERVERLESS_RUN) make _build

_build:
	rm -fr package
	mkdir -p $(PACKAGE_DIR)/
	cp package.json $(PACKAGE_DIR)/
	cp yarn.lock $(PACKAGE_DIR)/
	./node_modules/@babel/cli/bin/babel.js src -d $(PACKAGE_DIR)/src
	cd $(PACKAGE_DIR) && yarn install --production --no-bin-links
	cd $(PACKAGE_DIR) && zip -rq ../package .

deploy: $(ENVFILE_TARGET) $(ARTIFACT_PATH)
	$(SERVERLESS_RUN) make _deploy

_deploy:
	sls deploy -v

remove: $(ENVFILE_TARGET)
	$(SERVERLESS_RUN) make _remove

_remove:
	sls remove -v

shell: $(ENVFILE_TARGET)
	$(SERVERLESS_RUN) bash

clean: $(ENVFILE_TARGET)
	$(SERVERLESS_RUN) make _clean

_clean:
	rm -fr node_modules .serverless package
