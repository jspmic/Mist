all: Mist.img

boot/BootLoader.bin: boot/BootLoader.asm
	nasm -f bin $< -o $@

kernel/Kernel.bin: kernel/Kernel.c
	gcc -m64 -fno-stack-protector -ffreestanding -O2 -Wall -Wextra -fno-omit-frame-pointer -mno-red-zone -mcmodel=small -fno-pie -no-pie -c $< -o kernel/Kernel.o
	ld -m elf_x86_64 -Ttext=0x100000 --oformat=binary -e main -N -nostdlib kernel/Kernel.o -o $@

Mist.img: boot/BootLoader.bin kernel/Kernel.bin
	cat boot/BootLoader.bin kernel/Kernel.bin > Mist.img

run: Mist.img
	qemu-system-x86_64 -drive format=raw,file=Mist.img -d cpu -D MistLog.txt

clean:
	rm -f boot/*.bin kernel/*.bin kernel/*.o Mist.img

.PHONY: all run clean
