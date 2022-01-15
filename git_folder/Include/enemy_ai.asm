;-----------------------------------------------------------------------------------------------------------
;	ENEMY AI
;-----------------------------------------------------------------------------------------------------------
;	COMMENT:
;		-	This was a delight as everything was set up, so it's just a case of loading the STATE and 
;			FRAME Bytes in the table.
;				Still not quite sure that using Object tables is the best way. Maybe arrays for X/Y etc.
;			would be better, but using the Offset Names is so convenient.
;-----------------------------------------------------------------------------------------------------------
ENEMY_AI:

	;---------------------------
	btst 	#ALLSTOP,EFLAGS
	beq.s	.AIContinue
	moveq 	#0,d0
	bsr.w	ENEMY_STATE_LOADER
.AIContinue
	;---------------------------

	tst.b	(OBJECT_SLOTS+2)
	beq.s	.1
	lea 	OBJECT_3,a0
	bsr.w	ENEMY_AI_SUB
.1
	tst.b	(OBJECT_SLOTS+3)
	beq.s	.2
	lea 	OBJECT_4,a0
	bsr.w	ENEMY_AI_SUB
.2
	tst.b	(OBJECT_SLOTS+4)
	beq.s	.3
	lea 	OBJECT_5,a0
	bsr.w	ENEMY_AI_SUB
.3
	tst.b	(OBJECT_SLOTS+5)
	beq.s	.4
	lea 	OBJECT_6,a0
	bsr.w	ENEMY_AI_SUB
.4
	tst.b	(OBJECT_SLOTS+6)
	beq.s	.5
	lea 	OBJECT_7,a0
	bsr.w	ENEMY_AI_SUB
.5
	tst.b	(OBJECT_SLOTS+7)
	beq.s	.6
	lea 	OBJECT_8,a0
	bsr.w	ENEMY_AI_SUB
.6
	tst.b	(OBJECT_SLOTS+8)
	beq.s	.7
	lea 	OBJECT_9,a0
	bsr.w	ENEMY_AI_SUB
.7
	tst.b	(OBJECT_SLOTS+9)
	beq.s	.8
	lea 	OBJECT_10,a0
	bsr.w	ENEMY_AI_SUB
.8
	tst.b	(OBJECT_SLOTS+10)
	beq.s	.9
	lea 	OBJECT_11,a0
	bsr.w	ENEMY_AI_SUB
.9
	tst.b	(OBJECT_SLOTS+11)
	beq.s	.10
	lea 	OBJECT_12,a0
	bsr.w	ENEMY_AI_SUB
.10
	RTS

ENEMY_AI_SUB:

	;movem	d0-d3/a0,-(sp)
	


	
;-----------------------------------------------------------------------------------------------------------
; 	ALLSTOP: STATE  = 0 
;		- Stop Everything and just stand still
;-----------------------------------------------------------------------------------------------------------
E_ALLSTOP:
	
	;-----------------------
	cmp.b	#0,OBJ_STATE(a0)
	bne.w	E_STILL
	;-----------------------
	
	
E_ALLSTOP_DONE
;-----------------------------------------------------------------------------------------------------------
; 	DUMMY / STILL: STATE  = 1 (Enemies remain in a sittng or standing state until the player is close)
;-----------------------------------------------------------------------------------------------------------
E_STILL:
	
	;-----------------------
	cmp.b	#1,OBJ_STATE(a0)
	bne.w	E_WAIT
	;-----------------------
	
	bset 	#0,OBJ_FLAGS(a0)
;	move.b 	#2,OBJ_FRAME(a0)
	
	;-----------------------
	
	move.b (OBJECT_1+4),d0			; Player's X
	move.b	OBJ_X(a0),d1			; X
	
	;-----------------------
	sub.b 	#5,d1					; Sub 3
	cmp.b 	d0,d1			
	bgt.s 	.1						; If Player's X is less than X -4 then Stay in this state
	;-----------------------
	
	move.b	#5,OBJ_STATE(a0)		; Go to BACK OFF
	move.b	#6,OBJ_ANIMSPEED(a0)
	bclr 	#0,OBJ_FLAGS(a0)
	add.b	#2,OBJ_Y(a0)			; Add 1 to Y to stop going "behind" other Still enemies (looks bad)
	move.b 	#$40,OBJ_TIMER(a0)
.1
	;-----------------------
	
E_STILL_DONE:
	
;-----------------------------------------------------------------------------------------------------------
; 	WAIT: STATE  = 2
;-----------------------------------------------------------------------------------------------------------
E_WAIT:

	;-----------------------
	cmp.b	#2,OBJ_STATE(a0)
	bne.w	E_WALK
	
	;-----------------------
	; COLLISIONS
	;-----------------------
	bclr 	#HITBIT,OBJ_FLAGS(a0)
	bsr.w	E_COLLISIONS
	;-----------------------
	; XFLIP
	;-----------------------	
	bsr.w	E_XFLIP	
	;-----------------------
		
	tst.b	OBJ_TIMER(a0)
	bne.s	.1
	
	;-----------------------
	; RANDOM CHOOSE (WALK OR BACKOFF)
	;-----------------------
	moveq	#0,d0
	moveq	#0,d1
	move.w	#$0100,d1
	bsr.w	RNG
	;-----------------------

	cmp.w	#$0080,d0
	bgt.s	.2
	move.b	#3,OBJ_STATE(a0)
	bra.s	E_WAIT_DONE
.2
	move.b	#5,OBJ_STATE(a0)
	move.b 	#$50,OBJ_TIMER(a0)
	bra.s	E_WAIT_DONE
.1
	;-----------------------
	
	sub.b	#1,OBJ_TIMER(a0)
	
	;-----------------------
	
	bsr.w	E_ATTACKRANGE
	
E_WAIT_DONE:
	
;-----------------------------------------------------------------------------------------------------------
; 	WALK: STATE  = 3
;-----------------------------------------------------------------------------------------------------------
E_WALK:
	;-----------------------
	cmp.b	#3,OBJ_STATE(a0)
	bne.w	E_CHASE
	;-----------------------	
;WS = 2
ATTACKDISTANCE = $0040
	moveq	#0,d5
.Bred	
	cmp.b 	#4,OBJ_TYPE(a0)
	bgt.s	.J
	moveq 	#2,d5
	bra.s	.WalkSpeedDone
.J
	cmp.b 	#5,OBJ_TYPE(a0)
	bgt.s	.Roxy
	moveq 	#3,d5
	;bra.s	.WalkSpeedDone
