#IfWinActive, Helldivers
#InstallKeybdHook ; keep logical keypresses from fucking up the physical state
#SingleInstance force

; Settings
global delay = 30 ; milliseconds between keystrokes
global keys = ["w","a","s","d"] ; keys used for movement
global top = 55 ; top of ahk window
global left = 5 ; left of ahk window
global size = 50 ; icon size
global gap = 5 ; icon gap
global cols = 8
global width = cols * (size + gap)
global slots = Object()
global current

SetKeyDelay, %delay%

Gui, +0x20 +Lastfound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, cccccc
WinSet, TransColor, cccccc

global winId := WinExist()
global skills := Object()
global skillExpanded := False

global x = 0
global y = 0

; Read skill icons and key strokes from file
; Key strokes is the file name
workingDir := A_Temp . "\CheaterUI"
{
  FileInstall, JSON.ahk, %workingDir%\JSON.ahk
  FileCreateDir, %workingDir%\images
  FileCreateDir, %workingDir%\images\defensive
  FileCreateDir, %workingDir%\images\offensive
  FileCreateDir, %workingDir%\images\special
  FileCreateDir, %workingDir%\images\supply
  FileInstall, images\blank.png, %workingDir%\images\blank.png
  FileInstall, images\defensive\aawwda.png, %workingDir%\images\defensive\aawwda.png
  FileInstall, images\defensive\adssd.png, %workingDir%\images\defensive\adssd.png
  FileInstall, images\defensive\adsw.png, %workingDir%\images\defensive\adsw.png
  FileInstall, images\defensive\adws.png, %workingDir%\images\defensive\adws.png
  FileInstall, images\defensive\asd.png, %workingDir%\images\defensive\asd.png
  FileInstall, images\defensive\asswda.png, %workingDir%\images\defensive\asswda.png
  FileInstall, images\defensive\aswad.png, %workingDir%\images\defensive\aswad.png
  FileInstall, images\defensive\aswda.png, %workingDir%\images\defensive\aswda.png
  FileInstall, images\defensive\awd.png, %workingDir%\images\defensive\awd.png
  FileInstall, images\offensive\dadassd.png, %workingDir%\images\offensive\dadassd.png
  FileInstall, images\offensive\ddd.png, %workingDir%\images\offensive\ddd.png
  FileInstall, images\offensive\ddsa.png, %workingDir%\images\offensive\ddsa.png
  FileInstall, images\offensive\ddw.png, %workingDir%\images\offensive\ddw.png
  FileInstall, images\offensive\dsssas.png, %workingDir%\images\offensive\dsssas.png
  FileInstall, images\offensive\dswsa.png, %workingDir%\images\offensive\dswsa.png
  FileInstall, images\offensive\dswwas.png, %workingDir%\images\offensive\dswwas.png
  FileInstall, images\offensive\dwad.png, %workingDir%\images\offensive\dwad.png
  FileInstall, images\offensive\dwas.png, %workingDir%\images\offensive\dwas.png
  FileInstall, images\offensive\dwawda.png, %workingDir%\images\offensive\dwawda.png
  FileInstall, images\offensive\dwawsd.png, %workingDir%\images\offensive\dwawsd.png
  FileInstall, images\offensive\dwsda.png, %workingDir%\images\offensive\dwsda.png
  FileInstall, images\special\ssdw.png, %workingDir%\images\special\ssdw.png
  FileInstall, images\special\wadsws.png, %workingDir%\images\special\wadsws.png
  FileInstall, images\special\wsdaw.png, %workingDir%\images\special\wsdaw.png
  FileInstall, images\special\wsdw.png, %workingDir%\images\special\wsdw.png
  FileInstall, images\supply\sadda.png, %workingDir%\images\supply\sadda.png
  FileInstall, images\supply\sadws.png, %workingDir%\images\supply\sadws.png
  FileInstall, images\supply\sadww.png, %workingDir%\images\supply\sadww.png
  FileInstall, images\supply\sasda.png, %workingDir%\images\supply\sasda.png
  FileInstall, images\supply\sasdd.png, %workingDir%\images\supply\sasdd.png
  FileInstall, images\supply\saswa.png, %workingDir%\images\supply\saswa.png
  FileInstall, images\supply\saswd.png, %workingDir%\images\supply\saswd.png
  FileInstall, images\supply\saswwd.png, %workingDir%\images\supply\saswwd.png
  FileInstall, images\supply\sawaa.png, %workingDir%\images\supply\sawaa.png
  FileInstall, images\supply\sawas.png, %workingDir%\images\supply\sawas.png
  FileInstall, images\supply\sawsd.png, %workingDir%\images\supply\sawsd.png
  FileInstall, images\supply\sdsaad.png, %workingDir%\images\supply\sdsaad.png
  FileInstall, images\supply\sdsaaw.png, %workingDir%\images\supply\sdsaaw.png
  FileInstall, images\supply\sdsawd.png, %workingDir%\images\supply\sdsawd.png
  FileInstall, images\supply\sdwasa.png, %workingDir%\images\supply\sdwasa.png
  FileInstall, images\supply\sdwasd.png, %workingDir%\images\supply\sdwasd.png
  FileInstall, images\supply\sdwass.png, %workingDir%\images\supply\sdwass.png
  FileInstall, images\supply\sdwaws.png, %workingDir%\images\supply\sdwaws.png
  FileInstall, images\supply\ssads.png, %workingDir%\images\supply\ssads.png
  FileInstall, images\supply\sswd.png, %workingDir%\images\supply\sswd.png
  FileInstall, images\supply\swaads.png, %workingDir%\images\supply\swaads.png
  FileInstall, images\supply\swadad.png, %workingDir%\images\supply\swadad.png
  FileInstall, images\supply\swadas.png, %workingDir%\images\supply\swadas.png
  FileInstall, images\supply\swawds.png, %workingDir%\images\supply\swawds.png
  FileInstall, images\supply\swssd.png, %workingDir%\images\supply\swssd.png
  FileInstall, images\supply\swwsw.png, %workingDir%\images\supply\swwsw.png
}

