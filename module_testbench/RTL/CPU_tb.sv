`timescale 1ns/100ps

// clock time
`define period_pos  1
`define period_neg  1

// Main Control parameter
//The depth of the instruction register memory is set to 256 64-bit wide instructions by default.
`define instr_num_bit       8

module CPU_tb(
    output reg                  clk,
    output reg                  rst_n,

///////////////////////////////////////////////////////////////
///////////////////  CPU Peripheral Bus ///////////////////
    output reg                  CPU_instruction_valid,
    input                       CPU_instruction_irq,//interrupt signal, means finish.
    output reg[`instr_num_bit:0]CPU_instruction_addr,//Because the CPU bus width is 32, it takes 2 cycles to write a full 64-bit instruction.
    output reg[31:0]            CPU_instruction_data
);

//////////////////////////////////////////////////////
///////////////////  Clock Control ///////////////////
initial begin
    clk                     = 1'b1;
    rst_n                   = 1'b0;
    #10         
    rst_n                   = 1'b1;
end         
always begin            
    #`period_pos                      
    clk                     = 1'b0;
    #`period_neg                     
    clk                     = 1'b1;
end

//////////////////////////////////////////////////////
/////////////////// instruction emitter ///////////////////
initial begin
    CPU_instruction_valid   = 1'b0;
    CPU_instruction_addr    = 9'b0;
    CPU_instruction_data    = 32'b0;

    #18
    CPU_instruction_valid   = 1'b1;
    CPU_instruction_addr    = 9'h1ff;
    CPU_instruction_data    = 32'b1;

    @(posedge clk);
    CPU_instruction_valid   = 1'b0;
    CPU_instruction_addr    = 9'b0;
    CPU_instruction_data    = 32'b0;

    @(posedge CPU_instruction_irq);
    
    $display("The computation is finish!!!");
    $stop;
end

endmodule