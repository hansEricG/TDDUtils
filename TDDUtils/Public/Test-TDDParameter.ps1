<#
.SYNOPSIS
Tests whether a command has a given property

.DESCRIPTION
Returns $true if a command has a property with the given name, and it meets the optional other criterias, such as if it's Mandatory, 
of a certain type, or belongs to a ParameterSet. If one or more of the given criterias is not met, the command returns $false.

.PARAMETER Command
The command on which the test should be performed. 
This parameter is mandatory.

.PARAMETER ParameterName
The name of the parameter. 
This parameter is mandatory.

.PARAMETER TypeName
The name of the parameter's type, either the shortname (e.g. string) or the full name (e.g. System.String).
This parameter is optional.

.PARAMETER ParameterSet
The name of the parameter set of the parameter.
This parameter is optional.

.EXAMPLE
    The below code tests wheter My-Command has a string property with the name 'Path', and that it's declared mandatory

    $command = Get-Command -Name My-Command
    Test-TDDParameter -Command $Command -ParameterName 'Path' -TypeName 'string' -Mandatory

.EXAMPLE
    The below code tests wheter My-Command has a string property with the name 'Id', and that it it part of the Property Set 'ById'

    $command = Get-Command -Name My-Command
    Test-TDDParameter -Command $Command -ParameterName 'Id' -PropertySet 'ById'
#>
function Test-TDDParameter {
    [OutputType([Bool])]
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]
        $Command,

        [Parameter(Mandatory)]
        [String]
        $ParameterName,

        [string]
        $TypeName,

        [switch]
        $Mandatory,

        [string]
        $ParameterSet
    )

    $Parameter = $Command.Parameters[$ParameterName]
    if ($null -eq $Parameter) {
        Write-Verbose "The Command $($Command.Name) has no property with the name $ParameterName"
        return $false
    }

    if ($TypeName) {
        if ($Parameter.ParameterType.Name -ne $TypeName) {
            if ($Parameter.ParameterType.FullName -ne $TypeName) {
                Write-Verbose "The property $PropertyName is not of the given type $TypeName"
                return $false
            }
        }
    }
    
    if ($Mandatory -And -Not $Parameter.Attributes.Mandatory) {
        Write-Verbose "The property $PropertyName is not declared Mandatory"
        return $false
    }

    if ($ParameterSet) {
        if (-not ($Parameter.ParameterSets.Keys -contains $ParameterSet)) {
            Write-Verbose "The property $PropertyName has not declared the ParameterSet $ParameterSet"
            return $false
        }
    }

    $true
}