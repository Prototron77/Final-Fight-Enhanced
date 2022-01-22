; ----------------------------------------------------------------------------------------------------------
;		SUBROUTINES & FUCNTIONS
; ----------------------------------------------------------------------------------------------------------
	
;----------------------------------------------------------------------------------------------------------
;	CHANGE PALETTE ENTRY FOR RASTERTIME
;----------------------------------------------------------------------------------------------------------
	
CHECK_RASTERTIME:
	move.l a0,-(sp)
		lea 	$dff000,a0
		move.w #$777,$180(a0)
	move.l (sp)+,a0
	RTS

;----------------------------------------------------------------------------------------------------------
;	SWITCH SCREEN BUFFERS (MAIN GAME)
;----------------------------------------------------------------------------------------------------------

SWITCH_SCREENBUFFERS:		
				

	;-----------------------------------------------
	; 	POKE BITPLANE POINTERS
	;-----------------------------------------------
	
	movea.l 	DOUBLE_BUFFER,a0					; Screen Buffer Address List
	add.w 		#SCR_BPL*(32*4)+SCR_OFFSET,a0		; Add positioning shit
	add.w 		(XVIEW+6),a0						; Add distance into Level

	;-----------------------------------------------
	;	SCREEN SHAKE
	;-----------------------------------------------
	
	btst 	#6,SCROLLFLAGS
	beq.s	.2
	bsr.w 	SCREENSHAKE
.2
	;-----------------------------------------------
	; 	UPDATE BITPLANE POINTERS
	;-----------------------------------------------
	
	lea 	CoBplPr_MAIN,a1							; Where to poke the bitplane pointer words.
	moveq	#SCR_DEPTH-1,d0							; Loop Counter	
	
.Loop_DOUBLEBUFFER_POKE:
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)								; High word
	swap 	d1
	move.w 	d1,6(a1)								; Low word
	addq.l	#8,a1									; Point to next bpl to poke in copper
	lea		SCR_BPL(a0),a0 							; Interleaved bitmap (see BPLxMOD in copperlist)
	dbf 	d0,.Loop_DOUBLEBUFFER_POKE
	
		;-----------------------------------------------
	btst 	#3,SCROLLFLAGS
	beq.s	.1
	bsr.w 	BLIT_COLUMNS							; Blit Column to First Buffer
.1

	;-----------------------------------------------
	; 	SWITCH SCREEN BUFFERS
	;-----------------------------------------------
	
	movem.l DOUBLE_BUFFER,a0-a1						
	exg 	a0,a1
	movem.l a0-a1,DOUBLE_BUFFER
	
	;-----------------------------------------------
	btst 	#3,SCROLLFLAGS
	beq.s	.3
	bclr 	#3,SCROLLFLAGS
	bsr.w 	BLIT_COLUMNS							; Blit Column to second Buffer
.3
	;-----------------------------------------------
	; 	SWITCH TILECLEANER TABLES
	;-----------------------------------------------
		
	movem.l TILECLEANER_TABLES,a0-a1				; Switch addresses in TILETABLE list
	exg 	a0,a1
	movem.l a0-a1,TILECLEANER_TABLES
	
	;-----------------------------------------------
	;	FADE IN
	;-----------------------------------------------
	
	btst 	#6,HUDFLAGS2
	beq.s	.4
	tst.b	(FADE+1)
	bne.s	.FI_DEL
	bsr.w 	FADEIN_MG
	move.b	#1,(FADE+1)		; Reset Fade Delay
.FI_DEL
	sub.b	#1,(FADE+1)
.4
	;-----------------------------------------------
	;	FADE OUT
	;-----------------------------------------------
	
	btst 	#7,HUDFLAGS2
	beq.s	.5
	tst.b	(FADE+1)
	bne.s	.FO_DEL
	bsr.w 	FADEOUT_MG
	move.b	#4,(FADE+1)		; Reset Fade Delay
.FO_DEL
	sub.b	#1,(FADE+1)
