;-----------------------------------------------------------------------------------------------------------
;	MAIN GAME
;-----------------------------------------------------------------------------------------------------------

	SECTION code,CODE
	;----------------

STARTGAME:	

	;-----------------------------------	
	;	TEXT DEBUGGER 
	;	- This doesn't work any more
	; 	but it's not used much anyway.
	;-----------------------------------

	bclr 	#7,HUDFLAGS					; HIDE TEXT DEBUGGER (SHOW GAME HUD)
;	bset 	#7,HUDFLAGS					; SHOW TEST DEBUGGER

	;-----------------------------------
	; PRE-FLIP SLICE SHEETS & MASKS
	;-----------------------------------	

	bsr.w 	FLIP_SLICESHEETS			; Flip all slice sheets used in Level

	;-----------------------------------
	; MAIN INIT
	;-----------------------------------	
	
	bsr.w 	INIT_MAIN					; System Setup (MAIN GAME)
	
	;-----------------------------------	
	; DRAW HUD STUFF & 
	; LOAD LEVEL ADDRESSES/PLAYER POS
	;----------------------------------
	
	bsr.w 	HUD_ELEMENTS				; DRAW HUD STUFF (Icon, Healthbar, Name etc.)
	bsr.w 	CREATE_EVENT
	
	;-----------------------------------
	; BLIT INITIAL SCREEN
	;-----------------------------------	
	
	bsr.w 	ROW_BLIT					; Initial Background construct (BUFFER 1)
	movem.l DOUBLE_BUFFER,a0-a1						
	exg 	a0,a1						; Swap Buffer Pointer	
	movem.l a0-a1,DOUBLE_BUFFER
	bsr.w 	ROW_BLIT					; Initial Background construct (BUFFER 2)

	;-----------------------------------	
	; START MUSIC
	;-----------------------------------	
	
	lea 	MUS_L1,a0
	sub.l 	a1,a1
	sub.l 	a2,a2
	moveq 	#0,d0
	movem.l d0-a6,-(sp)		
	bsr 	P61_Init
	movem.l (sp)+,d0-a6	
	
	;-----------------------------------	
	
	bset 	#6,HUDFLAGS2				; Fade In activate
	
	;-----------------------------------	
	
;------------------------------------------------------------------------------------------------------------
;		MAIN LOOP
;------------------------------------------------------------------------------------------------------------
		
MAIN_LOOP:

	;-----------------------------------
	bsr.w 	CLEAN_SCREEN				; Clean dirty tiles on current buffer
	bsr.w	HW_SPRITES					; Train Background lights
	;-----------------------------------
	bsr.w 	SPAWNER_L2_2
	bsr.w	P1_CONTROLS					; Plot new Player co-ordinates
	bsr.w	ENEMY_AI					; Plot new Enemy co-ordinates
	bsr.w 	HUD_CONTROL					; Just what it says
	bsr.w	FX_HANDLER					; Hitsparks & Dust
	bsr.w 	DRAW_ROUTINE				; Draw gamne objects at new co-ordinates on cleaned buffer
	;-----------------------------------
	bsr.w 	CHECKSCROLL_R				; Scroll RIGHT
	bsr.w 	SWITCH_SCREENBUFFERS		; Update Pointers + switch Screen Buffers & Tile Tables
	;bsr.w 	CHECK_RASTERTIME			
	bsr.w	GAMEOVER_DISPLAY			; If deadbit is set, then game over
	;-----------------------------------
	bsr.w	VBLANK						; Wait for end of frame
	;-----------------------------------
	bra.w	MAIN_LOOP
	;-----------------------------------

EXIT:

;-----------------------------------------------------------------------------------------------------------	
;	INCLUDE FILES / SUBROUTINES
;-----------------------------------------------------------------------------------------------------------

	
	; --------------------------------------
		
	include 	"Include/create_event.asm"
	include 	"Include/hud_elements.asm"
	include 	"Include/hud_control.asm"
	include 	"Include/cpu_text_drawer.asm"
	include 	"Include/background_tile_draw.asm"
	include 	"Include/hud_tile_draw.asm"
	include 	"Include/background_tile_draw_rows.asm"
	include 	"Include/background_tile_draw_columns.asm"
	include 	"Include/background_tile_replacer.asm"
	include 	"Include/debugger.asm"
	include 	"Include/scrollchecks.asm"
	include 	"Include/init.asm"
	include 	"Include/x_flip.asm"
	include 	"Include/x_flip_flip_slicesheets.asm"
	include 	"Include/tbl_slice_sheets.asm"
	include 	"Include/get_frame_offset.asm"
	include 	"Include/blit_sprites.asm"
	include 	"Include/blit_tiles.asm"
	include		"Include/p1controls.asm"
	include		"Include/sound_effects.asm"
	include		"Include/hw_sprite.asm"
	include		"Include/fx_animate.asm"
	; --------------------------------------
	
	include		"Include/spawner_L2_2.asm"
	include		"Include/enemy_ai.asm"

	; --------------------------------------
	
	include		"Include/mg_subs.asm"
	include		"Include/inc_subs_shared.asm"
	
	; -------------------------------------
usecode		= $1900	
channels 	= 3

	include 	"Include/mus_player_constants.asm"
	; --------------------------------------

Playrtn:

;--------------------------------------
;	 VOLUME MIXER
;--------------------------------------

P61_Master:		; Master Volume 
	dc.w 62
P61_Ch1Vol:		; Leads
	dc.w 54
P61_Ch2Vol:		; Drums
	dc.w 42
P61_Ch3Vol:		; Bass
	dc.w 38	
P61_Ch4Vol:		; SFX
	dc.w 64

	include 	"Include/P6112-Play.i"
	
;--------------------------------------

;------------------------------------------------------------------------------------------------------------
;		DATA (COPPER, TABLES, GRAPHICS)
;-----------------------------------------------------------------------------------------------------------	

GFXNAME:	dc.b "graphics.library",0
	EVEN
	
	SECTION DATA,DATA_C
	
; ----- COPPERS ---------------------------------------------------------------------------------------------	

COPPER_MAINGAME:

; --------------------------------------
;	DISPLAY/DATA START & STOP
; --------------------------------------

	dc.w $1fc,0	
	dc.w $08E,$2c81						; Display Screen Top Left  		(VVHH)
	dc.w $090,$1cc1 					; Display Screen Botom Right 	(VVHH)
	dc.w $092,$30						; Display Bitplane Fetch Start 	(XXHH)
	dc.w $094,$d0						; Display Bitplane Fetch Stop	(XXHH)
			
