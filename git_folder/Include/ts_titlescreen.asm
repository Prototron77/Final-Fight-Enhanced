;-----------------------------------------------------------------------------------------------------------
;	TITLE SCREEN
;-----------------------------------------------------------------------------------------------------------
		
	SECTION TS_CODE,CODE
	;-------------------
	
	;-----------------------------------
	bsr.w 	INIT_TS						; Set bitplale pointers and Title Screen Buffer 
	;-----------------------------------
	
	
	;-----------------------------------	
	; START MUSIC
	;-----------------------------------
	
	lea 	MUS_TITLE,a0
	sub.l 	a1,a1
	sub.l 	a2,a2
	moveq 	#0,d0
	
	movem.l d0-a6,-(sp)		
	bsr 	P61_Init
	movem.l (sp)+,d0-a6		
	
	;-----------------------------------
		
FADEV	= 4

TITLESCREEN_LOOP:

	;----------------------------------
	bsr.w	VBLANK
	;----------------------------------
	btst 	#2,TSFLAGS
	bne.w	.2
	bsr.w	TS_SCREENCHANGE
	;----------------------------------
	
	btst 	#0,TSFLAGS
	bne.s 	.1
	bsr.w 	TS_PUSHSTART_FLASH
.1
	bsr.w 	PUSHSTART
.2
	;----------------------------------
	bsr.w	TS_FADES
	;----------------------------------
	bra.s	TITLESCREEN_LOOP
	;----------------------------------

Exit:
	
;-----------------------------------------------------------------------------------------------------------
;	TS INCLUDE FILES
;-----------------------------------------------------------------------------------------------------------
	
	include		"Include/ts_elements.asm"
	include		"Include/ts_credits.asm"
	include		"Include/blit_logo.asm"
	include 	"Include/cpu_text_drawer.asm"
	include		"Include/inc_subs_shared.asm"
	
	;----------------------------------------------
	
usecode		=$B409	
channels 	= 4
	include 	"Include/mus_player_constants.asm"

;--------------------------------------
;	 VOLUME MIXER
;--------------------------------------
P61_Master:
	dc.w 48
P61_Ch1Vol:
	dc.w 64
P61_Ch2Vol:
	dc.w 48
P61_Ch3Vol:
	dc.w 48
P61_Ch4Vol:
	dc.w 48
	include 	"Include/P6112-Play.i"
;----------------------------------------------

;-----------------------------------------------------------------------------------------------------------
; 	SUBROUTINES
;-----------------------------------------------------------------------------------------------------------	
	
PUSHSTART:

	bsr.w 	JOYSTICK_READER
	btst 	#4,d0						; Press Fire to Start Game (Goes nowhere ATM)
	bne.s	.2
		bset #2,TSFLAGS
		lea		TITLE_SCREEN,a0
		move.w	#(TITLE_SCREEN_END-TITLE_SCREEN)/4-1,d1
		bsr.w	CLEARSCREEN	
		move.w	#(TS_LOGO_END-TS_LOGO)/4-1,d1
	bsr 	P61_End
	bra.w	Exit
	;bsr.w	CLEARSCREEN	
	;bra.w	STARTGAME
.2
	RTS

TS_FADES:	
	;-----------------------------------------------
	;	FADE IN
	;-----------------------------------------------
	
	btst 	#6,HUDFLAGS2
	beq.s	.1
	tst.b 	(FADET)			; FADET Sets speed of Fade
	bne.s	.2	
	bsr.w 	FADEIN_TS
	move.b	#FADEV,(FADET)
.2
	sub.b	#1,(FADET)
.1
	;-----------------------------------------------
	;	FADE OUT
	;-----------------------------------------------
	
	btst 	#7,HUDFLAGS2
	beq.s	.3
	tst.b 	(FADET)
	bne.s	.4	
	bsr.w 	FADEOUT_TS
	move.b	#FADEV,(FADET)
.4
	sub.b	#1,(FADET)
.3
	;-----------------------------------------------
	RTS
	;-----------------------------------------------
;------------------------------------------------------------------------------------------------------------
;	FADES (WIP) - Haven't worked out how to poke the Copper Palette Waits yet.
;-----------------------------------------------------------------------------------------------------------
	
