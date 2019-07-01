; hello-os
; TAB=4

BITS 16
; bootloader
CYLS	EQU	10	
	
	ORG	0x7c00
	
	JMP	entry
	NOP

	DB	"HARIBOTE"
	DW	0x200
	DB	0x01
	DW	0x0001
	DB	0x02
	DW	0x0000
	DW	0x0000
	DB	0xf8
	DW	0x0000
	DW	0xffff
	DW	0x0001
	DD	0x00000000
	DD	0x00ee5000
	DD	0x000000ed
	DW	0x0000
	DW	0x0000
	DD	0x00000000
	DW	0x0001
	DW	0x0000
		times	12	DB 0
	DB	0x80
	DB	0x00
	DB	0x29
	DD	0xa0a615c
	DB	"ISHIHA BOOT"
	DB	"FAT32   "

drv:
	DB	0x80
DAPS:
	DB	0x10
	DB	0
	DB	1
	DB	0
addr:
	DW	0x8000
segm:
	DW	0x0000
lba0:
	DD	1
	DD	0
entry:
	CLI

	MOV	AX,0
	MOV	DS,AX
	MOV	SS,AX
	MOV	ES,AX
	MOV	BX,AX
	MOV	CX,AX
	MOV	SP,0x7c00

prepare:
	STI
	MOV [drv],DL
	MOV	AH,0x41
	MOV	word bx, 0x55aa
	INT	0x13
	JC	unsupported
	XOR	ax,ax
	ADD	ax,1
	XOR	EDI,EDI
	
	MOV	AH,0x45
	MOV	AL,0x01
	MOV	DL,0x80
	INT	0x13

	MOV	AX,0
	MOV	DS,AX

loop:
	MOV CL,0

retry:

	PUSH	DS
	PUSHAD
	MOV	DL,[drv]
	MOV	AH,0x42
	MOV	AL,0x00
	MOV	SI,DAPS
	INT	0x13
	JNC	next

	ADD	CL,1
	MOV	DL,0x90
	MOV	AH,0x00
	INT	0x13
	CMP	CL,6
	JAE	error
	JMP	retry

next:
	XOR	EAX,EAX	
	XOR	EBX,EBX	
	XOR	ECX,ECX	

	ADD	EDI,1
	MOV	ECX,lba0
	MOV[ECX],EDI

	XOR	EAX,EAX
	XOR	ECX,ECX
	XOR	EBP,EBP

	MOV	AX,[addr]
	MOV	ECX,addr
	MOV	EBX,segm
	ADD	AX,0x200
	ADC	BP,0
	SHL	BP,12
	ADD	BP,[segm]
	MOV	[EBX],BP

	MOV	[ECX],AX
	MOV	[EBX],BP

	CMP	EDI,0x16a
	JB	loop

	MOV	ECX, 0xc200

	MOV	EAX	,0x0000
	MOV	EBX,EAX
	MOV	EDX,EAX
	MOV	EBP,EAX
	MOV	ESI,EAX
	MOV	EDI,EAX
	
	MOV	CH,10
	MOV	[0x0ff0],CH

	MOV	ECX,EAX
	JMP	0x0000:0xc200

error:
	POPAD
	POP	DS
	MOV	SI,msg

putloop:
	MOV AL,[SI]
	ADD	SI,1
	CMP AL,0
	JE	fin
	MOV	AH,0x0e

	MOV	BX,0
	INT	0x10
	JMP	putloop


fin:
	HLT
	JMP	0xc200


msg:
	DB	0x0a,0x0a
	DB	"load error"
	DB	0x0a
	DB	0

msg1:
	DB	0x0a,0x0a
	DB	"unsupported"
	DB	0x0a
	DB	0

unsupported:
	MOV	SI,msg1
	JMP	putloop





	RESB	0x84

	DB		0x55, 0xaa



