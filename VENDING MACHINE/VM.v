`timescale 1ns / 1ps
module vending_machine(clock,reset,coin,vend,state,change);

  // inputs
input clock;
input reset;
input [2:0]coin;

  //ouptuts
output vend;
output [2:0]state;
output [2:0]change;

reg [2:0] prev_in ;
reg vend;
reg [2:0]change;
wire [2:0]coin;
  
  // internal 
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

reg [2:0] state,next_state;

always @(state or coin)
begin
	next_state=0; 
case(state)
IDLE: case(coin) 
     Rs5Coin : next_state=FIVE;
     Rs10Coin: next_state=TEN;
     Rs25Coin: next_state=TWENTYFIVE;
     default : next_state=IDLE;
endcase

FIVE: case(coin) 
     Rs5Coin : next_state=TEN;
     Rs10Coin: next_state=FIFTEEN;
     Rs25Coin: next_state=TWENTYFIVE; //change=Rs5Coin
     default : next_state=FIVE;
endcase

TEN: case(coin) 
     Rs5Coin : next_state=FIFTEEN;
     Rs10Coin: next_state=TWENTY;
     Rs25Coin: next_state=TWENTYFIVE; //change=Rs10Coin
     default : next_state=TEN;
endcase

FIFTEEN: case(coin)
     Rs5Coin : next_state=TWENTY;
     Rs10Coin: next_state=TWENTYFIVE;
     Rs25Coin: next_state=TWENTYFIVE; //change==Rs5Coin_Rs10Coin
     default : next_state=FIFTEEN;
endcase

TWENTY: case(coin) 
     Rs5Coin : next_state=TWENTYFIVE;
     Rs10Coin: next_state=TWENTYFIVE; //change=Rs5Coin
     Rs25Coin: next_state=TWENTYFIVE; //change==Rs10Coin_Rs10Coin
     default : next_state=TWENTY;
endcase

TWENTYFIVE: next_state=IDLE; 
     default : next_state=IDLE;
endcase

end
  
always @(clock)
begin 
      if(reset) 
	begin
           state <= IDLE;
           vend <= 1'b0;
	end 
	else 
      state <= next_state;

  // output value is calculated below
case (state)
  IDLE : begin 
  		vend <= 1'b0; 
		change <= 3'd0; 
	end
  
  FIVE : begin 
  		vend <= 1'b0; 
		if (coin == Rs25Coin) 
			change <= Rs5Coin;  // 5+25 - 25 = 5
		else change <= 3'd0;
	end
  
  TEN : begin 
  		vend <= 1'b0; 
		if (coin == Rs25Coin) 
			change <= Rs10Coin; // 10+25 - 25 = 10
		else change <= 3'd0; 
	end
  
  FIFTEEN : begin 
  		vend <= 1'b0; 
		if (coin==Rs25Coin) 
			change <= Rs5Coin_Rs10Coin; // 15+25 - 25 = 5_10
		else change <= 3'd0; 
	end
  
  TWENTY : begin 
  		vend <= 1'b0; 
		if (coin==Rs10Coin) 
			change <= Rs5Coin; // 20+10 - 25 = 5
		else if (coin==Rs25Coin) 
			change <= Rs10Coin_Rs10Coin ; // 20+25 - 25 = 10_10
		else change <= 3'd0; 
	end
  
  TWENTYFIVE : begin 
  		vend <= 1'b1; 
		change <= 3'd0; 
	end
  
  default : state <= IDLE;
endcase
end

  // logic to wait for input coin for 10 clock cycle.
integer count = 0;
  always @ (clock) 
    begin
      if (coin == 3'b000)
	      count = count + 1; // increment counter whenever no coin is received
	else
    		count = 0;
    
      if (count==10) begin
    	change = state;
        state = IDLE; // auto reset
      	count = 0;   end
  end
endmodule : vending_machine