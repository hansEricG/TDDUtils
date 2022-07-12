function Invoke-TDDInCmdlet {
    <#
    .SYNOPSIS
    Invokes the given code in the context of a cmdlet.

    .DESCRIPTION
    This command invokes the given code in the context of a cmdlet. This is useful in a testing scenario where, for example, 
    you want to ensure that the auto variable $PSCmdlet is set. 
    
    .PARAMETER Code
    The script block to be invoked by the function.
        
    .EXAMPLE
    A Pester test that relies on the $PSCmdlet variable

    It 'Should not Invoke the code and should return $false if Invoke-TDDShouldProcess returns $false' {

        function DummyFunction {
        }

        Mock DummyFunction { }
        Mock Invoke-TDDShouldProcess { $false }
        
        Invoke-TDDInCmdlet {
            # Ensures the below code under test has access to a defined $PSCmdlet 
            Invoke-TDDShouldProcessCode -Context $PSCmdlet -Target 'Target' -Operation 'Operation' -Code { DummyFunction } | Should -BeFalse
        }

        Should -Not -Invoke DummyFunction
    }
    
    .LINK
    This issue record and its comments explains the problem and the solution on which this function is based.
    
    https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [scriptblock] $Code
    )

    $Code.Invoke()
}