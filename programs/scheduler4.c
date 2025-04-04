#include <stdio.h>
#include <stdlib.h>
// #define DATA_SIZE   (1024)  // 100 KB of data
// #define LINE_SIZE   (1024)    // Each line is 1 KB, so 100 lines total
#define NUM_LINES   (1000)

// // Simulated memory for accelerator MMIO (one line of data)
// volatile unsigned char accelerator_mmio[LINE_SIZE];

// // Global data buffer representing 100 KB memory
unsigned int memory_data[NUM_LINES];
unsigned int command_data[NUM_LINES];

unsigned int hardware_data[8][8][100];

int main(void)
{
    int b;
    int a;
    int c;


    // Initialize the memory buffer with some sample data
    for (int i = 0; i < NUM_LINES; i++) {
        memory_data[i] = (unsigned int)(i % 30);
        command_data[i] = 300;
    }

    // Main scheduling loop (runs indefinitely)

    // offload_task(memory_data, 0);


    b = 2;
    c = 1;

    if (b == 1) {
        a = command_data[c];
        for (int i = 0; i < a; i++) {
            hardware_data[0][b][i] = memory_data[i];
        }

    } else if (b == 2) {
        for (int i = 0; i < 200; i++) {
            hardware_data[0][b][i] = memory_data[i];
        }

    } else if (b == 3) {
        for (int i = 0; i < 700; i++) {
            hardware_data[0][b][i] = memory_data[i];
        }

    } else if (b == 4) {
        for (int i = 0; i < 100; i++) {
            a = a + 1;
        }
    } else if (b == 5) {
        for (int i = 0; i < 50; i++) {
            a = a + 1;
        }
    } else if (b == 6) {
        for (int i = 0; i < 60; i++) {
            a = a + 1;
        }
    } else if (b == 7) {
        for (int i = 0; i < 70; i++) {
            a = a + 1;
        }
    } else if (b == 8) {
        for (int i = 0; i < 80; i++) {
            a = a + 1;
        }
    } else if (b == 9) {
        for (int i = 0; i < 90; i++) {
            a = a + 1;
        }
    } else if (b == 10) {
        for (int i = 0; i < 100; i++) {
            a = a + 1;
        }
    } else if (b == 11) {
        for (int i = 0; i < 110; i++) {
            a = a + 1;
        }
    } else if (b == 12) {
        for (int i = 0; i < 120; i++) {
            a = a + 1;
        }
    } else if (b == 13) {
        for (int i = 0; i < 130; i++) {
            a = a + 1;
        }
    } else if (b == 14) {
        for (int i = 0; i < 140; i++) {
            a = a + 1;
        }
    } else if (b == 15) {
        for (int i = 0; i < 150; i++) {
            a = a + 1;
        }
    } else if (b == 16) {
        for (int i = 0; i < 160; i++) {
            a = a + 1;
        }
    } else if (b == 17) {
        for (int i = 0; i < 170; i++) {
            a = a + 1;
        }
    } else if (b == 18) {
        for (int i = 0; i < 180; i++) {
            a = a + 1;
        }
    } else if (b == 19) {
        for (int i = 0; i < 190; i++) {
            a = a + 1;
        }
    } else if (b == 20) {
        for (int i = 0; i < 200; i++) {
            a = a + 1;
        }
    } else if (b == 21) {
        for (int i = 0; i < 210; i++) {
            a = a + 1;
        }
    } else if (b == 22) {
        for (int i = 0; i < 220; i++) {
            a = a + 1;
        }
    } else if (b == 23) {
        for (int i = 0; i < 230; i++) {
            a = a + 1;
        }
    } else if (b == 24) {
        for (int i = 0; i < 240; i++) {
            a = a + 1;
        }
    } else if (b == 25) {
        for (int i = 0; i < 250; i++) {
            a = a + 1;
        }
    } else if (b == 26) {
        for (int i = 0; i < 260; i++) {
            a = a + 1;
        }
    } else if (b == 27) {
        for (int i = 0; i < 270; i++) {
            a = a + 1;
        }
    } else if (b == 28) {
        for (int i = 0; i < 280; i++) {
            a = a + 1;
        }
    } else if (b == 29) {
        for (int i = 0; i < 290; i++) {
            a = a + 1;
        }
    } else if (b == 30) {
        for (int i = 0; i < 300; i++) {
            a = a + 1;
        }
    } else {
        a = 1;
    }


    return 0;
}
