SetUpTrayMenu()
{
  ; Tray
  ; +-- Script : Specific things relating to the script itself

  ; "Script" menu
  Menu, Script, Add, Admin, NullMenuOp
  Menu, Script, Add
  Menu, Script, Add, Reload, ReloadScript
  Menu, Script, Add, Reload as Admin, RelaunchAsAdmin
  Menu, Script, Add
  Menu, Script, Add, Edit, EditScript
  Menu, Script, Add
  Menu, Script, Add, Pause, PauseScript
  Menu, Script, Add, Suspend, SuspendScript

  Menu, Script, Disable, Admin
  if (IsRunningAsAdmin())
  {
      Menu, Script, Check, Admin
  }

  ; "Tray" menu (main)
  Menu, Tray, Icon, Automation.ico
  Menu, Tray, NoStandard
  Menu, Tray, Add, Setup, Setup
  Menu, Tray, Add	
  Menu, Tray, Add, Empty Recycle Bin, EmptyRecycleBin
  Menu, Tray, Add, Window Spy, RunWindowSpy
  Menu, Tray, Add
  Menu, Tray, Add, Script, :Script
  Menu, Tray, Add
  Menu, Tray, Add, Exit, ExitScript
  Menu, Tray, Tip, Automation`nTest
}

EmptyRecycleBin()
{
  FileRecycleEmpty
}

ReloadScript()
{
  Reload
}

PauseScript()
{
  if (A_IsPaused)
  {
    Menu, ScriptMenu, Uncheck, Pause
    Pause, Off
  }
  else {
    Menu, ScriptMenu, Check, Pause
    Pause, On
  }
}

SuspendScript()
{
  if (A_IsSuspended)
  {
    Menu, ScriptMenu, Uncheck, Suspend
    Suspend, Off
  }
  else
  {
    Menu, ScriptMenu, Check, Suspend
    Suspend, On
  }
}

EditScript()
{
  Edit
}

NullMenuOp()
{

}

RunWindowSpy()
{
  SplitPath, A_AhkPath, , ParentDir, , , 
  Run, %ParentDir%\WindowSpy.ahk
}

ExitScript()
{
  ExitApp
}