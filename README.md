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

<details>
<summary>Setup Instructions</summary>

#### Windows
<details>
<summary>Click to show Windows setup instructions</summary>

1. Choose your preferred method:

   **Option A: PowerShell (Recommended)**
   - Install Git for Windows from [git-scm.com](https://git-scm.com/download/windows)
   - During installation, ensure "Git from the command line..." is selected
   - This installation includes Git and Bash which will be available in PowerShell
   - Open PowerShell
   - Navigate to script directory
   - Run script: `bash cgit.sh`

   **Option B: Command Prompt (CMD)**
   - Install Git for Windows from [git-scm.com](https://git-scm.com/download/windows)
   - During installation, ensure "Git from the command line..." is selected
   - This installation includes Git and Bash which will be available in CMD
   - Open Command Prompt
   - Navigate to script directory
   - Run script: `bash cgit.sh`

   **Option C: Git Bash**
   - Install Git for Windows from [git-scm.com](https://git-scm.com/download/windows)
   - During installation, select "Git Bash" option
   - This installation provides a dedicated Bash terminal with Git included
   - Right-click in your desired folder
   - Select "Git Bash Here"
   - Run script: `./cgit.sh` or `bash cgit.sh`
</details>

#### macOS
<details>
<summary>Click to show macOS setup instructions</summary>

1. Install Git (if not already installed):
   - Open Terminal
   - Run `xcode-select --install` (installs Git and other developer tools)
   - Or install via Homebrew: `brew install git`
2. The script can be run directly from Terminal as macOS includes Bash by default
</details>

#### Ubuntu/Debian Linux
<details>
<summary>Click to show Linux setup instructions</summary>

1. Install Git (if not already installed):
   ```bash
   sudo apt update
   sudo apt install git
   ```
2. Make the script executable:
   ```bash
   chmod +x cgit.sh
   # or just run the script with bash
   bash cgit.sh
   ```
3. Run directly from Terminal as shown in Usage section
</details>

</details>

## Usage

### Syntax

```bash
./cgit.sh REPO_URL [EXTENSIONS] [DIRECTORIES] [--keep]
# or
bash cgit.sh REPO_URL [EXTENSIONS] [DIRECTORIES] [--keep]
```

### Examples

```bash
# Concatonate all files with default extensions in entire repo
bash cgit.sh "https://github.com/user/repo"

# Concatonate .go and .txt files in app/ and cmd/ directories, keep downloaded copy of repo
bash cgit.sh "https://github.com/user/repo" "go,txt" "app,cmd" --keep

# Concatonate default extensions only in the src/ directory
bash cgit.sh "https://github.com/user/repo" "" "src"

# Process modified extension list in specific directories
bash cgit.sh "https://github.com/user/repo" "+html,go,-c" "app/html,cloud"
```
### Default Code File Extensions
c cpp cc cxx java py js ts cs rb php html htm css swift kt kts go rs sh bat pl lua r m vb sql asm sc erl ex exs hs dart pas groovy f for f90 v vh sv pyx clj cljs md tsx jsx yaml yml json ini cfg xml ipynb
