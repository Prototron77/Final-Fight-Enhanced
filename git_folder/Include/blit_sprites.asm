;------------------------------------------------------------------------------------------------------------
;	DRAW ROUTINE
;-----------------------------------------------------------------------------------------------------------
;	COMMENT:
;		-	Still working on this. All the checking and fetching from tables might not be the best. The
;			tile cleaner is the biggest resource hog at the moment.
;
;		Screen objects are made up of many horizontal slices which are copied from a "Slice Sheet"
;		and Blitted to the screen using a table of offsets which centre around a main X/Y coordinate.
;
;		The OBJECT_SLOTS table determines how many screen objects are to be draw. The routine then figures 
;		out what type they are and what graphics to fetch.
;-----------------------------------------------------------------------------------------------------------
;
;	THE ROUTINE CONSISTS OF TWO PARTS  - "LOADER" AND "BLIT_SLICES"
;
;--------------------------------------
;	LOADER
;--------------------------------------
;
; 	1. GET NUMBER OF OBJECTS TO BE DRAWN AND OBJECTS' ID NUMBER
;	2. CHECK NUMBER OF OBJECTS TO BE DRAWN
;	3. SORT OBJECTS' PRIORITY
;	4. GET OBJECT TYPE
;	5. GET OBJECT STATE & FRAME NUMBER
;	6. SLICE GRAB 	XY WH VALUES 	(SOURCE)
;	7. SLICE SCREEN XY WH VALUES	(DESTINATION)
;	8. CALL "BLIT_SLICES" ROUTINE
; 	9. LOOP FOR NEXT SLICE

;--------------------------------------
;	BLIT_SLICES					
;--------------------------------------
;
;	1. ADD OFFSETS TO X/Y ORIGIN
;	2. CLIP BOB
;	2. CALCULATE X/Y
;	3. CALCULATE W/H
;	4. CALCULATE MODULOS
;	5. LOAD BLITTER REGISTERS &  BLIT SLICE

;--------------------------------------

;--------------------------------------
; 	TYPES
;--------------------------------------

OBJ_NONE		= 0

;--------------------------------------
; 	PLAYERS
;--------------------------------------

OBJ_GUY			= 1
OBJ_CODY		= 2
OBJ_HAGGAR		= 3

;--------------------------------------
; 	GOONS
;--------------------------------------

OBJ_BRED		= 4
OBJ_J			= 5
OBJ_ROXY		= 6
OBJ_AXL			= 7
OBJ_ORIBER		= 8
OBJ_ANDORE		= 9

;--------------------------------------
; 	BOSSES
;--------------------------------------

OBJ_DAMND		= 10
OBJ_SODOM		= 11
OBJ_EDIE		= 12
OBJ_ROLENTO		= 13
OBJ_ABIGAIL		= 14
OBJ_BELGER		= 15

;--------------------------------------
; 	BREAKABLES & PICKUPS
;--------------------------------------

OBJ_OILDRUM		= 16
OBJ_KNIFE		= 17
OBJ_PIPE		= 18
OBJ_MEAT		= 19
OBJ_1UP			= 20

;--------------------------------------
; 	FX
;--------------------------------------

OBJ_HITSPARK	= 21
OBJ_DUST		= 22
OBJ_BLOOD		= 23
OBJ_WOOD		= 24
OBJ_DROP		= 25

;--------------------------------------
; 	TEXT
;--------------------------------------

OBJ_GAMEOVER	= 26

;--------------------------------------
;	OBJECT TABLE OFFSET VALUES
;---------------------------------------

;-----------------------
; OBJECT OFFSETS
;-----------------------
OBJ_NUMBER			= 0
OBJ_TYPE			= 1
OBJ_ENERGY			= 2
OBJ_LIVES			= 3
OBJ_X				= 4	
OBJ_Y				= 5
OBJ_S				= 6
OBJ_STOPS			= 7
OBJ_STATE			= 8
OBJ_FRAME		 	= 9
OBJ_COMBO		 	= 10
OBJ_GRAB		 	= 11
OBJ_TIMER		 	= 12
OBJ_TIMER2		 	= 13
OBJ_JUMPHEIGHT		= 14
OBJ_Z			 	= 15
OBJ_WALKSPEED		= 16
OBJ_ANIMSPEED		= 17
OBJ_ATTACKDISTX		= 18
OBJ_ATTACKDISTY		= 19
OBJ_FLAGS			= 20
OBJ_FLAGS2			= 21
OBJ_HITCOUNT		= 22
OBJ_HITCOUNT_RESET	= 24
;-----------------------

