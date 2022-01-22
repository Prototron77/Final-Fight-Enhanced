;------------------------------------------------------------------------------------------------------------
;	DRAW RECTANGLE
;------------------------------------------------------------------------------------------------------------

RX 	= 0
RY	= 1
RW	= 2
RH	= 3

DRAW_RECTANGLE:

	moveq #0,d0
	lea 	BLIT_TABLE,a0
	
	move.w 	OBJ_X(a0),(RECTANGLE1)
	move.w 	(RECTANGLE1),d0
	move.b 	OBJ_Y(a0),(RECTANGLE1+3)
	move.b 	(RECTANGLE1+3),d0
	move.b 	OBJ_FWIDTH(a0),(RECTANGLE1+5)
	move.b 	(RECTANGLE1+5),d0
	move.b 	OBJ_FHEIGHT(a0),(RECTANGLE1+7)
	move.b 	(RECTANGLE1+7),d0
	bsr.s 	BLIT_RECTANGLE
	RTS

BLIT_RECTANGLE:	; a2 = IMAGE TO BLIT

	;----------------------------------
	
	movem.l d0-a6,-(sp)					; Back up Registers to Stack
	
	;----------------------------------	
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4
	
	lea 	P1TABLE,a0
	lea 	MAINSCREEN,a3


	
	; -- CALCULATE X/Y OFFSET --	
	;bltOffs 	= (bltY*HSCR_B_WIDTH)+(bltX/8)	
			
	move.w 	OBJ_X(a0),d1				; X-Coordinate (Words)

	move.b	OBJ_Y(a0),d2				; Y-Coordinate (Lines) +1 Offset in Table
	move.w	#88,d3
	move.w 	OBJ_S(a0),d4				; X-Coordinate (Words)
	add.w 	d4,d1
	lsr.w 	#3,d1
	add.w 	d1,a3	
	mulu.w 	d3,d2	
	add.l 	d2,a3
		
	;----------------------------------
	
	; -- CALCULATE WIDTH & HEGHT --	
	;- #HEIGHT*5*64+WORDWIDTH ,$058(a6)	; BLTSIZE - Size of Rectangle
	
	moveq 	#0,d1			
	moveq 	#0,d2	
	
	move.b 	#8,d1					; Height
	lsl.w	#2,d1	
	mulu.w 	#64,d1	
	
	move.b 	#16,d2					; Width		
	lsr.w	#4,d2	
	add.w	d1,d2
	
	;----------------------------------
	
	;-- DESTINATION MODULO --	
	; (HSCR_W-blt_widthV)/8
	
	moveq 	#0,d1	
	move.b 	#16,d1				
	move.w 	#704,d4					
	sub		d1,d4
	lsr.w	#3,d4
	
	;----------------------------------
	
	; -- BLIT SPRITE --
	
	lea 	$dff000,a6					; Custom Chip base address (a6)	
	tst 	$002(a6)					; DMACONR
	
	;----------------------------------
	
	bsr WAITFORBLITTER
	
	;----------------------------------
	
	;----------------------------------
	; SET UP BLTCON & SHIFTS FOR TEXT (If Needed)
	;----------------------------------
	
	move.l 	#$01000000,d6			
	
	move.l 	d6,$040(a6)					; BLTCON0 - Set Blitter Control bits


	;----------------------------------	
	; DRAW setup 
	;----------------------------------	

	;move.l 	#0,$050(a6)					; BLTAPTH - Source (A) pointer - IMAGE
	move.l 	a3,$054(a6)					; BLTDPTH - Destination (D) pointer - SCREEN		
	move.w 	d4,$064(a6)					; BLTAMOD - (A) Modulo
	move.w 	d4,$066(a6)					; BLTDMOD - Destination Modulo
	
	;----------------------------------
	
	move.w 	d2,$058(a6)					; BLTSIZE - Size of Rectangle (Blit Activate)	

	;----------------------------------
	
	movem.l (sp)+,d0-a6
	RTS
	
	;----------------------------------	
	
		
;-----------------------------------------------------------------------------------------------------------
		

;-----------------------------------------------------------------------------------------------------------
	