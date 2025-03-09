# Setting Up IAM Permissions for Amplify S3 Content

This guide explains how to configure the necessary IAM permissions for your AWS Amplify app to access the content S3 bucket.

## Option 1: Using the AWS Console

1. **Find Your Amplify Service Role**:

   - Go to the [AWS Amplify Console](https://console.aws.amazon.com/amplify/home)
   - Select your application
   - Go to "General settings" > "Advanced settings"
   - Note the IAM Service Role ARN (e.g., `arn:aws:iam::123456789012:role/amplifyconsole-backend-role`)

2. **Create a Custom Policy**:

   - Go to [IAM Console](https://console.aws.amazon.com/iam/home#/policies)
   - Click "Create policy"
   - Select the JSON tab
   - Paste the contents of `amplify-s3-policy.json`
   - Click "Next"
   - Name it "AmplifyS3ContentAccess"
   - Click "Create policy"

3. **Attach the Policy to Your Amplify Role**:
   - Go to [IAM Roles](https://console.aws.amazon.com/iam/home#/roles)
   - Search for and select your Amplify service role
   - Click "Attach policies"
   - Search for "AmplifyS3ContentAccess"
   - Select it and click "Attach policy"

## Option 2: Using AWS CLI

1. **Save the Policy**:

   ```bash
   aws iam create-policy \
     --policy-name AmplifyS3ContentAccess \
     --policy-document file://amplify-s3-policy.json
   ```

2. **Find Your Amplify Service Role**:

   ```bash
   # List your Amplify apps
   aws amplify list-apps

   # Get your app details
   aws amplify get-app --app-id YOUR_APP_ID
   ```

3. **Attach the Policy to Your Role**:
   ```bash
   aws iam attach-role-policy \
     --role-name YOUR_AMPLIFY_ROLE_NAME \
     --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/AmplifyS3ContentAccess
   ```

## Verifying Permissions

After setting up permissions, you can verify them by:

1. Going to the [Amplify Console](https://console.aws.amazon.com/amplify/home)
2. Starting a manual deployment
3. Checking the build logs for S3 access errors

If you see messages like "successfully pulled content from S3", your permissions are working correctly.

## Security Best Practices

This policy follows the principle of least privilege by only granting:

- Read-only access (`GetObject`, `ListBucket`)
- Limited to only the content bucket
- No write permissions to prevent unauthorized changes

## Troubleshooting

If you encounter permission errors in your Amplify build logs:

1. **Check the Role**: Verify you've attached the policy to the correct role
2. **Validate Bucket Name**: Ensure the bucket name in the policy matches your actual bucket
3. **Region Issues**: If using a bucket in a different region, add the `--region` flag to the S3 commands in `amplify.yml`
4. **IAM Propagation**: IAM changes can take a few minutes to propagate, so wait and try again
