function Get-TDDParamBlockAttribute {
    [OutputType([System.Management.Automation.Language.AttributeAst])]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]
        $Command,

        [Parameter(Mandatory)]
        [string]
        $AttributeName
    )

    $attribute = $command.ScriptBlock.Ast.Body.ParamBlock.Attributes | where-object { $_.TypeName.FullName -eq $AttributeName };
    $attribute
}