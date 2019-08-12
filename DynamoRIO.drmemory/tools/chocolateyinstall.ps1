$ErrorActionPreference = 'Stop'
 
$packageName = 'DynamoRIO.drmemory'
$url = 'https://github.com/DynamoRIO/drmemory/releases/download/release_2.2.0/DrMemory-Windows-2.2.0-1.zip'
$checksum = 'FB94511F05375B669F7EE90F374483E2EB199B82004404753FE10A895CA4D9C4'
$checksumType = 'sha256'
$installDir = Split-Path -parent $MyInvocation.MyCommand.Definition
 
Install-ChocolateyZipPackage -PackageName $packageName `
                             -Url $url `
                             -UnzipLocation $installDir `
                             -Checksum $checksum `
                             -ChecksumType $checksumType

# the zip contains a subdir, we need something to point to the root of the installation
$DrMemDir = Join-Path $installDir "DrMemory-Windows-2.2.0-1"

# The package contains both 32 and 64 bit executables
# Depending on the OS we need to make sure we create shims for the correct bitness
if ([Environment]::Is64BitOperatingSystem)
{
    $filesToShim = get-childitem "$DrMemDir\bin64" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\bin64" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\tools\bin64" -include *.exe -recurse
}
else
{
    $filesToShim = get-childitem "$DrMemDir\bin" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\bin32" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\tools\bin32" -include *.exe -recurse
}

# get all exe files
$files = get-childitem $DrMemDir -include *.exe -recurse

# get all files we don't want to create shims for
$filesToIgnore = $files | Where-Object { $_.FullName -NotIn $filesToShim.FullName }

# create the ignore files
$filesToIgnore | ForEach-Object { New-Item "$($_.FullName).ignore" -Type File -Force | Out-Null }
