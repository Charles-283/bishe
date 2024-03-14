`timescale 1ns/100ps

// clock time
`define period_pos  4
`define period_neg  1
`define F_delay     0.5

// signal length
`define Col_num_bit         6
`define Col_num             1 << `Col_num_bit
`define Row_num             16

// special address
`define All_zeros_addr      `Col_num_bit'b000000
`define Booth_pipo_addr     `Col_num_bit'b111110
`define MULsum_pipo_addr    `Col_num_bit'b111111
