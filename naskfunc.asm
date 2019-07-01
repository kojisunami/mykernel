; naskfunc
; TAB=4

BITS	32

	GLOBAL	_io_hlt, _write_mem8
	GLOBAL _io_cli, _io_sti, _io_stihlt
	GLOBAL _io_in8, _io_in16, _io_in32
	GLOBAL _io_out8, _io_out16, _io_out32
	GLOBAL _io_load_eflags, _io_store_eflags


section .bss

section .data


SECTION .text

_write_mem8: ; void write_mem8(int addr, int data);
	MOV ECX,[ESP+4]
	MOV	AL,[ESP+8]
	MOV	[ECX],AL
	RET

_io_cli:
	CLI
	RET

_io_sti:
	STI
	RET

_io_stihlt:
	STI
	HLT
	RET

_io_in8:
	MOV	EDX,[ESP+4]
	MOV	EAX,0
	IN	AL,DX
	RET

_io_in16:
	MOV	EDX,[ESP+4]
	MOV	EAX,0
	IN	AX,DX
	RET

_io_in32:
	MOV	EDX,[ESP+4]
	MOV	EAX,EDX
	RET

_io_out8: ; void_io_out8(int port, int data)
	MOV	EDX,[ESP+4]; port 
	MOV	AL,[ESP+8] ; data
	OUT	DX,AL
	RET

_io_out16:
	MOV	EDX,[ESP+4]
	MOV	EAX,[ESP+8]
	OUT	DX,AX
	RET

_io_out32:
	MOV	EDX,[ESP+4]
	MOV	EAX,[ESP+8]
	OUT	DX,EAX
	RET

_io_load_eflags:
	PUSHFD
	POP EAX
	RET

_io_store_eflags:
	MOV	EAX,[ESP+4]
	PUSH	EAX
	POPFD
	RET

_io_hlt:	; void io_hlt(void);
	HLT
	RET

