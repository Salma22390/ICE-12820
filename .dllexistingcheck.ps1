

 ## To read Directory paths json file  copied to all servers
$json = Get-Content "C:\Users\DirectoryPath.json" -Raw | ConvertFrom-Json


# To read all file/dlls within a folder and listing that in .txt format.
 get-childitem($json.Console) -include *.dll -recurse | where {!$_.PSIsContainer} |  foreach-object -process {$_.FullName} >>postDeploymentConsoleFile.txt
 get-childitem($json.API) -include *.dll -recurse | where {!$_.PSIsContainer} |  foreach-object -process {$_.FullName} >>postDeploymentConsoleFile.txt
  get-childitem($json.Worker) -include *.dll -recurse | where {!$_.PSIsContainer} |  foreach-object -process {$_.FullName} >>postDeploymentConsoleFile.txt


.\postDeploymentConsoleFile.txt


$PostCount = Get-Content .\postDeploymentConsoleFile.txt | Measure-Object 
$Count = $PostCount.Count


# Compare two text file and generate the report in .csv(True nd False)
$list1=(Get-Content .\preDeploymentConsoleFile.txt)

$list2=(Get-Content .\postDeploymentConsoleFile.txt)

$FullList= $List1 + $Lis2 

$report = @()
$report1 = @()

foreach($item in $FullList)
{
if($List1.Contains($item)){

$ExistsInlist1=$true
	
}

else{

$ExistsInlist1=$false
}

if($List2.Contains($item)){

$ExistsInlist2=$true
}

else{

$ExistsInlist2=$false
}

$report+= New-Object psobject -Property @{Item=$item; List1=$ExistsInlist1;List2=$ExistsInlist2}
}

$report | select Item, List1, List2 | Export-Csv -Path Report.csv -NoTypeInformation



.\Report.csv


$PresentFiles=Import-csv .\Report.CSV | Where-Object {$_.List2 -eq 'TRUE'} |foreach-object -process {$_.item} >>presentFiles.txt


$missingFiles=Import-csv .\Report.CSV | Where-Object {$_.List2 -eq 'FALSE'} |foreach-object -process {$_.item} >> missingFiles.txt

./presentFiles.txt

./missingFiles.txt

# count numbers(total, present and missing .dll files)


$measure = Get-Content  .\presentFiles.txt| Measure-Object 
$presentFilesCount = $measure.Count


$measure1 = Get-Content  .\missingFiles.txt| Measure-Object
$missingFilesCount = $measure1.Count

Write-Host "'$Count' .dll files are validated" -ForegroundColor DarkGreen


Write-Host "'$presentFilesCount' .dll files are present" -ForegroundColor DarkGreen

Write-Host "Missing .dll Files count is": (Get-Content .\missingFiles.txt).Length -ForegroundColor DarkGreen



if((Get-Content .\missingFiles.txt).Length -eq '0')
{
Write-Host "Success- All files are present" -ForegroundColor DarkMagenta
}
else
{
Write-Host "Failed: some dll files are missing check .\MissingFiles.txt from server" -ForegroundColor DarkMagenta
}

 Write-Host "---------------------------------------------------------------"