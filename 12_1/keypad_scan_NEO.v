`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:15 08/27/2015 
// Design Name: 
// Module Name:    keypad_scan 
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
`define KEYPAD_COL_WIDTH 4
`define KEYPAD_ROW_WIDTH 4
`define KEYPAD_PAUSE_PERIOD_BIT_WIDTH 4
`define KEYPAD_DEC_WIDTH 8
`define KEYPAD_PRESSED 1
`define KEYPAD_NOT_PRESSED 0
`define KEY_F 4'd15
`define KEY_E 4'd14
`define KEY_D 4'd13
`define KEY_C 4'd12
`define KEY_B 4'd11
`define KEY_A 4'd10
`define KEY_9 4'd9
`define KEY_8 4'd8
`define KEY_7 4'd7
`define KEY_6 4'd6
`define KEY_5 4'd5
`define KEY_4 4'd4
`define KEY_3 4'd3
`define KEY_2 4'd2
`define KEY_1 4'd1
`define KEY_0 4'd0
`define SCAN 0
`define PAUSE 1
module keypad_scan(
clk, // scan clock
rst_n, // active low reset
col_n, // pressed column index
row_n, // scanned row index
key, // returned pressed key
pressed // whether key pressed (1) or not (0)
);
// Declare I/Os
input clk; // scan clock
input rst_n; // active low reset
input [`KEYPAD_COL_WIDTH - 1:0] col_n;

output [`KEYPAD_ROW_WIDTH-1:0] row_n;
output [3:0] key; // returned pressed key
output pressed; // whether key pressed (1) or not (0)
// Declare internal nodes
reg [1:0] sel, sel_next;
reg [`KEYPAD_ROW_WIDTH-1:0] row_n;
reg [3:0] key;
reg [3:0] key_detected;
reg [3:0] key_next;
reg keypad_state, keypad_state_next;
reg [`KEYPAD_PAUSE_PERIOD_BIT_WIDTH-1:0] pause_delay, pause_delay_next;
reg pressed_detected;
reg pressed_next;
reg pressed;
// A repetitive counter for row-wise scan
always @(posedge clk or negedge rst_n)
begin
if (~rst_n)
sel = 2'b00;
else
sel = sel_next;
end
always @*
sel_next = sel + 1'b1;
// row-wise scan
always @*
case (sel)
2'd0: row_n = 4'b0111;
2'd1: row_n = 4'b1011;
2'd2: row_n = 4'b1101;
2'd3: row_n = 4'b1110;
default: row_n=4'b1111;
endcase
// column-wise readout
always @*
begin
case ({row_n,col_n})

8'b0111_0111: // press 'F'
	begin
	key_detected = `KEY_F;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b0111_1011: // press 'E'
	begin
	key_detected = `KEY_E;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b0111_1101: // press 'D'
	begin
	key_detected = `KEY_D;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b0111_1110: // press 'C'
	begin
	key_detected = `KEY_C;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1011_0111: // press 'B'
	begin
	key_detected = `KEY_B;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1011_1011: // press '3'
	begin
	key_detected = `KEY_3;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1011_1101: // press '6'
	begin
	key_detected = `KEY_6;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1011_1110: // press '9'
	begin
	key_detected = `KEY_9;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1101_0111: // press 'A'
	begin
	key_detected = `KEY_A;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1101_1011: // press '2'
	begin
	key_detected = `KEY_2;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1101_1101: // press '5'
	begin
	key_detected = `KEY_5;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1101_1110: // press '8'
	begin
	key_detected = `KEY_8;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1110_0111: // press '0'
	begin
	key_detected = `KEY_0;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1110_1011: // press '1'
	begin
	key_detected = `KEY_1;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1110_1101: // press '4'
	begin
	key_detected = `KEY_4;
	pressed_detected = `KEYPAD_PRESSED;
	end

8'b1110_1110: // press '7'
	begin
	key_detected = `KEY_7;
	pressed_detected = `KEYPAD_PRESSED;
	end

default:
	begin
	pressed_detected = `KEYPAD_NOT_PRESSED;
	key_detected = `KEY_0;
	end
endcase
end
// ************************
// FSM for keypad scan
// ************************
// FSM state transition
always @*
begin
case (keypad_state)
`SCAN:
begin
	if (pressed_detected == `KEYPAD_PRESSED)
		begin
		keypad_state_next = `PAUSE;
		pressed_next = `KEYPAD_PRESSED;
		pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
		key_next = key_detected;
		end
	else
		begin
		keypad_state_next = `SCAN;
		pressed_next = `KEYPAD_NOT_PRESSED;
		pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
		key_next = key;
		end
end
`PAUSE:
begin
	if (pause_delay==`KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b1111)
		begin
		keypad_state_next = `SCAN;
		pressed_next = `KEYPAD_NOT_PRESSED;
		pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
		key_next = key;
		end
	else
		begin
		keypad_state_next = `PAUSE;
		pressed_next = `KEYPAD_PRESSED;
		pause_delay_next = pause_delay + 1'b1;
		key_next = key;
		end
end
default:
	begin
	keypad_state_next = `SCAN;
	pressed_next = `KEYPAD_NOT_PRESSED;
	pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
	key_next = key;
	end
endcase
end

// FSM state register
always @(posedge clk or negedge rst_n)
if (~rst_n)
keypad_state <= 1'b0;
else
keypad_state <= keypad_state_next;
// Keypad Pause state counter
always @(posedge clk or negedge rst_n)
if (~rst_n)
pause_delay <= `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'd0;
else
pause_delay <= pause_delay_next;
// pressed indicator
always @(posedge clk or negedge rst_n)
if (~rst_n)
pressed <= `KEYPAD_NOT_PRESSED;
else
pressed <= pressed_next;
// pressed key indicator
always @(posedge clk or negedge rst_n)
if (~rst_n)
key <= `KEY_0;
else
key <= key_next;

endmodule
