; ------------------------------------------
; 	SCROLLING
; ------------------------------------------

CHECKSCROLL_R:

	btst 	#0,SCROLLFLAGS2
	bne.w	SCROLLRIGHT_END
	lea 	OBJECT_1,a1						; Load table address
	
	; -------------------------------------
	; BUTTONS & BOUNDARIES
	; -------------------------------------
	;moveq	#0,d2
	;move.w 	(TILETABLE+12),d1
	;cmp.w	#62,d1
	;cmp.w	#46,d1
	
	moveq	#0,d2
	move.w 	(TILETABLE+12),d1
	move.b	(LEVEL+1),d2
	sub		#18,d2
	cmp.w	d2,d1
	;cmp.w	#132,d1
	beq.w	.SkpScrollR						; Check if end of tilemap has been reached
	
;	bsr.w	JOYSTICK_READER					; Check if button is pushed
;	btst 	#3,d0
;	bne 	.skpscrl
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	
	; -------------------------------------
	; SCROLL PUSH BOUNDARY (RIGHT)
	; -------------------------------------
	
	move.b 	OBJ_X(a1),d1					; X
	move.b 	OBJ_S(a1),d2					; X Shift
	
	move.b	d1,d3
	move.b 	(XVIEW+3),d4
	sub.b 	d4,d1
	cmp.b	#-1,d1
	blt.w	.SkpScrollR
	
	move.b 	d3,d1
	
	lsl.w	#4,d1
	add.w 	d2,d1
	
	
	move.w 	(XVIEW),d3						; Get XVIEW Offset
	move.w	d3,d4
	; -------------------

	add.w 	#$00C4,d3						; If player is ahead of this boundary the scrolling
	cmp.w 	d3,d1							; is faster so that it can catch up to the walk speed
	bgt.s	.ScrlFast
	; -------------------
	move.w 	(XVIEW),d4						; Get XVIEW Offset
	add.w 	#$00C0,d4
	cmp.w 	d4,d1							; Compare X to RIGHT Scroll Boundary
	; -------------------
	
	blt.w	.SkpScrollR
	
.ScrlNorm
	move.w	#$22,d0
	move.w	#2,d1
	bra.s	.ScrlSpeed	
.ScrlFast
	move.w	#$44,d0
	move.w	#4,d1
	; -------------------------------------
	; SCROLL & UPDATE XVIEW VALUE
	; -------------------------------------
.ScrlSpeed	
	lea 	COPPER_SCROLL_SHIFT,a0
	sub.w	d0,2(a0)
	add.w 	d1,(XVIEW)						; Add 2 Pixels to XVIEW
	tst.w	2(a0)
	bgt.w 	SCROLLRIGHT_END
	
	; -------------------------------------
	; RESET SCROLL SHIFT (SCROLL DELAY VALUE)
	; -------------------------------------

	move.w 	#$ff,2(a0)						; Reset Shift value
	
	; ------------------
	addq.w 	#1,(XVIEW+2)					; Save WORD offset (XVIEW - LEFT)
	move.w	(XVIEW+2),d2
	add.w 	#21,d2
	move.w	d2,(XVIEW+4)					; Save WORD offset (XVIEW - RIGHT)
	; ------------------
	
	addq.w 	#2,(XVIEW+6)					; Add 2 to pointers offset for next time
	
	bset	#0,SCROLLFLAGS					; Flag for RIGHT Scroll
	bset 	#3,SCROLLFLAGS					; Flag for Column Blit
	bset 	#4,SCROLLFLAGS					; Flag for Tileclean Prev
	bset 	#5,SCROLLFLAGS					; Flag for Tileclean Prev reset

	; -------------------------------------		
	
.SkpScrollR

	; -------------------------------------	
	; SET XVIEW FAR LEFT
	; -------------------------------------	
;	moveq 	#0,d2
;	move.w 	(TILETABLE+12),d1
;	move.b	(LEVEL+1),d2
;	sub.b	#18,d2
;	cmp.w	d2,d1
;	blt.w	.setxviewR
	
;	lsl.w	d2
;	move.w	d2,(XVIEW)
	
