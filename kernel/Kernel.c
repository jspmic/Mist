void __attribute__((noreturn)) main(void) {
    volatile unsigned short *vga = (volatile unsigned short*)0xB8000;
    vga[6] = '!' | (0x07 << 8);   // 6-й символ (сдвиг 12 байт), белый на чёрном
    for(;;) __asm__ volatile("hlt");
}
