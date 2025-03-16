# 🚀 PowerShell Profile

Transform your PowerShell experience with a stylish, feature-rich terminal environment that rivals Linux terminals in both aesthetics and functionality.


## ✨ Features

- 🎨 Beautiful prompt with Git integration
- 🔍 Syntax highlighting
- 📁 File icons with Terminal-Icons
- 📊 Intelligent command history with PSReadLine
- 🧠 Smart directory navigation with zoxide
- 🛠️ Chocolatey package manager integration

## 💻 Quick Installation

Run this command in an **elevated PowerShell** window:

```powershell
irm "https://github.com/arminzou/PowerShell-Profile/raw/master/setup.ps1" | iex
```

The setup script automatically installs:
- Oh My Posh
- Nerd Fonts (CaskaydiaCove NF)
- Terminal-Icons
- Chocolatey
- zoxide

## 🔤 Font Installation

For the best experience, you need a Nerd Font. Choose one of these methods:

### Option 1: Using Oh My Posh (Recommended)

```powershell
oh-my-posh font install
```
1. Run the command `oh-my-posh font install`
2. Select your preferred font from the list using arrow keys and press Enter.

### Option 2: Manual Installation

The setup script attempts to install CaskaydiaCove NF automatically by default. If that fails:

1. Download [CaskaydiaCove NF](https://www.nerdfonts.com/font-downloads)
2. Extract and install the font files
3. Configure your terminal to use the installed font


## ⚙️ Customizing Your Profile

**Important:** Do not edit `Microsoft.PowerShell_profile.ps1` directly as it will be overwritten by updates.

To add your own customizations:

1. Run `Edit-Profile` in PowerShell
2. Add your custom settings to the newly created `profile.ps1` file
3. Save the file and restart your PowerShell session

## 🔧 Troubleshooting

If you encounter any issues:

1. Make sure you're running PowerShell as Administrator
2. Check that your terminal is using the installed Nerd Font
3. Restart your PowerShell session after installation
4. Run `Test-ProfileSetup` to diagnose common issues

## 📚 Useful Commands

```powershell
# Smart directory navigation
z [folder name]

# Edit your custom profile
Edit-Profile

# Update your PowerShell profile
Update-Profile

# Display all useful commands
Show-Help 
```
