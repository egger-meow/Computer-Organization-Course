
module Pipeline_CPU( clk_i, rst_n );
 


//I/O port
input         clk_i;
input         rst_n;





wire [32-1:0] instr1, instr2;
wire [32-1:0] ReadData12, ReadData22, ReadData13, ReadData23, ReadData24;
wire [32-1:0] DM_ReadData4, DM_ReadData5;
wire [32-1:0] signextend2, signextend3;
wire [32-1:0] ALUResult3, ALUResult4, ALUResult5;

wire [32-1:0] PC_add11, PC_add12, PC_add13;
wire [32-1:0] PC_add23, PC_add24;

wire [1:0] WB2, WB3, WB4, WB5; //RegWrite, MemtoReg
wire [2:0] M2, M3, M4; //Branch, MemRead, MemWrite
wire [4:0] EX2, EX3; //RegDst, ALUop[2:0], ALUsrc

wire [4:0] reg_add1, reg_add2; 
wire [4:0] WriteReg_addr3, WriteReg_addr4, WriteReg_addr5; 

wire zero3, zero4;


wire [32-1:0] PC_i, PC_o, WriteData;

wire [32-1:0]zerofilled, ALUinput2, ShifterResult;
wire [5-1:0] WriteReg_addr, Shifter_shamt;
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOP;
wire [2-1:0] FURslt;
wire [2-1:0] RegDst, MemtoReg;
wire RegWrite, ALUSrc, overflow;
wire Jump, Branch, BranchType, MemWrite, MemRead, BranchResult, PCSrc;
wire [32-1:0] PC_no_jump, PC_t, Mux3_result, DM_ReadData;



assign PCSrc =0;

wire [32-1:0] shiftedSignExtend, shiftedJump;
wire [27:0] temp;

assign shiftedSignExtend = signextend3 << 2;
assign Jump = 0;
assign Branch = 0;
// assign shiftedSignExtend[31] = signextend[31];

// assign temp              = instr[25:0] << 2;
// assign shiftedJump       = { PC_add1[31:28], temp };

//modules
Stage1 s1(
        .clk_i(clk_i), 
        .rst_n(rst_n), 
        .iinstr(instr1), 
        .iPC_add1(PC_add11), 
        .oinstr(instr2), 
        .oPC_add1(PC_add12)
    );

Stage2 s2(
        .clk_i(clk_i), 
        .rst_n(rst_n), 
        .iWB(WB2), 
        .iM(M2), 
        .iEX(EX2), 
        .iinstr(instr2), 
        .iPC_add1(PC_add12), 
        .iReadData1(ReadData12), 
        .iReadData2(ReadData22), 
        .isignextend(signextend2), 
        .oWB(WB3), 
        .oM(M3), 
        .oEX(EX3),  
        .oi1(reg_add1), 
        .oi2(reg_add2), 
        .oPC_add1(PC_add13), 
        .oReadData1(ReadData13), 
        .oReadData2(ReadData23), 
        .osignextend(signextend3)
    );

Stage3 s3(
        .clk_i(clk_i), 
        .rst_n(rst_n), 
        .iWB(WB3), 
        .iM(M3), 
        .iPC_add2(PC_add23), 
        .izero(zero3), 
        .iALUResult(Mux3_result), 
        .iReadData2(ReadData23), 
        .iWriteReg_addr(WriteReg_addr3), 
        .oWB(WB4), 
        .oM(M4), 
        .oPC_add2(PC_add24), 
        .ozero(zero4), 
        .oALUResult(ALUResult4), 
        .oReadData2(ReadData24), 
        .oWriteReg_addr(WriteReg_addr4)
    );

Stage4 s4(
        .clk_i(clk_i), 
        .rst_n(rst_n), 
        .iWB(WB4), 
        .iDM_ReadData(DM_ReadData4), 
        .iALUResult(ALUResult4), 
        .iWriteReg_addr(WriteReg_addr4), 
        .oWB(WB5), 
        .oDM_ReadData(DM_ReadData5), 
        .oALUResult(ALUResult5), 
        .oWriteReg_addr(WriteReg_addr5)
    );


Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(PC_i) ,   
	    .pc_out_o(PC_o) 
	);
	
