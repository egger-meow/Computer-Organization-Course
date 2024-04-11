module Shifter( result, leftRight, shamt, sftSrc  );
    
  output wire[31:0] result;

  input wire leftRight;
  input wire[4:0] shamt;
  input wire[31:0] sftSrc ;
  
  always @(*) begin
    if (leftRight == 1'b0) begin
      result = sftSrc >> 1

    end else begin
      result = sftSrc << 1
    end
  end
endmodule