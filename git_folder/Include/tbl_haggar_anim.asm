;-------------------------------------------------------------------------------------------------------------
;	HAGGAR - ANIMATION
;-------------------------------------------------------------------------------------------------------------

WALKANIM_OFFSET 	= 68
ATTACK_OFFSET 		= 492

;-------------------------------------------------------------------------
			
HAGGAR_ANIMATION_TABLE:

; $XXYY(GrabPos),$WWHH(GrabSize),$XXYY(ScreenPos),$XXYY(ScreenPosFLIPPED)

HAGGAR_STANCE:
	; Upper Half
	dc.w	$0000,$4010,$E0A0,$F0A0
	dc.w	$0300,$5010,$D0B0,$F0B0
	dc.w	$0700,$7010,$D0C0,$D0C0
	; Lower Half
	dc.w	$0E00,$5010,$D0D0,$F0D0
	dc.w	$0D00,$2010,$10D0,$E0D0			; Finger
	dc.w	$1200,$3010,$D0E0,$10E0
	dc.w	$0001,$3010,$F0E0,$F0E0
	dc.w	$0201,$5010,$D0F0,$F0F0				
	dc.w	-1								; -1 Terminates count
	;,$0042									$0042 resets value	

;-------------------------------------------------------------------------
; HAGGAR WALK
;-------------------------------------------------------------------------
	
HAGGAR_WALK_0:
	; Upper Half
	dc.w	$0000,$4010,$E09C,$F09C		
	dc.w	$0300,$5010,$D0AC,$F0AC
	dc.w	$0700,$7010,$D0BC,$D0BC
	; Lower Half
	dc.w	$0601,$4010,$D0CC,$00CC
	dc.w	$0D00,$2010,$10CC,$E0CC			; Finger
	dc.w	$0901,$4010,$D0DC,$00DC
	dc.w	$0C01,$5010,$D0EC,$F0EC
	dc.w	$1001,$5010,$D0FC,$F0FC					
	dc.w	-1								; -1 Terminates count
	;,$0042
	
HAGGAR_WALK_1:
	; Upper Half
	dc.w	$0000,$4010,$E09B,$F09B			
	dc.w	$0300,$5010,$D0AB,$F0AB
	dc.w	$0700,$7010,$D0BB,$D0BB
	; Lower Half
	dc.w	$0002,$4010,$D0CB,$00CB
	dc.w	$0D00,$2010,$10CB,$E0CB			; Finger
	dc.w	$0302,$3010,$E0DB,$00DB
	dc.w	$0502,$4010,$D0EB,$00EB
	dc.w	$0802,$4010,$D0FB,$00FB					
	dc.w	-1								; -1 Terminates count
	;,$0042
	
HAGGAR_WALK_2:
	; Upper Half
	dc.w	$0000,$4010,$E09B,$F09B			
	dc.w	$0300,$5010,$D0AB,$F0AB
	dc.w	$0700,$7010,$D0BB,$D0BB
	; Lower Half
	dc.w	$0B02,$4010,$D0CB,$00CB
	dc.w	$0D00,$2010,$10CB,$E0CB			; Finger
	dc.w	$0E02,$4010,$D0DB,$00DB
	dc.w	$1102,$4010,$D0EB,$00EB
	dc.w	$0003,$4010,$D0FB,$00FB					
	dc.w	-1								; -1 Terminates count
	;,$0042
	
HAGGAR_WALK_3:
	; Upper Half
	dc.w	$0000,$4010,$E09C,$F09C		
	dc.w	$0300,$5010,$D0AC,$F0AC
	dc.w	$0700,$7010,$D0BC,$D0BC
	; Lower Half
	dc.w	$0303,$4010,$D0CC,$00CC
	dc.w	$0D00,$2010,$10CC,$E0CC			; Finger
	dc.w	$0603,$4010,$D0DC,$00DC
	dc.w	$0903,$4010,$D0EC,$00EC
	dc.w	$0C03,$5010,$D0FC,$F0FC					
	dc.w	-1								; -1 Terminates count
	;,$0042
	
