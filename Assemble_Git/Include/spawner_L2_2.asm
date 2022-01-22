;**************************************************************************************************************
;	SPAWNER L2_2
;**************************************************************************************************************


SPAWNER_L2_2:

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 0
;	- Wait until first carriage gap has been reached, then activate first stop point
;----------------------------------------------------------------------------------------------------------

.Spawn0

	;-------------------------------
	tst.b 	(SPAWN)
	bgt.s	.Spawn1
	;-------------------------------
	cmp.w	#30,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	bset 	#0,SCROLLFLAGS2
	
	
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.s	.Spawn1
	
	move.b	#1,(SPAWN)

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 1
;	- Enemy wave at first carriage gap (from either side) once previous enemies have died
;-----------------------------------------------------------------------------------------------------------
.Spawn1

	;-------------------------------
	cmp.b 	#1,(SPAWN)
	bne.s	.Spawn2
	;-------------------------------
	cmp.w	#30,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	bset 	#0,SCROLLFLAGS2
	
	;-------------------------------
	; MAKE ENEMIES
	;-------------------------------
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$F8D0,d2				; Load X & Y of where to appear
	move.b	#3,d4					; State
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$22BC,d2					
	move.b	#3,d4					
	bsr.w	INSTANCE_CREATE			
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4	
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$24C0,d2					; Plot X
	move.b	#3,d4					; State
	
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	move.b	#2,(SPAWN)				; Increase Spawn variable
	bra.w	SPAWN_2_2_DONE
;.2

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 2
;	- Make sitting enemies futher down level
;-----------------------------------------------------------------------------------------------------------
.Spawn2

	;-------------------------------
	cmp.b 	#2,(SPAWN)
	bne.s	.Spawn3
	;-------------------------------
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.s	.Spawn3
	
	;-------------------------------
	; MAKE ENEMIES 
	;-------------------------------	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4		
	moveq 	#0,d5		
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$1FBC,d2				; Plot X/Y
	move.b	#1,d4					; State
	move.b	#1,d5					; Frame
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$28BC,d2					; Plot X
	move.b	#1,d4					; State
	move.b	#0,d5					; Frame
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4		
	moveq 	#0,d5		
	
	move.b	#OBJ_BRED,d1			; Make J
	move.w	#$2DBC,d2				; Plot X
	move.b	#1,d4					; State
	move.b	#0,d5					; Frame
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	bclr 	#0,SCROLLFLAGS2
	move.b	#3,(SPAWN)

	
;-----------------------------------------------------------------------------------------------------------
; SPAWN = 3
;	- Stop in midddle of carriage to fight enemies
;-----------------------------------------------------------------------------------------------------------
.Spawn3

	;-------------------------------
	cmp.b 	#3,(SPAWN)
	bne.s	.Spawn4
	;-------------------------------
	cmp.w	#60,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	bset 	#0,SCROLLFLAGS2
	
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.s	.Spawn4
	
	bclr 	#0,SCROLLFLAGS2
	move.b	#4,(SPAWN)
	bra.w	SPAWN_2_2_DONE
		
;-----------------------------------------------------------------------------------------------------------
; SPAWN = 4
;	- Enemy wave at second carriage gap (from either side) once previous enemies have died
;-----------------------------------------------------------------------------------------------------------
.Spawn4

	;-------------------------------
	cmp.b 	#4,(SPAWN)
	bne.s	.Spawn5
	;-------------------------------
	
	cmp.w	#78,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	bset 	#0,SCROLLFLAGS2
	
	;-------------------------------
	; MAKE ENEMIES
	;-------------------------------
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$F8D0,d2				; Load X & Y of where to appear
	move.b	#3,d4					; State
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$22BC,d2					
	move.b	#3,d4					
	bsr.w	INSTANCE_CREATE			
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4	
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$24C0,d2					; Plot X
	move.b	#3,d4					; State
	
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	move.b	#5,(SPAWN)				; Increase Spawn variable
	bra.w	SPAWN_2_2_DONE

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 5
;	- Activate scrolling from last stop point
;-----------------------------------------------------------------------------------------------------------
.Spawn5

	;-------------------------------
	cmp.b 	#5,(SPAWN)
	bne.s	.Spawn6
	;-------------------------------
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.w	SPAWN_2_2_DONE
	
	bclr 	#0,SCROLLFLAGS2
	move.b	#6,(SPAWN)
	bra.w	SPAWN_2_2_DONE
	
;-----------------------------------------------------------------------------------------------------------
; SPAWN = 6
;	- Create enemies while still scrolling (no stop point)
;-----------------------------------------------------------------------------------------------------------	
.Spawn6
	;-------------------------------
	cmp.b 	#6,(SPAWN)
	bne.s	.Spawn7
	;-------------------------------
	cmp.w	#92,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.w	SPAWN_2_2_DONE
	
	;-------------------------------
	; MAKE ENEMIES
	;-------------------------------
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$F8D0,d2				; Load X & Y of where to appear
	move.b	#3,d4					; State
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$22BC,d2					
	move.b	#3,d4					
	bsr.w	INSTANCE_CREATE			
	;-------------------------------
	
;	moveq 	#0,d1
;	moveq 	#0,d2
;	moveq 	#0,d3
;	moveq 	#0,d4	
;	moveq 	#0,d5	
	
;	move.b	#OBJ_BRED,d1			; Make J
;	move.w	#$24C0,d2				; Plot X
;	move.b	#3,d4					; State
	