SetWorkingDir %workingDir%

#Include, JSON.ahk

if (FileExist("slots.json")) {
  FileRead, slotsRaw, slots.json
  slots := JSON.Load(slotsRaw)
}

loop, images\*.png, 0, 1
{
  SplitPath, A_LoopFileLongPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
  if (OutNameNoExt != "blank") {
    skills.Insert({"type": A_LoopFileDir, "code": OutNameNoExt, "image": A_LoopFileFullPath})
  }
}

x := 0
y := 0
; Render skill slots
loop 8
{
  num := A_Index
  Gui, Add, Picture, gOpenSlot vslot%num% x%x% y0 w0 h0,images/blank.png
  x += size + gap
}

x := 0
y += size + gap

for index, value in skills {
  img := value.image
  Gui, Add, Picture, gSelectSkill v%index% x%x% y%y% w%size% h%size%, %img%
  x += size + gap
  if (x >= width) {
    x := 0
    y += size + gap
  }
}

for key, value in slots {
  img := skills[value].image
  GuiControl,, %key%, %img% ; set slot image
}

hideSkills()


; Hide window when game's not active
loop {
  if (WinActive("ahk_exe helldivers.exe") or WinActive("ahk_id " . winId)) {
    WinShow, ahk_id %winId%
  } else {
    WinHide, ahk_id %winId%
  }
  sleep 100
}

return

; toggle skills
OpenSlot:
  current = %A_GuiControl%
  if (skillExpanded == True) {
    hideSkills()
    return
  }
  showSkills()
return 

; Trigger when icon clicked
SelectSkill:
  id := A_GuiControl
  img := skills[id].image
  GuiControl,, %current%, %img% ; set slot image
  slots[current] := id
  slotsJson := JSON.Dump(slots)
  FileDelete, slots.json
  FileAppend, %slotsJson%, slots.json
  hideSkills()
return

hideSkills() {
  skillExpanded := False
  Gui, Show, x%left% y%top% h%size% w%width%
  WinActivate, Helldivers ; always focus back on game window
}

showSkills() {
  height := y + size + gap
  Gui, Show, x%left% y%top% h%height% w%width%
  skillExpanded := True
}

; Disable user inputs and release movement keys so they don't interrupt stratagem codes
StopMoving() {  
  BlockInput, On
  For index, value in keys {  
    Send {%value% up}
  }
}

; Enable user input and set movement keys back to their physical state
RestoreMovement() {
  BlockInput, Off
  For index, value in keys {
    GetKeyState, state, %value%, P
    if (state = D) {
      Send {%value% down}
    }
  }
}

; Stops movement, blocks input, calls a stratagem, and resumes movement
Call(slotId) {
  skillId := slots[slotId]
  FileAppend, %slotId%`n, debug.log
  FileAppend, %skillId%`n, debug.log
  if (!skillId) {
    return
  }
  keyStrokes := skills[skillId].code
  StopMoving()
  SendInput {LCtrl down}
  sleep %delay%
  Send %keyStrokes%
  sleep %delay%
  SendInput {LCtrl up}
  RestoreMovement()
}

; Shift + Numbers bound to numpad (bound in game for weapon switching)
; +1::Numpad1
; +2::Numpad2
; +3::Numpad3

1::Call("slot1")
2::Call("slot2")
3::Call("slot3")
4::Call("slot4")
5::Call("slot5")
6::Call("slot6")
7::Call("slot7")
8::Call("slot8")

^Space::
Suspend Toggle
If %A_IsSuspended%
  SoundPlay %WINDIR%\media\Windows Hardware Remove.wav
Else
  SoundPlay %WINDIR%\media\Windows Hardware Insert.wav
Return

GuiClose:
ExitApp