# EECS 573 Project

## GPU Concurrency Example
https://www.youtube.com/watch?v=v9W5CzJkOV8&ab_channel=catblue

## To-do List
- [X] Clean up Makefile (import from 470)
- [ ] Write C program & compile
- [ ] Calculate the latency of switching kernel in C (CPU)
- [ ] Estimate the latency of switching kernel in RTL (Hardware)

1. Single thread performance
   - Different PE instruction size for PE
   - Different computation latency
   - Different CPU performance
   - Different scheduling algorithm

2. Multi thread performance
   - Different # of thread
   - Different scheduling algorithm (affect utilization)

## Expectation
- More instruction -> More scheduling overhead
- More computation latency -> Less scheduling overhead
- More complex scheduling -> More scheduling overhead


# Slide
   1. Background  - Accelerator scheduling hard
   2. Motivation  - How to schedule accelerator fast
   3. Amber
   4. Proposal
   5. Cpu control overhead performance modeling
   6. Our hardware performance modeling