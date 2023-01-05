@echo off

echo checking connectivity of Master worker and Database
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'C:\Temp\connectivityCheck.ps1'"

echo ------------------------------------------------------
echo running postdeployment script on Master and Remote Workers
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'C:\Temp\hostPost.ps1'"

TIMEOUT /T 10


echo checking Health(services) of different applications....
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'C:\Temp\servicesCheck.ps1'"


echo Checking sharePath access and VersionConsistency of all deployed components....
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'C:\Temp\sharePathAccessCheck.ps1'"




 
