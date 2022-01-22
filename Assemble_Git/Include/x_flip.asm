;-----------------------------------------------------------------------------------------------------------
;	X-FLIP - HORIZONTALLY FLIP IMAGE
;-----------------------------------------------------------------------------------------------------------
;	COMMENT:
;		- 	I'm actually stunned that none of the Amiga's custom hardware can do this! It should have been
;		a job for the Agnus/Blitter using some built in LUTS, and activated by setting a register bit. It's
;		such a common thing for games to do, and So much Chip RAM is wasted by having to store the results
;		in a buffer.
;			This could have been another great ECS update. X-Flip, Y-Flip, and maybe some 90 degree
;		Rotation option as well. Using negative modulos for a Y-FLip isn't too bad, but still - it's less 
;		common than an X-Flip.
;----------------------------------------------------------------------------------------------------------
	
	; ----------------------------------
	include 	"Include/flip_macro_table.asm"
	; ----------------------------------
	
X_FLIP:	

	movem 	d0-a6,-(sp)
	
	; ----------------------------------
	; SLICE TABLE
	; ----------------------------------
	
	move.l	(XFLIP),a5
	
XFLIP_SHEET_FLIP_START:
	
	move.l	(XFLIP+4),a1
	move.l	(XFLIP+8),a2
	move.l	(XFLIP+12),a3
	move.l	(XFLIP+16),a4
		
	; ----------------------------------
	; X/Y
	; ----------------------------------

XFLIP_XY:	

	; SCREEN_BYTES*(LINES_DOWN*4)+SCR_RESET_OFFSET,
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4
	moveq 	#0,d5
	moveq 	#0,d6
	moveq 	#0,d7	
	
	; ----------------------------------
XFLIP_LOAD_FROM_TABLE:
	
	move.b 	(a5)+,d0					; X table fetch Values
	move.b 	(a5)+,d1					; Y table fetch Values
	move.b 	(a5)+,d6					; WIDTH	table fetch values
	move.b 	(a5)+,d7					; HEIGHT table fetch values
	
	; ----------------------------------
	
	lsl.l 	#4,d0						; *16
	lsr.l	#3,d0						; /8 for BYTES
		
	lsl.l 	#4,d1						; *16
	lsl.l	#2,d1						; *4
	mulu.w 	#40,d1						; *320
	
	add.l 	d0,d1						; Add for offset
	add.l 	d6,d6

SOURCE_POINTER_OFFSETS:	

	add.l 	d1,a1						; Add offset to SOURCE IMAGE pointer
	add.l 	d6,a1	
	subq 	#2,a1 
	
	add.l 	d1,a2						; Add offset to SOURCE MASK pointer
	add.l 	d6,a2	
	subq 	#2,a2 
	
	add.l 	d1,a3						; Add offset to DESTINATION IMAGE pointer
	add.l 	d1,a4						; Add offset to DESTINATION MASK pointer
	
	; ----------------------------------
	; WIDTH & HEIGHT
	; ----------------------------------
	
WIDTH_HEIGHT:

	lsr.w	#1,d6						; /2
	lsl.w 	#4,d7						; *16 -Get lines
	subq 	#1,d7
	
	move.w  d6,d5						; move to d5 for counter
	move.w  d5,d4						; Back up d5 in d4

	subq 	#1,d5
	
	; ----------------------------------

	move.w 	#3,d3						; Bitplane count

FLIPLOOP:
	move.w d3,-(sp)
	move.w 	(a1),d1
	suba.w	#2,a1
	tst.w 	d1
	beq .1
	FlipByte							; Flip IMAGE
.1
	move.w 	d1,(a3)+	
	
	move.w 	(a2),d1
	suba.w	#2,a2
	tst.w 	d1
	beq .2
	FlipByte							; Flip MASK
.2
	move.w 	d1,(a4)+	
	
	move.w (sp)+,d3
	; ----------------------------------	
	dbra 	d5,FLIPLOOP					; Per BITPLANE		
	; ----------------------------------
	
SKIP_TO_NEXT_BITLANE:

	move.l 	d4,d5
	move.l 	d4,d6	
	add.l 	d6,d6	
	adda.l 	#40,a1						; Add SCREEN WIDTH to source IMAGE
	adda.l 	#40,a2						; Add SCREEN WIDTH to source MASK
	adda.l	d6,a1						; Add Slice WIDTH
	adda.l	d6,a2						; Add Slice WIDTH
	adda.l 	#40,a3						; Add SCREEN WIDTH to Destination FLIP IMAGE
	adda.l 	#40,a4						; Add SCREEN WIDTH to Destination FLIP MASK
	suba.l	d6,a3						; Sub Slice WIDTH
	suba.l	d6,a4						; Sub Slice WIDTH
	subq 	#1,d5
	
	; ----------------------------------
	dbra 	d3,FLIPLOOP					; All Bitplanes per line		
	; ----------------------------------
	
	moveq 	#3,d3						; Reset Bitplane count
	
	; ----------------------------------
	dbra 	d7,FLIPLOOP					; All lines			
	; ----------------------------------
	
	cmp.w 	#-1,(a5)					; Loop until -1 is found at end of table
	bne.w 	XFLIP_SHEET_FLIP_START
	
	; ----------------------------------
	movem 	(sp)+,d0-a6
	RTS
	; ----------------------------------