HAGGAR_WALK_4:
	; Upper Half
	dc.w	$0000,$4010,$E09B,$F09B			
	dc.w	$0300,$5010,$D0AB,$F0AB
	dc.w	$0700,$7010,$D0BB,$D0BB
	; Lower Half
	dc.w	$1003,$4010,$D0CB,$00CB
	dc.w	$0D00,$2010,$10CB,$E0CB			; Finger
	dc.w	$1303,$2010,$E0DB,$10DB
	dc.w	$0004,$2010,$F0DB,$00DB
	dc.w	$0104,$4010,$D0EB,$00EB			
	dc.w	$0404,$4010,$D0FB,$00FB
	dc.w	-1								; -1 Terminates count
	;,$004A
	
HAGGAR_WALK_5:
	; Upper Half
	dc.w	$0000,$4010,$E09B,$F09B		
	dc.w	$0300,$5010,$D0AB,$F0AB
	dc.w	$0700,$7010,$D0BB,$D0BB
	; Lower Half
	dc.w	$0704,$4010,$D0CB,$00CB
	dc.w	$0D00,$2010,$10CB,$E0CB			; Finger
	dc.w	$0A04,$4010,$D0DB,$00DB
	dc.w	$0D04,$5010,$D0EB,$F0EB
	dc.w	$1104,$4010,$D0FB,$00FB	
	dc.w	$0005,$2010,$00FB,$F0FB	
	dc.w	-1								; -1 Terminates count

;-------------------------------------------------------------------------
; HAGGAR PUNCH
;-------------------------------------------------------------------------
	
HAGGAR_PUNCH_0:
	dc.w	$0105,$3010,$00A0,$E0A0			
	dc.w	$0305,$4010,$F0B0,$E0B0
	dc.w	$0605,$4010,$F0C0,$E0C0
	dc.w	$0905,$5010,$E0D0,$E0D0	
	dc.w	$0D05,$2010,$D0E0,$20E0	
	dc.w	$0E05,$5010,$E0E0,$E0E0	
	dc.w	$1205,$3010,$D0F0,$10F0		
	dc.w	$0006,$4010,$F0F0,$E0F0		
	dc.w	-1								; -1 Terminates count	
	
HAGGAR_PUNCH_1:
	dc.w	$0306,$3010,$00A0,$E0A0			
	dc.w	$0506,$6010,$E0B0,$D0B0
	dc.w	$0A06,$8010,$E0C0,$B0C0
	dc.w	$1106,$4010,$F0D0,$E0D0	
	dc.w	$0007,$5010,$E0E0,$E0E0	
	dc.w	$0D05,$2010,$D0E0,$20E0	
	dc.w	$0407,$6010,$D0F0,$E0F0
	dc.w	-1								; -1 Terminates count
		
HAGGAR_COMBO3_0:
	dc.w	$0907,$3010,$E090,$0090			
	dc.w	$0B07,$4010,$D0A0,$00A0
	dc.w	$0E07,$4010,$D0B0,$00B0
	dc.w	$1107,$4010,$D0C0,$00C0	
	dc.w	$0E00,$5010,$D0D0,$F0D0	
	dc.w	$1200,$3010,$D0E0,$10E0
	dc.w	$0001,$3010,$F0E0,$F0E0
	dc.w	$0201,$5010,$D0F0,$F0F0			
	dc.w	-1								; -1 Terminates count	
	
HAGGAR_COMBO3_1:
	dc.w	$0008,$4010,$F0A0,$E0A0			
	dc.w	$0308,$4010,$F0B0,$E0B0
	dc.w	$0608,$4010,$F0C0,$E0C0
	dc.w	$0908,$5010,$E0D0,$E0D0	
	dc.w	$0D05,$2010,$D0E0,$20E0	
	dc.w	$0E05,$5010,$E0E0,$E0E0	
	dc.w	$1205,$3010,$D0F0,$10F0		
	dc.w	$0006,$4010,$F0F0,$E0F0	
	dc.w	-1		
	
