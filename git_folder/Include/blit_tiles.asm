; ----------------------------------------------------------------------------------------------------------
;	BLITTER / DRAW - TILE DRAWER
; ----------------------------------------------------------------------------------------------------------
;	COMMENT:
;		-	Just what it says. It Blits tiles in 16x16 chunks using an A->D "Block Copy" on the Blitter.
;			No masking or anything.
; ----------------------------------------------------------------------------------------------------------
BLIT_TILES:	; a2 = IMAGE TO BLIT

	;------------------------------------------
	
	movem.l d0-d5/d7/a1/a3/a4,-(sp)						; Back up Registers to Stack
	
	;------------------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4
	
	;------------------------------------------

	btst 	#1,HUDFLAGS							; SEE IF DRAWING TO 0 = HUDSCREEN  OR 1 = MAIN_SCREEN
	bne.s	.DrawTo_Main
	
	;------------------------------------------
	
.DrawTo_Hud	

	lea 	HUDSCREEN,a3						; Set Normal screen
	move.w 	#HSCR_B_WIDTH,d3
	move.w 	#HSCR_W,d4
		
	bra.s 	.Hudscreen_Select_Done
	
	;------------------------------------------
	
.DrawTo_Main

	movea.l DOUBLE_BUFFER,a3					; Set Destination Screen Buffer (switched at VBLANK)
	move.w 	#SCR_B_WIDTH,d3
	move.w 	#SCR_W,d4

.Hudscreen_Select_Done
	
;------------------------------------------------------------------------------------------------------	
; 	-- CALCULATE X/Y OFFSET --	
;	bltOffs 	= (bltY*HSCR_B_WIDTH)+(bltX/8)	
;------------------------------------------------------------------------------------------------------
			
	move.w 	(TILETABLE),d1					; X-Coordinate (Words)
	move.w 	(TILETABLE+2),d2				; Y-Coordinate (Lines) +1 Offset in Table
	
	lsr.w 	#3,d1
	add.w 	d1,a3	
	mulu.w 	d3,d2	
	add.l 	d2,a3
		
;------------------------------------------------------------------------------------------------------
; 	-- CALCULATE WIDTH & HEGHT --	
;	- #HEIGHT*5*64+WORDWIDTH ,$058(a6)		; BLTSIZE - Size of Rectangle
;------------------------------------------------------------------------------------------------------
	
	moveq 	#0,d1			
	moveq 	#0,d2				
	move.b (TILETABLE+5),d1					; Height
	
	;move.b 	#16,d1
	
	btst 	#1,HUDFLAGS
	bne.s 	.Mainscreen_Depth
	mulu.w 	#5,d1							; Can't Shift, so MULU by 5
	bra.s	.Tile_DepthDone
.Mainscreen_Depth
	lsl.w	#2,d1	
.Tile_DepthDone
	mulu.w 	#64,d1	
	move.b (TILETABLE+4),d2				; Width		
	
	;move.b 	#16,d2
	lsr.w	#4,d2	
	add.w	d1,d2
	
;------------------------------------------------------------------------------------------------------
;	-- DESTINATION MODULO --	
; 	(HSCR_W-blt_widthV)/8
;------------------------------------------------------------------------------------------------------

	moveq 	#0,d5			
	move.b (TILETABLE+4),d5
	sub.w	d5,d4
	;sub.b	(TILETABLE+4),d4
	lsr.w	#3,d4
	
;------------------------------------------------------------------------------------------------------
;	BLIT SPRITE
;------------------------------------------------------------------------------------------------------	
	
	lea 	$dff000,a4							; Custom Chip base address (a6)	
	tst 	$002(a4)							; DMACONR
	
	;------------------------------------------
	
	bsr.w	WAITFORBLITTER
	
	;------------------------------------------
	
	;------------------------------------------
	; SET UP BLTCON ( & SHIFTS FOR IF NEEDED)
	;------------------------------------------
	
	btst 	#8,HUDFLAGS							; DRAW = 0 | ERASE = 1
	bne.s	.1
	move.l 	#$09f00000,d5						; A->D Block Copy setting
	bra.s	.2
.1
	move.l 	#$09000000,d5						; Draw Black Rectangle
	bclr 	#8,HUDFLAGS
.2
	;move.l 	#$09f00000<<4+$f,d5				
	;and.b	(TILETABLE+6),d5			
	;ror.l	#4,d5	
	move.l 	d5,$040(a4)							; BLTCON0 - Set Blitter Control bits
	move.l 	#$ffffffff,$044(a4)					; BLTAFWM - Set Source Mask for ICONS (No masking)

	;------------------------------------------
	; DRAW setup 
	;------------------------------------------
	move.l a2,$050(a4)							; BLTAPTH - Source (A) pointer - IMAGE
	move.l a3,$054(a4)							; BLTDPTH - Destination (D) pointer - SCREEN		
	move.w d7,$064(a4)							; BLTAMOD - (A) Modulo
	move.w d4,$066(a4)							; BLTDMOD - Destination Modulo
	
	;------------------------------------------
	
	move.w d2,$058(a4)							; BLTSIZE - Size of Rectangle (Blit Activate)	

	;------------------------------------------
	movem.l (sp)+,d0-d5/d7/a1/a3/a4
	RTS
	;------------------------------------------
	
	
BLITTER_ICON_DRAWER:

	;---------------------------------------------------------
	
	lea 	HUDSHEET,a2					; Set source address
	lea 	HUDSCREEN,a3				; Set Destination address
	lea 	HUDCHARS_SHEET_OFFSETS,a4	; Table offsets
	
	;---------------------------------------------------------	
	
TILEPASTE_LOOP:

	add.w 	d0,d0						; Double (WORDS)
	add  	d0,a4						; ADD to offset
	move.b 	(a4),d0						; Move X byte to D0
	add  	#1,a4						; Offset to Y byte
	moveq	#0,d1
	move.b 	(a4),d1						; Move Y Byte to D1
	
	;---------------------------------------------------------	
	; GRAB X/Y
	;---------------------------------------------------------	
	
	; X
	lsl.w	#4,d0
	ror.w	#3,d0
	
	; Y
	lsl.w	#3,d1
	mulu.w 	#5,d1
	mulu.w 	#24,d1						; Multiply by dest modulo

	add 	d1,d0	
	add.l 	d0,a2
	
	;---------------------------------------------------------	
	moveq 	#0,d1
	moveq 	#0,d7
	move.b	#192,d7
	move.b 	(TILETABLE+4),d1				; Width
	sub.b	d1,d7
	lsr.b	#3,d7
	;move.l 	#22,d7						; Set SOURCE modulo (24-2)

	;---------------------------------------------------------
	bsr.w 	BLIT_TILES					; CALL BLITTER ROUTINE
	;---------------------------------------------------------
	RTS