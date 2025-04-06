[![Assemble Toolkit](https://github.com/ExcelliumSA/AppSecToolkit/actions/workflows/assemble_toolkit.yml/badge.svg?branch=main)](https://github.com/ExcelliumSA/AppSecToolkit/actions/workflows/assemble_toolkit.yml) ![logo](https://img.shields.io/badge/Updated%20Every-Saturday-yellow?style=flat&logo=githubactions)

# What?

This project create a archive with a collection of free and open source tools that are needed for different kinds of assessment.

# Why?

The objective is faciliate the provisioning of an assessment environement by a client when usage of client workstation is required.

So, the client will download the archive on the provisioned machine and then the AppSec team have all the needed tools to work in non-Internet connected mode.

# Where?

The toolkit is targeted to be used on **Windows** station only (most common client case).

# How?

The toolkit archive is created via this [PowerShell script](Build-Toolkit.ps1) in which, each tool, is added via its dedicated function named `Add-xxx`.

The script is tested on the following environments:

* Windows 10 Pro with PowerShell 5.1
* Windows Server 2019 with PowerShell 7.1.3

The script is developed using [Visual Studio Code](https://code.visualstudio.com/) and a [pre-configured workspace file](workspace.code-workspace) is provided in order to project into it.

The files `user_profile.(ps1|sh)` are used to define profile in [CMDER](https://cmder.net/) when a PowerShell / Bash shell is opened.

💬 See [here](https://github.com/cmderdev/cmder/tree/master/config) for more information about usage of these 2 files by [CMDER](https://cmder.net/).

# Distribution of the kit

> [!TIP]
> 📦A release can be downloaded [here](https://github.com/ExcelliumSA/AppSecToolkit/releases/tag/latest).

> [!NOTE]
> 🕓This [file](last_release_info.txt) contain the datetime/hash information about the last toolkit release.

> [!CAUTION]
> IAS consultants, at the end of the assessment, must execute the script [Clear-Workstation.ps1](Clear-Workstation.ps1) (included into the toolkit) to leave the client workstation in a **as much as possible** clean state.

📝Files:

* `Hash.txt` contains the SHA-256 digest of the kit ZIP archive.
* `Metadata.json` contains information, about the current bundle release, that can be used to identify files that can trigger alert by an antivirus software.

💬 Once the ZIP is expanded, you can init a shell (Powershell/Bash) in the toolkit using the instance of [CMDER](https://cmder.net/) installed and configured (launch the file `Cmder.exe`).

💬 The Firefox portable bundle was added, as an extra artefact, because it cannot be added to the toolkit archive due to a final file size constraint. See [here](https://github.com/ExcelliumSA/AppSecToolkit/issues/3#issuecomment-937479620) for explanation.

Use the following set of PowerShell commands to grab and check the archive (*copy and paste the block of commands in a PowerShell shell*):

```powershell
Start-BitsTransfer -Source "https://github.com/ExcelliumSA/AppSecToolkit/releases/download/latest/Toolkit.zip" -Destination ".\Toolkit.zip"
Start-BitsTransfer -Source "https://github.com/ExcelliumSA/AppSecToolkit/releases/download/latest/Hash.txt" -Destination ".\Hash-Toolkit.txt"
Start-BitsTransfer -Source "https://github.com/ExcelliumSA/AppSecToolkit/releases/download/firefox-portable/FirefoxPortable.zip" -Destination ".\FirefoxPortable.zip"
Start-BitsTransfer -Source "https://github.com/ExcelliumSA/AppSecToolkit/releases/download/firefox-portable/Hash.txt" -Destination ".\Hash-FirefoxPortable.txt"
Get-Content ".\Hash-Toolkit.txt"
Get-FileHash ".\Toolkit.zip" -Algorithm SHA256 | Format-List
Get-Content ".\Hash-FirefoxPortable.txt"
Get-FileHash ".\FirefoxPortable.zip" -Algorithm SHA256 | Format-List
# Check that that all hashes are equals
```

# Next steps?

See [here](https://github.com/ExcelliumSA/AppSecToolkit/projects/2).

# Miscellaneous

> [!NOTE]
> Content is not linked to the toolkit itself. It is stored here to made it available to our client.

💡 The folder [miscellaneous](miscellaneous) contains different materials that are useful, in some context, during the activities of the AppSec practice.

## Scripts

### Count-Endpoints.ps1

🔬It is a script that is intented to help a client to identify the number of controllers or SOAP/REST API endpoints that a web application contains based on its source code.

🎯The goal is help him to provided such information when requesting an assessment of a web application.

💻Example of usage:

```powershell
PS> Count-Endpoints.ps1 -codeLocation "[APP_PROJECT_FOLDER]"
[*] Check the provided folder...
111 files found with supported technologies.
[*] Analyse the provided folder...
Technology: DOTNET
Framework : AspNet-Core-API
Endpoints : 25 identified
```