FADEIN_TS:

	movem.l a0-a2/d0/d1,-(sp)
	;---------------------------------------
	cmp.b 	#0,FADE
	bgt.s 	.1
	lea 	PalTITLE6,a0		; Main Palette
	lea 	PurpFADE6,a2		; Wait 1
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.1
	cmp.b 	#1,FADE
	bgt.s 	.2
	lea 	PalTITLE5,a0
	lea 	PurpFADE5,a2	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.2
	cmp.b 	#2,FADE
	bgt.s 	.3
	lea 	PalTITLE4,a0	
	lea 	PurpFADE4,a2	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.3
	cmp.b 	#3,FADE
	bgt.s 	.4
	lea 	PalTITLE3,a0	  
	lea 	PurpFADE3,a2	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.4
	cmp.b 	#4,FADE
	bgt.s 	.5
	lea 	PalTITLE2,a0
	lea 	PurpFADE2,a2	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.5
	cmp.b 	#5,FADE
	bgt.s 	.6
	lea 	PalTITLE1,a0	
	lea 	PurpFADE1,a2	
	bsr.w	FADE_POKE
	bra.w	FADEIN_DONE
.6
	lea 	PalTITLE,a0	
	lea		PalINTROTEXT_PURPLE,a2	
	bsr.w	FADE_POKE
	bclr 	#6,HUDFLAGS2
	move.b 	#0,(FADE)	
	;---------------------------------------
FADEIN_DONE
	movem.l (sp)+,a0-a2/d0/d1
	;---------------------------------------
	RTS
	;---------------------------------------
	
FADEOUT_TS:

	movem 	a0/a1/d0/d1,-(sp)
	
	;---------------------------------------
	cmp.b 	#0,FADE
	bgt.s 	.1
	lea 	PalTITLE,a0	   	
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.1
	cmp.b 	#1,FADE
	bgt.s 	.2
	lea 	PalTITLE1,a0	   						
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.2
	cmp.b 	#2,FADE
	bgt.s 	.3
	lea 	PalTITLE2,a0	   				
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.3
	cmp.b 	#3,FADE
	bgt.s 	.4
	lea 	PalTITLE3,a0	   				
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.4
	cmp.b 	#4,FADE
	bgt.s 	.5
	lea 	PalTITLE4,a0	   				
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.5
	cmp.b 	#5,FADE
	bgt.s 	.6
	lea 	PalTITLE5,a0	   				
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.6
	cmp.b 	#6,FADE
	bgt.s 	.7
	lea 	PalTITLE6,a0	   				
	bsr.w	FADE_POKE
	bra.w	FADEOUT_DONE
.7
	lea 	PalTITLE7,a0	   				
	bsr.w	FADE_POKE
	bclr 	#7,HUDFLAGS2
	move.b 	#0,(FADE)

	;---------------------------------------
FADEOUT_DONE:
	movem (sp)+,a0/a1/d0/d1
	;---------------------------------------
	RTS
	;---------------------------------------
	
FADE_POKE:

	moveq 	#0,d0
	moveq 	#0,d1
	
	lea 	PALETTE_TS,a1					; Where to poke the bitplane pointer words.
	moveq	#32-1,d0						; Loop Counter	

.lp_LOADPALETTE:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE
	;add.b 	#1,(FADE)
	
	moveq 	#0,d0
	moveq 	#0,d1
	

	lea 	TSCP_WAIT1,a1					; Where to poke the bitplane pointer words.
	
	move.w 	#$CF01,(a1)+
	move.w 	#$FF00,(a1)+
	
	moveq	#7-1,d0							; Loop Counter	

.lp_LOADPALETTEW1:
	move.w 	(a2)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1						; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTEW1
	add.b 	#1,(FADE)
	;---------------------------------------
	RTS
	;---------------------------------------
	
;----------------------------------------------------------------------------------------------------------
;	INIT TITLE
;----------------------------------------------------------------------------------------------------------

INIT_TS:

;-----------------------------------------------------------------------------------------------------------
;	TITLE SCREEN CONSTANTS
;-----------------------------------------------------------------------------------------------------------

