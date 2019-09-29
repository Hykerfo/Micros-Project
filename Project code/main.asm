; Project code.asm
;
; Created: 20/09/2019 12:36:59
; Author : Hyla 
; Student number : 1835707

.cseg
.org 0x0000
	jmp start
.org 0x0002
	jmp pulseInp
.org 0x0020
	jmp counting

start:

	ldi r16, 0b00000001
	sts eicra, r16
	out eimsk, r16
	sts timsk0, r16
	clr r16
	out tccr0a, r16
	ldi r16, 0b00000010
	out tccr0b, r16
	
	ldi r16, 0b00011111
	out ddrb, r16
	ldi r16, 0b11010000
	out ddrd, r16
	ldi r16,0b00000111
	out ddrc,r16
	ldi r24,0x02
	ldi r27, 1
	ldi r28,9

pickMode:
	;clr r16
	in r16,pind
	sbrc r16,5
	jmp getRegion
	jmp gameMode
jmp pickMode

display:
loop0:
	inc r19
	clr r22
		loop:
		inc r22
		clr r23
			loop1:
			inc r23
			cpi r23,100
			brne loop1
		cpi r22,100
		brne loop
	cpi r19,200
brne loop0
ret

gameMode:
;wait:
;	in r30,pind
;	sbrc r30, 6
;	jmp comm
;jmp wait

comm:
	ldi r27,1
	out portc,r27
	out portb,r28
jmp pickMode

getRegion:

;wat:
;	in r30,pind
;	sbrc r30 ,6
;	jmp commence
;jmp wat

commence:
	ldi r16, 0b00010000
	ldi r22,1
	clr r17
	clr r21
	ldi r25, 1
	clr r26

	clr r19
	out portd, r16
	call display
	out portd, r21
sei

timeLoop:
	nop
	jmp timeLoop

valueObtained:
	cli	
	clr r21
	lsr r18
	dec r18
	mov r21, r18

		;The following code hard codes for numbers 10-15
	cpi r21,0x0a
breq ten
	cpi r21, 0x0b
breq elev
	cpi r21, 0x0c
breq twelve
	cpi r21, 0x0d
breq thirt
	cpi r21,0x0e
breq fourt
	cpi r21,0x0f
breq fift

dis:
	out portc,r27
	out portb, r21
jmp pickMode


counting:
	inc r18
reti

pulseInp:
	cpi r26, 0
	brne valueObtained
	call setr26
reti

setr26:
	clr r18
	ldi r26, 1
ret

ten:
	ldi r21,0x10
jmp dis
elev:
	ldi r21,0x11
jmp dis
twelve:
	ldi r21,0x12
jmp dis
thirt:
	ldi r21,0x13
jmp dis
fourt:
	ldi r21,0x14
jmp dis
fift:
	ldi r21,0x15
jmp dis
