;--------------------------------------------------------------------------------------------------------------
; SHARED SUBS & FUNCTIONS
;--------------------------------------------------------------------------------------------------------------


;----------------------------------------------------------------------------------------------------------
;	WAIT FOR VERTICAL BLANK
;----------------------------------------------------------------------------------------------------------

VBLANK:
.loop	
	move.l	$dff004,d0
	and.l	#$1ff00,d0
	cmp.l	#$12c00,d0
	bne.b	.loop
	RTS
	
;-----------------------------------------------------------------------------------------------------------
;	CLEAR SCREEN
;-----------------------------------------------------------------------------------------------------------	

CLEARSCREEN:
	move.l 	d0,-(sp)
	;lea		BACK_BUFFER,a0
	moveq	#0,d0
	;move.w	#(BACK_BUFFER_END-BACK_BUFFER)/4-1,d1
ClrScreen:	
	move.l	d0,(a0)+
	dbf		d1,ClrScreen
	move.l (sp)+,d0
	RTS
	
;----------------------------------------------------------------------------------------------
;	WAIT FOR BLITTER
;----------------------------------------------------------------------------------------------	

WAITFORBLITTER:
.waitblit								; Wait for Blitter to finish
	btst #6,$002(a4)
	bne.s .waitblit	
	RTS
	
;------------------------------------------------------------------------------------------------------------
;	JOYSTICK READER
;-----------------------------------------------------------------------------------------------------------

JOYSTICK_READER: ;---7654S321RLDU

	move.b 	#%00111111,$BFE201			; Direction for port A (BFE001)...0=in 1=out...(For fire buttons)
	move.w 	$dff00A,d2					; Joystick-mouse 0 data (vert,horiz) (Joy2)	
	move.b 	$bfe001,d5					; /FIR1 /FIR0  /RDY /TK0  /WPRO /CHNG /LED  OVL	
	rol.b 	#1,d5						; Fire0 for joy 2
	bsr 	Player_ReadControlsOne		; Process Joy2	
	move.l 	d0,-(sp)
	move.w 	$dff00c,d2					; Joystick-mouse 1 data (vert,horiz) (Joy1)
	move.b 	$bfe001,d5					; /FIR1 /FIR0  /RDY /TK0  /WPRO /CHNG /LED  OVL	
	bsr 	Player_ReadControlsOne 		; Process Joy 1
	move.l 	(sp)+,d1
	
	;-----------------------------------
	RTS	
	;-----------------------------------
	
Player_ReadControlsOne:					; Translate HV data into joystick values
	moveq 	#0,d0	
	moveq 	#0,d1	
	moveq 	#0,d3	
	moveq 	#0,d4		
	
	;-----------------------------------
	; Get the 4 bits that are needed 
	;	for the directions
	;-----------------------------------
	
	roxr.l 	#1,d2						; bit 0
	roxl.l 	#1,d3	
	roxr.l 	#1,d2						; bit 1
	roxl.l 	#1,d4	
	roxr.l 	#7,d2						; bit 8
	roxl.l 	#1,d0	
	and.l 	#1,d2						; bit 9	
	
	;-----------------------------------
	;	Calculate the new directions
	;-----------------------------------
	
	move.b 	d2,d1
	eor.b 	d0,d1
	roxr.b 	d1
	roxr.b 	d0							; Up (Bit 9 Xor 8)
	move.b 	d4,d1
	eor.b 	d3,d1
	roxr.b 	d1
	roxr.b 	d0							; Down (Bit 1 Xor 0)	
	roxr.b 	d2
	roxr.b 	d0							; Left (Bit 9)	
	roxr.b 	d4
	roxr.b 	d0							; Right (Bit 1)
	roxl.b 	d5
	roxr.b 	d0							; Fire
	ror.b 	#3,d0
	eor.b 	#%11101111,d0				;Invert UDLR bits
	or.l 	#$FFFFFF00,d0				;Set unused bits
	
	;-----------------------------------
	RTS
	;-----------------------------------