# Pipelined-Processor
Designing and building a pipelined RISC processor in VHDL

Single-cycle processors are not very efficient. Not all instructions are equal in length, all instructions in a single cycle non-pipelined structure do not necessarily take the same amount of time, but rather, the next instruction to be executed cannot start until the next clock cycle. The current instruction may complete before the current cycle because cycle length is determined by the longest instruction. An example of such seen in the previous lab is add register completes before load in a RISC. However, nowadays, processors’ efficiencies have improved drastically. A reason for such is the introduction of the pipeline process. The difference here is that instruction pipelining is a technique for implementing instruction-level parallelism within a single processor. Pipelining attempts to keep every part of the processor busy with some instruction by dividing incoming instructions into a series of sequential steps (the eponymous "pipeline") performed by different processor units with different parts of instructions processed in parallel. Pipelining involves a single datapath capable of executing multiple instructions simultaneously. Hence, pipelining is the process by which instructions are parallelized over several overlapping stages of execution, in order to maximise datapath efficiency. This project involves pipelining the single-cycle MIPS processor built in a previous project, through its division into 5 stages of execution, as well as the addition of pipeline registers containing both data and control signals.

The pipeline is broken down into 5 stages, called the 5-stage MIPS instruction pipeline. These 5instructions are as follows:
• Fetch instruction from memory (IF)
• Read registers while decoding the instruction (ID)
• Execute the operation or calculate an address (EX)
• Access an operand in data memory (MEM)
• Write the result into a register (WB)

In order to convert our single-cycle processor from the previous project, we will need to break it up, as previously mentioned, into those 5 stages, as well as add pipeline registers. These registers have a role of storing the control and data that will be utilized later on in the pipeline.
