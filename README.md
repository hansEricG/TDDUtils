# TDDUtils PowerShell Module

TDDUtils is a PowerShell module aiming to make it easier for programmers to write PowerShell code using Test Driven Develpment techniques. It complements PowerShell testing frameworks such as [Pester](https://github.com/pester/Pester) by providing small utility functions that performs isolated tests on your code.

## Installation
The easiest way to install TDDUtils is to use the `Install-Module` command in PowerShell.

Open a PowerShell terminal in Administrator mode and enter the following command.

```
Install-Module TDDUtils
```

## Usage
Here are some Pester test examples to get you started.  

```
function My-Command
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([Bool])]
    ...
}

Describe "My-Command Tests" {
    It "Should be an advanced function" {
        $c = Get-Command -Name My-Command
        Test-TDDParamBlockAttribute $c 'CmdletBinding' | Should -BeTrue
    }

    It "Should have ConfirmImpact set to High" {
        $c = Get-Command -Name My-Command
        Test-TDDParamBlockAttributeArgument $c -AttributeName 'CmdletBinding' -ArgumentName 'ConfirmImpact' 
            -ArgumentValue 'High' | Should -BeTrue
    }

    It "Should have Output type Bool" {
        $c = Get-Command -Name My-Command
        Test-TDDOutputType $c -TypeName 'Bool' | Should -BeTrue
    }
} 
```

## Credits

# Pester
I have to give a shoutout to the amazing [Pester project](https://github.com/pester/Pester). It's the absolutly best tool to ensure your PowerShell code does what you intended. It's super easy and intuitive to get started with, and if you get into the habit of writing those tests first, you get all the benefits of Test Driven Development.

# Adam Driscoll
Big thank you to [Adam Driscoll](https://github.com/adamdriscoll) whos [How to Publish a PowerShell Module to the PowerShell Gallery tutorial video](https://www.youtube.com/watch?v=TdWWUOJ4s7A) helped a lot when i decided to make TDDUtils publicly available.