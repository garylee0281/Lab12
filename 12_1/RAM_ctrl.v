////////////////////////////////////////////////////////////////////////
// Department of Computer Science
// National Tsing Hua University
// Project   : Design Gadgets for Hardware Lab
// Module    : RAM_ctrl
// Author    : Chih-Tsun Huang
// E-mail    : cthuang@cs.nthu.edu.tw
// Revision  : 2
// Date      : 2011/04/13
module RAM_ctrl (
  input clk,
  input rst_n,
  input change,
  //input [15:0] key,
  input en,
  output reg [7:0] data_out,
  output reg data_valid,
  input [3:0]in0,
  input [3:0]in1,
  input [3:0]in2,
  input [3:0]in3
  //output addr
);
  parameter zero = 256'h0ff0_1818_1818_1818_1818_1818_1878_19d8_1b98_1e18_1818_1818_1818_1818_1818_0ff0;
  parameter one = 256'h0180_0380_0780_0180_0180_0180_0180_0180_0180_0180_0180_0180_0180_0180_0180_1ff8;
  parameter two = 256'h3ffc_3ffc_000c_000c_000c_000c_000c_3ffc_3ffc_3000_3000_3000_3000_3000_3ffc_3ffc;
  parameter three = 256'h3ffc_3ffc_000c_000c_000c_000c_000c_3ffc_3ffc_000c_000c_000c_000c_000c_3ffc_3ffc;
  parameter four = 256'h300c_300c_300c_300c_300c_300c_300c_300c_3ffc_3ffc_000c_000c_000c_000c_000c_000c_000c;
  parameter five = 256'h3ffc_3ffc_3000_3000_3000_3000_3000_3ffc_3ffc_000c_000c_000c_000c_000c_3ffc_3ffc;
  parameter six = 256'h3ffc_3ffc_3000_3000_3000_3000_3000_3ffc_3ffc_300c_300c_300c_300c_300c_3ffc_3ffc;
  parameter seven =256'h3ffc_3ffc_300c_300c_300c_300c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c;
  parameter eight =256'h1ff8_1ff8_1818_1818_1818_1818_1818_1ff8_1ff8_1818_1818_1818_1818_1818_1ff8_1ff8;
  parameter night =256'h1ff8_1ff8_1818_1818_1818_1818_1818_1ff8_1ff8_0018_0018_0018_0018_0018_1ff8_1ff8;
  parameter wordP = 256'h1ff8_1ff8_1818_1818_1818_1818_1818_1ff8_1ff8_1800_1800_1800_1800_1800_1800_1800;
  parameter wordA = 256'h03c0_03c0_0660_0660_0c30_0c30_1818_1818_300c_300c_7ffe_7ffe_c003_c003_8001_8001;
  parameter wordM = 256'h1818_1818_1c38_1c38_1e78_1e78_1bd8_1bd8_1998_1998_1818_1818_1818_1818_1818_1818;
  //parameter mark  = 256'hc003_e007_700e_381c_1c38_0e70_07e0_03c0_03c0_07e0_0e70_1c38_381c_700e_e007_c003;
  parameter IDLE  = 2'd0;
  parameter WRITE = 2'd1;
  parameter GETDATA = 2'd2;
  parameter TRANSDATA = 2'd3;

  reg [5:0] addr, addr_next;
  reg [5:0] counter_word, counter_word_next;
  wire [63:0] data_out_64;
  reg [63:0] data_in;
  reg [15:0] in_temp0, in_temp1, in_temp2, in_temp3;
  reg [1:0] cnt, cnt_next;  //count mark row
  reg [511:0] mem, mem_next;
  reg [1:0] state, state_next;
  reg flag, flag_next;
  reg [7:0] data_out_next;
  reg data_valid_next;
  reg wen, wen_next;
  reg temp_change, temp_change_next;
  reg hr_change;
 
  //assign in_temp0 = key[14-(cnt*4)] == 1'b0 ? 16'd0 : eight[(240-((addr%16)*16))+:16];
  //assign in_temp1 = key[14-(cnt*4)] == 1'b0 ? 16'd0 : four[(240-((addr%16)*16))+:16];
  //assign in_temp2 = key[13-(cnt*4)] == 1'b0 ? 16'd0 : six[(240-((addr%16)*16))+:16];
  //assign in_temp3 = key[12-(cnt*4)] == 1'b0 ? 16'd0 : night[(240-((addr%16)*16))+:16];
  //assign in_temp0 = (cnt%4==1'b1) ? wordP[(240-((addr%16)*16))+:16]:16'd0;
  //assign in_temp1 = (cnt%4==1'b1) ? wordA[(240-((addr%16)*16))+:16]:16'd0;
  //assign in_temp2 = (cnt%4==1'b1) ? wordM[(240-((addr%16)*16))+:16]:16'd0;
  //assign in_temp3 = (cnt%4==1'b1) ? two[(240-((addr%16)*16))+:16]:16'd0;
  //assign zero1 = 16'd0;
  always@(posedge clk)
  begin
      hr_change<=1'b1;
		case (in0)
		4'd0:in_temp0 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		4'd1:in_temp0 = (cnt%4==1'b1) ? one[(240-((addr%16)*16))+:16]:16'd0;
		4'd2:in_temp0 = (cnt%4==1'b1) ? two[(240-((addr%16)*16))+:16]:16'd0;
		4'd3:in_temp0 = (cnt%4==1'b1) ? three[(240-((addr%16)*16))+:16]:16'd0;
		4'd4:in_temp0 = (cnt%4==1'b1) ? four[(240-((addr%16)*16))+:16]:16'd0;
		4'd5:in_temp0 = (cnt%4==1'b1) ? five[(240-((addr%16)*16))+:16]:16'd0;
		4'd6:in_temp0 = (cnt%4==1'b1) ? six[(240-((addr%16)*16))+:16]:16'd0;
		4'd7:in_temp0 = (cnt%4==1'b1) ? seven[(240-((addr%16)*16))+:16]:16'd0;
		4'd8:in_temp0 = (cnt%4==1'b1) ? eight[(240-((addr%16)*16))+:16]:16'd0;
		4'd9:in_temp0 = (cnt%4==1'b1) ? night[(240-((addr%16)*16))+:16]:16'd0;
		4'd10:in_temp0 = (cnt%4==1'b1) ? wordA[(240-((addr%16)*16))+:16]:16'd0;
		4'd11:in_temp0 = (cnt%4==1'b1) ? wordP[(240-((addr%16)*16))+:16]:16'd0;
		4'd12:in_temp0 = (cnt%4==1'b1) ? wordM[(240-((addr%16)*16))+:16]:16'd0;
		default:in_temp0 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		endcase
  /*end
  always@(posedge clk)
  begin*/
		case (in1)
		4'd0:in_temp1 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		4'd1:in_temp1 = (cnt%4==1'b1) ? one[(240-((addr%16)*16))+:16]:16'd0;
		4'd2:in_temp1 = (cnt%4==1'b1) ? two[(240-((addr%16)*16))+:16]:16'd0;
		4'd3:in_temp1 = (cnt%4==1'b1) ? three[(240-((addr%16)*16))+:16]:16'd0;
		4'd4:in_temp1 = (cnt%4==1'b1) ? four[(240-((addr%16)*16))+:16]:16'd0;
		4'd5:in_temp1 = (cnt%4==1'b1) ? five[(240-((addr%16)*16))+:16]:16'd0;
		4'd6:in_temp1 = (cnt%4==1'b1) ? six[(240-((addr%16)*16))+:16]:16'd0;
		4'd7:in_temp1 = (cnt%4==1'b1) ? seven[(240-((addr%16)*16))+:16]:16'd0;
		4'd8:in_temp1 = (cnt%4==1'b1) ? eight[(240-((addr%16)*16))+:16]:16'd0;
		4'd9:in_temp1 = (cnt%4==1'b1) ? night[(240-((addr%16)*16))+:16]:16'd0;
		4'd10:in_temp1 = (cnt%4==1'b1) ? wordA[(240-((addr%16)*16))+:16]:16'd0;
		4'd11:in_temp1 = (cnt%4==1'b1) ? wordP[(240-((addr%16)*16))+:16]:16'd0;
		4'd12:in_temp1 = (cnt%4==1'b1) ? wordM[(240-((addr%16)*16))+:16]:16'd0;
		default:in_temp1 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		endcase
  /*end
  always@(posedge clk)
  begin*/
		case (in2)
		4'd0:in_temp2 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		4'd1:in_temp2 = (cnt%4==1'b1) ? one[(240-((addr%16)*16))+:16]:16'd0;
		4'd2:in_temp2 = (cnt%4==1'b1) ? two[(240-((addr%16)*16))+:16]:16'd0;
		4'd3:in_temp2 = (cnt%4==1'b1) ? three[(240-((addr%16)*16))+:16]:16'd0;
		4'd4:in_temp2 = (cnt%4==1'b1) ? four[(240-((addr%16)*16))+:16]:16'd0;
		4'd5:in_temp2 = (cnt%4==1'b1) ? five[(240-((addr%16)*16))+:16]:16'd0;
		4'd6:in_temp2 = (cnt%4==1'b1) ? six[(240-((addr%16)*16))+:16]:16'd0;
		4'd7:in_temp2 = (cnt%4==1'b1) ? seven[(240-((addr%16)*16))+:16]:16'd0;
		4'd8:in_temp2 = (cnt%4==1'b1) ? eight[(240-((addr%16)*16))+:16]:16'd0;
		4'd9:in_temp2 = (cnt%4==1'b1) ? night[(240-((addr%16)*16))+:16]:16'd0;
		4'd10:in_temp2 = (cnt%4==1'b1) ? wordA[(240-((addr%16)*16))+:16]:16'd0;
		4'd11:in_temp2 = (cnt%4==1'b1) ? wordP[(240-((addr%16)*16))+:16]:16'd0;
		4'd12:in_temp2 = (cnt%4==1'b1) ? wordM[(240-((addr%16)*16))+:16]:16'd0;
		default:in_temp2 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		endcase
  /*end

  always@(posedge clk)
  begin*/
		case (in3)
		4'd0:in_temp3 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		4'd1:in_temp3 = (cnt%4==1'b1) ? one[(240-((addr%16)*16))+:16]:16'd0;
		4'd2:in_temp3 = (cnt%4==1'b1) ? two[(240-((addr%16)*16))+:16]:16'd0;
		4'd3:in_temp3 = (cnt%4==1'b1) ? three[(240-((addr%16)*16))+:16]:16'd0;
		4'd4:in_temp3 = (cnt%4==1'b1) ? four[(240-((addr%16)*16))+:16]:16'd0;
		4'd5:in_temp3 = (cnt%4==1'b1) ? five[(240-((addr%16)*16))+:16]:16'd0;
		4'd6:in_temp3 = (cnt%4==1'b1) ? six[(240-((addr%16)*16))+:16]:16'd0;
		4'd7:in_temp3 = (cnt%4==1'b1) ? seven[(240-((addr%16)*16))+:16]:16'd0;
		4'd8:in_temp3 = (cnt%4==1'b1) ? eight[(240-((addr%16)*16))+:16]:16'd0;
		4'd9:in_temp3 = (cnt%4==1'b1) ? night[(240-((addr%16)*16))+:16]:16'd0;
		4'd10:in_temp3 = (cnt%4==1'b1) ? wordA[(240-((addr%16)*16))+:16]:16'd0;
		4'd11:in_temp3 = (cnt%4==1'b1) ? wordP[(240-((addr%16)*16))+:16]:16'd0;
		4'd12:in_temp3 = (cnt%4==1'b1) ? wordM[(240-((addr%16)*16))+:16]:16'd0;
		default:in_temp3 = (cnt%4==1'b1) ? zero[(240-((addr%16)*16))+:16]:16'd0;
		endcase
  end

  RAM R1(
    .clka(clk),
    .wea(wen),
    .addra(addr),
    .dina(data_in),
    .douta(data_out_64)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      addr = 6'd0;
      cnt = 2'd0;
      mem = 512'd0;
      state = IDLE;
      flag = 1'b0;
      counter_word = 6'd0;
      data_out = 8'd0;
      data_valid = 1'd0;
      wen = 1'b1;
      temp_change = 1'b0;
    end else begin
      addr = addr_next;
      cnt = cnt_next;
      mem = mem_next;
      state = state_next;
      flag = flag_next;
      counter_word = counter_word_next;
      data_out = data_out_next;
      data_valid = data_valid_next;
      wen = wen_next;
      temp_change = temp_change_next;
    end
  end

  always @(*) begin
    state_next = state;
    case(state)
      IDLE: begin
        if (wen) begin
          state_next = WRITE;
        end else begin
          state_next = GETDATA;
        end
      end
      WRITE: begin
        if (addr == 6'd63) begin
          state_next = GETDATA;
        end
      end
      GETDATA: begin
        if (flag == 1'b1) begin
          state_next = TRANSDATA;
        end
      end
      TRANSDATA: begin
        if (addr == 6'd0 && counter_word == 6'd63 && en) begin
          state_next = IDLE;
        end else if (counter_word == 6'd63 && en) begin
          state_next = GETDATA;
        end
      end
    endcase
  end

  always @(*) begin
    addr_next = addr;
    data_in = 64'd0;
    cnt_next = cnt;
    mem_next = mem;
    flag_next = 1'b0;
    counter_word_next = counter_word;
    data_valid_next = 1'd0;
    data_out_next = 8'd0;
    case(state)
      WRITE: begin
        addr_next = addr + 1'b1;
        data_in = {in_temp0, in_temp1, in_temp2, in_temp3};
        if (addr == 6'd15 || addr == 6'd31 || addr == 6'd47 || addr == 6'd63) begin
          cnt_next = cnt + 1'd1;
        end
      end
      GETDATA: begin
        if (!flag) begin
          addr_next = addr + 1'b1;
        end
        if ((addr%8) == 6'd7) begin
          flag_next = 1'b1;
        end
        if ((addr%8) >= 6'd1 || flag) begin
          mem_next[(((addr-1)%8)*64)+:64] = data_out_64;
        end
      end
      TRANSDATA: begin
        if (en) begin
          counter_word_next = counter_word + 1'b1;
          data_valid_next = 1'b1;
          data_out_next = {mem[511 - counter_word],
            mem[447 - counter_word],
            mem[383 - counter_word],
            mem[319 - counter_word],
            mem[255 - counter_word],
            mem[191 - counter_word],
            mem[127 - counter_word],
            mem[63 - counter_word]};
        end
      end
    endcase
  end
 
  //wen control
  always @(*) begin
    wen_next = wen;
    temp_change_next = temp_change;
    if (change||hr_change) begin
      temp_change_next = 1'b1;
    end
    if (state == WRITE && addr == 6'd63) begin
      wen_next = 1'b0;
    end
    if (state == TRANSDATA && addr == 6'd0 && counter_word == 6'd63 && temp_change == 1'b1) begin
      temp_change_next = 1'b0;
      wen_next = 1'b1;
    end
  end
endmodule
