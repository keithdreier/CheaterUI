#IfWinActive, Helldivers
#InstallKeybdHook ; keep logical keypresses from fucking up the physical state
SetWorkingDir %A_ScriptDir%

; Settings
global delay = 30 ; milliseconds between keystrokes
global keys := ["w","a","s","d"] ; keys used for movement
SetKeyDelay, %delay%

Gui, +Lastfound +AlwaysOnTop -Caption
Gui, Color, cccccc
WinSet, TransColor, cccccc

global skills := Object()
Loop, *.png, 0,1
{
	SplitPath, A_LoopFileLongPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	skills.Insert({"type": A_LoopFileDir, "code": OutNameNoExt, "image": A_LoopFileFullPath})
}

loop 8{
	num := A_Index
	x := num * 55 -55
	Gui, Add, Picture, gSelectKey vkey%num% x%x% y0 w0 h0,images/blank.png
}

x := 0
y := 60
for index, value in skills
{
	if value.type = "images\special"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w50 h50, %img%
		x := x + 55
	}
}

x := 0
y := 120
for index, value in skills
{
	if value.type = "images\supply"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w50 h50, %img%
		x := x + 55
	}
}

x := 0
y := 180
for index, value in skills
{
	if value.type = "images\defensive"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w50 h50, %img%
		x := x + 55
	}
}

x := 0
y := 240
for index, value in skills
{
	if value.type = "images\offensive"{
		img := value.image
		Gui, Add, Picture, gBind v%index% x%x% y%y% w50 h50, %img%
		x := x + 55
	}
}

hideSkills()
Return

SelectKey:
key = %A_GuiControl%
showSkills()
return 

Bind:
id := A_GuiControl
img := skills[id].image
GuiControl,, %key%, %img%
%key% := skills[id].code
hideSkills()
return

hideSkills(){
	Gui, Show, x5 y5 h50 w477
}

showSkills(){
	Gui, Show, x5 y5 h300 w1900
}

; Disable user inputs and release movement keys so they don't interrupt stratagem codes
StopMoving()
{	
	BlockInput, On
	For index, value in keys
	{	
		Send {%value% up}
	}
}

; Enable user input and set movement keys back to their physical state
RestoreMovement()
{
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
Call(key)
{
	StopMoving()
	SendInput {LCtrl down}
	sleep %delay%
	Send %key%
	sleep %delay%
	SendInput {LCtrl up}
	RestoreMovement()
}

; Shift + Numbers bound to numpad (bound in game for weapon switching)
+1::Numpad1
+2::Numpad2
+3::Numpad3

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