HAGGAR_COMBO3_2:
	dc.w	$0D08,$3010,$10A0,$D0A0			
	dc.w	$0F08,$5010,$F0B0,$D0B0
	dc.w	$1308,$2010,$F0C0,$00C0
	dc.w	$0009,$6010,$00C0,$B0C0	
	dc.w	$0509,$4010,$F0D0,$E0D0	
	dc.w	$0007,$5010,$E0E0,$E0E0	
	dc.w	$0D05,$2010,$D0E0,$20E0	
	dc.w	$0407,$6010,$D0F0,$E0F0
	dc.w	-1	
	
HAGGAR_COMBO3_3:
	dc.w	$0809,$3010,$00A0,$E0A0			
	dc.w	$0A09,$5010,$E0B0,$E0B0
	dc.w	$0E09,$5010,$E0C0,$E0C0
	dc.w	$1209,$3010,$E0D0,$00D0	
	dc.w	$000A,$3010,$00D0,$E0D0	
	dc.w	$0D05,$2010,$D0E0,$20E0	
	dc.w	$0E05,$5010,$E0E0,$E0E0	
	dc.w	$1205,$3010,$D0F0,$10F0		
	dc.w	$0006,$4010,$F0F0,$E0F0	
	dc.w	-1	
	
;-------------------------------------------------------------------------
; HAGGAR SPECIAL
;-------------------------------------------------------------------------
	
HAGGAR_SPECIAL_0:
	dc.w	$020A,$2010,$C080,$3080			
	dc.w	$030A,$5010,$C090,$0090
	dc.w	$070A,$6010,$C0A0,$F0A0
	dc.w	$0C0A,$4010,$D0B0,$00B0	
	dc.w	$0F0A,$4010,$D0C0,$00C0	
	dc.w	$120A,$3010,$D0D0,$10D0	
	dc.w	$000B,$2010,$F0D0,$00D0		
	dc.w	$010B,$3010,$E0E0,$00E0		
	dc.w	$030B,$4010,$D0F0,$00F0	
	dc.w	-1								; -1 Terminates count	
	
HAGGAR_SPECIAL_1:
	dc.w	$060B,$4010,$E0A0,$F0A0			
	dc.w	$090B,$4010,$E0B0,$F0B0
	dc.w	$0C0B,$4010,$E0C0,$F0C0
	dc.w	$0F0B,$3010,$E0D0,$00D0	
	dc.w	$110B,$4010,$D0E0,$00E0	
	dc.w	$000C,$2010,$00E0,$F0E0	
	dc.w	$010C,$5010,$D0F0,$F0F0
	dc.w	-1								; -1 Terminates count
	
HAGGAR_SPECIAL_2:
	dc.w	$050C,$5010,$D0A0,$F0A0			
	dc.w	$090C,$8010,$D0B0,$C0B0
	dc.w	$100C,$4010,$E0C0,$F0C0
	dc.w	$130C,$2010,$E0D0,$10D0	
	dc.w	$000D,$4010,$F0D0,$E0D0	
	dc.w	$030D,$4010,$F0E0,$E0E0	
	dc.w	$060D,$4010,$F0F0,$E0F0
	dc.w	-1								; -1 Terminates count
		
HAGGAR_SPECIAL_3:
	dc.w	$090D,$4010,$F0A0,$E0A0			
	dc.w	$0C0D,$4010,$F0B0,$E0B0
	dc.w	$0F0D,$4010,$F0C0,$E0C0
	dc.w	$120D,$3010,$F0D0,$F0D0	
	dc.w	$000E,$2010,$10D0,$E0D0	
	dc.w	$010E,$4010,$F0E0,$E0E0	
	dc.w	$040E,$4010,$F0F0,$E0F0
	dc.w	-1								; -1 Terminates count
	
	
HAGGAR_SPECIAL_4:
	dc.w	$070E,$6010,$F0A0,$C0A0			
	dc.w	$0C0E,$9010,$C0B0,$C0B0
	dc.w	$000F,$4010,$F0C0,$E0C0
	dc.w	$030F,$4010,$F0D0,$E0D0	
	dc.w	$060F,$3010,$F0E0,$F0E0	
	dc.w	$080F,$3010,$F0F0,$F0F0	
	dc.w	-1								; -1 Terminates count
	
