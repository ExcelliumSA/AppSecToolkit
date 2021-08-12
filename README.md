# What?

This project create a archive with a colleciton of free and open source tools that are needed for different kinds of assessmement.

# Why?

The objective is faciliate the provisioning of an assessment environement by a client when usage of client workstation is required.

So the client will download the archive on the provisioned machine and then we have all the need tools to work in non-Internet connected mode.

# Where?

The toolkit is targered to be used on a Windows station (most common client suitable case).

# How?

The toolkit arhive is created via this [PowerShell script](Build-Toolkit.ps1) in which each tool is added via its dedicated function `Add-xxx`.

The script is developed using [Visual Studio Code](https://code.visualstudio.com/) and a pre-configured workspace file is provided in order to project into it.

# Next steps?

See [here](https://github.com/ExcelliumSA/AppSecToolkit/projects/2).