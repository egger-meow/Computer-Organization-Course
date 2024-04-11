module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
assign ALU_operation_o = 

    (ALUOp_i == 3'b010) && (funct_i == 6'b010010) ? 4'b0010 : // add
    (ALUOp_i == 3'b010) && (funct_i == 6'b010000) ? 4'b0110 : // sub
    (ALUOp_i == 3'b010) && (funct_i == 6'b010100) ? 4'b0000 : // and
    (ALUOp_i == 3'b010) && (funct_i == 6'b010110) ? 4'b0001 : // or
    (ALUOp_i == 3'b010) && (funct_i == 6'b010101) ? 4'b1100 : // nor 
    (ALUOp_i == 3'b010) && (funct_i == 6'b100000) ? 4'b0111 : // slt
    (ALUOp_i == 3'b010) && (funct_i == 6'b000000) ? 4'b0001 : // sll
    (ALUOp_i == 3'b010) && (funct_i == 6'b000010) ? 4'b0000 : // srl

    (ALUOp_i == 3'b011) ? 4'b0010 : // addi
    (ALUOp_i == 3'b101) ? 4'b0000 : // not used
    (ALUOp_i == 3'b000) ? 4'b0010 : // lw sw 
    (ALUOp_i == 3'b001) ? 4'b0110 : // beq
    (ALUOp_i == 3'b110) ? 4'b0110 : // bne
                          4'b0010 ; // j
    


assign FURslt_o = (ALUOp_i == 3'b010) && ((funct_i == 6'b000010) || (funct_i == 6'b000000)) ? 2'b01 : 2'b00;


endmodule     
