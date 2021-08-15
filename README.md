[![Assemble Toolkit](https://github.com/ExcelliumSA/AppSecToolkit/actions/workflows/assemble_toolkit.yml/badge.svg?branch=main)](https://github.com/ExcelliumSA/AppSecToolkit/actions/workflows/assemble_toolkit.yml)

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

# Distribution of the kit

A release can be downloaded [here](https://github.com/ExcelliumSA/AppSecToolkit/releases/tag/latest).

The file `Hash.txt` contains the SHA-256 digest of the kit ZIP archive.

Once the ZIP is expanded, you can init a shell in the toolkit using the following PowerShell command:

```powershell
PS> .\shell.ps1
[+] Environement:
...
[+] Toolkit base:
...
(PythonEnv)> [POWERSHELL SHELL WITH PYTHON ENV LOADED]
```

# Next steps?

See [here](https://github.com/ExcelliumSA/AppSecToolkit/projects/2).