TSCR_DEPTH				=	5				; 5 BITPLANES
TSCR_W					= 	320				
TSCR_H					=	256
TSCR_BPL				=	TSCR_W/8
TSCR_BPLSIZE			=	TSCR_BPL*TSCR_H
TSCR_B_WIDTH			= 	TSCR_BPL*TSCR_DEPTH
TSCR_MODULO				= 	TSCR_BPL*(TSCR_DEPTH-1);+TSCR_BPL


;-----------------------------------------------------------------------------------------------------------
;	TURN OFF INTERRUPTS & OTHER STUFF
;-----------------------------------------------------------------------------------------------------------

OSoff:
	
	bset.b 	#1,$bfe001						; Turn Off Audio Low Pass Filter

;------------------------------------------
; 	INTERRUPTS OFF
;------------------------------------------

EnaDis:
	
	move.w 	#%0111111111111111,$dff09a		; Disable all bits in INTENA	- dff09a
	move.w 	#%0111111111111111,$dff09c		; Disable all bits in INTENAQ	- dff09c			
	move.w 	#%1000000000000000,$dff096		; Set relevant bits in DMACON	- dff096

CopperTSInit:

;------------------------------------------
;	BITPLANE POINTERS POKE - TITLE SCREEN
;------------------------------------------

	lea 	TITLE_SCREEN,a0	   				; Pointer to first bitplne of screen
	lea 	CoBplPr_TS,a1					; Where to poke the bitplane pointer words.
	moveq	#TSCR_DEPTH-1,d0				; Loop Counter	
.bpl_loopTS:
	move.l 	a0,d1
	swap 	d1
	move.w 	d1,2(a1)						; High word
	swap 	d1
	move.w 	d1,6(a1)						; Low word
	addq.l	#8,a1							; Point to next bpl to poke in copper
	lea		TSCR_BPL(a0),a0 				; interleaved bitmap (see BPLxMOD in copperlist)
	dbf 	d0,.bpl_loopTS
	
;------------------------------------------
;	LOAD PALETTE - TITLE SCREEN
;------------------------------------------
	
	lea 	PalTITLE7,a0	   				; Pointer to Palette values
	lea 	PALETTE_TS,a1					; Where to poke the bitplane pointer words.
	moveq	#32-1,d0						; Loop Counter	

.lp_LOADPALETTE_TS:
	move.w 	(a0)+,d1
	move.w 	d1,2(a1)	
	addq.l	#4,a1							; Point to next bpl to poke in copper
	dbf 	d0,.lp_LOADPALETTE_TS

;------------------------------------------
;	SET TS COPPER LIST
;------------------------------------------

SetCopperTitleScreen:	

	move.l 	#COPPER_TITLESCREEN,$dff080		; COP1LCH
	
;------------------------------------------
	RTS
;------------------------------------------
	
	
;-----------------------------------------------------------------------------------------------------------
; 	DATA
;-----------------------------------------------------------------------------------------------------------

		SECTION TS_DATA,DATA_C
		;---------------------
		
;----------------------------------------------------------------------------------------------------------
;	COPPERLIST FOR TITLE SCREEN	
;----------------------------------------------------------------------------------------------------------

COPPER_TITLESCREEN:						

; --------------------------------------
;	DISPLAY/DATA START & STOP
; --------------------------------------

	dc.w $1fc,0	
	dc.w $08E,$2c81						; Display Screen Top Left  		(VVHH)
	dc.w $090,$2cc1 					; Display Screen Botom Right 	(VVHH)
	dc.w $092,$38						; Display Bitplane Fetch Start 	(XXHH)
	dc.w $094,$d0						; Display Bitplane Fetch Stop 	(XXHH)		
	
; --------------------------------------
;	BITPLANE CONTROL
; --------------------------------------

	dc.w $100,%0101001000000001			; BPLCON0
	dc.w $106,%0000000000100000			; BPLCON3 - Enable ECS Border Blanking	
	dc.w $108,TSCR_MODULO				; Bitplane Modulo SCR_BPL*4 (odd planes) 
	dc.w $10A,TSCR_MODULO				; Bitplane Modulo SCR_BPL*4 (even planes)

; --------------------------------------
;	BITPLANE POINTERS
; --------------------------------------

