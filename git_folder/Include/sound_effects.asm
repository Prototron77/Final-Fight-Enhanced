;-------------------------------------------------------------------------------------------------------------
; SOUND EFFECT TEST
;-------------------------------------------------------------------------------------------------------------
	
PLAY_PUNCH_WOOSH:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_PUNCH_WOOSH+128,a0				; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#3500,$dff0d4						; Length
	move.w	#150,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
PLAY_PUNCH:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_PUNCH+128,a0				; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#2500,$dff0d4						; Length
	move.w	#160,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
PLAY_HARDHIT:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_HARDHIT+128,a0				; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#2500,$dff0d4						; Length
	move.w	#160,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3

	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
PLAY_CODYUPPER:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_CODYUPPER+128,a0				; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#4000,$dff0d4						; Length
	move.w	#160,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
PLAY_HAGGAR_HAMMER:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_HAGGAR_HAMMER+128,a0				; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#8500,$dff0d4						; Length
	move.w	#16,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
PLAY_HAGGAR_FLYINGKICK:	

	move.l a0,-(sp)
	
	;------bb-------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_HAGGAR_FLYINGKICK+128,a0				; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#5000,$dff0d4						; Length
	move.w	#230,$dff0d6						; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	

	
PLAY_HAGGAR_SPECIAL:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_HAGGAR_SPECIAL+128,a0			; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#16800,$dff0d4						; Length
	move.w	#160,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length
	move.w	#1,$dff0d6							; Period
	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
	
PLAY_LAND:	

	move.l a0,-(sp)
	
	;-------------------------------------------
	;	LOAD SOUND EFFECT AND ACTIVATE CHANNEL
	;-------------------------------------------
	
	move.w	#%0000000000001000,$dff096			; Disable Channel 3

	lea 	FX_LAND+128,a0						; Sound Data
	
	move.l 	a0,$dff0d0							; Pointer
	move.w	#5500,$dff0d4						; Length
	move.w	#16,$dff0d6							; Period
	move.w	#64,$dff0d8							; Volume

	move.w	#%1000000000001000,$dff096			; Enable Channel 3
	
	;-------------------------------------------
	; LINE UP SILENT DATA TO STOP SOUND EFFECT
	;-------------------------------------------
	
	lea 	FX_SILENCE,a0						; Sound Data
	move.w	#1,$dff0d4							; Length

	;-------------------------------------------
	move.l (sp)+,a0
	RTS
	;-------------------------------------------
	
	