`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:41:40 09/05/2015 
// Design Name: 
// Module Name:    fsm_hr 
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
module fsm_hr(
  rst,clk,sel_out,in
    );
input in;	 
input rst;
input clk;
output [1:0]sel_out;
wire [1:0] S0,S1,S2;
assign S0=2'b00;
assign S1=2'b01;
assign S2=2'b10;
reg [1:0]state,next_state;
always@(posedge clk,negedge rst)
	begin
		if(rst==0)
		state<=S0;
		else
		state<=next_state;
	end
always@(state or in)begin
	case(state)
	S0:begin
		if(in==1)
		next_state=S1;
		else
		next_state=S0;
		end
	S1:begin
		if(in==1)
		next_state=S2;
		else
		next_state=S1;
		end
	S2:begin
		if(in==1)
		next_state=S0;
		else
		next_state=S2;
		end
	endcase
end
assign sel_out=state;


endmodule
