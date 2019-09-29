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

pickMode:;In this mode the slide switch regulates what mode the program is in
	in r16,pind
	clr r21
	clr r29
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

ten2:
	ldi r29,0x10
jmp backAgain
elev2:
	ldi r29,0x11
jmp backAgain
twelve2:
	ldi r29,0x12
jmp backAgain

diScore:
	cpi r29,0
	brlt negative
	cpi r29,0
	brge positive
positive:
	out portc,r25

	cpi r29,0x0a
	breq ten2
	cpi r29,0x0b
	breq elev2
	cpi r29,0x0c
	breq twelve2

	backAgain:
	out portb,r29
jmp pickMode
negative: 
	out portc,r27
	neg r29
	out portb,r29
jmp pickMode

ten1:
	ldi r16,0x10
jmp here
elev1:
	ldi r16,0x11
jmp here
twelve1:
	ldi r16,0x12
jmp here
thirt1:
	ldi r16,0x13
jmp here
fourt1:
	ldi r16,0x14
jmp here
fift1:
	ldi r16,0x15
jmp here


gameMode:
wait:
	in r16,pind
	sbrc r16,5
	jmp pickMode
	in r30,pinc
	sbrc r30, 3
	jmp comm
jmp wait

comm:
clr r30
flip:
	inc r30
	ldi r24,5
	ldi r25,0b00000001
	ldi r27,0b00000100
;	sei
	in r16,tcnt0
	ldi r17,0b00001111
	and r16,r17
	dec r16
	mov r31,r16

cpi r16,0x0a
	breq ten1
cpi r16, 0x0b
	breq elev1
cpi r16, 0x0c
	breq twelve1
cpi r16, 0x0d
	breq thirt1
cpi r16,0x0e
	breq fourt1
cpi r16,0x0f
	breq fift1

here:
clr r20
lerp:
	inc r20
	out portb,r16
	ldi r19,19
	call display
	cpi r20,10
brne lerp
	jmp flerp;this is done to obtain a region

valObt:
cpse r21,r31
	jmp tryAgainBub
	jmp youGotIt

hereWeGoAgain:
	cpi r30,6
	brne flip;this loops the code 6 times
	call display
	clr r31
	out portc,r31
	ldi r19,50
	call display
	jmp diScore
jmp pickMode

youGotIt:
	ldi r17,2
	out portc,r25
	add r29,r17
jmp hereWeGoAgain

tryAgainBub:
	cpse r21,r31
	nop
	subi r29,1
	ldi r17,2
	ldi r31,15
	out portc,r27
	cpse r21,r31
	mov r17,r27
	out portc,r17

jmp hereWeGoAgain

getRegion:

wat:
	in r31,pinc
	sbrc r31 ,3
	jmp commence
jmp wat

commence:
	clr r24
flerp:
	ldi r28, 0b00010000
	ldi r22,1
	clr r17
	clr r21
	clr r26

	clr r19
	out portd, r28
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

	cpi r24,5
	breq valObt

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
	clr r19
	out portc,r19
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
