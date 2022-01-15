;-----------------------------------------------------------------------------------------------------------
; 	TS_SUBS
;-----------------------------------------------------------------------------------------------------------

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