;	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	move.b	#7,(SPAWN)
	bra.w	SPAWN_2_2_DONE

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 7
;	- Enemny wave 1 from left of screen at end of Level (once previous enemies have died)
;-----------------------------------------------------------------------------------------------------------
	
.Spawn7
	;-------------------------------
	cmp.b 	#7,(SPAWN)
	bne.s	.Spawn8
	;-------------------------------
	cmp.w	#128,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.w	SPAWN_2_2_DONE
	
	
	;-------------------------------
	; MAKE ENEMIES
	;-------------------------------
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make J
	move.w	#$F4D0,d2				; Load X & Y of where to appear
	move.b	#3,d4					; State
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$F0BC,d2					
	move.b	#3,d4					
	bsr.w	INSTANCE_CREATE			
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4	
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$F2C0,d2					; Plot X
	move.b	#3,d4					; State
	
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	bclr 	#0,SCROLLFLAGS2
	move.b	#8,(SPAWN)
	bra.w	SPAWN_2_2_DONE

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 8
;	- Enemny wave 2 from left of screen at end of Level (once previous enemies have died)
;-----------------------------------------------------------------------------------------------------------

.Spawn8
	;-------------------------------
	cmp.b 	#8,(SPAWN)
	bne.s	.Spawn9
	;-------------------------------
	cmp.w	#128,(XVIEW+2)
	blt.w	SPAWN_2_2_DONE
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.w	SPAWN_2_2_DONE
	
	
	;-------------------------------
	; MAKE ENEMIES
	;-------------------------------
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_J,d1				; Make J
	move.w	#$F0D0,d2				; Load X & Y of where to appear
	move.b	#3,d4					; State
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4				
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1			; Make BRED
	move.w	#$F0BC,d2					
	move.b	#3,d4					
	bsr.w	INSTANCE_CREATE			
	;-------------------------------
	
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	moveq 	#0,d4	
	moveq 	#0,d5	
	
	move.b	#OBJ_BRED,d1				; Make J
	move.w	#$F2C0,d2					; Plot X
	move.b	#3,d4					; State
	
	bsr.w	INSTANCE_CREATE			; Create Enemy
	;-------------------------------
	bclr 	#0,SCROLLFLAGS2
	move.b	#9,(SPAWN)
	bra.w	SPAWN_2_2_DONE

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 9 
;	- Stop everything
;-----------------------------------------------------------------------------------------------------------
.Spawn9

	;-------------------------------
	cmp.b 	#9,(SPAWN)
	bne.s	.Spawn10
	;-------------------------------
	cmp.b	#1,(OBJECT_NUMBER_OF)
	bgt.s	SPAWN_2_2_DONE
	
	lea 	OBJECT_1,a0
	bset 	#CONTROLS_LOCK,OBJ_FLAGS(a0)
	move.b	#13,OBJ_STATE(A0)
	move.b	#10,(SPAWN)
	move.b	#$60,(SPAWNT)

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 10
;	- Wait until timer runs out then activate fade out
;-----------------------------------------------------------------------------------------------------------	
.Spawn10

	;-------------------------------
	cmp.b 	#10,(SPAWN)
	bne.s	.Spawn11
	;-------------------------------
	
	tst.b	(SPAWNT)
	bne.s	.NoFadeYet
	
	bsr.w 	GAMEOVER_FADEOUT
	
	move.b	#11,(SPAWN)
	bra.s	SPAWN_2_2_DONE
.NoFadeYet
	subq.b #1,(SPAWNT)

;-----------------------------------------------------------------------------------------------------------
; SPAWN = 11
;	- All done. Go home and have a pint!
;-----------------------------------------------------------------------------------------------------------
.Spawn11



SPAWN_2_2_DONE:
	;-------------------------------
	RTS
	;-------------------------------
	
	
GAMEOVER_DISPLAY:	

	;-----------------------------------
	; DISPLAY "GAME OVER"
	;-----------------------------------


	btst	#5,HUDFLAGS2
	beq.s	GAMEOVER_DISPLAY_DONE
	move.b	#1,(OBJECT_SLOTS+15)
	lea 	OBJECT_16,a0
	tst.b	OBJ_TIMER(a0)
	bne.s	.1

	;move.b	#0,(OBJECT_SLOTS+15)
	move.b 	#$AA,OBJ_TIMER(a0)
	bsr.b	GAMEOVER_FADEOUT
	bclr	#5,HUDFLAGS2
	
	bra.s 	GAMEOVER_DISPLAY_DONE
.1
	sub.b 	#1,OBJ_TIMER(a0)
	
GAMEOVER_DISPLAY_DONE:	
	;-----------------------------------
	RTS
	;-----------------------------------
	
GAMEOVER_FADEOUT:	
	;-----------------------------------
	; GAME OVER FADE OUT
	;-----------------------------------
	move.b	#4,(FADE+1)					; Set fade speed (delay)
	bset 	#7,HUDFLAGS2				; Activate Fade Out
	bclr 	#6,SCROLLFLAGS				; Stop Screen Shake
	
	bset	#4,HUDFLAGS2				; Stop HUD Activity
	bset 	#1,SCROLLFLAGS2				; Deactivate HW Sprites (Until I do a fade table for them)
	move.b 	#0,(SPR_TRAINLIGHT_L+1)		; Move HWsprites to edge of screen
	move.b 	#0,(SPR_TRAINLIGHT_R+1)
	
	lea		HUDSCREEN,a0
	move.w	#(HUDSCREEN_END-HUDSCREEN)/4-1,d1
	bsr.w	CLEARSCREEN	
		
	bsr 	P61_End						; Stop Music
	;-----------------------------------
	RTS
	;-----------------------------------