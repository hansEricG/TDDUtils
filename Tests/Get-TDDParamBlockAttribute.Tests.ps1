BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Private\Get-TDDParamBlockAttribute.ps1
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
        $o.GetType().Name | Should -Be 'AttributeAst'
        $o.TypeName | Should -Be 'SomeAttribute'
    }

}