; ----------------------------------------------------------------------------------------------------------

DRAW_ROUTINE:

; ----------------------------------------------------------------------------------------------------------
;		1. GET NUMBER OF OBJECTS TO BE DRAWN AND OBJECTS' ID NUMBER
; ----------------------------------------------------------------------------------------------------------
	
LOADER_TEST_SLOTS:	

	lea 	OBJECT_SLOTS,a1				; How many objects are active?
	lea 	OBJECT_IDY,a2				; Stores ID numbers & Y coordinates for Priority sorting later

	moveq 	#0,d0
	moveq 	#0,d1						; Count for Id Store
	
	move.b 	#0,(OBJECT_NUMBER_OF)
LP_FIND_OBJSLOT:
	addq 	#1,d1
	tst.b	(a1)+
	bne.s	ID_STORE
	cmp.b 	#-1,(a1)
	bne.s	LP_FIND_OBJSLOT
	bra.s	LOADER_NUMBER_OF_OBJECTS
	
ID_STORE:

	add.b 	#1,d0						
	
	; --------------------
	
	move.b	d1,(a2)+					; Store ID number in First BYTE of word

	; --------------------
	move.b	d1,(OBJECT_ID)
	bsr.w 	LOAD_OBJECT_TABLE
	move.b 	OBJ_Y(a0),(a2)+				; Store Y in Second BYTE of word
	; --------------------

.CheckEnd
	cmp.b 	#-1,(a1)					; Check for -1
	bne.s	LP_FIND_OBJSLOT
	
SLOTSDONE:

; ----------------------------------------------------------------------------------------------------------
;		2. NUMBER OF OBJECT TO BE DRAWN
; ----------------------------------------------------------------------------------------------------------
		
LOADER_NUMBER_OF_OBJECTS:
	
	move.b 	d0,(OBJECT_NUMBER_OF)		; Store Number of Objects to draw
	moveq 	#0,d0
	
	move.b 	(OBJECT_NUMBER_OF),d0
	move.b 	d0,(OBJECT_SLOTCNTR)		; Loop Counter using value in OBJECT_NUMBER
	tst.b 	d0
	beq.w 	NO_OBJECTS_TO_DRAW

; ----------------------------------------------------------------------------------------------------------
;		3. SORT PRIORITY & LOAD OBJECT_IDY TABLE
; ----------------------------------------------------------------------------------------------------------

LOAD_OBJECT_PRIORITY:

	bsr.w 	PRIORITY_SORTER	

	;-----------------------------------

LOAD_OBJECT_ID:
	
	moveq 	#0,d0
		
	lea 	OBJECT_IDY,a0				; Get Table of ID numbers
	move.b	(OBJECT_IDOFFSET),d0		; Get offset into table
	add.w	d0,a0						; Add offset to get ID
	tst.b	(a0)						; Test to see if it's empty
	beq.w	CLEAR_TOC					; If so, then skip draw
	
	add.b	#2,(OBJECT_IDOFFSET)		; Add to offset for next time (Skips Y coordinates)
	move.b	(a0),OBJECT_ID				; Store Object ID Number
	bsr.w 	LOAD_OBJECT_TABLE			; Loads what object to draw depening on OBJECT_ID number

; ----------------------------------------------------------------------------------------------------------
;		4. GET OBJECT TYPE & LOAD IN THEIR STUFF
; ----------------------------------------------------------------------------------------------------------	

LOADER_LOAD_TYPE:

	; ----------------------------------
	; a0 = OBJECT VALUES TABLE			; Table which holds object's Type, X/Y, STATE, FRAME etc.
	; a1 = MASK							; Mask Sheet (Need to write a mask auto-generator soon)
	; a2 = SLICE SHEET					; Graphics sheet
	; a3 = ANIMATION TABLE				; Animation values (X/Y, W/H)
	; a4 = STATE Table					; (Added to ANIMATION for STATE offset)
	; a5 = FRAME table (LOADED)			; (Added to STATE for FRAME offset)
	; ----------------------------------	
	
	move.b 	OBJ_TYPE(a0),d1				; Get type number from object's Table
		
	; ----------------------------------
	
