BeforeAll {
    . $PSScriptRoot\..\PSTestUtils\Public\Test-PSTUPowerShellCode.ps1
}

Describe 'Test-PSTUPowerShellCode' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-PSTUPowerShellCode'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Path parameter' {
        CommandUnderTest | Should -HaveParameter 'Path' -Type 'string' -Mandatory
    }

    It 'Should throw argument exception if Path does not exist' {
        $Path = 'an invalid path'

        { Test-PSTUPowerShellCode -Path $Path } | Should -Throw -ExceptionType ArgumentException
    }

    It 'Should throw argument exception if Path is not a file' {
        $Path = 'TestDrive:\'

        { Test-PSTUPowerShellCode -Path $Path } | Should -Throw -ExceptionType ArgumentException
    }

    It 'Should return false if file is empty' {
        $Path = "TestDrive:\\$([System.IO.Path]::GetRandomFileName())"
        New-Item -Path $Path

        Test-PSTUPowerShellCode -Path $Path | Should -BeFalse
    }

    It 'Should return false if file contains invalid powershell code' {
        $Path = "TestDrive:\\$([System.IO.Path]::GetRandomFileName())"
        New-Item -Path $Path
        Add-Content -Path $Path -Value "function () { Invalid code"

        Test-PSTUPowerShellCode -Path $Path | Should -BeFalse
    }

    It 'Should return true if file contains valid powershell code' {
        $Path = "TestDrive:\\$([System.IO.Path]::GetRandomFileName())"
        New-Item -Path $Path
        Add-Content -Path $Path -Value 'function Valid-PowerShell () { $true }'

        Test-PSTUPowerShellCode -Path $Path | Should -BeTrue
    }
}