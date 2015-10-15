`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:25:09 09/01/2015 
// Design Name: 
// Module Name:    mon_date 
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
module mon_date(
switch_year,pressed,sel_mon_date,sel_add_sub,sel_ten,fast_clk,clk,rst_n,date_t_out,date_s_out,mon_t_out,mon_s_out
    );
input switch_year;	 
input fast_clk;	 
input pressed;	 
input clk,rst_n,sel_add_sub,sel_ten,sel_mon_date;
output date_t_out,date_s_out,mon_t_out,mon_s_out;
wire in0,in1,in2,in3;
reg [3:0]year_s,year_t,year_h,year_th;
reg [11:0]year;
reg [3:0]date_t_out,date_s_out,mon_t_out,mon_s_out;
reg [3:0]date_ttmp,date_stmp,mon_ttmp,mon_stmp;
wire [3:0]sel_add_sub;
// 01/01
assign in0=4'd0;
assign in1=4'd1;
assign in2=4'd0;
assign in3=4'd1;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		begin
		mon_ttmp<=in0;
		mon_stmp<=in1;
		date_ttmp<=in2;
		date_stmp<=in3;
		year_s<=4'd0;
		year_t<=4'd0;
		year_h<=4'd0;
		year_th<=4'd2;
		end
	else
		begin
		if(switch_year==0)
			begin
			mon_ttmp<=mon_ttmp;
			mon_stmp<=mon_stmp;
			date_ttmp<=date_ttmp;
			date_stmp<=date_stmp;
			if(sel_mon_date==0)//date
			begin
				if(sel_ten==0)//date_s
				begin
					if(sel_add_sub==4'd10&&pressed==1)//A(add)
					begin
						if(((mon_ttmp*10+mon_stmp)==1||(mon_ttmp*10+mon_stmp)==3||(mon_ttmp*10+mon_stmp)==5||(mon_ttmp*10+mon_stmp)==7||(mon_ttmp*10+mon_stmp)==8|| (mon_ttmp*10+mon_stmp)==10||(mon_ttmp*10+mon_stmp)==12)&&(mon_ttmp*10+mon_stmp)!=2)//奇數月情況
						begin
							if(date_stmp>=1&&date_ttmp>=3)//31情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								if(date_stmp>=9)
								begin
									date_stmp<=4'd0;
									date_ttmp<=date_ttmp+4'd1;
								end
								else
								begin
								date_stmp<=date_stmp+4'd1;
								end
							end
						end
						else if(((mon_ttmp*10+mon_stmp)==4||(mon_ttmp*10+mon_stmp)==6||(mon_ttmp*10+mon_stmp)==9||(mon_ttmp*10+mon_stmp)==11) &&(mon_ttmp*10+mon_stmp)!=2)
						begin
							if(date_stmp>=0&&date_ttmp>=3)//30情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								if(date_stmp>=9)
								begin
									date_stmp<=4'd0;
									date_ttmp<=date_ttmp+4'd1;
								end
								else
								begin
								date_stmp<=date_stmp+4'd1;
								end
							end
						end
						else if((year%4==0)&&(mon_ttmp*10+mon_stmp)==2)
						begin
							if(date_stmp>=9&&date_ttmp>=2)//29情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								if(date_stmp>=9)
								begin
									date_stmp<=4'd0;
									date_ttmp<=date_ttmp+4'd1;
								end
								else
								begin
								date_stmp<=date_stmp+4'd1;
								end
							end
						end
						else if((year%4!=0)&&(mon_ttmp*10+mon_stmp)==2)
						begin
							if(date_stmp>=8&&date_ttmp>=2)//28情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								if(date_stmp>=9)
								begin
									date_stmp<=4'd0;
									date_ttmp<=date_ttmp+4'd1;
								end
								else
								begin
								date_stmp<=date_stmp+4'd1;
								end
							end
						end
						else
						begin
							date_stmp<=date_stmp;
						end
					end
					/*else if(sel_add_sub==4'd11&&pressed==1)//B(sub)
					begin
						if(((mon_ttmp*10+mon_stmp)==1||(mon_ttmp*10+mon_stmp)==3||(mon_ttmp*10+mon_stmp)==5||(mon_ttmp*10+mon_stmp)==7||(mon_ttmp*10+mon_stmp)==8|| (mon_ttmp*10+mon_stmp)==10||(mon_ttmp*10+mon_stmp)==12)&&(mon_ttmp*10+mon_stmp)!=2)
						begin
							if(date_stmp<=1&&date_ttmp<=0)//31情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd3;
							end
							else
							begin
								if(date_stmp>=0)
								begin
									date_stmp<=4'd9;
									date_ttmp<=date_ttmp-4'd1;
								end
								else
								begin
								date_stmp<=date_stmp-4'd1;
								end
							end
						end
						else if(((mon_ttmp*10+mon_stmp)==4||(mon_ttmp*10+mon_stmp)==6||(mon_ttmp*10+mon_stmp)==9||(mon_ttmp*10+mon_stmp)==11)&&(mon_ttmp*10+mon_stmp)!=2 )
						begin
							if(date_stmp<=1&&date_ttmp<=0)//30情況
							begin
								date_stmp<=4'd0;
								date_ttmp<=4'd3;
							end
							else
							begin
								if(date_stmp>=0)
								begin
									date_stmp<=4'd9;
									date_ttmp<=date_ttmp-4'd1;
								end
								else
								begin
								date_stmp<=date_stmp-4'd1;
								end
							end
						end
						else if ((mon_ttmp*10+mon_stmp)==2)//2月
						begin
							if(date_stmp<=1&&date_ttmp<=0)//28號
							begin
								date_stmp<=4'd8;
								date_ttmp<=4'd2;
							end
							else
							begin
								if(date_stmp>=0)
								begin
									date_stmp<=4'd9;
									date_ttmp<=date_ttmp-4'd1;
								end
								else
								begin
								date_stmp<=date_stmp-4'd1;
								end
							end
						end
						else
						begin
							date_stmp<=date_stmp;
						end
					end*/
					else
					begin
						date_stmp<=date_stmp;
					end
				end
				else//date_t
				begin
					if(sel_add_sub==4'd10&&pressed==1)//A(add)
					begin
						if(((mon_ttmp*10+mon_stmp)==1||(mon_ttmp*10+mon_stmp)==3||(mon_ttmp*10+mon_stmp)==5||(mon_ttmp*10+mon_stmp)==7||(mon_ttmp*10+mon_stmp)==8|| (mon_ttmp*10+mon_stmp)==10||(mon_ttmp*10+mon_stmp)==12)&&(mon_ttmp*10+mon_stmp)!=2)//奇數月情況
						begin
							if(date_stmp>=1&&date_ttmp>=3||date_stmp>=2&&date_ttmp>=2)//31情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								date_ttmp<=date_ttmp+4'd1;
							end
						end
						else if(((mon_ttmp*10+mon_stmp)==4||(mon_ttmp*10+mon_stmp)==6||(mon_ttmp*10+mon_stmp)==9||(mon_ttmp*10+mon_stmp)==11) &&(mon_ttmp*10+mon_stmp)!=2)
						begin
							if(date_stmp>=0&&date_ttmp>=2)//30情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								date_ttmp<=date_ttmp+4'd1;
							end
						end
						else if((year%4==0)&&(mon_ttmp*10+mon_stmp)==2)
						begin
							if(date_stmp>=0&&date_ttmp>=2)//28情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								date_ttmp<=date_ttmp+4'd1;
							end
						end
						else if((year%4!=0)&&(mon_ttmp*10+mon_stmp)==2)
						begin
							if(date_stmp>=0&&date_ttmp>=2)//29情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd0;
							end
							else
							begin
								date_ttmp<=date_ttmp+4'd1;
							end
						end
						else
						begin
							date_ttmp<=date_ttmp;
						end
					end
					/*else if(sel_add_sub==4'd11&&pressed==1)//B(sub)
					begin
						if(((mon_ttmp*10+mon_stmp)==1||(mon_ttmp*10+mon_stmp)==3||(mon_ttmp*10+mon_stmp)==5||(mon_ttmp*10+mon_stmp)==7||(mon_ttmp*10+mon_stmp)==8|| (mon_ttmp*10+mon_stmp)==10||(mon_ttmp*10+mon_stmp)==12)&&(mon_ttmp*10+mon_stmp)!=2)
						begin
							if(date_stmp<=0&&date_ttmp<=1)//31情況
							begin
								date_stmp<=4'd1;
								date_ttmp<=4'd3;
							end
							else
							begin
								if(date_ttmp==4'd0)
								begin
								date_ttmp<=4'd0;
								end
								else
								begin
								date_ttmp<=date_ttmp-4'd1;
								end
							end
						end
						else if(((mon_ttmp*10+mon_stmp)==4||(mon_ttmp*10+mon_stmp)==6||(mon_ttmp*10+mon_stmp)==9||(mon_ttmp*10+mon_stmp)==11)&&(mon_ttmp*10+mon_stmp)!=2 )
						begin
							if(date_stmp<=0&&date_ttmp<=1)//30情況
							begin
								date_stmp<=4'd0;
								date_ttmp<=4'd3;
							end
							else
							begin
								if(date_ttmp==4'd0)
								begin
								date_ttmp<=4'd0;
								end
								else
								begin
								date_ttmp<=date_ttmp-4'd1;
								end
							end
						end
						else if ((mon_ttmp*10+mon_stmp)==2)//2月
						begin
							if(date_stmp<=0&&date_ttmp<=1)//28號
							begin
								date_stmp<=4'd8;
								date_ttmp<=4'd2;
							end
							else
							begin
								if(date_ttmp==4'd0)
								begin
								date_ttmp<=4'd0;
								end
								else
								begin
								date_ttmp<=date_ttmp-4'd1;
								end
							end
						end
						else
						begin
							date_ttmp<=date_ttmp;
						end
					end*/
					else
					begin
						date_ttmp<=date_ttmp;
					end
				end
			end
			else
			begin//mon
				if(sel_ten==0)//mon_s
				begin
					if(sel_add_sub==4'd10&&pressed==1)//A(add)
					begin
						if(mon_stmp>=2&&mon_ttmp>=1)//超過12月
							begin
								mon_stmp<=4'd1;
								mon_ttmp<=4'd0;
							end
						else
							begin
								if(mon_stmp>=4'd9)
								begin
								mon_stmp<=4'd0;
								mon_ttmp<=mon_ttmp+4'd1;
								end
								else
								begin
								mon_stmp<=mon_stmp+4'd1;
								end
							end
					end
					/*else if (sel_add_sub==4'd11&&pressed==1)//B(sub)
					begin
						if(mon_stmp<=1&&mon_ttmp<=0)//超過12月
							begin
								mon_stmp<=4'd2;
								mon_ttmp<=4'd1;
							end
						else
							begin
								if(mon_stmp<=4'd0)
								begin
								mon_stmp<=4'd9;
								mon_ttmp<=mon_ttmp-4'd1;
								end
								else
								begin
								mon_stmp<=mon_stmp-4'd1;
								end
							end
					end*/
					else
					begin
						mon_stmp<=mon_stmp;
					end
				end
				else//mon_t
				begin
					if(sel_add_sub==4'd10&&pressed==1)//A(add)
					begin
						if(mon_ttmp>0)//超過12月
							begin
								mon_ttmp<=4'd0;
								mon_stmp<=4'd1;
							end
						else
							begin
								mon_ttmp<=mon_ttmp+4'd1;
							end
					end
					/*else if (sel_add_sub==4'd11&&pressed==1)//B(sub)
					begin
						if(mon_ttmp<=0)//超過12月
							begin
								mon_ttmp<=4'd1;
							end
						else
							begin
								mon_stmp<=mon_stmp-4'd1;
							end
					end*/
					else
					begin
						mon_stmp<=mon_stmp;
					end
				end
			end
			end
			else//year
			begin
				if(sel_mon_date==0&&sel_ten==0&&sel_add_sub==4'd10&&pressed==1)//year_s
				begin
					if(year_s>=9)
					begin
						year_s<=4'd0;
					end
					else
					begin
						year_s<=year_s+4'd1;
					end
				end
				else if(sel_mon_date==0&&sel_ten==1&&sel_add_sub==4'd10&&pressed==1)//year_t
				begin
					if(year_t>=9)
					begin
						year_t<=4'd0;
					end
					else
					begin
						year_t<=year_t+4'd1;
					end
				end
				else if(sel_mon_date==1&&sel_ten==0&&sel_add_sub==4'd10&&pressed==1)//year_h
				begin
					if(year_h>=2)
					begin
						year_h<=4'd0;
					end
					else
					begin
						year_h<=year_h+4'd1;
					end
				end
				else if(&sel_mon_date==1&sel_ten==1&&sel_add_sub==4'd10&&pressed==1)//year_th
				begin
					if(year_th>=2)
					begin
						year_th<=4'd0;
					end
					else
					begin
						year_th<=year_th+4'd1;
					end
				end
				else
				begin
					year_s<=year_s;
					year_t<=year_t;
					year_h<=year_h;
					year_th<=year_th;
				end
			end
		end
end
always@(*)
begin
	year<=year_s+year_t*10+year_h*100+year_th*1000;
end
always@(posedge fast_clk or negedge rst_n)
begin
	if(~rst_n)
		begin
			date_s_out<=in3;
			date_t_out<=in2;
			mon_s_out<=in1;
			mon_t_out<=in0;
		end
	else
		begin
			if(switch_year==0)
			begin
			date_s_out<=date_stmp;
			date_t_out<=date_ttmp;
			mon_s_out<=mon_stmp;
			mon_t_out<=mon_ttmp;
			end
			else
			begin
			date_s_out<=year_s;
			date_t_out<=year_t;
			mon_s_out<=year_h;
			mon_t_out<=year_th;
			end
		end
end
endmodule
