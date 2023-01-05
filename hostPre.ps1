Set-ExecutionPolicy unrestricted
Enable-PSRemoting -Force

$server = Get-content "C:\Temp\serverlist.json" -Raw |ConvertFrom-Json | Where-Object { $_ }

#reading service account username and asking password as a prompt

$username = $server.username
$password =  Read-Host 'Enter the password of service account' -AsSecureString
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)



$DirectoryPathsJson= "C:\Temp\DirectoryPath.json"
$dest= 'C:\Users\'



# copy installationPaths json file to master server


$masterSession = New-PSSession -ComputerName $server.'Master Worker' -Credential $cred

Write-Host " running script on" $server.'Master Worker'
##Copy-Item $DirectoryPathsJson -Destination $dest -ToSession $masterSession
Invoke-Command -Session $masterSession -Filepath "C:\Temp\predeployment.ps1"

#copying installationPaths json file to all remote server

$remoteSessions = New-PSSession -ComputerName  $server.'Remote Workers' -Credential $cred

foreach($remote in $remoteSessions){

Write-Host " running scipt on remote server": $remote.ComputerName

Copy-Item $DirectoryPathsJson -Destination $dest -ToSession $remote
Start-Sleep -Seconds 3
 Invoke-Command -Session $remote -Filepath "C:\Temp\predeployment.ps1"
}