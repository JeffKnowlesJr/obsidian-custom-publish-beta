# Obsidian Custom Publish

![Obsidian + Hugo](https://img.shields.io/badge/Obsidian%20+%20Hugo-Publishing%20System-738bd7?style=for-the-badge)

A powerful, customizable publishing system that connects your Obsidian vault to a Hugo-based website. Publish your notes beautifully while keeping your content and publishing system cleanly separated.

## 🌟 Overview

This repository contains two main components:

1. **ObsidianCustomPublish/** - A Hugo-based publishing application with custom templates and configurations
2. **Link/** - An Obsidian vault (not tracked in git) that serves as your content source

This separation allows you to:

- Keep your personal notes private and locally stored
- Version control only the publishing system
- Easily update the publishing system without affecting your content
- Customize how your content is presented on the web

## 🏗️ Project Structure

```
repository/
├── ObsidianCustomPublish/   # Hugo publishing application
│   ├── config/              # Hugo configuration files
│   ├── layouts/             # Custom Hugo templates
│   ├── themes/              # Hugo themes
│   ├── scripts/             # Utility scripts
│   ├── amplify.yml          # AWS Amplify configuration
│   ├── amplify-s3-policy.json # IAM policy for S3 access
│   └── ...
│
├── Link/                    # Obsidian vault (not in git)
│   ├── .obsidian/           # Obsidian configuration
│   ├── Journal/             # Content organized by type
│   ├── References/
│   ├── Workspace/
│   └── ...
│
├── .gitignore               # Excludes Link/ and generated files
├── .git/hooks/pre-push      # Auto-sync content to S3 on git push
└── .cursorignore            # Optimizes editor performance
```

## ✨ Features

- **Seamless Integration**: Hugo automatically pulls content from your Obsidian vault
- **Two-Way System**: Work in Obsidian, publish with Hugo
- **Privacy Control**: Keep sensitive notes private, publish only what you choose
- **Markdown Power**: Full support for Obsidian markdown features
- **Modern Design**: Clean, responsive layouts optimized for reading
- **Customizable**: Easily modify themes and layouts to match your preferences
- **Fast Builds**: Quick generation of static site content
- **Simple Deployment**: Deploy to GitHub Pages, Netlify, or AWS Amplify
- **S3 Content Sync**: Automated content synchronization to AWS S3 for builds

## 🚀 Getting Started

### Prerequisites

- [Obsidian](https://obsidian.md/) (latest version)
- [Hugo Extended](https://gohugo.io/getting-started/installing/) (v0.110.0+)
- [Git](https://git-scm.com/) (2.0+)
- [Node.js](https://nodejs.org/) (v14+)
- [AWS CLI](https://aws.amazon.com/cli/) (for S3 content sync)
- AWS account with S3 and Amplify access

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/JeffKnowlesJr/obsidian-custom-publish-beta.git
   cd obsidian-custom-publish
   ```

2. **Set up the publishing system**:

   ```bash
   cd ObsidianCustomPublish
   npm install
   ```

3. **Set up your Obsidian vault**:

   - Open Obsidian
   - Select "Open folder as vault"
   - Navigate to the `Link` directory in this repository
   - Click "Open"

4. **Create S3 bucket for content** (if using AWS deployment):

   ```bash
   aws s3 mb s3://obsidian-custom-publish-content --region us-east-1
   ```

5. **Start the development server**:

   ```bash
   # From the ObsidianCustomPublish directory
   hugo server -D
   ```

6. **View your site**:
   Open your browser to `http://localhost:1313/`

## 📝 Usage

### Day-to-Day Workflow

1. **Write & organize in Obsidian**:

   - Create and edit your notes in the Link vault
   - Use Obsidian's powerful linking and organization features

2. **Preview your site**:

   ```bash
   cd ObsidianCustomPublish
   hugo server -D
   ```

3. **Build for production**:

   ```bash
   hugo --minify
   ```

4. **Deploy your site**:
   - Deploy the `public` directory to your hosting provider
   - Or use continuous deployment with GitHub Actions, Netlify, or AWS Amplify

### Common Tasks

- **Add a new section**: Create a new folder in your Obsidian vault
- **Control publishing**: Use frontmatter `draft: true` to prevent publishing specific notes
- **Customize appearance**: Edit themes in `ObsidianCustomPublish/themes/`
- **Sync content to S3**: Run `./ObsidianCustomPublish/scripts/sync-to-s3.sh` (automatic on git push)

## 🔧 Configuration

### Hugo Configuration

The main configuration files are:

- `ObsidianCustomPublish/config.toml`: Main Hugo configuration
- `ObsidianCustomPublish/config/_default/config.toml`: Default settings
- `ObsidianCustomPublish/config/production/config.toml`: Production settings

Key settings to customize:

```toml
baseURL = 'https://your-site.com/'
title = "Your Digital Garden"
contentDir = "../Link"  # Points to your Obsidian vault locally
```

### Obsidian Configuration

- `.obsidian/`: Contains all Obsidian settings (ignored by git)
- Use Obsidian plugins to enhance your editing experience

### S3 Content Sync Configuration

- `ObsidianCustomPublish/scripts/sync-to-s3.sh`: Content sync script
- Update bucket name and region if needed:
  ```bash
  S3_BUCKET="obsidian-custom-publish-content"
  AWS_REGION="us-east-1"
  ```

## 🌐 Deployment Options

### GitHub Pages

1. Create `.github/workflows/hugo.yml` with GitHub Actions configuration
2. Push changes to trigger automatic builds

### Netlify

1. Connect your repository to Netlify
2. Set build command: `hugo --minify`
3. Set publish directory: `public`

### AWS Amplify

1. Use the included `amplify.yml` in the `ObsidianCustomPublish` directory
2. Connect your repository to AWS Amplify
3. Follow the IAM setup instructions in `ObsidianCustomPublish/IAM-SETUP.md`

## 📦 S3 Content System

This project uses AWS S3 to store content separately from code, enabling a clean separation between your private Obsidian vault and the public publishing system.

### How It Works

1. **Local Development**:

   - Hugo reads directly from your local `Link/` directory
   - Content remains private and is not tracked in git

2. **Content Synchronization** (Obsidian → S3):

   - The `sync-to-s3.sh` script uploads selected content to S3
   - Excludes private notes, drafts, and Obsidian configuration
   - Runs automatically before each git push via Git hook (`pre-push`)
   - Only publishable content reaches the S3 bucket

3. **Amplify Build Process** (S3 → Amplify):
   - When AWS Amplify builds your site (triggered by git push or manually):
     - It first authenticates with AWS using its service role
     - Pulls content from the S3 bucket during the `preBuild` phase
     - Creates a local `s3-content` directory with your Obsidian content
     - Uses this content instead of a direct Git-based content
   - The `amplify.yml` configuration handles this process:
     ```yaml
     preBuild:
       commands:
         # Install dependencies
         ...
         # Pull content from S3
         - echo "Pulling content from S3 bucket: ${CONTENT_BUCKET}"
         - aws s3 sync s3://${CONTENT_BUCKET} s3-content/
     build:
       commands:
         # Build Hugo site with S3 content
         - hugo --contentDir=s3-content --minify
     ```
   - This approach gives you complete separation between:
     - Private notes (stay in your local Obsidian vault)
     - Public content (synced to S3)
     - Code/templates (stored in Git)

### Complete Workflow

The entire content publishing flow works like this:

```
[Edit in Obsidian] → [Git Commit] → [Git Push triggers pre-push hook] →
[Content synced to S3] → [Code pushed to GitHub] →
[Amplify detects changes] → [Amplify pulls content from S3] →
[Hugo builds site with S3 content] → [Site deployed to web]
```

This architecture provides several benefits:

- Your sensitive notes never leave your local system
- Your Git repository stays clean with only code/configuration
- Your deployment system always has access to the latest content
- You can update code and content independently

### Setting Up IAM Permissions

For AWS Amplify to access the S3 content bucket, you need to configure IAM permissions:

1. **Create IAM Policy**:

   - Policy document provided in `ObsidianCustomPublish/amplify-s3-policy.json`
   - Grants read-only access to the content bucket (`s3:GetObject`, `s3:ListBucket`)
   - Specific to your content bucket: `obsidian-custom-publish-content`

2. **Attach to Amplify Service Role**:
   - Identify your Amplify service role (typically `amplifyconsole-backend-role`)
   - Attach the policy to this role using AWS Console or CLI:
   ```bash
   aws iam attach-role-policy \
     --role-name amplifyconsole-backend-role \
     --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/AmplifyS3ContentAccess
   ```

Detailed instructions are available in `ObsidianCustomPublish/IAM-SETUP.md`.

### Troubleshooting S3 → Amplify Flow

If you encounter issues with the S3 content flow:

1. **Check Build Logs** in the Amplify Console

   - Look for messages about S3 access or content pulling
   - Verify that content is being found and used during build

2. **Verify IAM Permissions**

   - Ensure the Amplify service role has the correct policy attached
   - Check that the S3 bucket name matches in all configurations

3. **Manual Testing**

   - Try running `aws s3 ls s3://obsidian-custom-publish-content` with your AWS credentials
   - Verify the content appears in S3 after a git push

4. **Enhanced Logging**
   - The `amplify.yml` includes detailed logging for the S3 operations
   - Review these logs to pinpoint any issues in the process

## 📚 Documentation

For detailed documentation about:

- Custom theming
- Advanced configurations
- Templating
- Publishing workflows

See the [documentation in the ObsidianCustomPublish directory](ObsidianCustomPublish/docs/).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ❓ Support

If you need help or have questions:

1. Check the [documentation](ObsidianCustomPublish/docs/)
2. Open an [issue](../../issues)
3. Join our [community](https://discord.gg/example)
