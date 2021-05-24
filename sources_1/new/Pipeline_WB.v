module Pipeline_WB(
    input [31:0] ALU_res,
    input [31:0] Mem_res,
    input [31:0] PC,
    input [1:0] MemtoReg,

    output reg [31:0] wb_data
);

    always @ (*) begin
        case(MemtoReg)
        2'b00: begin
            wb_data = ALU_res;
        end
        2'b01: begin
            wb_data = Mem_res;
        end
        2'b10: begin
            wb_data = PC + 4;
        end
        2'b11: begin
            wb_data = PC + 4;
        end
        endcase
    end

endmodule