[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_io_hlt@PLT
[FILE "bootpack.c"]
[SECTION .text]
	GLOBAL	HariMain
HariMain:
	
	XOR	EAX,EAX
	CALL	_io_hlt@PLT
	JMP	.L2
