`timescale 1ns / 1ps

`define CLK @(posedge pclk)

module apb_slave_tb ();
  
	logic 			pclk;
	logic 			preset_n; 	// Active low reset
 
  logic[1:0]		add_i;		// 2'b00 - NOP, 2'b01 - READ, 2'b11 - WRITE
  
	logic 			psel_o;
	logic 			penable_o;
  	logic [31:0]	paddr_o;
	logic			pwrite_o;
  	logic [31:0] 	pwdata_o;
  	logic [31:0]	prdata_i;
 	logic			pready_i;
  
  // Implement clock
  always begin
    pclk = 1'b0;
    #5;
    pclk = 1'b1;
    #5;
  end
  
  // Instantiate the RTL
  apb_add_master APB_MASTER (.*);
  
  // Drive stimulus
  initial begin
    preset_n = 1'b0;
    add_i = 2'b00;
    repeat (2) `CLK;
    preset_n = 1'b1;
    repeat (2) `CLK;
    
    // Initiate a read transaction
    add_i = 2'b01;
    `CLK;
    add_i = 2'b00;
    repeat (4) `CLK;
    
    // Initiate a write transaction
    add_i = 2'b11;
    `CLK;
    add_i = 2'b00;
    repeat (4) `CLK;
    $finish();
  end
  
  // APB Slave
  always_ff @(posedge pclk or negedge preset_n) begin
    if (~preset_n)
      pready_i <= 1'b0;
    else begin
    if (psel_o && penable_o) begin
      pready_i <= 1'b1;
      prdata_i <= $urandom%32'h20;
    end else begin
      pready_i <= 1'b0;
      prdata_i <= $urandom%32'hFF;
    end
    end
  end
  
  // VCD Dump
  initial begin
    $dumpfile("apb_master.vcd");
    $dumpvars(2, apb_slave_tb);
  end
  
endmodule