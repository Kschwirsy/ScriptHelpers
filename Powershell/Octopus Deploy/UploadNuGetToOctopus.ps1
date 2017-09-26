param(
    [string] $executionDirectory,
    [string] $projectName, 
    [string] $version,
	[string] $branch,
    [string] $octopusUrl,
    [string] $apiKey
)

# 2. An API key, preferably for a Service Account (http://docs.octopusdeploy.com/display/OD/Service+Accounts)
# 3. Path to the package file to upload
$packageFilePath = "{0}\{2}\{3}\{2}-{3}.{1}.nupkg" -f $executionDirectory, $version, $projectName, $branch;

# 4. true to overwrite existing packages (Requires: BuiltInFeedAdminister permission)
$replaceExisting = $true;
$packageUrl = $octopusUrl + "/api/packages/raw?replace=" + $replaceExisting;

Write-Host Uploading $packageFilePath to $packageUrl;

$webRequest = [System.Net.HttpWebRequest]::Create($packageUrl);
$webRequest.Accept = "application/json";
$webRequest.ContentType = "application/json";
$webRequest.Method = "POST";
$webRequest.Headers["X-Octopus-ApiKey"] = $apiKey;

$proxy = New-Object System.Net.WebProxy("http://proxy:80",$true)
$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
$webRequest.proxy= $proxy

$packageFileStream = new-object IO.FileStream $packageFilePath,'Open','Read','Read'

    $boundary = "----------------------------" + [System.DateTime]::Now.Ticks.ToString("x");
    $boundarybytes = [System.Text.Encoding]::ASCII.GetBytes("`r`n--" + $boundary + "`r`n")
    $webRequest.ContentType = "multipart/form-data; boundary=" + $boundary;
    $webRequest.GetRequestStream().Write($boundarybytes, 0, $boundarybytes.Length);

    $header = "Content-Disposition: form-data; filename="""+ [System.IO.Path]::GetFileName($packageFilePath) +"""`r`nContent-Type: application/octet-stream`r`n`r`n";
    $headerbytes = [System.Text.Encoding]::ASCII.GetBytes($header);
    $webRequest.GetRequestStream().Write($headerbytes, 0, $headerbytes.Length);
    $packageFileStream.CopyTo($webRequest.GetRequestStream());
    $webRequest.GetRequestStream().Write($boundarybytes, 0, $boundarybytes.Length);
    $webRequest.GetRequestStream().Flush();
    $webRequest.GetRequestStream().Close();

    $packageFileStream.Close();
    $packageFileStream.Dispose();


$webResponse = $webRequest.GetResponse();
$webResponse.Dispose();

$output = "Successfully uploaded package: {0}-{2}.{1}.nupkg" -f $projectName, $version, $branch;
Write-Host $output