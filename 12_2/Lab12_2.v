`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:13:16 09/24/2015 
// Design Name: 
// Module Name:    Lab12_2 
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
module Lab12_2(
  input switch_timecount,
  input              clk,
  input              rst_n,
  input  wire [3:0]  col,
  output wire [3:0]  row,
  output             LCD_rst,
  output wire [1:0]  LCD_cs,
  output             LCD_rw,
  output             LCD_di,
  output wire [7:0]  LCD_data,
  output             LCD_en,
  output [14:0]display,
  output [3:0]display_ctl,
  output [15:0]LED,
  //new function
	input switch_hr_date,	 
	input mode,//pm-am button
	input start_count,//button	 
	input switch_year,	 
	input button_ten,
	input button_mon_date,
	input button_hr_min,
   input button_start_stop,
	input button_pause_resume
);

	//newfunction
	wire clk_out;//1s
	wire [1:0]clk_ctl;//for scan
	wire clk_150;
	wire  [3:0] bcd;
	wire [3:0]scanf_in;
	wire fsm_ten_in;
	wire sel_ten;
	wire pb_ten;
	wire [4:0]clk_date;

	wire pb_mon_date;
	wire fsm_mon_date;
	wire sel_mon_date;

	wire [3:0]date_t,date_s,mon_t,mon_s;
   reg [3:0]scanf_in_date;	
	wire pb_mode;
	wire fsm_modein;
	wire sel_mode;
	wire one_pluse_in;
	wire fsm_count;
	wire sel_in;
	wire [3:0]hr_tt,hr_ss,tmp_t,tmp_s;
	wire [3:0]hr_in3,hr_in2,hr_in1,hr_in0;
	reg [3:0]in3,in2,in1,in0;
	wire sel_t;
	reg[3:0] scanf_in_hr;

  //wire [15:0] key;
  wire change,en,out_valid;
  wire [7:0] data_out;
  wire clk_div;
//new one
wire pb_hr_min;
wire fsm_hr_min_in;
wire [1:0]hr_min_control;
wire pb_start_stop;
wire fsm_start_stop_in;
wire [1:0]start_stop;//S0:setting
wire pb_pause_resume;
wire fsm_pause_resume_in;
wire pause_resume;
wire [3:0]hr_ttmp,hr_stmp,min_ttmp,min_stmp;

reg [3:0]out0,out1,out2,out3;
wire [3:0]hr_t,hr_s,min_t,min_s;

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		out0<=4'd0;
		out1<=4'd0;
		out2<=4'd0;
		out3<=4'd0;
	end
	else
	begin
		if(pause_resume==0&&start_stop!=2'b00)
		begin
			out0<=hr_t;
			out1<=hr_s;
			out2<=min_t;
			out3<=min_s;
		end
		else if (pause_resume==1&&start_stop!=2'b00)
		begin
			out0<=out0;
			out1<=out1;
			out2<=out2;
			out3<=out3;
		end
		else
		begin
			out0<=hr_ttmp;
			out1<=hr_stmp;
			out2<=min_ttmp;
			out3<=min_stmp;
		end
	end
end

always@(posedge clk_150 or negedge rst_n)
begin
	if(~rst_n)
		begin
			if(switch_hr_date==0)
			begin
				scanf_in_hr<=4'd0;
			end
			else
			begin
				scanf_in_date<=4'd0;
			end
		end
	else
		begin
			if(switch_hr_date==0)
			begin
				scanf_in_hr<=scanf_in;
			end
			else
			begin
				scanf_in_date<=scanf_in;
			end
		end
end
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		begin
			in0<=4'd0;
			in1<=4'd0;
			in2<=4'd0;
			in3<=4'd0;
		end
	else if(switch_timecount==0)
		begin
		if(switch_hr_date==0)
		begin
			in0<=hr_in0;
			in1<=hr_in1;
			in2<=hr_in2;
			in3<=hr_in3;
		end
		else
		begin
			in0<=mon_t;
			in1<=mon_s;
			in2<=date_t;
			in3<=date_s;
		end
		end
	else
		begin
			in0<=out0;
			in1<=out1;
			in2<=out2;
			in3<=out3;
		end
end

freq_divider fl(
   .clk_out(clk_out), // divided clock output
	.clk_ctl(clk_ctl), // divided clock output for scan freq
	.clk_150(clk_150),
	.clk(clk), // global clock input
	.rst_n(rst_n), // active low reset
	.cnt_h(clk_date)
	); 



debounce de_ten(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_ten), //push button input
.pb_debounced(pb_ten)// debounced push button output
);	
one_pause_ten opten(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_ten), // input trigger
.out_pulse(fsm_ten_in) // output one pulse
);
fsm_ten ft(
.rst(rst_n),
.clk(clk),
.sel_out(sel_ten),
.in(fsm_ten_in)
    );
de_mon_date dmd(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_mon_date), //push button input
.pb_debounced(pb_mon_date) // debounced push button output
);
pluse_mon_date pmd(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_mon_date), // input trigger
.out_pulse(fsm_mon_date) // output one pulse
);
fsm_mon_date fmd(
   .rst(rst_n),
	.clk(clk),
	.sel_out(sel_mon_date),
	.in(fsm_mon_date)
    );
mon_date md(
.switch_year(switch_year),
.pressed(change),
.sel_mon_date(sel_mon_date),
.sel_add_sub(scanf_in_date),
.sel_ten(sel_ten),
.fast_clk(clk),
.clk(clk_date[3]),
.rst_n(rst_n),
.date_t_out(date_t),
.date_s_out(date_s),
.mon_t_out(mon_t),
.mon_s_out(mon_s)
    );
//24hr	 
clock_24( 
 .fast_clk(clk),
 .clk(clk_150),
 .rst_n(rst_n),
 .hr_s(hr_ss),
 .hr_t(hr_tt),
 .sel_in(sel_in),
 .sel_t(sel_t),
 .scanf_in(scanf_in_hr)
    );	 
debounce_mode dml(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(mode), //push button input
.pb_debounced(pb_mode) // debounced push button output
);
pluse_mode(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_mode), // input trigger
.out_pulse(fsm_modein) // output one pulse
);
fsm_mode(
    .rst(rst_n),
	 .clk(clk),
	 .sel_out(sel_mode),
	 .in(fsm_modein)
    );
 
	 
debounce debounce_startcounter(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(start_count), //push button input
.pb_debounced(one_pluse_in) // debounced push button output
);
one_pluse opcount(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(one_pluse_in), // input trigger
.out_pulse(fsm_count) // output one pulse
);
 fsm_count(
   .rst(rst_n),
	.clk(clk),
	.sel_out(sel_in),
	.in(fsm_count)
    );
	 
count( 
.clk(clk_out), //1s
.sel_in(sel_in), 
.in0(0), 
.in1(0),
.in2(hr_tt), 
.in3(hr_ss),
//.out0(),
//.out1(),
.out2(tmp_t),
.out3(tmp_s),
.rst(rst_n)
);
display_pm_am(
.sel_mode(sel_mode), 
.clk(clk),
.rst_n(rst_n),
.hr_s(hr_in3),
.hr_t(hr_in2),
.in0(hr_in0),
.in1(hr_in1),
.tmp_t(tmp_t),
.tmp_s(tmp_s)
    );
	 
one_pause_ten opt(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(change), // input trigger
.out_pulse(fsm_ten) // output one pulse
);

fsm_ten ftl(
.rst(rst_n),
.clk(clk),
.sel_out(sel_t),
.in(fsm_ten)
    );
	 
scanf sl(
   .ftsd_ctl(display_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(in0), // 1st input
	.in1(in1), // 2nd input
	.in2(in2), // 3rd input
	.in3(in3), // 4th input
	.ftsd_ctl_en(clk_ctl) // divided clock for scan control
	);	 
bcd_d bl(
   .display(display), // 14-segment display output
	.bcd(bcd) // BCD input
	);	 
//new function
//hr
debounce_hr dh(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_hr_min), //push button input
.pb_debounced(pb_hr_min) // debounced push button output
);	
one_pluse_hr oph(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_hr_min), // input trigger
.out_pulse(fsm_hr_min_in) // output one pulse
);
fsm_hr fh(
  .rst(rst_n),
  .clk(clk),
  .sel_out(hr_min_control),
  .in(fsm_hr_min_in)
    );
//control
control_function(
.clk(clk_out),
.reset(rst_n),
.switch_setting(start_stop),
.hr_control(hr_min_control),
.out0(hr_ttmp),
.out1(hr_stmp),
.out2(min_ttmp),
.out3(min_stmp),
.fast_clk(clk)
    );
//start_stop
debounce_start_stop(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_start_stop), //push button input
.pb_debounced(pb_start_stop) // debounced push button output
);
one_pluse_start_stop(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_start_stop), // input trigger
.out_pulse(fsm_start_stop_in) // output one pulse
);
fsm_start_stop(
   .rst(rst_n),
	.clk(clk),
	.sel_out(start_stop),
	.in(fsm_start_stop_in)
    );
//pause_resume
debounce_pause_resume(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_pause_resume), //push button input
.pb_debounced(pb_pause_resume) // debounced push button output
);	
one_pluse_pause_resume(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_pause_resume), // input trigger
.out_pulse(fsm_pause_resume_in) // output one pulse
);
fsm_pause_resume(
   .rst(rst_n),
	.clk(clk),
	.sel_out(pause_resume),
	.in(fsm_pause_resume_in)
    ); 
//count down
count_down(
 .fast_clk(clk),
 .clk(clk_out), 
 .sel_in(start_stop), 
 .in0(hr_ttmp),
 .in1(hr_stmp),
 .in2(min_ttmp),
 .in3(min_stmp),
 .out0(hr_t),
 .out1(hr_s),
 .out2(min_t),
 .out3(min_s),
 .rst(rst_n),
 .LED(LED)
);

	 
//old function	 
  keypad_scan K1 (
    .rst_n(rst_n),
    .clk(clk_div),
    .col_n(col),
    .row_n(row),
    .pressed(change),          // push and release//pressed 
    .key(scanf_in)                 // mask {F,E,D,C,B,3,6,9,A,2,5,8,0,1,4,7}
  );


  RAM_ctrl R2 (
    .clk(clk_div),
    .rst_n(rst_n),
    .change(change),
    //.key(key),
	 .in0(in0),
	 .in1(in1),
	 .in2(in2),
	 .in3(in3),
    .en(en),
    .data_out(data_out),
    .data_valid(out_valid)
	 //.addr(addr)
	 );

  lcd_ctrl d1 (
    .clk(clk_div),
    .rst_n(rst_n),
    .data(data_out),           // memory value  
    .data_valid(out_valid),    // if data_valid = 1 the data is valid
    .LCD_di(LCD_di),
    .LCD_rw(LCD_rw),
    .LCD_en(LCD_en),
    .LCD_rst(LCD_rst),
    .LCD_cs(LCD_cs),
    .LCD_data(LCD_data),
    .en_tran(en)
  );

  clock_divider #(
    .half_cycle(200),         // half cycle = 200 (divided by 400)
    .counter_width(8)         // counter width = 8 bits
  ) clk100K (
    .rst_n(rst_n),
    .clk(clk),
    .clk_div(clk_div)
  );


endmodule
