;---------------------------------------------------------
;	DRAW TEXT USING CPU
;---------------------------------------------------------
	
CPU_TEXT_DRAWER:	
		
	btst	#7,HUDFLAGS
	bne.s	.draw_debugger1	
	;---------------------------------------------------------

	btst 	#9,HUDFLAGS
	bne.s	.1
	moveq 	#0,d7
	move.b 	(a0),d7						; Load Letter count (First BYTE)
.1
	add 	#1,a0
	;--------------------------------------------------------
.draw_debugger1	
	;move.w 	#TSCR_B_WIDTH,d3
	move.w 		#40*5,d3
	;move.w 	#HSCR_W,d4	
	;---------------------------------------------------------	
	
TEXT_LOOP:

	btst 	#0,HUDFLAGS2
	beq.s	.1
.TYPEWRITER_LOOP
	sub.w 	#1,(TEXT_TIMER)
	tst.w 	(TEXT_TIMER)
	bne.s	.TYPEWRITER_LOOP
	move.w 	#$4444,(TEXT_TIMER)
.1
	
	;---------------------------------------------------------
	
	move.l 	(CPU_TEXT_DRAWL),a1			; Set source address
	move.l 	(CPU_TEXT_DRAWL+4),a2		; Set Destination address
	
	;---------------------------------------------------------
GET_TEXT_NUMBER:
	btst	#7,HUDFLAGS
	bne.s	.draw_debugger2	

	moveq 	#0,d1
	
	btst 	#9,HUDFLAGS
	bne.s	.1
	moveq 	#0,d0
	move.b 	(a0)+,d0					; Load Ascii character
.1
	bclr	#9,HUDFLAGS
	;move.b 	#$6d,d0
.draw_debugger2	
	sub.w 	#32,d0						; Sub 32 to get value
	move.l 	(CPU_TEXT_DRAWL+8),a3		; Load Font table	
	move.b 	(a3,d0.w),d0				; Get correct sheet number
	;---------------------------------------------------------
	; WHICH SHEET?
	;---------------------------------------------------------
	
	btst 	#4,HUDFLAGS
	bne.s	GAMETEXT
	;------------------
INTROTEXT:

	cmp.w 	#$A4,d0						
	bgt.s	.Set_X_16_T
	bclr	#3,HUDFLAGS
	bra.s	.Set_X_Done
.Set_X_16_T
	bset	#3,HUDFLAGS
.Set_X_Done
	bra.s 	TEXT_OFFSETS
	;------------------
GAMETEXT:
	cmp.b 	#34,d0	
	blt.s	.Set_X_16_G
	bclr	#3,HUDFLAGS
	bra.s	.Set_X_Done
.Set_X_16_G
	bset	#3,HUDFLAGS
.Set_X_Done
	;------------------
	
	;---------------------------------------------------------
TEXT_OFFSETS:
	move.l 	(CPU_TEXT_DRAWL+12),a4		; Load offsets table
	add.w 	d0,d0						; Double for WORD offsets
	add.w 	d0,a4						; Add to Offsets table
	moveq 	#0,d0
	move.b	(a4),d0						; Get X Offset
	addq	#1,a4						; Add 1 to move to next BYTE
	move.b	(a4),d1						; Get Y Offset
			
	;---------------------------------------------------------

	move.l	d7,-(sp)					; Store loop counter
	
	;---------------------------------------------------------
	;	CONVERT X/Y FOR GRAB
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; X - D0
	;---------------------------------------------------------
CPUTXT_X:	
	btst	#3,HUDFLAGS
	bne.s	.Set_16
.Set_8
	lsl.w	#3,d0;
	bra.s	.Set_XMUL_done
.Set_16
	lsl.w	#4,d0;
.Set_XMUL_done
	ror.w	#3,d0
		
	;---------------------------------------------------------
	; Y - D1
	;---------------------------------------------------------
CPUTXT_Y:	
	lsl.w	#3,d1
	mulu.w 	#5,d1
	
	btst 	#4,HUDFLAGS
	bne.s	.1
	mulu.w 	#40,d1						; Multiply by dest modulo
	bra.s 	.2
.1
	mulu.w 	#24,d1	
	;---------------------------------------------------------
.2	
	add 	d1,d0	
	add 	d0,a1						; Add offset to source to find letter
	
	;---------------------------------------------------------
	;	X/Y FOR PASTE
	; (bltY*HSCR_B_WIDTH)+(bltX/8)	
		
	
	move.w 	(TILETABLE),d1				; X-Coordinate
	lsr.w 	#3,d1
	add.w 	d1,a2	
	
	move.w 	(TILETABLE+2),d2			; Y-Coordinate (Lines) +1 Offset in Table
	mulu.w 	d3,d2	
	
	add.l 	d2,a2						; Add to screen offset for position
	
	;---------------------------------------------------------
	; DRAW
	;---------------------------------------------------------	
	
	move.b (TILETABLE+5),d7				; Height for number of lines drawn
	sub.b	#1,d7		

	;-----------------------
	btst 	#4,HUDFLAGS
	bne.s 	.3
	move.w 	#40,d2
	bra.s 	.DrawNextByte
.3
	move.w 	#24,d2
	;-----------------------
	
.DrawNextByte
	move.b 	(a1),(a2)					; Bitplane 1
	add		d2,a1
	add		#40,a2						; Add Screen Width in BYTES
	
	move.b 	(a1),(a2)					; Bitplane 2
	add		d2,a1
	add		#40,a2
	
	move.b 	(a1),(a2)					; Bitplane 3
	add		d2,a1
	add		#40,a2
	
	move.b 	(a1),(a2)					; Bitplane 4
	add		d2,a1
	add		#40,a2
	
	move.b 	(a1),(a2)					; Bitplane 5

	;---------------------------------------------------------	
	; NEXT LINE
	;---------------------------------------------------------	
	
	add		d2,a1
	add		#40,a2
	
	;---------------------------------------------------------		
	dbra 	d7,.DrawNextByte			; Repeat until character is drawn
	;---------------------------------------------------------	

	move.l	(sp)+,d7					; Restore loop counter

	;---------------------------------------------------------
	
	add.w 	#8,(TILETABLE)				; Move Across Screen
	
	;---------------------------------------------------------
	dbra 	d7,TEXT_LOOP
	;---------------------------------------------------------	

	RTS