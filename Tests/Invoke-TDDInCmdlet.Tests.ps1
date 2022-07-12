BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Invoke-TDDInCmdlet.ps1
}

Describe 'Invoke-InCmdlet Tests' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Invoke-TDDInCmdlet'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have  a mandatory scriptblock parameter: Code' {
        CommandUnderTest | Should -HaveParameter 'Code' -Type 'ScriptBlock' 
    }

    It 'Should be an advanced function' {
        Test-TDDCmdletBinding -Command (CommandUnderTest) | Should -BeTrue
    }

    It 'Should Invoke the code, and only once' {

        function DummyFunction {
        }

        Mock DummyFunction { }
        
        Invoke-TDDInCmdlet -Code { DummyFunction }

        Should -Invoke DummyFunction -Times 1 -Exactly
    }


}