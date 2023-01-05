# checking connectivity of database and master worker
  

$server = Get-content "C:\Temp\serverlist.json" -Raw |ConvertFrom-Json | Where-Object { $_ }

 
# To check database connectivity

 Write-Host "------------------------------------------------"
$Database=test-connection $server.'ICE Database' -Quiet
if($Database -eq $true)
{
Write-Host ($server.'ICE Database') : "Database connectivity is up" -ForegroundColor Magenta
}
else{

Write-Host "Database connectivity is down"}

Write-Host "--------------------------------------------"

## To Check Master worker connectivity
$MasterConnectivity=test-connection $server.'Master worker' -Quiet
if($MasterConnectivity -eq $true)
{
Write-Host ($server.'Master worker'):" Master Worker connectivity is up" -ForegroundColor Magenta

Write-Host "------------------------------------------"


}
else{

Write-Host ($server.'Master worker'):"Master worker connectivity is down" -ForegroundColor Red

}