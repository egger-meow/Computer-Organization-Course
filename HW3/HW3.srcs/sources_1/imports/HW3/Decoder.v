module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegDst_o;
output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
 
//Internal Signals
wire			RegDst_o;
wire			RegWrite_o;
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;



//Main function
// assign RegDst_o   = instr_op_i[5]
// assign RegWrite_o = instr_op_i[4]
// assign ALUOp_o    = instr_op_i[3:1]
// assign ALUSrc_o   = instr_op_i[0]

assign RegWrite_o = (instr_op_i == 6'b000000) || (instr_op_i == 6'b001000) ? 1 : 0;
assign RegDst_o   =  instr_op_i == 6'b000000 ? 1 : 0;
assign ALUSrc_o   =  instr_op_i == 6'b000000 ? 0 : 1;
// assign ALUOp_o    =  

assign ALUOp_o    = (instr_op_i == 6'b000000) ? 3'b100 : // not used
                    (instr_op_i == 6'b001000) ? 3'b010 : //
                                                3'b000 ;




endmodule
   