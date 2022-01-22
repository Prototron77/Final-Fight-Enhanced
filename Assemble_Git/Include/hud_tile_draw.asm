;---------------------------------------------------------
;	HUD BLIT FUNCTION 
;---------------------------------------------------------

TILE_DRAWER:
	
	;---------------------------------------------------------
	;	CONVERT X/Y FOR GRAB
	;---------------------------------------------------------
	; (SCREEN BYTES*(V-LINES DOWN*BITPLANES)+ H-BYTES OFFSET)
	
	; X
		lsl.w	#4,d0
		ror.w	#3,d0
	; Y
		lsl.w	#3,d1
		mulu.w 	#5,d1
		mulu.w 	#24,d1				; Multiply by dest modulo

	add 	d1,d0	
	lea 	HUDSHEET,a2				; Set source address
	add 	d0,a2
	
	;---------------------------------------------------------	
	
	move.l 	#22,d7					; Set SOURCE modulo (24-2)
	
	;---------------------------------------------------------	

	btst	#0,HUDFLAGS				; ICON (16x16) or Text (16x8)
	bne.s	.textwh
	move.w 	#$1010,(TILETABLE+4)	; Set WIDTH & HEIGHT
	bra.s 	.textwh_done
.textwh
	move.w 	#$1008,(TILETABLE+4)	; Set WIDTH & HEIGHT
.textwh_done
	
	;---------------------------------------------------------
	bsr.w 	BLIT_TILES				; CALL BLITTER ROUTINE
	;---------------------------------------------------------
	
	RTS