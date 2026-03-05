/*module SingleCycleProcessor(
    input clk,
    input reset
);
    // Instruction Fetch Stage
    wire [31:0] PC, NextPC, Instruction;
    
    // Instruction Decode Stage
	wire CLL_E;
    wire [5:0] OpCode;
    wire [3:0] Rd, Rs, Rt, Rt_or_Rd;
	wire [3:0] Rd_plus_1;
    wire [13:0] Imm;
    wire [31:0] ReadData1, ReadData2;
    
    // Execution Stage
    wire [31:0] ALUResult, ExtendedImm, ALUInput2;
    wire ZeroFlag;
    wire [1:0] CMPResult;
    
    // Memory Stage
    wire [31:0] MemReadData;
    
    // Write Back Stage
    wire [31:0] WriteBackData;
    
    // Control Signals
    wire RegWrite, MemRead, MemWrite, ExtOp, isSecondCycle;
    wire [2:0] ALUOp;
    wire [1:0] PCSrc, WBData, RegDest ,J_OR_B_Flag, ALUSrc,RegToRead;
    
    // Program Counter
    reg [31:0] PC_reg;
    always @(posedge clk or posedge reset) begin
        if (reset) PC_reg <= 0;
        else PC_reg <= NextPC;
    end
    assign PC = PC_reg;
    
    // Instruction Memory
    Inst_MEM IMEM(
        .address(PC),
        .inst(Instruction)
    );
    
    // Instruction Splitter
    Split Splitter(
        .Inst(Instruction),
        .OPCode(OpCode),
        .Rd(Rd),
        .Rs(Rs),
        .Rt(Rt),
        .Imm(Imm)
    );
    
    // Control Unit
    ControlUnit CU(
		.clk(clk),
		.opcode(OpCode),     
		.Rd(Rd[0]),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ExtOp(ExtOp),
        .ALUOp(ALUOp),
        .J_OR_B_Flag(J_OR_B_Flag),
        .PCSrc(PCSrc),
        .WBData(WBData),
        .RegDest(RegDest),
		.RegToRead(RegToRead),
		.isSecondCycle(isSecondCycle),
		.CLL_E(CLL_E)
    );
    assign Rd_plus_1 = Rd + 1;
    // Register File
    wire [3:0] WriteReg;
    assign WriteReg = (RegDest == 2'b00) ? Rd : 
                     (RegDest == 2'b01) ? Rd_plus_1 :
                     (RegDest == 2'b10) ? 4'd14 : // R14 for CALL
                     4'bxxxx; 
					 
    // Register to read Input MUX
	assign Rt_or_Rd = (RegToRead == 2'b00) ? Rt : 
                     (RegToRead == 2'b01) ? Rd:
                     (RegToRead == 2'b10) ? Rd_plus_1 : 
                     4'bxxxx; 				 
    RegFile RF(
        .src1(Rs),
        .src2(Rt_or_Rd),
        .RegDest(WriteReg),
        .data_in(WriteBackData),
        .WE(RegWrite),
        .clk(clk),
        .Reg1(ReadData1),
        .Reg2(ReadData2)
    );
    
    // Immediate Extender
    Extend Extender(
        .sel(ExtOp),
        .Imm(Imm),
        .out(ExtendedImm)
    );
    
    // ALU Input MUX
	assign ALUInput2 = (ALUSrc == 2'b00) ? ExtendedImm :
                          (ALUSrc == 2'b01) ? ReadData2 :
                          (ALUSrc == 2'b10) ? 0 : // for branch instructions cmp with 0
                          32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    
	
    
    // ALU
    ALU ALUUnit(
        .IN1(ReadData1),
        .IN2(ALUInput2),
        .ALU_OP(ALUOp),
        .Result(ALUResult),
        .ZeroFlag(ZeroFlag),
		.CMPflag(CMPResult)
    );
    
    
    
    // Data Memory
    Data_MEM DMEM(
        .clk(clk),
        .data_in(ReadData2),
        .address(ALUResult),
        .MEM_W(MemWrite),
        .MEM_R(MemRead),
        .data_out(MemReadData)
    );
    
    // Write Back MUX
    assign WriteBackData = (WBData == 2'b00) ? ALUResult :
                          (WBData == 2'b01) ? MemReadData :
                          (WBData == 2'b10) ? PC + 1 : // For CALL return address
                          32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    
    // PC Control Unit
    PC_CU PCControl(
        .currentPC(PC),
        .PC_D(PC + 1),
        .Imm(Imm),
        .J_OR_B_Flag(J_OR_B_Flag),
        .RR(ReadData1),
        .Reg(ReadData1),
        .CMPresult(CMPResult),
        .PC_sel(PCSrc),
        .NextPC(NextPC)
    );
	
	always @(posedge clk) begin
    $display("---- Clock Cycle ----");
    $display("PC: %h", PC);
    $display("Instruction: %h", Instruction);
    $display("Opcode: %b", OpCode);
    $display("Control Signals:");
    $display("  RegWrite: %b, MemWrite: %b, MemRead: %b", RegWrite, MemWrite, MemRead);
    $display("  ALUSrc: %b, RegDest: %b", ALUSrc, RegDest);	
	$display("  RegToRead: %b", RegToRead);
	$display("  Rt_or_Rd: %b", Rt_or_Rd);
    $display("ALUOp: %b", ALUOp);
    $display("ReadData1: %h, ReadData2: %h", ReadData1, ReadData2);
    $display("ExtendedImm: %h", ExtendedImm);
    $display("ALUResult: %h, CMPflag: %b", ALUResult, CMPResult);
    $display("Write Back Data: %h", WBData);
	$display("Is second cycle : %b", isSecondCycle);
    $display("-----------------------\n");
    end

    
endmodule


module ProcessorTest;
    reg clk = 0, reset = 1;
    SingleCycleProcessor UUT(clk, reset);

    initial begin
        #10 reset = 0;
        repeat (50) begin
            #10 clk = ~clk;
        end
        $finish;
    end
endmodule

									 */

