UrlEncode(string)
{
  out := ""
  oldFormat := A_FormatInteger
  SetFormat, Integer, H
  Loop, Parse, string
  {
    if A_LoopField is alnum
    {
      out .= A_LoopField
      continue
    }
    hex := SubStr(Asc(A_LoopField), 3)
    out .= "%".(StrLen(hex) == 1 ? "0".hex : hex)
  }
  SetFormat, Integer, %oldFormat%
  return out
}

IsRunningAsAdmin()
{
  full_command_line := DllCall("GetCommandLine", "str")
  return A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)")
}

RelaunchAsAdmin()
{
  if (not (IsRunningAsAdmin()))
  {
    try ; leads to having the script re-launching itself as administrator
    {
      if (A_IsCompiled)
      {
        Run *RunAs "%A_ScriptFullPath%" /restart
      }
      else
      {
        Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
      }
    }
    ExitApp
  }
}

PasteWithoutFormatting()
{
; Paste, but strip formatting
  Clip0 = %ClipBoardAll%
  ClipBoard = %ClipBoard% ; Convert to text
  Send ^v ; For best compatibility: SendPlay
  Sleep 50 ; Don't change clipboard while it is pasted! (Sleep > 0)
  ClipBoard = %Clip0% ; Restore original ClipBoard
  VarSetCapacity(Clip0, 0) ; Free memory
  return
}

PasteTextAndEnter(text)
{
  Clip0 = %ClipBoardAll%
  ClipBoard = %text% ; Convert to text
  Send ^v ; For best compatibility: SendPlay
  Sleep 50 ; Don't change clipboard while it is pasted! (Sleep > 0)
  Send {Enter}
  ClipBoard = %Clip0% ; Restore original ClipBoard
  VarSetCapacity(Clip0, 0) ; Free memory
  return
}