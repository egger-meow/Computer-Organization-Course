`include "Full_adder.v"

module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;

  
  
  always @(*) begin
    if (operation[1] == 0) begin 
      if (operation[0] == 0) begin
        if (invertA && invertB) begin
          result <= ~(a & b)

        end else begin
          result <= a | b
        end

      end else begin
        if (invertA && invertB) begin
          result <= ~(a | b)

        end else begin
          result <= a & b
        end

      end
    end else begin
      if (operation[0] == 0) begin
        if (invertB) begin
          Full_adder(.sum(result), .carryOut(carryOut), .carryIn(carryIn), .input1(a), .input2(~b));

        end else begin
          Full_adder(.sum(result), .carryOut(carryOut), .carryIn(carryIn), .input1(a), .input2(b));
        end

      end else begin 
        if (invertB) begin
          Full_adder(.sum(result), .carryOut(carryOut), .carryIn(carryIn), .input1(a), .input2(~b));

        end

      end
    end
  end
  
  
endmodule