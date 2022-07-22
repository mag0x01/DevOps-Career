# Initial Setup

## Install Prerequisites 

Open an Admin PowerShell and run the following commands:

- Enable OpenSSH by running `Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0`

### Winget

- Run `winget --version` to check if you have it installed. If not, install it from [Winget Releases on GitHub](https://github.com/microsoft/winget-cli/releases)
- Install Visual Studio Code: `winget install Microsoft.VisualStudioCode --silent`  
- Install Git: `winget install Git.Git --silent`

### Chocolatey (Only use if winget doesn't work)

- Install Chocolatey Package Manager:  
  ```Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))```

- Install Visual Studio Code:
```choco install vscode```

- Install Git:
```choco install git```

! Tip: You can add `-y` at the end of the command to auto-confirm the installation prompt.

! Tip: You can combine multiple installs into one: `choco install vscode git`

## Configure Git

! Make sure to change **FirstName** and **LastName** with your own

- Configure a User Name for your commits: `git config --global user.name "FirstName LastName"`
- Configure an Email Address for your commits: `git config --global user.email first.last@endava.com`
- Configure the default Git text editor: `git config --global core.editor "code --wait"`
- Configure proper line endings for Windows: `git config --global core.autocrlf true`
- Configure the default Git Diff tool: `git config --global diff.tool vscode`
- Configure VSCode Command for Diff: ``git config --global difftool.vscode.cmd "code --wait --diff `$LOCAL `$REMOTE"``
- Check the installation: `git config --list`

## Configure GitLab SSH Keys

- Long version: [GitLab and SSH Keys](https://docs.gitlab.com/ee/ssh)
- Short version:
  - Open a console, run `ssh-keygen` and follow the instructions to generate your ssh keys pair
  - Run `cat ~/.ssh/id_rsa.pub` and copy the output to your clipboard
  - Log into [Endava GitLab](https://gitlab.endava.com/-/profile/keys)
  - Navigate to [Profile -> SSH Keys](https://gitlab.endava.com/-/profile/keys)
  - Paste your public key in, give it a title and an expiration date (~4 months), and then press the add key button

## Setting the working directory

Create a new folder under C:\Projects named SoD-GitFundamentals:  
`New-Item -Type Directory -Name SoD-GitFundamentals -Path C:\Projects`