.Haggar									; Load HAGGAR
	cmp.b	#3,d1
	bgt.s	.Bred
	bsr.w 	LOAD_HAGGAR_VALUES	
	bra.s	LOADER_TYPE_DONE
	
.Bred									; Load BRED
	cmp.b	#4,d1
	bgt.s	.J
	bsr.w 	LOAD_BRED_VALUES	
	bra.s	LOADER_TYPE_DONE
	
.J										; Load J
	cmp.b	#5,d1
	bgt.s	.Hitspark	
	bsr.w 	LOAD_J_VALUES	
	;bra.s	LOADER_TYPE_DONE
	
; ROXY									; Load ROXY
;	cmp.b	#5,d1
;	bsr.w 	LOAD_ROXY_VALUES	
	;bra.s	LOADER_TYPE_DONE
	
	
.Hitspark								; Load Hitspark
	cmp.b	#22,d1
	bgt.s	.GameOver
	bsr.w 	LOAD_HITSPARK_VALUES	
	bra.s	LOADER_TYPE_DONE
	
.GameOver								; Load Hitspark
	cmp.b	#26,d1
	bgt.s	LOADER_TYPE_DONE
	bsr.w 	LOAD_GAMEOVER_VALUES	
	;bra.s	LOADER_TYPE_DONE
	; ----------------------------------
	
LOADER_TYPE_DONE:

; ----------------------------------------------------------------------------------------------------------
;		5. GET OBJECT STATE & FRAME
; ----------------------------------------------------------------------------------------------------------
	
	; --------------------------------------
	; d2 = STATE
	; d3 = FRAME
	; --------------------------------------	
	
LOADER_STATE_AND_FRAME:	

	moveq 	#0,d2
	moveq 	#0,d3
	move.b 	OBJ_STATE(a0),d2				; Get Object's STATE
	move.b 	OBJ_FRAME(a0),d3				; Get FRAME number of object's STATE	
	
	bsr.w 	GET_FRAME_OFFSET				; Load FRAME offset start to a5 by cmp STATE (d2)

	; --------------------------------------
	; a3 = LOCATION OF FRAME TABLE
	; --------------------------------------
	
; ----------------------------------------------------------------------------------------------------------
;		6. LOAD GRAB (SOURCE) XY
; ----------------------------------------------------------------------------------------------------------
		
LOADER_GRAB_VALUES:

POINTERS_RESET:

	; ----------------------------------
.Haggar	
	cmp.b 	#3,OBJ_TYPE(a0)
	bgt.s	.Bred
	bsr.w 	HAGGAR_SHEETS	
	bra.s	RESET_DONE
.Bred
	cmp.b 	#4,OBJ_TYPE(a0)
	bgt.s	.J
	bsr.w 	BRED_SHEETS	
	bra.s	RESET_DONE
.J	
	cmp.b 	#5,OBJ_TYPE(a0)
	bgt.s	.HitSpark
	bsr.w 	J_SHEETS	
	bra.s	RESET_DONE
	
.HitSpark
	cmp.b 	#22,OBJ_TYPE(a0)
	bgt.s	.GameOver
	bsr.w 	HITSPARK_SHEETS	
	bra.s	RESET_DONE
	
.GameOver
;	cmp.b 	#26,OBJ_TYPE(a0)
;	bgt.s	RESET_DONE
	bsr.w 	GAMEOVER_SHEETS	
	;bra.s	RESET_DONE
	
RESET_DONE:	

	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
;	moveq 	#0,d4
	
	move.b 	(a3)+,d0					; X Offset 	- GRABPos
	move.b 	(a3)+,d1					; Y Offset 	- GRABPos
	
	; ----------------------------------
	; X - GRAB
	; ----------------------------------
XGRAB:
	lsl.w	#4,d0						; Multiply by 16 to get pixel value
	;lsr.w	#3,d0						; Divide by 8 to get BYTE value		
	move.w	d0,(GRABXY_STORE)
	; ----------------------------------
	; Y	- GRAB
	; ----------------------------------
YGRAB:
	lsl.w	#4,d1						; x16
	lsl.w	#2,d1						; x4 to span bitplanes
	mulu.w 	#40,d1						; Bytes across source
	move.w	d1,(GRABXY_STORE+2)
	; ----------------------------------
	
