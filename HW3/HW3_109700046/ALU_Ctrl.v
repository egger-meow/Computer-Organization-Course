                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );
//give me money
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     //pug is perfect
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
assign ALU_operation_o = 
    (funct_i == 6'b010010) ? 4'b0010 : //add
    (funct_i == 6'b010000) ? 4'b0110 : //sub
    (funct_i == 6'b010100) ? 4'b0000 : //and
    (funct_i == 6'b010110) ? 4'b0001 : //or
    (funct_i == 6'b010101) ? 4'b1100 : //nor 
    (funct_i == 6'b100000) ? 4'b0111 : //slt
    (funct_i == 6'b000000) ? 4'b0001 : //sll
    (funct_i == 6'b000010) ? 4'b0000 :
                             4'b0010 ;

assign FURslt_o = (funct_i == 6'b000010) || (funct_i == 6'b000000) ? 2'b01 : 2'b00;


endmodule     
