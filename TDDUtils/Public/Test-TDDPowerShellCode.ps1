function Test-TDDPowerShellCode {
<#
.SYNOPSIS
Tests a powershell script and returns $true if it contains no syntax errors. 

.DESCRIPTION
Use this command to test if a PowerShell script contains valid code. It parses the code and returns $true if the number of syntax errors are 0. 

.PARAMETER Path
The path of the PowerShell script to be checked

.OUTPUTS
System.Boolean

.EXAMPLE
Test-TDDPowerShellCode -Path c:\myscript.ps1

.EXAMPLE
An example from a Pester test perspective:

It "Should contain valid PowerShell code" {
    Test-TDDPowerShellCode -Path $ModuleRootFile | Should -BeTrue
}

.LINK
https://pester.dev/
#>
[OutputType([Bool])]
[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    
    if ((Test-Path $Path -PathType Leaf) -eq $false) {
        throw [System.ArgumentException] "The Path ($Path) does not exist or is not a file"
    }

    $content = Get-Content -Path $Path

    if ($content)
    {
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$errors)
        $errors.Count -eq 0
    } else {
        $false
    }

}