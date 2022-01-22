;-----------------------------------------------------------------------------------------------------------
; CREATE EVENT
;-----------------------------------------------------------------------------------------------------------
;	COMMENT:
;		- 	Ok, I thieved the name from Game Maker, but it's just a 1-time set up page for each Level.
;			Definitely needs changing. Will probbaly have one buffer for Maps, one for Tilesheets etc., and
;			just load them in from disk as needed instead of having reserved spaces for each one.
;-----------------------------------------------------------------------------------------------------------

CREATE_EVENT:

;--------------------------------------;
; 	LEVEL 1 - SLUMS

L1_1 = 1	; SLUMS
L1_2 = 2	; WAREHOUSE
L1_3 = 3	; DAMND

;--------------------------------------;
; 	LEVEL 2 - SUBWAY

L2_1 = 4	; SUBWAY PLATFORM
L2_2 = 5	; INSIDE SUBWAY CARRIAGE
L2_3 = 6	; TRAIN TRACKS
L2_4 = 7	; SODOM'S RING (Oooh!)

;--------------------------------------;
; 	LEVEL 3 - WESTSIDE

L3_1 = 8	; WESTSIDE RESTAURANT
L3_2 = 9	; WESTSIDE BAR
L3_3 = 10	; HALL
L3_4 = 11	; ANDORE CAGE FIGHT
L3_5 = 12	; EDI.E

;--------------------------------------;
; 	LEVEL 4 - INDUSTRIAL AREA

L4_1 = 13	; FACTORY
L4_2 = 14	; ROLENTO ELEVATOR

;--------------------------------------;
; 	LEVEL 5 - BAY AREA

L5_1 = 15	; BAY AREA

;--------------------------------------;
; 	LEVEL 6 - UPTOWN

L6_1 = 16	; UPTOWN STREET
L6_2 = 17	; MAD GEAR HQ LOBBY
L6_3 = 18	; MAD GEAR HQ ROOF
L6_4 = 19	; MAD GEAR HQ OUTER
L6_5 = 20	; MAD GEAR HQ INNER - BELGER

;--------------------------------------;


;----------------------------------------------------------------------------------------------	
	
	lea CREATE_EVENT_ADDRESSES,a0
	lea LEVEL,a1
	
;----------------------------------------------------------------------------------------------		

	cmp.b #L1_1,(LEVEL)
	beq.w CREATE_LEVEL1_1
	
	cmp.b #L2_1,(LEVEL)
	beq.w CREATE_LEVEL2_1
	
	cmp.b #L2_2,(LEVEL)
	beq.w CREATE_LEVEL2_2
	
	cmp.b #L3_1,(LEVEL)
	beq.w CREATE_LEVEL3_1
	
;----------------------------------------------------------------------------------------------

CREATE_LEVEL1_1:

		;---------------------------------------
		lea 		MAP_L1_1,a2					; MAP
		move.l		a2,(a0)		
		;---------------------------------------
		lea 		L1_1_TILEOFFSETS,a2			; TILE OFFSETS
		move.l		a2,4(a0)		
		;---------------------------------------
		lea 		L1_1_TILES,a2				; TILE SHEET
		move.l		a2,8(a0)	
		;---------------------------------------
		move.b 		#81,1(a1)					; LEVEL WIDTH
		;---------------------------------------
		move.w		#$0808,(OBJECT_1+2)			; P1 START X
		move.w		#$D0D0,(OBJECT_1+4)			; P1 START Y	
		
		move.w		#$0707,(OBJECT_2+2)			; P1 START X
		move.w		#$F0F0,(OBJECT_2+4)			; P1 START Y	
		;---------------------------------------
		bra.w 		CREATE_EVENT_DONE

CREATE_LEVEL1_2:

CREATE_LEVEL1_3:

CREATE_LEVEL2_1:

		lea 		MAP_L2_1,a2			
		move.l		a2,(a0)		
		lea 		L2_1_TILEOFFSETS,a2			
		move.l		a2,4(a0)		
		lea 		L2_1_TILES,a2			
		move.l		a2,8(a0)	
		move.b 		#80,1(a1)						
		bra.w 		CREATE_EVENT_DONE

CREATE_LEVEL2_2:

		;---------------------------------------
		lea 		MAP_L2_2,a2					; MAP
		move.l		a2,(a0)		
		;---------------------------------------
		lea 		L2_2_TILEOFFSETS,a2			; TILE OFFSETS
		move.l		a2,4(a0)		
		;---------------------------------------
		lea 		L2_2_TILES,a2				; TILE SHEET
		move.l		a2,8(a0)	
		;---------------------------------------
		move.b 		#150,1(a1)					; LEVEL WIDTH
		;---------------------------------------
		lea			OBJECT_1,a0
		move.b		#$FF,OBJ_X(a0)				; P1 START X
		move.b		#$D8,OBJ_Y(a0)				; P1 START Y	
		bset 		#1,OBJ_FLAGS(a0)			; Lock controls (for Walk on)
		
		lea			OBJECT_2,a0
		move.b		#$07,OBJ_X(a0)				; P2 START X
		move.b		#$F8,OBJ_Y(a0)				; P2 START Y	
		bset 		#1,OBJ_FLAGS(a0)			; Lock controls (for Walk on)
		;---------------------------------------
		bset 		#1,OBJ_FLAGS(a0)			; Lock controls (for Walk on)
		bra.w 		CREATE_EVENT_DONE


CREATE_LEVEL2_3:

CREATE_LEVEL2_4:

CREATE_LEVEL3_1:
		
		lea 	MAP_L3_1,a2			
		move.l	a2,(a0)		
		lea 	L3_1_TILEOFFSETS,a2			
		move.l	a2,4(a0)		
		lea 	L3_1_TILES,a2			
		move.l	a2,8(a0)	
		move.b 	#66,1(a1)		
	
		
		;bra.s CREATE_EVENT_DONE

CREATE_LEVEL3_2:
		
CREATE_LEVEL3_3:

CREATE_LEVEL3_4:

;-------------------------------------------------------------------------------------------------------------

CREATE_EVENT_DONE:

;-------------------------------------------------------------------------------------------------------------
	RTS	
;-----------------------------------------------------------------------------------------------------------
