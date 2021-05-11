BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDParamBlockAttribute.ps1
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
}

Describe 'Test-TDDParamBlockAttribute' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDParamBlockAttribute'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Command parameter' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have a AttributeName parameter' {
        CommandUnderTest | Should -HaveParameter 'AttributeName' -Type 'System.string' -Mandatory
    }

    It 'Should declare OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should return false if no param block exists' {
        function Func() { }

        Test-TDDParamBlockAttribute -Command (Get-Command Func) -AttributeName 'SomeAttribute' | Should -BeFalse
    }

    It 'Should return true if the attribute exists' {
        function Func() { 
            [SomeAttribute()]
            param()
        }

        Test-TDDParamBlockAttribute -Command (Get-Command Func) -AttributeName 'SomeAttribute' | Should -BeTrue
    }

    It 'Should return true if the attribute has arguments' {
        function Func() { 
            [SomeAttribute(SomeArgument1, SomeArgument2 = $false)]
            param()
        }

        Test-TDDParamBlockAttribute -Command (Get-Command Func) -AttributeName 'SomeAttribute' | Should -BeTrue
    }
}