.5
	;-----------------------------------------------
	RTS
	;-----------------------------------------------
	
; ----------------------------------------------------------------------------------------------------------
;	SCREEN SHAKE (For slam moves and subway level)
; ----------------------------------------------------------------------------------------------------------	

SCREENSHAKE:
	
	tst.b	SCREENSHAKE_T
	bne.s	.3
	;-------------------------
	tst.b	SCREENSHAKE_VAR
	bne.s	.2
	move.b	#16,SCREENSHAKE_T
	;-------------------------
	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	;-------------------------
	move.b	#2,d1
	bsr.w	RNG
	move.b	d0,SCREENSHAKE_VAR
	bra.s	SCREENSHAKE_DONE
	;-------------------------
.2
	bset 	#7,SCROLLFLAGS
	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	move.b	SCREENSHAKE_VAR,d0
	rol.w	#2,d0
	mulu.w 	#SCR_BPL,d0
	sub.w 	d0,a0
	sub.b 	#1,SCREENSHAKE_VAR
	bra.s 	.4
	;-------------------------
.3
	sub.w 	#SCR_BPL*(0*4),a0
	sub.b	#1,SCREENSHAKE_T
.4
	
SCREENSHAKE_DONE:
	;-----------------------------------------------
	RTS
	
; 	SCREENSHAKE OLD
;	tst.b	SCREENSHAKE_VAR
;	bne.s	.2
;	btst 	#7,SCROLLFLAGS
;	beq.s 	.1
;	sub 	#SCR_BPL*(1*4),a0
;	bclr 	#7,SCROLLFLAGS
;	move.b	#8,SCREENSHAKE_VAR
;	bra.s 	.Done
;.1
;	sub 	#SCR_BPL*(0*4),a0
;	bset 	#7,SCROLLFLAGS
;	move.b	#12,SCREENSHAKE_VAR
;	bra.s 	.Done
;.2
;	move.b 	SCREENSHAKE_VAR,d0
;	subq	 #1,d0
;	move.b 	d0,SCREENSHAKE_VAR

; ----------------------------------------------------------------------------------------------------------	
; RANDOM NUMBER GENERATOR	
; - D0 = Lower Bound | D1 = Upper Bound | Number returned in d0
; ----------------------------------------------------------------------------------------------------------

MULT 	= 34564
INC		= 7682
SEED 	= 12032
MOD 	= 65535

RNG:
	moveq 	#0,d0

	moveq 	#0,d2
	move.l 	d2,-(sp)
	; ----------------
	;sub.w 	d0,d1
	;sub.w 	#0,d1
	addq.w 	#1,d1
	move.w 	OLD_SEED,d2
	; ----------------
	mulu.w 	#MULT,d2
	add.l 	#INC,d2
	divu.w 	#MOD,d2
	swap 	d2
	move.w 	d2,OLD_SEED
	; ----------------
	mulu.w 	d1,d2
	divu.w 	#MOD,d2
	add.w 	d2,d0
	move.l 	(sp)+,d2
	; ----------------
	RTS
	; ----------------

OLD_SEED: dc.w SEED
	EVEN

;-------------------------------------------------------------------------------
;	CURVALS
;-------------------------------------------------------------------------------

LD_CURRVALS:	
	move.b #5-1,d0		
.lp_bltcur
	move.b (a4)+,d1
	move.b d1,(a5)+
	dbf d0,.lp_bltcur
	RTS
	
;-------------------------------------------------------------------------------
;	TEXT FLASH
;-------------------------------------------------------------------------------

TEXT_FLASH:

	move.b 	TEXTFLASH_T,d0
	sub.b	#1,d0
	move.b 	d0,TEXTFLASH_T
	
	tst TEXTFLASH_T
	bne.s .1
	
	btst #4,HUDFLAGS
	bne.s .SHOW
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS					; Draw to HUD SCREEN
	move.l 	#0,a2						; Fill with 0
	move.w 	#$00D8,(TILETABLE)			; Set X for DRAW
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$4008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	bra.s	.1
	;---------------------------------------------------------
