if [ -z "$CFN_FILE" ]; then
	echo "Need to set CFN_FILE"
	exit 1
fi

echo aws cloudformation validate-template --template-body file://${CFN_FILE}
aws cloudformation validate-template --template-body file://${CFN_FILE}