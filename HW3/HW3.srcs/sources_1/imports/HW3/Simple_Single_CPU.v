module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal       Signles

//program counter


wire [32-1:0] pc_out_o;

//adder
wire [32-1:0] sum_o;

//instr memory
wire [32-1:0] pc_addr_i;
wire  [32-1:0] instr_o;
assign pc_addr_i = pc_out_o;

//reg file
wire [5-1:0] RDaddr_i;
wire [32-1:0] RDdata_i;
wire [32-1:0] RSdata_o;
wire [32-1:0] RTdata_o;

//decoder
wire RegWrite_o;
wire [3-1:0] ALUOp_o  ;
wire ALUSrc_o ;  
wire RegDst_o; 

//#ALU_Ctrl
wire [2-1:0] FURslt_o;
wire [4-1:0] ALU_operation_o;

//#ALU
wire [32-1:0] aluSrc2;
wire [32-1:0] ALU_result;
wire zero;
wire overflow;

//sign extend
wire [32-1:0] sign_extend_o;

//zero fill
wire [32-1:0] zerofilled_o;


//#shifter
wire [32-1:0] shifter_result; 
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(sum_o) ,   
	    .pc_out_o(pc_out_o) 
	    );
	
Adder Adder1(
        .src1_i(pc_out_o),     
	    .src2_i(32'd4),
	    .sum_o(sum_o)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_addr_i),  
	    .instr_o(instr_o)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst_o),
        .data_o(RDaddr_i)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(RDaddr_i) ,  
        .RDdata_i(RDdata_i)  , 
        .RegWrite_i(RegWrite_o),
        .RSdata_o(RSdata_o) ,  
        .RTdata_o(RTdata_o)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALUOp_o(ALUOp_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o)   
		);

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALUOp_o),   
        .ALU_operation_o(ALU_operation_o),
		.FURslt_o(FURslt_o)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_extend_o)
        );

Zero_Filled ZF(
        .data_i(instr_o[15:0]),
        .data_o(zerofilled_o)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src (
        .data0_i(RTdata_o),
        .data1_i(sign_extend_o),
        .select_i(ALUSrc_o),
        .data_o(aluSrc2)
        );	
		
ALU ALU(
	.aluSrc1(RSdata_o),
        .aluSrc2(aluSrc2),
	.ALU_operation_i(ALU_operation_o),
	.result(ALU_result),
        .zero(zero),
	.overflow(overflow)
	);
		
Shifter shifter ( 
        .result(shifter_result), 
        .leftRight(ALU_operation_o[0]),
        .shamt(instr_o[10:6]),
        .sftSrc(aluSrc2) 
        );
		
Mux3to1 #(.size(32)) RDdata_Source (
        .data0_i(ALU_result),
        .data1_i(shifter_result),
	.data2_i(zerofilled_o),
        .select_i(FURslt_o),
        .data_o(RDdata_i)
        );			

endmodule



