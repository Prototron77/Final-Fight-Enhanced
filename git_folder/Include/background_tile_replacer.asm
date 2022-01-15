;-----------------------------------------------------------------------------------------------------------
; TILE REPLACER
;-----------------------------------------------------------------------------------------------------------
;	COMMENT:
;
;		- AFAIK, the biggest resource hog in the game. I wish that Duel Playfield mode was 4-Bitplanes 
;		each, then Bobs and Backgrounds could just have their own layer. The extra processing might be just
;		as slow though.
;
;		Might have been a good ECS update, maybe?
;	
;-----------------------------------------------------------------------------------------------------------

TILETABLE_NO = 160								; Number of entries in the table(s)

TILECLEANER_STORE:

	; D4 = X + FRAME OFFSET + SLICE OFFSET
	; D5 = Y + FRAME OFFSET + SLICE OFFSET
	; D0 = WIDTH of slice (Width is used as a counter)
	
	;-------------------------------------------	
	movem.l d0-d7/a0/a1,-(sp)					; Back up Registers to Stack
	;-------------------------------------------
	
LOAD_TILECLEAN_TABLE:		

	move.l 	TILECLEANER_TABLES,a0				; Load coordinate table	(switched for screen buffers)
	moveq 	#0,d7								
	
	;------------------------------------------
	
	move.w 	#TILETABLE_NO,d7
TILECLEANER_STORE_CHECKSLOT:
	cmpi.w 	#-1,(a0)+							; Check to see if slot is empty. If so, skip.
	beq.s .1
	dbra	d7,TILECLEANER_STORE_CHECKSLOT
.1
	sub.w	#2,a0								; Step back
	;------------------------------------------
	
	moveq 	#0,d1								; TO STORE Y-TOP
	moveq 	#0,d2								; TO STORE Y-BOTTOM
	moveq 	#0,d3								; TO STORE X-LEFT
	moveq 	#0,d6								; Counter
		
	lsr.b	#4,d0								; Convert Slice WIDTH to counter value
	subq 	#1,d0								; Subtract 1 (don't need the 0)

	;--------------------------------------------------------------------------
	; FIND TOP TILE Y
	;--------------------------------------------------------------------------
							
	sub.w	#16,d5								; Starts 16 down
	lsr.b	#4,d5
	lsl.b	#4,d5
	move.b 	d5,d1
		
FIND_YTOP:										

	;--------------------------------------------------------------------------
	; FIND BOTTOM TILE Y (IF OVERLAPPING TILE BELOW)
	;--------------------------------------------------------------------------
	
FIND_YBOTTOM:	

	add.w 	#16,d5								; Add 16 to Y to find bottom of Slice
	move.b 	d5,d2

	;--------------------------------------------------------------------------
	; FIND TILE X-LEFT (WIDTH ADDED LATER)
	;--------------------------------------------------------------------------
	
FIND_XLEFT:	

	move.w 	(XVIEW+2),d3						; Load XVIEW reference
	lsl.w 	#4,d3
	sub.w 	d3,d4	
	lsr.w	#4,d4
	move.w 	d4,d3
		
	;--------------------------------------------------------------------------
	; LOG RESULTS
	;--------------------------------------------------------------------------							; If not, just log TOP tiles
	
LOG_RESULTS:	

LOOP_ADD_WIDTH:

	;-----------------------------------
	; CHECK FOR DUPLICATE ENTRIES
	;-----------------------------------
	
	move.b 	d3,d4								; Load to D4 for duplicates compare
	lsl.w	#4,d4
	lsl.w	#4,d4
	move.b 	d1,d4
	move.l	a0,-(sp)							; Save Slot position
	move.l 	TILECLEANER_TABLES,a0				; Load coordinate table	
	
	;-------------------
	move.w 	#TILETABLE_NO,d7
.Duplicate_Loop									; Check for Duplicates in table
	cmp.w 	(a0),d4
	beq.s	.NoToplog
	cmpi.w	#-1,(a0)+
	beq.s 	.1
	dbra 	d7,.Duplicate_Loop	
