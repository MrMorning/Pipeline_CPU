module Pipeline_EX(
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] Imm_data,
    input ALUSrc_B,
    input [2:0] ALU_Control,

    output [31:0] ALU_res
);

wire [31:0] alu_b_data = ALUSrc_B ? Imm_data : rs2_data;

ALU alu(
    .A(rs1_data),
    .B(alu_b_data),
    .ALU_op(ALU_Control),
    .res(ALU_res),
    .zero()
);

endmodule