BeforeAll {
    # Suppress the PSUseDeclaredVarsMoreThanAssignments warning since it's not correct here.
    # Info on suppressing PSScriptAnalyzer rules can be found here:
    # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/README.md#suppressing-rules
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $ModuleName = 'PSTestUtils'
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $ModulePath = Join-Path $PSScriptRoot ..\$ModuleName\ -Resolve 
}

Describe 'PSTestUtils Module' {
    
    Context 'Setup' {
        It 'Should have a root module file (psm1)' {
            "$ModulePath\$ModuleName.psm1" | Should -Exist
        }

        It 'Should have a manifest file (psd1)' {
            "$ModulePath\$ModuleName.psd1" | Should -Exist
        }

        It 'Should have valid powershell code' {
            $content = Get-Content -Path "$ModulePath\$ModuleName.psm1"
            $content | Should -Not -BeNullOrEmpty
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$errors)
            $errors.Count | Should -Be 0
        }

    }

    Context 'Functions'{
        # BeforeAll {
        #     # Suppress the PSUseDeclaredVarsMoreThanAssignments warning since it's not correct here.
        #     # Info on suppressing PSScriptAnalyzer rules can be found here:
        #     # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/README.md#suppressing-rules
        #     [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        #     $PublicFunctionFiles = Get-Item "$ModulePath/Public/*.ps1"
        # }

        $ModuleName = 'PSTestUtils'
        $ModulePath = Join-Path $PSScriptRoot ..\$ModuleName\
        $PublicFunctionFiles = Get-Item "$ModulePath/Public/*.ps1"
        foreach ($FunctionFile in $PublicFunctionFiles) {
            It "Public function file '$($FunctionFile.Name)' should have valid powershell code"  -TestCases @(
                @{
                    FunctionFile = $FunctionFile 
                }
            ) {
                $content = Get-Content -Path $FunctionFile.PSPath
                $content | Should -Not -BeNullOrEmpty
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$errors)
                $errors.Count | Should -Be 0
            }

            It "Public function file '$($FunctionFile.Name)' should have a corresponding test file"  -TestCases @(
                @{
                    FunctionFile = $FunctionFile 
                }
            ) {
                "$ModulePath\..\Tests\$($FunctionFile.BaseName).Tests.ps1" | Should -Exist
            }

            It "Public function '$($FunctionFile.Name)' should be dot sourced and exported"  -TestCases @(
                @{
                    FunctionFile = $FunctionFile 
                }
            ) {
                $ModuleContent = Get-Content -Path "$ModulePath\$ModuleName.psm1"

                $ModuleContent | Should -Contain ". `$PSScriptRoot\Public\$($FunctionFile.Name)"
                $ModuleContent | Should -Contain "Export-ModuleMember $($FunctionFile.BaseName)"
            }

            It "Public function '$($FunctionFile.Name)' should have a help block!" -TestCases @(
                @{
                    FunctionFile = $FunctionFile 
                }
            ) {
                    $FunctionFile.PSPath | Should -FileContentMatch  '<#'
                    $FunctionFile.PSPath | Should -FileContentMatch  '#>'
                    $FunctionFile.PSPath | Should -FileContentMatch  '.SYNOPSIS'
                    $FunctionFile.PSPath | Should -FileContentMatch  '.DESCRIPTION'
                    $FunctionFile.PSPath | Should -FileContentMatch  '.EXAMPLE'
            }

            It "Public function '$($FunctionFile.Name)' should be an advanced function"  -TestCases @(
                @{
                    FunctionFile = $FunctionFile 
                }
            ) {
                    $FunctionFile.PSPath | Should -FileContentMatch 'function'
                    $FunctionFile.PSPath | Should -FileContentMatch 'cmdletbinding'
                    $FunctionFile.PSPath | Should -FileContentMatch 'param'
            }
            
            # It "Public function '$($FunctionFile.Name)' should contain verbose messages" {
            #         $FunctionFile.PSPath | Should -FileContentMatch 'Write-Verbose'
            # }

        }

        # It 'All public functions should have valid powershell code' {
        #     foreach ($FunctionFile in $PublicFunctionFiles) {
        #         $content = Get-Content -Path $FunctionFile.PSPath
        #         $content | Should -Not -BeNullOrEmpty
        #         $errors = $null
        #         $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$errors)
        #         $errors.Count | Should -Be 0
        #     }
        # }

        # It "All public function files should have a corresponding test file"  {
        #     $PublicFunctionFiles | foreach-object { "$ModulePath\Tests\$($_.BaseName).Tests.ps1" } | Should -Exist
        # }

        # It "All public functions should be dot sourced and exported"  {
        #     $ModuleContent = Get-Content -Path "$ModulePath\$ModuleName.psm1"

        #     foreach ($FunctionFile in $PublicFunctionFiles) {
        #         $ModuleContent | Should -Contain ". `$PSScriptRoot\Public\$($FunctionFile.Name)"
        #         $ModuleContent | Should -Contain "Export-ModuleMember $($FunctionFile.BaseName)"
        #     }
        # }

        # It 'All public functions should have a help block' {
        #     foreach ($FunctionFile in $PublicFunctionFiles) {
        #         $FunctionFile.PSPath | Should -Contain '<#'
        #         $FunctionFile.PSPath | Should -Contain '#>'
        #         $FunctionFile.PSPath | Should -Contain '.SYNOPSIS'
        #         $FunctionFile.PSPath | Should -Contain '.DESCRIPTION'
        #         $FunctionFile.PSPath | Should -Contain '.EXAMPLE'
        #     }
        # }

        # It 'All public functions should be advanced functions' {
        #     foreach ($FunctionFile in $PublicFunctionFiles) {
        #         $FunctionFile.PSPath | Should -FileContentMatch 'function'
        #         $FunctionFile.PSPath | Should -FileContentMatch 'cmdletbinding'
        #         $FunctionFile.PSPath | Should -FileContentMatch 'param'
        #     }
        # }
        
        # It 'All public functions should contain verbose messages' {
        #     foreach ($FunctionFile in $PublicFunctionFiles) {
        #         $FunctionFile.PSPath | Should -FileContentMatch 'Write-Verbose'
        #     }
        # }

    }
}