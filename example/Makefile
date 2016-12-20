IMAGE_NAME ?= aws-serverless
CFN_PARAMS_JSON=kinesis/cfn.params.json
CFN_PARAMS_JSON_TPL=$(CFN_PARAMS_JSON).tpl
HANDLER_JS=lambdas/handler.js
HANDLER_JS_TPL=$(HANDLER_JS).tpl
ROOT_DIR=$(PWD)

define dockerRun
	docker run --rm --env-file env.list -v $(PWD):/opt/example -w /opt/example $(IMAGE_NAME) bash -c "$1"
endef

deps:
	$(call dockerRun,envsubst < $(CFN_PARAMS_JSON_TPL) > $(CFN_PARAMS_JSON))
	$(call dockerRun,envsubst < $(HANDLER_JS_TPL) > $(HANDLER_JS))
	$(call dockerRun,cd lambdas; npm install)
.PHONY: deps

deploy: cfn-validate
	$(call dockerRun,cfn-create-or-update.sh)
	$(call dockerRun,cd lambdas; sls deploy -v)
.PHONY: deploy

push:
	$(call dockerRun,cd lambdas; sls invoke --function pushDataToKinesis --path event.json; sleep 10)
.PHONY: push

log:
	$(call dockerRun,cd lambdas; sls logs --function logger)
.PHONY: log

delete:
	$(call dockerRun,cd lambdas; sls remove -v)
	$(call dockerRun,cfn-delete.sh)
.PHONY: delete

cfn-validate: deps
	$(call dockerRun,cfn-validate-template.sh)
.PHONY: cfn-validate

clean:
	rm -fr $(CFN_PARAMS_JSON) $(HANDLER_JS) lambdas/node_modules lambdas/.serverless
.PHONY: clean