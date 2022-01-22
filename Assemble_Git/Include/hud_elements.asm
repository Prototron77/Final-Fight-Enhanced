	;---------------------------------------------------------
	;	DRAW HUD ELEMENTS
	;---------------------------------------------------------
	
HUD_ELEMENTS:
	btst 	#7,HUDFLAGS
	bne.w	.Debugger

	;---------------------------------------------------------
	;	TIME (Left half)
	;---------------------------------------------------------
	
	bclr 	#1,HUDFLAGS
	moveq 	#0,d0
	move.b 	#11,d0						; Icon number
	move.w 	#$00A0,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;	TIME (Right Half)
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS
	moveq 	#0,d0
	move.b 	#23,d0						; Icon number
	move.w 	#$00B0,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;	TIME - LEFT NUMBER
	;---------------------------------------------------------
	
	bclr 	#1,HUDFLAGS
	moveq 	#0,d0
	move.b 	#31,d0						; Icon number
	move.w 	#$00A0,(TILETABLE)			; Set X for DRAW
	move.w 	#$10,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;	TIME - RIGHT NUMBER
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS
	moveq 	#0,d0
	move.b 	#24,d0						; Icon number
	move.w 	#$00B0,(TILETABLE)			; Set X for DRAW
	move.w 	#$10,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;	P1 BAR BACK
	;---------------------------------------------------------
	
	bclr 	#1,HUDFLAGS
	move.w 	#$0020,(TILETABLE)			; Set X for DRAW
		moveq 	#0,d7
	move.b 	#6,d7
.P1BarLoop
	moveq 	#0,d0
	move.b 	#74,d0						; Icon number

	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------

	move.l d7,-(sp)
	bsr.w 	BLITTER_ICON_DRAWER
	move.l (sp)+,d7
	add.w	#$10,(TILETABLE)
	dbra 	d7,.P1BarLoop
	
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;	P1 BAR BACK END
	;---------------------------------------------------------
	
	bclr 	#1,HUDFLAGS

	moveq 	#0,d0
	move.b 	#79,d0						; Icon number
	move.w 	#$0090,(TILETABLE)			; Set X for DRAW
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------

	bsr.w 	BLITTER_ICON_DRAWER

	;---------------------------------------------------------
	
	;---------------------------------------------------------
	;	P1 HEAD ICON
	;---------------------------------------------------------
	
	bclr 	#1,HUDFLAGS
	moveq 	#0,d0
	move.b 	#2,d0						; Icon number
	move.w 	#$0010,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; P1 NAME
	;---------------------------------------------------------

	bsr.w	LOAD_HUDFONT
	
	;-----------------------------------
	lea 	TEXT_HAGGAR,a0				; Load String to be printed
	;-----------------------------------
	
	move.w 	#$0028,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; =
	;---------------------------------------------------------

	bsr.w	LOAD_HUDFONT
	
	lea 	TEXT_EQU,a0					; Load String to be printed
	
	move.w 	#$0080,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; P1 Lives
	;---------------------------------------------------------

	bsr.w	LOAD_HUDFONT
	
	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d7
	move.b 	(OBJECT_1+3),d1
	
	bsr.w 	CONVERT_VALUES
	move.b	 d1,d0
	;lea 	TEXT_EQU,a0					; Load String to be printed
	
	move.w 	#$0088,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	bset 	#9,HUDFLAGS					; VARIABLE MODE
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; INSERT COIN
	;---------------------------------------------------------

	bsr.w	LOAD_HUDFONT
	
	lea 	TEXT_COIN,a0				; Load String to be printed
	
	move.w 	#$00E0,(TILETABLE)			; Set X for DRAW
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
		
	bra.w 	.Hud

;----------------------------------------------------------------------------------------------------------	
;	HUD DEBUGGER
;----------------------------------------------------------------------------------------------------------	

.Debugger	

	;----------------------------------------
	; 	VARIABLE NAME
	;----------------------------------------
	movem	d0-a6,-(sp)
		bclr	#7,HUDFLAGS
		move.w 	#$0010,(TILETABLE)			; Set X for DRAW
		move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
		move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
		lea 	TEXT_XVIEW,a0				; Load String
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	
	movem	d0-a6,-(sp)
		bclr	#7,HUDFLAGS
		move.w 	#$0010,(TILETABLE)			; Set X for DRAW
		move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
		move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
		lea 	TEXT_XVIEW2,a0				; Load String
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6	
	
		movem	d0-a6,-(sp)
		bclr	#7,HUDFLAGS
		move.w 	#$0010,(TILETABLE)			; Set X for DRAW
		move.w 	#$10,(TILETABLE+2)			; Set Y for DRAW
		move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
		lea 	TEXT_XVIEW3,a0				; Load String
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6	
	
.Hud
	;----------------------------------------
	RTS
	;----------------------------------------
	
;----------------------------------------------------------------------------------------------------------
	
LOAD_HUDFONT:
	lea 	HUDSHEET,a1						; Set source address
	lea 	HUDSCREEN,a2					; Set Destination address
	lea		HUDCHARS_SMALLFONT,a3			; Font Table
	lea 	HUDCHARS_SHEET_OFFSETS,a4		; Offsets table
	
	move.l 	a1,(CPU_TEXT_DRAWL)				; Transfer SOURCE address to list
	move.l 	a2,(CPU_TEXT_DRAWL+4)			; Transfer DESTINATION address to list
	move.l 	a3,(CPU_TEXT_DRAWL+8)			; Transfer FONT TABLE address to list
	move.l 	a4,(CPU_TEXT_DRAWL+12)			; Transfer OFFSETS TABLE address to list
	;----------------------------------------
	RTS
	;----------------------------------------
	

	
;----------------------------------------------------------------------------------------------------------
	

	