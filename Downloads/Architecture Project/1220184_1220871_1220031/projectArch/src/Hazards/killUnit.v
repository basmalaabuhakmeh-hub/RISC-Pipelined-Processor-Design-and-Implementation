//kill control unit
module kill(input [5:0] OPCode,
           input [1:0] CMPresult,
            output reg killSignal);
  always @(*) begin
	  killSignal = 0;
    if(OPCode == 6'b001101 || OPCode == 6'b001110 || OPCode == 6'b001111) killSignal = 1; //Jump Instruction
    else if(OPCode == 6'b001010 && CMPresult == 0) killSignal = 1; //BZ Instruction and the branch is taken
    else if(OPCode == 6'b001011 && CMPresult == 1) killSignal = 1; //BGZ Instruction and the branch is taken
    else if(OPCode == 6'b001100 && CMPresult != 1 && CMPresult != 0) killSignal = 1; //BLZ Instruction and the branch is taken
    else killSignal = 0; 
  end	
  //initial $monitor(" from kill unit at time:%0d:\nCMPresult = %0d"
	  //,$time, CMPresult);
endmodule