SLICE_SHEET_OFFSETS:	

	;***********************************************************
	; -- Had to move this bit further down to do the clipping --
	;***********************************************************

	;add.l 	d1,d0						; Add X/Y offset
	;adda.l 	d0,a1					; Add to Mask Sheet
	;adda.l 	d0,a2					; Add to slice sheet offset (d0 & d1 are now free)
	;move.l d0,(GRABXY_STORE)			; Store result for later (in case clipping ins needed)
	
; ----------------------------------------------------------------------------------------------------------
;		7. SCREEN (DESTINATION) XY & WH
; ----------------------------------------------------------------------------------------------------------

	moveq	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4
	moveq 	#0,d5
	moveq 	#0,d6
	;moveq 	#0,d7

LOAD_XY_WH:

	move.b 	(a3)+,d0					; Width		- GRAB Size
	move.b 	(a3)+,d1					; Height	- GRAB Size

	btst 	#0,OBJ_FLAGS(a0)
	bne.s 	.NoFlippedOffsets
	add.w 	#2,a3
	move.b 	(a3)+,d2					; OFFSET X-Coordinate FLipped
	move.b 	(a3)+,d3					; OFFSET Y-Coordinate Flipped
	bra.s 	.ScreenOffsetsDone
.NoFlippedOffsets
	move.b 	(a3)+,d2					; OFFSET X-Coordinate
	move.b 	(a3)+,d3					; OFFSET Y-Coordinate
	add.w 	#2,a3
.ScreenOffsetsDone

	move.b 	OBJ_X(a0),d4				; ORIGIN X-Coordinate (Words)
	move.b 	OBJ_Y(a0),d5				; ORIGIN Y-Coordinate (Lines) +1 Offset in Table
	move.b 	OBJ_Z(a0),d6				; ORIGIN Z-Coordinate (Gravity & Jumping/Falling)
	
	;----------------------------------
	; GRAVITY
	;----------------------------------
	
APPLY_GRAVITY:

	cmp.b 	#16,OBJ_NUMBER(a0)			; A dirty fix to get the GAME OVER text high enough using Z-Axis
	blt.s 	.1	
	add.b	(XVIEW+3),d4
	sub 	#2,d4
	lsl.w	#4,d6
.1
	divu	#3,d6						; /3 - Perfect jump speed but...divu. Rubbish!
	sub.w 	d6,d5
	;lsr.b	#1,d6						; /2 - Faster shift, but faster jump speed
	
; ----------------------------------------------------------------------------------------------------------
;		8. BLIT
; ----------------------------------------------------------------------------------------------------------
	
	bsr.s 	BLIT_SLICES					; Draw the frame section	

; ----------------------------------------------------------------------------------------------------------
;		9. SLICE & OBJECT LOOPS
; ----------------------------------------------------------------------------------------------------------

CHECK_SLICE_LOOP:	
	
	cmp.w	#-1,(a3)					; Check for Termination value to see if all slices are drawn 
	bne.w 	LOADER_GRAB_VALUES			; If not, then loop back and draw next slice.
	
	; ----------------------------------
	; CHECK IF MORE OBJECTS HAVE TO BE DRAWN
	; ----------------------------------

CHECK_OBJECT_LOOP:

	sub.b 	#1,(OBJECT_SLOTCNTR)
	tst.b	(OBJECT_SLOTCNTR)
	bgt.w	LOAD_OBJECT_ID	
		
	; ----------------------------------
	; CLEAR TABLES, OFFSETS, & COUNTERS
	; ----------------------------------
	
CLEAR_TOC:	

	;move.b 	#0,(OBJECT_NUMBER_OF)
	move.b	#0,(OBJECT_ID)
	move.b	#0,(OBJECT_IDOFFSET)
		
	lea 	OBJECT_IDY,a0
CLR_ID_TBL:
	move.w 	#0,(a0)+
	tst.w 	(a0)
	bne.s 	CLR_ID_TBL
	
	; ----------------------------------
	;	FINISHED DRAWING
	; ----------------------------------	

NO_OBJECTS_TO_DRAW:

	; ----------------------------------
	RTS
	; ----------------------------------
	
; ----------------------------------------------------------------------------------------------------------
;		LOADER DONE
; ----------------------------------------------------------------------------------------------------------
	
; ----------------------------------------------------------------------------------------------------------
;	BLIT SLICES - DRAW BOB SLICES
; ----------------------------------------------------------------------------------------------------------
	
