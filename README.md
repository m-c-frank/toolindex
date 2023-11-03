# toolindex

A CLI tool that lists GitHub projects with their `ABSTRACT.md` contents.

## Installation

To install `toolindex`, run the following command:

```bash
bash <(gh api repos/m-c-frank/toolindex/contents/install.sh -H "Accept: application/vnd.github.v3.raw")
```

This script will:
- check for necessary dependencies
- clone the repository
- copy the scripts to your `~/bin` directory
- add the directory to your `PATH` if it's not already included.

After installation, restart your terminal or run:

## Usage

Run `toolindex` in your terminal to list your GitHub projects and their abstracts.
