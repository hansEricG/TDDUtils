BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDCmdletBinding.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDParamBlockAttribute.ps1
}

Describe 'Test-TDDCmdletBinding' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDCmdletBinding'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Mandatory string parameter: Command' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should return false given a simple function' {
        function SimpleFunction() { }

        Test-TDDCmdletBinding -Command (Get-Command SimpleFunction) | Should -BeFalse
    }

    It 'Should return true given an advanced function' {
        function AdvancedFunction() { 
            [CmdletBinding()]
            param()
        }

        Test-TDDCmdletBinding -Command (Get-Command AdvancedFunction) | Should -BeTrue
    }

}