`timescale 1ns/1ps
module fsm_tb;
  
  reg TL,TS,c,reset,clk;
  wire MR, MY, MG, SR, SY, SG, ST;
  
  fsm uut(.MR(MR),.MY(MY),.MG(MG),.SR(SR),.SY(SY),.SG(SG),.ST(ST),.TL(TL),
          .TS(TS),.c(c),.reset(reset),.clk(clk));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, fsm_tb);
    TS=0;TL=0;c=0;reset=1;
    clk = 0;
    #100 TS=0;TL=1;c=1;reset=0;
    #100 TS=0;TL=0;c=0;reset=1;
    #100 TS=1;TL=1;c=0;reset=0;
    #100;
    $finish; 
  end
  always 
    begin
      #100
      clk = ~clk;
    end
endmodule
    
    