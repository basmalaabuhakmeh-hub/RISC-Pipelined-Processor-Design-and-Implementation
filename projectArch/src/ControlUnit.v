module ControlUnit (  
	input clk,
    input [5:0] opcode,
	input Rd,
	input isSecondCycle,
    output reg RegWrite, MemRead, MemWrite, ExtOp,
	nextIsSecondCycle, 	//flag is set to 1 when the instruction LDW/SDW is in its first cycle so it can take the control signals of the second cycle in the next cycle   	
	is_LDW_SDW,	//flag is set to 1 when the instruction is LDW/SDW  
	CLL_E,	 //flag is set to 1 when the instruction is CLL
    output reg [2:0] ALUOp,
    output reg [1:0] PCSrc,WBData ,RegDest ,J_OR_B_Flag, ALUSrc, RegToRead
);

    always @(*) begin
        // Default values
        RegWrite = 0; MemRead = 0; MemWrite = 0; RegToRead = 0 ; // rt
        ALUSrc = 0; ALUOp = 3'b000; PCSrc = 2'b00;
		WBData=2'b00; RegDest=2'b00;   
		ExtOp=1;J_OR_B_Flag=0;	// jumb In= 00, BZ In = 01 , BGZ = 10, BLZ = 11
		nextIsSecondCycle = 0;CLL_E=0;
		is_LDW_SDW = 0;
        case (opcode)
            6'd0: begin // OR
                RegWrite = 1;
                ALUOp = 3'b000;
				ExtOp=1'bx; 
				ALUSrc = 1;
				
            end
            6'd1: begin // ADD
                RegWrite = 1;
                ALUOp = 3'b001;
				ExtOp=1'bx;
				ALUSrc = 1;
            end
            6'd2: begin // Sub
                RegWrite = 1;
                ALUOp = 3'b010;
				ExtOp=1'bx;
				ALUSrc = 1;	
            end	  
			6'd3: begin // CMP
                RegWrite = 1;
                ALUOp = 3'b011;
				ExtOp=1'bx;
				ALUSrc = 1;
            end	
			6'd4: begin // ORI
                RegWrite = 1;
                ALUOp = 3'b000;
				ExtOp=1'b0; 
				//isSecondCycle= 0;
            end
			6'd5: begin //ADD1 
                RegWrite = 1;
                ALUOp = 3'b001;
				//isSecondCycle= 0;
            end
			6'd6: begin // LW
                RegWrite = 1;
                ALUOp = 3'b001;
				MemRead=1;
				WBData=	2'b01; 
            end
			6'd7: begin // SW
                MemWrite=1; 
				WBData=2'bxx;
                ALUOp = 3'b001;	
				RegToRead = 1;
            end
            6'd8: begin // LDW  first cycle	  
				if (Rd == 1'b1) begin
    			// rd is odd
    				//skip to next instruction 
				end else begin
				if (isSecondCycle == 1'b0 ) begin 
                RegWrite = 1;
                ALUOp = 3'b001;
				MemRead=1;
				WBData=	2'b01; 
				nextIsSecondCycle = 1;
				is_LDW_SDW = 1;
				end 
			else begin 	
				RegDest = 2'b01;
				RegWrite = 1;
				ALUOp = 3'b100;	
				MemRead=1;
				WBData=2'b01;  
				nextIsSecondCycle = 0;
				end 
				end
            end
            6'd9: begin // SDW  
            if (Rd == 1'b1) begin
    			// rd is odd
    				//skip to next instruction 
				end else begin
				if (isSecondCycle == 1'b0 ) begin 
                ALUOp = 3'b001;
				MemWrite=1;
				WBData=	2'b01; 	 
				RegToRead = 1 ;
				nextIsSecondCycle = 1; 
				is_LDW_SDW = 1;
				end 
			else begin 	 
				RegDest = 2'b01;
				ALUOp = 3'b100;	
				MemWrite=1;
				WBData=2'b01; 			 
				RegToRead = 2;//change to Rd+1
				end 
				end    
            end
            6'd10: begin // BZ
                J_OR_B_Flag = 1;
                PCSrc = 2'b10; 
				RegDest = 2'bxx; 
				ExtOp=1'bx;	
				ALUSrc = 2'b10;	
				ALUOp = 3'b011;
				WBData=2'bxx;
            end
            6'd11: begin // BGZ
                J_OR_B_Flag = 2;
                PCSrc = 2'b10; 
				RegDest = 2'bxx; 
				ExtOp=1'bx;	
				ALUSrc = 2'b10;	
				ALUOp = 3'b011;
				WBData=2'bxx;
            end
			6'd12: begin // BLZ 
                J_OR_B_Flag = 3;
                PCSrc = 2'b10; 
				RegDest = 2'bxx; 
				ExtOp=1'bx;	
				ALUSrc = 2'b10;	
				ALUOp = 3'b011;
				WBData=2'bxx;
            end
			6'd13: begin // JR to Rs 
                J_OR_B_Flag = 0;
                PCSrc = 2'b01; 
				RegDest = 2'bxx; 
				ExtOp=1'bx;	
				ALUSrc = 2'bxx;	
				ALUOp = 3'bxxx;
				WBData=2'bxx;
            end
			6'd14: begin // J label
                J_OR_B_Flag = 0;
                PCSrc = 2'b10; 
				RegDest = 2'bxx;  		  
				ALUSrc = 2'bxx;	
				ALUOp = 3'bxxx;
				WBData=2'bxx;
            end
			6'd15: begin // Cll label
                J_OR_B_Flag = 0;
                PCSrc = 2'b10; 
				RegDest = 2'b10;  
				RegWrite = 1;	
				ExtOp=1'bx;	  
				ALUSrc = 2'bxx;	
				ALUOp = 3'bxxx;
				WBData=2'b10; 
				CLL_E=1;
            end
            default: begin
              
            end
endcase
end
   
endmodule
