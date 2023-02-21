`timescale 1ns / 1ps
module testbench;
  
reg clock,reset;
reg [2:0]coin;
wire vend;
wire [2:0]state;
wire [2:0]change;

parameter [2:0] Rs5Coin = 3'b001;
parameter [2:0] Rs10Coin = 3'b010;
parameter [2:0] Rs5Coin_Rs10Coin = 3'b011;
parameter [2:0] Rs10Coin_Rs10Coin = 3'b100;
parameter [2:0] Rs25Coin = 3'b101;

parameter [2:0] IDLE = 3'b000;
parameter [2:0] FIVE = 3'b001;
parameter [2:0] TEN = 3'b010;
parameter [2:0] FIFTEEN = 3'b011;
parameter [2:0] TWENTY = 3'b100;
parameter [2:0] TWENTYFIVE = 3'b101;
  
  // instantiate DUT
    vending_machine dut(clock,reset,coin,vend,state,change);

initial begin
$display("Time\tcoin\tdrink\treset\tclock\tstate\tchange");
$monitor("%g \t %b \t %b \t %b \t %b \t  %d  \t %d",$time,coin,vend,reset,clock,state,change);

clock=0;
reset=1; 
#2 reset=0;
coin=Rs5Coin;
  
#2 reset = 1; coin = 2'b00;
#2 reset=0;
  
coin=Rs10Coin;
#2 reset = 1; coin =2'b00;
#2 reset=0;
coin=Rs25Coin;

#2 reset=1; coin=2'b00;
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs10Coin;
#2 coin=Rs10Coin;
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs10Coin;
#2 coin=Rs25Coin;
#2 reset=1; coin=2'b00;
  
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs10Coin;
#2 reset=1; coin=2'b00;
  
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs10Coin;
#2 reset=1; coin=2'b00;
  
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs5Coin;
#2 coin=Rs25Coin;

#2 reset=1; coin=2'b00;
#2 reset=0;
coin=Rs5Coin;
#2 coin=Rs25Coin;
#2 reset=1; coin=2'b00;
  /// after this
  #2 reset =0;
  #2 coin=Rs5Coin;
  #2 coin=Rs5Coin;
  #2 coin=2'b00;
  #2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;
  #2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;#2 coin=2'b00;
  #2 coin=Rs5Coin;
  #2 coin=Rs5Coin;
  #2 coin=Rs5Coin;#2 coin=Rs5Coin;
  
  //// before this
#2 $finish;
end

always begin
  #1 clock=~clock; end

initial begin
if (reset)
coin=2'b00;
end
  
endmodule : testbench
