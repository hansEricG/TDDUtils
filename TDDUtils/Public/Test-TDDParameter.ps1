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

.PARAMETER Mandatory
If added to the command call, the command verifies that the parameter under test is declared as mandatory. 
Note that, if a ParameterSet is given, the command checks that the property is declared mandatory for that PropertySet.
Also note that this parameter cannot be added together with Optional 

.PARAMETER Optional
If added to the command call, the command verifies that the parameter under test is not declared as mandatory. 
Note that, if a ParameterSet is given, the command checks that the property is not declared mandatory for that PropertySet. 
Also note that this parameter cannot be added together with Mandatory 

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

        [switch]
        $Optional,

        [string]
        $ParameterSet
    )

    if ($Mandatory -and $Optional) {
        throw [System.ArgumentException] "Both -Mandatory and -Optional cannot be given, remove one - or both - of them and try again."
    }

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
    
    if ($ParameterSet) {
        $ParameterSetFound = $Parameter.ParameterSets[$ParameterSet]
        if (-not $ParameterSetFound) {
            Write-Verbose "The property $PropertyName has not declared the ParameterSet $ParameterSet"
            return $false
        }

        if ($Mandatory) {
            if (-not $ParameterSetFound.IsMandatory) {
                Write-Verbose "The property $PropertyName has not declared Mandatory for the ParameterSet $ParameterSet"
                return $false
            }
        } elseif ($Optional) {
            if ($ParameterSetFound.IsMandatory) {
                Write-Verbose "The property $PropertyName has declared Mandatory for the ParameterSet $ParameterSet"
                return $false
            }
        }
    } else {
        if ($Mandatory) {
            if (-Not $Parameter.Attributes.Mandatory) {
                Write-Verbose "The property $PropertyName is not declared Mandatory"
                return $false
            }
        } elseif ($Optional) {
            if ($Parameter.Attributes.Mandatory) {
                Write-Verbose "The property $PropertyName is declared Mandatory"
                return $false
            }
        }
    }

    $true
}