.Roxy	
.WalkSpeedDone
	;-----------------------
	; COLLISIONS
	;-----------------------
	bclr 	#HITBIT,OBJ_FLAGS(a0)
	bsr.w	E_COLLISIONS	
	;-----------------
	; 	XFLIP
	;-----------------
	
	bsr.w	E_XFLIP	
	
	;-----------------------
	; 	MOVE
	;-----------------------
E_MOVE:

	;-----------------------
	;	Y
	;-----------------------

E_CHECK_Y:
	move.b 	(OBJECT_1+5),d0
	move.b	d0,d1
	cmp.b	OBJ_Y(a0),d0
	bgt.s	.1
	bsr.w 	E_WALKANIM
	sub.b	#1,OBJ_Y(a0)
.1
	subq 	#2,d1
	cmp.b	OBJ_Y(a0),d1
	blt.s	.2
	bsr.w 	E_WALKANIM
	add.b	#1,OBJ_Y(a0)
.2

	;-----------------------
	;	X
	;-----------------------
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d4	

E_CHECK_X:	
	move.b  (OBJECT_1+4),d0				; Player's X
	lsl.w	#4,d0
	add.b	(OBJECT_1+6),d0				; Add Shift
	
	move.b	OBJ_X(a0),d1				; X
	lsl.w	#4,d1
	add.b	OBJ_S(a0),d1				; Add Shift
	
	;-----------------------
	; RIGHT
	;-----------------------
	move.w	d0,d2					
	sub.w	#ATTACKDISTANCE-4,d0				
	cmp.w 	d0,d1					
	blt.s	.MoveRight
	
	;-----------------------
	; LEFT
	;-----------------------
	move.w	d2,d0						
	add.w	#ATTACKDISTANCE-4,d0					
	cmp.w 	d0,d1
	bgt.s	.MoveLeft

	bra.s	GOTO_EATTACK

	;-----------------------
	
.MoveLeft
	sub.b	d5,OBJ_S(a0)
	cmp.b	#0,OBJ_S(a0)
	bgt.s	.3
	sub.b	#1,OBJ_X(a0)
	move.b 	#15,OBJ_S(a0)
.3	
	bsr.w 	E_WALKANIM
	bra.s	GOTO_EATTACK
	
.MoveRight
	add.b	d5,OBJ_S(a0)
	cmp.b	#15,OBJ_S(a0)
	blt.s	.4
	add.b	#1,OBJ_X(a0)
	move.b 	#0,OBJ_S(a0)
.4
	bsr.w 	E_WALKANIM
	
	;-----------------------
	; ATTACK IF IN RANGE
	;-----------------------
GOTO_EATTACK:

	bsr.w	E_ATTACKRANGE
		
	;-----------------------
	; RANDOM STOP
	;-----------------------
RANDOM_STOP:	
	bsr.w 	INVIEW					; Check if enemy is inside View
	cmp.b 	#2,d1					; If not, then no random stop (keep walking)
	blt.s	E_MOVEDONE
	cmp.b 	#20,d1
	bgt.s	E_MOVEDONE
	;-----------------------
	moveq	#0,d0
	moveq	#0,d1
	move.w	#$0400,d1				; Upper Random Number Generator Limit
	bsr.w	RNG						; Calculate Random Number betaeen 0 and Upper Limit
	;-----------------------
	cmp.w	#$0010,d0				; Set condition value
	bgt.s	.5
	move.b 	#2,OBJ_STATE(a0)
	move.b 	#$20,OBJ_TIMER(a0)
	bra.w	E_BACKOFF
.5
E_MOVEDONE:

;-----------------------------------------------------------------------------------------------------------
; 	CHASE: STATE  = 4
;-----------------------------------------------------------------------------------------------------------
E_CHASE:

	;-----------------------
	cmp.b	#4,OBJ_STATE(a0)
	bne.w	E_BACKOFF
	
	bclr 	#HITBIT,OBJ_FLAGS(a0)
	
E_CHASE_DONE:

;-----------------------------------------------------------------------------------------------------------
; 	BACKOFF: STATE  = 5
;-----------------------------------------------------------------------------------------------------------
E_BACKOFF:

	;-----------------------
	cmp.b	#5,OBJ_STATE(a0)
	bne.w	E_OTHERSIDE
	;-----------------------
	; COLLISIONS
	;-----------------------
	bclr 	#HITBIT,OBJ_FLAGS(a0)
	bsr.w	E_COLLISIONS
	
	;-----------------------
	
	tst.b	OBJ_TIMER(a0)
	bne.s	.1
	move.b	#3,OBJ_STATE(a0)
	bra.s	E_BACKOFF_DONE
.1
	sub.b	#1,OBJ_TIMER(a0)

	;---------------------------------------
	btst 	#0,OBJ_FLAGS(a0)
	bne.s	.2
	add.b 	#1,OBJ_S(a0)					; Add shift value
	cmp.b 	#15,OBJ_S(a0)					; Check for Shift limit on right of frame
	blt.s 	.3								; If less then, the skip frame move
	add.b 	#1,OBJ_X(a0)					; Move RIGHT BY 16 Pixels		
	move.b 	#0,OBJ_S(a0)					; Reset SHIFT value to '0'
	bra.s	.3	
.2
	sub.b 	#1,OBJ_S(a0)					;  Shift value
	cmp.b 	#0,OBJ_S(a0)					; Check for Shift limit on right of frame
	bgt.s 	.3								; If less then, the skip frame move
	sub.b 	#1,OBJ_X(a0)					; Move RIGHT BY 16 Pixels		
	move.b 	#15,OBJ_S(a0)					; Reset SHIFT value to '0'
.3
	;---------------------------------------
	
	bsr.w 	E_WALKANIM
	
	;---------------------------------------
	
	bsr.w 	INVIEW
	cmp.b 	#2,d1
	bgt.s	.4
	move.b	#3,OBJ_STATE(a0)
	bra.s	E_BACKOFF_DONE
.4
	cmp.b 	#20,d1
	blt.s	E_BACKOFF_DONE
	move.b	#3,OBJ_STATE(a0)
	
	;---------------------------------------	
	
E_BACKOFF_DONE:

;-----------------------------------------------------------------------------------------------------------
; 	OTHERSIDE: STATE  = 6
;	- Move to other side of Player(s)
;-----------------------------------------------------------------------------------------------------------
E_OTHERSIDE:

	;---------------------------------------
	cmp.b	#5,OBJ_STATE(a0)
	bne.w	E_ATTACK
	;---------------------------------------
	
	

