# Custom Obsidian Publish

A custom implementation for publishing Obsidian notes using Hugo with the Book theme.

## Documentation

- [Changelog](CHANGELOG.md) - Version history and changes
- [Obsidian-Hugo Implementation Guide](docs/obsidian-hugo-implementation.md) - Detailed guide for setting up and syncing
- [Frontend Customization](#frontend-customization) - Documentation for customizing the site appearance
- [Separating Content from Code](#separating-content-from-code) - Guide to moving Obsidian vault outside the Git repo

## Overview

This project provides a simple, elegant way to publish your Obsidian notes as a public website. It uses:

- [Hugo](https://gohugo.io/) static site generator
- [Hugo Book Theme](https://github.com/alex-shpak/hugo-book) for documentation-style presentation
- Custom templates for proper rendering of Obsidian markdown features

## Features

- Automatic file tree navigation based on your folder structure
- Custom styling similar to Obsidian
- Support for common Obsidian markdown features
- Dark mode support
- Fast and lightweight

## Installation

1. Clone this repository
2. Install Hugo (see [Hugo Installation Guide](https://gohugo.io/installation/))
3. Run `hugo server -D` to start a local development server

## Usage

### Directory Structure

Place your Obsidian markdown files in the `content` directory. The site structure will follow your folder hierarchy.

### Front Matter

You can use YAML front matter at the beginning of your markdown files:

```yaml
---
title: 'Custom Title'
date: 2023-01-01
draft: false
tags: ['tag1', 'tag2']
---
```

### Publishing

To build the site for production:

```bash
hugo --minify
```

The static site will be generated in the `public` directory.

## Frontend Customization

### Styling

Custom styles can be added in `assets/scss/_custom.scss`.

### Theme Customization Best Practices

When customizing the theme, always follow these best practices:

1. **Never modify theme files directly** in the `themes/hugo-book/` directory
2. **Always create overrides** in your project's directories:
   - For layouts: `layouts/` (mirroring the theme's structure)
   - For styles: `assets/scss/_custom.scss`
   - For static files: `static/`

This ensures your customizations won't be lost when updating the theme.

### Navigation Menu

The navigation menu is customized to display a collapsible file tree based on your content structure.

#### Menu Customization Files

- `layouts/partials/docs/menu.html` - Main menu wrapper template that includes all menu components
- `layouts/partials/docs/menu-filetree.html` - Custom file tree implementation that scans the content directory
- `layouts/partials/docs/search.html` - Custom search implementation

#### Menu Structure

The menu automatically generates a hierarchical structure based on the following sections:

- Journal
- Documents
- Templates
- Workspace
- References
- Archive

Each section displays folders and files found in your content directory, with collapsible subsections for folders.

#### Adding New Top-Level Sections

To add new top-level sections to the navigation menu:

1. Edit the file `layouts/partials/docs/menu-filetree.html`
2. Locate the following line (around line 7):
   ```html
   {{ range (slice "Journal" "Documents" "Templates" "Workspace" "References"
   "Archive") }}
   ```
3. Add your new section name to the slice, for example:
   ```html
   {{ range (slice "Journal" "Documents" "Templates" "Workspace" "References"
   "Archive" "Projects" "Notes") }}
   ```
4. Create the corresponding folder in your `content` directory (e.g., `content/Projects`)
5. Restart the Hugo server to see your changes

The menu will automatically scan for content in the new section folder and display it in the navigation.

#### Menu Behavior

- Folders with content are displayed as collapsible sections with triangle indicators
- The menu preserves the open/closed state during navigation
- Active pages are highlighted with bold text

### Search Functionality

The site includes built-in search functionality powered by Fuse.js. To customize the search:

1. Create a custom override at `layouts/partials/docs/search.html`
2. Modify the search behavior or appearance as needed

## Separating Content from Code

For better separation of concerns, you can move your Obsidian vault to a sibling directory outside the Git repository. This keeps your content separate from the publishing code.

### Directory Structure

The recommended structure is:

```
parent-directory/
├── obsidian-vault/     # Your private notes (outside Git)
└── hugo-website/       # Your current Git repository
```

### Implementation Steps

#### 1. Create the Directory Structure

```bash
# From your current directory (hugo-website)
mkdir -p ../obsidian-vault
```

#### 2. Move Your Content

```bash
# Copy existing content to the new vault location
rsync -av --exclude=".git" content/ ../obsidian-vault/

# Optional: Remove content from Git repository if you want to sync it dynamically
# git rm -r content/
# mkdir content
# echo "content/*" >> .gitignore
```

#### 3. Create a Sync Script

Create a script to sync your Obsidian vault to the Hugo content directory:

```bash
# Create script directory
mkdir -p scripts
```

Add this content to `scripts/sync-obsidian.sh`:

```bash
#!/bin/bash

# Configuration - Updated paths for sibling directory structure
OBSIDIAN_VAULT="../obsidian-vault"  # Path to sibling directory
HUGO_CONTENT="./content"            # Path within your Hugo project

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Syncing entire Obsidian vault to Hugo content directory...${NC}"

# Create destination if it doesn't exist
mkdir -p "$HUGO_CONTENT"

# Sync entire vault using rsync
rsync -rltv --delete \
    --exclude="*.sync-conflict*" \
    --exclude=".obsidian/" \
    --exclude=".trash/" \
    --exclude=".DS_Store" \
    --exclude="*.swap" \
    --exclude="*.swp" \
    --exclude="*.swo" \
    --exclude="_private*" \
    "$OBSIDIAN_VAULT/" "$HUGO_CONTENT/"

echo -e "${GREEN}✓ Obsidian vault successfully synced to Hugo content!${NC}"
```

Make the script executable:

```bash
chmod +x scripts/sync-obsidian.sh
```

#### 4. Update .gitignore

Ensure your `.gitignore` excludes appropriate files:

```
# Standard exclusions
public/
resources/
.hugo_build.lock
node_modules/
.DS_Store
*.log
Thumbs.db

# Obsidian specific
.obsidian/
.trash/

# If you want to exclude content from Git
# and sync it dynamically (optional)
content/*
!content/.gitkeep
```

#### 5. Set Up Obsidian

1. Open Obsidian
2. Select "Open folder as vault"
3. Navigate to the `../obsidian-vault` directory
4. Configure your Obsidian settings as needed

#### 6. Development Workflow

With this setup, the recommended workflow is:

1. Edit content in Obsidian (in the separate vault directory)
2. Run the sync script to update the Hugo content:
   ```bash
   ./scripts/sync-obsidian.sh
   ```
3. Preview your site with Hugo:
   ```bash
   hugo server -D
   ```
4. Make changes to layouts, styling, and configuration in the Git repository
5. Commit and push those changes to version control

#### 7. Benefits of This Approach

- **Content Privacy**: Your notes remain outside the Git repository
- **Clear Separation**: Publishing mechanism separated from content
- **Versioning Control**: Only track changes to the site functionality, not content
- **Simplified Git History**: Fewer changes to track and manage
- **Flexible Content Management**: Easily switch between different content vaults

#### 8. Deployment Considerations

Before deploying:

1. Run the sync script to ensure content is up-to-date
2. Use Hugo's built-in capabilities to exclude draft content
3. Consider setting up CI/CD to automate the sync and build process

## Contributing

### Security Best Practices

When contributing to this repository, please follow these security best practices:

1. **Never commit sensitive information** such as:

   - API keys or tokens
   - Passwords or credentials
   - Private configuration files

2. **Use environment variables** for sensitive configuration

   - Consider using `.env` files (added to `.gitignore`)
   - Document required environment variables without showing actual values

3. **Review your changes** before committing to ensure no sensitive data is included

## License

MIT
