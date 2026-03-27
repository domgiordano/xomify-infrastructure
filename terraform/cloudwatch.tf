# CloudWatch log groups for DynamoDB tables removed (#54)
# DynamoDB tables do not emit CloudWatch logs by default.
# Log groups were orphaned resources with no data flowing to them.
# If DynamoDB Streams or Contributor Insights are enabled in the future,
# re-add the relevant log groups at that time.