CoBplPr_TS:
	dc.w $0e0,0							; Bitplane Pointer 1 (High 5 Bits) (ECS)
	dc.w $0e2,0							; Bitplane Pointer 1 (Low 15 Bits)	
	dc.w $0e4,0							; Bitplane Pointer 2 (High 5 Bits)
	dc.w $0e6,0							; Bitplane Pointer 2 (Low 15 Bits)
	dc.w $0e8,0							; Bitplane Pointer 3 (High 5 Bits)
	dc.w $0ea,0							; Bitplane Pointer 3 (Low 15 Bits)
	dc.w $0ec,0							; Bitplane Pointer 4 (High 5 Bits)
	dc.w $0ee,0							; Bitplane Pointer 4 (Low 15 Bits)
	dc.w $0f0,0							; Bitplane Pointer 5 (High 5 Bits)
	dc.w $0f2,0							; Bitplane Pointer 5 (Low 15 Bits)
	
; --------------------------------------
;	SPRITE POINTERS
; --------------------------------------

SprPtr_TS:
	dc.w $120,0							; HW Sprite 0
	dc.w $122,0	
	dc.w $124,0							; HW Sprite 1
	dc.w $126,0					
	dc.w $128,0							; HW Sprite 2				
	dc.w $12a,0							
	dc.w $12c,0							; HW Sprite 3				
	dc.w $12e,0		
	dc.w $130,0							; HW Sprite 4		
	dc.w $132,0					
	dc.w $134,0							; HW Sprite 5
	dc.w $136,0						
	dc.w $138,0							; HW Sprite 6					
	dc.w $13a,0							
	dc.w $13c,0							; HW Sprite 7
	dc.w $13e,0	
	
; --------------------------------------
;	PALETTE
; --------------------------------------

PALETTE_TS:
	dc.w $180,0							; Colour 0
	dc.w $182,0							; Colour 1
	dc.w $184,0							; Colour 2
	dc.w $186,0							; Colour 3
	dc.w $188,0							; Colour 4
	dc.w $18a,0							; Colour 5
	dc.w $18c,0							; Colour 6
	dc.w $18e,0							; Colour 7
	dc.w $190,0							; Colour 8
	dc.w $192,0							; Colour 9
	dc.w $194,0							; Colour 10
	dc.w $196,0							; Colour 11
	dc.w $198,0							; Colour 12
	dc.w $19a,0							; Colour 13
	dc.w $19c,0							; Colour 14
	dc.w $19e,0							; Colour 15
	dc.w $1a0,0							; Colour 16		
	dc.w $1a2,0							; Colour 17
	dc.w $1a4,0							; Colour 18
	dc.w $1a6,0							; Colour 19
	dc.w $1a8,0							; Colour 20		
	dc.w $1aa,0							; Colour 21
	dc.w $1ac,0							; Colour 22
	dc.w $1ae,0							; Colour 23
	dc.w $1b0,0							; Colour 24
	dc.w $1b2,0							; Colour 25
	dc.w $1b4,0							; Colour 26
	dc.w $1b6,0							; Colour 27
	dc.w $1b8,0							; Colour 28
	dc.w $1ba,0							; Colour 29
	dc.w $1bc,0							; Colour 30
	dc.w $1be,0							; Colour 21
	
;-- TEXT PALETTE CHANGES --
	
TSCP_WAIT1:
	dc.w $Fe00,$ff00					
	dc.w $184,$0							; Colour 2
	dc.w $19a,$0							; Colour 13
	dc.w $19c,$0							; Colour 14
	dc.w $19e,$0							; Colour 15
	dc.w $1a0,$0							; Colour 16		
	dc.w $1a2,$0							; Colour 17
	dc.w $1a4,$0							; Colour 18
	
TSCP_WAIT2:	
	dc.w $Fe00,$ff00					
	dc.w $184,$0							; Colour 2
	dc.w $19a,$0							; Colour 13
	dc.w $19c,$0							; Colour 14
	dc.w $19e,$0							; Colour 15
	dc.w $1a0,$0							; Colour 16		
	dc.w $1a2,$0							; Colour 17
	dc.w $1a4,$0							; Colour 18
	
