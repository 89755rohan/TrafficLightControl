`timescale 1ns/1ps

module main (
input reset, clk, c,
output MR, MY, MG,
output SR, SY, SG,ST
);
  wire TL, TS;
 timer part1 (.clk(clk), .ST(ST), .TS(TS), .TL(TL));
 fsm part2 (.reset(reset), .clk(clk), .c(c), .MR(MR), .MY(MY), .MG(MG),
               .SR(SR), .SY(SY), .SG(SG), .TL(TL), .TS(TS), .ST(ST));
endmodule 

`timescale 1ns/1ps

module timer(
input clk, ST,
output reg TS, TL
);
  
  integer value;
  
  assign TS = (value>=4);
  assign TL = (value>=14);
  
  always @(posedge clk or posedge ST)
    begin 
      if(ST==1)
        value <= 1;
      else 
        value <= value +1;
    end
endmodule

`timescale 1ns/1ps

module fsm (
  input clk, reset, c, TS, TL,
  output MR,MY,MG,
  output SR,SY,SG, 
  output reg ST
);
  reg[6:1] state;
  
  parameter mainroadgreen = 6'b001100;
  parameter mainroadyellow = 6'b010100;
  parameter sideroadgreen = 6'b100001;
  parameter sideroadyellow = 6'b100010;
  
  assign MR = state[6];
  assign MY = state[5];
  assign MG = state[4];
  assign SR = state[3];
  assign SY = state[2];
  assign SG = state[1];
  
  initial begin state = mainroadgreen; ST=0;end
  
  always @(posedge clk)
    begin 
      if(reset)begin 
        state <= mainroadgreen;
        ST <= 1; 
      end
      else begin 
        ST <= 0;
        case(state)
          mainroadgreen : 
            if(TL&c)
              begin state <= mainroadgreen;
                ST <= 1;
              end
          mainroadyellow : 
            if(TS)
              begin state <= sideroadgreen;
                ST <= 1;
              end
          sideroadgreen : 
            if(TL| !c)
              begin state <= sideroadyellow;
                ST <= 1;
              end
          sideroadyellow : 
            if(TS)
              begin state <= mainroadgreen;
                ST <= 1;
              end
        endcase
      end 
    end
  endmodule