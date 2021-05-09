function Test-TDDCmdletBindingArgument {
<#
.SYNOPSIS
Tests whether a command has a CmdletBinding argument

.DESCRIPTION
Use this command to test if a command has a particular cmdletbinding argument set, e.g. SupportsShouldProcess.

.PARAMETER Command
The command on which the test should be performed

.PARAMETER ArgumentName
The argument name to test for

.PARAMETER ArgumentValue
Optional. The value of the argument.

.EXAMPLE
    $command = Get-Command -Name My-Command
    $supportsShouldProcess = Test-TDDCmdletBindingArgument -Command $command -ArgumentName 'SupportsShouldProcess'

.EXAMPLE
An example from a Pester test perspective:

function My-Command
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    ...
}

It "Should have ConfirmImpact set to High" {
    $c = Get-Command -Name My-Command
    Test-TDDCmdletBindingArgument $c -ArgumentName 'ConfirmImpact' -ArgumentValue 'High' | Should -BeTrue
}

.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute

.LINK
https://pester.dev/
#>
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]
        $Command,
        [Parameter(Mandatory)]
        [string]
        $ArgumentName,
        [Parameter()]
        [string]
        $ArgumentValue
    )

    if ($Command.CmdletBinding) {
        $cmdletBinding = Get-TDDParamBlockAttribute $command 'CmdletBinding'
        $argument = $cmdletBinding.NamedArguments | where-object { $_.ArgumentName -eq $ArgumentName };

        if ($null -eq $argument) {
            # Command does not have CmdletBinding argument, return false
            $false
        } elseif ($argument.ExpressionOmitted) {
            $ArgumentValue -eq '' -or $ArgumentValue -eq $true
        } elseif ($argument.Argument.Extent.Text -eq '$true') {
            $ArgumentValue -eq '' -or $ArgumentValue -eq $true
        } elseif ($argument.Argument.Extent.Text -eq '$false') {
            $ArgumentValue -eq $false
        } else {
            $ArgumentValue -eq $argument.Argument.Value
        }
    } else {
        $false
    }
}