# Set-FolderLocation creates a Windows folder browser in order to capture user input for the folder containing .txt and .md5 files
function Set-FolderLocation{
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = 'Select the folder containing .txt/.md5 files'
    # $result attempts to make the folder browser the top-most element on the screen
    $result = $folderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))

    if($result -eq [Windows.Forms.DialogResult]::OK){
        $folderBrowser.SelectedPath
    }
    else {
        exit
    }
}

# Refine folder location into variables
$folder = Set-FolderLocation
$invalidPath = $folder + '\invalid.txt'
$files = $folder | Get-ChildItem
$fileNames = $files.Name
$txtFiles = @()

# Add only .txt files to the $txtFiles array
foreach($f in $fileNames){
    $filePath = $folder + '\' + $f
    $extension = [IO.Path]::GetExtension($f)
    if($extension -eq '.txt'){
        $txtFiles += $filePath 
    }
}

# If invalid.txt exists then clear contents
if(Test-Path -Path $invalidPath -PathType Leaf){Clear-Content -Path $invalidPath}

# Loop through each .txt file and get the MD5 sum
foreach($f in $txtFiles){
    # If invalid.txt is $f skip this loop
    if($f -eq $invalidPath){continue}

    $fileHash = Get-FileHash $f -Algorithm MD5
    $fileHash = $fileHash.Hash
    # Switch file from $f.txt to $f.md5
    $sumFile = $f.Replace('.txt', '.md5')
    $checkSum = Get-Content $sumFile

    # Compare checksums
    if($fileHash -ne $checkSum){
        Write-Host "Invalid file: $f"
        Add-Content -Path $invalidPath -Value $f
    }
}