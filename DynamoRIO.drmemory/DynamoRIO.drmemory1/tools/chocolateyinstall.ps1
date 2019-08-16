$ErrorActionPreference = 'Stop'
 
$packageName = 'DynamoRIO.drmemory'
$url = 'https://github.com/DynamoRIO/drmemory/releases/download/release_1.11.0/DrMemory-Windows-1.11.0-2.zip'
$checksum = 'BAB2AE2A59238DE29B6B12E0CAC9F1F9B97328F9DE2CE5DA76D397DBBB2B8872'
$checksumType = 'sha256'
$installDir = Split-Path -parent $MyInvocation.MyCommand.Definition
 
Install-ChocolateyZipPackage -PackageName $packageName `
                             -Url $url `
                             -UnzipLocation $installDir `
                             -Checksum $checksum `
                             -ChecksumType $checksumType

# the zip contains a subdir, we need something to point to the root of the installation
$DrMemDir = Join-Path $installDir "DrMemory-Windows-1.11.0-2"

# The package contains both 32 and 64 bit executables
# Depending on the OS we need to make sure we create shims for the correct bitness
if ((Get-OSArchitectureWidth 32) -or $env:ChocolateyForceX86)
{
    #32 bit
    $filesToShim = get-childitem "$DrMemDir\bin" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\bin32" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\tools\bin32" -include *.exe -recurse
}
else
{
    # 64 bit
    $filesToShim = get-childitem "$DrMemDir\bin64" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\bin64" -include *.exe -recurse
    $filesToShim += get-childitem "$DrMemDir\dynamorio\tools\bin64" -include *.exe -recurse
}

# get all exe files
$files = get-childitem $DrMemDir -include *.exe -recurse

# get all files we don't want to create shims for
$filesToIgnore = $files | Where-Object { $_.FullName -NotIn $filesToShim.FullName }

# create the ignore files
$filesToIgnore | ForEach-Object { New-Item "$($_.FullName).ignore" -Type File -Force | Out-Null }
