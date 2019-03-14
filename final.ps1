<#
Your script should process each of the given .txt files and check to see if the .txt file's MD5 hash matches the content of it's corresponding .md5 file
So in the case of brown.txt and brown.md5 you should calculate the MD5 hash of brown.txt and see if it matches the content of brown.md5

If a file's hash does not match, print "Invalid file: $filename" to the console (so in this case it would print "Invalid file: brown.txt), then write that file's name to a new file: invalid.txt
Comment your script sensibly, highlighting what each logical block of code in your script is doing
#>
$txtFiles = Get-ChildItem "C:\Users\david.king\Documents\IT 120\Final\*.txt"

foreach($file in $txtFiles){
    $fileHash = Get-FileHash $file -Algorithm MD5
    
    $noExtension,$extension = $file.Name -Split(".txt")  
    $checkSum = Get-Content "$noExtension.md5"

    if($checkSum -ne $fileHash.Hash){
        Write-Host "Invalid file: $file.Name"
        Add-Content -Path invalid.txt -Value $file.Name 
    }
    #$file.Name + " " + $fileHash.Hash
    #"$noExtension.md5" + " " + $checkSum
}