.SHOW
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS					; Draw to HUD SCREEN
	move.l 	#0,a2						; Fill with 0
	move.w 	#$00D8,(TILETABLE)			; Set X for DRAW
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$4008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
.1
	RTS
		
;-------------------------------------------------------------------------------
;	TEXT FLASH
;-------------------------------------------------------------------------------

TS_TEXT_FLASH:

	move.b 	TEXTFLASH_T,d0
	sub.b	#1,d0
	move.b 	d0,TEXTFLASH_T
	
	tst TEXTFLASH_T
	bne.s .1
	
	btst #4,HUDFLAGS
	bne.s .SHOW
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS					; Draw to HUD SCREEN
	move.l 	#0,a2						; Fill with 0
	move.w 	#$0060,(TILETABLE)			; Set X for DRAW
	move.w 	#$0C,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$6008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	bra.s	.1
	;---------------------------------------------------------
.SHOW
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS					; Draw to HUD SCREEN
	move.l 	#0,a2						; Fill with 0
	move.w 	#$0060,(TILETABLE)			; Set X for DRAW
	move.w 	#$0C,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$6008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
.1
	RTS

;------------------------------------------------------------------------------------------------------------
;	FADES (MAIN GAME)
;-----------------------------------------------------------------------------------------------------------
	
FADEIN_MG:

	movem 	a0/a1/d0/d1,-(sp)
	;---------------------------------------
	cmp.b 	#0,FADE
	bgt.s 	.1
	lea 	PalGame6,a0	   					; Pointer to Palette values		
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.1
	cmp.b 	#1,FADE
	bgt.s 	.2
	lea 	PalGame5,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.2
	cmp.b 	#2,FADE
	bgt.s 	.3
	lea 	PalGame4,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.3
	cmp.b 	#3,FADE
	bgt.s 	.4
	lea 	PalGame3,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.4
	cmp.b 	#4,FADE
	bgt.s 	.5
	lea 	PalGame2,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.5
	cmp.b 	#5,FADE
	bgt.s 	.6
	lea 	PalGame1,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.6
	lea 	PalGame,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bclr 	#6,HUDFLAGS2
	move.b 	#0,(FADE)
	;---------------------------------------
FADEIN_DONE:
	movem (sp)+,a0/a1/d0/d1
	;---------------------------------------
	RTS
	;---------------------------------------
	
FADEOUT_MG:

	movem 	a0/a1/d0/d1,-(sp)
	
	;---------------------------------------
	
	cmp.b 	#0,FADE
	bgt.s 	.1
	lea 	PalGame1,a0	   					; Pointer to Palette values		
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.1
	cmp.b 	#1,FADE
	bgt.s 	.2
	lea 	PalGame2,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.2
	cmp.b 	#2,FADE
	bgt.s 	.3
	lea 	PalGame3,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.3
	cmp.b 	#3,FADE
	bgt.s 	.4
	lea 	PalGame4,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.4
	cmp.b 	#4,FADE
	bgt.s 	.5
	lea 	PalGame5,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.5
	cmp.b 	#5,FADE
	bgt.s 	.6
	lea 	PalGame6,a0	   					; Pointer to Palette values	
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.6
	lea 	PalGame7,a0	   					; Pointer to Palette values	
	bsr.b	FADE_POKE
	bclr 	#7,HUDFLAGS2
	move.b 	#0,(FADE)	
	;---------------------------------------
FADEOUT_DONE:
	movem (sp)+,a0/a1/d0/d1
	;---------------------------------------
	RTS
	;---------------------------------------
	
FADE_POKE:
	moveq 	#0,d0
	moveq 	#0,d1
	
	lea 	PALETTE_MAIN,a1					; Where to poke the bitplane pointer words.
	moveq	#16-1,d0						; Loop Counter	

.lp_LOADPALETTE:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE
	add.b 	#1,(FADE)
	;---------------------------------------
	RTS
	;---------------------------------------