import os
import re
from datetime import datetime

def fix_date_format(content):
    # Find the front matter
    front_matter_match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL)
    if not front_matter_match:
        return content

    front_matter = front_matter_match.group(1)
    # Find the date line
    date_match = re.search(r'date:\s*"?\[\[(.*?)\]\]"?', front_matter)
    if not date_match:
        return content

    # Extract and clean the date
    date_str = date_match.group(1)
    date_str = re.sub(r'-(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)$', '', date_str)
    
    # Replace the old date format with the new one
    new_front_matter = re.sub(
        r'date:\s*"?\[\[.*?\]\]"?',
        f'date: "{date_str}"',
        front_matter
    )
    
    # Replace the old front matter with the new one
    return content.replace(front_matter_match.group(0), f'---\n{new_front_matter}\n---')

def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    new_content = fix_date_format(content)
                    if new_content != content:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Fixed date format in {file_path}")
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

if __name__ == "__main__":
    # Update to process all content directories
    content_dirs = [
        "content/_journal",
        "content/_fleeting",
        "content/copilot-conversations"
    ]
    for dir in content_dirs:
        if os.path.exists(dir):
            process_directory(dir) 