;	lea 	COPPER_SCROLL_SHIFT,a0
;	move.w 	2(a0),d4
;	move.w 	#$11,d4
;	move.w 	d4,2(a0)

	
;	move.w 	(TILETABLE+12),d1				; If Map LEFT is reached make sure XVIEW sub is not skipped
;	cmp.w	#62,d1							
;	blt.w	.setxviewR
;	move.w	#994,(XVIEW)
.setxviewR
	
	; -------------------------------------	
		
SCROLLRIGHT_END:	

	RTS
	; -------------------------------------	

; ---------------------------------------------------------------------------------------------------------
	
CHECKSCROLL_L:
	lea 	OBJECT_1,a1							; Load table address
	; -------------------------------------	
	
	move.w 	(TILETABLE+12),d1
	cmp.w	#1,d1
	ble.w	.SkipScroll_L

.LeftCheck1	

	moveq	#0,d2
	moveq	#0,d4
	
	; -------------------------------------
	
	move.b 	OBJ_X(a1),d1					; X
	move.b 	OBJ_S(a1),d2					; X SHift
	
	lsl.w	#4,d1
	add 	d2,d1
	
	move.w 	(XVIEW),d3						; Get XVIEW Offset
	add.w 	#144,d3
	
	cmp.w 	d3,d1		
	bgt.b	.SkipScroll_L

	; -------------------------------------
	; SCROLL & UPDATE XVIEW VALUE
	; -------------------------------------
	
	bset 	#1,SCROLLFLAGS
	
	lea 	COPPER_SCROLL_SHIFT,a0
;	move. 	2(a0),d4
;	add.w 	#$22,d4
;	move.w 	d4,2(a0)						; Poke new shift value to Copper
	
	sub.w 	#2,(XVIEW)						; Sub 2 Pixels from XVIEW offset
	
	cmp.w	#$FF,d4							; Compare with max value
	blt.w 	.skp_resetscrollshift
	
	; -------------------------------------
	; RESET SCROLL WORD SHIFT
	; -------------------------------------

	move.w 	#$00,2(a0)						; Reset Shift value
	
	;lea 	MAINSCREEN+SCR_BPL*(32*4)+(SCR_OFFSET-2),a0
	;add.w 	(XVIEW+4),a0					; Add to Memory address
	;bsr.w	SCROLL_UPDATE_POINTERS
				; Add to Memory address
	;lea 	BACK_BUFFER+SCR_BPL*(32*4)+(SCR_OFFSET-2),a0
	
	move.l 	(DOUBLE_BUFFER),a0
	add 	#SCR_BPL*(32*4)+SCR_OFFSET-2,a0
	
	sub.w 	#2,(XVIEW+4)
	add.w 	(XVIEW+4),a0					; Sub from Memory address
	
	bclr	#0,SCROLLFLAGS					; Set GO LEFT
	bsr.w 	BLIT_COLUMNS					; Blit columns
	
	sub.w 	#1,(XVIEW+2)


	; -------------------------------------	
	; POKE COPPER WITH VALUES
	; -------------------------------------	
	
		bsr.w	SCROLL_UPDATE_POINTERS
.skp_resetscrollshift	
	; -------------------------------------	
.SkipScroll_L

	; -------------------------------------	
	; SET XVIEW FAR LEFT
	; -------------------------------------	
	move.w 	(TILETABLE+12),d1				; If Map LEFT is reached make sure XVIEW sub is not skipped
	cmp.w	#1,d1							
	bgt.w	.setxviewL
	move.w	#32,(XVIEW)
.setxviewL
	; -------------------------------------	

	RTS
	
	
;----------------------------------------------------------------------------------------------------------	
;
;----------------------------------------------------------------------------------------------------------
SCROLL_UPDATE_POINTERS:
	lea 	CoBplPr_MAIN,a1					; Where to poke the bitplane pointer WORDS
	moveq	#SCR_DEPTH-1,d5					; Loop Counter	
.lp_BPL_MAINSC:
	move.l 	a0,d4
	swap 	d4
	move.w 	d4,2(a1)						; High word
	swap 	d4
	move.w 	d4,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	lea		SCR_BPL(a0),a0 					; interleaved bitmap (see BPLxMOD in copperlist)
	dbf 	d5,.lp_BPL_MAINSC
	RTS