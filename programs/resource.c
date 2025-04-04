#include <stdio.h>
#include <stdlib.h>
// #define DATA_SIZE   (1024)  // 100 KB of data
// #define LINE_SIZE   (1024)    // Each line is 1 KB, so 100 lines total
#define NUM_LINES   (1000)

// // Simulated memory for accelerator MMIO (one line of data)
// volatile unsigned char accelerator_mmio[LINE_SIZE];

// // Global data buffer representing 100 KB memory
// unsigned int memory_data[NUM_LINES];
// unsigned int command_data[NUM_LINES];

unsigned int pe_resource[8][8];
unsigned int switch_resource[8][8][8];
unsigned int dma_resource[8];

int main(void)
{
    int b;
    int a;
    int c;

    int row_id, col_id;
    int row_shape, col_shape;
    int sw_row_id, sw_col_id, sw_port_id;
    int dma_id;


    row_id = 2;
    col_id = 1;
    row_shape = 3;
    col_shape = 5;

    sw_row_id = 2;
    sw_col_id = 2;
    sw_port_id = 2;

    dma_id = 5;

    if(pe_resource[row_id] != 1){
        if (pe_resource[col_id] != 1) {
            if (dma_resource[dma_id] != 1) {

            }
        }
    }


    return 0;
}
