Write-Host "Cleanup Script"

# DISM cleanup
Dism.exe /online /Cleanup-Image /StartComponentCleanup

$DateLimit = (Get-Date).AddDays(-1)

$userDirs = Get-ChildItem -Path "C:\Users" -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName

foreach($userDir in $userDirs) {
    # Clear local temp
    $tempDir = "$($userDir.FullName)\AppData\Local\Temp"

    if(Test-Path -Path $tempDir) {
        Get-ChildItem -Path $tempDir -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $DateLimit } | Remove-Item -Force
        Get-ChildItem -Path $tempDir -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
    }

    # Clear chrome cache
    $googleDir = "$($userDir.FullName)\AppData\Local\Google\Chrome\User Data\Default"

    if(Test-Path "$($googleDir)\Cache") {
        Remove-Item -Path "$($googleDir)\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
    }

    if(Test-Path "$($googleDir)\History") {
        Remove-Item -Path "$($googleDir)\History" -Force -EA SilentlyContinue -Verbose
    }

    if(Test-Path "$($googleDir)\Favicons") {
        Remove-Item -Path "$($googleDir)\Favicons" -Force -EA SilentlyContinue -Verbose
    }

    # Clear edge cache
    $edgeDir = "$($userDir.FullName)\AppData\Local\Microsoft\Edge\User Data\Default"

    if(Test-Path "$($edgeDir)\Cache") {
        Remove-Item -Path "$($edgeDir)\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
    }

    if(Test-Path "$($edgeDir)\History") {
        Remove-Item -Path "$($edgeDir)\History" -Force -EA SilentlyContinue -Verbose
    }

    if(Test-Path "$($edgeDir)\Favicons") {
        Remove-Item -Path "$($edgeDir)\Favicons" -Force -EA SilentlyContinue -Verbose
    }

    # Clear ie cache
    $ieDir = "$($userDir.FullName)\AppData\Local\Microsoft\Windows\INetCache\IE"

    if(Test-Path $ieDir) {
        Remove-Item -Path "$($ieDir)\*" -Recurse -Force -EA SilentlyContinue -Verbose
    }
        
    # Clear thumb cache
    Remove-Item -Path "$($userDir.FullName)\AppData\Local\Microsoft\Windows\Explorer\thumbcache*.db" -Force -EA SilentlyContinue -Verbose
}

# Clear temp
Get-ChildItem -Path "C:\Windows\Temp" -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $DateLimit } | Remove-Item -Force
Get-ChildItem -Path "C:\Windows\Temp" -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

# Clear recycle bin
Remove-Item -Path "C:\`$Recycle.Bin\" -Recurse -Force -EA SilentlyContinue -Verbose

# Clear internet files
Get-ChildItem -Path "C:\Windows\Downloaded Program Files" -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $DateLimit } | Remove-Item -Force
Get-ChildItem -Path "C:\Windows\Downloaded Program Files" -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse