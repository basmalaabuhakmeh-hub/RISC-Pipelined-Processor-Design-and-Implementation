// Module for Data Memory
module Data_MEM(clk, data_in, address, MEM_W, MEM_R, data_out);
  input clk, MEM_W, MEM_R;
  input [31:0] data_in, address;
  output reg [31:0] data_out;
  
  reg [31:0] RAM[0:255];
  integer i;

  // Initialize RAM from file
  initial begin
    $readmemb("DataMemory.dat", RAM);
  end 

  // Print initial memory state
  initial $display("Initial MEM[0] = %0d, MEM[1] = %0d", RAM[0], RAM[1]);

  // Read from RAM 
  always @(*) begin
    if (MEM_R)
      data_out = RAM[address];	
    else
      data_out = 32'bx; // unknown value if not reading
  end

  // Write to RAM (on rising clock edge)
  always @(posedge clk) begin
    if (MEM_W) begin
      RAM[address] <= data_in;
      $display("[Data_MEM] Write: RAM[%0d] <= %h at time %0t", address, data_in, $time);
    end
  end

  // Dump entire RAM after some time 
  initial begin
    #200;
    $display("=== Dumping Data Memory ===");
    for (i = 0; i < 10; i = i + 1) begin
      $display("RAM[%0d] = %h", i, RAM[i]);
    end
  end
endmodule
