import boto3
import os
import sys
import uuid

s3_client = boto3.client('s3')

OUTPUT_BUCKET = os.environ['OUTPUT_BUCKET']

def main(download_path, upload_path):
    newLines = []
    with open(download_path, 'r') as file:
        lines = file.readlines()
        for line in lines:
            newLines.append( line + " ... every single line")
    with open(upload_path, 'w') as file:
        print(newLines)
        file.writelines(newLines)

def handler(event, context):
    print(OUTPUT_BUCKET)
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        output_key = '{}-{}'.format(uuid.uuid4(), key)
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), key)
        upload_path = '/tmp/resized-{}'.format(key)

        s3_client.download_file(bucket, key, download_path)
        main(download_path, upload_path)
        s3_client.upload_file(upload_path, OUTPUT_BUCKET, output_key)
