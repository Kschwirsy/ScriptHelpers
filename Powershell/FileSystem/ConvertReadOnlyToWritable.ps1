###################################################
# 
#     Convert read-only directory to have write permissions
#     Running service account must have rights to the directory
#
###################################################

param(
    [string] $permissionsDirectory
)

Write-Host "Converting build directory to Write permissions - Start"

Get-ChildItem $buildDirectory -Recurse |
    Where-Object {$_.GetType().ToString() -eq "System.IO.FileInfo"} |
    Set-ItemProperty -Name IsReadOnly -Value $false

Write-Host "Converting build directory to Write permissions - Complete"

