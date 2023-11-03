#!/bin/bash
# ---
# Lists projects and their abstracts for the authenticated GitHub user.
# Usage: ./toolindex.sh [-l limit]
# Options:
#   -l limit: Number of projects to list (default 10)
# ---

# Default limit
LIMIT=10

# Parse command line options
while getopts "l:" opt; do
  case $opt in
    l) LIMIT=${OPTARG} ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Check if GitHub CLI is authenticated
if ! gh auth status &> /dev/null; then
    echo "GitHub CLI not authenticated. Please login with 'gh auth login'."
    exit 1
fi

# Fetch and display repos with ABSTRACT.md
{
    printf "%-40s | %-60s\n" "PROJECT" "ABSTRACT"
    printf "%-40s | %-60s\n" "-------" "--------"
    gh repo list --limit "$LIMIT" --json nameWithOwner | jq -c '.[]' | while read -r repo; do
        REPO_NAME=$(echo "$repo" | jq -r '.nameWithOwner')
        # Check if ABSTRACT.md exists in the repository
        if gh api repos/"$REPO_NAME"/contents/ABSTRACT.md --jq '.content' &> /dev/null; then
            ABSTRACT_CONTENT=$(gh api repos/"$REPO_NAME"/contents/ABSTRACT.md --jq '.content' | base64 --decode)
        else
            ABSTRACT_CONTENT="ABSTRACT.md does not exist"
        fi

        # Use printf to ensure proper alignment and trimming of content
        printf "%-40s | %-60s\n" "$REPO_NAME" "$ABSTRACT_CONTENT"
    done | column -t -s '|'
}
