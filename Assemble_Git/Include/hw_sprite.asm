;--------------------------------------------------------------------------------------------------------------
;		SPRITE TEST
;--------------------------------------------------------------------------------------------------------------

HW_SPRITES:

	movem.l	a0-a1/d1,-(sp)
	
	btst 	#1,SCROLLFLAGS2
	bne.w	TRAINLIGHTS_DONE
	;---------------------------------------
	
	lea 	SprPtr_HUD,a1					; Where to poke the Sprite pointers in the Copper
		
	;---------------------------------------
	; 	SPRITE 0
	;---------------------------------------
	
HWSPRITE0:	

	lea 	SPR_TRAINLIGHT_L,a0	   			; Sprite Data

	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	
	;---------------------------------------
	; 	SPRITE 1
	;---------------------------------------
	
HWSPRITE1:	

	lea 	SPR_TRAINLIGHT_R,a0				; Sprite Data
	
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	
	;---------------------------------------
	; 	SPRITE 2
	;---------------------------------------
	
HWSPRITE2:	

	lea 	SPR_BLANKSPRITE,a0			; Sprite Data

	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	
	;---------------------------------------
	; 	SPRITE 3
	;---------------------------------------
	
HWSPRITE3:

	lea 	SPR_BLANKSPRITE,a0				; Sprite Data
	
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	
	;---------------------------------------
	; 	SPRITE 4
	;---------------------------------------
	
HWSPRITE4:

	lea 	SPR_BLANKSPRITE,a0				; Sprite Data
	
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	
	;---------------------------------------
	; 	SPRITE 5
	;---------------------------------------
	
HWSPRITE5:

	lea 	SPR_BLANKSPRITE,a0				; Sprite Data
	
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	
	;---------------------------------------
	; 	SPRITE 6 
	;---------------------------------------
	
HWSPRITE6:

	lea 	SPR_BLANKSPRITE,a0				; Sprite Data

	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
;	addq.l	#8,a1							; Point to next bpl to poke in copper

	;---------------------------------------
	; 	SPRITE 7 (Disabled for scrolling)
	;---------------------------------------
	
HWSPRITE7:

;	lea 	SPR_BLANKSPRITE,a0				; Sprite Data
	
;	move.l 	a0,d1
;	swap 	d1
;	move.w 	d1,2(a1)						; High word
;	swap 	d1
;	move.w 	d1,6(a1)						; Low word
;	addq.l	#8,a1							; Point to next bpl to poke in copper

	;---------------------------------------
	;	ENABLE SPRITE DMA
	;---------------------------------------
	
	move.w 	#%1000000000100000,$dff096		
	
	;---------------------------------------
	;	MOVE SPRITES (Off for now)
	;---------------------------------------
	
	move.b 	(SPR_TRAINLIGHT_L+1),d0
	sub.b 	#9,d0
	
	move.b 	d0,(SPR_TRAINLIGHT_L+1)
	addq	#8,d0
	move.b 	d0,(SPR_TRAINLIGHT_R+1)
			
	;---------------------------------------
TRAINLIGHTS_DONE:
		
	movem.l	(sp)+,a0-a1/d1		

	;---------------------------------------
	RTS
	;---------------------------------------