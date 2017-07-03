#requires -Version 3


function Convert-FileEncoding {
<#
    .SYNOPSIS
    Gets file encoding.

    .DESCRIPTION
    Usage is exactly like Get-ChildItem.

    The function sets encoding on files. Results are undefined where the object is not a file.

    This runs files through Out-File. File characteristics may be lost, such as the archive bit, system or hidden flags, or alternate filestreams. 
    Binary files may no longer function as intended. File sizes may change. ACLs may change.

    By default, converts to UTF-8. (Out-File defaults to UTF-16.)

    .EXAMPLE
    Convert-FileEncoding
    
    This command converts child items in the current location to UTF-8 encoding. If the location is a file system directory, it gets the files and 
    sub-directories in the current directory. If the item does not have child items, this command returns to the command prompt without doing
    anything. Results are undefined when the item is not a file.

    .EXAMPLE
    Convert-FileEncoding –Path *.txt -Encoding Unicode -Recurse -Force
    
    This command converts the encoding of all of the .txt files in the current directory and its subdirectories to UTF-16. The Recurse parameter 
    directs Windows PowerShell to get objects recursively, and it indicates that the subject of the command is the specified directory and its 
    contents. The Force parameter includes hidden files.

    .EXAMPLE
    Convert-FileEncoding –Path C:\Windows\Logs\* -Encoding ascii -Include *.txt -Exclude A*
    
    This command converts the encoding of the .txt files in the Logs subdirectory to ASCII, except for those whose names start with the letter A. 
    It uses the wildcard character (*) to indicate the contents of the Logs subdirectory, not the directory container. Because the command does 
    not include the Recurse parameter, Convert-FileEncoding does not include the content of directory automatically; you need to specify it.

    .NOTES
    The parameter block was generated from Get-ChildItem using Indented.StubCommand, so you can use this command exactly like Get-ChildItem

    .LINK
    https://github.com/fsackur/Encoding
#>
    [CmdletBinding(DefaultParameterSetName='Items', SupportsTransactions=$true, HelpUri='https://github.com/fsackur/Encoding')]
    [OutputType([void])]
    param (
        [Parameter(ParameterSetName='Items', Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${Path},
        
        [Parameter(ParameterSetName='LiteralItems', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('PSPath')]
        [string[]]
        ${LiteralPath},
        
        [ValidateSet(   #[System.Text.Encoding] | Get-Member -Static -MemberType Property
            'ASCII',
            'BigEndianUnicode',
            'Default',
            'Unicode',
            'UTF32',
            'UTF7',
            'UTF8'
        )]
        [Parameter(Position=1)]
        [string]
        ${Encoding} = 'utf8',

        [Parameter(Position=2)]
        [string]
        ${Filter},
        
        [string[]]
        ${Include},
        
        [string[]]
        ${Exclude},
        
        [Alias('s')]
        [switch]
        ${Recurse},
        
        [uint32]
        ${Depth},
        
        [switch]
        ${Force},
        
        [switch]
        ${Name}
    )
    
    dynamicparam {
        $parameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        
        # Attributes
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Attributes", [System.Management.Automation.FlagsExpression`1[System.IO.FileAttributes]], $attributes)
        $parameters.Add("Attributes", $parameter)
        
        # Directory
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('ad', 'd')
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Directory", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("Directory", $parameter)
        
        # File
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('af')
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("File", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("File", $parameter)
        
        # Hidden
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('ah', 'h')
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Hidden", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("Hidden", $parameter)
        
        # ReadOnly
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('ar')
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("ReadOnly", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("ReadOnly", $parameter)
        
        # System
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('as')
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("System", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("System", $parameter)
        
        return $parameters
    }
    
    end {
        $null = $PSBoundParameters.Remove('Encoding')
        Get-ChildItem @PSBoundParameters | foreach {
            $Content = Get-Content $_
            $Content | Out-File $_.FullName -Encoding $Encoding
        }
    }
}



function Get-FileEncoding {
<#
    .SYNOPSIS
    Gets file encoding.

    .DESCRIPTION
    Usage is exactly like Get-ChildItem.

    The function determines encoding by looking at Byte Order Mark (BOM). Results are undefined where the object is not a file.

    .EXAMPLE
    Get-FileEncoding
    
    This command gets the encoding of child items in the current location. If the location is a file system directory, it gets the files and 
    sub-directories in the current directory. If the item does not have child items, this command returns to the command prompt without displaying
    anything. Encoding is undefined when the item is not a file.

    .EXAMPLE
    Get-FileEncoding –Path *.txt -Recurse -Force
    
    This command gets the encoding of all of the .txt files in the current directory and its subdirectories. The Recurse parameter directs Windows 
    PowerShell to get objects recursively, and it indicates that the subject of the command is the specified directory and its contents. The Force 
    parameter adds hidden files to the display.
    
    To use the Recurse parameter on Windows PowerShell 2.0 and earlier versions of Windows PowerShell, the value use the Path parameter must be a 
    container. Use the Include parameter to specify the .txt file type. For example, Get-FileEncoding –Path .\* -Include *.txt -Recurse

    .EXAMPLE
    Get-FileEncoding –Path C:\Windows\Logs\* -Include *.txt -Exclude A*
    
    This command gets the encoding of  the .txt files in the Logs subdirectory, except for those whose names start with the letter A. It uses the 
    wildcard character (*) to indicate the contents of the Logs subdirectory, not the directory container. Because the command does not include 
    the Recurse parameter, Get-FileEncoding does not include the content of directory automatically; you need to specify it.

    .NOTES
    The parameter block was generated from Get-ChildItem using Indented.StubCommand, so you can use this command exactly like Get-ChildItem

    .LINK
    https://github.com/fsackur/Encoding
#>
    [CmdletBinding(DefaultParameterSetName='Items', SupportsTransactions=$true, HelpUri='https://github.com/fsackur/Encoding')]
    [OutputType([pscustomobject])]
    param (
        [Parameter(ParameterSetName='Items', Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${Path},
        
        [Parameter(ParameterSetName='LiteralItems', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('PSPath')]
        [string[]]
        ${LiteralPath},
        
        [Parameter(Position=1)]
        [string]
        ${Filter},
        
        [string[]]
        ${Include},
        
        [string[]]
        ${Exclude},
        
        [Alias('s')]
        [switch]
        ${Recurse},
        
        [uint32]
        ${Depth},
        
        [switch]
        ${Force},
        
        [switch]
        ${Name}
    )
    
    dynamicparam {
        $parameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        
        # Attributes
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Attributes", [System.Management.Automation.FlagsExpression`1[System.IO.FileAttributes]], $attributes)
        $parameters.Add("Attributes", $parameter)
        
        # Directory
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('ad', 'd')
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Directory", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("Directory", $parameter)
        
        # File
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('af')
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("File", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("File", $parameter)
        
        # Hidden
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('ah', 'h')
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Hidden", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("Hidden", $parameter)
        
        # ReadOnly
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('ar')
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("ReadOnly", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("ReadOnly", $parameter)
        
        # System
        $attributes = New-Object System.Collections.Generic.List[Attribute]
        
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Add($attribute)
        
        $attribute = New-Object System.Management.Automation.AliasAttribute('as')
        $attributes.Add($attribute)
        
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("System", [System.Management.Automation.SwitchParameter], $attributes)
        $parameters.Add("System", $parameter)
        
        return $parameters
    }
    
    end {
        Get-ChildItem @PSBoundParameters | select Name, @{n='Encoding';e={Get-FileEncodingPrivate $_.FullName}}, FullName
    }
}



function Get-FileEncodingPrivate {
<#
    .SYNOPSIS
    Gets file encoding.

    .DESCRIPTION
    The Get-FileEncoding function determines encoding by looking at Byte Order Mark (BOM).

    .EXAMPLE
    Get-ChildItem  *.ps1 | select FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} | where {$_.Encoding -ne 'ASCII'}
    This command gets ps1 files in current directory where encoding is not ASCII
#>
    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName='Path', Mandatory=$True, ValueFromPipelineByPropertyName=$True, Position=0)] 
        [string]$Path
    )

    [byte[]]$Bytes = Get-Content -Encoding Byte -ReadCount 4 -TotalCount 4 -Path $Path
    #Write-Host Bytes: $Bytes[0] $Bytes[1] $Bytes[2] $Bytes[3]

    # EF BB BF (UTF8)
    if ( $Bytes[0] -eq 0xef -and $Bytes[1] -eq 0xbb -and $Bytes[2] -eq 0xbf )
    { Write-Output 'UTF8' }

    # FE FF  (UTF-16 Big-Endian)
    elseif ($Bytes[0] -eq 0xfe -and $Bytes[1] -eq 0xff)
    { Write-Output 'Unicode UTF-16 Big-Endian' }

    # FF FE  (UTF-16 Little-Endian)
    elseif ($Bytes[0] -eq 0xff -and $Bytes[1] -eq 0xfe)
    { Write-Output 'Unicode UTF-16 Little-Endian' }

    # 00 00 FE FF (UTF32 Big-Endian)
    elseif ($Bytes[0] -eq 0 -and $Bytes[1] -eq 0 -and $Bytes[2] -eq 0xfe -and $Bytes[3] -eq 0xff)
    { Write-Output 'UTF32 Big-Endian' }

    # FE FF 00 00 (UTF32 Little-Endian)
    elseif ($Bytes[0] -eq 0xfe -and $Bytes[1] -eq 0xff -and $Bytes[2] -eq 0 -and $Bytes[3] -eq 0)
    { Write-Output 'UTF32 Little-Endian' }

    # 2B 2F 76 (38 | 38 | 2B | 2F)
    elseif ($Bytes[0] -eq 0x2b -and $Bytes[1] -eq 0x2f -and $Bytes[2] -eq 0x76 -and ($Bytes[3] -eq 0x38 -or $Bytes[3] -eq 0x39 -or $Bytes[3] -eq 0x2b -or $Bytes[3] -eq 0x2f) )
    { Write-Output 'UTF7'}

    # F7 64 4C (UTF-1)
    elseif ( $Bytes[0] -eq 0xf7 -and $Bytes[1] -eq 0x64 -and $Bytes[2] -eq 0x4c )
    { Write-Output 'UTF-1' }

    # DD 73 66 73 (UTF-EBCDIC)
    elseif ($Bytes[0] -eq 0xdd -and $Bytes[1] -eq 0x73 -and $Bytes[2] -eq 0x66 -and $Bytes[3] -eq 0x73)
    { Write-Output 'UTF-EBCDIC' }

    # 0E FE FF (SCSU)
    elseif ( $Bytes[0] -eq 0x0e -and $Bytes[1] -eq 0xfe -and $Bytes[2] -eq 0xff )
    { Write-Output 'SCSU' }

    # FB EE 28  (BOCU-1)
    elseif ( $Bytes[0] -eq 0xfb -and $Bytes[1] -eq 0xee -and $Bytes[2] -eq 0x28 )
    { Write-Output 'BOCU-1' }

    # 84 31 95 33 (GB-18030)
    elseif ($Bytes[0] -eq 0x84 -and $Bytes[1] -eq 0x31 -and $Bytes[2] -eq 0x95 -and $Bytes[3] -eq 0x33)
    { Write-Output 'GB-18030' }

    else
    { Write-Output 'ASCII' }
}

Export-ModuleMember (
    'Convert-FileEncoding',
    'Get-FileEncoding'
)
