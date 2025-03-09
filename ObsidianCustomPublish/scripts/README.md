# Utility Scripts

This directory contains utility scripts for managing the Obsidian Custom Publish workflow.

## S3 Content Sync

The `sync-to-s3.sh` script syncs content from your Obsidian vault to an S3 bucket for use in AWS Amplify builds.

### Prerequisites

1. Install the [AWS CLI](https://aws.amazon.com/cli/)
2. Configure AWS credentials (`aws configure`)
3. Create an S3 bucket for your content

### Usage

```bash
# From the scripts directory
./sync-to-s3.sh your-bucket-name
```

### Setup S3 Bucket

If you haven't created a bucket yet:

```bash
aws s3 mb s3://your-bucket-name --region your-region
```

### Automation Options

#### Option 1: Add as a Git Pre-Push Hook

Create `.git/hooks/pre-push`:

```bash
#!/bin/bash
echo "Syncing Obsidian content to S3 before push..."
./ObsidianCustomPublish/scripts/sync-to-s3.sh your-bucket-name
```

Make it executable:

```bash
chmod +x .git/hooks/pre-push
```

#### Option 2: Create an Alias

Add to your `.bashrc` or `.zshrc`:

```bash
alias sync-obsidian="cd /path/to/project && ./ObsidianCustomPublish/scripts/sync-to-s3.sh your-bucket-name"
```

### Customization

Edit the script to customize:

- Excluded file patterns
- CloudFront invalidation (if using CloudFront)
- Other AWS S3 sync options
