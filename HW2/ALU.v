

module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
  
  output wire[31:0] result;
  output wire zero = 1'b0;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;

  wire carry = 1'b0;
  
	always @(*) begin
    integer i;
    for (i = 0; i < 32; i = i + 1) begin
      ALU_1bit(.result(result[i]), .carryOut(carry), .a(aluSrc1[i]), .b(aluSrc2[i]), .invertA(invertA), .invertB(invertB), .operation(operation), .carryIn(carry), less );
      zero = zero | result[i];
      if (i == 31) begin
        
      end
    end 
    overflow <= carry;
  end


endmodule