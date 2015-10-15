`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:43 08/26/2015 
// Design Name: 
// Module Name:    freq_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define FREQ_DIV_BIT 25
module freq_divider(
   clk_out, // divided clock output
	clk_ctl, // divided clock output for scan freq
	clk_150,
	clk, // global clock input
	rst_n, // active low reset
	cnt_h
	);
	output  cnt_h; 	
	output reg clk_out; // divided clock output (in always block)
	output reg [1:0] clk_ctl; // divided output for scan freq (in always block)
	output reg clk_150;//for debounce
	input clk; // global clock input
	input rst_n; // active low reset
	reg [14:0] cnt_l; // temp buf of the counter
	reg [4:0] cnt_h; // temp buf of the counter
	reg cnt_t;
	reg [`FREQ_DIV_BIT-1:0] cnt_tmp; // input to dff (in always block)
	// Combinational logics: increment, neglecting overflow 
	always @(clk_out  or cnt_h or clk_150 or cnt_t or clk_ctl or cnt_l)
		cnt_tmp = {clk_out,cnt_h,clk_150,cnt_t,clk_ctl,cnt_l} + 1'b1;
	// Sequential logics: Flip flops
	always @(posedge clk or negedge rst_n)
		if (~rst_n) {clk_out,cnt_h, clk_150,cnt_t,clk_ctl, cnt_l}<=`FREQ_DIV_BIT'd0;
		else {clk_out,cnt_h,clk_150,cnt_t,clk_ctl, cnt_l}<=cnt_tmp;
endmodule
