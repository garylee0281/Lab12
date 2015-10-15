////////////////////////////////////////////////////////////////////////
// Department of Computer Science
// National Tsing Hua University
// Project   : Design Gadgets for Hardware Lab
// Module    : lcd2 (top module)
// Author    : Chih-Tsun Huang
// E-mail    : cthuang@cs.nthu.edu.tw
// Revision  : 2
// Date      : 2011/04/13
module lcd2 (
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
  //output wire [5:0]  addr
  //output wire [15:0] key,
  //new function
	input switch_hr_date,	 
	input mode,//pm-am button
	input start_count,//button	 
	input switch_year,	 
	input button_ten,
	input button_mon_date
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
	else
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
