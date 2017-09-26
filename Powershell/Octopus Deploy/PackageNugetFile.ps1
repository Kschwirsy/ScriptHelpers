param(
    [string] $executionDirectory,
    [string] $projectName, 
    [string] $version,
	[string] $branch, 
	[string] $nuspecFileName
)

Write-Host "Packing project exe and supporting files into Nuget package";
$args = @()
$args += ("-NuSpecFilePath", "{0}\{1}\{2}\{3}" -f $executionDirectory, $projectName, $branch, $nuspecFileName)
$args += ("-Version", $version)
$args += ("-PackOptions", "'-Build -OutputDirectory {0}'" -f "{0}\{2}\{1}" -f $executionDirectory, $branch, $projectName)
$args += ("-NoPrompt", "")
$args += ("-NuGetExecutableFilePath", "{0}\VFPBuildScripts\TFSPackagingScripts\NuGet.exe" -f $executionDirectory)
$cmd = "{0}\VFPBuildScripts\TFSPackagingScripts\New-NuGetPackage.ps1" -f $executionDirectory

Invoke-Expression "$cmd $args"