E_OTHERSIDE_DONE:

;-----------------------------------------------------------------------------------------------------------
; 	ATTACK: STATE  = 7
;-----------------------------------------------------------------------------------------------------------
E_ATTACK:
	;-----------------------
	cmp.b	#7,OBJ_STATE(a0)
	bne.w	E_HITS
	;-----------------------
	

	;-----------------------
	; COLLISIONS
	;-----------------------
	bclr 	#HITBIT,OBJ_FLAGS(a0)
	bsr.w	E_COLLISIONS	
	;-----------------------
	; ANIMATION
	;-----------------------
	tst.b 	OBJ_ANIMSPEED(a0)
	bne.s	.e_SubTimer	
	move.b	#6,OBJ_ANIMSPEED(a0)
	cmp.b 	#2,OBJ_FRAME(a0)
	blt.s	.e_animate
	move.b	#3,OBJ_STATE(a0)
	move.b	#0,OBJ_FRAME(a0)
	bra.w	E_ATTACK_DONE	
.e_animate	
	add.b	#1,OBJ_FRAME(a0)
	bra.w	E_ATTACK_DONE
.e_SubTimer
	sub.b	#1,OBJ_ANIMSPEED(a0)
	

	bsr.w	HITPLAYER

	;-----------------------
E_ATTACK_DONE:

;-----------------------------------------------------------------------------------------------------------
; 	HIT: STATE  = 8
;-----------------------------------------------------------------------------------------------------------
E_HITS:
	;-----------------------
	cmp.b	#8,OBJ_STATE(a0)
	bne.w	E_FALL
	;-----------------------
	; COLLISIONS
	;-----------------------
	
	bsr.w	E_COLLISIONS
	
	;-----------------------
	;	FRAME 						; 0 = HIGH HIT | 1 = LOW HIT
	;-----------------------
	move.b	#1,OBJ_FRAME(a0)
	;-----------------------
	;	TIMER RELEASE
	;-----------------------
	sub.b	#1,OBJ_TIMER(a0)		; Sub TIMER
	tst.b	OBJ_TIMER(a0)
	bne.s	.1
	move.b	#2,OBJ_STATE(a0)		; Return to WALK
	move.b	#0,OBJ_FRAME(a0)		; Reset FRAME
	move.b	#16,OBJ_TIMER(a0)		; Re-load TIMER with WALK value
	bclr 	#1,OBJ_FLAGS(a0)		; Clear SHUDDER flag
	bclr 	#HITBIT,OBJ_FLAGS(a0)
.1
	;-----------------------
	; 	SHUDDER
	;-----------------------
	btst 	#1,OBJ_FLAGS(a0)	; Test SHUDDER flag
	bne.s	.2
	bset 	#1,OBJ_FLAGS(a0)				; Set flag to 1 for next time
	sub.b 	#2,OBJ_S(a0)					;  Shift value
	cmp.b 	#0,OBJ_S(a0)					; Check for Shift limit on right of frame
	bgt.s 	.3								; If less then, the skip frame move
		sub.b 	#1,OBJ_X(a0)					; Move RIGHT BY 16 Pixels		
		move.b 	#15,OBJ_S(a0)					; Reset SHIFT value to '0'
.3
	
	bra.s	E_HITS_DONE
.2
	bclr 	#1,OBJ_FLAGS(a0)	; Set flag to 0 for next time
	add.b 	#2,OBJ_S(a0)					; Add shift value
	cmp.b 	#15,OBJ_S(a0)					; Check for Shift limit on right of frame
	blt.s 	.4								; If less then, the skip frame move
		add.b 	#1,OBJ_X(a0)					; Move RIGHT BY 16 Pixels		
		move.b 	#0,OBJ_S(a0)					; Reset SHIFT value to '0'
		;bra.s	.4	
	
.4
	;-----------------------
E_HITS_DONE:



;-----------------------------------------------------------------------------------------------------------
; 	FALL: STATE  = 10
;-----------------------------------------------------------------------------------------------------------
E_FALL:
	
	;-----------------------
	cmp.b	#10,OBJ_STATE(a0)
	bne.w	E_GROUND
	;-----------------------
	
	bsr.w	FALL
	
	;-----------------------

E_FALL_DONE:	

;-----------------------------------------------------------------------------------------------------------
; 	GROUND: STATE  = 11
;-----------------------------------------------------------------------------------------------------------
E_GROUND:
	
	;-----------------------
	cmp.b	#11,OBJ_STATE(a0)
	bne.w	E_KNEEL
	;-----------------------
	btst	#7,OBJ_FLAGS(a0)
	bne.s	.1
	move.b 	#$08,OBJ_JUMPHEIGHT(a0)
	move.b 	#0,OBJ_Z(a0)
	move.b 	#10,OBJ_STATE(a0)				; Return to WAIT
	bset	#7,OBJ_FLAGS(a0)				; Set Bounce bit
	bra.s	AI_DONE
.1	
	;-----------------------

	tst.b	OBJ_TIMER(a0)
	bne.s	.2
	
	btst	#DIE,OBJ_FLAGS2(a0)
	beq.s	.3
	
	bsr.w 	INSTANCE_DESTROY		
	
	bra.s	AI_DONE	
.3
	move.b 	#12,OBJ_STATE(a0)				; Return to WAIT
	move.b 	#0,OBJ_FRAME(a0)	
	move.b	#60,OBJ_TIMER(a0)	
	bclr	#7,OBJ_FLAGS(a0)				; Clear Bounce bit
	
	
	bra.s	AI_DONE
	
.2
	;----------------------
	
	sub.b	#1,OBJ_TIMER(a0)				; Sub TIMER
	
	;-----------------------
	
E_GROUND_DONE:		

	
;-----------------------------------------------------------------------------------------------------------
; 	KNEEL: STATE  = 11
;-----------------------------------------------------------------------------------------------------------
E_KNEEL:
	
	;-----------------------
	cmp.b	#12,OBJ_STATE(a0)
	bne.w	AI_DONE
	;-----------------------
	
	tst.b	OBJ_TIMER(a0)
	bne.s	.2
	move.b 	#2,OBJ_STATE(a0)				; Return to WAIT
	move.b 	#0,OBJ_FRAME(a0)	
	move.b 	#$20,OBJ_TIMER(a0)
	bclr	#7,OBJ_FLAGS(a0)				; Clear Bounce bit	
	bra.s	AI_DONE
	
