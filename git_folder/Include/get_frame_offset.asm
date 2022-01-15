;-----------------------------------------------------------------------------------------------------------
; 		FIND AND GET FRAME FOR ANIMATIONS
;-----------------------------------------------------------------------------------------------------------

GET_FRAME_OFFSET:

;------------------------------------------------
; 	D1 Holds OBJECT TYPE (Which Character)
; 	Compare to jump to correct animation offsets
;------------------------------------------------

; HAGGAR
	cmp.b 	#3,d1
	beq.w 	HAGGAR_STATE_OFFSET

; BRED
	cmp.b 	#4,d1
	beq.w 	BRED_STATE_OFFSET
	
; J
	cmp.b 	#5,d1
	beq.w 	J_STATE_OFFSET
	
; HITSPARK
	cmp.b 	#22,d1
	beq.w 	HITSPARK_STATE_OFFSET
	
; GAMEOVER
	cmp.b 	#26,d1
	beq.w 	GAMEOVER_STATE_OFFSET

;------------------------------------------------
; 	LOAD STATE
;------------------------------------------------

HAGGAR_STATE_OFFSET:
	
	; ALLSTOP
	cmp.b 	#0,d2
	bne.s 	.0
	bra.w	HAGGAR_FRAME_STANCE
	RTS
.0
	; DUMMY
	cmp.b 	#1,d2
	bne.s 	.1
	bra.w	HAGGAR_FRAME_WALK
	RTS
.1	; STANCE
	cmp.b 	#2,d2
	bgt.s 	.2
	bra.w 	HAGGAR_FRAME_STANCE
	RTS
.2	; WALK
	cmp.b 	#3,d2
	bne.s 	.3
	bra.w	HAGGAR_FRAME_WALK
	RTS
.3	; PUNCH
	cmp.b 	#4,d2
	bgt.s 	.4
	cmp.b	#3,OBJ_COMBO(a0)
	blt.s	.Combo1
	bra.w 	HAGGAR_FRAME_COMBO3
.Combo1
	bra.w 	HAGGAR_FRAME_COMBO1
.ComboDone
	RTS
.4	; SPECIAL MOVE
	cmp.b 	#5,d2
	bgt.s 	.5
	bra.w 	 HAGGAR_FRAME_SPECIAL
	RTS
.5	; JUMP
	cmp.b 	#7,d2
	bgt.s 	.6
	bra.w 	 HAGGAR_FRAME_JUMP
	RTS
.6	; FLYINGKICK
	cmp.b 	#8,d2
	bgt.s 	.7
	bra.w 	 HAGGAR_FRAME_JUMP
	RTS
.7	; HIT
	cmp.b 	#9,d2
	bgt.s 	.8
	bra.w 	 HAGGAR_FRAME_HIT
	RTS
.8	; FALL
	cmp.b 	#10,d2
	bgt.s 	.9
	bra.w 	 HAGGAR_FRAME_FALL
	RTS
.9
	; GROUND
	cmp.b 	#11,d2
	bgt.s 	.10
	bra.w 	 HAGGAR_FRAME_KNEEL
	RTS
.10
	; KNEEL
	cmp.b 	#12,d2
	bgt.s 	.11
	bra.w 	 HAGGAR_FRAME_KNEEL
	RTS
.11
	; DEAD
;	cmp.b 	#13,d2
;	bgt.s 	.12
;	bra.w 	 HAGGAR_FRAME_KNEEL
	RTS
	; ----------------------------------
	RTS
	; ----------------------------------
	
;-------------------------------------------------------------------------
;	LOAD FRAME
;-------------------------------------------------------------------------

HAGGAR_FRAME_OFFSET:

HAGGAR_FRAME_STANCE:	

	lea		HAGGAR_STANCE,a3
	RTS

HAGGAR_FRAME_WALK:

	tst.b	d3
	bgt.s	.1
	lea		HAGGAR_WALK_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		HAGGAR_WALK_1,a3
	RTS
.2	
	cmp.b	#2,d3
	bgt.s	.3
	lea		HAGGAR_WALK_2,a3
	RTS
