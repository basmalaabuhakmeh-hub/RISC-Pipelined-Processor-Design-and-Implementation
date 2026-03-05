module Pipelined_Processor();
    // Pipeline control signals
    wire stall, kill;  
	
    reg [31:0] PC_reg; 
  	reg clk;
    // Fetch stage signals
    wire [31:0] PC_F, NPC_F, Instruction_F, currentPC_F;
    wire [1:0] CMPresult_F;
    wire [1:0] PC_sel_F, J_OR_B_Flag_F,J_OR_B_Flag_D;
    // Decode stage signals
    wire [31:0] Instruction_D, PC_D;
    wire MEM_read_D, MEM_write_D, RegW_D, is_CLL, isSecondCycle_D;
    wire [3:0] R_dest_D;
    wire [31:0] A_D, B_D, ExtendedImm_D;
    wire [2:0] ALUOp_D;
    wire [1:0] CMPFlag_D, ALUSrc_D, WB_sel_D;
    wire is_LDW_SDW;
    // Execute stage signals
    wire signed [1:0] CMPflag_EX;
    wire ZeroFlag_EX;
    wire [31:0] Result_EX;
    wire [31:0] A_EX, B_EX, ExtendedImm_EX, nextPC_EX;
    wire [3:0] Rd2_EX;
    wire [2:0] ALUOp_EX;
    wire [1:0] WB_EX, ALUSrc_EX;
    wire RegW_EX, MEMR_EX, MEMW_EX;
    
    // Memory stage signals
    wire [31:0] DATAout_MEM;
    wire [31:0] ALURes_MEM, nextPC_MEM, DataIn_MEM;
    wire [3:0] Rd3_MEM;
    wire [1:0] WB_MEM;
    wire signed [1:0] CMPflag_MEM;
    wire RegW_MEM, MEMR_MEM, MEMW_MEM;
    
    // Writeback stage signals
    wire [31:0] DataOut_WB;
    wire [3:0] Rd4_WB;
    wire RegW_WB;
    
   	initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
      
       // Instantiate pipeline stages
    FetchStage fetch(
        .clk(clk),
        .stall(stall),
        .kill(kill),
        .currentPC(currentPC_F), 
        .PC_D(PC_D),
        .Reg(A_D), // For JR instruction
        .RR(R14), // Return address for CLL
        .Imm(ExtendedImm_D[13:0]),
        .CMPresult(CMPFlag_D), // From Decode stage
        .PC_sel(PC_sel_F),
        .J_OR_B_Flag(J_OR_B_Flag_D),
        .Instruction(Instruction_F),
        .NPC(NPC_F)
    );
	assign PC_F = currentPC_F;
    // IF_ID Pipeline Buffer
    IF_ID if_id(
        .clk(clk),
        .Instruction_F(Instruction_F),
        .PC_F(PC_F),   // current pc or next pc ??
        .stall(stall),
        .kill(kill),
        .Instruction_D(Instruction_D),
        .PC_D(PC_D)
    );
    
    // Decode Stage
    DecodeStage decode(
        .clk(clk),
        .Instruction(Instruction_D),
        .ALUForward(Result_EX), // Forward from EX
        .MEMForward(DATAout_MEM), // Forward from MEM
        .PC_D(PC_D),
        .Data_in_WB(DataOut_WB),  //forward from WB
        .RegWr_WB(RegW_WB),
        .RegWr_EX(RegW_EX),
        .RegWr_MEM(RegW_MEM),
        .MEMR_EX(MEMR_EX),
        .Rd_EX(Rd2_EX),
        .Rd_MEM(Rd3_MEM),
        .Rd_WB(Rd4_WB),
        .MEM_read(MEM_read_D),
        .MEM_write(MEM_write_D),
        .RegW(RegW_D),
        .CLL_E(is_CLL),
        .isSecondCycle(isSecondCycle_D),
        .R_dest(R_dest_D),
        .PC_sel(PC_sel_F),
        .J_OR_B_Flag(J_OR_B_Flag_D),
        .A(A_D),
        .B(B_D),
        .stallSignal(stall),
        .killSignal(kill),
        .ALUOp(ALUOp_D),
        .CMPFlag(CMPFlag_D),
        .ALUSrc(ALUSrc_D),
        .WB_sel(WB_sel_D),
        .ExtendedImm(ExtendedImm_D),
		.is_LDW_SDW(is_LDW_SDW)
    );
    
    // ID/EX Pipeline Buffer
    ID_EX id_ex(
        .clk(clk),
        .stall(stall),
        .Rd2_D(R_dest_D),
        .RegW_D(RegW_D),
        .MEMR_D(MEM_read_D),
        .MEMW_D(MEM_write_D),
        .A_D(A_D),
        .B_D(B_D),
        .ALUSrc_D(ALUSrc_D),
        .ALUOp_D(ALUOp_D),
        .WB_D(WB_sel_D),
        .ExtendedImm_D(ExtendedImm_D),
        .nextPC_D(PC_D),
		.is_LDW_SDW(is_LDW_SDW),
        .Rd2_EX(Rd2_EX),
        .RegW_EX(RegW_EX),
        .MEMR_EX(MEMR_EX),
        .MEMW_EX(MEMW_EX),
        .A_EX(A_EX),
        .B_EX(B_EX),
        .ALUSrc_EX(ALUSrc_EX),
        .ALUOp_EX(ALUOp_EX),
        .ExtendedImm_EX(ExtendedImm_EX),
        .WB_EX(WB_EX),
        .nextPC_EX(nextPC_EX)
    );
    
    // Execute Stage
    ExecutionStage execute(
        .ALUOp(ALUOp_EX),
        .BusA(A_EX),
        .BusB(B_EX),
        .ExtendedImm(ExtendedImm_EX),
        .ALUSrc(ALUSrc_EX),
        .CMPflag(CMPflag_EX),
        .ZeroFlag(ZeroFlag_EX),
        .Result(Result_EX)
    );
    
    // EX/MEM Pipeline Register
    EX_MEM ex_mem(
        .clk(clk),
        .RegW_EX(RegW_EX),
        .MEMR_EX(MEMR_EX),
        .MEMW_EX(MEMW_EX),
        .Rd3_EX(Rd2_EX),
        .WB_EX(WB_EX),
        .CMPflag_EX(CMPflag_EX),
        .ALURes_EX(Result_EX),
        .nextPC_EX(nextPC_EX),
        .DataIn_EX(B_EX),
        .RegW_MEM(RegW_MEM),
        .MEMR_MEM(MEMR_MEM),
        .MEMW_MEM(MEMW_MEM),
        .Rd3_MEM(Rd3_MEM),
        .WB_MEM(WB_MEM),
        .CMPflag_MEM(CMPflag_MEM),
        .ALURes_MEM(ALURes_MEM),
        .nextPC_MEM(nextPC_MEM),
        .DataIn_MEM(DataIn_MEM)
    );
    
    // Memory Stage
    MemoryStage memory(
        .clk(clk),
        .MEMR_EX(MEMR_MEM),
        .MEMW_EX(MEMW_MEM),
        .WB_Sel(WB_MEM),
        .Rd_EX(Rd3_MEM),
        .BusB(DataIn_MEM),
        .ALUResult(ALURes_MEM),
        .nextPC(nextPC_MEM),
        .DATAout(DATAout_MEM)
    );
    
    // MEM/WB Pipeline Register
    MEM_WB mem_wb(
        .clk(clk),
        .RegW_MEM(RegW_MEM),
        .Rd4_MEM(Rd3_MEM),
        .DataOut_MEM(DATAout_MEM),
        .RegW_WB(RegW_WB),
        .Rd4_WB(Rd4_WB),
        .DataOut_WB(DataOut_WB)
    );
     
    // Special register R14 (return address)
    reg [31:0] R14;
    always @(posedge clk) begin
        if (is_CLL) begin // If CLL instruction
            R14 <= PC_D + 1; // Save return address
        end
    end
