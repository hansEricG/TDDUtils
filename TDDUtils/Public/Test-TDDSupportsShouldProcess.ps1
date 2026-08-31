function Test-TDDSupportsShouldProcess {
<#
.SYNOPSIS
Tests whether a command declares SupportsShouldProcess

.DESCRIPTION
Returns $true if the command's CmdletBinding attribute declares
SupportsShouldProcess (i.e. the command opts in to -WhatIf and -Confirm).
Returns $false for a simple function, an advanced function without
SupportsShouldProcess, or one that declares SupportsShouldProcess=$false.

.PARAMETER Command
The command on which the test should be performed

.EXAMPLE
    $command = Get-Command -Name My-Command
    $supportsShouldProcess = Test-TDDSupportsShouldProcess -Command $command

.EXAMPLE
An example from a Pester test perspective:

function Remove-Thing
{
    [CmdletBinding(SupportsShouldProcess)]
    param()
}

It "Should support ShouldProcess" {
    $c = Get-Command -Name Remove-Thing
    Test-TDDSupportsShouldProcess $c | Should -BeTrue
}

.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute

.LINK
https://pester.dev/
#>

[OutputType([Bool])]
[CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]
        $Command
    )

    Test-TDDCmdletBindingArgument -Command $Command -ArgumentName 'SupportsShouldProcess'
}
