###################################################
# 
#     Start a process with a timeout and error handling
#
###################################################

param(
    [string] $processDirectory,
    [string] $processExe,
    [string] $timeoutLimit
)

Write-Host "$processExe - Start"
cd $processDirectory

# Optional argument list if neccessary ############

#$buildConfig = "-c" + $buildDirectory + "build.fpw" 
#$proc = Start-Process -FilePath $processExe -ArgumentList "$buildConfig" -PassThru

$proc = Start-Process -FilePath $processExe -PassThru

##################################################
# Wait for the process to complete before proceeding.
#
# Timeout is set in milliseconds.  If build exceeds timeout limit the build proc process will be killed
# to prevent blockage of future release requests.
##################################################

if(!$proc.WaitForExit($timeoutLimit)) {
    $proc.Kill();
    Write-Host "The process took longer than $timeoutLimit MS to compelte."
    Write-Host "The build process has been stopped. Please check the build machine for any errors or consider raising the timeout limit for this build." 

    exit -1
}

Write-Host "Process - End"
