;-------------------------------------------------------------------------------------------------------------
; 	HUD CONTROL
;
;		- Displays energy bars and enemy faces/names on collisions
;-------------------------------------------------------------------------------------------------------------

HUD_CONTROL:
		
	btst	#4,HUDFLAGS2					; Stop Hud Activity if Bit is set
	bne.s	HUD_CONTROL_DONE
	
	;----------------------------------------
	; ENEMY ENERGY BAR 
	;----------------------------------------
ENEMYENERGY:
	btst 	#5,HUDFLAGS
	beq.s	.1
	
	tst.b	(HUDTIMERS)
	bne.s	.2
	
	bsr.w	ERASE_ENEMYHUD
	
.2	
	sub.b	#1,(HUDTIMERS)
.1

	;----------------------------------------
	; P2 START FLASH
	;----------------------------------------
P2_STARTFLASH:

	tst.b	(HUDTIMERS+1)
	bne.s	.2
	
	bsr.w	HUD_P2START_FLASH
	move.b	#$30,(HUDTIMERS+1)
.2	
	sub.b	#1,(HUDTIMERS+1)
.1

HUD_CONTROL_DONE:
	;----------------------------------------
	RTS
	;----------------------------------------


;-----------------------------------------------------------------------------------------------------------
;	HUD SUBS
;-----------------------------------------------------------------------------------------------------------
DRAW_PLAYERHUD:

	lea OBJECT_1,a0
	move.w 	#$8,d3					; Set Y for Draw
	bsr.w	P1_ENERGYBAR_SEQUENCE
	
	
	;---------------------------------------------------------
	; P1 Lives
	;---------------------------------------------------------

	bsr.w	LOAD_HUDFONT
	
	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d7
	move.b 	OBJ_LIVES(a0),d1
	
	bsr.w 	CONVERT_VALUES
	move.b	 d1,d0
	;lea 	TEXT_EQU,a0					; Load String to be printed
	
	move.w 	#$0088,(TILETABLE)			; Set X for DRAW
	move.w 	#$00,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	bset 	#9,HUDFLAGS					; VARIABLE MODE
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	
	;----------------------------------------
	RTS
	;----------------------------------------
	
DRAW_ENEMYHUD:

	movem.l d0-a6,-(sp)
	bsr.w 	ERASE_ENEMYNAME
	moveq 	#0,d3
	move.w 	#$18,d3					; Set Y for Draw
	bsr.w	P1_ENERGYBAR_SEQUENCE
	
	;---------------------------------------------------------
	;	HEAD ICON
	;---------------------------------------------------------
	
	bclr 	#1,HUDFLAGS
	moveq 	#0,d0
	move.b 	OBJ_TYPE(a0),d0				; Icon number
	subq	#1,d0
	move.w 	#$0010,(TILETABLE)			; Set X for DRAW
	move.w 	#$10,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1010,(TILETABLE+4)		; Set WIDTH & HEIGHT
	
	;---------------------------------------------------------
	bsr.w 	BLITTER_ICON_DRAWER
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	; NAME
	;---------------------------------------------------------
	
	bsr.w	LOAD_HUDFONT
	
	;-----------------------------------
	bsr.w 	LOAD_NAME
	;-----------------------------------
	
	move.w 	#$0028,(TILETABLE)			; Set X for DRAW
	move.w 	#$10,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	bclr 	#0,HUDFLAGS2				; No Typewriter
	;---------------------------------------------------------

	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	movem.l 	(sp)+,d0-a6
	;-----------------------------------
	RTS
	;-----------------------------------
	
ERASE_ENEMYHUD:

	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS						; Draw to HUD SCREEN
	bset 	#8,HUDFLAGS						; ERASE Mode
	move.l 	#0,d7							; Set SOURCE modulo (24-2)
	move.w 	#$0010,(TILETABLE)				; Set X for DRAW
	move.w 	#$10,(TILETABLE+2)				; Y-Coordinate
	move.w 	#$9010,(TILETABLE+4)			; WIDTH & HEIGHT #$WWHH

	;---------------------------------------------------------
	bsr.w 	BLIT_TILES
	;---------------------------------------------------------
	
	;-----------------------------------
	RTS
	;-----------------------------------
	
ERASE_ENEMYNAME:

	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS						; Draw to HUD SCREEN
	bset 	#8,HUDFLAGS						; ERASE Mode
	move.l 	#0,d7							; Set SOURCE modulo (24-2)
	move.w 	#$0030,(TILETABLE)				; Set X for DRAW
	move.w 	#$10,(TILETABLE+2)				; Y-Coordinate
	move.w 	#$6008,(TILETABLE+4)			; WIDTH & HEIGHT #$WWHH

	;---------------------------------------------------------
	bsr.w 	BLIT_TILES
	;---------------------------------------------------------
	
	;---------------------------------------------------------
	RTS
	;---------------------------------------------------------
	
