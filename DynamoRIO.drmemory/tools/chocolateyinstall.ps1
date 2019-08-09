$ErrorActionPreference = 'Stop';
 
$packageName = 'DynamoRIO.drmemory'
$url = 'https://github.com/DynamoRIO/drmemory/releases/download/cronbuild-2.0.17918/DrMemory-Windows-1.11.17918-1.zip'
$checksum = 'A3C818014F43105674BDECC4DA1C98A126EC20D3612266DAE24CE475769D3753'
$checksumType = 'sha256'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
 
Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType"