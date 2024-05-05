import boto3
import psycopg2
from psycopg2 import sql

s3 = boto3.client("s3")
bucket_name = "my-bucket"
key = "data.txt"
data = s3.get_object(Bucket=bucket_name, Key=key)["Body"].read().decode("utf-8")

def push_to_rds(data):
    try:
        conn = psycopg2.connect(
            dbname="mydb",
            user="myuser",
            password="mypassword",
            host="my-rds-endpoint"
        )
        cur = conn.cursor()
        query = sql.SQL("INSERT INTO mytable (data) VALUES (%s)")
        cur.execute(query, [data])
        conn.commit()
        cur.close()
        conn.close()
        return True
    except Exception as e:
        print("Error pushing to RDS:", e)
        return False

def push_to_glue(data):
    glue = boto3.client("glue")
    response = glue.create_partition(
        DatabaseName="mydatabase",
        TableName="mytable",
        PartitionInput={
            "Values": [data],  
        },
    )
    return response

if _name_ == "_main_":
    if not push_to_rds(data):
        push_to_glue(data)