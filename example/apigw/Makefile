PACKAGE_DIR=package/package
ARTIFACT_NAME=package.zip
ARTIFACT_PATH=package/$(ARTIFACT_NAME)

################
# Entry Points #
################

build: .env
	docker-compose run --rm serverless make _deps _testUnit _build

deploy: $(ARTIFACT_PATH) .env
	docker-compose run --rm serverless make _deploy

shell:
	docker-compose run --rm serverless bash

##############
# NOT DOCKER #
##############

.env: | $(DOTENV)
	echo "Must provide 'DOTENV=.yourenvfile' or create file '.env' manually"

$(DOTENV):
	echo "Overwritting .env file with $(DOTENV)"
	cp $(DOTENV) .env
.PHONY: $(DOTENV)

# _deps install nodejs modules and babel-cli.
# This is time consuming and if you are developing using a container, best to not exit the container.
_deps:
	# work around due to https://github.com/yarnpkg/yarn/issues/1961
	yarn --no-bin-links
	$(info Install babel-cli globally)
	yarn global add babel-cli@6.18.0

_testUnit:
	./node_modules/mocha/bin/mocha --compilers js:babel-register test/unit

# _build transcompiles the src folder using Babel, installs nodejs production modules and creates a package ready for Serverless Framework.
_build:
	rm -fr package
	mkdir -p $(PACKAGE_DIR)/
	cp package.json $(PACKAGE_DIR)/
	cp yarn.lock $(PACKAGE_DIR)/
	babel src -d $(PACKAGE_DIR)/src
	cd $(PACKAGE_DIR) && yarn install --production
	cd $(PACKAGE_DIR) && zip -rq ../package .

# _buildLite does a pack but does not do the yarn install.
# This speeds up the process if you you have already done _build before and the node_modules production hasn't changed.
_buildLite:
	rm -fr $(PACKAGE_DIR)/src
	babel src -d $(PACKAGE_DIR)/src
	cd $(PACKAGE_DIR) && zip -rq ../package .
.PHONY: _buildLite

_deploy:
	rm -fr .serverless
	sls deploy -v

_logs:
	sls logs --function greet

_remove:
	sls remove -v
	rm -fr .serverless

_clean:
	rm -fr node_modules .serverless package