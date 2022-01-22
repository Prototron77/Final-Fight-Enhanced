;-------------------------------------------------------------------------------------------------------------
;	J - ANIMATION
;-------------------------------------------------------------------------------------------------------------
; 	$XXYY(GrabPos),$WWHH(GrabSize),$XXYY(ScreenPos),$XXYY(ScreenPosFLIPPED)
;-------------------------------------------------------------------------
			
J_ANIMATION_TABLE:

;--------------------------------------------
; J WALK
;--------------------------------------------

J_WALK_0:
	; Upper Half
	;dc.w	$0005						; <- Loop count
	dc.w	$0000,$2010,$00A0,$F0A0
	dc.w	$0100,$4010,$F0B0,$E0B0
	dc.w	$0400,$5010,$E0C0,$E0C0
	; Lower Half
	dc.w	$0800,$4010,$E0D0,$F0D0
	dc.w	$0B00,$5010,$E0E0,$E0E0	
	dc.w	$0F00,$6010,$E0F0,$D0F0	
	dc.w	-1							; -1 Terminates count
	
J_WALK_1:
	; Upper Half
	;dc.w	$0005						; <- Loop count
	dc.w	$0000,$2010,$009F,$F09F
	dc.w	$0100,$4010,$F0AF,$E0AF
	dc.w	$0400,$5010,$E0BF,$E0BF
	; Lower Half
	dc.w	$0001,$3010,$F0CF,$F0CF
	dc.w	$0201,$4010,$E0DF,$F0DF	
	dc.w	$0501,$4010,$E0EF,$F0EF	
	dc.w	-1				

J_WALK_2:
	; Upper Half
	;dc.w	$0005					;<- Loop count
	dc.w	$0000,$2010,$009E,$F09E
	dc.w	$0100,$4010,$F0AE,$E0AE
	dc.w	$0400,$5010,$E0BE,$E0BE
	; Lower Half
	dc.w	$0901,$3010,$F0CE,$F0CE
	dc.w	$0B01,$3010,$F0DE,$F0DE	
	dc.w	$0D01,$3010,$F0EE,$F0EE	
	dc.w	-1	
	
;--------------------------------------------
; 	J ATTACK
;--------------------------------------------
	
J_ATTACK1:
	dc.w	$0000,$2010,$009F,$F09F
	dc.w	$0100,$4010,$F0AF,$E0AF
	dc.w	$0400,$5010,$E0BF,$E0BF
	; Lower Half
	dc.w	$0001,$3010,$F0CF,$F0CF
	dc.w	$0201,$4010,$E0DF,$F0DF	
	dc.w	$0501,$4010,$E0EF,$F0EF	
	dc.w	-1	
	
J_ATTACK2:
	; Upper Half
	dc.w	$0F01,$3010,$009F,$E09F
	dc.w	$1101,$4010,$F0AF,$E0AF
	dc.w	$0002,$3010,$20AF,$C0AF
	dc.w	$0202,$5010,$E0BF,$E0BF
	dc.w	$0602,$5010,$E0CF,$E0CF		
	
	dc.w	$0201,$4010,$E0DF,$F0DF	
	dc.w	$0501,$4010,$E0EF,$F0EF	
	dc.w	-1

;--------------------------------------------
; 	J HITS
;--------------------------------------------

J_HIT_HIGH:
	; Upper Half
	dc.w	$0404,$4010,$F0B0,$E0B0
	dc.w	$0C04,$3010,$F0C0,$F0C0
	; Lower Half
	dc.w	$1004,$2010,$F0D0,$00D0
	dc.w	$1204,$2010,$F0E0,$00E0
	dc.w	$0005,$2010,$F0F0,$E0F0		
	dc.w	-1	
;	EVEN
	
J_HIT_LOW:
	; Upper Half
	dc.w	$0803,$4010,$F0A6,$E0A6
	dc.w	$0B03,$5010,$E0B6,$E0B6
	; Lower Half
	dc.w	$0F03,$5010,$E0C6,$E0C6
	dc.w	$0204,$5010,$E0D6,$E0D6
	dc.w	$0604,$4010,$E0E6,$F0E6		
	dc.w	$0904,$5010,$E0F6,$E0F6		; <---FEET WITH SHADOW
	dc.w	-1	
	
J_PILEDRIVER:
	; Upper Half
	dc.w	$0B04,$5010,$F0B0,$E0B0
	dc.w	$0F04,$4010,$F0C0,$F0C0
	; Lower Half
	dc.w	$1204,$3010,$F0D0,$00D0
	dc.w	$0005,$3010,$F0E0,$00E0
	dc.w	$0505,$4010,$F0F0,$F0F0		; <---FEET WITH NO SHADOW
	dc.w	-1	

;--------------------------------------------
; 	J FALL
;--------------------------------------------

J_FALL:
	; Upper Half
	dc.w	$1104,$4010,$E0C0,$00C0
	dc.w	$0005,$2010,$10C0,$F0C0
	; Lower Half
	dc.w	$0105,$6010,$E0D0,$E0D0
	dc.w	$0605,$7010,$E0E0,$D0E0
	dc.w	$0C05,$3010,$20F0,$D0F0
	dc.w	-1	
	EVEN
	
;--------------------------------------------
; 	J STILL
;--------------------------------------------

; STANDING
J_STILL_0:
	dc.w	$0207,$3010,$E0B0,$E0B0
	dc.w	$0407,$4010,$E0C0,$E0C0
	dc.w	$0707,$4010,$E0D0,$E0D0
	dc.w	$0A07,$5010,$D0E0,$D0E0
	dc.w	$0E07,$4010,$D0F0,$D0F0
	dc.w	-1	
	EVEN
	
; CROUCHING
J_STILL_1:
	dc.w	$0207,$3010,$E0B0,$E0B0
	dc.w	$0407,$4010,$E0C0,$E0C0
	dc.w	$0707,$4010,$E0D0,$E0D0
	dc.w	$0A07,$5010,$D0E0,$D0E0
	dc.w	$0E07,$4010,$D0F0,$D0F0
	dc.w	-1	
	EVEN
	
; SITTING ON TRAIN / BENCH	
J_STILL_2:
	dc.w	$0207,$3010,$E0B0,$E0B0
	dc.w	$0407,$4010,$E0C0,$E0C0
	dc.w	$0707,$4010,$E0D0,$E0D0
	dc.w	$0A07,$5010,$D0E0,$D0E0
	dc.w	$0E07,$4010,$D0F0,$D0F0

	dc.w	-1	
	EVEN
	
;--------------------------------------------
; 	J GROUND
;--------------------------------------------

J_GROUND:
	dc.w	$0E05,$7010,$D0E0,$E0E0
	dc.w	$0006,$2010,$30E0,$D0E0
	dc.w	$0106,$9010,$D0F0,$C0F0
	dc.w	-1	
	EVEN
	
;--------------------------------------------
; 	J KNEEL
;--------------------------------------------	
J_KNEEL:
	; Upper Half
	dc.w	$0803,$4010,$F0C0,$E0C0
	dc.w	$0B03,$5010,$E0D0,$E0D0
	dc.w	$0F03,$5010,$E0E0,$E0E0
	; Lower Half
	dc.w	$1303,$2010,$E0F0,$10F0
	dc.w	$0004,$3010,$F0F0,$F0F0
	dc.w	-1	