`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:59:36 09/02/2015 
// Design Name: 
// Module Name:    display_pm_am 
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
module display_pm_am( sel_mode,clk,rst_n,hr_s,hr_t,in0,in1,tmp_t,tmp_s
    );
input sel_mode;	 
input clk,rst_n,tmp_t,tmp_s;
output hr_s,hr_t,in0,in1;
wire [3:0]tmp_s,tmp_t;

reg[3:0]hr_s,hr_t,in0,in1;	 
reg[4:0]hr;




always@(*)
begin
hr<=tmp_t*10+tmp_s;
end

always@(posedge clk or negedge rst_n)
begin
if(~rst_n)
begin
	hr_s<=4'd0;
	hr_t<=4'd0;
end
	else
	begin
		if(sel_mode==0)
		begin
		hr_s<=tmp_s;
	   hr_t<=tmp_t;
		in0<=4'd0;
		in1<=4'd0;
		end
		else
		begin
			if(hr>12)
			begin
				hr_t<=(hr-12)/10;
				hr_s<=(hr-12)%10;
				in0<=4'd11;
				in1<=4'd12;
			end
			else
			begin
				hr_t<=hr/10;
				hr_s<=hr%10;
				in0<=4'd10;
				in1<=4'd12;
			end
		end
	end
end

endmodule
