;-----------------------------------------------------------------------------------------------------------
; 	TITLE SCREEN CHANGE
;-----------------------------------------------------------------------------------------------------------

TS_SCRVAR = $0800

TS_SCREENCHANGE:
	
	tst.b	(TS_TIMER_SCR)
	bne.s	.1
	;--------------------------------
	lea		TITLE_SCREEN,a0
	move.w	#(TITLE_SCREEN_END-TITLE_SCREEN)/4-1,d1
	bsr.w	CLEARSCREEN	
	;--------------------------------
	btst 	#0,TSFLAGS
	bne.s	.2
	;--------------------------------
	bclr	#1,TSFLAGS
	bsr.w 	TSCP_CREDITS	
	bsr.w 	TS_CREDITS			
	move.w	#$0480,(TS_TIMER_SCR)

	bset 	#0,TSFLAGS
	bra.s	.3
	;--------------------------------
.2	
	bset 	#6,HUDFLAGS2
	bsr.w 	TSCP_MAIN	
	bsr.w 	TS_MAIN		
	move.w	#$0900,(TS_TIMER_SCR)
	bclr 	#0,TSFLAGS
	bra.s	.3
	;--------------------------------
.1	
	sub.w	#1,(TS_TIMER_SCR)
.3
	;--------------------------------
	RTS
	;--------------------------------
	
;--------------------------------------------------------------------------------------------------------------
; TITLESCREEN ELEMENTS
;-----------------------------------------------------------------------------------------------------------

TS_MAIN:

	;---------------------------------------------------------
	; 	LOGO
	;---------------------------------------------------------
		
	bsr.w 	BLIT_LOGO					; Blit Logo Bitmap	
		
	;---------------------------------------------------------
	; 	ENHANCED
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_INTRO	
	lea 	TEXT_ENHANCED,a0			; Load String to be printed		
	move.w 	#$0060,(TILETABLE)			; Set X for DRAW
	move.w 	#$A8,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0810,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bclr 	#0,HUDFLAGS2
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	PUSH 1P START
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_SMALL	
	lea 	TEXT_PUSH1P_START,a0		; Load String to be printed	
	move.w 	#$0068,(TILETABLE)			; Set X for DRAW
	move.w 	#$C8,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0808,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------

	;---------------------------------------------------------
	; 	CAPCOM
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_SMALL	
	lea 	TEXT_CAPCOM,a0				; Load String to be printed	
	move.w 	#$0050,(TILETABLE)			; Set X for DRAW
	move.w 	#$E0,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0808,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; 	2021 PROTOTRON
	;---------------------------------------------------------
	
	bsr.w 	LOAD_TITLEFONT_SMALL
	lea 	TEXT_PROTOTRON,a0			; Load String to be printed
	move.w 	#$0068,(TILETABLE)			; Set X for DRAW
	move.w 	#$E9,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0808,(TILETABLE+4)		; Set WIDTH & HEIGHT

	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	

	RTS
	
;----------------------------------------------------------------------------------------------------------
;	TITLE SCREEN PALLETE POKE
;----------------------------------------------------------------------------------------------------------

TSCP_MAIN:
	lea 	PalTITLE7,a0	   				; Pointer to Palette values
	lea 	PALETTE_TS,a1					; Where to poke the bitplane pointer words.
	moveq	#32-1,d0						; Loop Counter	

.lp_LOADPALETTE_TS:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_TS
	

	lea 	TSCP_WAIT1,a1				; Where to poke the bitplane pointer words.

	move.w 	#$CF01,(a1)+
	move.w 	#$FF00,(a1)+
	
	bsr.w 	TS_PALLETPOKE_YEL
	;-----------------------------------
	lea 	TSCP_WAIT2,a1				; Where to poke the bitplane pointer words.

	move.w 	#$CF01,(a1)+
	move.w 	#$FF00,(a1)+
	
	bsr.w 	TS_PALLETPOKE_PURPLE
	;-----------------------------------
	lea 	TSCP_WAIT3,a1				; Where to poke the bitplane pointer words.

	move.w 	#$F001,(a1)+
	move.w 	#$FF00,(a1)+
	
	bsr.w 	TS_PALLETPOKE_YEL
	;-----------------------------------
	RTS
	
TSCP_CREDITS:

	;-----------------------------------
	lea 	TSCP_WAIT1,a1				; Where to poke the bitplane pointer words.
	move.w 	#$1001,(a1)+
	move.w 	#$FF00,(a1)+
	bsr.w 	TS_PALLETPOKE_BLUE
	;-----------------------------------
	lea 	TSCP_WAIT2,a1				; Where to poke the bitplane pointer words.
	move.w 	#$AB01,(a1)+
	move.w 	#$FF00,(a1)+

	bsr.w 	TS_PALLETPOKE_YEL
	;-----------------------------------
	lea 	TSCP_WAIT3,a1				; Where to poke the bitplane pointer words.
	move.w 	#$FB01,(a1)+
	move.w 	#$FF00,(a1)+
	bsr.w 	TS_PALLETPOKE_PURPLE
	;-----------------------------------
	RTS


