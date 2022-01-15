;-------------------------------------------------------------------------------------------------------------
; 	FX ANIMATER
;-------------------------------------------------------------------------------------------------------------


FX_ACTIVATE:

	movem	a2,-(sp)
	lea 	OBJECT_SLOTS,a2
	add 	#12,a2
;	bra.s	.1					; Temporary jump until I fix the below code

;FindFxSlot:
;	cmp.b	#-1,(a2)
;	beq.s	FX_ACTIVATE_DONE
;	tst.b	(a2)
;	beq.s	.1
;	add 	#1,a2
;	bra.s	FindFxSlot
;.1
	move.b 	#1,(a2)
	
FX_ACTIVATE_DONE:	

	movem	(sp)+,a2
	;--------------------------------
	RTS
	;--------------------------------
		
FX_HANDLER:
	
	movem.l	d1/a0-a1,-(sp)
	;moveq #0,d1
	;--------------
	tst.b	(OBJECT_SLOTS+12)
	beq.s	.1
	lea 	OBJECT_13,a0
	bsr.w	FX_ANIMATE
;	bra.s	FX_HANDLER_END
	;--------------
.1

FX_HANDLER_END:
	movem.l	(sp)+,d1/a0-a1
	;--------------------------------
	RTS
	;--------------------------------
	
FX_ANIMATE:

	move.w	(FX_XY),OBJ_X(a0)		; XY of where FX is to appear
	move.b	(FX_S),OBJ_S(a0)		; S of where FX is to appear
	add.b	#5,OBJ_Y(a0)
	move.b	(FX_Z),OBJ_Z(a0)		; Z-Height in relation to Y
		
	tst.b 	OBJ_TIMER(a0)
	bne.s	.1
	
	cmp.b 	#1,OBJ_FRAME(a0)
	blt.s	.2
	
	lea 	OBJECT_SLOTS,a1
	moveq 	#0,d1
	move.b	OBJ_NUMBER(a0),d1
	add.w 	d1,a1
	sub 	#1,a1
	move.b	#0,(a1)
	move.b	#4,OBJ_TIMER(a0)
	move.b	#0,OBJ_FRAME(a0)
	bra.s	.3
.2
	add.b 	#1,OBJ_FRAME(a0)
	move.b	#4,OBJ_TIMER(a0)
	bra.s	.3
.1	
	sub.b 	#1,OBJ_TIMER(a0)
.3
	;--------------------------------
	RTS
	;--------------------------------