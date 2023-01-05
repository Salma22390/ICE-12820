

$server = Get-content "C:\Temp\serverlist.json" -Raw |ConvertFrom-Json | Where-Object { $_ }

#reading service account username and asking password as a prompt

$username = $server.username
$password =  Read-Host 'Enter the password of service account' -AsSecureString
$Cred = New-Object System.Management.Automation.PSCredential ("username", $password)



# to get Master Worker services

Write-Host " Master Worker": $server.'Master Worker'

$Master=Get-WMIObject -Credential $cre -ComputerName $server.'Master Worker' -Query "Select * From Win32_Service WHERE Name Like 'ICE%'" | 
ft @{Label="Host";Expression= {$_.SystemName }},@{Label="ServiceName";Expression= {$_.Name }},Status,State 

#printing output in console
$Master

#printing output in console
$Master| Out-File -Append .\servives.txt -Force

Write-Host "----------------------------------------" 
 
 ## To get the all Remote worker services
foreach($args in $server.'Remote Workers')

{
Write-Host " $args machine services"
Start-Sleep 3
$remoteServices=Get-WMIObject -Credential $cre -ComputerName $args -Query "Select * From Win32_Service WHERE Name Like 'ICE%'" | 
ft @{Label="Host";Expression= {$_.SystemName }},@{Label="ServiceName";Expression= {$_.Name }},Status,State 

#To Print output in console
$remoteServices

#To Export output in .txt file
$remoteServices | Out-File -Append .\servives.txt -Force

Write-Host "----------------------------------------"
}

# To open output file
.\servives.txt
