# GitHub Repository Code Concatenation Tool (cgit.sh)

## Overview
`cgit.sh` is a Bash script designed to clone a GitHub repository and concatenate all relevant source code files into a single text file. It supports flexible options for filtering by file extension and directory, making it ideal for preparing code for submission to AI chat bots.

## Features
- **Flexible File Filtering:** Specify which file extensions to include or exclude in the concatenation process.
- **Directory Filtering:** Limit the search to specified directories within the repository.
- **Repository Retention:** Option to keep the cloned repository in the current directory after processing.

## Prerequisites
- Git installed on your machine.
- Bash environment capable of executing shell scripts.

## Usage

### Syntax

```bash
./cgit.sh REPO_URL [EXTENSIONS] [DIRECTORIES] [--keep]
```

### Examples

```bash
# Concatonate .go and .txt files in app/ and cmd/ directories
bash cgit2.sh "https://github.com/user/repo" "go,txt" "app,cmd" --keep

# Concatonate default extensions only in the src/ directory
bash cgit2.sh "https://github.com/user/repo" "" "src" --keep

# Process modified extension list in specific directories
bash cgit2.sh "https://github.com/user/repo" "+html,go,-c" "app/html,cloud" --keep
```
### Standard Extensions
c cpp cc cxx java py js ts cs rb php html htm css swift kt kts go rs sh bat pl lua r m vb sql asm sc erl ex exs hs dart pas groovy f for f90 v vh sv pyx clj cljs md tsx jsx yaml yml json ini cfg xml ipynb
