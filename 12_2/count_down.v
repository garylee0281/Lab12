`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:52 09/05/2015 
// Design Name: 
// Module Name:    count_down 
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
module count_down(
 fast_clk,clk, sel_in, in0, in1,in2, in3,out0,out1,out2,out3,rst,LED
);
//input switch_setting;
input fast_clk;
input clk ,sel_in,rst;
input [3:0]in0,in1,in2,in3;
output [3:0]out0,out1,out2,out3;
output [15:0]LED;
reg [3:0]temp0,temp1,temp2,temp3;
reg [3:0]out0,out1,out2,out3;
reg a,b,c,d;
reg [15:0]LED;
reg start_flag;
wire [1:0]sel_in;
always@(posedge clk or negedge rst)begin
if(~rst)
begin
temp0<=in0;
temp1<=in1;
temp2<=in2;
temp3<=in3;
start_flag<=1'b0;
	 LED[0]=0;
	 LED[1]=0;
	 LED[2]=0;
	 LED[3]=0;
	 LED[4]=0;
	 LED[5]=0;
	 LED[6]=0;
	 LED[7]=0;
	 LED[8]=0;
	 LED[9]=0;
	 LED[10]=0;
	 LED[11]=0;
	 LED[12]=0;
	 LED[13]=0;
	 LED[14]=0;
	 LED[15]=0;
end
else if(sel_in==2'b01)
	begin
			if(temp3==4'd0)
			begin
				if(temp2==4'd0)
				begin
					if(temp1==4'd0)
					begin
						if(temp0==4'd0)
						begin
							LED[0]=1;
							LED[1]=1;
							LED[2]=1;
							LED[3]=1;
							LED[4]=1;
							LED[5]=1;
							LED[6]=1;
							LED[7]=1;
							LED[8]=1;
							LED[9]=1;
							LED[10]=1;
							LED[11]=1;
							LED[12]=1;
							LED[13]=1;
							LED[14]=1;
							LED[15]=1;
						end
						else
						begin
							temp0<=temp0-4'd1;
							temp1<=4'd9;
							temp2<=4'd5;
							temp3<=4'd9;
						end
					end
					else
					begin
					temp1<=temp1-4'd1;
					temp2<=4'd5;
					temp3<=4'd9;
					end
				end
				else
				begin
				temp2<=temp2-4'd1;
				temp3<=4'd9;
				end
			end
			else
			begin
			/*temp0<=temp0;
			temp1<=temp1;
			temp2<=temp2;*/
			temp3<=temp3-4'd1;
			end
		end
else if (sel_in==2'b10)
	begin
			temp0<=temp0;
			temp1<=temp1;
			temp2<=temp2;
			temp3<=temp3;
			start_flag<=1'b1;
	end
else if (sel_in==2'b00&&start_flag==0)
	begin
		   temp0<=in0;
			temp1<=in1;
			temp2<=in2;
			temp3<=in3;
	end
else
	begin
		temp0<=temp0;
		temp1<=temp1;
		temp2<=temp2;
		temp3<=temp3;	
	end	
end

always@(posedge fast_clk or negedge rst)
begin
	if(~rst)
	begin
	out0<=in0;
	out1<=in1;
	out2<=in2;
	out3<=in3;
	end
	else
	begin
	out0<=temp0;
	out1<=temp1;
	out2<=temp2;
	out3<=temp3;
	end
end



endmodule
