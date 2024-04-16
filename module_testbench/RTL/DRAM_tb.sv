`timescale 1ns/100ps

// signal len
`define Col_num             128
//Set the depth and length of the ddr address register table. By default, eight 25-bit wide ddr addresses can be stored(for 128-bitwidth 512MB DDR3 addressing).
`define ddr_addr_len        25

module DRAM_tb(
    input                       clk,

///////////////////////////////////////////////////////////////
///////////////////  From To DDR3-DRAM Interface IP ///////////////////
    input                       DRAM_valid,
    input                       DRAM_wr_en,
    input  [`ddr_addr_len-1:0]  DRAM_addr,
    output [`Col_num-1:0]       DRAM_rd_data,
    input  [`Col_num-1:0]       DRAM_wr_data
);

reg  [`Col_num-1:0]             DRAM_memory         [0:2047];
initial $readmemh ("./memory_data/DRAM_memory.data", DRAM_memory);

assign DRAM_rd_data             = {`Col_num{DRAM_valid & (~DRAM_wr_en)}} & DRAM_memory[DRAM_addr];

always @(posedge clk) 
    if (DRAM_valid & DRAM_wr_en)
        DRAM_memory[DRAM_addr] <= DRAM_wr_data;

endmodule