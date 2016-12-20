#! /bin/bash

if [ -z "$STACK_NAME" ]; then
	echo "Need to set STACK_NAME"
	exit 1
fi

if [ -z "$CFN_FILE" ]; then
	echo "Need to set CFN_FILE"
	exit 1
fi

if [ -z "$CFN_PARAMS_FILE" ]; then
	echo "Need to set CFN_PARAMS_FILE"
	exit 1
fi

function getStackStatus() {
	STACK_STATUS=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME} | jq -r " .Stacks[].StackStatus")
	if [ $? -ne 0 ]; then
		echo "Error executing aws command"
		exit 1;
	fi
}

function processStackStatus() {
	getStackStatus
	echo "Stack Status: ${STACK_STATUS}"
	case $STACK_STATUS in
		CREATE_IN_PROGRESS)
			;;
		UPDATE_IN_PROGRESS)
			;;
		UPDATE_COMPLETE_CLEANUP_IN_PROGRESS)
			;;
		UPDATE_ROLLBACK_IN_PROGRESS)
			;;
		ROLLBACK_IN_PROGRESS)
			;;
		DELETE_IN_PROGRESS)
			;;
		UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS)
			;;
		CREATE_FAILED)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		ROLLBACK_FAILED)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		ROLLBACK_COMPLETE)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		DELETE_FAILED)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		DELETE_COMPLETE)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		UPDATE_ROLLBACK_FAILED)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		UPDATE_ROLLBACK_COMPLETE)
			echo "Error creating stack"
			STACK_DONE=1
			;;
		CREATE_COMPLETE)
			echo "Stack created"
			STACK_DONE=1
			;;
		UPDATE_COMPLETE)
			echo "Stack updated"
			STACK_DONE=1
			;;
		*)
			echo "Unknown Stack Status"
			STACK_DONE=1
			;;
	esac
}

# Check if stack already exists
RESULT=$(aws cloudformation describe-stacks --stack-name $STACK_NAME 2>&1)
if [ $? -eq 0 ]; then
	echo "Stack '$STACK_NAME' Exists, Update It"
	OPERATION_TYPE="update-stack"
	getStackStatus
	echo "Pre-Update Stack Status: ${STACK_STATUS}"
elif [[ "$RESULT" =~ "Stack with id $STACK_NAME does not exist" ]]; then
	echo "Stack '$STACK_NAME' Does NOT Exists, Create It"
	OPERATION_TYPE="create-stack"
else
	echo "Error executing aws command: $?"
	exit 1
fi

# Invoke AWS cloudformation
echo aws cloudformation $OPERATION_TYPE --stack-name $STACK_NAME \
  --template-body file://${CFN_FILE} --parameters file://${CFN_PARAMS_FILE}

RESULT="$(aws cloudformation $OPERATION_TYPE --stack-name $STACK_NAME --template-body file://${CFN_FILE} --parameters file://${CFN_PARAMS_FILE} 2>&1)"

echo "This line is only for debugging purpose: $RESULT"

# Catch if no update required
if [[ "$RESULT" =~ "No updates are to be performed" ]]; then
	echo "No Update Required"
else
	STACK_DONE=0
	while [ $STACK_DONE -eq 0 ]; do
		sleep 5
		processStackStatus
	done
fi

# Show stack description
aws cloudformation describe-stacks --stack-name $STACK_NAME