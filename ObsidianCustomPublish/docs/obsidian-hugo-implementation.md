# Obsidian-Hugo Implementation Guide

This document provides a detailed, step-by-step guide for separating your Obsidian vault from your Hugo website while maintaining sync capabilities.

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Migration Steps](#migration-steps)
3. [Git Configuration](#git-configuration)
4. [Sync Structure Setup](#sync-structure-setup)
5. [Content Organization](#content-organization)
6. [Implementation Process](#implementation-process)
7. [Testing Phase](#testing-phase)
8. [Deployment](#deployment)
9. [Maintenance Procedures](#maintenance-procedures)
10. [Recovery Procedures](#recovery-procedures)

## Initial Setup

Create the following directory structure:

```bash
parent-directory/
├── obsidian-vault/     # Your private notes
└── hugo-website/       # Your current Hugo project
```

## Migration Steps

### A. Prepare Obsidian Vault

Create the new Obsidian vault structure:

```bash
# Create directory structure
mkdir -p obsidian-vault/{_Journal/{y_2024,y_2025}/{January,February,March},Documents/{Images,Videos,Audio,Other},Templates,_Workspace/{Client-X,Client-Y,Client-Self},_References/{Books,Articles,Courses},Archive}
```

### B. Move Current Content

```bash
# Move your existing Obsidian content
mv hugo-website/.obsidian obsidian-vault/
mv hugo-website/content/_journal/* obsidian-vault/_Journal/
# Repeat for other directories as needed
```

## Git Configuration

### A. Update .gitignore

Add to your hugo-website/.gitignore:

```gitignore
# Obsidian-specific
.obsidian/
.trash/
.DS_Store
*.sync-conflict*
.sync/
.mobile.json
workspace.json
workspace

# Private content markers
**/_private/
**/_sensitive/
**/_personal/

# Obsidian workspace and settings
*.workspace
**/*.workspace
workspace
**/workspace
workspace.json
**/workspace.json
.mobile.json
**/.mobile.json
graph.json
**/graph.json

# Obsidian plugins and themes
**/plugins/
**/.obsidian/themes/
**/.obsidian.vimrc
**/.obsidian.mobile
**/.obsidian.iphone
**/.obsidian.ipad
**/.obsidian.android
**/.hotreload
```

### B. Clean Git History (Optional)

```bash
# Remove sensitive files from git history
git filter-branch --force --index-filter \
  "git rm -r --cached --ignore-unmatch .obsidian/" \
  --prune-empty --tag-name-filter cat -- --all
```

## Sync Structure Setup

### A. Create Sync Script

```bash
# Create sync script directory
mkdir -p hugo-website/scripts/
touch hugo-website/scripts/sync-obsidian.sh
chmod +x hugo-website/scripts/sync-obsidian.sh
```

### B. Configure Sync Script

```bash
#!/bin/bash

# Configuration
OBSIDIAN_VAULT="../obsidian-vault"
HUGO_CONTENT="./content"

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

> **Note**: This approach syncs your entire Obsidian vault to Hugo's content directory, which is simpler to maintain than selectively syncing specific directories. Just make sure your exclusion patterns (like `_private*`) properly filter out any content you don't want published.

## Content Organization

### A. Setup Templates

Create default template in obsidian-vault/Templates/:

```yaml
---
title: '{{title}}'
date: { { date } }
lastmod: { { date } }
draft: true
private: false
categories: []
tags: []
---
Content goes here...
```

### B. Organize Existing Content

1. Move private content to `_private_` prefixed folders
2. Update frontmatter in existing files
3. Reorganize media files into appropriate directories

## Implementation Process

### Day 1: Setup

- [ ] Create directory structure
- [ ] Move Obsidian vault
- [ ] Configure git
- [ ] Test basic structure

### Day 2: Content Migration

- [ ] Move existing content
- [ ] Update file organization
- [ ] Fix broken links
- [ ] Test content access

### Day 3: Sync Setup

- [ ] Implement sync script
- [ ] Test sync process
- [ ] Verify file integrity
- [ ] Document procedures

## Testing Phase

### A. Local Testing

```bash
# Test Hugo build
cd hugo-website
hugo server -D

# Test sync script
./scripts/sync-obsidian.sh
```

### B. Content Verification Checklist

- [ ] All links work
- [ ] Media displays correctly
- [ ] Navigation structure works
- [ ] Private content is excluded
- [ ] Templates function properly
- [ ] Sync script works as expected

## Deployment

### A. Initial Deployment

```bash
# Clean and build
cd hugo-website
hugo --cleanDestinationDir

# Deploy
git add .
git commit -m "Implement Obsidian-Hugo separation"
git push
```

### B. Production Verification Checklist

- [ ] Published site is accessible
- [ ] No private content exposed
- [ ] All functionality works
- [ ] Document any issues
- [ ] Test all navigation
- [ ] Verify media loading

## Maintenance Procedures

### A. Daily Workflow

```bash
# 1. Work in Obsidian vault

# 2. Run sync when ready to publish
cd hugo-website
./scripts/sync-obsidian.sh

# 3. Build and verify
hugo server -D

# 4. Deploy changes
git add .
git commit -m "Update content"
git push
```

### B. Weekly Tasks Checklist

- [ ] Audit published content
- [ ] Backup Obsidian vault
- [ ] Clean up unused media
- [ ] Update documentation
- [ ] Check for broken links
- [ ] Verify sync integrity

## Recovery Procedures

### A. Backup Strategy

```bash
# Backup Obsidian vault
rsync -av --exclude=".trash" obsidian-vault/ backup/obsidian/

# Backup Hugo content
rsync -av hugo-website/ backup/hugo/
```

### B. Recovery Steps Checklist

- [ ] Document recovery procedures
- [ ] Test restore process
- [ ] Verify backup integrity
- [ ] Update emergency contacts
- [ ] Maintain backup logs
- [ ] Test recovery annually

## Additional Notes

### Security Considerations

1. Never commit `.obsidian` directory
2. Regularly audit git history
3. Use `.gitignore` properly
4. Consider using `git-crypt` for sensitive files

### Performance Optimization

1. Optimize media files before sync
2. Regular cache clearing
3. Monitor build times
4. Performance testing after major changes

### Documentation

1. Keep README files updated
2. Document special procedures
3. Maintain configuration notes
4. Track important decisions

## Troubleshooting

### Common Issues and Solutions

1. **Sync Issues**

   - Check file permissions
   - Verify ignore patterns
   - Review sync logs
   - Test sync manually

2. **Build Problems**

   - Verify Hugo version
   - Check configuration
   - Review error logs
   - Test locally first

3. **Content Issues**
   - Validate frontmatter
   - Check file paths
   - Verify media links
   - Test in development

## Version Control

Last Updated: 2024-03-07
Version: 1.0.0

Remember to review and update this document regularly as your workflow evolves.