.3	
	cmp.b	#3,d3
	bgt.s	.4
	lea		HAGGAR_WALK_3,a3
	RTS
.4	
	cmp.b	#4,d3
	bgt.s	.5
	lea		HAGGAR_WALK_4,a3
	RTS
.5	
	lea		HAGGAR_WALK_5,a3
	RTS
	
;----------------------------------------------------------

HAGGAR_FRAME_COMBO1:

	tst.b	d3
	bgt.s	.1
	lea		HAGGAR_PUNCH_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		HAGGAR_PUNCH_1,a3
	RTS
.2	
;	cmp.b	#2,d3
;	bgt.s	.3
	lea		HAGGAR_PUNCH_0,a3
;.3
	RTS
	
HAGGAR_FRAME_COMBO3:

	tst.b	d3
	bgt.s	.1
	lea		HAGGAR_COMBO3_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		HAGGAR_COMBO3_1,a3
	RTS
.2
	cmp.b	#2,d3
	bgt.s	.3
	lea		HAGGAR_COMBO3_2,a3
	RTS
.3
	cmp.b	#3,d3
	bgt.s	.4
	lea		HAGGAR_COMBO3_3,a3
	RTS
.4
	lea		HAGGAR_COMBO3_3,a3
	RTS


HAGGAR_FRAME_SPECIAL:

	tst.b	d3
	bgt.s	.1
	lea		HAGGAR_SPECIAL_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		HAGGAR_SPECIAL_1,a3
	RTS
.2	
	cmp.b	#2,d3
	bgt.s	.3
	lea		HAGGAR_SPECIAL_2,a3
	RTS
.3	
	cmp.b	#3,d3
	bgt.s	.4
	lea		HAGGAR_SPECIAL_3,a3
	RTS
.4
	cmp.b	#4,d3
	bgt.s	.5
	lea		HAGGAR_SPECIAL_4,a3
	RTS
.5
	cmp.b	#5,d3
	bgt.s	.6
	lea		HAGGAR_SPECIAL_1,a3
	RTS
.6	
	cmp.b	#6,d3
	bgt.s	.7
	lea		HAGGAR_SPECIAL_2,a3
	RTS
.7
	cmp.b	#7,d3
	bgt.s	.8
	lea		HAGGAR_SPECIAL_3,a3
	RTS
.8	
	lea		HAGGAR_SPECIAL_4,a3
	RTS

;----------------------------------------------------------
	
HAGGAR_FRAME_JUMP:

	tst.b	d3
	bgt.s	.1
	lea		HAGGAR_JUMP_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		HAGGAR_JUMP_1,a3
	RTS
.2	
	cmp.b	#2,d3
	bgt.s	.3
	lea		HAGGAR_FKICK_0,a3
	RTS
.3
	lea		HAGGAR_FKICK_1,a3	
	RTS
	
HAGGAR_FRAME_HIT:

	tst.b	d3
	bgt.s	.1
	lea		HAGGAR_HIT_HIGH,a3
	RTS
.1
	lea		HAGGAR_HIT_LOW,a3
	RTS
	
HAGGAR_FRAME_FALL:
	cmp.b	#0,d3
	bgt.s	.1
	lea		HAGGAR_FKICK_0,a3
	RTS
.1	
;	cmp.b	#1,d3
;	bgt.s	.2
	lea		HAGGAR_KNEEL,a3
	RTS
;.2
	
HAGGAR_FRAME_KNEEL:
	lea		HAGGAR_KNEEL,a3
	RTS
	
;----------------------------------------------------------------------------------------------------------
; BRED LOAD STATE
;----------------------------------------------------------------------------------------------------------

BRED_STATE_OFFSET:


	; ALLSTOP
	cmp.b 	#0,d2
	bgt.s 	.0
	bra.w 	BRED_FRAME_WALK
	RTS
.0	; STILL
	cmp.b 	#1,d2
	bgt.s 	.1
	bra.w 	BRED_FRAME_STILL
	RTS
.1	; WAIT
	cmp.b 	#2,d2
	bgt.s 	.2
	bra.w 	BRED_FRAME_WALK
	RTS
