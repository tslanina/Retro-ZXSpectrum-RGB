; RGB by dox
; 256 bytes speccy intro
; tomasz@slanina.pl

				org 0xe000
start:
				ei
				call $d6b	; clear  cd 6b 0d
main_loop:
		
				ld ix,balls
									
loop_balls:			
	
				ld a,[ix]	; counter
				inc [ix]			
				ld hl,ptable							
				add a,l
				ld l,a			
				ld a,[hl]	;ptable data 1

				or a
							
				jr nz, continue
				ld [ix],a
				jr loop_balls
				
continue:			
				; a contains y positon
				ld c,a
				and %11110000
				
				ld l,a
				ld h,$60
				
				add hl,hl
				inc ix				;ix points to x pos
				ld a,l
				add a,[ix]
				
				ld l,a				;hl = draw address
				
				inc ix				;ix points to mask		
				ld a,c
				and %1111
				ld bc,adr
				add a,c
				ld c,a
				ld a,[bc]
				ld e,a
				ld d,$e0
				ld a,[ix]
				inc ix	;ix points to next ball
				
				call draw_circle
				
				ld a,[ix]
	
				or a
				
				jr nz, loop_balls
		
				out(254),a	
			
				ld hl,$c000
				push hl
				ld de,$5800
				ld bc,32*24
				ldir

				ld de,$c001
				pop hl

				ld [hl],7*8
				ld bc,32*8
				push bc
				ldir
				halt
				ld a,7
				out(254),a	
				ld bc,32*6
				ldir
				
				ld [hl],a

				pop bc
				ldir
				
				jr main_loop

draw_circle:
				ld [color_wr+1],a
				;bc = y,x

				ld bc,32
row_loop:

				ld a,[de] 
				or a
				ret z	
				push hl
				push bc			
				ld b,a
				and %111			
				dec a			
				add a,l
				ld l,a
						
				inc de
				srl b
				srl b
				srl b			
				jr z,skip_row

write:				
				ld a,[hl]
				cp 7*8
				jr nz,color_wr
				ld a,64
				
color_wr:
				or 8
				ld [hl],a
				
				inc hl
				djnz write
skip_row:				
				pop bc
				pop hl
				
				add hl, bc
				jr row_loop
	
	
adr:
				db ball0-$e000
				db ball1-$e000
				db ball2-$e000	
	
ball0:
				db	%00101111	;.......xxxxx 7-5
				db	%00111110	;......xxxxxxx 6-7
				db	%01001101	;.....xxxxxxxxx 5-9
				db	%01011100	;....xxxxxxxxxxx 4-11
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01011100	;....xxxxxxxxxxx 4-11
				db	%01001101	;.....xxxxxxxxx 5-9
				db	%00111110	;......xxxxxxx 6-7
				db	%00101111	;.......xxxxx 7-5
				db	0

ball1:

				db	%00000001
				db	%00111110	;......xxxxxxx 6-7
				db	%01001101	;.....xxxxxxxxx 5-9
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01111010	;..xxxxxxxxxxxxxxx 2-15
				db	%01111010	;..xxxxxxxxxxxxxxx 2-15
				db	%01111010	;..xxxxxxxxxxxxxxx 2-15
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01101011	;...xxxxxxxxxxxxx 3-13
				db	%01001101	;.....xxxxxxxxx 5-9
				db	%00111110	;......xxxxxxx 6-7
				db	0

ball2:
				db	%00000001
				db	%00000001
				db	%00111110	;......xxxxxxx 6-7
				db	%01011100	;....xxxxxxxxxxx 4-11
				db	%01111010	;..xxxxxxxxxxxxxxx 2-15
				db	%10001001	;..xxxxxxxxxxxxxxx 1-17
				db	%10001001	;..xxxxxxxxxxxxxxx 1-17
				db	%10001001	;..xxxxxxxxxxxxxxx 1-17
				db	%01111010	;..xxxxxxxxxxxxxxx 2-15	
				db	%01011100	;....xxxxxxxxxxx 4-11
				db	%00111110	;......xxxxxxx 6-7
				db 	0


balls:

				db 3,0,16
				db 3+10,7,32
				db 3+20,14,8,0
	
ptable:

				db $10  ; yyyyffff  => ypos (high nibble), frame (low nibble)
				db $10
				db $10
				db $10
				db $10
				db $10
				db $20
				db $20
				db $20
				db $30
				db $30
				db $40
				db $50
				db $60
				db $70
				db $80
				db $91
				db $91
				db $91
				db $91
				db $a2
				db $a2
				db $a2
				db $a2
				db $a2
				db $a2
				db $a2
				db $91
				db $91
				db $91
				db $91
				db $80
				db $70
				db $60
				db $50
				db $40
				db $30
				db $30
				db $20
				db $20
				db $20
				db $10
				db $10
				db $10
				db $10
				db 0			
end start