$server = Get-content "C:\Temp\serverlist.json" -Raw |ConvertFrom-Json | Where-Object { $_ }
$hostName=$server.'Master Worker'



## Share Path Access check
for ($var = 1; $var -le 5; $var++)
{

If($var -eq 1){
Write-Host "\\$hostName\Project"
 
$Body=@{
#Write-Host "PROJECT"
fullpath="\\$hostName\projects"}
}

 Write-Host "--------------------------------"


If($var -eq 2){
Write-Host "\\$hostName\\PRIMARY"
$Body=@{
fullpath= "\\$hostName\PRIMARY"}
}

If($var -eq 3){
Write-Host "\\$hostName\SECONDARY"
$Body=@{

fullpath= "\\$hostName\SECONDARY"}
}

If($var -eq 4){
Write-Host "\\$hostName\PROCESSING"
$Body=@{

fullpath= "\\$hostName\PROCESSING"}
}


If($var -eq 5){
Write-Host "\\$hostName\export"
$Body=@{

 

fullpath= "\\$hostName\export"}
}
 

$Parameters = @{
    Method = "POST"
    Uri = "http://$hostName.consiliotest.com:4080/api/v2/check/ioreadwrite" 
    Body=($Body |ConvertTo-json)

 


    ContentType = "application/json"
}

 
Invoke-RestMethod @Parameters
Start-Sleep 5

}

 Write-Host "-------------------------------"

# Version consistency check
$Parameters1 = @{
    Method = "GET"
    Uri = "http://$hostName.consiliotest.com:4080/api/v2/about" 
    
  
 
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters1

$version= Invoke-RestMethod @Parameters1

$version| select component, version | Export-Csv -Path version1.csv -NoTypeInformation
.\version1.csv



# to check all component versions are same or not
$csvItems = Import-Csv ./version1.csv

## checking all components version same or not
#To check Reading version from json file and comparing with .csv file


foreach($item in $csvItems.version)
{
if($server.version -eq $item)
{

$meetCriteria=$true
}
else
{
$meetCriteria=$false}

}
if($meetCriteria -eq $true){


Write-Host "All deployed component versions are same" -ForegroundColor DarkGreen -BackgroundColor White
}

else
{ 
Write-Host " some components versions are incorrect, check ./version.csv file" -ForegroundColor DarkGreen -BackgroundColor White
 }

 
 