.2	; WALK
	cmp.b 	#3,d2
	bgt.s 	.3
	bra.w	BRED_FRAME_WALK
	RTS
.3	; CHASE
	cmp.b 	#4,d2
	bgt.s 	.4
	bra.w	BRED_FRAME_WALK
	RTS
.4	; BACKOFF
	cmp.b 	#5,d2
	bgt.s 	.5
	bra.w	BRED_FRAME_WALK
	RTS
.5	; OTHERSIDE
	cmp.b 	#6,d2
	bgt.s 	.6
	bra.w	BRED_FRAME_WALK
	RTS
.6	; ATTACK
	cmp.b 	#7,d2
	bgt.s 	.7
	bra.w	BRED_FRAME_ATTACK
	RTS
.7	; HITS
	cmp.b 	#8,d2
	bgt.s 	.8
	bra.w	BRED_FRAME_HITS
	RTS		
.8	; GRAB
	cmp.b 	#9,d2
	bgt.s 	.9
	bra.w	BRED_FRAME_FALL
	RTS
.9	; FALL
	cmp.b 	#10,d2
	bgt.s 	.10
	bra.w	BRED_FRAME_FALL
	RTS
.10	; GROUND
	cmp.b 	#11,d2
	bgt.s 	.11
	bra.w	BRED_FRAME_GROUND
	RTS
.11	; KNEEL
	cmp.b 	#12,d2
	bgt.s 	.12
	bra.w	BRED_FRAME_KNEEL
	RTS
.12
	RTS

	; ----------------------
	RTS
	; ----------------------
	
;-------------------------------------------------------------------------
;	BRED LOAD FRAME
;-------------------------------------------------------------------------

BRED_FRAME_OFFSET:

BRED_FRAME_STILL:

	tst.b	d3
	bne.s	.1
	lea		BRED_STILL_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		BRED_STILL_1,a3
	RTS
.2	
;	cmp.b	#2,d3
;	bgt.s	.3
	lea		BRED_STILL_2,a3
	RTS


BRED_FRAME_WALK:

	tst.b	d3
	bne.s	.1
	lea		BRED_WALK_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		BRED_WALK_1,a3
	RTS
.2	
	cmp.b	#2,d3
	bgt.s	.3
	lea		BRED_WALK_2,a3
	RTS
.3	
;	cmp.b	#3,d3
;	bgt.s	.4
	lea		BRED_WALK_1,a3
	RTS
.4
	;RTS
	
BRED_FRAME_ATTACK:
	cmp.b	#0,d3
	bgt.s	.1
	lea		BRED_ATTACK1,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		BRED_ATTACK2,a3
	RTS
.2
	lea		BRED_ATTACK1,a3
	RTS
	
BRED_FRAME_HITS:
	cmp.b	#0,d3
	bgt.s	.1
	lea		BRED_HIT_HIGH,a3
	RTS
.1
;	cmp.b	#1,d3
;	bgt.s	.2
	lea		BRED_HIT_LOW,a3
	RTS
;.2

BRED_FRAME_FALL:
	cmp.b	#0,d3
	bgt.s	.1
	lea		BRED_FALL,a3
	RTS
.1	
	cmp.b	#1,d3
	bgt.s	.2
	lea		BRED_GROUND,a3
	RTS
.2
	
	
BRED_FRAME_GROUND:
	lea		BRED_GROUND,a3
	RTS
	
BRED_FRAME_KNEEL:
	lea		BRED_KNEEL,a3
	RTS

;----------------------------------------------------------------------------------------------------------
; J LOAD STATE
;----------------------------------------------------------------------------------------------------------

J_STATE_OFFSET:

	; ALLSTOP
	cmp.b 	#0,d2
	bgt.s 	.0
	bra.w 	J_FRAME_WALK
	RTS
.0	; STILL
	cmp.b 	#1,d2
	bgt.s 	.1
	bra.w 	J_FRAME_STILL
	RTS
.1	; WAIT
	cmp.b 	#2,d2
	bgt.s 	.2
	bra.w 	J_FRAME_WALK
	RTS
.2	; WALK
	cmp.b 	#3,d2
	bgt.s 	.3
	bra.w	J_FRAME_WALK
	RTS
