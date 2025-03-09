#!/bin/bash
# sync-to-s3.sh
# Syncs content from Link/ vault to S3 bucket for use in Amplify builds
#
# Usage: ./sync-to-s3.sh [bucket-name]

# Get bucket name from command line or use default
S3_BUCKET=${1:-"obsidian-custom-publish-content"}
CONTENT_DIR="../../Link"
AWS_REGION="us-east-1"

echo "Syncing Obsidian content to S3 bucket: $S3_BUCKET (region: $AWS_REGION)"
echo "Content source: $CONTENT_DIR"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install it first." >&2
    exit 1
fi

# Check if content directory exists
if [ ! -d "$CONTENT_DIR" ]; then
    echo "Error: Content directory not found: $CONTENT_DIR" >&2
    exit 1
fi

# Sync content to S3, excluding private content
echo "Starting sync..."
aws s3 sync "$CONTENT_DIR" "s3://$S3_BUCKET" \
    --region "$AWS_REGION" \
    --exclude ".obsidian/*" \
    --exclude "*.private.*" \
    --exclude "_private/*" \
    --exclude ".trash/*" \
    --exclude "**/_drafts/*" \
    --delete

RESULT=$?
if [ $RESULT -eq 0 ]; then
    echo "✅ Content successfully synced to S3!"
else
    echo "❌ Error syncing content to S3. Exit code: $RESULT" >&2
    exit $RESULT
fi

# Optional: Invalidate CloudFront cache if you're using CloudFront
# DISTRIBUTION_ID="your-cloudfront-distribution-id"
# aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*" --region "$AWS_REGION"

echo "Sync complete. Your content is ready for Amplify builds." 