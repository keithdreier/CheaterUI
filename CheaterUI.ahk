#IfWinActive, Helldivers
#InstallKeybdHook ; keep logical keypresses from fucking up the physical state
#SingleInstance force
SetWorkingDir %A_ScriptDir%

; Settings
global delay = 30 ; milliseconds between keystrokes
global keys := ["w","a","s","d"] ; keys used for movement
global top := 40 ; top of ahk window
global size := 50 ; icon size
global gap = 5 ; icon gap
SetKeyDelay, %delay%

Gui, +0x20 +Lastfound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, cccccc
WinSet, TransColor, cccccc

global winId := WinExist()
global skills := Object()

global skillExpanded = False

; Read skill icons and key strokes from file
; Key strokes is the file name
Loop, *.png, 0,1
{
	SplitPath, A_LoopFileLongPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	skills.Insert({"type": A_LoopFileDir, "code": OutNameNoExt, "image": A_LoopFileFullPath})
}

; Render skill slots
loop 8 {
	num := A_Index
	x := (num - 1) * (size + gap)
	Gui, Add, Picture, gSelectKey vkey%num% x%x% y0 w0 h0,images/blank.png
}

; First line
x := 0
y := (size + gap)
for index, value in skills {
	if value.type = "images\special"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w%size% h%size%, %img%
		x += size + gap
	}
}

; Second line
x := 0
y := (size + gap) * 2
for index, value in skills {
	if value.type = "images\supply"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w%size% h%size%, %img%
		x := x + size + gap
	}
}

; Third line
x := 0
y := (size + gap) * 3
for index, value in skills {
	if value.type = "images\defensive"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w%size% h%size%, %img%
		x := x + size + gap
	}
}

; Forth line
x := 0
y := (size + gap) * 4
for index, value in skills {
	if value.type = "images\offensive" {
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w%size% h%size%, %img%
		x := x + size + gap
	}
}

hideSkills()

loop {
  if (WinActive("ahk_exe helldivers.exe") or WinActive("ahk_id " . winId)) {
    WinShow, ahk_id %winId%
  } else {
    WinHide, ahk_id %winId%
  }
  sleep 100
}

Return

SelectKey:
  ; toggle skills
  key = %A_GuiControl%
  if (skillExpanded == True) {
    hideSkills()
    return
  }
  showSkills()
return 

; Trigger when icon clicked
Bind:
	id := A_GuiControl
	img := skills[id].image
	GuiControl,, %key%, %img%
	%key% := skills[id].code
	hideSkills()
return

hideSkills() {
  skillExpanded := False
	Gui, Show, x5 y%top% h50 w477
  WinActivate, Helldivers ; always focus back on game window
}

showSkills() {
	height := (size + gap) * 5
	Gui, Show, x5 y%top% h%height% w1900
	skillExpanded := True
}

; Disable user inputs and release movement keys so they don't interrupt stratagem codes
StopMoving() {	
	BlockInput, On
	For index, value in keys
	{	
		Send {%value% up}
	}
}

; Enable user input and set movement keys back to their physical state
RestoreMovement() {
	BlockInput, Off
	For index, value in keys
	{
		GetKeyState, state, %value%, P
		if state = D
		{
			Send {%value% down}
		}
	}
}

; Stops movement, blocks input, calls a stratagem, and resumes movement
Call(key) {
	StopMoving()
	SendInput {LCtrl down}
	sleep %delay%
	Send %key%
	sleep %delay%
	SendInput {LCtrl up}
	RestoreMovement()
}

; Shift + Numbers bound to numpad (bound in game for weapon switching)
; +1::Numpad1
; +2::Numpad2
; +3::Numpad3

1::Call(key1)
2::Call(key2)
3::Call(key3)
4::Call(key4)
5::Call(key5)
6::Call(key6)
7::Call(key7)
8::Call(key8)

GuiClose:
ExitApp
