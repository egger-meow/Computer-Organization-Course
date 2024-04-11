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
/*your code here*/
assign ALU_operation_o = 
        (funct_i == 6'b010010 && ALUOp_i == 3'b010) ? 4'b0010 : //add
        (funct_i == 6'b010000 && ALUOp_i == 3'b010) ? 4'b0110 :  //sub
        (funct_i == 6'b010100 && ALUOp_i == 3'b010) ? 4'b0001 :  //and
        (funct_i == 6'b010110 && ALUOp_i == 3'b010) ? 4'b0000 :  //or
        (funct_i == 6'b010101 && ALUOp_i == 3'b010) ? 4'b1101 :  //nor
        (funct_i == 6'b100000 && ALUOp_i == 3'b010) ? 4'b0111 :  //slt
        (funct_i == 6'b000000 && ALUOp_i == 3'b010) ? 4'b0001 :  //sll //拿最後一位來當成leftright判斷
        (funct_i == 6'b000010 && ALUOp_i == 3'b010) ? 4'b0000 :  //srl
        (ALUOp_i == 3'b011) ? 4'b0010 : //addi *
        (ALUOp_i == 3'b000) ? 4'b0010 : //lw,sw
        (ALUOp_i == 3'b001 || ALUOp_i == 3'b110) ? 4'b0110 : //bne
                         4'b0010 ;  //addi,srl,sll
                                 
assign FURslt_o = (funct_i == 6'b000000 && ALUOp_i == 3'b010) ? 2'b01 :      //sll
                  (funct_i == 6'b000010 && ALUOp_i == 3'b010) ? 2'b01 :      //srl
                                           2'b00 ;      //from ALU

endmodule     
