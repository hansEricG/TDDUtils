BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDPowerShellCode.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
}

Describe 'Test-TDDPowerShellCode' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDPowerShellCode'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Path parameter' {
        CommandUnderTest | Should -HaveParameter 'Path' -Type 'string' -Mandatory
    }

    It 'Should declare OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should throw argument exception if Path does not exist' {
        $Path = 'an invalid path'

        { Test-TDDPowerShellCode -Path $Path } | Should -Throw -ExceptionType ArgumentException
    }

    It 'Should throw argument exception if Path is not a file' {
        $Path = 'TestDrive:\'

        { Test-TDDPowerShellCode -Path $Path } | Should -Throw -ExceptionType ArgumentException
    }

    It 'Should return false if file is empty' {
        $Path = "TestDrive:\\$([System.IO.Path]::GetRandomFileName())"
        New-Item -Path $Path

        Test-TDDPowerShellCode -Path $Path | Should -BeFalse
    }

    It 'Should return false if file contains invalid powershell code' {
        $Path = "TestDrive:\\$([System.IO.Path]::GetRandomFileName())"
        New-Item -Path $Path
        Add-Content -Path $Path -Value "function () { Invalid code"

        Test-TDDPowerShellCode -Path $Path | Should -BeFalse
    }

    It 'Should return true if file contains valid powershell code' {
        $Path = "TestDrive:\\$([System.IO.Path]::GetRandomFileName())"
        New-Item -Path $Path
        Add-Content -Path $Path -Value 'function Valid-PowerShell () { $true }'

        Test-TDDPowerShellCode -Path $Path | Should -BeTrue
    }
}