TSCP_WAIT3:
	dc.w $fe00,$ff00
	dc.w $184,$0							; Colour 2
	dc.w $19a,$0							; Colour 13
	dc.w $19c,$0							; Colour 14
	dc.w $19e,$0							; Colour 15
	dc.w $1a0,$0							; Colour 16		
	dc.w $1a2,$0							; Colour 17
	dc.w $1a4,$0							; Colour 18
	
;-------------------------------------------
;	COPPER TITLE SCREEN END
;-------------------------------------------

	dc.w $ffff,$fffe						; COPPER END
	
;-----------------------------------------------------------------------------------------------------------
; 	FLAGS, VARIABLES, AND TIMERS
;-----------------------------------------------------------------------------------------------------------

HUDFLAGS:   		dc.b %00000000		
HUDFLAGS2:   		dc.b %01000000
	EVEN
	
HUDTIMERS:			dc.w $0030 	; First BYTE = Energy Bar clear | Second BYTE = 2P START Flash
TILETABLE:			dc.w $0000,$0000,$0000,$0000,$FFFE,$002A,$0002
TSFLAGS: 			dc.b %00000001	
TS_TIMER_TEXTFLASH:	dc.b $00
	EVEN
	
TS_TIMER_SCR:		dc.w $0000		
TS_TIMER:			dc.w $FFFF
TEXT_TIMER:			dc.w $FFFF	
TS_TIMER_SCREENS:	dc.b 8	
TEXTFLASH_T: 		dc.b 64	
FADE:				dc.b 0
FADET:				dc.b FADEV
	EVEN

CPU_TEXT_DRAWL:		dc.l 0,0,0,0			; SOURCE | DEST | FONT TABLE | OFFSETS TABLE
CPU_TEXT_DRAWL_END

	
;VID_DELAY:
;	dc.w $1400
;	EVEN
;------------------------------------------------------
; TITLE SCREEN (32 Colours)
;------------------------------------------------------

PalTITLE:									;$06CE <- Original Blue
	dc.w $0000,$0115,$0227,$0339,$044A,$055C,$0f00,$0FFF ; 8			; <-- MAIN PALETTE
	dc.w $0F40,$0F50,$0F60,$0F90,$0F80,$0F70,$0F94,$0FA5 ; 16
	dc.w $0FB6,$0FD7,$0FF8,$0FA0,$0FB0,$0FC0,$0FE0,$0531 ; 24	
	dc.w $0641,$0650,$0752,$0862,$0973,$0B93,$0546,$0888 ; 32
PalTITLE1:								
	dc.w $0000,$0114,$0226,$0227,$0339,$044A,$0D00,$0DDD
	dc.w $0D30,$0D40,$0D50,$0D80,$0B70,$0B60,$0D80,$0D94
	dc.w $0B85,$0DB6,$0DD7,$0B90,$0D90,$0DA0,$0DB0,$0431 	
	dc.w $0531,$0540,$0642,$0752,$0863,$0983,$0435,$0777
PalTITLE2:								
	dc.w $0000,$0114,$0115,$0225,$0336,$0449,$0B00,$0BBB
	dc.w $0B30,$0B30,$0B40,$0B60,$0B60,$0B50,$0B63,$0B74
	dc.w $0B84,$0B95,$0BB6,$0B70,$0B80,$0B90,$0BA0,$0421 	
	dc.w $0431,$0440,$0541,$0641,$0652,$0862,$0434,$0666
PalTITLE3:								
	dc.w $0000,$0113,$0114,$0114,$0226,$0337,$0900,$0999 				
	dc.w $0920,$0930,$0930,$0950,$0950,$0940,$0952,$0963 
	dc.w $0963,$0974,$0995,$0960,$0960,$0970,$0980,$0321 	
	dc.w $0321,$0330,$0431,$0531,$0524,$0652,$0323,$0555	
PalTITLE4:								
	dc.w $0000,$0002,$0113,$0113,$0224,$0225,$0600,$0666 				
	dc.w $0620,$0620,$0630,$0640,$0630,$0630,$0642,$0642
	dc.w $0653,$0663,$0663,$0640,$0650,$0650,$0660,$0210 	
	dc.w $0320,$0320,$0321,$0221,$0431,$0541,$0223,$0333
