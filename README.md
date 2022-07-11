# Windows Setup

This repository contains some notes and scripts for my Windows 10/11 setup. Its purpose is mostly documentation for myself.

## Installing packages with winget

I decided to try winget as it comes as official package manager for Windows. It does everything I need, and the package choice is good enough for me.

I followed [this blog post](https://dev.to/guitarzan/installing-software-with-winget-automating-installation-with-powershell-1pdf).

- [install-windows_packages.ps1](./windows/install-windows_packages.ps1)

As an alternative there is also [ninite](https://ninite.com/), which may be useful for a basic setup, however it has only a small number of packages.

## WSL

I currently use Ubuntu 22 LTS. The easiest way is to install it via winget or from the MS Store.

### [Setup WSL](./wsl/setup-wsl.sh)

```bash
bash ./wsl/setup-wsl.sh | tee -a ~/setup.log
```

- Installs basic applications such as fish, tmux, ripgrep and neovim
- Installs python packages pip3, pipx, venv, xdg-open-wsl
- Installs fisher and some fish plugins
- Installs miniconda
- Links [scripts](./wsl/bin/) to `~/.local/bin`

### Configure git

```bash
git config --global user.name "$USER_NAME"
git config --global user.email "$EMAIL_ADDRESS"
git config --global init.defaultBranch main
```

### Create/Import ssh keys

```bash
ssh-keygen
```

### Clone and link dotfiles

- TODO

## Virtualization with Hyper-V

This may depend on your hardware and BIOS settings. If virtualization is supported and enabled, we just need to enable the Windows Feature. Afterwards, a reboot is required.

Run the following command as Administrator:

```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Nota Bene: This can also be done via the Control Panel, just look for "Windows Features".

## MS Hacks

### [Remove all icons from the taskbar](./windows/taskbar-fix.bat)

Nice to fix broken taskbar buttons, which happened to me twice.

### Add a custom entry to the start menu

Navigate to `%AppData%\Microsoft\Windows\Start Menu\Programs` and link the corresponding `.exe` file there.

### Manipulate Default Folders

Press `Win+R` and type `regedit`, then navigate to `HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders` and modify the corresponding folders. I had to do this in order to get rid of OneDrive, which I installed accidentally.

## Misc

- Download and Install [nerdfonts](https://www.nerdfonts.com/)
- [xdg-open-wsl](https://github.com/cpbotha/xdg-open-wsl) is a replacement for xdg-open. This is nice to open files an folders from the commandline, e.g. a folder in the Windows File Explorer.

[^fn1]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2