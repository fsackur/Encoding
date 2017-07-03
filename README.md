# Encoding
Functions to help with text file encoding

Exposes two functions: Get-FileEncoding and Convert-FileEncoding

This was borne out of frustrations with git treating text files as binary

# Usage
Get-FileEncoding is used exactly like Get-ChildItem, except that it returns the encoding of any text files

```powershell
PS C:\dev\RaxCloud> Get-FileEncoding

Name           Encoding                     FullName
----           --------                     --------
.gitattributes UTF8                         C:\dev\RaxCloud\.gitattributes
RaxCloud.ps1   Unicode UTF-16 Little-Endian C:\dev\RaxCloud\RaxCloud.ps1
README.md      ASCII                        C:\dev\RaxCloud\README.md
```

```powershell
PS C:\dev\RaxCloud> Get-FileEncoding .\.git -Recurse -Include *msg* -Exclude hooks

Name                      Encoding FullName
----                      -------- --------
applypatch-msg.sample     ASCII    C:\dev\RaxCloud\.git\hooks\applypatch-msg.sample
commit-msg.sample         ASCII    C:\dev\RaxCloud\.git\hooks\commit-msg.sample
prepare-commit-msg.sample ASCII    C:\dev\RaxCloud\.git\hooks\prepare-commit-msg.sample
applypatch-msg.sample     ASCII    C:\dev\RaxCloud\.git\modules\PoshStack\hooks\applypatch-msg.sample
commit-msg.sample         ASCII    C:\dev\RaxCloud\.git\modules\PoshStack\hooks\commit-msg.sample
prepare-commit-msg.sample ASCII    C:\dev\RaxCloud\.git\modules\PoshStack\hooks\prepare-commit-msg.sample
applypatch-msg.sample     ASCII    C:\dev\RaxCloud\.git\modules\rackspacecloud_powershell\hooks\applypatch-msg.sample
commit-msg.sample         ASCII    C:\dev\RaxCloud\.git\modules\rackspacecloud_powershell\hooks\commit-msg.sample
prepare-commit-msg.sample ASCII    C:\dev\RaxCloud\.git\modules\rackspacecloud_powershell\hooks\prepare-commit-msg.sample
COMMIT_EDITMSG            ASCII    C:\dev\RaxCloud\.git\COMMIT_EDITMSG
MERGE_MSG.lock                     C:\dev\RaxCloud\.git\MERGE_MSG.lock
```

In the second example, the last file is empty, so has no encoding data associated.

## WARNING

```powershell
PS C:\dev\RaxCloud> Get-FileEncoding C:\WINDOWS\regedit.exe

Name        Encoding FullName
----        -------- --------
regedit.exe ASCII    C:\WINDOWS\regedit.exe
```

In this example, a binary file reports that it is ascii. This is clearly not useful. Results are only defined for text files.


Convert-FileEncoding accepts the same values for the -Encoding parameter as Out-File.

```powershell
PS C:\dev\RaxCloud> Get-FileEncoding .\README.md | Convert-FileEncoding -Encoding UTF8
1  file(s) converted to UTF8 in .
```