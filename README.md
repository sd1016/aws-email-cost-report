# About  
AWS Lambda to email cost report summary. This is a great way to monitor your homelab expenses and make sure you're not accidentally running resources that could lead to unexpected charges.

```bash
terraform apply -var="sender_email=<sender_email>" -var="recipient_email=<recipient_email>"