;----------------------------------------------------------------------------------------------
;		P1CONTROLS
;----------------------------------------------------------------------------------------------

; BIT 	- ACTION
; ---   - ------
; 0 	- UP
; 1 	- DOWN
; 2 	- LEFT
; 3 	- RIGHT
; 4 	- FIRE 1
; 5 	- FIRE 2
; -------------------------
; CONSTANTS
; -------------------------

ANIMSPEED_WALK 		= 6
ANIMSPEED_ATTACK 	= 4
ANIMSPEED_SPECIAL 	= 4
HSPEED 				= 2
VSPEED 				= 2

; -------------------------
; SHIFT LIMITS
; -------------------------

RLIMIT 				= 16
LLIMIT 				= 0

; -------------------------
; VISIBLE SCREEN BOUNDARIES
; -------------------------

RIGHTSTOP 			= 0
LEFTSTOP 			= 1
UPSTOP 				= 2
DOWNSTOP 			= 3

; -------------------------

P1_CONTROLS:

	
	;----------------------
	movem 	d0-a6,-(sp)
	;----------------------

	lea 	OBJECT_1,a0						; Load P1 Table
	
	;----------------------
	; COMBO RESET						; Timer to reset combo if no-one has been hit in a while
	;----------------------
p1COMBO_RESET:		
	cmp.b	#1,OBJ_COMBO(a0)
	beq		.1
	tst.b	(COMBO_RESET)
	bne.s	.2
	cmp.b	#4,OBJ_STATE(a0)
	beq.s	.1
	move.b	#1,OBJ_COMBO(a0)
	move.b 	#100,(COMBO_RESET)
	bra.s 	.1
	
.2
	sub.b #1,(COMBO_RESET)
.1
	;----------------------
	; HITCLOUNT RESET					; Same as Combo reset, but with hitcount
	;----------------------
HITCOUNT_RESET:	
	cmp.b	#0,OBJ_HITCOUNT(a0)
	beq		.1
	tst.b	OBJ_HITCOUNT_RESET(a0)
	bne.s	.2
	cmp.b	#9,OBJ_STATE(a0)
	beq.s	.1
	move.b	#0,OBJ_HITCOUNT(a0)
	move.b 	#100,OBJ_HITCOUNT_RESET(a0)
	bra.s 	.1
.2
	sub.b #1,OBJ_HITCOUNT_RESET(a0)
.1
	;----------------------
	; CONTROLS LOCK TEST
	;----------------------
	btst 	#1,OBJ_FLAGS(a0)				; Controls Lock
	bne.w 	P1_CONTROLS_TRIGGER_DONE
	
;----------------------------------------------------------------------------------------------------------
; 	STATES TRIGGER
;----------------------------------------------------------------------------------------------------------

	;---------------------------------------
	bsr.w	JOYSTICK_READER					; D0 Holds button info
	;---------------------------------------
	move.w %1111111100000000,$dff034		; POTGO (FIRE BUTTON 2 SETUP)
	;---------------------------------------

;-------------------------------------------
; 	SPECIAL
;-------------------------------------------

PRESS_SPECIAL:
	btst 	#4,d0	
	bne.s	.P1NoSpecial
	btst 	#14-8,$dff016	
	bne.s	.P1NoSpecial
	bsr.w	PLAY_PUNCH_WOOSH
	bset 	#CONTROLS_LOCK,OBJ_FLAGS(a0)
	bset	#1,OBJ_FLAGS(a0)
	bsr.w	 PLAY_HAGGAR_SPECIAL
	move.b 	#1,OBJ_COMBO(a0)
	move.b 	#5,OBJ_STATE(a0)	
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#ANIMSPEED_SPECIAL,OBJ_TIMER(a0)
	bra.w 	P1SPECIAL
.P1NoSpecial


;-------------------------------------------
; 	ATTACK
;-------------------------------------------
	
PRESS_ATTACK:
	btst 	#4,d0
	bne.s	.P1NoAttack
	bclr	#HITBIT,OBJ_FLAGS(a0)
	bset 	#CONTROLS_LOCK,OBJ_FLAGS(a0)				; Controls Lock	

	cmp.b 	#3,OBJ_COMBO(a0)
	beq.s	.1
	bsr.w	PLAY_PUNCH_WOOSH
	bra.s	.2	
.1
	bsr.w	PLAY_CODYUPPER	
	;bsr.w	PLAY_HAGGAR_HAMMER
.2
	move.b 	#4,OBJ_STATE(a0)	
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#ANIMSPEED_ATTACK,OBJ_TIMER(a0)
	bra.w 	P1ATTACK
