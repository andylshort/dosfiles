; Automation.ahk

; Script settings
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn
SendMode Input ; Increased speed and reliability
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
#SingleInstance, force
DetectHiddenWindows, On ; Detect hidden windows
SetTitleMatchMode, 2
SetBatchLines, -1 ; Never sleep for best performance
SetCapslockState, AlwaysOff

#KeyHistory, 0

; Configuration
global browser := "Firefox.exe"
global editor := "S:\Microsoft VS Code\Code.exe"

; Startup
Startup()

; Ctrl+Win+Esc - Manually reload script
^#Escape::Reload

; Included scripts
#Include Scripts\Hotstrings.ahk
#Include Scripts\Utilities.ahk
#Include Scripts\Tray.ahk

; End of Auto-Execute =====


; Hotkeys =====

; Win + Shift + Down
; Minimise active window
#+Down::
  WinGetTitle, current_window_title, A
  WinMinimize, %current_window_title%
return

; If active window is the script editor...
#IfWinActive ahk_group this_script

; Ctrl + S
; Reload the script
~^s::
  TrayTip, Reloading updated script, %A_ScriptName%
  Reload
return

#IfWinActive

; CapsLock::ToggleLauncher()
#w::
#f::
return

; Performs a Google search for the highlighted text
#g::
  SearchForHighlightedText()
return

; Performs a Google Scholar search for the highlighted test
#h::
  SearchForHighlightedText("https://scholar.google.co.uk/scholar?hl=en&q=")
return

^#i::
  Winset, AlwaysOnTop, , A
return

; Ctrl + Win + v
; Paste the contents of the clipboard without its formatting
^#v::
  PasteWithoutFormatting()
return

; BrowserHome key
; Open my Downloads folder
Browser_Home::
  Run shell:::{374DE290-123F-4565-9164-39C4925E467B}
return

; Functions =====

; Actions to perform when the script loads
Startup()
{
  LoadConfiguration()

  SetUpTrayMenu()

  ; Add any window containing this script's name to the group this_script for auto-reloading
  GroupAdd, this_script, %A_ScriptName%

  MiscellaneousStartupRoutines()
}

LoadConfiguration(fileName := "Configuration.ini")
{
  ; Specific configuration
  IniRead, browser, %fileName%, General, Browser
}

MiscellaneousStartupRoutines()
{
  ; Register hook for window messages
  ; DllCall("RegisterShellHookWindow", "Uint", A_ScriptHwnd)
  ; shell_hook := DllCall("RegisterWindowMessage", "str", "SHELLHOOK")
  ; OnMessage(shell_hook, Func("OnWin"))
}



; Tray menu handlers -----

; Initialisation and customisation of environment
Setup()
{
  ; MsgBox, Test
  ; MsgBox, Setup Procedure
  if (IsRunningAsAdmin())
  {
    ; Msgbox, Regedit
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit,, "S:\Microsoft VS Code\Code.exe" "`%1"
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command,, "S:\Microsoft VS Code\Code.exe" "`%1"

    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\.ahk, PerceivedType, text
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\.json, PerceivedType, text
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\.md, PerceivedType, text

    RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search, AllowCortana, 0x0
    RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell, ExecutionPolicy, RemoteSigned
  }
  else
  {
    ; MsgBox, Not Running as admin
  }
}


Search(Query, Url="https://www.google.co.uk/search?hl=en&q=")
{
  ; Web search:     https://www.google.co.uk/search?hl=en&q=%Query%
  ; Scholar search: https://scholar.google.co.uk/scholar?hl=en&q=%Query%
  NewQuery := UrlEncode(Trim(Query))
  Run, %Browser% %Url%%NewQuery%
}

SearchForHighlightedText(Url="https://www.google.co.uk/search?hl=en&q=")
{
  Save_Clipboard := ClipboardAll
  Clipboard := ""
  Send ^c
  ClipWait, .5
  if (!ErrorLevel)
  {
    Query := Clipboard
    Search(Query, Url)
  }
  Clipboard := Save_Clipboard
  Save_Clipboard := ""
}

; EXPERIMENTAL

; Numpad0::
; {
; 	; 0xC40000
; 	; 0xC00000
; 	WinGet, Style, Style, A
; 	if (Style & 0xC40000) {
; 		WinSet, Style, -0xC40000, A
; 	} else {
; 		WinSet, Style, 0+xC40000, A
; 	}
; }

ToggleLauncher()
{
  global LauncherActive
  static LauncherCommand
  if (LauncherActive = 1) {
    Gui, Destroy
    LauncherActive := False
  }
  else {
    ; Launcher Gui Initialisation
    LauncherActive := True
    Gui, Default
    Gui, +LastFound +AlwaysOnTop -MaximizeBox -MinimizeBox +ToolWindow
    Gui, Add, Edit, vLauncherCommand
    Gui, Add, Button, x-10 y-10 w1 h1 +default gOnSubmit
    Gui, Show, , >
  }
  return

  OnSubmit:
  {
    Gui, Submit, NoHide
    Command := LauncherCommand
    Gui, Destroy
    LauncherActive := False
    OnLauncherCommand(Command)
    return
  }
}

OnLauncherCommand(Command)
{
  ; MsgBox, % Command

  if (Command = "chrome")
  {
    Run, chrome.exe
  }
  else if (Command = "ff")
  {
    Run, firefox.exe
  }
  else if (Command = "shutdown")
  {
    Shutdown, 9
  }
  else if (Command = "restart")
  {
    Shutdown, 6
  }
}

OnWin(Event, Hwnd)
{
  ; Codes: https://msdn.microsoft.com/en-us/library/windows/desktop/ms644991(v=vs.85).aspx
  ; HSHELL_WINDOWACTIVATED (4)
  if (Event = 4 or Event = 32772)
  {
    WinGetClass, Class_Found, % "ahk_id" Hwnd
    ; Menu, Tray, Tip, % Class_Found
    
    if (Class_Found = "Notepad")
    {
      ; WinSet, Style, -0xC40000, ahk_class %Class_Found%
      ; WinMaximize, ahk_class %Class_Found%
      ;MsgBox, "Notepad" ;gosub, Increase_Notepad_Counter
    }
    else if (Class_Found = "MsPaintApp")
    {
      ; MsgBox, "MsPaintApp" ;gosub, Increase_Paint_Counter
    }
    else if (Class_Found = "ConsoleWindowClass")
    {
      ; MsgBox, "ConsoleWindowClass" ; gosub, Increase_Cmd_Counter
    }
    ; else if (Class_Found = "SunAwtFrame" and WinExist("ahk_exe RuneLite.exe"))
    ; {
    ; 	if (!WinExist("OSRS.ahk"))
    ; 	{
    ; 		Run, %A_ScriptDir%\Library\Scripts\OSRS.ahk
    ; 	}
    ; }
  }
  ; else if (Event = 2)
  ; {
  ;     if (!WinExist("ahk_exe RuneLite.exe") and WinExist("OSRS.ahk")) {
  ;         WinClose, %A_ScriptDir%\Library\Scripts\OSRS.ahk
  ;     }
  ; }
}