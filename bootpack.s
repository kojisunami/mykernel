	.file	"bootpack.c"
	.text
	.globl	HariMain
	.type	HariMain, @function
HariMain:
.LFB0:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
.L2:
	xorl	%eax, %eax
	call	_io_hlt@PLT
	jmp	.L2
	.cfi_endproc
.LFE0:
	.size	HariMain, .-HariMain
	.ident	"GCC: (GNU) 8.2.1 20181127"
	.section	.note.GNU-stack,"",@progbits