PalTITLE5:								
	dc.w $0000,$0001,$0112,$0112,$0113,$0113,$0400,$0444 				
	dc.w $0410,$0410,$0420,$0430,$0430,$0420,$0431,$0431 
	dc.w $0410,$0442,$0442,$0430,$0430,$0430,$0440,$0110 	
	dc.w $0210,$0210,$0211,$0110,$0321,$0321,$0112,$0222
PalTITLE6:								
	dc.w $0000,$0001,$0001,$0001,$0111,$0111,$0200,$0222 				
	dc.w $0210,$0210,$0210,$0210,$0210,$0210,$0211,$0211 
	dc.w $0210,$0221,$0221,$0210,$0220,$0220,$0220,$0100 	
	dc.w $0110,$0110,$0110,$0221,$0110,$0210,$0111,$0111
PalTITLE7:								
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 				; <-- BLACK PALETTE
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 	
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 

;------------------------------------------------------
;	TEXT PALETTE NUMBERS: 02,13,14,15,16,17,18
;------------------------------------------------------

PalINTROTEXT_YEL:
			dc.w	$0227,$0F70,$0f94,$0FA5,$0FB6,$0FD7,$0FF8	
YelFADE1:	dc.w	$0225,$0B50,$0f94,$0FA5,$0FB6,$0FD7,$0FF8	
YelFADE2:	dc.w	$0115,$0840,$0f94,$0FA5,$0FB6,$0FD7,$0FF8		
YelFADE3:	dc.w	$0114,$0420,$0f94,$0FA5,$0FB6,$0FD7,$0FF8	
YelFADE4:	dc.w	$0113,$0420,$0f94,$0FA5,$0FB6,$0FD7,$0FF8
YelFADE5:	dc.w	$0112,$0420,$0f94,$0FA5,$0FB6,$0FD7,$0FF8	
YelFADE6:	dc.w	$0111,$0F70,$0f94,$0FA5,$0FB6,$0FD7,$0FF8		
YelFADE7:	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000


PalINTROTEXT_BLUE:
			dc.w	$0008,$048F,$059F,$06AF,$08BF,$0ADF,$0CFF
BlueFADE1:	dc.w	$0007,$037D,$048D,$059D,$079D,$09BD,$0ADD
BlueFADE2:	dc.w	$0006,$036B,$046B,$047B,$068B,$079B,$09BB
BlueFADE3:	dc.w	$0005,$0259,$0359,$0369,$0569,$0679,$0799
BlueFADE4:	dc.w	$0003,$0236,$0246,$0346,$0356,$0466,$0566
BlueFADE5:	dc.w	$0002,$0124,$0134,$0234,$0234,$0344,$0344
BlueFADE6:	dc.w	$0001,$0112,$0112,$0112,$0122,$0122,$0222
BlueFADE7:	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000


PalINTROTEXT_RED:
			dc.w	$0500,$0A00,$0B00,$0C00,$0D10,$0E20,$0F30
RedFADE1:	dc.w	$0400,$0900,$0900,$0A00,$0B10,$0C20,$0D30
RedFADE2:	dc.w	$0400,$0700,$0800,$0900,$0910,$0A10,$0B30
RedFADE3:	dc.w	$0300,$0600,$0600,$0700,$0710,$0810,$0930
RedFADE4:	dc.w	$0200,$0400,$0500,$0500,$0600,$0610,$0610
RedFADE5:	dc.w	$0100,$0300,$0300,$0300,$0400,$0410,$0410
RedFADE6:	dc.w	$0100,$0100,$0200,$0200,$0200,$0200,$0200
RedFADE7:	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000

	
PalINTROTEXT_PURPLE:
			dc.w	$0008,$0A2A,$0B4B,$0C6C,$0D8D,$0EAE,$0FCF
PurpFADE1:	dc.w	$0007,$0929,$0949,$0A5A,$0B7B,$0C9C,$0DAD
PurpFADE2:	dc.w	$0006,$0717,$0838,$0949,$0969,$0A7A,$0B9B
PurpFADE3:	dc.w	$0005,$0616,$0626,$0737,$0757,$0868,$0979
PurpFADE4:	dc.w	$0003,$0414,$0525,$0535,$0636,$0646,$0656
PurpFADE5:	dc.w	$0002,$0313,$0313,$0323,$0424,$0434,$0434
PurpFADE6:	dc.w	$0001,$0101,$0212,$0212,$0212,$0212,$0222
PurpFADE7:	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000
	
