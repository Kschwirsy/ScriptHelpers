###################################################
# 
#     Read and print out provided error logs 
#
###################################################

param(
    [string[]] $listOfLogFileNames,
    [string] $filesDirectoryLocation
)




$listOfLogs | foreach {

$testPath = "{0}{1}" -f $filesDirectoryLocation, $_

Write-Host "Checking for Error Log: " $testPath
$testRestult = Test-Path $testPath

if($testRestult){
    Write-Host "Listed below is a readout from the Log File:"
    Write-Host " "

    $errorContents = Get-Content -Path $testPath
    Write-Host $errorContents
    
    Set-OctopusVariable -name "ErrorFileName" -value $_
    Set-OctopusVariable -name "ErrorLogContents" -value $errorContents
    Set-OctopusVariable -name "ErrorFilePath" -value $testPath
    
    exit -1
  }  
}   

Write-Host "No error log found";