.2
	;----------------------
	sub.b	#1,OBJ_TIMER(a0)				; Sub TIMER
	;-----------------------
E_KNEEL_DONE:
	
		
AI_DONE:
	;movem	(sp)+,d0-d3/a0
	;----------------------------------
	RTS
	;----------------------------------
	
	
	
;------------------------------------------------------------------------------------------------------------	
;	ENEMY AI SUBROUTINES
;-----------------------------------------------------------------------------------------------------------

ENEMY_STATE_LOADER:

SL_1:
	tst.b	(OBJECT_SLOTS+2)
	beq.s	SL_2
	lea 	OBJECT_3,a0
	
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1

SL_2:
	tst.b	(OBJECT_SLOTS+3)
	beq.s	SL_3
	lea 	OBJECT_4,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_3:
	tst.b	(OBJECT_SLOTS+4)
	beq.s	SL_4
	lea 	OBJECT_5,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_4:
	tst.b	(OBJECT_SLOTS+5)
	beq.s	SL_5
	lea 	OBJECT_6,a0
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_5:
	tst.b	(OBJECT_SLOTS+6)
	beq.s	SL_6
	lea 	OBJECT_7,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_6:
	tst.b	(OBJECT_SLOTS+7)
	beq.s	SL_7
	lea 	OBJECT_8,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_7:
	tst.b	(OBJECT_SLOTS+8)
	beq.s	SL_8
	lea 	OBJECT_9,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_8:
	tst.b	(OBJECT_SLOTS+9)
	beq.s	SL_9
	lea 	OBJECT_10,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_9:
	tst.b	(OBJECT_SLOTS+10)
	beq.s	SL_10
	lea 	OBJECT_11,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_10:
	tst.b	(OBJECT_SLOTS+11)
	beq.s	SL_11
	lea 	OBJECT_12,a0
	cmp.b 	#1,OBJ_STATE(a0)
	beq.s	.1
	move.b	d0,OBJ_STATE(a0)
.1
SL_11:
	RTS

;---------------------------------------
; XFLIP - FLIP IMAGE BASED ON PLAYER'S X
;---------------------------------------
E_XFLIP:	
	moveq	#0,d0
	moveq	#0,d3
	move.b 	OBJ_X(a0),d0				; Load X (WORD)	
	move.b 	(OBJECT_1+4),d1				; Player's X	
	move.b 	(XVIEW+3),d3				; XVIEW
	sub.b	d3,d0
	sub.b	d3,d1
	
	cmp.b 	d0,d1
	bgt.s	XRIGHT
XLEFT:
	bclr	#0,OBJ_FLAGS(a0)
	bra.s	E_XFLIPDONE
XRIGHT:
	bset	#0,OBJ_FLAGS(a0)	
	;----------------------------------
E_XFLIPDONE:
	RTS
	;----------------------------------
	
;---------------------------------------
; ANIMATE
;---------------------------------------

E_WALKANIM:
	tst.b 	OBJ_ANIMSPEED(a0)
	bne.s	.e_SubTimer	
	move.b	#6,OBJ_ANIMSPEED(a0)
	cmp.b 	#3,OBJ_FRAME(a0)
	blt.s	.e_animate
	move.b	#0,OBJ_FRAME(a0)
	bra.s	E_WALKANIM_DONE	
.e_animate	
	add.b	#1,OBJ_FRAME(a0)
	bra.s	E_WALKANIM_DONE
.e_SubTimer
	sub.b	#1,OBJ_ANIMSPEED(a0)	
	;----------------------------------
E_WALKANIM_DONE:	
	RTS
	;----------------------------------

;---------------------------------------
; 	INVIEW
;	- ONLY RUN WITHIN VISIBLE SCDREEN
;---------------------------------------

INVIEW:
	moveq 	#0,d0
	moveq 	#0,d1
	move.b	(XVIEW+3),d0
	move.b 	OBJ_X(a0),d1
	sub.b 	d0,d1
	;----------------------------------
	RTS
	;----------------------------------
	
;---------------------------------------
; 	FALL CODE (SHARED)
;---------------------------------------
FALL:

	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	
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
	
FALLDIR:
	
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
	;---------------------------------------
	RTS
	;---------------------------------------
	
E_ATTACKRANGE:

	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2

	move.b  (OBJECT_1+4),d0				; Player's X
	lsl.w	#4,d0
	add.b	(OBJECT_1+6),d0				; Add Shift
	move.w	d0,d2
	
	move.b	OBJ_X(a0),d1				; X
	lsl.w	#4,d1
	add.b	OBJ_S(a0),d1				; Add Shift
										; Back up TARGET's X
	;-----------------------
	; LEFT
	;-----------------------
ATTACK_R:
	btst 	#0,OBJ_FLAGS(a0)
	beq.s	ATTACK_L
	sub.w	#ATTACKDISTANCE,d0					
	cmp.w 	d0,d1	
	blt.s	E_ATTACKRANGE_DONE
	bra.s	ATTACK_Y
	
	;-----------------------
	; RIGHT
	;-----------------------
ATTACK_L:
	add.w	#ATTACKDISTANCE,d2					
	cmp.w 	d2,d1
	bgt.s	E_ATTACKRANGE_DONE
	
	;-----------------------
ATTACK_Y:
	move.b 	(OBJECT_1+5),d0
	move.b	d0,d1
	cmp.b	OBJ_Y(a0),d0
	bgt.s	.1
	bra.s	E_ATTACKRANGE_DONE
.1
	subq 	#2,d1
	cmp.b	OBJ_Y(a0),d1
	blt.s	.2
	bra.s	E_ATTACKRANGE_DONE
.2
	move.b	#16,OBJ_ANIMSPEED(a0)
	move.b 	#7,OBJ_STATE(a0)
	move.b 	#0,OBJ_FRAME(a0)
	;-----------------------
E_ATTACKRANGE_DONE:
	RTS
	;-----------------------
	
	
	;-----------------------
	; LAND HIT ON PLAYER
	;-----------------------
