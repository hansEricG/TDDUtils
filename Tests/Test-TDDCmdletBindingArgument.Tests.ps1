BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDCmdletBindingArgument.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDParamBlockAttributeArgument.ps1
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
}

Describe 'Test-TDDCmdletBindingArgument' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDCmdletBindingArgument'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Command parameter' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have an ArgumentName parameter' {
        CommandUnderTest | Should -HaveParameter 'ArgumentName' -Type 'string' -Mandatory
    }

    It 'Should have an ArgumentValue parameter' {
        CommandUnderTest | Should -HaveParameter 'ArgumentValue' -Type 'string'
    }

    It 'Should return false given a simple function' {
        function SimpleFunction() { }

        Test-TDDCmdletBindingArgument -Command (Get-Command SimpleFunction) -ArgumentName 'SomeArgumentName' | Should -BeFalse
    }

    It 'Should return false if the argument does not exist' {
        function AdvancedFunction() {
            [OutputType([bool])]
            [CmdletBinding()]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' | Should -BeFalse
    }

    It 'Should return true if the argument exists on the function' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName)]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' | Should -BeTrue
    }

    It 'Should return true if the argument has a $true value' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName=$true)]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' | Should -BeTrue
    }

    It 'Should return true if the argument has a $true value and a $true Argument value' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName=$true)]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' -ArgumentValue $true | Should -BeTrue
    }

    It 'Should return false if the argument has a $false value' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName=$false)]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' | Should -BeFalse
    }

    It 'Should return true if the argument has a $false value and an ArgumentValue of $false is given' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName=$false)]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' -ArgumentValue $false | Should -BeTrue
    }

    It 'Should return false if the argument value differs' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName='SomeValue')]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' -ArgumentValue 'Some other valur' | Should -BeFalse
    }

    It 'Should return true if the argument value is the same' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeArgumentName='SomeValue')]
            param()
        }

        Test-TDDCmdletBindingArgument -Command (Get-Command AdvancedFunction) -ArgumentName 'SomeArgumentName' -ArgumentValue 'SomeValue' | Should -BeTrue
    }
}