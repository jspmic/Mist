#include <mist.h>

void __attribute__((section(".text.start"), noreturn)) main(void) {
    pmm_init();
    clear();
    print("Welcome to Mist!");
    print("\nMist - tiny x86_64 operating system");
    print("\nNow it have:");
    print("\n  1. Paging");
    print("\n  2. GDT");
    print("\n  3. Screen work tools");
    print("\n  4. Memory work tools");
    print("\n  5. VGA driver");
    print("\n  6. PMM");
    for(;;) __asm__ volatile("hlt");
}