HITPLAYER:	

	;----------------------
	; d0 ENEMY X + S
	; d1 ENEMY Y
	; d2 PLAYER X + S
	; d3 PLAYER Y
	;----------------------
	
	cmp.b	#1,OBJ_FRAME(a0)
	bne.w	PHIT_DONE
	
	moveq 	#0,d0
	moveq 	#0,d1
	moveq 	#0,d2
	moveq 	#0,d3
	
	move.b	OBJ_X(a0),d0
	lsl.w	d0
	move.b	OBJ_S(a0),d1
	add.w 	d1,d0				; Enemy X
	
	move.b	OBJ_Y(a0),d1
	
	;-----------------------
	lea 	OBJECT_1,a1
	
	move.b	OBJ_X(a1),d2
	lsl.w	d2
	move.b	OBJ_S(a1),d3
	add.w 	d3,d2				; Player's X
	move.w 	d2,d4				; Backup
	
	move.b	OBJ_Y(a1),d3		; Player's Y
	move 	d3,d5				; Backup
	;-----------------------
	
	add.b 	#4,d3				; Bottom Y Margin
	cmp.b	d3,d1
	bgt.w	PHIT_DONE
	
	sub.b 	#4,d5				; Bottom Y Margin
	cmp.b	d5,d1
	blt.w	PHIT_DONE
	
	btst 	#0,OBJ_FLAGS(a0)
	bne.s	CheckPHITR
	
CheckPHITL:						; Player Facing Right
	;sub.b 	#$10,d4
	cmp.w	d4,d0
	blt.w	PHIT_DONE
	add.w 	#20,d4
	cmp.w	d4,d0
	bgt.w	PHIT_DONE
	;-----------------------
	cmp.b 	#2,OBJ_STATE(a1)				; Is the player in STANCE state?
	beq.s	.HitL
	cmp.b 	#3,OBJ_STATE(a1)				; Is the player in WALK state?
	beq.s	.HitL
	bra.w	PHIT_DONE
.HitL	
	;sub.b 	#1,OBJ_S(a1)
	btst	#0,OBJ_FLAGS(a1)
	bne.s	.3	
	bset	#0,OBJ_FLAGS(a1)
	add.b 	#1,OBJ_X(a1)
.3	
	bra.s	PHIT_IN_MARGIN
	
CheckPHITR:
	;add.b 	#$10,d2
	cmp.b	d2,d0
	bgt.w	PHIT_DONE
	sub.b 	#20,d2
	cmp.b	d2,d0
	blt.w	PHIT_DONE
	;-----------------------
	cmp.b 	#2,OBJ_STATE(a1)				; Is the player in STANCE state?
	beq.s	.HitR
	cmp.b 	#3,OBJ_STATE(a1)				; Is the player in WALK state?
	beq.s	.HitR
	bra.w	PHIT_DONE
.HitR	
	;add.b 	#1,OBJ_S(a1)
	btst	#0,OBJ_FLAGS(a1)
	beq.s	.3	
	bclr	#0,OBJ_FLAGS(a1)
	sub.b 	#1,OBJ_X(a1)
.3	

PHIT_IN_MARGIN:

	bsr.w	PLAY_PUNCH
	sub.b	#8,OBJ_ENERGY(a1)
	
		cmp.b	#0,OBJ_ENERGY(a1)
		bgt.s 	.NotDead
		bset	#DIE,OBJ_FLAGS2(a1)
		move.b	#3,OBJ_HITCOUNT(a1)
.NotDead
	;-----------------------
	movem.l a0-a1,-(sp)
	bsr.w	DRAW_PLAYERHUD
	movem.l (sp)+,a0-a1
	;-----------------------
	add.b 	#1,OBJ_HITCOUNT(a1)
	
	cmp.b	#3,OBJ_HITCOUNT(a1)
	bge.s	.1

	move.b 	#9,OBJ_STATE(a1)				; Send Player to HIT State
	move.b 	#0,OBJ_FRAME(a1)	
	move.b 	#16,OBJ_TIMER(a1)	
	bra.s  .2
.1
	move.b	#16,OBJ_JUMPHEIGHT(a1)
	move.b 	#10,OBJ_STATE(a1)				; Fall if Hitcount is 3
	move.b	#0,OBJ_HITCOUNT(a1)
.2


	bset	#1,OBJ_FLAGS(a1)				; Lock Player Controls
	move.w	OBJ_X(a1),(FX_XY)
	move.b	#$D0,(FX_Z)
	bsr.w	FX_ACTIVATE	
	
PHIT_DONE:
	;---------------------------------------
	RTS
	;---------------------------------------

;------------------------------------------------------------------------------------------------------
;	COLLISION SUBS
;------------------------------------------------------------------------------------------------------

E_COLLISIONS:
	bsr.w	COL_STATECHECK
	RTS

	
COL_STATECHECK:
	;---------------------------
	; 	a0 is the VICTIM Object 	(Running the code)
	; 	a1 is the ATTACKING Object	
	;---------------------------
	;	d0 -	add Attackdistance
	;	d1 -	sub Attackdistance
	;	d2 - 	Attacker 	X
	;	d3 -	Victim 		X
	; 	d5 - 	Hitpause Value  
	;---------------------------
	
	
	;---------------------------
	; HITPAUSE VALUES				; Small Pause when collision is made to increase feel of Impact
	;---------------------------
	
COMBOPAUSE 			= 2	
SPECIALPAUSE 		= 6
FLYINGKICKPAUSE 	= 6

Z_SPECIALFX			= $B0
Z_COMBOFX			= $88

	;---------------------------
	lea 	OBJECT_1,a1
	;-----------------------
	cmp.b	#4,OBJ_STATE(a1)					; Check if ATTACK State is active
	bne.w	COL_FLYINGKICK
	btst 	#HITBIT,OBJ_FLAGS(a0)
	bne.w	COL_STATECHECK_DONE
	;-----------------------
	move.w	#$55,OBJ_ATTACKDISTX(a1)	
	;move.b	#12,OBJ_ATTACKDISTY(a1)
	;-------------------------------------------
COMBO1:
	;-----------------------
	cmp.b 	#1,OBJ_COMBO(a1)					; Check COMBO value
	bgt.w	COMBO2
	;-----------------------
		cmp.b	#1,OBJ_FRAME(a1)				; Check FRAME value
		bne.w	COL_STATECHECK_DONE
		;----------------------	
		bsr.w	CHECK_YMARGINS					; Check Y Margin & Calculate X Margin Values
		btst	#COLSKIP,OBJ_FLAGS2(a0)
		beq.s	.Hitmade
		bra.w	OUTSIDE_MARGINS
.Hitmade
		;----------------------			
		btst 	#0,OBJ_FLAGS(a1)				; Test Player XFLip
		bne.s 	.Right