; --------------------------------------
;	BITPLANE POINTERS (HUD)
; --------------------------------------

CoBplPr_HUD:
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
;	BITPLANE CONTROL (HUD)
; --------------------------------------

BITPLANE_CONTROL_HUD:
	dc.w $100,%0101001000000001			; BPLCON0
	dc.w $102,%0000000000000000			; BPLCON1
	dc.w $106,%0000000000100000			; BPLCON3 - Enable ECS Border Blanking	
	dc.w $108,HSCR_MODULO-2				; Bitplane Modulo PSCR_BPL*3 (odd planes) 
	dc.w $10A,HSCR_MODULO-2				; Bitplane Modulo PSCR_BPL*3 (even planes)	
	
; --------------------------------------
;	SPRITE POINTERS (HUD)
; --------------------------------------

SprPtr_HUD:
	dc.w $120,0		; HW Sprite 0
	dc.w $122,0	
	dc.w $124,0		; HW Sprite 1
	dc.w $126,0					
	dc.w $128,0		; HW Sprite 2				
	dc.w $12a,0							
	dc.w $12c,0		; HW Sprite 3				
	dc.w $12e,0		
	dc.w $130,0		; HW Sprite 4		
	dc.w $132,0					
	dc.w $134,0		; HW Sprite 5
	dc.w $136,0						
	dc.w $138,0		; HW Sprite 6					
	dc.w $13a,0							
	dc.w $13c,0		; HW Sprite 7	(Disabled)	
	dc.w $13e,0	

; --------------------------------------
;	PALETTE (HUD)
; --------------------------------------	

PALETTE_HUD:
	dc.w $180,0				; Colour 0
	dc.w $182,0				; Colour 1
	dc.w $184,0				; Colour 2
	dc.w $186,0				; Colour 3
	dc.w $188,0				; Colour 4
	dc.w $18a,0				; Colour 5
	dc.w $18c,0				; Colour 6
	dc.w $18e,0				; Colour 7
	dc.w $190,0				; Colour 8
	dc.w $192,0				; Colour 9
	dc.w $194,0				; Colour 10
	dc.w $196,0				; Colour 11
	dc.w $198,0				; Colour 12
	dc.w $19a,0				; Colour 13
	dc.w $19c,0				; Colour 14
	dc.w $19e,0				; Colour 15
	dc.w $1a0,0				; Colour 16
	dc.w $1a2,0				; Colour 17
	dc.w $1a4,0				; Colour 18
	dc.w $1a6,0				; Colour 19
	dc.w $1a8,0				; Colour 20
	dc.w $1aa,0				; Colour 21
	dc.w $1ac,0				; Colour 22
	dc.w $1ae,0				; Colour 23
	dc.w $1b0,0				; Colour 24
	dc.w $1b2,0				; Colour 25
	dc.w $1b4,0				; Colour 26
	dc.w $1b6,0				; Colour 27
	dc.w $1b8,0				; Colour 28
	dc.w $1ba,0				; Colour 29
	dc.w $1bc,0				; Colour 30
	dc.w $1be,0				; Colour 31
			
; --------------------------------------
;	SCREEN SPLIT
; --------------------------------------

	dc.w $4C01,$ff00					; Trying to hide the scdroll shift.
	
COPPER_SCROLL_SHIFT:	
	dc.w $102,$ff						; BPLCON1 -  Horizontal Scroll Register

;	dc.w $108,SCR_MODULO-2				; Bitplane Modulo SCR_BPL*4 (odd planes) 
;	dc.w $10A,SCR_MODULO-2				; Bitplane Modulo SCR_BPL*4 (even planes)

	dc.w $4D01,$ff00					; WAIT and then Split screen into HUD SCREEN and MAIN SCREEN
	
; --------------------------------------
;	MAIN SCREEN
; --------------------------------------

COPPER_MAINSCREEN:						

; --------------------------------------
;	BITPLANE POINTERS (HUD)
; --------------------------------------

CoBplPr_MAIN:
	dc.w $0e0,0							; Bitplane Pointer 1 (High 5 Bits) (ECS)
	dc.w $0e2,0							; Bitplane Pointer 1 (Low 15 Bits)	
	dc.w $0e4,0							; Bitplane Pointer 2 (High 5 Bits)
	dc.w $0e6,0							; Bitplane Pointer 2 (Low 15 Bits)
	dc.w $0e8,0							; Bitplane Pointer 3 (High 5 Bits)
	dc.w $0ea,0							; Bitplane Pointer 3 (Low 15 Bits)
	dc.w $0ec,0							; Bitplane Pointer 4 (High 5 Bits)
	dc.w $0ee,0							; Bitplane Pointer 4 (Low 15 Bits)
	
; --------------------------------------
;	BITPLANE CONTROL (MAIN)
; --------------------------------------

	dc.w $100,%0100001000000001			; BPLCON0

	dc.w $104,%0000000000000001			; BPLCON2
	
; --------------------------------------
;	PALETTE (MAIN)
; --------------------------------------

PALETTE_MAIN:
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
	
	dc.w $1a0,$000						; Colour 16		; HARDWARE SPRITE 1 PALETTE
	dc.w $1a2,$008						; Colour 17
	dc.w $1a4,$08A						; Colour 18
	dc.w $1a6,$88F						; Colour 19
	
	dc.w $1a8,$000						; Colour 20		; HARDWARE SPRITE 2 PALETTE
	dc.w $1aa,$000						; Colour 21
	dc.w $1ac,$000						; Colour 22
	dc.w $1ae,$000						; Colour 23
	
	dc.w $1b0,$888						; Colour 24
	dc.w $1b2,$888						; Colour 25
	dc.w $1b4,$888						; Colour 26
	dc.w $1b6,$888						; Colour 27
	dc.w $1b8,$888						; Colour 28
	dc.w $1ba,$888						; Colour 29
	dc.w $1bc,$888						; Colour 30
	dc.w $1be,$888						; Colour 21
	
; --------------------------------------
;	COPPER MAIN GAME END
; --------------------------------------
	
	dc.w $ffff,$fffe		; COPPER END
	
