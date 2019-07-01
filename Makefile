

SUB_PATH=/home/k/src/os/haribote/tolset/z_tools/

all :
	@make haribote.img

ipl10.bin:	ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin: asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

naskfunc.o: naskfunc.asm Makefile
	nasm -f coff naskfunc.asm -o naskfunc.o -l naskfunc.lst

bootpack.hrb: bootpack.c naskfunc.o Makefile har.ld
	gcc -c bootpack.c -m32 -nostdlib -fno-pie -O0 -Wall
	gcc -m32 -nostdlib -T har.ld -g bootpack.o  naskfunc.o -o bootpack.hrb -fno-pie -O0 -Wall 

haribote.sys: asmhead.bin bootpack.hrb  Makefile
	@cat asmhead.bin bootpack.hrb > haribote.sys


haribote.img: ipl10.bin haribote.sys Makefile
	@mformat -f 1440 -B ipl10.bin -C -i haribote.img
	@mcopy haribote.sys -i haribote.img ::

debug:
	@qemu-system-i386 -usb haribote.img 


clean:
	@rm *.sys *.bin *.lst *.img *.o