;---------------------------------------	
TS_PALLETPOKE_BLUE:

	lea 	PalINTROTEXT_BLUE,a0	   		; Pointer to Palette values

	moveq	#7-1,d0							; Loop Counter	

.lp_LOADPALETTE_TS:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_TS
	;---------------------------------------
	RTS
	;---------------------------------------

;---------------------------------------		
TS_PALLETPOKE_YEL:

	lea 	PalINTROTEXT_YEL,a0	   			; Pointer to Palette values
	moveq	#7-1,d0							; Loop Counter	

.lp_LOADPALETTE_TS:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_TS
	;---------------------------------------
	RTS
	;---------------------------------------

;---------------------------------------		
TS_PALLETPOKE_RED:

	lea 	PalINTROTEXT_RED,a0	   			; Pointer to Palette values
	moveq	#7-1,d0							; Loop Counter	

.lp_LOADPALETTE_TS:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_TS
	;---------------------------------------
	RTS
	;---------------------------------------

;---------------------------------------		
TS_PALLETPOKE_PURPLE:

	lea 	PalINTROTEXT_PURPLE,a0	   		; Pointer to Palette values
	moveq	#7-1,d0							; Loop Counter	

.lp_LOADPALETTE_TS:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_TS
	;---------------------------------------
	RTS
	;---------------------------------------
	
;-----------------------------------------------------------------------------------------------------------
; 	TEXT FLASH (For PUSH 1P START)
;-----------------------------------------------------------------------------------------------------------	

TS_PUSHSTART_FLASH:
	
	tst.b	(TS_TIMER_TEXTFLASH)
	bne.w	.1
	
	btst 	#1,TSFLAGS
	bne.b	.2	
	;-----------------
	bsr.w 	LOAD_TITLEFONT_SMALL	
	lea 	TEXT_PUSH1P_START,a0		; Load String to be printed	
	move.w 	#$0068,(TILETABLE)			; Set X for DRAW
	move.w 	#$C8,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0808,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bclr 	#0,HUDFLAGS2
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	bset 	#1,TSFLAGS	
	bra.s 	.3
	;-----------------
.2
	;-----------------
	bsr.w 	LOAD_TITLEFONT_SMALL	
	lea 	TEXT_PUSH1P_STARTC,a0		; Load String to be printed	
	move.w 	#$0068,(TILETABLE)			; Set X for DRAW
	move.w 	#$C8,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$0808,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bclr 	#0,HUDFLAGS2
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	bclr	#1,TSFLAGS
	;-----------------
.3
	move.b	#$40,(TS_TIMER_TEXTFLASH)
	bra.s 	.4
.1	
	sub.b	#1,(TS_TIMER_TEXTFLASH)
.4
	;----------------------------------------
	RTS
	;----------------------------------------

;------------------------------------------------------------------------------------------------------------
; 	TEXT LOADER SUBS
;-----------------------------------------------------------------------------------------------------------	

LOAD_TITLEFONT_INTRO:
	lea 	TS_CHARS,a1						; Set Image source address
	lea 	TITLE_SCREEN,a2					; Set Destination address
	lea		TS_INTROFONT,a3					; Font Table
	lea 	TS_CHARS_OFFSETS,a4				; Offsets table
	
	move.l 	a1,(CPU_TEXT_DRAWL)				; Transfer SOURCE address to list
	move.l 	a2,(CPU_TEXT_DRAWL+4)			; Transfer DESTINATION address to list
	move.l 	a3,(CPU_TEXT_DRAWL+8)			; Transfer FONT TABLE address to list
	move.l 	a4,(CPU_TEXT_DRAWL+12)			; Transfer OFFSETS TABLE address to list
	;----------------------------------------
	RTS
	;----------------------------------------	
	
LOAD_TITLEFONT_SMALL:

	lea 	TS_CHARS,a1						; Set Image source address
	lea 	TITLE_SCREEN,a2					; Set Destination address
	lea		TS_SMALLFONT,a3					; Font Table
	lea 	TS_CHARS_OFFSETS,a4				; Offsets table
	
	move.l 	a1,(CPU_TEXT_DRAWL)				; Transfer SOURCE address to list
	move.l 	a2,(CPU_TEXT_DRAWL+4)			; Transfer DESTINATION address to list
	move.l 	a3,(CPU_TEXT_DRAWL+8)			; Transfer FONT TABLE address to list
	move.l 	a4,(CPU_TEXT_DRAWL+12)			; Transfer OFFSETS TABLE address to list
	;----------------------------------------
	RTS
	;----------------------------------------