BLIT_SLICES:	

	movem.l d0-a4,-(sp)						; Back up Used Registers to Stack	
	
	; -------------------------------------
	; d0 = WIDTH	(Same for screen as grab)
	; d1 = HEIGHT	(Same for screen as grab)
	; d2 = X OFFSET
	; d3 = Y OFFSET
	; d4 = X ORIGIN
	; d5 = Y ORIGIN
	; -------------------------------------
	
	; --------------------------------------
	; 	SELECT SCREEN BUFFER TO DRAW TO
	; --------------------------------------
	
	movea.l DOUBLE_BUFFER,a3				; Swapped at start of frame

; ----------------------------------------------------------------------------------------------------------
;		1. ADD SLICE'S OFFSETS TO ORIGIN
; ----------------------------------------------------------------------------------------------------------

BOB_ADD_SLICE_OFFSETS:	
	
	lsl.w 	#4,d4							; X * 16	
	
	tst.b 	d2								; Test if offset is negetive or not
	bpl.s 	.PosNum							; If not then skip word negative conversion
	move.w 	d2,-(sp)
	move.w 	#$00FF,d2
	not.w	d2
	add.w 	(sp)+,d2
.PosNum		
	add.w	d2,d4							; X-Position Relative to Object XPos ORIGIN
	add.b	d3,d5							; Y-Position Relative to Object YPos ORIGIN
	move.w 	d0,d2							; Back up WIDTH 	
	move.b 	d1,d3							; Back Up HEIGHT
	
; ----------------------------------------------------------------------------------------------------------
; 		2. CLIP BOB ( SIDES OF SCREEN )
; ----------------------------------------------------------------------------------------------------------
	
CALC_CLIPRIGHT:
	moveq 	#0,d6
	move.w (XVIEW+4),d6						; Load XVIEW RIGHT
	add.b	#2,d6
	lsl.w	#4,d6	
	move.w	d4,-(sp)
	add.w 	d0,d4
	cmp.w 	d6,d4
	blt.s	.1	
		sub.w 	d4,d6						; Get difference
		neg.w 	d6							; Change to positive
		cmp.w 	d6,d0
		ble.s .2			
			sub.w	d6,d0					; Subtract difference from WIDTH
			sub.w	d6,d2					; Subtract difference from WIDTH Modulo
			move.w (sp)+,d4			
			bra.s 	LOADGRABX			
.2
		move.w 	(sp)+,d4
		move.w	#16,d0
		bra.s 	CALC_CLIPLEFT
.1
	move.w (sp)+,d4
	
CALC_CLIPLEFT:
	moveq 	#0,d7
	move.w	(XVIEW+2),d7					; Load XVIEW LEFT
	subq 	#2,d7							; Subtract 2 to make sure it's deep enough
	lsl.w 	#4,d7							; * 16 (D7 still holds XVIEW LEFT)
	
	cmp.w	d7,d4							; Compare X and XVIEW LEFT
	bgt.s 	.1								; Check if X is greater than XVIEW LEFT (if so - skip)
		sub.w	d4,d7						; Sub X Words from XVIEW amount to get difference
		add.w	d7,d4						; Add to X		
		cmp.w 	d7,d0						; Compare Difference to WIDTH
		ble.s 	.2							; If it's less than or equal to then skip (no negative width)
			sub.w	d7,d0					; Subtract difference from WIDTH
			sub.w	d7,d2					; Subtract difference from WIDTH Modulo		
			move.w (GRABXY_STORE),d6
			add.w	d7,d6
			lsr.w	#3,d6
			bra.s	LOADGRABY
.2
		move.w	#16,d0
.1

LOADGRABX:
	moveq 	#0,d6
	moveq 	#0,d7
	move.w (GRABXY_STORE),d6
	lsr.w	#3,d6
LOADGRABY:

	move.w (GRABXY_STORE+2),d7
	
	;---------------------------------------
	; Calc W & H ( From stored buffer )
	;---------------------------------------
	
	add.l 		d6,d7						; Add X/Y offset
	adda.l 		d7,a1						; Add to Mask Sheet
	adda.l 		d7,a2						; Add to slice sheet offset (d0 & d1 are now free)
	
	;---------------------------------------
	