.3	; CHASE
	cmp.b 	#4,d2
	bgt.s 	.4
	bra.w	J_FRAME_WALK
	RTS
.4	; BACKOFF
	cmp.b 	#5,d2
	bgt.s 	.5
	bra.w	J_FRAME_WALK
	RTS
.5	; OTHERSIDE
	cmp.b 	#6,d2
	bgt.s 	.6
	bra.w	J_FRAME_WALK
	RTS
.6	; ATTACK
	cmp.b 	#7,d2
	bgt.s 	.7
	bra.w	J_FRAME_ATTACK
	RTS
.7	; HITS
	cmp.b 	#8,d2
	bgt.s 	.8
	bra.w	J_FRAME_HITS
	RTS		
.8	; GRAB
	cmp.b 	#9,d2
	bgt.s 	.9
	bra.w	J_FRAME_FALL
	RTS
.9	; FALL
	cmp.b 	#10,d2
	bgt.s 	.10
	bra.w	J_FRAME_FALL
	RTS
.10	; GROUND
	cmp.b 	#11,d2
	bgt.s 	.11
	bra.w	J_FRAME_GROUND
	RTS
.11	; KNEEL
	cmp.b 	#12,d2
	bgt.s 	.12
	bra.w	J_FRAME_KNEEL
	RTS
.12
	RTS

	; ----------------------
	RTS
	; ----------------------
;-------------------------------------------------------------------------
;	J LOAD FRAME
;-------------------------------------------------------------------------

J_FRAME_OFFSET:

J_FRAME_STILL:

	tst.b	d3
	bne.s	.1
	lea		J_STILL_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		J_STILL_1,a3
	RTS
.2	
;	cmp.b	#2,d3
;	bgt.s	.3
	lea		J_STILL_2,a3
	RTS


J_FRAME_WALK:

	tst.b	d3
	bne.s	.1
	lea		J_WALK_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		J_WALK_1,a3
	RTS
.2	
	cmp.b	#2,d3
	bgt.s	.3
	lea		J_WALK_2,a3
	RTS
.3	
;	cmp.b	#3,d3
;	bgt.s	.4
	lea		J_WALK_1,a3
	RTS
.4
	;RTS
	

J_FRAME_ATTACK:

	cmp.b	#0,d3
	bgt.s	.1
	lea		J_WALK_0,a3
	RTS
.1
	cmp.b	#1,d3
	bgt.s	.2
	lea		J_ATTACK2,a3
	RTS
.2
;	cmp.b	#2,d3
;	bgt.s	.3
	lea		J_WALK_0,a3
	RTS
;.3

J_FRAME_HITS:
	cmp.b	#0,d3
	bgt.s	.1
	lea		J_HIT_HIGH,a3
	RTS
.1
;	cmp.b	#1,d3
;	bgt.s	.2
	lea		J_HIT_LOW,a3
	RTS
;.2

J_FRAME_FALL:
	cmp.b	#0,d3
	bgt.s	.1
	lea		J_FALL,a3
	RTS
.1	
	cmp.b	#1,d3
	bgt.s	.2
	lea		J_GROUND,a3
	RTS
.2
	
	
J_FRAME_GROUND:
	lea		J_GROUND,a3
	RTS
	
J_FRAME_KNEEL:
	lea		J_KNEEL,a3
	RTS
	
;-------------------------------------------------------------------------
;	HITSPARK LOAD FRAME
;-------------------------------------------------------------------------

HITSPARK_STATE_OFFSET:

	; STILL
	tst.b	d2
	bgt.s 	.0
	bra.w 	HITSPARK_ANIM
.0
	RTS

HITSPARK_ANIM:

	tst.b	d3
	bgt.s	.1
	lea		HITSPARK1,a3
	RTS
.1
	cmp.b	#1,d3
	;bgt.s	.2
	lea		HITSPARK2,a3
	;RTS
.2	
	RTS

;-------------------------------------------------------------------------
;	GAMEOVER LOAD FRAME
;-------------------------------------------------------------------------

GAMEOVER_STATE_OFFSET:

	lea		GAMEOVER1,a3
	RTS