;-------------------------------------------------------------------------
; HAGGAR JUMP
;-------------------------------------------------------------------------

HAGGAR_JUMP_0:
	dc.w	$0A0F,$4010,$E0A0,$F0A0		
	dc.w	$0D0F,$5010,$E0B0,$E0B0
	dc.w	$110F,$3010,$E0C0,$00C0
	dc.w	$130F,$2010,$E0D0,$10D0
	dc.w	$0010,$2010,$F0D0,$00D0	
	dc.w	$0110,$3010,$E0E0,$00E0
	dc.w	$0310,$3010,$E0F0,$00F0		
	dc.w	$0510,$3010,$E000,$0000		
	dc.w	-1								; -1 Terminates count	
	
HAGGAR_JUMP_1:
	dc.w	$0710,$4010,$E0A0,$F0A0			
	dc.w	$0A10,$4010,$E0B0,$F0B0
	dc.w	$0D10,$5010,$E0C0,$E0C0
	dc.w	$1110,$4010,$E0D0,$F0D0
	dc.w	$0011,$2010,$10D0,$E0D0	
	dc.w	$0111,$4010,$E0E0,$F0E0	
	dc.w	-1								; -1 Terminates count
	


;-------------------------------------------------------------------------
; HAGGAR FLYING KICK
;-------------------------------------------------------------------------

HAGGAR_FKICK_0:
	dc.w	$0411,$5010,$C0B0,$F0B0			
	dc.w	$0811,$5010,$C0C0,$F0C0
	dc.w	$0C11,$6010,$C0D0,$E0D0
	dc.w	$1111,$4010,$C0E0,$00E0
	dc.w	$0012,$4010,$F0E0,$D0E0	
	dc.w	$0312,$3010,$F0F0,$E0f0		
	dc.w	-1								
	
HAGGAR_FKICK_1:
	dc.w	$0512,$3010,$D0B0,$10B0			 
	dc.w	$0712,$4010,$C0C0,$10C0
	dc.w	$0A12,$9010,$C0D0,$C0D0
	dc.w	$1212,$2010,$C0E0,$30E0
	dc.w	$1312,$2010,$E0E0,$10E0
	dc.w	$0013,$6010,$F0E0,$C0E0
	dc.w	-1								

;-------------------------------------------------------------------------
; HAGGAR HITS
;-------------------------------------------------------------------------

HAGGAR_HIT_HIGH:
	dc.w	$0C17,$4010,$D0A0,$00A0			
	dc.w	$0F17,$5010,$D0B0,$F0B0
	dc.w	$1317,$2010,$D0C0,$20C0
	dc.w	$0018,$5010,$E0C0,$E0C0
	; Lower Half
	dc.w	$0E00,$5010,$D0D0,$F0D0
	dc.w	$1200,$3010,$D0E0,$10E0
	dc.w	$0001,$3010,$F0E0,$F0E0
	dc.w	$0201,$5010,$D0F0,$F0F0		
	dc.w	-1								
	
HAGGAR_HIT_LOW:
	dc.w	$0518,$3010,$E0B0,$10B0			 
	dc.w	$0718,$4010,$D0C0,$10C0
	dc.w	$0A18,$9010,$D0D0,$C0D0
	dc.w	$1218,$2010,$D0E0,$30E0
	dc.w	$1318,$2010,$F0E0,$10E0
	dc.w	$0019,$6010,$00E0,$C0E0
	dc.w	-1								
	
;-------------------------------------------------------------------------
; 	HAGGAR GROUND & KNEEL (Same frame)
;-------------------------------------------------------------------------

HAGGAR_KNEEL:
	dc.w	$0419,$2010,$F0B0,$00B0			
	dc.w	$0519,$4010,$E0C0,$F0C0
	dc.w	$0819,$4010,$E0D0,$F0D0
	dc.w	$0B19,$5010,$E0E0,$E0E0
	dc.w	$0F19,$4010,$E0F0,$F0F0	
	dc.w	-1	
	

	

	