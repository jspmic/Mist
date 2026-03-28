all: os.img

boot/boot.bin: boot/boot.asm
	nasm -f bin $< -o $@

kernel/kernel.o: kernel/kernel.c
	gcc -ffreestanding -mcmodel=kernel -mno-red-zone -nostdlib -fno-pie -no-pie -c $< -o $@

kernel/kernel.bin: kernel/kernel.o
	ld -Ttext=0x100000 -nostdlib -e kernel_main $< -o $@

os.img: boot/boot.bin kernel/kernel.bin
	cat boot/boot.bin kernel/kernel.bin > os.img

run: os.img
	qemu-system-x86_64 -drive format=raw,file=os.img -d int,cpu_reset -no-reboot

clean:
	rm -f boot/*.bin kernel/*.bin kernel/*.o os.img

.PHONY: all run clean
