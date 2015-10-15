`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:41:43 08/28/2015 
// Design Name: 
// Module Name:    fsm_ten 
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
module fsm_ten(
rst,clk,sel_out,in
    );
input in;	 
input rst;
input clk;
output sel_out;
wire [1:0] S0,S1;
assign S0=2'b00;
assign S1=2'b01;
//assign S2=2'b10;
reg [2:0]state,next_state;
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
		next_state=S0;
		else
		next_state=S1;
		end
	/*S2:begin
		if(in==0)
		next_state=S0;
		else
		next_state=S1;
		end*/
	endcase
end
assign sel_out=state==S1?1:0;



endmodule
