C := $(wildcard msc/drivers/*.c msc/kernel/*.c msc/mistlibc/*.c)
O := $(C:.c=.o)
BUILD_DIR=mbin
BUILD_DIRS=$(BUILD_DIR)/kernel		\
		   $(BUILD_DIR)/Minit		\
		   $(BUILD_DIR)/drivers		\
		   $(BUILD_DIR)/mistlibs	\

all: builder

$(BUILD_DIR)/Minit/BootLoader.bin: msc/Minit/BootLoader.asm
	nasm -f bin $< -o $@

$(BUILD_DIR)/kernel/Kernel.elf: $(O)
	ld -m elf_x86_64 -T linker.ld -nostdlib -o $@ $^

$(BUILD_DIR)/kernel/Kernel.bin: $(BUILD_DIR)/kernel/Kernel.elf
	llvm-objcopy -O binary $< $@

builder: make-dir $(BUILD_DIR)/Mist.img

$(BUILD_DIR)/Mist.img: mbin/Minit/BootLoader.bin mbin/kernel/Kernel.bin
	cat $^ > $@

%.o: %.c
	clang --target=x86_64-elf -ffreestanding -fno-stack-protector -mno-red-zone -mno-sse -mno-sse2 -fno-pie -fno-builtin -nostdlib -O2 -Wall -Wextra -Imsc/headers -c $< -o $@

run: $(BUILD_DIR)/Mist.img
	qemu-system-x86_64 -drive format=raw,file=$(BUILD_DIR)/Mist.img -no-reboot

make-dir:
	@mkdir -p $(BUILD_DIR)
	@- $(foreach X, $(BUILD_DIRS), mkdir -p $X;)

clean:
	rm -f $(BUILD_DIR)/Minit/* $(BUILD_DIR)/drivers/* $(BUILD_DIR)/kernel/* $(BUILD_DIR)/mistlibs/* $(BUILD_DIR)/Mist.img
	rm -rf $(BUILD_DIR)

.PHONY: all run clean
