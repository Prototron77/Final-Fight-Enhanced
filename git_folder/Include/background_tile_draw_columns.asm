;---------------------------------------------------------
; 	COLUMNS
;---------------------------------------------------------

BLIT_COLUMNS:
	
	;---------------------------------------------------------
	;	SET MAP START & INCREASE COLUMN OFFSET
	;---------------------------------------------------------

	move.l 	a0,-(sp)
	
DB_LOOP:

	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d6
	
	move.w 	#14,d6							; Number of blits down screen
	
	lea 	CREATE_EVENT_ADDRESSES,a0		; Load LEVEL addresses
	
	move.l 	(a0),a3							; Load Map
			
	btst 	#0,SCROLLFLAGS
	bne.s 	.Scroll_Right
	
	;---------------------------------------------------------
	; SCROLL LEFT
	;---------------------------------------------------------	
	
	move.w 	(TILETABLE+8),d1				; Load LEFT map offset
	add 	d1,a3							; Add offset to map every column
	sub.w	#2,(TILETABLE+8)				; Sub from LEFT Map offset
	sub.w	#2,(TILETABLE+10)				; Sub from RIGHT Map offset
	sub.w	#1,(TILETABLE+12)				; Store Row count min in table
	
	bra.s  .Set_Y
	
	;---------------------------------------------------------	

.Scroll_Right
	;---------------------------------------------------------
	; SCROLL RIGHT
	;---------------------------------------------------------
	
	move.w 	(TILETABLE+10),d1				; Load RIGHT map offset
	add 	d1,a3							; Add offset to map every column
		
	;---------------------------------------------------------
	
.Set_Y
	;---------------------------------------------------------
	; SET Y-POS
	;---------------------------------------------------------
	
	moveq 	#0,d1
	move.w 	#$10,(TILETABLE+2)				; Set Y COORDINATE
	
	;---------------------------------------------------------
	; LOOP
	;---------------------------------------------------------
	
COLUMN_TILEPASTE_LOOP:

	move.l 	4(a0),a4						; TILE OFFSETS TABLE
	move.w 	(a3),d0							; Get MAP entry
	
	move.b 	(LEVEL+1),d1					; Load Level WIDTH (In BYTES)
	add.w	d1,d1							; Double
	add.w 	d1,a3							; Add to MAP to find right location (Skip over XXn of map)
	moveq 	#0,d1							; Clear register
	
	;---------------------------------------------------------
	; X
	;-------------------------------
	
	add.w 	d0,d0							; Double (WORDS)
	add  	d0,a4							; ADD to offset
	moveq 	#0,d0
	
	;-------------------------------
	
	move.b 	(a4),d0							; Move X byte to D0
	lsl.w	#4,d0
	lsr.w	#3,d0
	add  	#1,a4							; Offset to Y byte
		
	;-------------------------------
	; Y	
	;-------------------------------
	
	move.b 	(a4),d1							; Move Y Byte to D1	
	lsl.w	#4,d1							; x16
	move.w	#30,d2							; Width of sources in BYTES
	lsl.w	#2,d2							; x4 to span bitplanes
	mulu.w 	d2,d1							; Multiply 16 times to go 16 lines down	
	
	;-------------------------------
	
	add 	d1,d0	
	move.l 	8(a0),a2
	;lea 	L3_1_TILES,a2					; Source
	add 	d0,a2
	
	;---------------------------------------------------------	

	;move.b 	#%00000010,HUDFLAGS
	bclr	#0,HUDFLAGS						; ICON mode
	bset 	#1,HUDFLAGS						; Main Screen	
	move.l 	#28,d7							; Set SOURCE modulo	
	move.w 	#$1010,(TILETABLE+4)			; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	;	BLIT COLUMNS
	;---------------------------------------------------------
		
	move.w 	(XVIEW+2),d0
	lsl.w 	#4,d0
	;move.w 	d0,d1
	
	add.w 	#336,d0					
	move.w 	d0,(TILETABLE)					; Set X RIGHT of XVIEW
	
;	move.w 	(XVIEW+4),d0
;	lsl.w 	#4,d0
;	move.w 	d0,(TILETABLE)					; Set X RIGHT of XVIEW
	bsr.w 	BLIT_TILES						; BLIT RIGHT COLUMN
	
	;;add.w	#16,d1	
	;move.w 	d1,(TILETABLE)				; Set X LEFT of XVIEW

	;bsr.w 	BLIT_TILES						; BLIT LEFT COLUMN
		
	;---------------------------------------------------------
	;	ADD 16 TO TILE Y POSITION
	;---------------------------------------------------------
	
	move.w 	(TILETABLE+2),d1				; Set Y for DRAW
	add.w	#16,d1
	move.w	d1,(TILETABLE+2)
	moveq 	#0,d0
	moveq 	#0,d1
	
	;---------------------------------------------------------
	dbra 	d6,COLUMN_TILEPASTE_LOOP		; Horizontal paste loop
	;---------------------------------------------------------
	
	btst 	#3,SCROLLFLAGS
	bne.s	.1
	add.w	#2,(TILETABLE+10)				; Add to RIGHT Scroll Map offset
	add.w	#2,(TILETABLE+8)				; Add to LEFT Scroll Map offset
	add.w	#1,(TILETABLE+12)				; Store Row count max in table
	bset	#3,SCROLLFLAGS
.1	

	;---------------------------------------------------------
	move.l (sp)+,a0
	;---------------------------------------------------------
	RTS	
	
	; LEVEL 2-1 COLUMN OFFSET - #160 Tiles Total - 116 To Be blitted