; ----------------------------------------------------------------------------------------------------------
;		3. TILE CLEANER - STORE (Stores Coordiates of tiles that this slice has contact with)
; ----------------------------------------------------------------------------------------------------------
	
TILE_CLEANER1:	

	bsr.w 	TILECLEANER_STORE			
	
; ----------------------------------------------------------------------------------------------------------
;		4. CALCULATE SCREEN XY, SLICE WIDTH & HEIGHT, AND MODULOS
; ----------------------------------------------------------------------------------------------------------

	; --------------------------------------
	; CALCULATE X/Y POSITION ON SCREEN
	; --------------------------------------
	
BOB_XY:	

	lsr.w 	#3,d4							; X/8
	mulu.w 	#SCR_B_WIDTH,d5					; Multiply Y by SCR_B_WIDTH 
	add.w 	d4,d5							; Add together 
	add.l 	d5,a3							; Add to SCREEN offset
	; d4 & d5 are free

	; --------------------------------------
	; CALCULATE WIDTH & HEGHT
	; #HEIGHT*4*64+WORDWIDTH ,$058(a6)		; BLTSIZE - Size of Rectangle
	; --------------------------------------
	
BOB_WIDTH_HEIGHT:							; D0=WIDTH D1=HEIGHT

	lsl.w	#2+6,d1							; Also mul by SCR_DEPTH	
	lsr.w	#4,d0	
	add.w	d1,d0							; Value in D0
	
	; --------------------------------------
	; MODULO =(SCR_W-blt_widthV)/8	
	; d2 still holds WIDTH
	; --------------------------------------
		
BOB_MODULOS:

	; SOURCE MODULO
	move.w 	#320,d4							; Slice Sheet Width (always 320)
	sub.w 	d2,d4							; Subtract Slice WIDTH
	lsr.w	#3,d4							; Multiply by 4

	; DESTRINATION (SCREEN) MODULO
	move.w 	#SCR_W,d5						; Yada!
	sub.w	d2,d5							; Yada!
	lsr.w	#3,d5							; Yoda! (Do, or do not...)

; ----------------------------------------------------------------------------------------------------------
;		5. ADD SHIFT VALUE, LOAD BLITTER REGISTERS, AND BLIT
; ----------------------------------------------------------------------------------------------------------
	
BOB_LOAD_REGISTERS:	

	lea 	$dff000,a4							; Custom Chip base address (a4)	
	tst 	$002(a4)							; DMACONR	
	
	bsr.w 	WAITFORBLITTER	
	
	; --------------------------------------
	;	ADD SHIFT VALUE
	; --------------------------------------	
	
	; COOKIE-CUT MODE
	move.l 	#$0fca0000<<4+$f,d6				; Set DRAW mode (Cookie-Cutter)
	;move.l 	#$09f00000<<4+$f,d6			; Set DRAW mode (Block Copy)
	move.l 	#$00000000<<4+$f,d7		
	and.b	OBJ_S(a0),d6					; IMAGE shift value
	ror.l	#4,d6	
	and.b	OBJ_S(a0),d7					; MASK shift value
	ror.l	#4,d7	
	move.l 	d6,$040(a4)						; BLTCON0 - Set Blitter Control bits
	move.l 	d7,$042(a4)						; BLTCON1 - Set Blitter Control bits	
	move.l 	#$ffff0000,$044(a4)				; BLTAFWM - Set Source Mask

	; --------------------------------------
	;	LOAD REGISTERS
	; --------------------------------------

	; POINTERS
	move.l 	a1,$050(a4)						; BLTAPTH - SOURCE 		(A) pointer - MASK
	move.l 	a2,$04c(a4)						; BLTBPTH - SOURCE 		(B) pointer - IMAGE
	move.l 	a3,$048(a4)						; BLTCPTH - SOURCE 		(C) pointer - SCREEN
	move.l 	a3,$054(a4)						; BLTDPTH - DESTINATION (D) pointer - SCREEN	
	
	; MODULOS
	move.w 	d4,$064(a4)						; BLTAMOD - SOURCE 		(A) Modulo
	move.w 	d4,$062(a4)						; BLTBMOD - SOURCE 		(B) Modulo
	move.w 	d5,$060(a4)						; BLTCMOD - SOURCE		(C) Modulo	
	move.w 	d5,$066(a4)						; BLTDMOD - DESTINATION (D) Modulo	

	; --------------------------------------
	;	BLIT
	; --------------------------------------	

	move.w 	d0,$058(a4)						; BLTSIZE - Size of Rectangle		
	
	; --------------------------------------
	movem.l (sp)+,d0-a4						; Restore registers
	RTS
	; --------------------------------------
		
