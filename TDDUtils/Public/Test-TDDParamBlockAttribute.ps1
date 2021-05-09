function Test-TDDParamBlockAttribute {
    <#
    .SYNOPSIS
    Tests whether a command has an attribute with a given name
    
    .DESCRIPTION
    Returns $true if the command has the given attribute defined.
    
    .PARAMETER Command
    The command on which the test should be performed
    
    .EXAMPLE
        $command = Get-Command -Name My-Command
        $isAdvancedFunction = Test-TDDParamBlockAttribute -Command $command -AttributeName 'CmdletBinding'
    
    .EXAMPLE
    An example from a Pester test perspective:
    
    It "Should be an advanced function" {
        $c = Get-Command -Name My-Command
        Test-TDDParamBlockAttribute $c 'CmdletBinding' | Should -BeTrue
    }
    
    .LINK
    help about_functions_advanced
    
    .LINK
    https://pester.dev/
    #>
    
    [CmdletBinding()]
        param (
            # Parameter help description
            [Parameter(Mandatory)]
            [System.Management.Automation.CommandInfo]
            $Command,

            [Parameter(Mandatory)]
            [string]
            $AttributeName
        )
    
        $attribute = Get-TDDParamBlockAttribute $command $AttributeName
        $null -ne $attribute
    }