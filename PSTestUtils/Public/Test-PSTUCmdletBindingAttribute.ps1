function Test-PSTUCmdletBindingAttribute {
<#
.SYNOPSIS
Tests whether a command has a CmdletBinding attribute

.DESCRIPTION
Use this command to test if a command has a particular cmdletbinding attribute set, e.g. SupportsShouldProcess.

.PARAMETER Command
The command on which the test should be performed

.PARAMETER AttributeName
The attribute name to test for

.PARAMETER AttributeValue
Optional. The value of the attribute.

.EXAMPLE
    $command = Get-Command -Name My-Command
    $supportsShouldProcess = Test-PSTUCmdletBindingAttribute -Command $command -AttributeName 'SupportsShouldProcess'

.EXAMPLE
An example from a Pester test perspective:

function My-Command
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    ...
}

It "Should have ConfirmImpact set to High" {
    $c = Get-Command -Name My-Command
    Test-PSTUCmdletBindingAttribute $c -AttributeName 'ConfirmImpact' -AttributeValue 'High' | Should -BeTrue
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
        $AttributeName,
        [Parameter()]
        [string]
        $AttributeValue
    )

    if ($Command.CmdletBinding) {
        # Credit to https://stackoverflow.com/users/3156906/mclayton who influenced this implementation by
        # answering my question on Stack Overflow:
        # https://stackoverflow.com/questions/67264521/how-to-test-that-a-powershell-function-has-a-cmdletbinding-attribute
        $attributes = $command.ScriptBlock.Ast.Body.ParamBlock.Attributes;
        $cmdletBinding = $attributes | where-object { $_.TypeName.FullName -eq "CmdletBinding" };
        $attribute = $cmdletBinding.NamedArguments | where-object { $_.ArgumentName -eq $AttributeName };

        if ($null -eq $attribute) {
            # Command does not have CmdletBinding attribute, return false
            $false
        } elseif ($attribute.ExpressionOmitted) {
            $AttributeValue -eq '' -or $AttributeValue -eq $true
        } elseif ($attribute.Argument.Extent.Text -eq '$true') {
            $AttributeValue -eq '' -or $AttributeValue -eq $true
        } elseif ($attribute.Argument.Extent.Text -eq '$false') {
            $AttributeValue -eq $false
        } else {
            $AttributeValue -eq $attribute.Argument.Value
        }
    } else {
        $false
    }
}