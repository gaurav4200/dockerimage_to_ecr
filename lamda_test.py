import boto3

lambda_client = boto3.client("lambda")

response = lambda_client.invoke(
    FunctionName="my-docker-lambda",
    InvocationType="RequestResponse"
)

print("Lambda response:", response)