;------------------------------------------------------------------------------------------------------------
;		FLAGS  (WIP)
;------------------------------------------------------------------------------------------------------------
	
	
EFLAGS:   dc.b %00000000
; ---------------------------------
; EFLAGS: 	BIT - ACTION
; ---------------------------------
; 00 - ALLSTOP
; 01 - 
; 02 - 
; 03 -
; 04 - 
; 05 - 
; 06 -
; 07 - 

SCROLLFLAGS:   		dc.b %01000000
; ---------------------------------
; 	SCROLLFLAGS: 	BIT - ACTION
; ---------------------------------
; 0 - SCROLLLEFT/SCROLLRIGHT		0/1
; 1 - XVIEW MAP SET L				0/1
; 2 - XVIEW MAP SET R				0/1
; 3 - COLUMN BLIT LOOP				0/1
; 4 - TILECLEAN PREV PASTE			0/1
; 5 - TILECLEAN PREV PASTE LOOP		0/1
; 6 - SCREEN SHAKE					0/1
; 7 - SCREEN SHAKE SWAP  			0/1

SCROLLFLAGS2:   	dc.b %00000000

; ---------------------------------
; 	SCROLLFLAGS2: 	BIT - ACTION
; ---------------------------------
; 0 - SCROLL DEACTIVATE				0/1
; 1 - HW SPRITES OFF/ON				0/1
; 2 - 								0/1
; 3 -								0/1
; 4 - 								0/1
; 5 - 								0/1
; 6 - 								0/1
; 7 -  								0/1

SCREENSHAKE_VAR:	dc.b 0
SCREENSHAKE_T:		dc.b 6				;_T = TIMER
HUDFLAGS:   		dc.b %10000000
HUDFLAGS2:   		dc.b %00000000
	EVEN

HUDTIMERS: 			; First BYTE = Energy Bar clear | Second BYTE = 2P START Flash
	dc.w $0030
	
; BIT - ACTION
; ---------------------------------
; 00 - ICON/SMALLTEXT			0/1
; 01 - HUDSCREEN/MAINSCREEN		0/1
; 02 - MAINSCREEN/BACKBUFFER	0/1
; 03 - 16/8 CPU text drawer		0/1
; 04 - TEXT SHEET SELECT		0/1 ( 0 = INTRO | 1 = IN GAME HUD )
; 05 - HUDCONTROL1				0/1
; 06 - HUDCONTROL2				0/1
; 07 - HUD/DEBUGGER				0/1

; 08 - DRAW/ERASE				0/1
; 09 - STRING/VARIABLE			0/1
; 10 - TEXT FLASH				0/1
; 11 - TYPEWRITER TEXT			0/1
; 12 - KILL HUD CONTROL			0/1 
; 13 - GAME OVER TEXT			0/1
; 14 - FADE IN					0/1
; 15 - FADE OUT					0/1


TEXT_TIMER:	dc.w $FFFF

TCFLAG: 	dc.b 0
 EVEN

;------------------------------------------------------------------------------------------------------------
;		TABLES, VARIABLES, AND MAPS
;-----------------------------------------------------------------------------------------------------------


; ------------------------------------------------
; 	LEVEL NUMBER | LEVEL WIDTH (IN BYTES)
; ------------------------------------------------

LEVEL:	dc.b $05,$00
	EVEN
	
; ------------------------------------------------
; 	VALUE MEANING
; ------------------------------------------------
; 01 - 1-1
; 02 - 1-2
; 03 - 1-3
; 04 - 2-1
; 05 - 2-2	
; 06 - 2-3
; 07 - 2-4
; 08 - 3-1
; 09 - 3-2
; 0A - 3-3
; 0B - 3-4
; ------------------------------------------------

CREATE_EVENT_ADDRESSES:
	dc.l	0,0,0,0	
;	EVEN
	
; 1	MAP
; 2	TILESHEET X/Y
; 3	TILESHEET BITMAP
; 4	LEVEL WIDTH
	
XVIEW:				dc.w $0020,$0002,$0017,2,0		
YVIEW:				dc.w $10	
GRABXY_STORE:		dc.w 0 0
GRABXY_STORE_MASK:	dc.w 0 0
	
SPAWN:				dc.b 0
SPAWNT:				dc.b 0
FADE:				dc.b 0,0	; Count | Delay

;--------------------------------------------
;	LIST BUFFERS
;--------------------------------------------

LEVELMAP_BUFFER:
	dc.b 0
	EVEN
	
DOUBLE_BUFFER:
	dc.l 0,0
DOUBLE_BUFFERE
	
CPU_TEXT_DRAWL:
	dc.l 0,0,0,0			; SOURCE | DEST | FONT TABLE | OFFSETS TABLE
CPU_TEXT_DRAWL_END
	

