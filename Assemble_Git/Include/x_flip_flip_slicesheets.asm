;-------------------------------------------------------------------------------------------------------------
; FLIP SLICE SHEETS
;-------------------------------------------------------------------------------------------------------------

FLIP_SLICESHEETS:
	;-----------------------------------
	; HAGGAR
	;-----------------------------------
	lea 	HAGGAR_SLICESHEET_TABLE,a5
	lea 	HAGGAR_SLICE_SHEET,a1
	lea 	HAGGAR_SLICE_SHEET_MASK,a2	
	lea		HAGGAR_SLICE_SHEET_FLIP,a3	
	lea		HAGGAR_SLICE_SHEET_MASK_FLIP,a4

	move.l	a5,(XFLIP)
	move.l	a1,(XFLIP+4)
	move.l	a2,(XFLIP+8)
	move.l	a3,(XFLIP+12)
	move.l	a4,(XFLIP+16)
	bsr.w 	X_FLIP						; FLIP SPRITE/MASK SHEET & STORE (Should've been a Blitter operation)
	
	;-----------------------------------
	; BRED
	;-----------------------------------
	
	lea 	BRED_SLICESHEET_TABLE,a5
	lea 	BRED_SLICE_SHEET,a1
	lea 	BRED_SLICE_SHEET_MASK,a2	
	lea		BRED_SLICE_SHEET_FLIP,a3	
	lea		BRED_SLICE_SHEET_MASK_FLIP,a4

	move.l	a5,(XFLIP)
	move.l	a1,(XFLIP+4)
	move.l	a2,(XFLIP+8)
	move.l	a3,(XFLIP+12)
	move.l	a4,(XFLIP+16)
	bsr.w 	X_FLIP						; FLIP SPRITE/MASK SHEET & STORE (Should've been a Blitter operation)
	
	;-----------------------------------
	; J
	;-----------------------------------
	
	lea 	J_SLICESHEET_TABLE,a5
	lea 	J_SLICE_SHEET,a1
	lea 	J_SLICE_SHEET_MASK,a2	
	lea		J_SLICE_SHEET_FLIP,a3	
	lea		J_SLICE_SHEET_MASK_FLIP,a4

	move.l	a5,(XFLIP)
	move.l	a1,(XFLIP+4)
	move.l	a2,(XFLIP+8)
	move.l	a3,(XFLIP+12)
	move.l	a4,(XFLIP+16)
	bsr.w 	X_FLIP						; FLIP SPRITE/MASK SHEET & STORE (Should've been a Blitter operation)
	;-----------------------------------
	RTS