.P1NoAttack

;-------------------------------------------
; 	JUMP
;-------------------------------------------

PRESS_JUMP:
	btst 	#14-8,$dff016
	bne.s	.P1NoJUmp

	bset 	#CONTROLS_LOCK,OBJ_FLAGS(a0)				; Controls Lock	
	move.b 	#1,OBJ_COMBO(a0)
	move.b 	#7,OBJ_STATE(a0)	
	move.b 	#0,OBJ_FRAME(a0)
	move.b	#20,OBJ_JUMPHEIGHT(a0)
	move.b	#0,OBJ_Z(a0)	
	;----------------------
	
	btst 	#3,d0						; Check if Jumping RIGHT
	bne.s	.1
	bset 	#4,OBJ_FLAGS(a0)			; Set DIRECTION ACTIVE
	bset 	#5,OBJ_FLAGS(a0)			; Set RIGHT
.1
	;----------------------
	btst 	#2,d0						; Check if Jumping LEFT
	bne.s	.2
	bset 	#4,OBJ_FLAGS(a0)			; Set DIRECTION ACTIVE
	bclr 	#5,OBJ_FLAGS(a0)			; Set LEFT
.2
	;----------------------	
	bra.w 	P1JUMP
	
.P1NoJUmp

;--------------------------------------
; 	WALK
;--------------------------------------

PRESS_WALK:

	;----------------------
P1_PUSHUP:
	btst 	#0,d0
	bne.s	.P1NoUp
	move.b 	#3,OBJ_STATE(a0)
	bclr	#DOWNSTOP,OBJ_STOPS(a0)		; Clear DOWNSTOP flag if UP is pushed
	bra.w 	P1_WALK
.P1NoUp
	;----------------------
P1_PUSHDOWN:
	btst 	#1,d0
	bne.s	.P1NoDown
	move.b 	#3,OBJ_STATE(a0)
	bclr	#UPSTOP,OBJ_STOPS(a0)		; Clear UPSTOP flag if DOWN is pushed
	bra.w 	P1_WALK
.P1NoDown
	;----------------------	
P1_PUSHLEFT:
	btst 	#2,d0
	bne.s	.P1NoLeft
	move.b 	#3,OBJ_STATE(a0)
	bclr	#RIGHTSTOP,OBJ_STOPS(a0)	; Clear RIGHTSTOP flag if LEFT is pushed	
	bra.w 	P1_WALK
.P1NoLeft
	;----------------------
P1_PUSHRIGHT:
	btst 	#3,d0
	bne.s	.P1NoRight	
	move.b 	#3,OBJ_STATE(a0)
	bclr	#LEFTSTOP,OBJ_STOPS(a0)		; Clear LEFTSTOP flag if RIGHT is pushed
	bra.w 	P1_WALK
.P1NoRight
	;----------------------

	;--------------------------------------
	; GO TO STANCE IF NO BUTTONS ARE PUSHED
	;--------------------------------------
	cmp.b 	#1,OBJ_STATE(a0)				;CHECK STATE
	beq.s	.1
	move.b 	#2,OBJ_STATE(a0)
	move.b 	#0,OBJ_FRAME(a0)
	bra.w 	P1STANCE
.1	

;--------------------------------------
P1_CONTROLS_TRIGGER_DONE:
;--------------------------------------


;-----------------------------------------------------------------------------------------------------------
;	ALLSTOP: STATE = 0
; 	- Player stops eveything (for end of level)
;-----------------------------------------------------------------------------------------------------------

P1_ALLSTOP:
	;---------------------------------------
	cmp.b 	#0,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1_DUMMY
	;---------------------------------------
	
P1_ALLSTOP_DONE:

;-----------------------------------------------------------------------------------------------------------
;	DUMMY: STATE = 1
; 	- Auto walks right on or off screen
;-----------------------------------------------------------------------------------------------------------

P1_DUMMY:
	;---------------------------------------
	cmp.b 	#1,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1_WALK
	;---------------------------------------
	bset 	#0,OBJ_FLAGS(a0)
	bset 	#1,OBJ_FLAGS(a0)
	add.b 	#HSPEED,OBJ_S(a0)				; Add shift value
	cmp.b 	#RLIMIT,OBJ_S(a0)				; Check for Shift limit on right of frame
	blt.s 	.1								; If less then, the skip frame move
	add.b 	#1,OBJ_X(a0)					; Move RIGHT BY 16 Pixels		
	move.b 	#0,OBJ_S(a0)					; Reset SHIFT value to '0'	