; ------------------------------------------------	
; XVIEW
; ------------------------------------------------
; 00 XVIEW_LEFT 			( PIXELS )
; 02 XVIEW_LEFT 			( WORDS )
; 04 XVIEW RIGHT			( WORDS )
; 06 SCREEN RESET			( 
; 08 TOTAL COUNT
; 10 CLIP DIFFERENCE
; ------------------------------------------------


; ----------------------------------------------------------------------------------------------------------
;	OBJECT TABLES - Maximum 16 Objects 
; ----------------------------------------------------------------------------------------------------------

; ------------------------------------------------	
; 	- Objects include - Players, Enemies, Breakables, Items, Weapons
; 	- Any object can be any type, but OBJECT_1 = Player 1 & OBJECT_2 = Player 2
; ------------------------------------------------	

; PLAYER_OBJECTS
OBJECT_1:		dc.w $0103,$7800,$00E3,$0000,$0100,$0100,$0000,$0000,$0000,$0000,$0100,$0064

OBJECT_2:		dc.w $0205,$7802,$15BC,$0000,$0300,$0000,$0000,$0001,$0000,$0000,$0000,$0064
	
; ENEMY OBJECTS
OBJECT_3:		dc.w $0305,$3200,$14BC,$0800,$0100,$0000,$0000,$0000,$0206,$0000,$0000

OBJECT_4:		dc.w $0405,$3200,$17BC,$0800,$0100,$0000,$0000,$0000,$0206,$0000,$0000
	
OBJECT_5:		dc.w $0504,$3200,$1BBC,$0000,$0100,$0000,$0000,$0000,$0206,$0000,$0000
	
OBJECT_6:		dc.w $0604,$7800,$29BC,$0000,$0100,$0000,$0000,$0000,$0206,$0000,$0000
	
OBJECT_7:		dc.w $0704,$7800,$F0BC,$0000,$0300,$0000,$0000,$0000,$0206,$0000,$0000
		
OBJECT_8:		dc.w $0804,$7800,$B0B0,$0000,$0300,$0000,$0000,$0000,$0206,$0000,$0000
		
OBJECT_9:		dc.w $0904,$7800,$D0D0,$0000,$0300,$0000,$0000,$0000,$0206,$0000,$0000
	
OBJECT_10:		dc.w $0A04,$7800,$BEBE,$0000,$0300,$0000,$0000,$0000,$0206,$0000,$0000
		
OBJECT_11:		dc.w $0B04,$7800,$D0D0,$0000,$0300,$0000,$0000,$0000,$0206,$0000,$0000
	
OBJECT_12:		dc.w $0C1A,$7800,$BEBE,$0000,$0300,$0000,$0000,$0000,$0206,$0000,$0000
		
; FX OBJECTS	
OBJECT_13:		dc.w $0D16,$7800,$0000,$0000,$0000,$0000,$0400,$0000,$0000,$0000,$0100
		
OBJECT_14:		dc.w $0E16,$7800,$0000,$0000,$0000,$0000,$0400,$0000,$0000,$0000,$0100
		
OBJECT_15:		dc.w $0F16,$7800,$0000,$0000,$0000,$0000,$0400,$0000,$0000,$0000,$0100
		
OBJECT_16:		dc.w $101A,$7800,$0EF0,$0000,$0000,$0000,$7F7F,$0018,$0000,$0000,$0100
	

; ------------------------------------------------
;	OBJECT TABLE VALUES
; ------------------------------------------------

; 00 - OBJECT NUMBER /TYPE
; 02 - ENERGY / LIVES
; 04 - X / Y
; 06 - S / STOPFLAGS: %XXXXDULR 	; S = Shift
; 08 - STATE / FRAME NUMBER
; 10 - COMBO# / GRAB#
; 12 - TIMER1 / TIMER2
; 14 - JUMPHEIGHT / Z-POS
; 16 - WALKSPEED/ANIMSPEED
; 18 - ATTACKDISTANCE 				; 16 Bit - $0000
; 20 - FLAGS/ FLAGS2				; FLAGS $FFFF | FLASG2 $FFFF
; 22 - HITCOUNT / HITCOUNT_RESET

; ------------------------------------------------
; 	PLAYER STATES
; ------------------------------------------------
; 00 - Do nothing until told otherwise
; 01 - Computer Controlled (walk Left or right off screen maybe)
; 02 - Stance
; 03 - Walk
; 04 - Attack (Combo)
; 05 - Special move
; 06 - Grab
; 07 - Jump / Flying Kick
; 08 - Hitpause
; 09 - Hit
; 10 - Fall
; 11 - Ground
; 12 - Kneel
; ------------------------------------------------
; 	ENEMY STATES
; ------------------------------------------------
; 00 - Dummy/Still	- Stay still until player is close and then start AI
; 01 - 
; 02 - WaitT		- Randomly wait until a timer runs out (Stops clumping)
; 03 - Walk			- Walk towards nearest player
; 04 - Chase		- Lock on to target player (Using OBJECT_NUMBER) and chase them, no matter what
; 05 - Back Off		- Randomly Back off (Stops clumping)
; 06 - Other Side	- Move around to other side of target (Stops clumping)
; 07 - Attack 		- Attack when in range
; 08 - Hit			- Displays HIGH HIT or LOW HIT frame along with code for shaking
; 09 - Grab			- States for when grabbed by player
; 10 - Fall			- Uses Z-Axis and fall frame
; 11 - Ground		- Contains code for Bouncing when hitting the ground, then a timer to go to KNEEL
; 12 - Kneel		- Displays Kneel frame until time runs out, then returns to WALK state
; 13 - Die

; ------------------------------------------------
; FLAGS: BIT - ACTION (PLAYER)
; ------------------------------------------------

; ------------------
; FLAGS 1
; ------------------
XFLIP_LR 		= 0
CONTROLS_LOCK 	= 1
HITBIT 			= 2
BUTTONRELEASE	= 3
JUMPDIR 		= 4
JUMPDIR2 		= 5
JUMPKICK 		= 6
BOUNCE 			= 7

; 0 - XFLIP L/R			0/1
; 1 - CONTROLS LOCK		0/1
; 2 - HIT BIT			0/1	= Tells if contact has been made, and changes COmbo code on return to stance
; 3 - BUTTONRELEASE		0/1 = Button must be released to trigger again
; 4 - JUMPDIR			0/1 ( 0 = UP ) 
; 5 - JUMPDIR2			0/1	( 0 = LEFT | 1 = RIGHT )
; 6 - JUMP/FKICK		0/1
; 7 - BOUNCE			0/1

; ------------------
; FLAGS 2
; ------------------
COLSKIP			= 0
FALLKILL		= 1
HITPAUSE		= 2
;				= 3
;				= 4
;				= 5
ALLSTOP			= 6
DIE				= 7
; 0- COLSKIP			0/1 - Outside Collision Margins

; ------------------------------------------------
; FLAGS: BIT - ACTION (ENEMY)
; ------------------------------------------------
; 0 - XFLIP L/R			0/1
; 1 - HIT SHUDDER		0/1
; 2 - HIT/FALL			0/1
; 3 - HITKILL			0/1	- Stops multiple hits onh same collision
; 4 - 
; 5 - JUMPDIR2			0/1	( 0 = LEFT | 1 = RIGHT )
; 6 - DIE		(Maybe)
; 7 - BOUNCE			0/1

; ------------------------------------------------
; 00 - OBJECT NUMBER /TYPE
; 02 - X / X-PREV
; 04 - Y / Y-PREV
; 06 - S / S-PREV
; 08 - FWIDTH & FHEIGHT (Whole frame, not individual slices)	
; 10 - FWIDTH & FHEIGHT PREV
; 12 - STATE / FRAME NUMBER
; 14 - STATEPREV / FRAMEPREV NUMBER
; 16 - COMBO# / GRAB#
; 18 - TIMER / P1FLAGS
; 20 - JUMPHEIGHT / Z-POS 
; ------------------------------------------------

; ------------------------------------------------
;	GAME OBJECTS
; ------------------------------------------------

; ------------------------------------------------	
OBJECT_SLOTS:		dc.b 1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,-1
	
; ------------------------------------------------	
OBJECT_IDOFFSET:	dc.b 0

; ------------------------------------------------	
OBJECT_SLOTCNTR: 	dc.b 0
	
; ------------------------------------------------	
OBJECT_NUMBER_OF: 	dc.b 0						; Total Number of objects in game

; ------------------------------------------------
OBJECT_PLAYERS: 	dc.b 1						; Total Number of PLAYERS in game
	
; ------------------------------------------------
OBJECT_ENEMIES: 	dc.b 1						; Total Number of ENEMIES in game

; ------------------------------------------------
OBJECT_ITEMS: 		dc.b 0						; Total Number of ITEMS in game (Weapons/Food/Breakables)
	EVEN

; ------------------------------------------------	
; Slots for what object to draw First or Last. Depth is based on Y
					
					;$IDYY - First Byte is Object's ID Number, second is its Y-Coordinate
OBJECT_IDY:		dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
				dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
				dc.w -1

; ------------------------------------------------
OBJECT_ID: 		dc.b 0						; Store for Id # of object

; ------------------------------------------------
	
COMBOCOMP: 		dc.b 0
COMBORESTV 		= 100
COMBO_RESET:	dc.b	COMBORESTV
	EVEN

FX_XY:	dc.w	0
FX_S:	dc.b	0
FX_Z:	dc.b	0
	EVEN
	
; ------------------------------------------------

TILETABLE:		dc.w $0000,$0000,$0000,$0000,$FFFE,$002A,$0002	
MAPBLIT_Y:		dc.b 0,0 ; BLIT Y | COUNT 	
	EVEN
	
; ------------------------------------------------
; 00 - X
; 02 - Y
; 04 - WIDTH/HEIGHT
; 06 - # of tile in map row/
; 08 - Map LEFT offset
; 10 - Map RIGHT offset
; 12 - Row Count
; 14 - Tile Replace offset /
; ------------------------------------------------

;----------------------------------------------------------------------------------------------------------
; TILE CLEANER TABLES (One for each Screen Buffer)
;----------------------------------------------------------------------------------------------------------

TILECLEANER_TABLE1:			; Table 1
	REPT TILETABLE_NO
		dc.w -1
	ENDR

	
TILECLEANER_TABLE2:			; Table 2
	REPT TILETABLE_NO
		dc.w -1
	ENDR		
	
TILECLEANER_TABLES:		dc.l 0,0		; List for addresses		
TILE_COMPARE: 			dc.w 0	
TEMPTILE				dc.w 0

TILECLEAN_OFFSET1:		dc.w	$0000	
TILECLEAN_OFFSET2:		dc.w	$0000
TILECLEAN_OFFSETS:		dc.l	0,0

TILECHECK: 				dc.b 0
	EVEN
;----------------------------------------------------------------------------------------------------------
; 	X-FLIP ADDRESS LIST
;----------------------------------------------------------------------------------------------------------	

XFLIP:		dc.l 0,0,0,0,0

;----------------------------------------------------------------------------------------------------------
; 	TABLES
;----------------------------------------------------------------------------------------------------------

;-------------------------------------------------------
; 	HUD ENERGYBAR TABLES
;-------------------------------------------------------

ENERGY_120: dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4A80,$4F90
ENERGY_116:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4A80,$5090
ENERGY_112:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4A80,$5190 	;  END FULLY RED

ENERGY_108:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4B80,$5190
ENERGY_104:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4C80,$5190
ENERGY_100:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4D80,$5190
ENERGY_96:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4A70,$4E80,$5190 	; BLOCK FULLY RED

ENERGY_92:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4B70,$4E80,$5190
ENERGY_88:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4C70,$4E80,$5190
ENERGY_84:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4D70,$4E80,$5190
ENERGY_80:	dc.w $4A20,$4A30,$4A40,$4A50,$4A60,$4C70,$4E80,$5190	; BLOCK FULLY RED

ENERGY_76:	dc.w $4A20,$4A30,$4A40,$4A50,$4B60,$4E70,$4E80,$5190	
ENERGY_72:	dc.w $4A20,$4A30,$4A40,$4A50,$4C60,$4E70,$4E80,$5190
ENERGY_68:	dc.w $4A20,$4A30,$4A40,$4A50,$4D60,$4E70,$4E80,$5190
ENERGY_64:	dc.w $4A20,$4A30,$4A40,$4A50,$4E60,$4E70,$4E80,$5190	; BLOCK FULLY RED

ENERGY_60:	dc.w $4A20,$4A30,$4A40,$4B50,$4E60,$4E70,$4E80,$5190
ENERGY_56:	dc.w $4A20,$4A30,$4A40,$4C50,$4E60,$4E70,$4E80,$5190	
ENERGY_52:	dc.w $4A20,$4A30,$4A40,$4D50,$4E60,$4E70,$4E80,$5190
ENERGY_48:	dc.w $4A20,$4A30,$4A40,$4E50,$4E60,$4E70,$4E80,$5190	; BLOCK FULLY RED

ENERGY_44:	dc.w $4A20,$4A30,$4B40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_40:	dc.w $4A20,$4A30,$4C40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_36:	dc.w $4A20,$4A30,$4D40,$4E50,$4E60,$4E70,$4E80,$5190	
ENERGY_32:	dc.w $4A20,$4A30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190	; BLOCK FULLY RED

ENERGY_28:	dc.w $4A20,$4B30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_24:	dc.w $4A20,$4C30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_20:	dc.w $4A20,$4D30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_16:	dc.w $4A20,$4E30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190	; BLOCK FULLY RED

ENERGY_12:	dc.w $4B20,$4E30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_8:	dc.w $4C20,$4E30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_4:	dc.w $4D20,$4E30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190
ENERGY_0:	dc.w $4E20,$4E30,$4E40,$4E50,$4E60,$4E70,$4E80,$5190	; BLOCK FULLY RED

;------------------------------------------------------
; 	HUD	PALETTE (Static)
;------------------------------------------------------

PalHUD:
	dc.w $0000,$0000,$0e90,$0fb0,$0fd0,$0a40,$0f60,$0c60 	
	dc.w $0eee,$0b20,$08ac,$0964,$0600,$0ea7,$0eca,$0b75 	
	dc.w $0d86,$0753,$0c86,$0eb8,$0754,$0b40,$0730,$0753 	
	dc.w $0753,$0643,$0643,$0456,$0532,$0520,$0430,$0005
PallHUD_END:	
	
;------------------------------------------------------
;	 GAME PALETTE & FADES
;------------------------------------------------------
	
PalGame:
	dc.w $0000,$0111,$0620,$0864,$0A86,$0057,$00AC,$09EF	; <-- MAIN PALETTE
	dc.w $0A40,$0E60,$0EA0,$0080,$00C0,$0ECA,$0AAA,$0EEE		
PalGame1:
	dc.w $0000,$0111,$0520,$0753,$0975,$0046,$009B,$09CD	
	dc.w $0930,$0C50,$0C90,$0070,$00A0,$0CA9,$0999,$0DDD
PalGame2:
	dc.w $0000,$0111,$0410,$0643,$0764,$0045,$0079,$06AB	
	dc.w $0730,$0A40,$0A70,$0060,$0090,$0A97,$0777,$0BBB	
PalGame3:
	dc.w $0000,$0111,$0310,$0532,$0653,$0034,$0067,$0589	
	dc.w $0620,$0830,$0860,$0050,$0070,$0876,$0555,$0999	
PalGame4:
	dc.w $0000,$0111,$0310,$0332,$0433,$0023,$0046,$0466	
	dc.w $0420,$0630,$0640,$0040,$0050,$0654,$0333,$0666	
PalGame5:
	dc.w $0000,$0110,$0210,$0221,$0322,$0012,$0034,$0344	
	dc.w $0310,$0420,$0430,$0030,$0030,$0433,$0222,$0444	
PalGame6:
	dc.w $0000,$0100,$0100,$0111,$0111,$0011,$0012,$0122	
	dc.w $0200,$0210,$0210,$0010,$0020,$0221,$0111,$0222	
PalGame7:
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; <-- BLACK PALETTE
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		
SCROLLTABLE: 	dc.w $2,$0

;---------------------------------------------------------------------------------------------------------
;		TEXT AND FONT TABLES
;---------------------------------------------------------------------------------------------------------

TEXTFLASH_T: 	dc.b	64
	
	;------------------------------------------------------------------------------

	
;HUDCHARS_SMALLFONT:
;	dc.b	23,98,99
;	blk.b 	10
;	dc.b	100,0,0,62,63,64,65,66,67,68,69,70,71,0,0,0,101,0,0,0
;	dc.b	72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90
;	dc.b 	91,92,93,94,95,96,97
;	EVEN
;HUDCHARS_LARGEFONT:
;	dc.b	23
;	blk.b 	14
;	dc.b 	25,26,27,28,29,30,31,32,33,34,35
;	blk.b 	7
;	dc.b	36,37,38,39,40,41,42,43,44,45,46,47,48,49,60,51,52,53,54
;	dc.b	55,56,57,58,59,60,61
;	EVEN	

HUDCHARS_LARGEFONT:
	dc.b	23
	blk.b 	14
	dc.b 	24,25,26,27,28,29,30,31,32,33,34
	
	EVEN	
	
HUDCHARS_SMALLFONT:
	dc.b	82,70,71
	blk.b 	10
	dc.b	72,0,0,34,35,36,37,38,39,40,41,42,71,0,0,0,73,0,0,0
	dc.b	44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62
	dc.b 	63,64,65,66,67,68,69
	
	EVEN

HUDCHARS_SHEET_OFFSETS: ; 16H 8V
	;------------------------------------------------------------------------------
	; ICONS & BIG NUMBERS (16x16)
	;------------------------------------------------------------------------------
	; HEADS
	dc.w	$0000,$0100,$0200,$0300,$0400,$0500,$0600,$0700,$0800,$0900,$0A00,$0B00
	dc.w  	$0002,$0102,$0202,$0302,$0402,$0502,$0602,$0702,$0802,$0902,$0A02,$0B02
	; BIG NUMBERS
	dc.w 	$0004,$0104,$0204,$0304,$0404,$0504,$0604,$0704,$0804,$0904
;	dc.w 	$0006,$0106,$0206,$0306,$0406,$0506,$0606,$0706,$0806,$0906,$0a06,$0b06
;	dc.w 	$0008,$0108,$0208,$0308,$0408,$0508,$0608,$0708,$0808,$0908,$0a08,$0b08
;	dc.w 	$000A,$010A
	;------------------------------------------------------------------------------
	; WEE LETTERS  (8x8)
	;------------------------------------------------------------------------------
	dc.w	$0006,$0106,$0206,$0306,$0406,$0506,$0606,$0706,$0806,$0906
	dc.w	$0A06,$0B06,$0C06,$0D06,$0E06,$0F06,$1006,$1106,$1206,$1306
	
	dc.w	$0007,$0107,$0207,$0307,$0407,$0507,$0607,$0707,$0807,$0907
	dc.w	$0A07,$0707,$0C07,$0D07,$0E07,$0F07,$1007,$1107,$1207,$1307
	;------------------------------------------------------------------------------
	; ENERGY BARS (16x8)
	;------------------------------------------------------------------------------
	dc.w	$0A04,$0B04,$0A05,$0B05,$0A06,$0B06,$0A07,$0B07	
	dc.w	$1007

	EVEN
	
;-------------------------------------------
	
TILESHEET_TABLES:

	include "Include\background_tilesheet_offsets.asm"
	
	EVEN
	
;-------------------------------------------
	
MAP_L1_1:
	;include "Include\L1_1_MAP.asm"
	EVEN
MAP_L2_1:
	;include "Include\L2_1_MAP.asm"
	EVEN	
MAP_L2_2:
	include "Include\L2_2_MAP.asm"
	EVEN	
MAP_L3_1:
	;include "Include\L3_1_MAP.asm"
	EVEN
	
;-------------------------------------------
; ALL THESE TABLE CAN BE THE SAME LATER ON	
;-------------------------------------------

HAGGAR_FRAME_TABLE:	
	include "Include/tbl_haggar_anim.asm"
	EVEN
	
BRED_FRAME_TABLE:	
	include "Include/tbl_bred_anim.asm"
	EVEN
	
J_FRAME_TABLE:	
	include "Include/tbl_j_anim.asm"
	EVEN

FX_FRAME_TABLE:	
	include	"Include/tbl_fx_anim.asm"
	EVEN
			
;------------------------------------------------------------------------------
;	TEXT STRINGS
;------------------------------------------------------------------------------

TEXT_STRINGS:

;--------------------------------------------
;	TITLE SCREEN STRINGS
;--------------------------------------------

; KEY - LOOP LENGTH, "STRING", TERMINATE (NYYYAAARGGH!!!)

;--------------------------------------------
;	HUD
;--------------------------------------------

TEXT_COIN: 		dc.b 9,"PUSH START",0			
TEXT_COINC: 	dc.b 9,"          ",0			
TEXT_EQU: 		dc.b 0,"=",0			

;--------------------------------------------
;	PLAYERS
;--------------------------------------------

TEXT_GUY: 		dc.b 2,"GUY",0			
TEXT_CODY: 		dc.b 3,"CODY",0			
TEXT_HAGGAR: 	dc.b 5,"HAGGAR",0		

;--------------------------------------------
;	GOONS
;--------------------------------------------
	
TEXT_BRED: 		dc.b 3,"BRED",0				
TEXT_J: 		dc.b 0,"J",0			
TEXT_GORIBER: 	dc.b 7,"G.ORIBER",0			
TEXT_ROXY: 		dc.b 3,"ROXY",0				
TEXT_HWOOD: 	dc.b 9,"HOLLY WOOD",0		
TEXT_ANDORE: 	dc.b 5,"ANDORE",0		
	
;--------------------------------------------
;	BOSSES
;--------------------------------------------

TEXT_DAMND: 	dc.b 4,"DAMND",0		
TEXT_SODOM: 	dc.b 4,"SODOM",0			
TEXT_EDIE: 		dc.b 4,"EDI.E",0		
TEXT_ROLENTO: 	dc.b 6,"ROLENTO",0			
TEXT_ABIGAIL: 	dc.b 6,"ABIGAIL",0			
TEXT_BELGER: 	dc.b 5,"BELGER",0		

;--------------------------------------------
;	DEBUGGER
;--------------------------------------------

TEXT_XVIEW		dc.b 4,"XVIEW"				
TEXT_XVIEW2		dc.b 3,"P1 X"				
TEXT_XVIEW3		dc.b 4,"FRAME"			
	
	EVEN	

;------------------------------------------------------------------------------------------------------------
;		GRAPHICS
;-----------------------------------------------------------------------------------------------------------

;--------------------------------------------
;	SLICE SHEETS + MASKS
;--------------------------------------------	
	
;----------------------------
; HAGGAR
;----------------------------

HAGGAR_SLICE_SHEET:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_HAGGAR.RAW"
HAGGAR_SLICE_SHEET_END:
	
HAGGAR_SLICE_SHEET_MASK:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_HAGGAR.MASK"
HAGGAR_SLICE_SHEET_MASK_END:

	
HAGGAR_SLICE_SHEET_FLIP:
	ds.b	(((320*416)*4)/8) 
HAGGAR_SLICE_SHEET_FLIP_END:

HAGGAR_SLICE_SHEET_MASK_FLIP:
	ds.b	(((320*416)*4)/8)		; <--- Pretty sure this should be 4x smaller (1Bpl Mask)
HAGGAR_SLICE_SHEET_MASK_FLIP_END:

	
;----------------------------
; BRED
;----------------------------

BRED_SLICE_SHEET:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_BRED.RAW"
BRED_SLICE_SHEET_END:
	
BRED_SLICE_SHEET_MASK:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_BRED.MASK"
BRED_SLICE_SHEET_MASK_END:

	
BRED_SLICE_SHEET_FLIP:
	ds.b	(((320*160)*4)/8)
BRED_SLICE_SHEET_FLIP_END:

BRED_SLICE_SHEET_MASK_FLIP:
	ds.b	(((320*160)*4)/8)
BRED_SLICE_SHEET_MASK_FLIP_END:

;--------------
; J
;--------------
J_SLICE_SHEET:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_J.RAW"
	;ds.b	((320*128)*4)/8
J_SLICE_SHEET_END:
	
J_SLICE_SHEET_MASK:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_J.RAW"
	;ds.b	((320*128)*1)/8
J_SLICE_SHEET_MASK_END:
	
	
J_SLICE_SHEET_FLIP:
	ds.b	(((320*128)*4)/8);-(((48*16)*4)/8) 
J_SLICE_SHEET_FLIP_END:

J_SLICE_SHEET_MASK_FLIP:
	ds.b	(((320*128)*4)/8);-(((48*16)*4)/8) 
J_SLICE_SHEET_MASK_FLIP_END:
	
;--------------
; ROXY
;--------------

ROXY_SLICE_SHEET:
	ds.b	((320*176)*4)/8
ROXY_SLICE_SHEET_END:
	
ROXY_SLICE_SHEET_MASK:
	ds.b	((320*176)*4)/8
ROXY_SLICE_SHEET_MASK_END:
	
	
ROXY_SLICE_SHEET_FLIP:
	ds.b	((320*176)*4)/8
ROXY_SLICE_SHEET_FLIP_END:
	
ROXY_SLICE_SHEET_MASKFLIP:
	ds.b	((320*176)*4)/8
ROXY_SLICE_SHEET_MASK_FLIP_END:
	
;--------------
; AXL
;--------------

AXL_SLICE_SHEET:
	;ds.b	((320*176)*4)/8
AXL_SLICE_SHEET_END:
	
AXl_SLICE_SHEET_MASK:
	;ds.b	((320*176)*4)/8
AXL_SLICE_SHEET_MASK_END:
	
	
AXL_SLICE_SHEET_FLIP:
	;ds.b	((320*176)*4)/8
AXL_SLICE_SHEET_FLIP_END:
	
AXl_SLICE_SHEET_MASKFLIP:
	;ds.b	((320*176)*4)/8
AXL_SLICE_SHEET_MASKFLIP_END:
	
;--------------
; BILL BULL
;--------------

BILL_SLICE_SHEET:
	;ds.b	((320*176)*4)/8
BILL_SLICE_SHEET_END:

BILL_SLICE_SHEET_MASK:
	;ds.b	((320*176)*4)/8
BILL_SLICE_SHEET_MASK_END:
	
;--------------
; HOLLY WOOD
;--------------

HWOOD_SLICE_SHEET:
	;ds.b	((320*176)*4)/8
HWOOD_SLICE_SHEET_END:
	
HWOOD_SLICE_SHEET_MASK:
	;ds.b	((320*176)*4)/8
HWOOD_SLICE_SHEET_MASK_END:
	
;--------------
; ANDORE
;--------------

ANDORE_SLICE_SHEET:
	;ds.b	((320*208)*4)/8
	;INCBIN "C:\Amiga\FFARES\SPRITESHEETS\PLAYERS\HAGGAR_SS.RAW"
ANDORE_SLICE_SHEET_END:
	
ANDORE_SLICE_SHEET_MASK:
	;ds.b	((320*208)*4)/8
	;INCBIN "C:\Amiga\FFARES\SPRITESHEETS\PLAYERS\HAGGAR_SS_MASK.RAW"
ANDORE_SLICE_SHEET_MASK_END:
	
	
ANDORE_SLICE_SHEET_FLIPPED:
	;ds.b	((320*208)*4)/8
	;INCBIN "C:\Amiga\FFARES\SPRITESHEETS\PLAYERS\HAGGAR_SS.RAW"
ANDORE_SLICE_SHEET_FLIPPED_END:
	
ANDORE_SLICE_SHEET_FLIPPED_MASK:
	;ds.b	((320*208)*4)/8
	;INCBIN "C:\Amiga\FFARES\SPRITESHEETS\PLAYERS\HAGGAR_SS_MASK.RAW"
ANDORE_SLICE_SHEET_FLIPPED_MASK_END:


;--------------------------------------------
;	STUFF
;--------------------------------------------

;--------------
; EFFECTS
;--------------

FX_SLICE_SHEET:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_FX.RAW"
	;ds.b	((320*32)*4)/8
FX_SLICE_SHEET_END:

FX_SLICE_SHEET_MASK:
SS_FX.MASK"
	;ds.b	((320*32)*4)/8
FX_SLICE_SHEET_MASK_END:
	
	
FX_SLICE_SHEET_FLIP:
;	ds.b	((320*32)*4)/8
FX_SLICE_SHEET_FLIP_END:
	
FX_SLICE_SHEET_MASK_FLIP:
;	ds.b	((320*32)*4)/8
FX_SLICE_SHEET_MASK_FLIP_END:

;---------------------
;	HARDWARE SPRITES
;---------------------

SPR_TRAINLIGHT_L:
	dc.w	$70F0,$A000
	INCBIN "GRAPHICS\MG_MAINGAME\TRAINLIGHT_L.RAW"
	dc.w	0,0
	
SPR_TRAINLIGHT_R:
	dc.w	$70F8,$A000
	INCBIN "GRAPHICS\MG_MAINGAME\TRAINLIGHT_R.RAW"
	dc.w	0,0
	
SPR_BLANKSPRITE:
	dc.w	$2a10,$2b00
	dc.w	0,0
	dc.w	0,0

TXCHECK:

	dc.w 0
	
	EVEN
	
;--------------------------------------------
;	TILE SHEETS
;--------------------------------------------
	
HUDSHEET:
	INCBIN "GRAPHICS\MG_MAINGAME\HUDCHARS.RAW"
HUDSHEET_END:
	EVEN
	
BLANKBUFFER:
	ds.b 	(16*144)/8
	EVEN
	
L1_1_TILES:
	;INCBIN "C:\Amiga\FFARES\ROUND1_SLUMS\1_1\L1_1_tiles.RAW"
L1_1_TILES_END:
	EVEN
	
L2_1_TILES:
	;INCBIN "C:\Amiga\FFARES\ROUND2_SUBWAY\TILES\L2_1_tiles.RAW"
L2_1_TILES_END:
	EVEN
	
L2_2_TILES:
	INCBIN "GRAPHICS\MG_MAINGAME\SS_FX.RAW"
L2_2_TILES_END:
	EVEN
	
L3_1_TILES:
	;INCBIN "C:\Amiga\FFARES\ROUND3_WESTSIDE\TILES\L3_1_TILES2.RAW"
L3_1_TILES_END:
	;EVEN
	
;------------------------------------------------------------------------------------------------------------
;		SOUND DATA
;----------------------------------------------------------------------------------------------------------
	
FX_PUNCH_WOOSH:
	INCBIN "SOUND\PUNCH_WOOSH.IFF"
FX_PUNCH_WOOSH_END:
;-----------------	
FX_PUNCH:
	INCBIN "SOUND\PUNCH.IFF"
FX_PUNCH_END:
;-----------------

FX_HARDHIT:
	INCBIN "SOUND\HARD_HIT.IFF"
FX_HARDHIT_END:
;-----------------
FX_CODYUPPER:
	INCBIN "SOUND\CODYUPPER.IFF""
FX_CODYUPPER_END:
;-----------------

FX_HAGGAR_HAMMER:
	INCBIN "SOUND\HAGGAR_HAMMER.IFF"
FX_HAGGAR_HAMMER_END:

FX_HAGGAR_FLYINGKICK:
	INCBIN "SOUND\HAGGAR_FLYINGKICK.IFF""
FX_HAGGAR_FLYINGKICK_END:

FX_HAGGAR_SPECIAL:
	INCBIN "SOUND\HAGGAR_SPECIAL.IFF"
FX_HAGGAR_SPECIAL_END:
;-----------------	
FX_LAND:
	INCBIN "SOUND\LAND.IFF"
FX_LAND_END:
;-----------------
FX_SILENCE:
	dc.w 0
FX_SILENCE_END:
;-----------------
	
MUS_L1:
	incbin "SOUND/P61.prototron_subway_1900"
	
;------------------------------------------------------------------------------------------------------------
;		BSS
;------------------------------------------------------------------------------------------------------------

	SECTION MG_BSS,BSS_C
	;-------------------
	
;-------------------------------------------	
HUDSCREEN:
	ds.b	HSCR_BPLSIZE*HSCR_DEPTH			; No double buffer on HUD screen (don't think it needs it)
HUDSCREEN_END:
	EVEN
;-------------------------------------------	
MAIN_SCREEN:
	ds.b	(SCR_BPLSIZE*SCR_DEPTH)+56 		; Extra words = (Mapwidth - displaywidth)
MAIN_SCREEN_END:
	EVEN
;-------------------------------------------	
BACK_BUFFER:
	ds.b	(SCR_BPLSIZE*SCR_DEPTH)+56
BACK_BUFFER_END:
	EVEN
;-------------------------------------------

;-----------------------------------------------------------------------------------------------------------
		END ; ...OF LINE!
;-----------------------------------------------------------------------------------------------------------
