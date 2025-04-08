import boto3
from datetime import datetime, timedelta


ce = boto3.client('ce')

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

    
    print("Cost Data for the Last 7 Days:")
    for day in response['ResultsByTime']:
        time_period = day['TimePeriod']
        cost = day['Total']['UnblendedCost']['Amount']
        unit = day['Total']['UnblendedCost']['Unit']
        print(f"Date: {time_period['Start']} to {time_period['End']}, Cost: {cost} {unit}")
except Exception as e:
    print(f"Error retrieving cost data: {e}")