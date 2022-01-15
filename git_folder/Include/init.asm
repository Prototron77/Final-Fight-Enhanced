;----------------------------------------------------------------------------------------------------------
;	INIT MAIN SCREEN
;----------------------------------------------------------------------------------------------------------

INIT_MAIN:




;----------------------------------------------------------------------------------------------------------
;	HUDSCREEN CONSTANTS
;----------------------------------------------------------------------------------------------------------
HSCR_DEPTH				=	5	; 5 BITPLANES  - Interleaved bitmap
HSCR_W					= 	320				
HSCR_H					=	48
HSCR_BPL				=	HSCR_W/8
HSCR_BPLSIZE			=	HSCR_BPL*HSCR_H
HSCR_B_WIDTH			= 	HSCR_BPL*HSCR_DEPTH

;----------------------------------------------------------------------------------------------------------
;	HUD DISPLAY AREA CONSTANTS (Centered)
;----------------------------------------------------------------------------------------------------------

HVSCR_W					= 	320
HVSCR_OFFSET			=	(HSCR_W-HVSCR_W)/2
HSCR_MODULO				= 	HSCR_BPL*(HSCR_DEPTH-1)+(HSCR_W-HVSCR_W)/8

;----------------------------------------------------------------------------------------------------------
;	MAIN SCREEN CONSTANTS
;----------------------------------------------------------------------------------------------------------

SCR_DEPTH				=	4	; 4 BITPLANES  - Interleaved bitmap
SCR_W					= 	400		
SCR_H					=	240	
SCR_BPL					=	SCR_W/8
SCR_BPLSIZE				=	SCR_BPL*SCR_H
SCR_B_WIDTH				= 	SCR_BPL*SCR_DEPTH
SCR_OFFSET				=	4

;----------------------------------------------------------------------------------------------------------
;	MAIN VISIBLE DISPLAY AREA CONSTANTS (Centered)
;----------------------------------------------------------------------------------------------------------

VSCR_W					= 	320
VSCR_OFFSET				=	(SCR_W-VSCR_W)/2
SCR_MODULO				= 	SCR_BPL*(SCR_DEPTH-1)+(SCR_W-VSCR_W)/8

;------------------------------------------------------------------------------------------------------------
;	MAINSCREEN HIDDEN CONSTANTS
;----------------------------------------------------------------------------------------------------------

MAIN_HIDDEN_W			= 	240				
MAIN_HIDDEN_H			=	240
MAIN_HIDDEN_BYTES		=	MAIN_HIDDEN_W/8
MAIN_HIDDEN_BPLSIZE		=	MAIN_HIDDEN_BYTES*MAIN_HIDDEN_H
MAIN_HIDDEN_B_WIDTH		= 	MAIN_HIDDEN_BYTES*SCR_DEPTH


;----------------------------------------------------------------------------------------------------------
;	TILE CONSTANTS
;----------------------------------------------------------------------------------------------------------

TILESCREEN_W 			= 20
TILESCREEN_H 			= 13
TILESCREEN_TOTAL		= 260



;----------------------------------------------------------------------------------------------------------
;	BLITTER CONSTANTS (Old)
;----------------------------------------------------------------------------------------------------------

;bltX		= 0
;bltY 		= 0
		; SCR_B_WIDTH already mul by 4
;bltOffs 	= (bltY*SCR_B_WIDTH)+(bltX/8)

;blt_height 	= 93
;blt_widthV	= 96
;blt_width 	= blt_widthV/16
;blt_modu 	= (SCR_W-blt_widthV)/8
;blt_brcorner = (blt_height-1)*SCR_BPL+blt_widthV*2-2

;----------------------------------------------------------------------------------------------------------
;	TURN OFF AMIGA OS
;----------------------------------------------------------------------------------------------------------

;OSoff:
	
	bset.b 	#1,$bfe001						; Turn Off Audio Low Pass Filter
		
		
;	move.l 	4.w,a6							; Execbase
;	moveq	#0,d0
;	lea		GFXNAME(pc),a1
;	jsr 	-408(a6)						; oldopenlibrary()
;	move.l 	d0,a1
;	move.l 	38(a1),d4						; Original Copper ptr
;	jsr 	-414(a6)						; Closelibrary()
	
	; -- Enable/Disable relebant bits in registers --

;EnaDis:	 ; order matters: disable interrupts first

;	move.w 	$dff01c,d5
;	move.w 	$dff002,d3		
;	move.w 	#%0111111111111111,$dff09a		; Disable all bits in INTENA	- dff09a
;	move.w 	#%0111111111111111,$dff09c		; Disable all bits in INTENAQ	- dff09c			
;	move.w 	#%1000000000000000,$dff096		; Set relevant bits in DMACON	- dff096	