.1	
	cmp.b 	#8,OBJ_X(a0)
	blt.s 	.2
	bclr 	#1,OBJ_FLAGS(a0)
	move.b 	#2,OBJ_STATE(a0)				; RETURN TO STANCE
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#0,OBJ_TIMER(a0)	
.2
	bsr.w 	P_WALKANIM
	;---------------------------------------
	bra.w 	P1_CONTROLS_DONE
	;---------------------------------------
	
;-----------------------------------------------------------------------------------------------------------
;	WALK: STATE = 3
;-----------------------------------------------------------------------------------------------------------

P1_WALK:
	;---------------------------------------
	cmp.b 	#3,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1ATTACK
	;---------------------------------------

	moveq 	#0,d7
	bsr.w 	BOUNDARIES
	
;------------------------------------------
;	RIGHT
;------------------------------------------

P1_MOVERIGHT:
	btst	#3,d0							; Test bit for RIGHT
	bne.s 	P1_MOVELEFT						; If not set, skip to check LEFT bit 
	btst 	#0,OBJ_FLAGS(a0)
	bne.s	.1
	add.b 	#1,OBJ_X(a0)
	
	cmp.b	#2,OBJ_COMBO(a0)
	bgt.s	.1
	move.b	#1,OBJ_COMBO(a0)				; For Punch shifting like in the arcade game
.1
.NoFlipShiftR
	bset 	#0,OBJ_FLAGS(a0)
	btst 	#1,d0							; Check if Diagonal RIGHT-DOWN is pushed
		bne.s 	.NO_RD				
		btst	#DOWNSTOP,OBJ_STOPS(a0)		; Check DOWNSTOP
		bne.s	.NO_RD	
		add.b 	#VSPEED,OBJ_Y(a0)
.NO_RD
		btst 	#0,d0						; Check if Diagoinal RIGHT-UP is pushed
		bne.s 	.NO_RU		
		
		btst	#UPSTOP,OBJ_STOPS(a0)		; Check UPSTOP
		bne.s	.NO_RU	
		add.b 	#-VSPEED,OBJ_Y(a0)				
.NO_RU				
		btst	#RIGHTSTOP,OBJ_STOPS(a0)	; Check RIGHTSTOP
		bne.s	.no_wordshiftR
		add.b 	#HSPEED,OBJ_S(a0)			; Add shift value
		cmp.b 	#RLIMIT,OBJ_S(a0)			; Check for Shift limit on right of frame
		blt.s 	.no_wordshiftR				; If less then, the skip frame move
			add.b 	#1,OBJ_X(a0)			; Move frame RIGHT BY 16 Pixels		
			move.b 	#0,OBJ_S(a0)			; Reset SHIFT value to '0'			
.no_wordshiftR	
	bra.w 	P1_WALK_DONE
		
;------------------------------------------
;	LEFT
;------------------------------------------
P1_MOVELEFT:
	btst 	#2,d0
	bne.s 	.P1_MOVEDOWN
	btst 	#0,OBJ_FLAGS(a0)
	beq.s	.1
	sub.b 	#1,OBJ_X(a0)
	
	cmp.b	#2,OBJ_COMBO(a0)
	bgt.s	.1
	move.b	#1,OBJ_COMBO(a0)				; For Punch shifting like in the arcade game
.1
.NoFlipShiftL
	bclr 	#0,OBJ_FLAGS(a0)
	btst 	#1,d0							; Test for LEFT-DOWN
		bne.s 	.NO_LD
		btst	#DOWNSTOP,OBJ_STOPS(a0)		; Check DOWNSTOP
		bne.s	.NO_LD	
		add.b 	#VSPEED,OBJ_Y(a0)
.NO_LD
	btst 	#0,d0							; Test for LEFT-UP
	bne.s 	.NO_LU
		btst	#UPSTOP,OBJ_STOPS(a0)		; Check DOWNSTOP
		bne.s	.NO_LU	
		add.b 	#-VSPEED,OBJ_Y(a0)	
.NO_LU
	btst	#LEFTSTOP,OBJ_STOPS(a0)			; Check DOWNSTOP
	bne.s	.no_wordshiftL	
	sub.b 	#HSPEED,OBJ_S(a0)	
	cmp.b 	#LLIMIT,OBJ_S(a0)
	bgt.s 	.no_wordshiftL			
		sub.b 	#1,OBJ_X(a0)
		move.b 	#15,OBJ_S(a0)		
