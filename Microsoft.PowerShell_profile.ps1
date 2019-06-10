Set-ExecutionPolicy RemoteSigned process

# Functions
function FindFolderLockOwner([string]$Path)
{
    if ((Test-Path -Path $Path) -eq $false)
    {
        Write-Warning "File or directory does not exist."       
    }
    else
    {
        $LockingProcess = CMD /C "openfiles /query /fo table | find /I ""$Path"""
        Write-Host $LockingProcess
    }
}

function Rebuild-IconCache() {
    Try 
    { 
        # Check if file exists 
        If(Test-Path -Path "$env:LOCALAPPDATA\IconCache.db") 
        { 
            Remove-Item -Path "$env:LOCALAPPDATA\IconCache.db" -Force 
        } 
        # Restart Explorer Process 
        Stop-Process -ProcessName explorer
      
        Invoke-Expression -Command "ie4uinit.exe -cleariconcache" 
        Write-Host "Successfully refreshed icon cache." 
    } 
    Catch 
    { 
        Write-Warning "Failed to refreshed icon cache." 
    }
}

function Test-IsAdmin {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Aliases
function ..() { cd .. }
function ...() { cd ..\.. }

# Prompt
Clear-Host

function Prompt {
    # $Host.UI.RawUI.WindowTitle = (Get-Date -UFormat '%y/%m/%d %R').Tostring()

    Write-Host '[' -NoNewline
    Write-Host (Get-Date -UFormat '%T') -ForegroundColor White -NoNewline
    Write-Host '] ~ ' -NoNewline
    Write-Host (Get-Location) -NoNewline
    return " > "
}