import json
from urllib import response
import boto3
import os
import urllib.parse

# Initialize AWS clients
s3_client = boto3.client('s3')
# Bedrock runtime is used for invoking models
bedrock_client = boto3.client('bedrock-runtime', region_name='us-east-1')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    try:
        # 1. Get the uploaded file info from the S3 event trigger
        bucket_name = event['Records'][0]['s3']['bucket']['name']
        raw_key = event['Records'][0]['s3']['object']['key']
        file_key = urllib.parse.unquote_plus(raw_key)
        print(f"Processing file: {file_key} (Decoded from: {raw_key})")
        # 2. Download the file from S3 into memory
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        file_bytes = response['Body'].read()
        
        # Determine format (Claude 3 supports pdf, txt, csv, html, etc.)
        doc_format = "pdf" if file_key.lower().endswith(".pdf") else "txt"
        
        # 3. Construct the Bedrock Converse API payload
        messages = [{
            "role": "user",
            "content": [
                {
                    "document": {
                        "name": "uploaded_document",
                        "format": doc_format,
                        "source": {"bytes": file_bytes}
                    }
                },
                {
                    "text": "You are an AI document analyzer. Please read this document and provide a 2-sentence summary. Also, extract any key financial numbers, costs, or dates. Format your response clearly."
                }
            ]
        }]
        
        # 4. Call Claude 3 Haiku (Fast and extremely cost-effective)
        print("Sending document to Amazon Bedrock...")
        bedrock_response = bedrock_client.converse(
            modelId="anthropic.claude-3-haiku-20240307-v1:0",
            messages=messages
        )
        
        # 5. Extract the AI's answer
        ai_text = bedrock_response['output']['message']['content'][0]['text']
        print(f"AI Response received. Length: {len(ai_text)} characters.")
        
        # 6. Save the result to DynamoDB
        table_name = os.environ.get('TABLE_NAME', 'DocumentAnalysisResults')
        table = dynamodb.Table(table_name)
        
        table.put_item(
            Item={
                'DocumentId': file_key,
                'AI_Analysis': ai_text
            }
        )
        
        return {
            "statusCode": 200, 
            "body": json.dumps("Successfully processed document!")
        }

    except Exception as e:
        print(f"Error processing document: {str(e)}")
        return {
            "statusCode": 500, 
            "body": json.dumps("Failed to process document.")
        }