; ----------------------------------------------------------------------------------------------------------
;	LOADER SUBS
; ----------------------------------------------------------------------------------------------------------

LOAD_OBJECT_TABLE:

	cmp.b 	#1,(OBJECT_ID)
	beq.w	.1		
	cmp.b 	#2,(OBJECT_ID)
	beq.w	.2		
	cmp.b 	#3,(OBJECT_ID)
	beq.w	.3		
	cmp.b 	#4,(OBJECT_ID)
	beq.w	.4		
	cmp.b 	#5,(OBJECT_ID)
	beq.w	.5		
	cmp.b 	#6,(OBJECT_ID)
	beq.w	.6		
	cmp.b 	#7,(OBJECT_ID)
	beq.w	.7		
	cmp.b 	#8,(OBJECT_ID)
	beq.w	.8		
	cmp.b 	#9,(OBJECT_ID)
	beq.w	.9		
	cmp.b 	#10,(OBJECT_ID)
	beq.w	.10		
	cmp.b 	#11,(OBJECT_ID)
	beq.w	.11		
	cmp.b 	#12,(OBJECT_ID)
	beq.w	.12	
	cmp.b 	#13,(OBJECT_ID)
	beq.w	.13	
	cmp.b 	#14,(OBJECT_ID)
	beq.w	.14	
	cmp.b 	#15,(OBJECT_ID)
	beq.w	.15	
	cmp.b 	#16,(OBJECT_ID)
	beq.w	.16	

; ----------------------------------	
	
.1 
	lea 	OBJECT_1,a0
	bra.s	.LoadObjectAddressDone	
.2
	lea 	OBJECT_2,a0
	bra.s	.LoadObjectAddressDone	
.3 
	lea 	OBJECT_3,a0
	bra.s	.LoadObjectAddressDone	
.4
	lea 	OBJECT_4,a0
	bra.s	.LoadObjectAddressDone	
.5 
	lea 	OBJECT_5,a0
	bra.s	.LoadObjectAddressDone	
.6
	lea 	OBJECT_6,a0
	bra.s	.LoadObjectAddressDone	
.7 
	lea 	OBJECT_7,a0
	bra.s	.LoadObjectAddressDone	
.8
	lea 	OBJECT_8,a0
	bra.s	.LoadObjectAddressDone	
.9
	lea 	OBJECT_9,a0
	bra.s	.LoadObjectAddressDone	
.10 
	lea 	OBJECT_10,a0
	bra.s	.LoadObjectAddressDone	
.11
	lea 	OBJECT_11,a0
	bra.s	.LoadObjectAddressDone
.12
	lea 	OBJECT_12,a0
	bra.s	.LoadObjectAddressDone
.13
	lea 	OBJECT_13,a0
	bra.s	.LoadObjectAddressDone
.14
	lea 	OBJECT_14,a0
	bra.s	.LoadObjectAddressDone
.15
	lea 	OBJECT_15,a0
	bra.s	.LoadObjectAddressDone
.16
	lea 	OBJECT_16,a0
	;bra.s	.LoadObjectAddressDone
	
.LoadObjectAddressDone

; ----------------------------------
	RTS
; ----------------------------------------------------------------------------------------------------------

.NoObjectsToDraw

; ----------------------------------------------------------------------------------------------------------
;	LOAD OBJECT TYPE
; ----------------------------------------------------------------------------------------------------------

LOAD_HAGGAR_VALUES:	

	; ----------------------------------
	lea 	HAGGAR_ANIMATION_TABLE,a3		; Animation table
;	lea 	HAGGAR_STATE_TABLE,a4			; State table (Added to Animation table)
	; ----------------------------------
	
HAGGAR_SHEETS:	
	btst 	#0,OBJ_FLAGS(a0)				; Test X-Flip Bit
	bne.s	.FaceRightLoad
	lea 	HAGGAR_SLICE_SHEET_MASK_FLIP,a1	
	lea 	HAGGAR_SLICE_SHEET_FLIP,a2	
	bra.s	.FaceDirDone
.FaceRightLoad
	lea 	HAGGAR_SLICE_SHEET_MASK,a1	
	lea 	HAGGAR_SLICE_SHEET,a2	