.no_wordshiftL	
	bra 	P1_WALK_DONE
	
;------------------------------------------
;	DOWN
;------------------------------------------
.P1_MOVEDOWN	

	btst 	#1,d0
	bne.s 	.P1_MOVEUP
	btst	#DOWNSTOP,OBJ_STOPS(a0)			; Check DOWNSTOP
	bne.s	P1_WALK_DONE
	add.b 	#VSPEED,OBJ_Y(a0)
	bra.s 	P1_WALK_DONE
;------------------------------------------
;	UP
;------------------------------------------
.P1_MOVEUP

	btst 	#0,d0
	bne.w 	P1STANCE
	btst	#UPSTOP,OBJ_STOPS(a0)			; Check UPSTOP
	bne.s	P1_WALK_DONE
	add.b 	#-VSPEED,OBJ_Y(a0)
;------------------------------------------
;	DONE
;------------------------------------------		

P1_WALK_DONE:

	bsr.w 	P_WALKANIM
	
	;---------------------------------------
	bra.w 	P1_CONTROLS_DONE
	;---------------------------------------

;-----------------------------------------------------------------------------------------------------------
;	ATTACK: STATE = 4
;-----------------------------------------------------------------------------------------------------------

P1ATTACK:	
	;----------------------
	cmp.b 	#4,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1SPECIAL
	;----------------------

	tst.b 	OBJ_TIMER(a0)					; Test TIMER for Animation speed
	bne.s	.AnimDelay
	
	cmp.b 	#4,OBJ_COMBO(a0)
	blt.s	.1
	move.b	#1,OBJ_COMBO(a0)
	bclr	#HITBIT,OBJ_FLAGS(a0)
.1
	;----------------------
	; SET FRAME LIMIT
	;----------------------
	cmp.b 	#3,OBJ_COMBO(a0)
	blt.s	.2
	move.b	#4,d1
	bset 	#HITBIT,OBJ_FLAGS(a0)
	bra.s	.FrameCompare	
.2
	move.b	#2,d1
		
.FrameCompare	
	cmp.b 	OBJ_FRAME(a0),d1
	bgt.s	.Animate
.Return									; RETURN TO STANCE

	bclr 	#1,OBJ_FLAGS(a0)
	move.b 	#2,OBJ_STATE(a0)				
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#0,OBJ_TIMER(a0)

	;----------------------	
	bra.w 	P1STANCE	
	;----------------------
	
	;----------------------
	; ANIMATE
	;----------------------
.Animate	
	add.b 	#1,OBJ_FRAME(a0)				; FRAME	
.AnimateDone
	move.b 	#ANIMSPEED_ATTACK,OBJ_TIMER(a0)	; Reset Timer

	bra.w 	P1STANCE
	
	;----------------------
.AnimDelay	

	btst	#HITPAUSE,OBJ_FLAGS2(a0)		; Hit Pause
	beq.s	.3
	tst.b	OBJ_TIMER2(a0)
	bne.s	.5
	bclr	#HITPAUSE,OBJ_FLAGS2(a0)
	bra.s	.4
.5
	sub.b 	#1,OBJ_TIMER2(a0)
	bra.s	.4
.3
	sub.b 	#1,OBJ_TIMER(a0)
.4
.Done
	;----------------------

P1ATTACK_DONE:
	;---------------------------------------
	bra.w 	P1_CONTROLS_DONE
	;---------------------------------------
	
;-----------------------------------------------------------------------------------------------------------
;	SPECIAL: STATE = 5
;-----------------------------------------------------------------------------------------------------------
P1SPECIAL:
	
	;---------------------------------------
	cmp.b 	#5,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1JUMP
	;---------------------------------------

	tst.b 	OBJ_TIMER(a0)					; Test TIMER for Animation speed
	bne.s	.AnimDelay
	
	cmp.b 	#8,OBJ_FRAME(a0)				; FRAME
	blt.s	.Animate	

	bclr 	#1,OBJ_FLAGS(a0)
	move.b 	#2,OBJ_STATE(a0)				; RETURN TO STANCE
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#0,OBJ_TIMER(a0)	
	bra.w 	P1STANCE
.Animate	
	add.b 	#1,OBJ_FRAME(a0)				; FRAME	
.AnimateDone
	move.b 	#ANIMSPEED_SPECIAL,OBJ_TIMER(a0)	; Reset Timer
	bra.w 	P1STANCE ;
