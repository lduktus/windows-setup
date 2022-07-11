# 1. Make sure the Microsoft App Installer is installed:
#    https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1
# 2. Edit the list of apps to install.
# 3. Run this script as administrator.

Write-Output "Installing Apps"
$apps = @(
    @{name = "7zip.7zip" },
    @{name = "Adobe.Acrobat.Reader.64-bit" },
    @{name = "Bitwarden.Bitwarden" },
    @{name = "BraveSoftware.BraveBrowser" },
    @{name = "Discord.Discord" },
    @{name = "Google.Chrome" },
    @{name = "Microsoft.PowerShell" },
    @{name = "Microsoft.PowerToys" },
    @{name = "Microsoft.VisualStudioCode" },
    @{name = "Microsoft.WindowsTerminal" },
    @{name = "Mozilla.Firefox" },
    @{name = "Obsidian.Obsidian" },
    @{name = "OBSProject.OBSStudio" },
    @{name = "OpenWhisperSystems.Signal" },
    @{name = "SumatraPDF.SumatraPDF" },
    @{name = "SyncTrayzor.SyncTrayzor" },
    @{name = "Typora.Typora" },
    @{name = "Zoom.Zoom" },
    @{name = "Zotero.Zotero" }
);
Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}