HUD_ENEMY_ENERGY:

	;---------------------------------------------------------
	RTS
	;---------------------------------------------------------

;-----------------------------------------------------------------------------------------------------------
; PUSH 2P START
;-----------------------------------------------------------------------------------------------------------	

HUD_P2START_FLASH:

	btst 	#10,HUDFLAGS
	bne.s	.1
	bclr 	#1,HUDFLAGS					; Draw to HUD SCREEN
	bsr.w	LOAD_HUDFONT
	lea 	TEXT_COIN,a0				; Load String to be printed
	
	move.w 	#$00E0,(TILETABLE)			; Set X for DRAW
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	bclr 	#0,HUDFLAGS2				; No Typewriter
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	bset	#10,HUDFLAGS
	bra.s 	.2
.1
	;---------------------------------------------------------
	bclr 	#1,HUDFLAGS					; Draw to HUD SCREEN
	bsr.w	LOAD_HUDFONT
	lea 	TEXT_COINC,a0				; Load String to be printed
	
	move.w 	#$00E0,(TILETABLE)			; Set X for DRAW
	move.w 	#$08,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	bset 	#4,HUDFLAGS					; IN GAME TEXT SHEET
	bclr 	#0,HUDFLAGS2				; No Typewriter
	;---------------------------------------------------------
	bsr.w 	CPU_TEXT_DRAWER
	;---------------------------------------------------------
	bclr	#10,HUDFLAGS
.2

	;---------------------------------------------------------
	RTS
	;---------------------------------------------------------
	
;-----------------------------------------------------------------------------------------------------------
; 	LOAD ENEMY NAME TO BE DISPLAYED
;-----------------------------------------------------------------------------------------------------------	

LOAD_NAME:

	cmp.b	#1,OBJ_TYPE(a0)
	bgt.s	.1
	lea 	TEXT_GUY,a0				; Load String to be printed
	bra.s	LOAD_NAME_DONE
.1
	cmp.b	#2,OBJ_TYPE(a0)
	bgt.s	.2
	lea 	TEXT_CODY,a0				; Load String to be printed
	bra.s	LOAD_NAME_DONE
.2	
	cmp.b	#3,OBJ_TYPE(a0)
	bgt.s	.3
	lea 	TEXT_HAGGAR,a0				; Load String to be printed
	bra.s	LOAD_NAME_DONE
.3	
	cmp.b	#4,OBJ_TYPE(a0)
	bgt.s	.4
	lea 	TEXT_BRED,a0				; Load String to be printed
	bra.s	LOAD_NAME_DONE
.4
	cmp.b	#5,OBJ_TYPE(a0)
	bgt.s	.5
	lea 	TEXT_J,a0					
	bra.s	LOAD_NAME_DONE
.5
	cmp.b	#6,OBJ_TYPE(a0)
	bgt.s	.6
	lea 	TEXT_ROXY,a0					
	;bra.s	LOAD_NAME_DONE
.6
	
LOAD_NAME_DONE:
	RTS
	
;---------------------------------------------------------
	
P1_ENERGYBAR_SEQUENCE:

	bsr.w	EB_LOAD_SEQUENCE
	
DrawEB:

	moveq #0,d0
	moveq #0,d1
	moveq #0,d2
	moveq #0,d7
	
	move.b #7,d7						; Counter (8 Blocks in energy bar)
EB_BlockLoop:
	
	move.b (a1)+,d0						; Load X of Block (Changes)
	move.b (a1)+,d2						; Load Y of Block (Static)

	bclr 	#1,HUDFLAGS
	;move.b 	d1,d0					; Icon number
	move.w 	d2,(TILETABLE)				; Set X for DRAW
	move.w 	d3,(TILETABLE+2)			; Set Y for DRAW
	move.w 	#$1008,(TILETABLE+4)		; Set WIDTH & HEIGHT
	;---------------------------------------------------------
	movem 	d0-d3/d7,-(sp)
	bsr.w 	BLITTER_ICON_DRAWER
	movem 	(sp)+,d0-d3/d7
	;---------------------------------------------------------
	dbra 	d7,EB_BlockLoop
	;---------------------------------------------------------

	;---------------------------------------------------------
	RTS
	;---------------------------------------------------------

EB_LOAD_SEQUENCE:		
	cmp.b 	#120,OBJ_ENERGY(a0)
	blt.s	.1	
	lea 	ENERGY_120,a1	
	bra.w	DrawEB
.1
	cmp.b 	#116,OBJ_ENERGY(a0)
	blt.s	.2
	lea 	ENERGY_116,a1	
	bra.w	DrawEB
