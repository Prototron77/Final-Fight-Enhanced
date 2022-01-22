	;----------------------------------------
	; VARIABLE READOUT
	;----------------------------------------	
	
DEBUGGER1:

	movem	d0-a6,-(sp)
	;----------------------------------------

	bset	#7,HUDFLAGS
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;----------------------------------------
	;	CONVERT TO ASCII
	;----------------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d7
	
	lea 	OBJECT_1,a0
	move.b 	OBJ_STATE(a0),d1

	
	bsr.w CONVERT_VALUES
	
	;----------------------------------------
	;	DRAW
	;----------------------------------------
	
	;----------------------------------------
	; FIRST DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0048,(TILETABLE)			
		move.w 	d3,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	; SECOND DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0050,(TILETABLE)			
		move.w 	d2,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	; THIRD DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0058,(TILETABLE)			
		move.w 	d1,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	movem	(sp)+,d0-a6
	;----------------------------------------
	RTS
	;----------------------------------------
	
;----------------------------------------------------------------------------------------------------------			
DEBUGGER2:

	movem	d0-a6,-(sp)
	;----------------------------------------

	bset	#7,HUDFLAGS
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;----------------------------------------
	;	CONVERT TO ASCII
	;----------------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d7
	
	btst 	#11,HUDFLAGS				; TYPEWRITER MODE
	beq.s .1
	move.b 	#1,d1
.1

	bsr.w CONVERT_VALUES
	
	;----------------------------------------
	;	DRAW
	;----------------------------------------
	
	;----------------------------------------
	; FIRST DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0048,(TILETABLE)			
		move.w 	d3,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	; SECOND DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0050,(TILETABLE)			
		move.w 	d2,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	; THIRD DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0058,(TILETABLE)			
		move.w 	d1,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	movem	(sp)+,d0-a6
	;----------------------------------------
	RTS
	;----------------------------------------

;----------------------------------------------------------------------------------------------------------	
DEBUGGER3:

	movem	d0-a6,-(sp)
	;----------------------------------------

	bset	#7,HUDFLAGS
	move.w 	#$10,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;----------------------------------------
	;	CONVERT TO ASCII
	;----------------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d7
	
	lea 	OBJECT_SLOTS,a0
	add 	#$E,a0
	move.b 	(a0),d1

	
	bsr.b CONVERT_VALUES
	
	;----------------------------------------
	;	DRAW
	;----------------------------------------
	
	;----------------------------------------
	; FIRST DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0048,(TILETABLE)			
		move.w 	d3,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	; SECOND DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0050,(TILETABLE)			
		move.w 	d2,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	; THIRD DIGIT
	movem	d0-a6,-(sp)
		move.w 	#$0058,(TILETABLE)			
		move.w 	d1,d0	
		bsr.w 	CPU_TEXT_DRAWER
	movem	(sp)+,d0-a6
	;----------------------------------------
	movem	(sp)+,d0-a6
	;----------------------------------------
	RTS
	;----------------------------------------
	
;----------------------------------------------------------------------------------------------------------			
CONVERT_VALUES:

	divu.w 	#10,d1
	move.l	d1,d2
	move.l	d1,d3
	swap	d1
	swap	d2
	swap	d3
	move.w	#0,d2
	move.w	#0,d3
	swap 	d2
	swap 	d3
	divu.w 	#10,d2
	swap 	d2
	divu.w 	#10,d3
	
	add 	#48,d1
	add 	#48,d2
	add 	#48,d3
	
	;----------------------------------------
	RTS
	;----------------------------------------
