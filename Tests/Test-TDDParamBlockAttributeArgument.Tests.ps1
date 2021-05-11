BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDParamBlockAttributeArgument.ps1
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
}

Describe 'Test-TDDParamBlockAttributeArgument' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDParamBlockAttributeArgument'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Command parameter' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have an AttributeName parameter' {
        CommandUnderTest | Should -HaveParameter 'ArgumentName' -Type 'string' -Mandatory
    }

    It 'Should have an ArgumentName parameter' {
        CommandUnderTest | Should -HaveParameter 'ArgumentName' -Type 'string' -Mandatory
    }

    It 'Should have an ArgumentValue parameter' {
        CommandUnderTest | Should -HaveParameter 'ArgumentValue' -Type 'string'
    }

    It 'Should declare OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should return false given a simple function' {
        function SimpleFunction() { }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command SimpleFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' | Should -BeFalse
    }

    It 'Should return false if the argument does not exist' {
        function AdvancedFunction() {
            [OutputType([bool])]
            [CmdletBinding()]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' | Should -BeFalse
    }

    It 'Should return true if the argument exists on the function' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument)]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' | Should -BeTrue
    }

    It 'Should return true if the argument has a $true value' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument=$true)]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' | Should -BeTrue
    }

    It 'Should return true if the argument has a $true value and a $true Argument value' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument=$true)]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' -ArgumentValue $true | Should -BeTrue
    }

    It 'Should return false if the argument has a $false value' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument=$false)]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' | Should -BeFalse
    }

    It 'Should return true if the argument has a $false value and an ArgumentValue of $false is given' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument=$false)]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' -ArgumentValue $false | Should -BeTrue
    }

    It 'Should return false if the argument value differs' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument='SomeValue')]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' -ArgumentValue 'Some other valur' | Should -BeFalse
    }

    It 'Should return true if the argument value is the same' {
        function AdvancedFunction() { 
            [SomeAttribute(SomeArgument='SomeValue')]
            param()
        }

        Test-TDDParamBlockAttributeArgument -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttribute' -ArgumentName 'SomeArgument' -ArgumentValue 'SomeValue' | Should -BeTrue
    }
}