initial begin
        $display("====================================================================================================");
        $display("Time\tPC\t\tIF\t\tID\t\tEX\t\tMEM\t\tWB\t\tRegW\tData");
        $display("====================================================================================================");	
		 #200 $finish; 
    end 

    // Monitor signals at every clock edge
    always @(posedge clk) begin
        $display("%h\t%h\t%h\t%h\t%h\t%h\t%b\t%h", 
            NPC_F,
            Instruction_F,
            Instruction_D,
            ALUOp_EX,
            WB_MEM,
            WB_sel_D,
            RegW_WB,
            DataOut_WB
        ); 
		
      
        $display("\t\tIF Stage: PC=%h, Instr=%h", PC_F, Instruction_F);
        $display("\t\tID Stage: Instr=%h, A_D=%h, B_D=%h, R_dest_D=%h, Imm=%h", 
            Instruction_D,
            A_D,
            B_D,
            R_dest_D,
            ExtendedImm_D
        );
        $display("\t\tEX Stage: ALUOp=%b, A=%h, B=%h, Result=%h", 
            ALUOp_EX,
            A_EX,
            B_EX,
            Result_EX
        );
        $display("\t\tMEM Stage: MEMR_MEM=%b, MEMW_MEM=%b, Addr(ALUres)=%h, Rd3_MEM=%h,DataIn=%h",
            MEMR_MEM ,
            MEMW_MEM ,
            ALURes_MEM,
			Rd3_MEM,
            DataIn_MEM
        );
        $display("\t\tWB Stage: RegW=%b, Rd=%d, Dataout=%h",
            RegW_WB,
            Rd4_WB,
            DataOut_WB
        );
        $display("----------------------------------------------------------------------------------------------------");
		end 
		
endmodule

/*module tb_Pipelined_Processor();
    reg clk;
    
    // Instantiate the processor
    Pipelined_Processor uut(
        .clk(clk)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
  
    
    // Initialize and run test
    initial begin
        // Initialize signals
        clk = 0;
        
     
        
        // Run 
        #200 $finish;
    end	 
    
    
endmodule	*/