.FaceDirDone

	; ----------------------------------
	RTS
	; ----------------------------------

;-----------------------------------------------------------------------------------------------------------
	
LOAD_BRED_VALUES:	

	; ----------------------------------
	lea 	BRED_ANIMATION_TABLE,a4			; Animation table
;	lea 	BRED_STATE_TABLE,a5				; State table (Added to Animation table)
	; ----------------------------------
	
BRED_SHEETS:	
	btst 	#0,OBJ_FLAGS(a0)
	bne.s	.FaceRightLoad
	lea 	BRED_SLICE_SHEET_MASK_FLIP,a1	
	lea 	BRED_SLICE_SHEET_FLIP,a2	
	bra.s	.FaceDirDone
.FaceRightLoad
	lea 	BRED_SLICE_SHEET_MASK,a1	
	lea 	BRED_SLICE_SHEET,a2	
.FaceDirDone

	; ----------------------------------
		RTS
	; ----------------------------------
	
;-----------------------------------------------------------------------------------------------------------
	
LOAD_J_VALUES:	

	; ----------------------------------
	lea 	J_ANIMATION_TABLE,a4			; Animation table
;	lea 	J_STATE_TABLE,a5				; State table (Added to Animation table)
	; ----------------------------------
	
J_SHEETS:	
	btst 	#0,OBJ_FLAGS(a0)
	bne.s	.FaceRightLoad
	lea 	J_SLICE_SHEET_MASK_FLIP,a1	
	lea 	J_SLICE_SHEET_FLIP,a2	
	bra.s	.FaceDirDone
.FaceRightLoad
	lea 	J_SLICE_SHEET_MASK,a1	
	lea 	J_SLICE_SHEET,a2	
.FaceDirDone

	; ----------------------------------
		RTS
	; ----------------------------------
	
;-----------------------------------------------------------------------------------------------------------
	
LOAD_HITSPARK_VALUES:	

	; ----------------------------------
	lea 	FX_ANIMATION_TABLE,a4			; Animation table
	; ----------------------------------
	
HITSPARK_SHEETS:	
	btst 	#0,OBJ_FLAGS(a0)
	bne.s	.FaceRightLoad
	lea 	FX_SLICE_SHEET_MASK_FLIP,a1	
	lea 	FX_SLICE_SHEET_FLIP,a2	
	bra.s	.FaceDirDone
.FaceRightLoad
	lea 	FX_SLICE_SHEET_MASK,a1	
	lea 	FX_SLICE_SHEET,a2	
.FaceDirDone

	; ----------------------------------
		RTS
	; ----------------------------------
	
;-----------------------------------------------------------------------------------------------------------
	
LOAD_GAMEOVER_VALUES:	

	; ----------------------------------
	lea 	FX_ANIMATION_TABLE,a4			; Animation table
	; ----------------------------------

GAMEOVER_SHEETS:

	lea 	FX_SLICE_SHEET_MASK,a1			; No flipped data needed. Text only faces one way.
	lea 	FX_SLICE_SHEET,a2
	
	; ----------------------------------
		RTS
	; ----------------------------------
	
;-----------------------------------------------------------------------------------------------------------
;		PRIORITY SORTER		$ONYY - ON = Object Number | YY = Y Coordinate
; 		- Sorted by Y coordinate in ascending order
;-----------------------------------------------------------------------------------------------------------
	
PRIORITY_SORTER:
				
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	
	move.b	(OBJECT_NUMBER_OF),d0	; How many screen objects to sort
	
Pri_LoopO
	lea 	OBJECT_IDY,a0	
Pri_LoopI
	tst.w	(a0)+
	beq.s	PRI_DONE
	tst.w	(a0)
	beq.s	PRI_DONE
	sub	 	#2,a0
	move.w 	(a0)+,d2 				; Fetch current element
	move.w	(a0),d3					
	cmp.b 	d2,d3 					; Is d3 > d2
	bcc.s 	Pri_LoopI  				; If > skip, else swap
	move.w 	(a0),-2(a0)
	move.w 	d2,(a0)
	bra.s	Pri_LoopI 
PRI_DONE:
	lea 	OBJECT_IDY,a1
	dbra 	d0,Pri_LoopO
	; ----------------------------------
	RTS
	; ----------------------------------
	





