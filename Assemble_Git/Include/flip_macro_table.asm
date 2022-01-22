FLIP_MACRO_AND_TABLE:
	macro FlipByte ;Source Pixels ABCDEFGH IJKLMNOP

	moveq #0,d2
	moveq #0,d3
	move.w d1,d2
	and.w #%1000000000000000,d1		;A %00000000 00000001
	rol.w #1,d1
	move.w d1,d3	
	move.w d2,d1
	
	and.w #%0100000000000000,d1		;B %00000000 00000010
	rol.w #3,d1
	or.w d3,d1
	move.w d1,d3
	move.w d2,d1
	
	and.w #%0010000000000000,d1		;C %00000000 00000100
	rol.w #5,d1
	or.w d3,d1
	move.w d1,d3 		
	move.w d2,d1		
	
	and.w #%0001000000000000,d1 	;D %10000000 00001000
	rol.w #7,d1
	or.w d3,d1
	move.w d1,d3
	move.w d2,d1
	
	and.w #%0000100000000000,d1 	;E %00000000 00010000
	ror.w #7,d1
	or.w d3,d1
	move.w d1,d3
	move.w d2,d1
	
	and.w #%0000010000000000,d1		;F %00000000 00100000
	ror.w #5,d1
	or.w d3,d1
	move.w d1,d3
	move.w d2,d1
	
	and.w 	#%0000001000000000,d1	;G %00000000 01000000
	ror.w	#3,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000100000000,d1	;H %00000000 10000000
	ror.w 	#1,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000010000000,d1	;I %00000000 10000000
	rol.w 	#1,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000001000000,d1	;j %00000000 01000000
	rol.w	#3,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000000100000,d1	;K %00000000 01000000
	rol.w	#5,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000000010000,d1	;L %00000000 01000000
	rol.w	#7,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000000001000,d1	;M %00000000 01000000
	ror.w	#7,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000000000100,d1	;N %00000000 01000000
	ror.w	#5,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000000000010,d1	;O %00000000 01000000
	ror.w	#3,d1
	or.w 	d3,d1
	move.w 	d1,d3
	move.w 	d2,d1
	
	and.w 	#%0000000000000001,d1	;P %00000000 01000000
	ror.w	#1,d1
	or.w 	d3,d1
	endm