.AnimDelay	

	btst	#HITPAUSE,OBJ_FLAGS2(a0)		; Hit Pause
	beq.s	.3
	tst.b	OBJ_TIMER2(a0)
	bne.s	.5
	bclr	#HITPAUSE,OBJ_FLAGS2(a0)
	bra.s	.4
.5
	sub.b 	#1,OBJ_TIMER2(a0)
	bra.s	.4
.3
	sub.b 	#1,OBJ_TIMER(a0)
.4


.Done

	;---------------------------------------
	bra.w 	P1_CONTROLS_DONE
	;---------------------------------------
	
;-----------------------------------------------------------------------------------------------------------
;	JUMP: STATE = 7
;-----------------------------------------------------------------------------------------------------------
P1JUMP:
	
	;---------------------------------------
	cmp.b 	#7,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1HIT
	;---------------------------------------
	
	moveq 	#0,d1	
	moveq 	#0,d2		
	moveq 	#0,d3	
	moveq 	#0,d4

	bset 	#1,OBJ_FLAGS(a0)				; Controls Lock		
	
	;---------------------------------------
	; 	GRAVITY
	;---------------------------------------
	
	move.b	OBJ_Z(a0),d1
	move.b	OBJ_JUMPHEIGHT(a0),d2
	;****************************
	btst	#HITPAUSE,OBJ_FLAGS2(a0)			; Hit Pause
	beq.s	.3
	;****************************
	tst.b	OBJ_TIMER2(a0)
	bne.s	.5
	bclr	#HITPAUSE,OBJ_FLAGS2(a0)
	bra.s	.6
.5
	sub.b 	#1,OBJ_TIMER2(a0)
	bra.w	HitPauseDone
.3
	add.b 	d2,d1		
	move.b	d1,OBJ_Z(a0)
	move.b	OBJ_Z(a0),d1
	
	subq 	#1,d2							
	move.b	d2,OBJ_JUMPHEIGHT(a0)
.6	
	;---------------------------------------
	; 	ANIMATION ( JUMP & FLYING KICK)
	;---------------------------------------

	btst 	#6,OBJ_FLAGS(a0)			; Test to see if FLYING KICK Flag has been set
	bne.s	.1							; If so, skip to FLYING KICK animation Code
	move.w	d1,-(sp)
	bsr.w	JOYSTICK_READER	
	move.w	(sp)+,d1
	btst 	#4,d0						; If not, check if ATTACK has been pressed
	bne.s	.2							; If not, cointinue with JUMP animation
	;bsr.w	PLAY_PUNCH_WOOSH
	bsr.w	PLAY_HAGGAR_FLYINGKICK
	move.b	#3,OBJ_TIMER(a0)			; Set TIMER
	move.b	#2,OBJ_FRAME(a0)			; Set FRAME to start flying kick on
	bset 	#6,OBJ_FLAGS(a0)			; If ATTACK has been pressed, then set FLYING KICK flag
	bra.s	P_FLYNGKICK
.2
	;-----------------------
	; JUMP
	;-----------------------
	lsr.b 	#4,d1
	cmp.b 	#6,d1
	blt.s	.DownFrame
.UpFrame
	move.b	#1,OBJ_FRAME(a0)
	bra.s	PLAYER_JUMPDIR
.DownFrame
	move.b	#0,OBJ_FRAME(a0)
	bra.s	PLAYER_JUMPDIR
	;-----------------------
.1
	;-----------------------
	; FLYING KICK
	;-----------------------
P_FLYNGKICK:
	cmp.b 	#0,OBJ_TIMER(a0)
	bgt.s	.3
	move.b	#3,OBJ_FRAME(a0)
	bra.s 	.4
.3
	sub.b	#1,OBJ_TIMER(a0)
.4	
	
	;---------------------------------------
	; 	DIRECTION (STRAIGHT UP, LEFT, RIGHT)
	;---------------------------------------
	
PLAYER_JUMPDIR:	
	bsr.w 	BOUNDARIES
	btst #4,OBJ_FLAGS(a0)					; Test to see if UP flag is set. If so
	beq.s LAND								; ...then skip all direction code
	;--------
	btst #5,OBJ_FLAGS(a0)
	bne.s .JumpRight
	;--------
	; LEFT
	;--------
.JumpLeft	
	btst	#LEFTSTOP,OBJ_STOPS(a0)			; Check LEFTSTOP
	bne.s	.1
	bclr	#RIGHTSTOP,OBJ_STOPS(a0)
	sub.b 	#HSPEED,OBJ_S(a0)				; SUB shift value
	cmp.b 	#LLIMIT,OBJ_S(a0)				; Check for Shift limit on right of frame...
	bgt.s 	.1								; ...If less than, the skip frame move
		sub.b 	#1,OBJ_X(a0)				; Move frame LEFT BY 16 Pixels		
		move.b 	#15,OBJ_S(a0)				; Reset SHIFT value to '15'
