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

    It 'Should have an optional switch parameter: Optional' {
        CommandUnderTest | Should -HaveParameter 'Optional' -Type 'switch'
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

    It 'Should throw if both -Mandatory and -Optional is given' {
        function FunctionWithNoParameters() { }

        { Test-TDDParameter -Command (Get-Command FunctionWithNoParameters) -ParameterName 'SomeParameter' -Mandatory -Optional } | Should -Throw -ExceptionType ArgumentException
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

    It 'Should return false if Mandatory flag is given and Mandatory is not declared for the ParameterSet' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(ParameterSetName='someset1')]
                [Parameter(Mandatory, ParameterSetName='someset2')]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -ParameterSet 'someset1' -Mandatory | Should -BeFalse
    }

    It 'Should return true if Mandatory flag is given and Mandatory is declared for the ParameterSet' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(ParameterSetName='someset1')]
                [Parameter(Mandatory, ParameterSetName='someset2')]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -ParameterSet 'someset2' -Mandatory | Should -BeTrue
    }

    It 'Given no Mandatory flag, Should return true even though Mandatory is not declared for the parameter' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(Mandatory)]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' | Should -BeTrue
    }

    It 'Given -Optional, Should return false if Mandatory is declared' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(Mandatory)]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -Optional | Should -BeFalse
    }

    It 'Given -Optional and a parameterset, Should return false if Mandatory is declared for that parameterset' {
        function FunctionWithParameter() { 
            Param(
                [Parameter(Mandatory, ParameterSetName='someset')]
                [string]
                $SomeParameter
            )
        }

        Test-TDDParameter -Command (Get-Command FunctionWithParameter) -ParameterName 'SomeParameter' -ParameterSet 'someset' -Optional | Should -BeFalse
    }
}