/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  cpu.sv                                              //
//                                                                     //
//  Description :  Top-level module of the verisimple processor;       //
//                 This instantiates and connects the 5 stages of the  //
//                 Verisimple pipeline together.                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`include "sys_defs.svh"

module cpu (
    input clock, // System clock
    input reset, // System reset

    input MEM_TAG   mem2proc_transaction_tag, // Memory tag for current transaction
    input MEM_BLOCK mem2proc_data,            // Data coming back from memory
    input MEM_TAG   mem2proc_data_tag,        // Tag for which transaction data is for

    output MEM_COMMAND proc2mem_command, // Command sent to memory
    output ADDR        proc2mem_addr,    // Address sent to memory
    output MEM_BLOCK   proc2mem_data,    // Data sent to memory
    output MEM_SIZE    proc2mem_size,    // Data size sent to memory

    // Note: these are assigned at the very bottom of the module
    output COMMIT_PACKET [`N-1:0] committed_insts,

    // Debug outputs: these signals are solely used for debugging in testbenches
    // Do not change for project 3
    // You should definitely change these for project 4
    output ADDR  if_NPC_dbg,
    output DATA  if_inst_dbg,
    output logic if_valid_dbg,
    output ADDR  if_id_NPC_dbg,
    output DATA  if_id_inst_dbg,
    output logic if_id_valid_dbg,
    output ADDR  id_ex_NPC_dbg,
    output DATA  id_ex_inst_dbg,
    output logic id_ex_valid_dbg,
    output ADDR  ex_mem_NPC_dbg,
    output DATA  ex_mem_inst_dbg,
    output logic ex_mem_valid_dbg,
    output ADDR  mem_wb_NPC_dbg,
    output DATA  mem_wb_inst_dbg,
    output logic mem_wb_valid_dbg
);

    //////////////////////////////////////////////////
    //                                              //
    //                Pipeline Wires                //
    //                                              //
    //////////////////////////////////////////////////

    // Pipeline register enables
    logic if_id_enable, id_ex_enable, ex_mem_enable, mem_wb_enable;

    // Outputs from IF-Stage and IF/ID Pipeline Register
    ADDR Imem_addr;
    IF_ID_PACKET if_packet, if_id_reg;

    // Outputs from ID stage and ID/EX Pipeline Register
    ID_EX_PACKET id_packet, id_ex_reg;

    // Outputs from EX-Stage and EX/MEM Pipeline Register
    EX_MEM_PACKET ex_packet, ex_mem_reg;

    // Outputs from MEM-Stage and MEM/WB Pipeline Register
    MEM_WB_PACKET mem_packet, mem_wb_reg;

    // Outputs from MEM-Stage to memory
    ADDR        Dmem_addr;
    MEM_BLOCK   Dmem_store_data;
    MEM_COMMAND Dmem_command;
    MEM_SIZE    Dmem_size;

    // Outputs from WB-Stage (These loop back to the register file in ID)
    COMMIT_PACKET wb_packet;

    //////////////////////////////////////////////////
    //                                              //
    //                Memory Outputs                //
    //                                              //
    //////////////////////////////////////////////////

    // these signals go to and from the processor and memory
    // we give precedence to the mem stage over instruction fetch
    // note that there is no latency in project 3
    // but there will be a 100ns latency in project 4

    always_comb begin
        if (Dmem_command != MEM_NONE) begin  // read or write DATA from memory
            proc2mem_command = Dmem_command;
            proc2mem_size    = Dmem_size;   // size is never DOUBLE in project 3
            proc2mem_addr    = Dmem_addr;
        end else begin                      // read an INSTRUCTION from memory
            proc2mem_command = MEM_LOAD;
            proc2mem_addr    = Imem_addr;
            proc2mem_size    = DOUBLE;      // instructions load a full memory line (64 bits)
        end
        proc2mem_data = Dmem_store_data;
    end

    //////////////////////////////////////////////////
    //                                              //
    //                  Valid Bit                   //
    //                                              //
    //////////////////////////////////////////////////

    // This state controls the stall signal that artificially forces IF
    // to stall until the previous instruction has completed.
    // For project 3, start by assigning if_valid to always be 1

    logic if_valid, start_valid_on_reset, wb_valid;


    always_ff @(posedge clock) begin
        // Start valid on reset. Other stages (ID,EX,MEM,WB) start as invalid
        // Using a separate always_ff is necessary since if_valid is combinational
        // Assigning if_valid = reset doesn't work as you'd hope :/
        start_valid_on_reset <= reset;
    end

    // valid bit will cycle through the pipeline and come back from the wb stage
    // assign if_valid = start_valid_on_reset || wb_valid;
    // assign if_valid = '1;

    logic ex_mem_branch, mem_wb_branch;

    logic fwd_after_lw_a, fwd_after_lw_b;

    always_comb begin
        if(ex_mem_reg.valid && (ex_mem_reg.wr_mem || ex_mem_reg.rd_mem) || ex_mem_reg.take_branch) begin
            if_valid = '0;
        end else if (fwd_after_lw_a || fwd_after_lw_b) begin
            if_valid = '0;
        end else begin
            if_valid = '1;
        end
    end

    //////////////////////////////////////////////////
    //                                              //
    //                  IF-Stage                    //
    //                                              //
    //////////////////////////////////////////////////

    stage_if stage_if_0 (
        // Inputs
        .clock (clock),
        .reset (reset),
        .if_valid      (if_valid),
        .take_branch   (ex_mem_reg.take_branch),
        .branch_target (ex_mem_reg.alu_result),
        .Imem_data     (mem2proc_data),

        // Outputs
        .if_packet (if_packet),
        .Imem_addr (Imem_addr)
    );

    // debug outputs
    assign if_NPC_dbg   = if_packet.NPC;
    assign if_inst_dbg  = if_packet.inst;
    assign if_valid_dbg = if_packet.valid;

    //////////////////////////////////////////////////
    //                                              //
    //            IF/ID Pipeline Register           //
    //                                              //
    //////////////////////////////////////////////////

    assign if_id_enable = 1'b1; // always enabled
    // Disable when taking branch -> Need to flush
    // always_comb begin
    //     if(ex_packet.take_branch) begin
    //         if_id_enable = 1'b0;
    //     end else begin
    //         if_id_enable = 1'b1;
    //     end
    // end

    IF_ID_PACKET if_packet_stall;

    always_comb begin
        if(fwd_after_lw_a || fwd_after_lw_b) begin
            if_packet_stall = if_id_reg;
        end else if (ex_packet.take_branch) begin
            if_packet_stall.inst  = `NOP;
            if_packet_stall.valid = `FALSE;
            if_packet_stall.NPC   = '0;
            if_packet_stall.PC    = '0;
        end else begin
            if_packet_stall = if_packet;
        end
    end


    always_ff @(posedge clock) begin
        if (reset) begin
            if_id_reg.inst  <= `NOP;
            if_id_reg.valid <= `FALSE;
            if_id_reg.NPC   <= 0;
            if_id_reg.PC    <= 0;
        end else begin
            if_id_reg       <= if_packet_stall;
        end
    end

    // debug outputs
    assign if_id_NPC_dbg   = if_id_reg.NPC;
    assign if_id_inst_dbg  = if_id_reg.inst;
    assign if_id_valid_dbg = if_id_reg.valid;

    //////////////////////////////////////////////////
    //                                              //
    //                  ID-Stage                    //
    //                                              //
    //////////////////////////////////////////////////

    stage_id stage_id_0 (
        // Inputs
        .clock           (clock),
        .reset           (reset),
        .if_id_reg       (if_id_reg),
        .wb_regfile_en   (wb_packet.valid),
        .wb_regfile_idx  (wb_packet.reg_idx),
        .wb_regfile_data (wb_packet.data),

        // Output
        .id_packet (id_packet)
    );

    logic [2:0][4:0] queue;

    always_ff @(posedge clock) begin
        if (reset) begin
            queue <= '0;
        end
        else if (id_packet.inst == 32'b0000_0000_0011_0001_0010_0000_0010_0011) begin // store instruction
            queue[0] <= id_packet.inst.r.rs1;
            queue[1] <= queue[0];
            queue[2] <= queue[1];
        end else begin
            queue[0] <= id_packet.dest_reg_idx;
            queue[1] <= queue[0];
            queue[2] <= queue[1];
        end
    end


    // Check whether it is the case where forwarding after lw -> need to stall

    always_comb begin
        fwd_after_lw_a = 1'b0;
        if(id_ex_reg_mux.rd_mem) begin // load instruction cases
            if(queue[0] == if_id_reg.inst.r.rs1) begin
                fwd_after_lw_a = 1'b1;
            end
        end
    end


// `RV32_LB, `RV32_LH, `RV32_LW, `RV32_LBU, `RV32_LHU
// 00000000000000100010000100000011

    always_comb begin
        fwd_after_lw_b = 1'b0;
        if(id_ex_reg_mux.rd_mem) begin // load instruction cases
            if(queue[0] == if_id_reg.inst.r.rs2) begin
                fwd_after_lw_b = 1'b1;
            end
        end
    end

    logic fwd_after_lw_ex_a, fwd_after_lw_me_a, fwd_after_lw_wb_a;
    logic fwd_after_lw_ex_b, fwd_after_lw_me_b, fwd_after_lw_wb_b;

    always_ff @(posedge clock) begin
        if (reset) begin
            fwd_after_lw_ex_a <= '0;
            fwd_after_lw_me_a <= '0;
            fwd_after_lw_wb_a <= '0;
            fwd_after_lw_ex_b <= '0;
            fwd_after_lw_me_b <= '0;
            fwd_after_lw_wb_b <= '0;
        end else begin
            fwd_after_lw_ex_a <= fwd_after_lw_a;
            fwd_after_lw_me_a <= fwd_after_lw_ex_a;
            fwd_after_lw_wb_a <= fwd_after_lw_me_a;
            fwd_after_lw_ex_b <= fwd_after_lw_b;
            fwd_after_lw_me_b <= fwd_after_lw_ex_b;
            fwd_after_lw_wb_b <= fwd_after_lw_me_b;
        end
    end

    // Check whether it is the case where lw after sw with same register
    logic lw_after_sw,lw_after_sw_ex,lw_after_sw_me,lw_after_sw_wb;

    always_comb begin
        lw_after_sw = 1'b0;
        if(id_packet.inst == 32'b0000_0000_0000_0001_0010_0010_0000_0011) begin    // load instruction
            if(id_ex_reg_mux.inst == 32'b0000_0000_0011_0001_0010_0000_0010_0011) begin
                if(queue[0] == if_id_reg.inst.r.rs1) begin
                    lw_after_sw = 1'b1;
                end
            end
        end
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            lw_after_sw_ex <= '0;
            lw_after_sw_me <= '0;
            lw_after_sw_wb <= '0;
        end else begin
            lw_after_sw_ex <= lw_after_sw;
            lw_after_sw_me <= lw_after_sw_ex;
            lw_after_sw_wb <= lw_after_sw_me;
        end
    end

    logic mux_ex_1a_next, mux_ex_2a_next, mux_ex_3a_next, mux_ex_1a, mux_ex_2a, mux_ex_3a;
    logic mux_ex_1b_next, mux_ex_2b_next, mux_ex_3b_next, mux_ex_1b, mux_ex_2b, mux_ex_3b;

    always_comb begin
        mux_ex_1a_next = 1'b0;
        mux_ex_2a_next = 1'b0;
        mux_ex_3a_next = 1'b0;
        if(if_id_reg.valid) begin
            if(queue[0] == if_id_reg.inst.r.rs1) begin
                mux_ex_1a_next = 1'b1;
            end
            if(queue[1] == if_id_reg.inst.r.rs1) begin
                mux_ex_2a_next = 1'b1;
            end
            if(queue[2] == if_id_reg.inst.r.rs1) begin
                mux_ex_3a_next = 1'b1;
            end
        end
    end

    always_comb begin
        mux_ex_1b_next = 1'b0;
        mux_ex_2b_next = 1'b0;
        mux_ex_3b_next = 1'b0;
        if(if_id_reg.valid) begin
            if(queue[0] == if_id_reg.inst.r.rs2) begin
                mux_ex_1b_next = 1'b1;
            end
            if(queue[1] == if_id_reg.inst.r.rs2) begin
                mux_ex_2b_next = 1'b1;
            end
            if(queue[2] == if_id_reg.inst.r.rs2) begin
                mux_ex_3b_next = 1'b1;
            end
        end
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            mux_ex_1a <= '0;
            mux_ex_1b <= '0;
        end
        else if (id_ex_reg.valid) begin
            mux_ex_1a <= mux_ex_1a_next;
            mux_ex_1b <= mux_ex_1b_next;
        end
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            mux_ex_2a <= '0;
            mux_ex_2b <= '0;
        end
        else if (ex_mem_reg.valid) begin
            mux_ex_2a <= mux_ex_2a_next;
            mux_ex_2b <= mux_ex_2b_next;
        end
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            mux_ex_3a <= '0;
            mux_ex_3b <= '0;
        end
        else if (mem_wb_reg.valid) begin
            mux_ex_3a <= mux_ex_3a_next;
            mux_ex_3b <= mux_ex_3b_next;
        end
    end

    //////////////////////////////////////////////////
    //                                              //
    //            ID/EX Pipeline Register           //
    //                                              //
    //////////////////////////////////////////////////

    assign id_ex_enable = 1'b1; // always enabled
    // Disable when taking branch -> Need to flush
    // always_comb begin
    //     if(ex_packet.take_branch) begin
    //         id_ex_enable = 1'b0;
    //     end else begin
    //         id_ex_enable = 1'b1;
    //     end
    // end

    ID_EX_PACKET id_packet_stall;

    always_comb begin
        id_packet_stall = id_packet;
        if(fwd_after_lw_a || fwd_after_lw_b) begin
            id_packet_stall = '{
                `NOP, // we can't simply assign 0 because NOP is non-zero
                32'b0, // PC
                32'b0, // NPC
                32'b0, // rs1 select
                32'b0, // rs2 select
                OPA_IS_RS1,
                OPB_IS_RS2,
                `ZERO_REG,
                ALU_ADD,
                1'b0, // mult
                1'b0, // rd_mem
                1'b0, // wr_mem
                1'b0, // cond
                1'b0, // uncond
                1'b0, // halt
                1'b0, // illegal
                1'b0, // csr_op
                1'b0  // valid
            };
        end else if (ex_packet.take_branch) begin
            id_packet_stall = '{
                `NOP, // we can't simply assign 0 because NOP is non-zero
                32'b0, // PC
                32'b0, // NPC
                32'b0, // rs1 select
                32'b0, // rs2 select
                OPA_IS_RS1,
                OPB_IS_RS2,
                `ZERO_REG,
                ALU_ADD,
                1'b0, // mult
                1'b0, // rd_mem
                1'b0, // wr_mem
                1'b0, // cond
                1'b0, // uncond
                1'b0, // halt
                1'b0, // illegal
                1'b0, // csr_op
                1'b0  // valid
            };
        end
    end



    always_ff @(posedge clock) begin
        if (reset) begin
            id_ex_reg <= '{
                `NOP, // we can't simply assign 0 because NOP is non-zero
                32'b0, // PC
                32'b0, // NPC
                32'b0, // rs1 select
                32'b0, // rs2 select
                OPA_IS_RS1,
                OPB_IS_RS2,
                `ZERO_REG,
                ALU_ADD,
                1'b0, // mult
                1'b0, // rd_mem
                1'b0, // wr_mem
                1'b0, // cond
                1'b0, // uncond
                1'b0, // halt
                1'b0, // illegal
                1'b0, // csr_op
                1'b0  // valid
            };
        end else begin
            id_ex_reg <= id_packet_stall;
        end
    end

    // debug outputs
    assign id_ex_NPC_dbg   = id_ex_reg.NPC;
    assign id_ex_inst_dbg  = id_ex_reg.inst;
    assign id_ex_valid_dbg = id_ex_reg.valid;

    //////////////////////////////////////////////////
    //                                              //
    //                  EX-Stage                    //
    //                                              //
    //////////////////////////////////////////////////

    ID_EX_PACKET id_ex_reg_mux;
    MEM_COMMAND Dmem_command_ff;

    always_comb begin
        id_ex_reg_mux = id_ex_reg;

        if(mux_ex_1a && ex_mem_reg.valid) begin
            if(!ex_mem_reg.wr_mem && !ex_mem_branch) begin
            //     id_ex_reg_mux.rs1_value = ex_mem_reg.rs2_value;
            // end else begin
                id_ex_reg_mux.rs1_value = ex_mem_reg.alu_result;
            end
        end else if (mux_ex_2a && mem_wb_reg.valid && !mem_wb_branch) begin
            if(Dmem_command_ff != MEM_STORE && !ex_mem_reg.take_branch) begin
                id_ex_reg_mux.rs1_value = mem_wb_reg.result;
            end
        end
        if(fwd_after_lw_me_a) begin
            id_ex_reg_mux.rs1_value = mem_wb_reg.result;
        end


        if(mux_ex_1b && ex_mem_reg.valid && !ex_mem_branch) begin
            if(!ex_mem_reg.wr_mem) begin
            //     id_ex_reg_mux.rs2_value = ex_mem_reg.rs2_value;
            // end else begin
                id_ex_reg_mux.rs2_value = ex_mem_reg.alu_result;
            end
        end else if (mux_ex_2b && mem_wb_reg.valid && !mem_wb_branch) begin
            if(Dmem_command_ff != MEM_STORE && !ex_mem_reg.take_branch) begin
                id_ex_reg_mux.rs2_value = mem_wb_reg.result;
            end
        end
        if(fwd_after_lw_me_b) begin
            id_ex_reg_mux.rs2_value = mem_wb_reg.result;
        end
    end

    stage_ex stage_ex_0 (
        // Input
        .id_ex_reg (id_ex_reg_mux),

        // Output
        .ex_packet (ex_packet)
    );

    //////////////////////////////////////////////////
    //                                              //
    //           EX/MEM Pipeline Register           //
    //                                              //
    //////////////////////////////////////////////////

    assign ex_mem_enable = 1'b1; // always enabled

    always_ff @(posedge clock) begin
        if (reset) begin
            ex_mem_inst_dbg <= `NOP; // debug output
            ex_mem_reg      <= 0;    // the defaults can all be zero!
            ex_mem_branch   <= 0;
            mem_wb_branch   <= 0;
        end else if (ex_mem_enable) begin
            ex_mem_inst_dbg <= id_ex_inst_dbg; // debug output, just forwarded from ID
            ex_mem_reg      <= ex_packet;
            ex_mem_branch   <= id_ex_reg_mux.uncond_branch || id_ex_reg_mux.cond_branch;
            mem_wb_branch   <= ex_mem_branch;
        end
    end

    // debug outputs
    assign ex_mem_NPC_dbg   = ex_mem_reg.NPC;
    assign ex_mem_valid_dbg = ex_mem_reg.valid;

    //////////////////////////////////////////////////
    //                                              //
    //                 MEM-Stage                    //
    //                                              //
    //////////////////////////////////////////////////

    stage_mem stage_mem_0 (
        // Inputs
        .ex_mem_reg     (ex_mem_reg),
        .Dmem_load_data (mem2proc_data),

        // Outputs
        .mem_packet      (mem_packet),
        .Dmem_command    (Dmem_command),
        .Dmem_size       (Dmem_size),
        .Dmem_addr       (Dmem_addr),
        .Dmem_store_data (Dmem_store_data)
    );

    MEM_WB_PACKET mem_wb_reg_mux;
    MEM_BLOCK   Dmem_store_data_ff;



    always_ff @(posedge clock) begin
        if (reset) begin
            Dmem_store_data_ff  <= '0;
            Dmem_command_ff     <= '0;
        end else begin
            Dmem_store_data_ff  <= Dmem_store_data;
            Dmem_command_ff     <= Dmem_command;
        end
    end

    always_comb begin
        mem_wb_reg_mux = mem_packet;
        if(lw_after_sw_me) begin
            mem_wb_reg_mux.result = Dmem_store_data_ff;
        end
    end

    //////////////////////////////////////////////////
    //                                              //
    //           MEM/WB Pipeline Register           //
    //                                              //
    //////////////////////////////////////////////////

    assign mem_wb_enable = 1'b1; // always enabled

    // If store data is forwarded to the next instruction, mem_wb_reg.result should be rs2_value, not alu_resut


    always_ff @(posedge clock) begin
        if (reset) begin
            mem_wb_inst_dbg <= `NOP; // debug output
            mem_wb_reg      <= 0;    // the defaults can all be zero!
        end else if (mem_wb_enable) begin
            mem_wb_inst_dbg <= ex_mem_inst_dbg; // debug output, just forwarded from EX
            mem_wb_reg      <= mem_wb_reg_mux;
        end
    end

    // debug outputs
    assign mem_wb_NPC_dbg   = mem_wb_reg.NPC;
    assign mem_wb_valid_dbg = mem_wb_reg.valid;

    //////////////////////////////////////////////////
    //                                              //
    //                  WB-Stage                    //
    //                                              //
    //////////////////////////////////////////////////

    stage_wb stage_wb_0 (
        // Input
        .mem_wb_reg (mem_wb_reg), // doesn't use all of these

        // Output
        .wb_packet (wb_packet)
    );

    // This signal is solely used by if_valid for the initial stalling behavior
    always_ff @(posedge clock) begin
        if (reset) wb_valid <= 0;
        else       wb_valid <= mem_wb_reg.valid;
    end

    //////////////////////////////////////////////////
    //                                              //
    //               Pipeline Outputs               //
    //                                              //
    //////////////////////////////////////////////////

    // Output the committed instruction to the testbench for counting
    assign committed_insts[0] = wb_packet;

endmodule // pipeline
