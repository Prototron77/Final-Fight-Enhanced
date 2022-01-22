;-------------------------------------------------------------------------------------------------------------
;	BRED - ANIMATION
;-------------------------------------------------------------------------------------------------------------
; 	$XXYY(GrabPos),$WWHH(GrabSize),$XXYY(ScreenPos),$XXYY(ScreenPosFLIPPED)
;-------------------------------------------------------------------------
			
BRED_ANIMATION_TABLE:

;--------------------------------------------
; BRED WALK
;--------------------------------------------

BRED_WALK_0:
	; Upper Half
	;dc.w	$0005					;<- Loop count
	dc.w	$0000,$4010,$F0B0,$E0B0
	dc.w	$0300,$4010,$F0C0,$E0C0
	; Lower Half
	dc.w	$0600,$4010,$F0D0,$E0D0
	dc.w	$0900,$5010,$E0E0,$E0E0
	dc.w	$0D00,$5010,$E0F0,$E0F0					
	dc.w	-1								; -1 Terminates count
	
BRED_WALK_1:
	; Upper Half
	dc.w	$0000,$4010,$F0AF,$E0AF
	dc.w	$0300,$4010,$F0BF,$E0BF
	; Lower Half
	dc.w	$1100,$3010,$F0CF,$F0CF
	dc.w	$1300,$2010,$F0DF,$00DF
	dc.w	$0001,$2010,$00DF,$F0DF		
	dc.w	$0101,$4010,$E0EF,$F0EF		
	dc.w	-1		

BRED_WALK_2:
	; Upper Half
	dc.w	$0000,$4010,$F0AE,$E0AE
	dc.w	$0300,$4010,$F0BE,$E0BE
	; Lower Half
	dc.w	$0401,$3010,$F0CE,$F0CE
	dc.w	$0601,$3010,$F0DE,$F0DE
	dc.w	$0801,$3010,$F0EE,$F0EE		
	dc.w	-1		
	
;--------------------------------------------
; 	BRED HITS
;--------------------------------------------
	
BRED_ATTACK1:
	; Upper Half
	dc.w	$0A01,$3010,$F0A0,$00A0
	dc.w	$0C01,$6010,$E0B0,$E0B0
	; Lower Half
	dc.w	$1101,$4010,$F0C0,$F0C0
	dc.w	$0002,$4010,$F0D0,$F0D0
	dc.w	$0302,$5010,$E0E0,$F0E0	
	dc.w	$0702,$5010,$E0F0,$F0F0			
	dc.w	-1	
	
BRED_ATTACK2:
	; Upper Half
	dc.w	$0B02,$6010,$00A0,$C0A0
	dc.w	$1002,$5010,$F0B0,$E0B0
	; Lower Half
	dc.w	$0003,$2010,$30B0,$D0B0
	dc.w	$0103,$4010,$F0C0,$F0C0
	dc.w	$0403,$3010,$00D0,$F0D0		
	dc.w	$0603,$4010,$F0E0,$F0E0	
	dc.w	$0903,$4010,$F0F0,$F0F0	
	dc.w	-1

;--------------------------------------------
; 	BRED HITS
;--------------------------------------------

BRED_HIT_HIGH:
	; Upper Half
	dc.w	$0404,$4010,$F0B0,$E0B0
	dc.w	$0C04,$3010,$F0C0,$F0C0
	; Lower Half
	dc.w	$1004,$2010,$F0D0,$00D0
	dc.w	$1204,$2010,$F0E0,$00E0
	dc.w	$0005,$2010,$F0F0,$E0F0		
	dc.w	-1	
	EVEN
	
BRED_HIT_LOW:
	; Upper Half
	dc.w	$0B04,$5010,$F0B0,$E0B0
	dc.w	$0F04,$4010,$F0C0,$F0C0
	; Lower Half
	dc.w	$1204,$3010,$F0D0,$00D0
	dc.w	$0005,$3010,$F0E0,$00E0
	dc.w	$0205,$4010,$F0F0,$F0F0		; <---FEET WITH SHADOW
	dc.w	-1	
	
BRED_PILEDRIVER:
	; Upper Half
	dc.w	$0B04,$5010,$F0B0,$E0B0
	dc.w	$0F04,$4010,$F0C0,$F0C0
	; Lower Half
	dc.w	$1204,$3010,$F0D0,$00D0
	dc.w	$0005,$3010,$F0E0,$00E0
	dc.w	$0505,$4010,$F0F0,$F0F0		; <---FEET WITH NO SHADOW
	dc.w	-1	

;--------------------------------------------
; 	BRED FALL
;--------------------------------------------

BRED_FALL:
	; Upper Half
	dc.w	$0007,$6010,$D0C0,$E0C0
	dc.w	$0507,$7010,$D0D0,$D0D0
	; Lower Half
	dc.w	$0B07,$4010,$00E0,$D0E0
	dc.w	$0E07,$3010,$10F0,$D0F0
	dc.w	-1	
	EVEN
	
;--------------------------------------------
; 	BRED STILL
;--------------------------------------------

; STANDING
BRED_STILL_0:
	dc.w	$1007,$4010,$F0B0,$E0C0
	dc.w	$1307,$2010,$E0C0,$D0D0
	dc.w	$0008,$4010,$F0C0,$D0E0
	dc.w	$0308,$5010,$E0D0,$D0F0
	dc.w	$0708,$3010,$E0E0,$D0F0
	dc.w	$0A08,$3010,$E0F0,$D0F0
	dc.w	-1	
	EVEN
	
; CROUCHING
BRED_STILL_1:
	dc.w	$0E05,$3010,$F0A0,$E0A0
	dc.w	$1005,$4010,$F0B0,$D0B0
	dc.w	$1305,$2010,$F0C0,$D0C0
	dc.w	$0006,$3010,$00C0,$D0C0
	dc.w	$0206,$3010,$F0D0,$D0D0
	dc.w	$0406,$3010,$F0E0,$D0E0
	dc.w	$0606,$4010,$F0F0,$D0F0
	dc.w	-1	
	EVEN
	
; SITTING ON TRAIN / BENCH	
BRED_STILL_2:
	dc.w	$1007,$4010,$F0B0,$E0C0
	dc.w	$1307,$2010,$E0C0,$D0D0
	dc.w	$0008,$4010,$F0C0,$D0E0
	dc.w	$0308,$5010,$E0D0,$D0F0
	dc.w	$0708,$3010,$E0E0,$D0F0
	dc.w	$0A08,$3010,$E0F0,$D0F0
	dc.w	-1	
	EVEN
	
;--------------------------------------------
; 	BRED GROUND
;--------------------------------------------

BRED_GROUND:
	dc.w	$0C08,$9010,$D0E0,$D0E0
	dc.w	$0009,$9010,$D0F0,$D0F0
	dc.w	-1	
	EVEN
	
;--------------------------------------------
; 	BRED KNEEL
;--------------------------------------------	
BRED_KNEEL:
		; Upper Half
	dc.w	$0B04,$5010,$F0C8,$E0C8
	dc.w	$0F04,$4010,$F0D8,$F0D8
	; Lower Half
	dc.w	$0805,$4010,$E0E8,$00E8
	dc.w	$0B05,$4010,$E0F8,$00F8
	dc.w	-1	
	EVEN