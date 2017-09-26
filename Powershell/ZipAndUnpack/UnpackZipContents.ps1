param(
    [string] $stagingDir,
    [string] $fileName,
    [string] $srcFolder
)

Write-host "Looking for file: " + $fileName + " in directory: " + $stagingDir
$zipPath = $stagingDir+"\"+$fileName;

#Test if file exists, if it does proceed.  Otherwise return error code.
if(Test-Path $zipPath) {
    
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    #Test if staging directory exitst, if not create it
    if(-NOT (Test-Path ("{0}\OutputStage" -f $stagingDir))){
        Write-Host "Created Output Stage Folder"
        New-Item ("{0}\OutputStage" -f $stagingDir) -type directory
    } else {
        Remove-Item ("{0}\OutputStage\*" -f $stagingDir)
    }

    #Test if output directory exitst, if not create it
    if(-NOT (Test-Path ("{0}\Output" -f $stagingDir))){
        New-Item ("{0}\Output" -f $stagingDir) -type directory
        Write-Host "Created Output Folder"
    } else {
        Remove-Item ("{0}\Output\*" -f $stagingDir)
    } 

    Write-Host "Unzipping build package"
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $stagingDir+"\\OutputStage")

    #Check if target folder is nested within the unzipped folder. If so, locate that folder and copy from there.  If not, copy out of the staging folder.
    if($srcFolder) {
        $packagePath =  ls $stagingDir"\OutputStage" $srcFolder -Recurse -Directory 
        Write-Host "Copying to output directory."
        Copy-Item ("{0}\*" -f $packagePath.Parent.FullName) ("{0}\Output" -f $stagingDir) -Recurse
    } else {
        Write-Host "Copying to output directory."
        Copy-Item ("{0}\OutputStage\*" -f $stagingDir) ("{0}\Output" -f $stagingDir) -Recurse
    }
    
} else {
    write-host "File not found"
    exit -1;
}