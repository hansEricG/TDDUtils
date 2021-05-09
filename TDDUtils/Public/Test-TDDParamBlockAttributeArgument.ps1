function Test-TDDParamBlockAttributeArgument {
    <#
    .SYNOPSIS
    Tests whether a command has a param block attribute with a given argument
    
    .DESCRIPTION
    Use this command to test if a command has an attribute with a given argument defined.
    
    .PARAMETER Command
    The command on which the test should be performed
    
    .PARAMETER AttributeName
    The attribute name to test for, e.g. CmdletBinding
    
    .PARAMETER ArgumentName
    The argument name to test for, e.g. SupportsShouldProcess
    
    .PARAMETER ArgumentValue
    Optional. The value of the argument.
    
    .EXAMPLE
        $command = Get-Command -Name My-Command
        $supportsShouldProcess = Test-TDDParamBlockAttributeArgument -Command $command -AttributeName 'CmdletBinding' -ArgumentName 'SupportsShouldProcess'
    
    .EXAMPLE
    An example from a Pester test perspective:
    
    function My-Command
    {
        [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
        ...
    }
    
    It "Should have ConfirmImpact set to High" {
        $c = Get-Command -Name My-Command
        Test-TDDParamBlockAttributeArgument $c -AttributeName 'CmdletBinding' -ArgumentName 'ConfirmImpact' -ArgumentValue 'High' | Should -BeTrue
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
            
            [Parameter(Mandatory)]
            [string]
            $ArgumentName,
            
            [Parameter()]
            [string]
            $ArgumentValue
        )
    
        $attribute = Get-TDDParamBlockAttribute -Command $Command -AttributeName $AttributeName

        if ($attribute) {
            $argument = $attribute.NamedArguments | where-object { $_.ArgumentName -eq $ArgumentName };
    
            if ($null -eq $argument) {
                # The attribute does not have the argument, return false
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
            # No such attribute exists on the command, return false
            $false
        }
    }