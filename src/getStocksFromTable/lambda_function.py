import boto3

def lambda_handler(event, context):
    # TODO implement
    client = boto3.resource("dynamodb")
    table = client.Table("positions")
    allthemoney = table.scan()["Items"]
    
    print("ALL: ", allthemoney)
    
    return allthemoney