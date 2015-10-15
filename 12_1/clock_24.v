`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:07 09/02/2015 
// Design Name: 
// Module Name:    clock_24 
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
module clock_24( fast_clk,clk,rst_n,hr_s,hr_t,sel_in,sel_t,scanf_in
    );
input fast_clk;
input [3:0]scanf_in;	 
input clk,rst_n,sel_in,sel_t;
output [3:0]hr_s,hr_t;
reg [3:0]hr_s,hr_t;
reg [3:0]hr_ss,hr_tt;
	 
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
	hr_ss<=4'd0;
	hr_tt<=4'd0;
	end
	else 
	begin
		if(sel_in==0)
		begin
			if(sel_t==0)
				begin
				hr_ss<=scanf_in;
				end
			else if(sel_t==1)
				begin
				hr_tt<=scanf_in;
				end
			else if(hr_ss>=4 && hr_tt>=2 || hr_tt>=3)
				begin
				hr_ss<=4'd0;
				hr_tt<=4'd0;
				end	
			else 
				begin
				hr_ss<=hr_ss;
				hr_tt<=hr_tt;
				end
		end
		else
		begin
		end	
	end		
end
always@(posedge fast_clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		hr_t<=4'd0;
		hr_s<=4'd0;
	end
	else
	begin
		hr_t<=hr_tt;
		hr_s<=hr_ss;
	end
end
endmodule
