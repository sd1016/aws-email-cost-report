# About  
AWS Lambda to email cost report summary. This is a great way to monitor your homelab expenses and make sure you're not accidentally running resources that could lead to unexpected charges.

```bash
terraform apply -var="sender_email=<sender_email>" -var="recipient_email=<recipient_email>"
```

You will need 2 verified email addresses(sender and recipient) to make this work. Below are steps to verify an email address.

#### Steps to Verify an Email Address

1. **Run the Email Verification Command**  
   ```bash
   aws ses verify-email-identity --email-address your_email@example.com --region us-east-1
   ```
- `your_email@example.com` the email you want to verify.  
- `us-east-1` with your preferred region (must match the SES region you're working in).

2. **Check your inbox** 
An email will be sent to that address with a verification link. Click it to complete the process.

3. **Check Verification Status**

```bash
aws ses list-identities --identity-type EmailAddress --region us-east-1
```
