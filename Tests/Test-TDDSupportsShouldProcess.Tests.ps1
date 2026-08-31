BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDSupportsShouldProcess.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDCmdletBindingArgument.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDParamBlockAttributeArgument.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
}

Describe 'Test-TDDSupportsShouldProcess' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDSupportsShouldProcess'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Mandatory CommandInfo parameter: Command' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should declare OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should return false given a simple function' {
        function SimpleFunction() { }

        Test-TDDSupportsShouldProcess -Command (Get-Command SimpleFunction) | Should -BeFalse
    }

    It 'Should return false given an advanced function without SupportsShouldProcess' {
        function AdvancedFunction() {
            [CmdletBinding()]
            param()
        }

        Test-TDDSupportsShouldProcess -Command (Get-Command AdvancedFunction) | Should -BeFalse
    }

    It 'Should return true given a function declaring SupportsShouldProcess' {
        function ShouldProcessFunction() {
            [CmdletBinding(SupportsShouldProcess)]
            param()
        }

        Test-TDDSupportsShouldProcess -Command (Get-Command ShouldProcessFunction) | Should -BeTrue
    }

    It 'Should return true given a function declaring SupportsShouldProcess=$true' {
        function ShouldProcessTrueFunction() {
            [CmdletBinding(SupportsShouldProcess = $true)]
            param()
        }

        Test-TDDSupportsShouldProcess -Command (Get-Command ShouldProcessTrueFunction) | Should -BeTrue
    }

    It 'Should return false given a function declaring SupportsShouldProcess=$false' {
        function ShouldProcessFalseFunction() {
            [CmdletBinding(SupportsShouldProcess = $false)]
            param()
        }

        Test-TDDSupportsShouldProcess -Command (Get-Command ShouldProcessFalseFunction) | Should -BeFalse
    }
}
