`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:30:23 08/26/2015 
// Design Name: 
// Module Name:    debounce 
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
module debounce(
    clk, // clock control
rst_n, // reset
pb_in, //push button input
pb_debounced // debounced push button output
);
// declare the I/Os
input clk; // clock control
input rst_n; // reset
input pb_in; //push button input
output pb_debounced; // debounced push button output
reg pb_debounced; // debounced push button output
// declare the internal nodes
reg [3:0] debounce_window; // shift register flip flop
reg pb_debounced_next; // debounce result
// Shift register
reg [3:0] debounce_window_tmp;

always@(*)
begin
debounce_window_tmp[3]<=debounce_window[3];
debounce_window_tmp[2]<=debounce_window[2];
debounce_window_tmp[1]<=debounce_window[1];
debounce_window_tmp[0]<=debounce_window[0];
end
always @(posedge clk or negedge rst_n)
begin
if (~rst_n)
begin
debounce_window <= 4'd0;
end
else
begin
debounce_window [0]<= ~pb_in;
debounce_window [1]<= debounce_window[0];
debounce_window [2]<= debounce_window[1];
debounce_window [3]<= debounce_window[2];
end
end
// debounce circuit
always @*
begin
if (debounce_window == 4'b1111)
begin
pb_debounced_next = 1'b1;
end
else
begin
pb_debounced_next = 1'b0;
end
end
always @(posedge clk or negedge rst_n)
begin
if (~rst_n)
begin
pb_debounced <= 1'b0;
end
else
begin
pb_debounced <= pb_debounced_next;
end
end
endmodule
