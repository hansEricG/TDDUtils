function Test-TDDOutputType {
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