Param(
    [Parameter(Mandatory = $true)]
    [String]$ModuleName,
    [Parameter(Mandatory = $true)]
    [string]$SourcePath
)

Function Get-ModuleVersion {

    [Parameter(Mandatory = $true)]
    [type]$P

}

$ModuleRootFolder = "$(($Env:PSModulePath -split  ';')[1])\$ModuleName"
Write-Verbose "ModuleRootFolder = $ModuleRootFolder"
$ModuleFolderExists = Test-Path $ModuleRootFolder
if ($ModuleFolderExists) {



}