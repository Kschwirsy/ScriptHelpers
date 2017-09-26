#######################################################
#
#    Description: Remove all files matching the regex input string and are older than the number of specified days
#    NOTE: Days input must be negative (-14 for two weeks) otherwise all matching files will be removed.
#
#######################################################

#Parameters
param(
    [string] $cleanDirectory,
    [string] $expirationDays,
    [string] $filePrefix
)

$limit = (Get-Date).AddDays($expirationDays)

if($limit -gt (Get-Date)) {
    Write-Host "Expiration days must be set to a negative number. For example: -14 for 2 weeks"
    Write-Host "The current value is: $ExpirationDays";
    exit -1;
}

Write-Host "Looking for $filePrefix"

#Find all versions of file that is older than the days specified
$oldFiles = Get-ChildItem $cleanDirectory | WHERE {$_.Name -like $filePrefix -and $_.CreationTime -lt $limit}

Write-Host "Removing the following files as they're more than $ExpirationDays days old"

if($oldFiles) {
    foreach($file in $oldFiles){
        Write-Host $file.Name
        $removePath = "{0}\{1}" -f $cleanDirectory, $file.Name

		$removeErrors = @();

        Remove-Item $removePath -ErrorAction SilentlyContinue -ErrorVariable removeErrors;
		$removeErrors | where-object { Write-Host $_.Exception.Message }
    }
} else {
    Write-Host "There were no files to clean up."
}