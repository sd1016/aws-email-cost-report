import boto3
import os

ses = boto3.client('ses')

SENDER_EMAIL = os.environ['SENDER_EMAIL']
RECIPIENT_EMAIL = os.environ['RECIPIENT_EMAIL']

def lambda_handler(event, context):
    ses.send_email(Source=SENDER_EMAIL,
                   Destination={'ToAddresses': [RECIPIENT_EMAIL]},
                   Message={
                       'Subject': {'Data': 'Hello from sd1016 Lambda!'},
                       'Body': {'Text': {'Data': 'Hello, World! - best regards, from sd1016'}}
                   })
    return {"Status": "Success", "Message": f"Email sent successfully to {RECIPIENT_EMAIL} from sd1016 Lambda"}