CopperMSInit:

;----------------------------------------------------------------------------------------------------------
;	BITPLANE POINTERS POKE - HUD SCREEN
;----------------------------------------------------------------------------------------------------------

	lea 	HUDSCREEN,a0	   				; Pointer to first bitplne of screen (+2 for hidden area)
	lea 	CoBplPr_HUD,a1					; Where to poke the bitplane pointer words.
	moveq	#HSCR_DEPTH-1,d0				; Loop Counter	
.bpl_loopHS:
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	lea		HSCR_BPL(a0),a0 				; interleaved bitmap (see BPLxMOD in copperlist)
	dbf 	d0,.bpl_loopHS
	
;----------------------------------------------------------------------------------------------------------
;	LOAD PALETTE (POKE COLOUR VALUES) - HUD SCREEN
;----------------------------------------------------------------------------------------------------------

	lea 	PalHUD,a0	   					; Pointer to Palette values
	lea 	PALETTE_HUD,a1					; Where to poke the bitplane pointer words.
	moveq	#32-1,d0						; Loop Counter	

.lp_LOADPALETTE_HUD:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_HUD
	
;----------------------------------------------------------------------------------------------------------
;	BITPLANE POINTERS POKE - MAIN SCREEN (Set 2 screen buffers)
;----------------------------------------------------------------------------------------------------------
	;-----------------------------------------------
	; 	LOAD TILECLEANER TABLE ADDRESSES TO LIST
	;-----------------------------------------------
	
	lea 		TILECLEANER_TABLE1,a1
	lea 		TILECLEANER_TABLE2,a2
	lea 		TILECLEANER_TABLES,a3
	
	move.l 		a1,(a3)+
	move.l 		a2,(a3)+
	
	;-----------------------------------------------
	; 	LOAD TILECLEANER OFFSETS
	;-----------------------------------------------
	
	lea 		TILECLEAN_OFFSET1,a1
	lea 		TILECLEAN_OFFSET2,a2
	lea 		TILECLEAN_OFFSETS,a3
	
	move.l 		a1,(a3)+
	move.l 		a2,(a3)+
	
	;-----------------------------------------------
	;	LOAD SCREEN BUFFER ADDRESSES TO LIST
	;-----------------------------------------------
	
	lea 		MAIN_SCREEN,a1			
	lea 		BACK_BUFFER,a2
	lea 		DOUBLE_BUFFER,a3
	
	move.l 		a1,(a3)+
	move.l 		a2,(a3)+
		
	;-----------------------------------------------
	;	POKE BITPLANE POINTERS
	;-----------------------------------------------
	;lea 	MAINSCREEN+SCR_BPL*(32*4)+SCR_OFFSET,a0	; Pointer to first bitpalne of screen (+2 for hidden area)
	;-----------------------------------------------
	
	movea.l		DOUBLE_BUFFER,a0					; First Buffer is MAINSCREEN		
	add 		#SCR_BPL*(32*4)+SCR_OFFSET,a0
	add.w 		(XVIEW+6),a0
		
	lea 		CoBplPr_MAIN,a1							; Where to poke the bitplane pointer words.
	moveq		#SCR_DEPTH-1,d0							; Loop Counter	
.Loop_BPL_MAIN:
	move.l 		a0,d1
	swap 		d1
	move.w 		d1,2(a1)								; High word
	swap 		d1
	move.w 		d1,6(a1)								; Low word
	addq.l		#8,a1									; Point to next bpl to poke in copper
	lea			SCR_BPL(a0),a0 							; interleaved bitmap (see BPLxMOD in copperlist)
	dbf 		d0,.Loop_BPL_MAIN
	;-----------------------------------------------
	
;	lea 	COPPER_SCROLL_SHIFT,a0
;	sub.w	#$ff,2(a0)
	
;----------------------------------------------------------------------------------------------------------
;	LOAD PALETTE (POKE COLOUR VALUES) - MAIN SCREEN
;----------------------------------------------------------------------------------------------------------

	lea 	PalGame7,a0	   					; Pointer to Palette values	
	lea 	PALETTE_MAIN,a1					; Where to poke the bitplane pointer words.
	moveq	#16-1,d0						; Loop Counter	

.lp_LOADPALETTE:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE

;----------------------------------------------------------------------------------------------------------
;	SET COPPER LISTS	
;-----------------------------------------------------------------------------------------------------------

SetCopper1:	
	move.l 	#COPPER_MAINGAME,$dff080					; COP1LCH
	
;----------------------------------------------------------------------------------------------------------
	RTS
;----------------------------------------------------------------------------------------------------------