.1	
	bra.s 	.2
	;--------
	; RIGHT
	;--------
.JumpRight
	btst	#RIGHTSTOP,OBJ_STOPS(a0)		; Check RIGHTSTOP
	bne.s	.2
	bclr	#LEFTSTOP,OBJ_STOPS(a0)
	add.b 	#HSPEED,OBJ_S(a0)				; Add shift value
	cmp.b 	#RLIMIT,OBJ_S(a0)				; Check for Shift limit on right of frame...
	blt.s 	.2								; ...If less than, the skip frame move
		add.b 	#1,OBJ_X(a0)				; Move frame RIGHT BY 16 Pixels		
		move.b 	#0,OBJ_S(a0)				; Reset SHIFT value to '0'
.2	
	;---------------------------------------
	;	LAND
	;---------------------------------------
LAND:	
	tst.b	d1
	bne.s	.3
	move.b 	#2,OBJ_STATE(a0)				; Return to Stance
	move.b 	#0,OBJ_FRAME(a0)				; Return to Stance
	bclr 	#1,OBJ_FLAGS(a0)				; Unlock Controls
	bclr 	#4,OBJ_FLAGS(a0)				; Clear Direction flag
	bclr 	#6,OBJ_FLAGS(a0)				; Clear FLYING KICK FLAG
	moveq	#0,d0
.3
	;---------------------------------------
HitPauseDone:
	;---------------------------------------
	bra.w 	P1_CONTROLS_DONE
	;---------------------------------------
	
	
;-----------------------------------------------------------------------------------------------------------
;	HIT: STATE = 9
;-----------------------------------------------------------------------------------------------------------
P1HIT:
	
	;---------------------------------------
	cmp.b 	#9,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1FALL
	;---------------------------------------
	
	tst.b 	OBJ_TIMER(a0)
	bne.s	.1
	move.b 	#2,OBJ_STATE(a0)				; Return to Stance
	move.b 	#0,OBJ_FRAME(a0)
	bclr	#1,OBJ_FLAGS(a0)
	bra.w 	P1STANCE
.1
	sub.b 	#1,OBJ_TIMER(a0)
	
P1HIT_DONE:


;-----------------------------------------------------------------------------------------------------------
;	FALL: STATE = 10
;-----------------------------------------------------------------------------------------------------------
P1FALL:
	
	;---------------------------------------
	cmp.b 	#10,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1GROUND
	;---------------------------------------
	
	bsr.w 	BOUNDARIES
	
	btst 	#7,OBJ_FLAGS(a0)			; Test BOUNCE Flag
	bne.s	.1
	move.b 	#0,OBJ_FRAME(a0)
	bra.s 	.2
.1
	move.b 	#1,OBJ_FRAME(a0)
.2	
	;-----------------------
	;	GRAVITY
	;-----------------------

	move.b	OBJ_Z(a0),d1
	move.b	OBJ_JUMPHEIGHT(a0),d2
	add.b 	d2,d1		
	move.b	d1,OBJ_Z(a0)
	subq 	#1,d2							
	move.b	d2,OBJ_JUMPHEIGHT(a0)

	;-----------------------	
	;	LAND
	;-----------------------	
	
	tst.b	d1
	bne.s	.3
	move.b 	#11,OBJ_STATE(a0)				; Goto Ground
	move.b 	#0,OBJ_FRAME(a0)			
	move.b	#40,OBJ_TIMER(a0)	
	
	btst 	#FALLKILL,OBJ_FLAGS2(a0)
	bne.s	.4
	bsr.w	PLAY_LAND
	bset	#FALLKILL,OBJ_FLAGS2(a0)
	bra.s .5
.4
	bclr	#FALLKILL,OBJ_FLAGS2(a0)
.5	
	moveq	#0,d0
.3
	;-----------------------
	
PFALLDIR:
	
	;-----------------------

	btst 	#0,OBJ_FLAGS(a0)
	beq.s 	.FallRight
	
	;------------
	; LEFT
	;------------

	btst	#LEFTSTOP,OBJ_STOPS(a0)			; Check LEFTSTOP
	bne.s	.1
	bclr	#RIGHTSTOP,OBJ_STOPS(a0)
	sub.b 	#2,OBJ_S(a0)					; SUB shift value
	cmp.b 	#0,OBJ_S(a0)					; Check for Shift limit on right of frame...
	bgt.s 	.1								; ...If less than, the skip frame move
		sub.b 	#1,OBJ_X(a0)				; Move frame RIGHT BY 16 Pixels		
		move.b 	#15,OBJ_S(a0)				; Reset SHIFT value to '0'
