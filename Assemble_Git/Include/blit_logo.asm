; ----------------------------------------------------------------------------------------------------------
;	BLITTER / DRAW - TILE DRAWER
; ----------------------------------------------------------------------------------------------------------
	
BLIT_LOGO:


	;---------------------------------------
	
	movem.l d0-a6,-(sp)						; Back up Registers to Stack
	move.w 	#%1000010000000000,$dff096		; Set Blitter Nasty
	;---------------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4
	moveq 	#0,d5
	moveq 	#0,d6
	moveq 	#0,d7

	;---------------------------------------
	
	lea 	TS_LOGO,a2						; Load Source image
	lea		TITLE_SCREEN,a3					; Set Destination Screen Buffer
	
;------------------------------------------------------------------------------------------------------	
; 	-- CALCULATE X/Y OFFSET --	
;	bltOffs 	= (bltY*TSCR_B_WIDTH)+(bltX/8)	
;------------------------------------------------------------------------------------------------------
			
	move.w 	#0,d1							; X-Coordinate (Words)
	move.w 	#0,d2							; Y-Coordinate (Lines) +1 Offset in Table
	
	;---------------------------------------
	mulu.w 	#TSCR_B_WIDTH,d2				; bltY * TSCR_B_WIDTH
	lsr.w 	#3,d1							; bltX / 8

	add.l	d1,d2							; Add together
	add.l 	d2,a3							; Add to address
		
;------------------------------------------------------------------------------------------------------
; 	-- CALCULATE WIDTH & HEGHT --	
;	- #HEIGHT*5*64+WORDWIDTH ,$058(a6)			; BLTSIZE - Size of Rectangle
;------------------------------------------------------------------------------------------------------
	
	moveq 	#0,d1	
	moveq 	#0,d2	
	
	;---------------------------------------

	move.w 	#165,d1								; Height
	mulu.w 	#5,d1								; * 5
	mulu.w 	#64,d1								; * 64
	
	move.w 	#320,d2								; Width (Pixels)
	lsr.w	#4,d2								; Divide by 16 to get WORD value
	add.w	d1,d2								; + WIDTH in WORDS
	
;------------------------------------------------------------------------------------------------------
;	MODULOS	
; 	(TSCR_W-blt_widthV)/8
;------------------------------------------------------------------------------------------------------

	; - Both Zero -								; 320w Image and 320w Screen

;------------------------------------------------------------------------------------------------------
;	BLIT LOGO
;------------------------------------------------------------------------------------------------------	
	
	lea 	$dff000,a6							; Custom Chip base address (a6)	
	tst 	$002(a6)							; DMACONR
	
	;-------------------------------------------
	
	bsr.w	WAITFORBLITTER
	
	;-------------------------------------------
	
	;-------------------------------------------
	; SET UP BLTCON
	;-------------------------------------------
	
	move.l 	#$09f00000,$040(a6)					; Block Draw (A -> D)
	;move.l 	#$ffffffff,$044(a6)				; BLTAFWM - Set Source Mask for ICONS (No masking
	;------------------------------------------
	; DRAW setup 
	;------------------------------------------

	move.l a2,$050(a6)							; BLTAPTH - (A) Source  pointer - IMAGE
	move.l a3,$054(a6)							; BLTDPTH - (A) Destination pointer - SCREEN		
	move.w 0,$064(a6)							; BLTAMOD - (A) Source Modulo
	move.w 0,$066(a6)							; BLTDMOD - (D) Destination Modulo
	
	;------------------------------------------

	move.w d2,$058(a6)							; BLTSIZE - Size of Rectangle (Blit Activate)	

	;------------------------------------------
	move.w 	#%0000010000000000,$dff096	; Clear Blitter Nasty
	movem.l (sp)+,d0-a6
	RTS
	;------------------------------------------