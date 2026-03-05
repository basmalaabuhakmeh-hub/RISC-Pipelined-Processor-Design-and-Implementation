module MemoryStage(input clk, MEMR_EX, MEMW_EX, 
				   input [1:0] WB_Sel,
                   input [3:0] Rd_EX,
                   input [31:0] BusB, ALUResult,nextPC,
                   output reg [31:0] DATAout);
  
  wire [31:0] memoryData;
  Data_MEM ReadData(clk,BusB,ALUResult,MEMW_EX,MEMR_EX, memoryData);
  
	  
 

  always @(*) begin
    case (WB_Sel) 
	  2'b00: DATAout = ALUResult;
      2'b01: DATAout = memoryData;
      2'b10: DATAout = nextPC+1;
      default:DATAout=32'hx; 
	 endcase 
  end
  
endmodule		   
			  
		
             
            