.1
	sub.w	#2,a0
	;-------------------
	
	move.l	(sp)+,a0							; Refresh Slot position
			
	;-----------------------------------
	; CHECK CLIP & LOG RESULTS
	;-----------------------------------
	
	cmp.b #0,d3									; Clipping L
	ble.s DuplicateFound
	cmp.b #22,d3								; Clipping R
	bge.s DuplicateFound
	
	;-------------------
		
	move.b 	d3,(a0)+							; Store Top 
	move.b 	d1,(a0)+	
	bra.s 	.Log_bottom

.NoToplog	
	
	move.l	(sp)+,a0							; Refresh Slot position (if skipping Top Log)
	
.Log_bottom
	
	move.b 	d3,(a0)+							; Store Bottom
	move.b 	d2,(a0)+
	
DuplicateFound:
		
	addq	#1,d3
	dbra 	d0,LOOP_ADD_WIDTH
	
TILECLEANER_STORE_DONE:

	;-------------------------------------------
	movem.l (sp)+,d0-d7/a0/a1					; Restore Registers from Stack
	RTS
	;-------------------------------------------
	
;-----------------------------------------------------------------------------------------------------------

TILECLEANER_PASTE:

	;-------------------------------------------
	movem.l d0-a4,-(sp)							; Back up Registers to Stack	
	;-------------------------------------------
	
	lea 	CREATE_EVENT_ADDRESSES,a1			; Load LEVEL addresses table
	
	move.l 	TILECLEANER_TABLES,a0				; Load coordinate table	
	cmp.w 	#-1,(a0)
	beq.w 	TILECLEANER_PASTE_DONE				; Skip if map entry is -1 (Nothing in there)
	
	;-------------------------------------------
	; PASTE LOOP START
	;-------------------------------------------
	
	bset 	#1,HUDFLAGS							; DRAW TO MAIN SCREEN

	move.w 	#TILETABLE_NO,d6		

TILECLEANER_PASTE_LOOP:

	moveq 	#0,d0
	moveq 	#0,d1								; TO STORE Y-TOP
	moveq 	#0,d2								; TO STORE Y-BOTTOM
	moveq 	#0,d3								; TO STORE X-LEFT
	moveq 	#0,d4	
	
	;------------------------------------------
	; LOAD X/Y OF DIRTY TILES FROM TABLE
	;-------------------------------------------
	
	move.w 	(a0)+,d0							; Load X/Y entry from table	
	move.b	d0,d1								; Save to second register
	
	lsr.w	#4,d0								; Seperate X
	lsr.w	#4,d0
	lsl.w 	#4,d0

	move.w	d0,d2
	move.w	d1,d3
	
	move.w 	(XVIEW+2),d4						; Get XVIEW offset

	lsl.w 	#4,d4								; * 4
	add.w	d4,d0								; Add to X
	
	add.w	#16,d1								; Add YVIEW

	;---------------------
	btst 	#4,SCROLLFLAGS						; Adjust for scroll delay reset...
	beq.s 	.1									; ... when screen is pushed forward
	sub.w 	#$10,d0								; Sub 1 tile's width (16 pixels)
.1
	;---------------------
	
	move.w 	d0,(TILETABLE)						; Set X for DRAW
	move.w 	d1,(TILETABLE+2)					; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)				; Set WIDTH & HEIGHT
	
	;-------------------------------------------
	; GET MAP ENTRY
	; - a3 holds MAP
	; - a4 holds offsets for tiles
	;-------------------------------------------
	
TILECLEANER_GET_MAP_ENTRY:	

	move.l (a1),a3								; MAP Address
	move.l 4(a1),a4								; GRAB OFFSETS FOR TILESHEET
	
	move.w 	(TILETABLE+8),d4					; MAP LEFT OFFSET (current position)
	
	;---------------------
	
	btst #4,SCROLLFLAGS							; Adjust for scroll delay reset
	beq.s .2
	sub.w #$2,d4								; Go back 1 entry in map
