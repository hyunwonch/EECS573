#include <stdio.h>
#include <stdlib.h>
// #define DATA_SIZE   (1024)  // 100 KB of data
// #define LINE_SIZE   (1024)    // Each line is 1 KB, so 100 lines total
// #define NUM_LINES   (1000)

// // Simulated memory for accelerator MMIO (one line of data)
// volatile unsigned char accelerator_mmio[LINE_SIZE];

// // Global data buffer representing 100 KB memory
// unsigned char memory_data[DATA_SIZE];



int main(void)
{
    int interrupt_val;
    int a;


    // Initialize the memory buffer with some sample data
    // for (int i = 0; i < DATA_SIZE; i++) {
    //     memory_data[i] = (unsigned char)(i % 256);
    // }

    // Main scheduling loop (runs indefinitely)

    // offload_task(memory_data, 0);

    a = 0;
    interrupt_val = 2;
    // switch (interrupt_val) {
    //     case 1:
    //         for (int i = 0; i < 50; i++) {
    //             a = a + 1;
    //         }
    //     case 2:
    //         for (int i = 0; i < 10; i++) {
    //             a = a + 1;
    //         }
    //     case 3:
    //         for (int i = 0; i < 20; i++) {
    //             a = a + 1;
    //         }
    //     case 4:
    //         for (int i = 0; i < 2000; i++) {
    //             a = a + 1;
    //         }
    // }
    return 0;
}