.1	
	bra.s 	.2
	;------------
	; RIGHT
	;------------
.FallRight
	btst	#RIGHTSTOP,OBJ_STOPS(a0)		; Check RIGHTSTOP
	bne.s	.2
	bclr	#LEFTSTOP,OBJ_STOPS(a0)
	add.b 	#2,OBJ_S(a0)					; Add shift value
	cmp.b 	#15,OBJ_S(a0)					; Check for Shift limit on right of frame...
	blt.s 	.2								; ...If less than, the skip frame move
		add.b 	#1,OBJ_X(a0)				; Move frame RIGHT BY 16 Pixels		
		move.b 	#0,OBJ_S(a0)				; Reset SHIFT value to '0'
.2
	
P1FALL_DONE:

;-----------------------------------------------------------------------------------------------------------
;	GROUND: STATE = 11
;-----------------------------------------------------------------------------------------------------------
P1GROUND:
	
	;---------------------------------------
	cmp.b 	#11,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1KNEEL
	;---------------------------------------

	move.b	#0,OBJ_HITCOUNT(a0)
	btst	#7,OBJ_FLAGS(a0)
	bne.s	.1
	move.b 	#$08,OBJ_JUMPHEIGHT(a0)
	move.b 	#0,OBJ_Z(a0)
	move.b 	#10,OBJ_STATE(a0)				; Go to small fall
	bset	#7,OBJ_FLAGS(a0)				; Set Bounce bit
	bra.w	P1_CONTROLS_DONE
.1	
	;-----------------------

	tst.b	OBJ_TIMER(a0)
	bne.s	.2
	

	move.b 	#12,OBJ_STATE(a0)				; Go to Kneel
	move.b 	#0,OBJ_FRAME(a0)	
	move.b	#60,OBJ_TIMER(a0)	
	bclr	#7,OBJ_FLAGS(a0)				; Clear Bounce bit
	
	bra.w	P1_CONTROLS_DONE
	
.2
	;----------------------
	
	sub.b	#1,OBJ_TIMER(a0)				; Sub TIMER
	
	;-----------------------
	
	
P1GROUND_DONE:

;-----------------------------------------------------------------------------------------------------------
;	KNEEL: STATE = 12
;-----------------------------------------------------------------------------------------------------------
P1KNEEL:
	
	;---------------------------------------
	cmp.b 	#12,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1_DEAD
	;---------------------------------------
	
	tst.b	OBJ_TIMER(a0)
	bne.w	.1
	
	;****************************
	btst	#DIE,OBJ_FLAGS2(a0)
	beq.s	.2
	
	sub.b 	#1,OBJ_LIVES(a0)
	
	cmp.b	#0,OBJ_LIVES(a0)
	blt.s	.GameOver
	
	moveq 	#0,d1
	move.b 	#$80,d1
	add.b	(XVIEW+2),d1
	
	
	;move.b 	D1,OBJ_X(a0)
	move.b 	#$D8,OBJ_Y(a0)
	move.b	#$D1,OBJ_Z(a0)

	move.b 	#$78,OBJ_ENERGY(a0)				; Reset Energy
	move.b 	#7,OBJ_STATE(a0)				; Jump state (to fall into screen like the arcade game)
	bclr	#7,OBJ_FLAGS(a0)				; Clear Bounce bit
	bclr	#DIE,OBJ_FLAGS2(a0)
	bsr.w	DRAW_PLAYERHUD
	
	bra.w	P1JUMP	
	
	
.GameOver

	move.b	#13,OBJ_STATE(a0)				; Player 1 Off
	lea 	OBJECT_SLOTS,a0					
	move.b 	#0,(a0)							; Deactivate Player Slot
	bset 	#ALLSTOP,EFLAGS					; STop all enemies from moving
	
	bset	#5,HUDFLAGS2
	move.b	#1,(OBJECT_SLOTS+15)			; Activate GAME OVER text Object

	bra.w	P1_CONTROLS_DONE	
	;****************************
