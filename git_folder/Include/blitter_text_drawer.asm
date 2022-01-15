;-----------------------------------------------------------------------------------------------------------
;	DRAW TEXT WITH BLITTER
;
;		- I gave up on this and just used the CPU to draw text, as it was too much of a pain
;		with all the shifting and positioning.
;-----------------------------------------------------------------------------------------------------------
	
BLITTER_TEXT_DRAWER:	

TEXT_LOOP:
	moveq 	#0,d0
	moveq 	#0,d1
	move.b 	(a0)+,d0					; Load Ascii character
	sub.w 	#32,d0						; Sub 32 to get value
	move.b 	(a1,d0.w),d0				; Get correct sheet number
	lea 	HUDCHARS_SHEET_OFFSETS,a2	; Load offsets table
	add 	d0,d0						; Double for WORD offsets
	add 	d0,a2						; Add to Offsets table
	move.b	(a2),d0						; Get X Offset
	add 	#1,a2						; Add 1 to move to next BYTE
	move.b	(a2),d1						; Get Y Offset
	move.l	d7,-(sp)					; Store loop counter
	;---------------------------------------------------------
	btst	#2,HUDFLAGS
	bne.s 	.TurnTextShiftOff			; if it is then turn off
	bset	#2,HUDFLAGS					; Set correct MASK
	move.b	#8,(TILETABLE+6)
	bra.s	.TextShiftDone
.TurnTextShiftOff	
	bclr	#2,HUDFLAGS					; Set correct MASK
	move.w	#0,(TILETABLE+6)
.TextShiftDone
	;---------------------------------------------------------
	bsr 	TILE_DRAWER
	;---------------------------------------------------------
	move.l	(sp)+,d7					; Restore loop counter
	;---------------------------------------------------------
	
	add.w 	#16,(TILETABLEs)			; Move Across Screen

	;---------------------------------------------------------
	dbra d7,TEXT_LOOP
	;---------------------------------------------------------
	RTS