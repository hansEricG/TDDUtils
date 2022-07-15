BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDParameter.ps1
}

Describe 'Test-TDDParameter' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDParameter'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should be an advanced function' {
        Test-TDDCmdletBinding -Command (CommandUnderTest) | Should -BeTrue
    }

    It 'Should declare OutputType' {
        Test-TDDOutputType -Command (CommandUnderTest) -TypeName 'Bool' | Should -BeTrue
    }

    It 'Should have a Mandatory string parameter: Command' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have a Mandatory string parameter: ParameterName' {
        CommandUnderTest | Should -HaveParameter 'ParameterName' -Type 'string' -Mandatory
    }

    It 'Should have an optional switch parameter: Mandatory' {
        CommandUnderTest | Should -HaveParameter 'Mandatory' -Type 'switch'
    }

    It 'Should have an optional string parameter: TypeName' {
        CommandUnderTest | Should -HaveParameter 'TypeName' -Type 'string'
    }

    It 'Should have an optional string parameter: ParameterSet' {
        CommandUnderTest | Should -HaveParameter 'ParameterSet' -Type 'string'
    }

    It 'Should return false if the parameter does not exist' {
        function FunctionWithNoParameters() { }

        Test-TDDParameter -Command (Get-Command FunctionWithNoParameters) -ParameterName 'SomeParameter' | Should -BeFalse
    }

    It 'Should return true if the parameter exists' {
        function FunctionWithParameter() { 
            Param(
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' | Should -BeTrue
    }

    It 'Should return false if the parameter exists but is not mandatory when given the Mandatory switch' {
        function FunctionWithParameter() { 
            Param(
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -Mandatory | Should -BeFalse
    }

    It 'Should return true if the parameter exists and is mandatory when given the Mandatory switch' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(Mandatory)]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -Mandatory | Should -BeTrue
    }

    It 'Should return false if typenames mismatch' {
        function FunctionWithParameter() { 
            Param(
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -TypeName 'sometype' | Should -BeFalse
    }

    It 'Should return true if typenames match' {
        function FunctionWithParameter() { 
            Param(
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -TypeName 'string' | Should -BeTrue
    }

    It 'Should return true if typenames match but full type name is used' {
        function FunctionWithParameter() { 
            Param(
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -TypeName 'System.String' | Should -BeTrue
    }

    It 'Should return false if ParameterSet not matching' {
        function FunctionWithParameter() { 
            Param(
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -ParameterSet 'someset' | Should -BeFalse
    }

    It 'Should return true if parameter set match' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(ParameterSetName='someset')]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -ParameterSet 'someset' | Should -BeTrue
    }

    It 'Should return true if multiple parameter sets exist but one match' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(ParameterSetName='someset1')]
                [Parameter(ParameterSetName='someset2')]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -ParameterSet 'someset1' | Should -BeTrue
    }
}