Instr_Memory IM(
        .pc_addr_i(PC_o),  // FIXME
	    .instr_o(instr1)    
	);

Sign_Extend SE(
        .data_i(instr2[15:0]),
        .data_o(signextend2)
    );


Adder Adder1(
        .src1_i(PC_o),     
	    .src2_i(32'd4),
	    .sum_o(PC_add11)    
	);

Adder Adder2(
        .src1_i(PC_add13),     
	    .src2_i(shiftedSignExtend), // FIXME 
	    .sum_o(PC_add23)    
	);
	

Mux2to1 #(.size(5)) Mux_Write_Reg (
        .data0_i(reg_add1),
        .data1_i(reg_add2),
        .select_i(EX3[4]),
        .data_o(WriteReg_addr3)
     );	
		
Mux2to1 #(.size(32)) ALU_Src (
        .data0_i(ReadData23),
        .data1_i(signextend3),
        .select_i(EX3[0]),
        .data_o(ALUinput2)
    );	

Mux2to1 #(.size(1)) beqbne (
        .data0_i(zero4),
        .data1_i(~zero4),
        .select_i(BranchType),
        .data_o(BranchResult)
    );		

Mux2to1 #(.size(32)) ifBranch (
        .data0_i(PC_add11),
        .data1_i(PC_add24),
        .select_i(PCSrc),
        .data_o(PC_no_jump)
    );		

Mux2to1 #(.size(32)) PC_in (
        .data0_i(PC_no_jump),
        .data1_i(shiftedJump),
        .select_i(Jump),
        .data_o(PC_i)
    );		


Mux2to1 #(.size(32)) ALUorMEMtoREG (
        .data0_i(ALUResult5),
        .data1_i(DM_ReadData5),
        .select_i(WB5[0]),
        .data_o(WriteData)
    );		    
	
Reg_File RF (
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr2[25:21]) ,  
        .RTaddr_i(instr2[20:16]) ,  
        // .Wrtaddr_i(WriteReg_addr5),
        // .Wrtdata_i(WriteData)  ,    
        .Wrtaddr_i(WriteReg_addr5),
        .Wrtdata_i(WriteData)  ,    
        .RegWrite_i(WB5[1]),
        .RSdata_o(ReadData12) ,  
        .RTdata_o(ReadData22)   
    );
	

Decoder Decoder ( 
        .instr_op_i(instr2[31:26]), 
        .WB_o(WB2),	
        .M_o(M2), 
        .EX_o(EX2)
    );


ALU_Ctrl AC(
        .funct_i(signextend3[5:0]),   
        .ALUOp_i(EX3[3:1]),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt)
    );
	

Zero_Filled ZF(
        .data_i(instr2[15:0]),
        .data_o(zerofilled)
    );

ALU ALU(
	    .aluSrc1(ReadData13),
        .aluSrc2(ALUinput2),
	    .ALU_operation_i(ALU_operation),
	    .result(ALUResult3),
        .zero(zero3),
	    .overflow(overflow)
	);
		
Shifter shifter ( 
        .result(ShifterResult),
        .leftRight(ALU_operation[0]),
        .shamt(signextend3[10:6]),
        .sftSrc(ALUinput2) 
    );
		
Mux3to1 #(.size(32)) RDdata_Source (
        .data0_i(ALUResult3),
        .data1_i(ShifterResult),
	    .data2_i(zerofilled),
        .select_i(FURslt),
        .data_o(Mux3_result)
    );	

Data_Memory DM ( 
        .clk_i(clk_i),
        .addr_i(ALUResult4) ,
        .data_i(ReadData24) ,
        .MemRead_i(M4[1]) ,
        .MemWrite_i(M4[0]) ,
        .data_o(DM_ReadData4)
    );

endmodule



