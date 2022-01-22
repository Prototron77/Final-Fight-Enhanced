;---------------------------------------------------------
; BACKGROUND TILE DRAW FUNCTION
;---------------------------------------------------------
	
ROW_BLIT:	

	;-------------------------------------------------------------------
	; LOAD LEVEL MAP & GRAPHICS
	;-------------------------------------------------------------------	
	
	lea CREATE_EVENT_ADDRESSES,a0
	
	;-------------------------------------------------------------------
	; GRAB TILE - Grab & Blit 16xnn Tile from sheet
	;-------------------------------------------------------------------	
	; (SCREEN BYTES*(V-LINES DOWN*BITPLANES)+ H-BYTES OFFSET)
	
	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4
	moveq 	#0,d5
	moveq 	#0,d6
	moveq 	#0,d7
	
	move.w 	#14,d5						; Row count
	move.w 	#20,d6						; Blits across
	move.w 	d6,d3						; Back up blits across for calculation
	
	move.l (a0),a3						; LOAD MAP
	
	move.w 	#$0030,(TILETABLE)			; Set initial X for DRAW
	move.w 	(YVIEW),(TILETABLE+2)		; Set initial Y for DRAW
	move.w	#0,(TILETABLE+6)			; No Shifts
	
ROW_TILEPASTE_LOOP:

	move.l 4(a0),a4						; LOAD TILESHEET X/Y GRAB OFFSETS
	
	;-------------------------------------------------------------------	
	;	FETCH MAP ENTRY & APPLY TO TILESHEET TABLE FOR CO-ORDINATES
	;-------------------------------------------------------------------
	
	move.w 	(a3)+,d0					; Get MAP entry
	add.w 	d0,d0						; Double (WORDS)
	add.l  	d0,a4						; ADD to TILEOFFSETS table
	moveq 	#0,d0
	move.b 	(a4),d0						; Move X byte to D0
	add.w  	#1,a4						; Offset 1 to Y byte
	move.b 	(a4),d1						; Move Y Byte to D1

	;-------------------------------------------------------------------	
	;	CONVERT X/Y VALUES AND ADD TO TILESHEET BITMAP TO FIND LOCATION OF TILE
	;-------------------------------------------------------------------
	
	lsl.w	#4,d0						; X * 16
	lsr.w	#3,d0						; Divide by 8 for BYTE value
	
	lsl.w	#4,d1						; Y * 16
	lsl.w	#2,d1						; * 4 to span bitplanes
	mulu.w 	#30,d1						; * by Source width in BYTES
	
	add.l 	d1,d0						; Add together to get offset
	
	;-------------------------------------------------------------------	
	;	LOAD SOURCE TILESHEET
	;-------------------------------------------------------------------
	
	move.l 8(a0),a2						; LOAD LEVEL TILESHEET
	add.l 	d0,a2						; Add offset to Source Bitmap
	
	;-------------------------------------------------------------------	
	;
	;-------------------------------------------------------------------
	
	move.l 	#28,d7						; Set SOURCE modulo (BYTE WIDTH-2)
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;-------------------------------------------------------------------	
	;
	;-------------------------------------------------------------------
	
	bclr	#0,HUDFLAGS					; ICON mode
	bset 	#1,HUDFLAGS					; Main Screen
	bclr 	#8,HUDFLAGS	
	
	bsr.w 	BLIT_TILES					; CALL BLITTER ROUTINE
	
	;---------------------------------------------------------
	;	ADD 16 TO TILE X POSITION
	;---------------------------------------------------------
	
	move.w 	(TILETABLE),d1			; Set X for DRAW
	add.w	#16,d1
	move.w	d1,(TILETABLE)
	moveq 	#0,d0
	moveq 	#0,d1
		
	;---------------------------------------------------------
	dbra d6,ROW_TILEPASTE_LOOP			; Horizontal paste loop
	;---------------------------------------------------------

		move.b 	(LEVEL+1),d0			; Load Level WIDTH
		subq 	#1,d0

ROW_RESET:		
		sub 	d3,d0
		add.w 	d0,d0
		add 	d0,a3
		move.w 	#20,d6
		move.w	#$0030,(TILETABLE)		; Reset X to left of screen
	
	
		move.w 	(TILETABLE+2),d1		
		add.w	#16,d1					; Add 16 to Y for next row down
		move.w	d1,(TILETABLE+2)
		
		moveq 	#0,d0
		moveq 	#0,d1
		
	;---------------------------------------------------------
	dbra d5,ROW_TILEPASTE_LOOP		; Move down one row
	;---------------------------------------------------------
	RTS