;------------------------------------------------------
;	FONT TABLES
;------------------------------------------------------
	
TS_SMALLFONT: 		; ASCII 8x8
	dc.b 	0,1,2,3,4,5,6,7,8,9,10,11,12,13					; SPACE & PUNCT	1
	dc.b 	62,0
	dc.b 	14,15,16,17,18,19,20,21,22,23 					; NUMBERS
	dc.b 	24,25,26,27,28,29,30							; PUNCT 2
	dc.b	31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46	; LETTERS UPPER
	dc.b 	47,48,49,50,51,52,53,54,55,56,0,0,0,0,0,0
	dc.b	63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
	dc.b	80,81,82,83,84,85,86,87,88
	EVEN
TS_INTROFONT: 		; ASCII 8x16
	dc.b 	90,152,146,0,0,0,0,144,148,149,0,0,146,0,117,0
	; Numbers
	dc.b	163,154,155,156,157,158,159,160,161,162,147,0,0,0,0,151,0
	; UPPERCASE
	dc.b	91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107
	dc.b	108,109,110,111,112,113,114,115,116,0,0,0,0,0,0

	; LowerCase
	dc.b	118,119,120,121,122,123,124,125,126,127,128,129,130
	dc.b	131,132,133,134,135,136,137,138,139,140,141,142,143
	;dc.b	,144,145,146,147,148,49,1,150,151,152
	EVEN
TS_LARGEFONT:
	dc.b	163	; SPACE
	blk.b 	10	; PAD
	dc.b	164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179	; A-Z
	dc.b	180,181,182,183,184,185,186,187,188,189
	EVEN
	