.2
	move.b 	#2,OBJ_STATE(a0)				; Return to STANCE
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#ANIMSPEED_WALK,OBJ_TIMER(a0)
	bclr	#7,OBJ_FLAGS(a0)				; Clear Bounce bit	
	bclr 	#1,OBJ_FLAGS(a0)	
	bclr 	#ALLSTOP,EFLAGS
	bra.s	P1STANCE	
.1
	;----------------------
	sub.b	#1,OBJ_TIMER(a0)				; Sub TIMER
	;-----------------------
	
	
P1KNEEL_DONE:


;-----------------------------------------------------------------------------------------------------------
;	DEAD: STAT is dead/off/deactivated
;-----------------------------------------------------------------------------------------------------------

P1_DEAD:
	;---------------------------------------
	cmp.b 	#13,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1STANCE
	;---------------------------------------
	
P1_DEAD_DONE:

;-----------------------------------------------------------------------------------------------------------
;	STANCE
;-----------------------------------------------------------------------------------------------------------

P1STANCE:

	;---------------------------------------
	cmp.b 	#2,OBJ_STATE(a0)				;CHECK STATE
	bne.w	P1_CONTROLS_DONE
	;---------------------------------------
	btst 	#HITBIT,OBJ_FLAGS(a0)
	beq.s	.3
	add.b 	#1,OBJ_COMBO(a0)
	bclr	#HITBIT,OBJ_FLAGS(a0)
.3

	bclr	#HITBIT,OBJ_FLAGS(a0)
	;----------------------
	; COMBO LIMIT 
	;----------------------
	cmp.b 	#4,OBJ_COMBO(a0)
	blt.s	.2
	move.b	#1,OBJ_COMBO(a0)
	bclr	#HITBIT,OBJ_FLAGS(a0)
.2
	
	move.b 	#0,OBJ_FRAME(a0)	

;----------------------------------------------------------------------------------------------------------
;	DONE
;----------------------------------------------------------------------------------------------------------	
P1_CONTROLS_DONE:
;------------------------------------------		
	movem (sp)+,d0-a6
	RTS
;------------------------------------------		


P_WALKANIM:
	;---------------------------------------
	; ANIMATION
	;---------------------------------------	
	tst.b 	OBJ_TIMER(a0)					; Test TIMER for Animation speed	
	bne.s	.AnimDelay						; If Above 0 then Don't change Frame	
	cmp.b 	#4,OBJ_FRAME(a0)				; FRAME Limit
	ble.s	.Animate						; If TIMER is above zero then keep frame the same	
	move.b 	#0,OBJ_FRAME(a0)				; If FRAME hits 5, reset to zero (6 frame sin walk cycle)
	bra.s 	.AnimateDone	
.Animate	
	add.b 	#1,OBJ_FRAME(a0)				; Increase FRAME number	
.AnimateDone
	move.b 	#ANIMSPEED_WALK,OBJ_TIMER(a0)	; Reset Timer
	bra.s 	.ALLANIMDONE
.AnimDelay	
	sub.b 	#1,OBJ_TIMER(a0)				; Sub TIMER	
.ALLANIMDONE	
	;---------------------------------------	
	RTS
	;---------------------------------------	
	
	
BOUNDARIES:

	;---------------
	; LEFT
	;---------------
	move.b 	OBJ_X(a0),d6
	move.b 	(XVIEW+3),d7
	subq 	#2,d7
	sub.b	d7,d6

	cmp.b	#4,d6
	bgt.s 	.1							; Skip if reached
	bset 	#LEFTSTOP,OBJ_STOPS(a0)
.1
	moveq	#0,d7
	;---------------
	; RIGHT
	;---------------
	move.b 	OBJ_X(a0),d6
	move.b 	(XVIEW+3),d7
	subq 	#2,d7
	sub.b	d7,d6

	cmp.b	#22,d6
	blt.s 	.2							; Skip if reached
	bset 	#RIGHTSTOP,OBJ_STOPS(a0)
	bra.s	.3R
.2
	bclr 	#RIGHTSTOP,OBJ_STOPS(a0)
.3R
	moveq	#0,d7
	;---------------
	; UP
	;---------------
	cmp.b	#$C4,OBJ_Y(a0)
	bgt.s 	.3							; Skip if reached
	bset 	#UPSTOP,OBJ_STOPS(a0)
.3
	moveq	#0,d7
	;---------------
	; DOWN
	;---------------
	cmp.b	#$F0,OBJ_Y(a0)
	blt.s 	.4							; Skip if reached
	bset 	#DOWNSTOP,OBJ_STOPS(a0)
.4
	moveq	#0,d7
	;-----------------------------------
	RTS
	;-----------------------------------

