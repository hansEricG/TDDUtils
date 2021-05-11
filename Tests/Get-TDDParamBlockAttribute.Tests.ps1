BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDOutputType.ps1
}

Describe 'Get-TDDParamBlockAttribute' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Get-TDDParamBlockAttribute'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Command parameter' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have an AttributeName parameter' {
        CommandUnderTest | Should -HaveParameter 'AttributeName' -Type 'System.string' -Mandatory
    }

    It 'Should have declared OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'System.Management.Automation.Language.AttributeAst' | Should -BeTrue
    }

    It 'Should return $null if no param block exists' {
        function Func() { }

        Get-TDDParamBlockAttribute -Command (Get-Command Func) -AttributeName 'SomeAttribute' | Should -Be $null
    }

    It 'Should return an AttributeAst object if the attribute exists' {
        function Func() { 
            [SomeAttribute()]
            param()
        }

        $o = Get-TDDParamBlockAttribute -Command (Get-Command Func) -AttributeName 'SomeAttribute'
        $o.GetType().FullName | Should -Be 'System.Management.Automation.Language.AttributeAst'
        $o.TypeName | Should -Be 'SomeAttribute'
    }

}