//The buffer between memory and write back stage 

module MEM_WB(input clk, RegW_MEM,
              input [3:0] Rd4_MEM,
              input [31:0] DataOut_MEM,
              output reg RegW_WB,
              output reg [3:0] Rd4_WB,
              output reg [31:0] DataOut_WB);
  always @(posedge clk) begin
    RegW_WB = RegW_MEM;
    Rd4_WB = Rd4_MEM;  
	DataOut_WB=DataOut_MEM;
  end
endmodule