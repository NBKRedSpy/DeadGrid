#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

SetMouseDelay 0
SetKeyDelay, 10,50


;Game - Dead Grid
#IfWinActive ahk_exe DeadGrid.exe
    PgUp::
        Suspend On
        SoundBeep 200,100
        return
    PgDn::
        Suspend Off
        SoundBeep 200,100
        SoundBeep 100,100
	    return


    ;Merc drag start
	~LButton::
		MouseGetPos, x, y
		startX := x
		startY := y
		endX := 
		endY := 
		return

    ;Zed End Drag		
	~Lbutton up::
		MouseGetPos, x, y
		endX := x
		endY := y
		return		

	;Repeat attack from previous merc to previous target
	r::
		if(!endX or !endY or !startX or !startY)
		{
			return
		}

		rm := new RestoreMouse(50)

		mouseMove startX, startY, 50
		click down
		sleep 100
		mouseMove endX, endY, 50
		sleep 100
		click up
		sleep 100
		rm.Restore()
		return
	;Attack previous target from merc the mouse is hovering over.
	t::
		if(!endX or !endY)
		{
			return
		}

		restoreMouse := new RestoreMouse(true)
		click down
		sleep 100
		mouseMove endX, endY, 50
		sleep 100
		click up
		sleep 100
		restoreMouse.Restore()


	;Allow snippet shortcut to pass through.
	~#+s::return
	
	;Move to previous page
	s::Left
	;Move to next page
	f::Right

#if

class RestoreMouse
{
	mouseX := 
	mouseY := 
	;If true, will block and unblock mouse input.  A common pattern.
	blockMouseInput := false
	mouseMoveSpeed := 

	__New(blockMouseInput := false, mouseMoveSpeed := 100)
	{
		this.blockMouseInput := blockMouseInput
		this.mouseMovespeed := mouseMoveSpeed
		;By default save the current position.
		this.Save()

	}

	Set(x,y) {
		this.mouseX := x
		this.mouseY := y
	}
	Save() {

		MouseGetPos x, y

		this.mouseX := x
		this.mouseY := y
	}

	Restore() {

		if(blockMouseInput) {
			BlockInput, MouseMove
		}

		x := this.mouseX
		y := this.mouseY
		mouseMoveSpeed := this.mouseMoveSpeed
		MouseMove %x%, %y%, %mouseMoveSpeed%

		if(this.blockMouseInput)
		{
			BlockInput, MouseMoveOff
		}
	}

	ToString() {
		return % "x:" this.mouseX " y:" this.MouseY
	}

}