.Left
		add.w 	#32,d2
		cmp.w	d2,d3							; Margin R (at Player's X)
		bgt.w	OUTSIDE_MARGINS
		cmp.w	d1,d3							; Margin L (at Player's X - Attackdistance)
		blt.w	OUTSIDE_MARGINS
			bset 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------	
			bset 	#HITBIT,OBJ_FLAGS(a1)		; Set HITBIT flag PLAYER	
			move.b	#COMBOPAUSE,d5			
			bsr.w	GOTO_HIT	
			bsr.w	PLAY_PUNCH	
			
			move.w	OBJ_X(a0),(FX_XY)
			move.b	OBJ_S(a0),(FX_S)
			move.b	#Z_COMBOFX,(FX_Z)
			bsr.w	FX_ACTIVATE
			;----------------------	
			bra.w	INSIDE_MARGINS
.Right	

		sub.w 	#32,d2
		cmp.w	d2,d3							; Margin L (at Player's X)
		blt.w	OUTSIDE_MARGINS					; If VICTIM X < ATTAKER X = Outside Margin
		cmp.w	d0,d3							; Margin R (at Player's X + Attackdistance)
		bgt.w	OUTSIDE_MARGINS					; If VICTIM X > ATTAKER X + ATTACKDISTANCE = Outside Margin
			bclr 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------	
			move.b	#COMBOPAUSE,d5		
			bset 	#HITBIT,OBJ_FLAGS(a1)		; Set HITBIT flag PLAYER			
			bsr.w	GOTO_HIT	
			bsr.w	PLAY_PUNCH
			
			move.w	OBJ_X(a0),(FX_XY)
			move.b	OBJ_S(a0),(FX_S)
			move.b	#Z_COMBOFX,(FX_Z)
			bsr.w	FX_ACTIVATE
			;----------------------		
			bra.w	INSIDE_MARGINS				; Set HITBIT and Exit
			
	;-------------------------------------------
	
COMBO2:
	;-----------------------
	cmp.b 	#2,OBJ_COMBO(a1)
	bgt.w	COMBO3
	;-----------------------
		cmp.b	#1,OBJ_FRAME(a1)				; Check FRAME value
		bne.w	COL_STATECHECK_DONE
		;----------------------	
		bsr.w	CHECK_YMARGINS					; Check Y Margin & Calculate X Margin Values
		btst	#COLSKIP,OBJ_FLAGS2(a0)
		beq.s	.Hitmade
		bra.w	OUTSIDE_MARGINS
.Hitmade
		;----------------------			
		btst 	#0,OBJ_FLAGS(a1)				; Test Player XFLip
		bne.s 	.Right
.Left
		add.w 	#32,d2
		cmp.w	d2,d3							; Margin R (at Player's X)
		bgt.w	OUTSIDE_MARGINS
		cmp.w	d1,d3							; Margin L (at Player's X - Attackdistance)
		blt.w	OUTSIDE_MARGINS
			bset 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------		
			move.b	#COMBOPAUSE,d5		
			bset 	#HITBIT,OBJ_FLAGS(a1)		; Set HITBIT flag PLAYER			
			bsr.w	GOTO_HIT	
			bsr.w	PLAY_PUNCH	
			
			move.w	OBJ_X(a0),(FX_XY)
			move.b	#Z_COMBOFX,(FX_Z)
			bsr.w	FX_ACTIVATE
			;----------------------	
			bra.w	INSIDE_MARGINS
.Right
		sub.w 	#32,d2
		cmp.w	d2,d3							; Margin L (at Player's X)
		blt.w	OUTSIDE_MARGINS
		cmp.w	d0,d3							; Margin R (at Player's X + Attackdistance)
		bgt.w	OUTSIDE_MARGINS
			bclr 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------	
			move.b	#COMBOPAUSE,d5	
			bset 	#HITBIT,OBJ_FLAGS(a1)		; Set HITBIT flag PLAYER			
			bsr.w	GOTO_HIT	
			bsr.w	PLAY_PUNCH
			
			move.w	OBJ_X(a0),(FX_XY)
			move.b	#Z_COMBOFX,(FX_Z)
			bsr.w	FX_ACTIVATE
			;----------------------		
			bra.w	INSIDE_MARGINS
	;-------------------------------------------
COMBO3:
	;-----------------------
	cmp.b 	#3,OBJ_COMBO(a1)
	bne.w	COL_STATECHECK_DONE
	;-----------------------
		cmp.b	#2,OBJ_FRAME(a1)
		bne.w	COL_STATECHECK_DONE
		;----------------------	
		bsr.w	CHECK_YMARGINS					; Check Y Margin & Calculate X Margin Values
		btst	#COLSKIP,OBJ_FLAGS2(a0)
		beq.s	.Hitmade
		bra.w	OUTSIDE_MARGINS
.Hitmade
		;----------------------				
		btst 	#0,OBJ_FLAGS(a1)				; Test Player XFLip
		bne.s 	.Right
.Left
		add.w 	#32,d2
		cmp.w	d2,d3							; Margin R (at Player's X)
		bgt.w	OUTSIDE_MARGINS
		cmp.w	d1,d3							; Margin L (at Player's X - Attackdistance)
		blt.w	OUTSIDE_MARGINS
			bset 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------	
			move.b	#COMBOPAUSE,d5	
			bset 	#HITBIT,OBJ_FLAGS(a1)		; Set HITBIT flag PLAYER
			bsr.w	GOTO_FALL	
			;bsr.w	PLAY_CODYUPPER	
			bsr.w	PLAY_HAGGAR_HAMMER	
			
			move.w	OBJ_X(a0),(FX_XY)
			move.b	#Z_COMBOFX,(FX_Z)
			bsr.w	FX_ACTIVATE	
			;----------------------	
			bra.w	INSIDE_MARGINS
.Right
		sub.w 	#32,d2
		cmp.w	d2,d3							; Margin L (at Player's X)
		blt.w	OUTSIDE_MARGINS
		cmp.w	d0,d3							; Margin R (at Player's X + Attackdistance)
		bgt.w	OUTSIDE_MARGINS
			bclr 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------	
			move.b	#COMBOPAUSE,d5	
			bset 	#HITBIT,OBJ_FLAGS(a1)		; Set HITBIT flag PLAYER
			bsr.w	GOTO_FALL					; Reaction Tyoe
			;bsr.w	PLAY_CODYUPPER	
			bsr.w	PLAY_HAGGAR_HAMMER	
			
			move.w	OBJ_X(a0),(FX_XY)
			move.b	#Z_COMBOFX,(FX_Z)
			bsr.w	FX_ACTIVATE			
			;----------------------		
			bra.w	INSIDE_MARGINS				; Set HITBIT and clear COLSKIP
	;-------------------------------------------

	;-------------------------------------------
	
COL_FLYINGKICK:
	;------------------------
	cmp.b	#7,OBJ_STATE(a1)
	bne.w	COL_SPECIAL
	;-----------------------
	move.w	#$50,OBJ_ATTACKDISTX(a1)
	;move.b	#12,OBJ_ATTACKDISTY(a1)
	;-----------------------
	cmp.b	#3,OBJ_FRAME(a1)
	bne.w	COL_STATECHECK_DONE
		move.b 	#1,OBJ_COMBO(a1)
		;----------------------	
		bsr.w	CHECK_YMARGINS					; Check Y Margin & Calculate X Margin Values
		btst	#COLSKIP,OBJ_FLAGS2(a0)
		beq.s	.Hitmade
		bra.w	OUTSIDE_MARGINS
.Hitmade
		;----------------------			
		btst 	#0,OBJ_FLAGS(a1)				; Test Player XFLip
		bne.s 	.Right
.Left
		add.w 	#32,d2
		cmp.w	d2,d3							; Margin R (at Player's X)
		bgt.w	OUTSIDE_MARGINS
		cmp.w	d1,d3							; Margin L (at Player's X - Attackdistance)
		blt.w	OUTSIDE_MARGINS
			bset 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------		
			move.b	#FLYINGKICKPAUSE,d5	
			bsr.w	GOTO_FALL		
			bsr.w	PLAY_HARDHIT
			move.w	OBJ_X(a0),(FX_XY)
			move.b	#$D0,(FX_Z)
			bsr.w	FX_ACTIVATE
			;sub.b	#4,OBJ_ENERGY(a0)
			;----------------------	
			bra.w	INSIDE_MARGINS	
.Right
		sub.w 	#32,d2
		cmp.w	d2,d3							; Margin L (at Player's X)
		blt.w	OUTSIDE_MARGINS
		cmp.w	d0,d3							; Margin R (at Player's X + Attackdistance)
		bgt.w	OUTSIDE_MARGINS
			bclr 	#0,OBJ_FLAGS(a0)			; Face left if hit from the Right
			;----------------------	
			move.b	#FLYINGKICKPAUSE,d5	
			bsr.w	GOTO_FALL					; Reaction Tyoe
			bsr.w	PLAY_HARDHIT
			move.w	OBJ_X(a0),(FX_XY)
			move.b	#$D0,(FX_Z)
			bsr.w	FX_ACTIVATE
			;sub.b	#4,OBJ_ENERGY(a0)
			;----------------------		
			bra.w	INSIDE_MARGINS				; Set HITBIT and clear COLSKIP
	;-------------------------------------------
	
COL_SPECIAL:
	;-----------------------
	cmp.b	#5,OBJ_STATE(a1)
	bne.w	COL_STATECHECK_DONE
	;-----------------------
	move.b 	#1,OBJ_COMBO(a1)
	move.w	#$60,OBJ_ATTACKDISTX(a1)
	;move.b	#16,OBJ_ATTACKDISTY(a1)
		;----------------------	
		bsr.w	CHECK_YMARGINS					; Check Y Margin & Calculate X Margin Values
		btst	#COLSKIP,OBJ_FLAGS2(a0)
		beq.s	.Hitmade
		bra.w	OUTSIDE_MARGINS
.Hitmade
		;----------------------		
		btst 	#0,OBJ_FLAGS(a1)				; Test Player XFLip
		bne.w 	.Right
.Left
	;----------------------	
	; FRONT HIT
	;----------------------
	cmp.w	d2,d3							; Margin L (at Player's X)
	cmp.w	d2,d3							; Margin L (at Player's X)
	bgt.w	.Special_BackL
	cmp.w	d1,d3							; Margin R (at Player's X - Attackdistance)
	blt.w	.Special_BackL

		cmp.b	#2,OBJ_FRAME(a1)
		bne.s	.1
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		bra.w	INSIDE_MARGINS	
.1
		cmp.b	#6,OBJ_FRAME(a1)
		bne.w	COL_STATECHECK_DONE
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH	
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE

		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------
		bra.w	INSIDE_MARGINS	
	;----------------------	
	; BACK HIT
	;----------------------
.Special_BackL
	cmp.w	d2,d3							; Margin L (at Player's X)
	blt.w	OUTSIDE_MARGINS
	cmp.w	d0,d3							; Margin R (at Player's X + Attackdistance)
	bgt.w	OUTSIDE_MARGINS
		cmp.b	#4,OBJ_FRAME(a1)
		bne.s	.2
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------
		bra.w	INSIDE_MARGINS	
.2
		cmp.b	#8,OBJ_FRAME(a1)
		bne.w	COL_STATECHECK_DONE
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH	
		
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------
		bra.w	INSIDE_MARGINS	
	;-------------------------------------------
.Right
	;----------------------	
	; FRONT HIT
	;----------------------
	cmp.w	d2,d3							; Margin L (at Player's X)
	blt.w	.Special_BackR
	cmp.w	d0,d3							; Margin R (at Player's X + Attackdistance)
	bgt.w	.Special_BackR
		cmp.b	#2,OBJ_FRAME(a1)
		bne.s	.3
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------)
		bra.w	INSIDE_MARGINS	
.3
		cmp.b	#6,OBJ_FRAME(a1)
		bne.w	COL_STATECHECK_DONE
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH	
		
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------
		bra.w	INSIDE_MARGINS	
	;----------------------	
	; BACK HIT
	;----------------------
.Special_BackR
	cmp.w	d2,d3							; Margin L (at Player's X)
	bgt.w	OUTSIDE_MARGINS
	cmp.w	d1,d3							; Margin R (at Player's X - Attackdistance)
	blt.w	OUTSIDE_MARGINS
		cmp.b	#4,OBJ_FRAME(a1)
		bne.s	.4
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------
		bra.w	INSIDE_MARGINS	
.4
		cmp.b	#8,OBJ_FRAME(a1)
		bne.w	COL_STATECHECK_DONE
		move.b	#SPECIALPAUSE,d5
		bsr.w	GOTO_FALL
		bsr.w	PLAY_PUNCH	
		
		move.w	OBJ_X(a0),(FX_XY)
		move.b	OBJ_S(a0),(FX_S)
		move.b	#Z_SPECIALFX,(FX_Z)
		bsr.w	FX_ACTIVATE
		;-----------------------
		sub.b	#4,OBJ_ENERGY(a1)
		movem.l a0-a1,-(sp)
		bsr.w	DRAW_PLAYERHUD
		movem.l (sp)+,a0-a1
		;-----------------------
		bra.w	INSIDE_MARGINS	
	;-------------------------------------------
	
INSIDE_MARGINS:			
		
		;---------------------
		; HUD DISPLAY ACTIVATE
		;---------------------
		sub.b	#8,OBJ_ENERGY(a0)
		move.b 	#$A0,(HUDTIMERS)
		bset 	#5,HUDFLAGS
		bsr.w	DRAW_ENEMYHUD
		;---------------------

		bset 	#HITPAUSE,OBJ_FLAGS2(a1)	; Set HITBIT flag PLAYER
		move.b	d5,OBJ_TIMER2(a1)			; Set HITPAUSE Timer
		bset 	#HITBIT,OBJ_FLAGS(a0)		; Set HITBIT flag ENEMY	
		;bsr HUD_ENEMY_ENERGY
		;---------------------
		; DIE
		;---------------------
		cmp.b	#0,OBJ_ENERGY(a0)
		bgt.s 	.1
		bset	#DIE,OBJ_FLAGS2(a0)
		bsr.w	GOTO_FALL
.1
		;----------------
		;bra.s	COL_STATECHECK_DONE
OUTSIDE_MARGINS:
		bclr 	#COLSKIP,OBJ_FLAGS2(a0)		; Clear COLSKIP Flag
		;bra.s	COL_STATECHECK_DONE			; Done
			
	;-------------------------------------------	
COL_STATECHECK_DONE:
	RTS

;-----------------------------------------------------------------------------------------------------------
;	CHECK Y MARGIN & CALCULATE X VALUES
;-----------------------------------------------------------------------------------------------------------	
CHECK_YMARGINS:
	;---------------------------
	;	CHECK Y MARGIN
	;---------------------------
CHECK_YMARGIN:	
	moveq	#0,d0
	moveq	#0,d1

	move.b	OBJ_Y(a1),d0
	move.b	d0,d1	
	;-------------
	sub.b 	#16,d0
	add.b 	#16,d1
	;-------------
	cmp.b 	OBJ_Y(a0),d0
	bgt.s	SET_COLSKIP
	cmp.b 	OBJ_Y(a0),d1
	blt.s	SET_COLSKIP
CHECK_XMARGIN:	
	;---------------------------
	;	CALCULATE X VALUES
	;----------------------------	
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	move.b	OBJ_X(a1),d0
	lsl.w	#4,d0
	move.b 	OBJ_S(a1),d1
	add.w	d1,d0
	move.w	d0,d1
	move.w	d0,d2
	;---------------------------
	moveq	#0,d3
	moveq	#0,d4
	move.b	OBJ_X(a0),d3
	lsl.w	#4,d3
	move.b 	OBJ_S(a0),d4
	add.w 	d4,d3	
	;---------------------------
	; SET ATTACK DISTANCE
	;---------------------------
	add.w 	OBJ_ATTACKDISTX(a1),d0
	sub.w 	OBJ_ATTACKDISTX(a1),d1
	;---------------------------
	bra.s	CHECKY_DONE
SET_COLSKIP:
	bset 	#COLSKIP,OBJ_FLAGS2(a0)
CHECKY_DONE:
	RTS


;-----------------------------------------------------------------------------------------------------------
;	COLLISON TYPE (HIGH HIT, LOW HIT, OR FALL)
;-----------------------------------------------------------------------------------------------------------

;----------------------------------
GOTO_HIT:
	move.b	#8,OBJ_STATE(a0)	
	move.b	#20,OBJ_TIMER(a0)
	move.b 	#100,(COMBO_RESET)
	RTS
;----------------------------------
GOTO_FALL:
	
	move.b	#10,OBJ_STATE(a0)	
	move.b	#16,OBJ_JUMPHEIGHT(a0)
	RTS
;----------------------------------


;----------------------------------------------------------------------------------------------------------

INSTANCE_CREATE:

	;-----------------------------
	; d1 = Object Type 		- What type of enemy are we creating?
	; d2 = Object XY		- Where to put it?
	; d3 = Object ID Count 	- Number for ID
	; D4 = Object's STATE	- Pick whjether they are waiting in a dummy state, or just walk on screen
	; D5 = Object's FRAME	- For choosing dummy state type (Sitting, Standing, crouching)
	;-----------------------------
	
	;----------------------------------
	; FIND SLOT
	;----------------------------------
	moveq 	#2,d3			
	;---------------
	lea 	OBJECT_SLOTS,a2
	addq 	#2,a2
	;---------------
.FindSlot
	addq	#1,d3
	tst.b	(a2)+
	bne.s	.FindSlot
	sub		#1,a2
	move.b	#1,(a2)
	;----------------------------------
	; GET OBJECT INFO
	;----------------------------------
	move.b 	d3,(OBJECT_ID)				; D3 Now free
	bsr.w	LOAD_OBJECT_TABLE
	;----------------------------------
	move.b 	d1,OBJ_TYPE(a0)

	move.w 	d2,OBJ_X(a0)
	moveq 	#0,d3
	move.b	(XVIEW+3),d3
	add.b	d3,OBJ_X(a0)				; Relative to scren pos
	
	move.b 	d4,OBJ_STATE(a0)
	move.b 	d5,OBJ_FRAME(a0)
	
	add.b 	#1,(OBJECT_ENEMIES)
	;----------------------------------
	RTS
	;----------------------------------
	
INSTANCE_DESTROY:

	movem.l 	d0/a2,-(sp)
	;----------------------------------
	lea 	OBJECT_SLOTS,a2		
	moveq 	#0,d0
	move.b	OBJ_NUMBER(a0),d0	
	add		d0,a2
	sub 	#1,a2
	move.b	#0,(a2)
	move.b	#$78,OBJ_ENERGY(a0)				; Reset energy
	move.b 	#0,OBJ_FLAGS(a0)				; Clear All flags
	move.b 	#0,OBJ_FLAGS2(a0)
	move.b	#6,OBJ_ANIMSPEED(a0)
	;sub.b 	#1,(OBJECT_NUMBER_OF)
	sub.b 	#1,(OBJECT_ENEMIES)
	;----------------------------------
	movem.l 	(sp)+,d0/a2
	;----------------------------------
	RTS
	;----------------------------------