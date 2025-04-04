#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <stdint.h>

#define DATA_SIZE   (10240)  // 100 KB of data
#define LINE_SIZE   (1024)    // Each line is 1 KB, so 100 lines total
#define NUM_LINES   (1000)

// Simulated memory for accelerator MMIO (one line of data)
volatile unsigned char accelerator_mmio[LINE_SIZE];

// Global data buffer representing 100 KB memory
unsigned char memory_data[DATA_SIZE];


/**
 * @brief Offload one line of data to the accelerator via MMIO.
 *
 * In a real system, this would involve writing to hardware registers.
 * Here, we simulate the MMIO write by copying the data.
 *
 * @param data Pointer to the start of the data line.
 */
void mmio_offload(const unsigned char *data)
{
    for (int i = 0; i < LINE_SIZE; i++) {
        accelerator_mmio[i] = data[i];
    }
    // Simulate a short processing delay
    // usleep(1000);  // 1 millisecond
}

/**
 * @brief Offload a complete task to the accelerator.
 *
 * This function offloads NUM_LINES lines of data and identifies the task by task_id.
 *
 * @param data Pointer to the start of the data buffer.
 * @param task_id Identifier for the task being offloaded.
 */
void offload_task(const unsigned char *data, int task_id)
{

    mmio_offload(data + 10*NUM_LINES));

    // printf("Task %d offloaded successfully.\n", task_id);
}


int main(void)
{
    int interrupt_val;



    // Initialize the memory buffer with some sample data
    for (int i = 0; i < DATA_SIZE; i++) {
        memory_data[i] = (unsigned char)(i % 256);
    }

    // Main scheduling loop (runs indefinitely)

    offload_task(memory_data, 0);


    interrupt_val = 2;
    switch (interrupt_val) {
        case 1:
            offload_task(memory_data, 1);
            break;
        case 2:
            offload_task(memory_data, 2);
            break;
        case 3:
            offload_task(memory_data, 3);
            break;
        case 4:
            offload_task(memory_data, 4);
            break;
        default:
            printf("Unknown interrupt value: %d\n", interrupt_val);
            break;
    }


    return 0;
}
