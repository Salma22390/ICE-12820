@echo off

echo checking connectivity of master worker and Database
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'C:\Temp\connectivityCheck.ps1'"

echo running predeployment script on Master and Remote Workers
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'C:\Temp\hostPre.ps1'"






 
