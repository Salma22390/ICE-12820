$json = Get-Content "C:\Users\DirectoryPath.json" -Raw | ConvertFrom-Json



# To read all file/dlls within a folder and listing that in .txt format.
 get-childitem($json.Console) -include *.dll -recurse | where {!$_.PSIsContainer} |  foreach-object -process {$_.FullName} >>preDeploymentConsoleFile.txt
 get-childitem($json.API) -include *.dll -recurse | where {!$_.PSIsContainer} |  foreach-object -process {$_.FullName} >>preDeploymentConsoleFile.txt
  get-childitem($json.Worker) -include *.dll -recurse | where {!$_.PSIsContainer} |  foreach-object -process {$_.FullName} >>preDeploymentConsoleFile.txt


.\preDeploymentConsoleFile.txt

$PostCount = Get-Content .\postDeploymentConsoleFile.txt | Measure-Object 
$Count = $PostCount.Count

Write-Host "Total .dll file count is $Count" -ForegroundColor DarkGreen