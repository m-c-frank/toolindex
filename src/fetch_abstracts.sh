#!/bin/bash
# Fetches the projects and their abstracts, outputting in CSV format.

LIMIT=10

# Parse command line options for limit
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

# Fetch repos and their abstracts in CSV format
gh repo list --limit "$LIMIT" --json nameWithOwner | jq -c '.[]' | while read -r repo; do
    REPO_NAME=$(echo "$repo" | jq -r '.nameWithOwner')
    # Check if ABSTRACT.md exists in the repository
    if gh api repos/"$REPO_NAME"/contents/ABSTRACT.md --jq '.content' &> /dev/null; then
        ABSTRACT_CONTENT=$(gh api repos/"$REPO_NAME"/contents/ABSTRACT.md --jq '.content' | base64 --decode | awk '{printf "%s ", $0}' | sed 's/ $//')
        echo "$REPO_NAME,\"$ABSTRACT_CONTENT\""
    else
        echo "$REPO_NAME,\"ABSTRACT.md not found\""
    fi
done
