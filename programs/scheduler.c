#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <stdint.h>

#define DATA_SIZE   (102400)  // 100 KB of data
#define LINE_SIZE   (1024)    // Each line is 1 KB, so 100 lines total
#define NUM_LINES   (1000)

// Simulated memory for accelerator MMIO (one line of data)
volatile unsigned char accelerator_mmio[LINE_SIZE];

// Global data buffer representing 100 KB memory
unsigned char memory_data[DATA_SIZE];

static void delay_ms(uint32_t ms)
{
    // This is purely illustrative: the constant 1000 is not correct for all CPUs.
    // You must tune it to match your CPU frequency and desired delay.
    volatile uint32_t i;
    while (ms--) {
        for (i = 0; i < 100000; i++) {
            // Prevent the compiler from optimizing away the loop
            __asm__ volatile ("nop");
        }
    }
}

static void my_sleep(int seconds)
{
    // Convert seconds to ms for your delay function
    delay_ms(seconds * 100);
}

/**
 * @brief Simulate waiting for an interrupt.
 *
 * This function sleeps for one second to mimic a delay and then returns
 * a random interrupt value between 1 and 4.
 *
 * @return int The simulated interrupt value.
 */
int simulate_interrupt(void)
{
    my_sleep(1);  // Simulate waiting time for an interrupt
    return (rand() % 4) + 1;  // Return a value in the range 1-4
}

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
    // printf("Offloading task %d...\n", task_id);
    for (int i = 0; i < NUM_LINES; i++) {
        mmio_offload(data + (i * LINE_SIZE));
    }
    // printf("Task %d offloaded successfully.\n", task_id);
}


int main(void)
{
    int interrupt_val;

    // Seed the random number generator for interrupt simulation
    srand(time(NULL));

    // Initialize the memory buffer with some sample data
    for (int i = 0; i < DATA_SIZE; i++) {
        memory_data[i] = (unsigned char)(i % 256);
    }

    // Main scheduling loop (runs indefinitely)
    while (1) {
        offload_task(memory_data, 0);


        interrupt_val = simulate_interrupt();
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
    }

    return 0;
}
