import boto3
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
    ce = boto3.client('ce')
    ses = boto3.client('ses')

    # Email configuration
    # Must be a verified SES email address
    SENDER_EMAIL = os.environ['SENDER_EMAIL']
    RECIPIENT_EMAIL = os.environ['RECIPIENT_EMAIL']

    # Calculate last 7 days in UTC
    end_date = datetime.now()
    start_date = end_date - timedelta(days=7)

    start_str = start_date.strftime('%Y-%m-%d')
    end_str = end_date.strftime('%Y-%m-%d')

    try:
        # Get cost data
        # 'UnblendedCost' is used since we want to see the true resource consumption cost without the complexity of billing arrangements
        # 'UnblendedCost' metric should work for homelab account setup where you're likely paying standard AWS rates 
        response = ce.get_cost_and_usage(
            TimePeriod={'Start': start_str, 'End': end_str},
            Granularity='DAILY',
            Metrics=['UnblendedCost'] 
        )

        
        # Generate report
        cost_report = "AWS Cost Report for the Last 7 Days:\n\n"
        for day in response['ResultsByTime']:
            time_period = day['TimePeriod']
            cost = day['Total']['UnblendedCost']['Amount']
            unit = day['Total']['UnblendedCost']['Unit']
            cost_report += f"Date: {time_period['Start']} to {time_period['End']}, Cost: {cost} {unit}\n"

        
        # Send email
        response = ses.send_email(
            Source=SENDER_EMAIL,
            Destination={'ToAddresses': [RECIPIENT_EMAIL]},
            Message={
                'Subject': {'Data': 'AWS Lambda - 7 Days AWS Cost Report'},
                'Body': {'Text': {'Data': cost_report}}
            }
        )
    
        return {"status": "Success", "message": "Email sent successfully"}

    except Exception as e:
        print(f"Error retrieving cost data: {e}")
        return {"status": "Error", "message": str(e)}
