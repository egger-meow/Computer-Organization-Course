module moduleName (
    a,
    b,
    c
);

input a, b, sel;        //Gate level
output c;

    
wire bitch              //Dataflow level
assign bitch = a | b

reg c;

always@(a or b or sel) //Behavior level 
begin
    if (sel)
        c = a;
    else 
        c = b;
    case (sel)
        2b'10:  
        default: 
    endcase
end
function [3:0] min;
input    [3:0] a,b;
    ;
    
endfunction

always@( posedge ) // 0->1
always@( negedge ) // 1->0

assign Y2 = {C{}} 
endmodule