.2
	cmp.b 	#112,OBJ_ENERGY(a0)
	blt.s	.3
	lea 	ENERGY_112,a1	
	bra.w	DrawEB
.3
	cmp.b 	#108,OBJ_ENERGY(a0)
	blt.s	.4
	lea 	ENERGY_108,a1	
	bra.w	DrawEB
.4
	cmp.b 	#104,OBJ_ENERGY(a0)
	blt.s	.5
	lea 	ENERGY_104,a1	
	bra.w	DrawEB
.5
	cmp.b 	#100,OBJ_ENERGY(a0)
	blt.s	.6
	lea 	ENERGY_100,a1	
	bra.w	DrawEB
.6
	cmp.b 	#96,OBJ_ENERGY(a0)
	blt.s	.7
	lea 	ENERGY_96,a1	
	bra.w	DrawEB
.7
	cmp.b 	#92,OBJ_ENERGY(a0)
	blt.s	.8
	lea 	ENERGY_92,a1	
	bra.w	DrawEB
.8
	cmp.b 	#88,OBJ_ENERGY(a0)
	blt.s	.9
	lea 	ENERGY_88,a1	
	bra.w	DrawEB
.9
	cmp.b 	#84,OBJ_ENERGY(a0)
	blt.s	.10
	lea 	ENERGY_84,a1	
	bra.w	DrawEB
.10
	cmp.b 	#80,OBJ_ENERGY(a0)
	blt.s	.11
	lea 	ENERGY_80,a1
	bra.w	DrawEB
.11
	cmp.b 	#76,OBJ_ENERGY(a0)
	blt.s	.12
	lea 	ENERGY_76,a1	
	bra.w	DrawEB
.12
	cmp.b 	#72,OBJ_ENERGY(a0)
	blt.s	.13
	lea 	ENERGY_72,a1	
	bra.w	DrawEB
.13
	cmp.b 	#68,OBJ_ENERGY(a0)
	blt.s	.14
	lea 	ENERGY_68,a1	
	bra.w	DrawEB
.14
	cmp.b 	#64,OBJ_ENERGY(a0)
	blt.s	.15
	lea 	ENERGY_64,a1	
	bra.w	DrawEB
.15
	cmp.b 	#60,OBJ_ENERGY(a0)
	blt.s	.16
	lea 	ENERGY_60,a1	
	bra.w	DrawEB
.16
	cmp.b 	#56,OBJ_ENERGY(a0)
	blt.s	.17
	lea 	ENERGY_56,a1	
	bra.w	DrawEB
.17
	cmp.b 	#52,OBJ_ENERGY(a0)
	blt.s	.18
	lea 	ENERGY_52,a1	
	bra.w	DrawEB
.18
	cmp.b 	#48,OBJ_ENERGY(a0)
	blt.s	.19
	lea 	ENERGY_48,a1	
	bra.w	DrawEB
.19
	cmp.b 	#44,OBJ_ENERGY(a0)
	blt.s	.20
	lea 	ENERGY_44,a1	
	bra.w	DrawEB
.20
	cmp.b 	#40,OBJ_ENERGY(a0)
	blt.s	.21
	lea 	ENERGY_40,a1	
	bra.w	DrawEB
.21
	cmp.b 	#36,OBJ_ENERGY(a0)
	blt.s	.22
	lea 	ENERGY_36,a1	
	bra.w	DrawEB
.22
	cmp.b 	#32,OBJ_ENERGY(a0)
	blt.s	.23
	lea 	ENERGY_32,a1	
	bra.w	DrawEB
.23
	cmp.b 	#28,OBJ_ENERGY(a0)
	blt.s	.24
	lea 	ENERGY_28,a1	
	bra.w	DrawEB
.24
	cmp.b 	#24,OBJ_ENERGY(a0)
	blt.s	.25
	lea 	ENERGY_24,a1	
	bra.w	DrawEB
.25
	cmp.b 	#20,OBJ_ENERGY(a0)
	blt.s	.26
	lea 	ENERGY_20,a1	
	bra.w	DrawEB
.26
	cmp.b 	#16,OBJ_ENERGY(a0)
	blt.s	.27
	lea 	ENERGY_16,a1	
	bra.w	DrawEB
.27
	cmp.b 	#12,OBJ_ENERGY(a0)
	blt.s	.28
	lea 	ENERGY_12,a1	
	bra.w	DrawEB
.28
	cmp.b 	#8,OBJ_ENERGY(a0)
	blt.s	.29
	lea 	ENERGY_8,a1	
	bra.w	DrawEB
.29
	cmp.b 	#4,OBJ_ENERGY(a0)
	blt.s	.30
	lea 	ENERGY_4,a1	
	bra.w	DrawEB
.30
	lea 	ENERGY_0,a1	

	;--------------------	
	RTS
	;--------------------	