TS_CHARS_OFFSETS:
	;------------------------------------------------------------------------------
	;		INTRO FONT	SMALL ( 8 x 8 ) 0-89
	;------------------------------------------------------------------------------
	dc.w	$0000,$0100,$0200,$0300,$0400,$0500,$0600,$0700,$0800,$0900,$0A00,$0B00,$0C00,$0D00,$0E00,$0F00	;15
	dc.w	$1000,$1100,$1200,$1300,$1400,$1500,$1600,$1700,$1800,$1900,$1A00,$1B00,$1C00,$1D00,$1E00	;30
	; LETTERS UPPER
	dc.w	$1F00,$2000,$2100,$2200,$2300,$2400,$2500,$2600,$2700	
	dc.w	$0001,$0101,$0201,$0301,$0401,$0501,$0601,$0701,$0801,$0901,$0A01,$0B01,$0C01,$0D01,$0E01,$0F01	
	dc.w	$1001
	; WEIRD SHIT
	dc.w	$1101,$1201,$1301,$1401,$1501,$1601
	; LETTERS LOWER
	dc.w	$1701,$1801,$1901,$1A01,$1B01,$1C01,$1D01,$1E01	
	dc.w	$1F01,$2001,$2101,$2201,$2301,$2401,$2501,$2601,$2701

	dc.w	$0002,$0102,$0202,$0302,$0402,$0502,$0602,$0702,$0802
	dc.w $0000
	;------------------------------------------------------------------------------
	;		INTRO FONT ( 8 x 16 ) UPPERCASE - 89-119
	;------------------------------------------------------------------------------

	dc.w	$0003,$0103,$0203,$0303,$0403,$0503,$0603,$0703,$0803,$0903,$0A03,$0B03,$0C03,$0D03,$0E03,$0F03	;15
	dc.w	$1003,$1103,$1203,$1303,$1403,$1503,$1603,$1703,$1803,$1903,$1A03,$1B03
	
	;------------------------------------------------------------------------------
	;		INTRO FONT ( 8 x 16 ) LOWERCASE, PUNCT, NUMBERS. - 119-164 (Punct 45 >
	;------------------------------------------------------------------------------

	dc.w	$1C03,$1D03,$1E03,$1F03,$2003,$2103,$2203,$2303,$2403,$2503,$2603,$2703	
	dc.w	$0005,$0105,$0205,$0305,$0405,$0505,$0605,$0705,$0805,$0905,$0A05,$0B05,$0C05,$0D05
	; PUNCTUATION
	dc.w	$0E05,$0F05,$1005,$1105,$1205,$1305,$1405,$1505,$1605,$1705
	; NUMBERS
	dc.w	$1805,$1905,$1A05,$1B05,$1C05,$1D05,$1E05,$1F05,$2005,$2105
	
	;------------------------------------------------------------------------------
	;		INTRO FONT - LARGE LETTERS - 164-189 (190 = Copyright Symbol)
	;------------------------------------------------------------------------------
	
	dc.w	$2805,$2A05,$2C05
	dc.w	$0007,$0207,$0407,$0607,$0807,$0A07,$0B07,$0C07,$0D07,$0E07
	dc.w	$0F07,$1007,$1107,$1207,$1307,$1407,$1507,$1607,$1707,$1807
	dc.w	$0009,$0209,$0409
		
;-----------------------------------------------------------------------------------------------------------
;	TITLE SCREEN STRINGS
;-----------------------------------------------------------------------------------------------------------

;	 KEY - LOOP LENGTH, "STRING", ZERO TERMINATE (NYYYAAARGGH!!!)

;------------------------------------------------------
;	MAIN TITLE SCREEN
;------------------------------------------------------

TEXT_ENHANCED: 			dc.b 14,"E N H A N C E D",0			
TEXT_PUSH1P_START: 		dc.b 12,"PUSH 1P START",0			
TEXT_PUSH1P_STARTC: 	dc.b 12,"             ",0			
TEXT_PUSH1P2P_START: 	dc.b 12,"PUSH 1P OR 2P START",0			
TEXT_CAPCOM: 			dc.b 19,"#1989 CAPCOM CO.LTD.",0		
TEXT_CREATIVE: 			dc.b 23,"#1991 CREATIVE MATERIALS",0			
TEXT_PROTOTRON: 		dc.b 13,"2021 PROTOTRON",0			

;------------------------------------------------------
;	CREDITS
;------------------------------------------------------

TEXT_FFTM: 				dc.b 38,"Final Fight(TM) (C)1989 CAPCOM USA Inc.",0				
TEXT_ALLRIGHTS: 		dc.b 19,"All rights reserved.",0				
TEXT_PROTOCREDITS: 		dc.b 33,"Programming and music by Prototron",0				
TEXT_TITLEMUSIC: 		dc.b 26,"Title music by Jolyon Myers",0			
TEXT_BGGCREDITS: 		dc.b 27,"Background graphics by Ralph",0		
TEXT_BGGCREDITS2: 		dc.b 26,"for Creative Materials Ltd.",0	
TEXT_CONTROLS: 			dc.b 8,"Controls:",0	
TEXT_CONTROLSA: 		dc.b 8,"A: Attack",0	
TEXT_CONTROLSJ: 		dc.b 6,"B: Jump",0	
TEXT_CONTROLSS: 		dc.b 21,"A plus B: Special Move",0	
TEXT_1MB: 				dc.b 39,"1MB ram and 68020 CPU required (for now)",0	
	EVEN
	
;-----------------------------------------------------------------------------------------------------------
;	TITLE SCREEN ASSETS
;-----------------------------------------------------------------------------------------------------------

;------------------------------------------------------
; 	GRAPHICS
;------------------------------------------------------

TS_LOGO:
	INCBIN "GRAPHICS\TS_TITLESCREEN\TITLE_LOGO.RAW"
TS_LOGO_END:	
	EVEN	
	
TS_CHARS:	
	INCBIN "GRAPHICS\TS_TITLESCREEN\TITLE_CHARS.RAW"
TS_CHARS_END:
	EVEN
	
;------------------------------------------------------
; 	TITLE SCREEN MUSIC
;------------------------------------------------------
	
MUS_TITLE:
	incbin "SOUND\P61.lost-in-time_B904"
	EVEN
	
;------------------------------------------------------------------------------------------------------------
;		BSS
;------------------------------------------------------------------------------------------------------------

	SECTION TS_BSS,BSS_C
	;-------------------
	
;-------------------------------------------
	
TITLE_SCREEN:
	ds.b	TSCR_BPLSIZE*TSCR_DEPTH			; No double buffering
TITLE_SCREEN_END:

;-------------------------------------------