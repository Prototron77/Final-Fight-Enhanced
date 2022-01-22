;--------------------------------------------------------------------------------------------------------------
; TITLESCREEN ELEMENTS
;--------------------------------------------------------------------------------------------------------------

TS_CREDITS:
	

TS_STARTX 	= $0000
TS_STARTY 	= 20

	bset 	#0,HUDFLAGS2				; TYPEWRITER MODE
		
	;---------------------------------------------------------
	; 	CREDITS:
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_FFTM,a0				; Load String to be printed
		
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$20,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------


	;---------------------------------------------------------
	; 	TITLE MUSIC1
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_ALLRIGHTS,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$30,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	TITLE MUSIC1
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_PROTOCREDITS,a0		; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$40,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	BACKGROUND GRAPHICS 1
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_TITLEMUSIC,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$50,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;---------------------------------------------------------
	; 	BACKGROUND GRAPHICS 2
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_BGGCREDITS,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$60,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	PROTOTRON CREDITS 1
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_BGGCREDITS2,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$70,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	PROTOTRON CREDITS 2
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_CONTROLS,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$80,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	COPYRIGHT 1
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_CONTROLSA,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$90,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	CONTROLS JUMP
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_CONTROLSJ,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$A0,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	CONTROLS SPECIAL
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_CONTROLSS,a0			; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$B0,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	RAM
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO
	
	lea 	TEXT_1MB,a0					; Load String to be printed
	
	move.w 	#TS_STARTX,(TILETABLE)		; Set X for DRAW
	move.w 	#$D0,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	

	;---------------------------------------------------------
	RTS
	;---------------------------------------------------------
	