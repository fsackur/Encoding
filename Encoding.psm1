<#
    .NOTES
    My additions are just the latest tweaks to some code that appears to have passed through many hands.

    I found it at https://gist.github.com/jpoehls/2406504 so my credit goes to Joshua Poehls.
#>

<#
    .SYNOPSIS
    Converts files to the given encoding.

    .DESCRIPTION
    Matches the include pattern recursively under the given path.

    .EXAMPLE
    Convert-FileEncoding -Include *.js -Path scripts -Encoding UTF8
#>
function Convert-FileEncoding([string]$Include, [string]$Path, [string]$Encoding='UTF8') {

    $count = 0

    Get-ChildItem -Include $Pattern -Recurse -Path $Path |
        select FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} |
        where {$_.Encoding -ne $Encoding} |
        foreach { 
            (Get-Content $_.FullName) |
            Out-File $_.FullName -Encoding $Encoding; $count++;
        }
  
    Write-Host "$count $Pattern file(s) converted to $Encoding in $Path."
}


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
function Get-FileEncoding {
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


<#
    .SYNOPSIS
    Gets file encoding.

    .DESCRIPTION
    The Get-FileEncoding function determines encoding by looking at Byte Order Mark (BOM).
    Based on port of C# code from http://www.west-wind.com/Weblog/posts/197245.aspx

    .EXAMPLE
    Get-ChildItem  *.ps1 | select FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} | where {$_.Encoding -ne 'ASCII'}
    This command gets ps1 files in current directory where encoding is not ASCII

    .EXAMPLE
    Get-ChildItem  *.ps1 | select FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} | where {$_.Encoding -ne 'ASCII'} | foreach {(get-content $_.FullName) | set-content $_.FullName -Encoding ASCII}
    Same as previous example but fixes encoding using set-content
 
    .NOTES
    Modified by F.RICHARD August 2010
    add comment + more BOM
    http://unicode.org/faq/utf_bom.html
    http://en.wikipedia.org/wiki/Byte_order_mark

    Do this next line before or add function in Profile.ps1
    Import-Module .\Get-FileEncoding.ps1

    .LINK
    http://franckrichard.blogspot.com/2010/08/powershell-get-encoding-file-type.html
#>
function Get-FileEncodingPrivate {
    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName='Path', Mandatory=$True, ValueFromPipelineByPropertyName=$True, Position=0)] 
        [string]$Path
    )

    [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $Path
    #Write-Host Bytes: $byte[0] $byte[1] $byte[2] $byte[3]

    # EF BB BF (UTF8)
    if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
    { Write-Output 'UTF8' }

    # FE FF  (UTF-16 Big-Endian)
    elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff)
    { Write-Output 'Unicode UTF-16 Big-Endian' }

    # FF FE  (UTF-16 Little-Endian)
    elseif ($byte[0] -eq 0xff -and $byte[1] -eq 0xfe)
    { Write-Output 'Unicode UTF-16 Little-Endian' }

    # 00 00 FE FF (UTF32 Big-Endian)
    elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff)
    { Write-Output 'UTF32 Big-Endian' }

    # FE FF 00 00 (UTF32 Little-Endian)
    elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff -and $byte[2] -eq 0 -and $byte[3] -eq 0)
    { Write-Output 'UTF32 Little-Endian' }

    # 2B 2F 76 (38 | 38 | 2B | 2F)
    elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76 -and ($byte[3] -eq 0x38 -or $byte[3] -eq 0x39 -or $byte[3] -eq 0x2b -or $byte[3] -eq 0x2f) )
    { Write-Output 'UTF7'}

    # F7 64 4C (UTF-1)
    elseif ( $byte[0] -eq 0xf7 -and $byte[1] -eq 0x64 -and $byte[2] -eq 0x4c )
    { Write-Output 'UTF-1' }

    # DD 73 66 73 (UTF-EBCDIC)
    elseif ($byte[0] -eq 0xdd -and $byte[1] -eq 0x73 -and $byte[2] -eq 0x66 -and $byte[3] -eq 0x73)
    { Write-Output 'UTF-EBCDIC' }

    # 0E FE FF (SCSU)
    elseif ( $byte[0] -eq 0x0e -and $byte[1] -eq 0xfe -and $byte[2] -eq 0xff )
    { Write-Output 'SCSU' }

    # FB EE 28  (BOCU-1)
    elseif ( $byte[0] -eq 0xfb -and $byte[1] -eq 0xee -and $byte[2] -eq 0x28 )
    { Write-Output 'BOCU-1' }

    # 84 31 95 33 (GB-18030)
    elseif ($byte[0] -eq 0x84 -and $byte[1] -eq 0x31 -and $byte[2] -eq 0x95 -and $byte[3] -eq 0x33)
    { Write-Output 'GB-18030' }

    else
    { Write-Output 'ASCII' }
}

Export-ModuleMember (
    'Convert-FileEncoding',
    'Get-FileEncoding'
)
