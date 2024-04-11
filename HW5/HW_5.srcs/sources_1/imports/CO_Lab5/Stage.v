

module Stage1 (clk_i, rst_n, iinstr, iPC_add1, oinstr, oPC_add1);
  
    input clk_i, rst_n;

    input  [32-1:0] iinstr;
    input  [32-1:0] iPC_add1;

    reg [32-1:0] instr;
    reg [32-1:0] PC_add1;

    output reg [32-1:0] oinstr;
    output reg [32-1:0] oPC_add1;


    always @(posedge clk_i or negedge rst_n) begin

        if(~rst_n) begin
            oinstr <= 0;
            oPC_add1 <= 0;
        end
        else if(clk_i) begin
            oinstr <= iinstr;
            oPC_add1 <= iPC_add1;
        
        end

    end

endmodule

module Stage2 (clk_i, rst_n, iWB, iM, iEX, iinstr, iPC_add1, iReadData1, iReadData2, isignextend, oWB, oM, oEX,  oi1, oi2, oPC_add1, oReadData1, oReadData2, osignextend);

    input clk_i, rst_n;

    input  [1:0] iWB;
    input  [2:0] iM;
    input  [4:0] iEX;
    input  [32-1:0] iinstr;
    input  [32-1:0] iPC_add1;
    input  [32-1:0] iReadData1;
    input  [32-1:0] iReadData2;
    input  [32-1:0] isignextend;

    reg [1:0] WB; //RegWrite, MemtoReg
    reg [2:0] M; //Branch, MemRead, MemWrite
    reg [4:0] EX; //RegDst, ALUop[2:0], ALUsrc
    reg [32-1:0] instr;
    reg [32-1:0] PC_add1;
    reg [32-1:0] ReadData1;
    reg [32-1:0] ReadData2;
    reg [32-1:0] signextend;


    output reg [1:0] oWB;
    output reg [2:0] oM;
    output reg [4:0] oEX;
    output reg [4:0] oi1, oi2;
    output reg [32-1:0] oPC_add1;
    output reg [32-1:0] oReadData1;
    output reg [32-1:0] oReadData2;
    output reg [32-1:0] osignextend;


    always @(posedge clk_i or negedge rst_n ) begin
        if(~rst_n) begin
            oWB <= 0;
            oM  <= 0;
            oEX <= 0;
            oi1 <= 0;
            oi2 <= 0;
            oPC_add1 <= 0;
            oReadData1 <= 0;
            oReadData2 <= 0;
            osignextend <= 0;
        end
        else if(clk_i) begin
            oi1 <= iinstr[20:16];
            oi2 <= iinstr[15:11];

            oPC_add1 <= iPC_add1;
            oWB <= iWB;
            oM <= iM;
            oEX <= iEX;
            oReadData1 <= iReadData1;
            oReadData2 <= iReadData2;
            osignextend <= isignextend;
       
        end
    end
endmodule

module Stage3 (clk_i, rst_n, iWB, iM, iPC_add2, izero, iALUResult, iReadData2, iWriteReg_addr, oWB, oM, oPC_add2, ozero, oALUResult, oReadData2, oWriteReg_addr);

    input clk_i, rst_n;

    input  [1:0]    iWB;
    input  [2:0]    iM;
    input  [32-1:0] iPC_add2;
    input           izero;
    input  [32-1:0] iALUResult;
    input  [32-1:0] iReadData2;
    input  [5-1:0]  iWriteReg_addr;

    reg [1:0]    WB; //RegWrite, MemtoReg
    reg [2:0]    M; //Branch, MemRead, MemWrite
    reg [32-1:0] PC_add2;
    reg          zero;
    reg [32-1:0] ALUResult;
    reg [32-1:0] ReadData2;
    reg [5-1:0]  WriteReg_addr;

    output reg [1:0] oWB;
    output reg [2:0] oM;
    output reg [32-1:0] oPC_add2;
    output reg          ozero;
    output reg [32-1:0] oALUResult;
    output reg [32-1:0] oReadData2;
    output reg [5-1:0]  oWriteReg_addr;

   
    always @(posedge clk_i or negedge rst_n ) begin
        if(~rst_n) begin
            oWB <= 0;
            oM  <= 0;
            oPC_add2 <= 0;
            ozero <= 0;
            oALUResult <= 0;
            oReadData2 <= 0;
            oWriteReg_addr <= 0;
        end

        else if(clk_i) begin
            oWB <= iWB;
            oM <= iM;
            oPC_add2 <= iPC_add2;
            ozero <= izero;
            oALUResult <= iALUResult;
            oReadData2 <= iReadData2;
            oWriteReg_addr <= iWriteReg_addr;
       
        end
    end
endmodule

module Stage4 (clk_i, rst_n, iWB, iDM_ReadData, iALUResult, iWriteReg_addr, oWB, oDM_ReadData, oALUResult, oWriteReg_addr);

    input clk_i, rst_n;

    input  [1:0]    iWB;
    input  [32-1:0] iDM_ReadData;
    input  [32-1:0] iALUResult;
    input  [5-1:0]  iWriteReg_addr;

    reg [1:0]    WB; //RegWrite, MemtoReg
    reg [32-1:0] DM_ReadData;
    reg [32-1:0] ALUResult;
    reg [5-1:0]  WriteReg_addr;

    output reg [1:0]    oWB; //RegWrite, MemtoReg
    output reg [32-1:0] oDM_ReadData;
    output reg [32-1:0] oALUResult;
    output reg [5-1:0]  oWriteReg_addr;


    always @(posedge clk_i or negedge rst_n ) begin
        if(~rst_n) begin
            oWB <= 0;
            oDM_ReadData <= 0;
            oALUResult <= 0;
            oWriteReg_addr <= 0;
        end
        else if(clk_i) begin
            oWB <= iWB;
            oDM_ReadData <= iDM_ReadData;
            oALUResult <= iALUResult;
            oWriteReg_addr <= iWriteReg_addr;
        end
    end
endmodule
