BeforeAll {
    . $PSScriptRoot\..\TDDUtils\Public\Test-TDDCmdletBindingAttribute.ps1
}

Describe 'Test-TDDCmdletBindingAttribute' {
    BeforeAll {
        function CommandUnderTest {
            Get-Command 'Test-TDDCmdletBindingAttribute'
        }
    }

    It "Should exist" {
        CommandUnderTest | Should -Not -BeNullOrEmpty
    }

    It 'Should have a Command parameter' {
        CommandUnderTest | Should -HaveParameter 'Command' -Type 'System.Management.Automation.CommandInfo' -Mandatory
    }

    It 'Should have an AttributeName parameter' {
        CommandUnderTest | Should -HaveParameter 'AttributeName' -Type 'string' -Mandatory
    }

    It 'Should have an AttributeValue parameter' {
        CommandUnderTest | Should -HaveParameter 'AttributeValue' -Type 'string'
    }

    It 'Should return false given a simple function' {
        function SimpleFunction() { }

        Test-TDDCmdletBindingAttribute -Command (Get-Command SimpleFunction) -AttributeName 'SomeAttributeName' | Should -BeFalse
    }

    It 'Should return false if the attribute does not exist' {
        function AdvancedFunction() {
            [OutputType([bool])]
            [CmdletBinding()]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' | Should -BeFalse
    }

    It 'Should return true if the attribute exists on the function' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName)]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' | Should -BeTrue
    }

    It 'Should return true if the attribute has a $true value' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName=$true)]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' | Should -BeTrue
    }

    It 'Should return true if the attribute has a $true value and a $true attribute value' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName=$true)]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' -AttributeValue $true | Should -BeTrue
    }

    It 'Should return false if the attribute has a $false value' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName=$false)]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' | Should -BeFalse
    }

    It 'Should return true if the attribute has a $false value and an AttributeValue of $false is given' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName=$false)]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' -AttributeValue $false | Should -BeTrue
    }

    It 'Should return false if the attribute value differs' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName='SomeValue')]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' -AttributeValue 'Some other valur' | Should -BeFalse
    }

    It 'Should return true if the attribute value is the same' {
        function AdvancedFunction() { 
            [CmdletBinding(SomeAttributeName='SomeValue')]
            param()
        }

        Test-TDDCmdletBindingAttribute -Command (Get-Command AdvancedFunction) -AttributeName 'SomeAttributeName' -AttributeValue 'SomeValue' | Should -BeTrue
    }
}