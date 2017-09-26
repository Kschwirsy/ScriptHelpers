###################################################
# 
#     Check if process is running. If so, kill process
#
###################################################

param(
    [string] $processName
)

# Check if process is already running 
if(get-process | ?{$_.path -eq $processName}){
    Stop-Process -processname $processName
    Write-Host "$processName was running. Stopping this process."
} else {
    Write-host "$processName is not running"
}