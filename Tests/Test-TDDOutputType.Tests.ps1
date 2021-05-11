BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
}

Describe 'Test-TDDOutputType' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDOutputType'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Command parameter' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have a TypeName parameter' {
        CommandUnderTest | Should -HaveParameter 'TypeName' -Type 'string' -Mandatory
    }

    It 'Should declare OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should return false given a simple function' {
        function Func() { }

        Test-TDDOutputType -Command (Get-Command Func) -TypeName 'SomeType' | Should -BeFalse
    }

    It 'Should return false if OutputType is defined but no type given' {
        function Func() { 
            [OutputType()]
            param()
        }

        Test-TDDOutputType -Command (Get-Command Func) -TypeName 'SomeType' | Should -BeFalse
    }

    It 'Should return true if OutputType is defined' {
        function Func() { 
            [OutputType([Bool])]
            param()
        }

        Test-TDDOutputType -Command (Get-Command Func) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should return true if OutputType is defined as a string' {
        function Func() { 
            [OutputType('System.Bool')]
            param()
        }

        Test-TDDOutputType -Command (Get-Command Func) -TypeName 'System.Bool' | Should -BeTrue
    }
}