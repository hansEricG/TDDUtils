function Test-TDDOutputType {
<#
.SYNOPSIS
Tests whether a command has an output type declared

.DESCRIPTION
Use this command to test if a command has an OutputType attribute. Note that this function only tests the simple case where you declare one single type, e.g. as shown below

function MyFunction {
    [OutputType('String')]
    ...
}

.PARAMETER Command
The command on which the test should be performed

.PARAMETER TypeName
The name of the type to test for, e.g. 'Bool'.

.EXAMPLE
    $command = Get-Command -Name My-Command
    $HasBoolOutputType = Test-TDDOutputType -Command $command -TypeName 'Bool'

.EXAMPLE
An example from a Pester test perspective:

function My-Command
{
    [OutputType([Bool])]
    ...
}

It "Should have Output type Bool" {
    $c = Get-Command -Name My-Command
    Test-TDDOutputType $c -TypeName 'Bool' | Should -BeTrue
}

.LINK
https://pester.dev/
#>

    [OutputType([Bool])]
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]
        $Command,

        [Parameter(Mandatory)]
        [string]
        $TypeName
    )

    $attribute = Get-TDDParamBlockAttribute -Command $Command -AttributeName 'OutputType'
    if ($attribute) {
        $argument = $attribute.PositionalArguments | where-object {
            if ($_.StaticType.Name -eq 'String') {
                $_.Value -eq $TypeName 
            } elseif ($_.StaticType.Name -eq 'Type') {
                $_.TypeName.Name -eq $TypeName 
            } else {
                $false
            }
        }
        if ($argument) {
            $true
        } else {
            $false
        }
    } else {
        $false
    }
}