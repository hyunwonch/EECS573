#include <stdio.h>
#include <stdlib.h>

#define NUM_TREES 10
#define NUM_STAGES 10
#define NUM_BRANCHES 4
#define TOTAL_KERNELS (NUM_TREES * NUM_STAGES)
#define HW_OFFSET 500
#define HW_MEM_SIZE (HW_OFFSET + TOTAL_KERNELS)

// Each kernel has four branches, each branch holds a 16-bit task value.
typedef struct {
    unsigned short branches[NUM_BRANCHES];
} Kernel;

// Simulated system memory: one Kernel (64-bit line) per stage.
Kernel kernels[TOTAL_KERNELS];

// Simulated hardware memory (each element is a 64-bit line).
// The hardware memory “address” starts at HW_OFFSET.
unsigned long long hw_memory[HW_MEM_SIZE];

// Initialize each kernel with a sample task value per branch.
// For simplicity, the value is computed from tree, stage and branch.
void init_kernels() {
    int tree, stage, branch;
    for (tree = 0; tree < NUM_TREES; tree++) {
        for (stage = 0; stage < NUM_STAGES; stage++) {
            int idx = tree * NUM_STAGES + stage;
            for (branch = 0; branch < NUM_BRANCHES; branch++) {
                kernels[idx].branches[branch] = (unsigned short)(tree * 100 + stage * 10 + branch);
            }
        }
    }
}

// Offload the task for the given tree, stage, and branch.
// The offload copies the 16-bit task value from system memory (kernels)
// to a simulated hardware memory location computed as HW_OFFSET + index.
void offload_task(int tree, int stage, int branch) {
    if (tree < 0 || tree >= NUM_TREES ||
        stage < 0 || stage >= NUM_STAGES ||
        branch < 0 || branch >= NUM_BRANCHES) {
        printf("Invalid interrupt parameters.\n");
        return;
    }

    int idx = tree * NUM_STAGES + stage;
    unsigned short task = kernels[idx].branches[branch];
    int hw_addr = HW_OFFSET + idx;  // Map to hardware memory address
    hw_memory[hw_addr] = task;      // Offload task (copy value)

    printf("Offloaded task from tree %d, stage %d, branch %d: value %hu to hardware address %d\n",
           tree, stage, branch, task, hw_addr);
}

int main() {
    int tree, stage, branch;

    // Initialize our system memory with tasks.
    init_kernels();
    tree = 1;
    stage = 5;
    branch = 2;
    // Simulation loop: read an “interrupt” and offload the corresponding task.
    // The interrupt is simulated by user input in the format: tree stage branch.

    offload_task(tree, stage, branch);

    return 0;
}