.2	
	;---------------------
	
	add.w 	d4,a3								; Add current MAP offset to MAP table
	
	lsr.w 	#4,d2								; X / 16
	lsr.w 	#4,d3								
	
	moveq 	#0,d0
	move.b	(LEVEL+1),d0
	mulu.w 	d0,d3								; Level WIDTH in BYTES (Must be a variable)
	add.w 	d2,d3
	add.w 	d3,d3
	add.w 	d3,a3
	
	;-------------------------------------------
	; USE MAP ENTRY TO GET SOURCE OFFSET
	;-------------------------------------------
	
	moveq 	#0,d0
	moveq 	#0,d1
	
	move.w 	(a3),d0								; Get MAP entry
	
	;-------------------------------------------
	; X
	;-------------------------------------------
	
	add.w 	d0,d0								; Double (WORDS)
	add.w  	d0,a4								; ADD to offset
	
	moveq 	#0,d0								; Clear register
	
	move.b 	(a4),d0								; Move X byte to D0
	lsl.w	#4,d0								; * 4
	ror.w	#3,d0								; / 8 for BYTES
	addq  	#1,a4								; Offset forward to Y byte
	
	;-------------------------------------------
	; Y	
	;-------------------------------------------
	
	move.b 	(a4),d1								; Move Y Byte to D1	
	lsl.w	#4,d1								; x16
	move.w	#30,d2								; Width of sources in BYTES
	lsl.w	#2,d2								; x4 to span bitplanes
	mulu.w 	d2,d1								; Multiply 16 times to go 16 lines down	
	
	;-------------------------------------------
	
	add.w 	d1,d0	
	move.l 	8(a1),a2							; Tilesheet Source				
	add.w 	d0,a2
	move.w 	#28,d7								; Source Modulo

	;-------------------------------------------
	
	bsr.w 	BLIT_TILES							; Draw tile

	btst 	#0,TCFLAG
	bne.s	.1
	add.b 	#1,(TILECHECK)
.1
	;-------------------------------------------
	
SKIP_TILEBLIT:	
	cmp.w 	#-1,(a0)
	beq.s 	TILECLEANER_PASTE_DONE	
	dbra	d6,TILECLEANER_PASTE_LOOP

TILECLEANER_PASTE_DONE:
	bset 	#0,TCFLAG
	move.b (TILECHECK),d0

	;------------------------------------------

	btst 	#3,SCROLLFLAGS						
	beq.s 	.2
	bclr 	#3,SCROLLFLAGS						; Turn off column blit flag
.2

	btst 	#5,SCROLLFLAGS						
	bne.s 	.4
	bclr 	#4,SCROLLFLAGS						; Turn off tile prev flag
.4
	bclr 	#5,SCROLLFLAGS
.3

	;-------------------------------------------
	movem.l (sp)+,d0-a4						
	RTS
	;-------------------------------------------
	
;---------------------------------------------------------------------------------------------------------
;	TILECLEANER PASTE - Called in main loop (I should maybe put this with the other subs?)
;---------------------------------------------------------------------------------------------------------

CLEAN_SCREEN:	

	;-------------------------------------------
	; PASTE TILES
	;-------------------------------------------

	bsr.w 	TILECLEANER_PASTE
	
	;-------------------------------------------
	;	PURGE TILE CLEANER TABLE
	;-------------------------------------------
	
	move.l 	TILECLEANER_TABLES,a0				; Load table base address
	
	cmpi.w 	#-1,(a0)							; See if first entry is full
	beq.s 	.skip_tilecleaner_purge				; if not then skip purge
	
	;-------------------------------------------
	
	move.w 	#TILETABLE_NO,d6					; Load count
.purge_tilecleaner_table
	move.w 	#-1,(a0)+							; Move -1 to table slot and increase
	cmpi.w 	#-1,(a0)							; Check to see if next slot is full
	beq.s	.skip_tilecleaner_purge				; If not then break loop
	dbra	d6,.purge_tilecleaner_table
.skip_tilecleaner_purge	

	;-------------------------------------------
	RTS
	;-------------------------------------------