#! /bin/bash
if [ -z "$STACK_NAME" ]; then
	echo "Need to set STACK_NAME"
	exit 1
fi

function getStackStatus() {
	STACK_STATUS=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME} 2> /dev/null | jq -r " .Stacks[].StackStatus")
	if [ $? -ne 0 ]; then
		echo "Error executing aws command"
		exit 1;
	fi

	if [ -z "$STACK_STATUS" ]; then
		STACK_STATUS="DELETE_COMPLETE"
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
		UPDATE_COMPLETE)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		CREATE_FAILED)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		ROLLBACK_FAILED)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		ROLLBACK_COMPLETE)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		DELETE_FAILED)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		UPDATE_ROLLBACK_FAILED)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		UPDATE_ROLLBACK_COMPLETE)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		CREATE_COMPLETE)
			echo "Error deleting stack"
			STACK_DONE=1
			;;
		DELETE_COMPLETE)
			echo "Stack Deleted"
			STACK_DONE=1
			;;
		*)
			echo "Error Unknown Stack Status"
			STACK_DONE=1
			;;
	esac
}

# Check if stack already exists
RESULT=$(aws cloudformation describe-stacks --stack-name $STACK_NAME 2>&1 )
if [ $? -eq 0 ]; then
	echo "Stack '$STACK_NAME' Exists, Delete It"
	getStackStatus
	echo "Pre-Delete Stack Status: ${STACK_STATUS}"
elif [[ "$RESULT" =~ "Stack with id $STACK_NAME does not exist" ]]; then
	echo "Stack '$STACK_NAME' Does NOT Exists, Nothing to do"
	exit 0
else
	echo "Error executing aws command: $?"
	exit 1
fi

# Invoke AWS cloudformation
echo aws cloudformation delete-stack --stack-name $STACK_NAME
aws cloudformation delete-stack --stack-name $STACK_NAME

# Wait for stack
STACK_DONE=0
while [ $STACK_DONE -eq 0 ]; do
	sleep 5
	processStackStatus
done