function Test-TDDCmdletBinding {
<#
.SYNOPSIS
Tests whether a command has Cmdlet binding defined

.DESCRIPTION
Returns $true if the command is an advanced function.

.PARAMETER Command
The command on which the test should be performed

.EXAMPLE
    $command = Get-Command -Name My-Command
    $isAdvancedFunction = Test-TDDCmdletBinding -Command $command

.EXAMPLE
An example from a Pester test perspective:

It "Should be an advanced function" {
    $c = Get-Command -Name My-Command
    Test-TDDCmdletBinding $c | Should -BeTrue
}

.LINK
help about_functions_advanced

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

    Test-TDDParamBlockAttribute $Command 'CmdletBinding'
}