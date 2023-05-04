`timescale 1ns / 1ps
`define CLK @(posedge clk)
module qs_fifo_tb ();
  
  localparam DATA_W = 8;
  localparam DEPTH = 2;
  
  logic 			clk;
  logic				reset;
  logic 			push_i;
  logic [DATA_W-1:0] push_data_i;
  logic 			pop_i;
  logic [DATA_W-1:0] pop_data_o;
  logic full_o;
  logic empty_o;
  
  fifo #(.DATA_W(DATA_W), .DEPTH(DEPTH)) FIFO(
    .*
  );
            
  // Generate clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
            
  // Drive our stimulus
  initial begin
    reset = 1'b1;
    push_i = 1'b0;
    pop_i = 1'b0;
    repeat (2) @(posedge clk);
    reset = 1'b0;
    `CLK;
    push_i = 1'b1;
    push_data_i = 8'hAB;
    `CLK;
    push_data_i = 8'hCC;
    `CLK;
    push_i = 1'b0;
    `CLK;
    push_i = 1'b0;
    push_data_i = 8'hx;
    pop_i = 1'b1;
    `CLK;
    pop_i = 1'b0;
    repeat (2) `CLK;
    $finish();
  end
            

  
endmodule