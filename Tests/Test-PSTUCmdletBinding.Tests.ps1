BeforeAll {
    . $PSScriptRoot\..\PSTestUtils\Public\Test-PSTUCmdletBinding.ps1
}

Describe 'Test-PSTUCmdletBinding' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-PSTUCmdletBinding'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Mandatory string parameter: Name' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should return false given a simple function' {
        function SimpleFunction() { }

        Test-PSTUCmdletBinding -Command (Get-Command SimpleFunction) | Should -BeFalse
    }

    It 'Should return true given an advanced function' {
        function AdvancedFunction() { 
            [CmdletBinding()]
            param()
        }

        Test-PSTUCmdletBinding -Command (Get-Command AdvancedFunction) | Should -BeTrue
    }

}