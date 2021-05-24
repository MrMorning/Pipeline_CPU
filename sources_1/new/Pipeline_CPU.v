`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2021 01:07:33 PM
// Design Name: 
// Module Name: Pipeline_CPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Pipeline_CPU(
        input clk,
        input rst,
        input [31:0] Data_in,
        input [31:0] inst_in,
        output wire MemRW,
        output reg [31:0] PC_out,
        output [31:0] Addr_out,
        output [31:0] Data_out
        //below are debug signals.
        
    );

    // Pipeline Stages

    ////////////////////////////////////////////////////////
    //IF: Instruction Fetch

    reg [31:0] inst_IFID;
    reg [31:0] PC_IFID;

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            PC_out <= 0; 
        end else begin
            PC_out <= PC_out + 4; 
        end
    end

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            inst_IFID <= 0;
            PC_IFID <= 0;
        end
        else begin
            inst_IFID <= inst_in;
            PC_IFID <= PC_out;
        end
    end

    ////////////////////////////////////////////////////////
    //ID: Instruction Decode

    reg [31:0] rs1_data_IDEX;
    reg [31:0] rs2_data_IDEX;
    reg [4:0] rd_addr_IDEX;
    reg [31:0] Imm_data_IDEX;
    reg ALUSrc_B_IDEX;
    reg [1:0] MemtoReg_IDEX;
    // reg Branch_IDEX;
    // reg Jump_IDEX;
    reg RegWrite_IDEX;
    reg MemRW_IDEX;
    reg [2:0] ALU_Control_IDEX;
    reg [31:0] PC_IDEX;

    wire [4:0] rs1_addr_IDEX_wire;
    wire [31:0] rs1_data_IDEX_wire;
    wire [4:0] rs2_addr_IDEX_wire;
    wire [31:0] rs2_data_IDEX_wire;
    wire [4:0] rd_addr_IDEX_wire;
    wire [31:0] Imm_data_IDEX_wire;
    wire ALUSrc_B_IDEX_wire;
    wire [1:0] MemtoReg_IDEX_wire;
    wire Branch_IDEX_wire;
    wire Jump_IDEX_wire;
    wire RegWrite_IDEX_wire;
    wire MemRW_IDEX_wire;
    wire [2:0] ALU_Control_IDEX_wire;

    Pipeline_ID ID(
        .clk(clk),
        .rst(rst),
        .inst(inst_IFID),
        
        .rs1_addr(rs1_addr_IDEX_wire),
        .rs2_addr(rs2_addr_IDEX_wire),
        .rd_addr(rd_addr_IDEX_wire),
        .Imm_data(Imm_data_IDEX_wire),

        .ALUSrc_B(ALUSrc_B_IDEX_wire),
        .MemtoReg(MemtoReg_IDEX_wire),
        .Branch(Branch_IDEX_wire),
        .Jump(Jump_IDEX_wire),
        .RegWrite(RegWrite_IDEX_wire),
        .MemRW(MemRW_IDEX_wire),
        .ALU_Control(ALU_Control_IDEX_wire)
    );

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            rs1_data_IDEX <= 0;
            rs2_data_IDEX <= 0;
            rd_addr_IDEX <= 0;
            Imm_data_IDEX <= 0;
            ALUSrc_B_IDEX <= 0;
            MemtoReg_IDEX <= 0;
            RegWrite_IDEX <= 0;
            MemRW_IDEX <= 0;
            ALU_Control_IDEX <= 0;
            PC_IDEX <= 0;
        end else begin
            rs1_data_IDEX <= rs1_data_IDEX_wire;
            rs2_data_IDEX <= rs2_data_IDEX_wire;
            rd_addr_IDEX <= rd_addr_IDEX_wire;
            Imm_data_IDEX <= Imm_data_IDEX_wire;
            ALUSrc_B_IDEX <= ALUSrc_B_IDEX_wire;
            MemtoReg_IDEX <= MemtoReg_IDEX_wire;
            RegWrite_IDEX <= RegWrite_IDEX_wire;
            MemRW_IDEX <= MemRW_IDEX_wire;
            ALU_Control_IDEX <= ALU_Control_IDEX_wire;
            PC_IDEX <= PC_IFID;
        end
    end

    ////////////////////////////////////////////////////////
    //EX: Execution

    reg [4:0] rd_addr_EXMEM;
    reg [1:0] MemtoReg_EXMEM;
    reg RegWrite_EXMEM;
    reg MemRW_EXMEM;
    reg [31:0] PC_EXMEM;
    reg [31:0] ALU_res_EXMEM;
    reg [31:0] rs2_data_EXMEM;

    wire [31:0] ALU_res_EXMEM_wire;

    Pipeline_EX EX(
        .rs1_data(rs1_data_IDEX),
        .rs2_data(rs2_data_IDEX),
        .Imm_data(Imm_data_IDEX),
        .ALUSrc_B(ALUSrc_B_IDEX),
        .ALU_Control(ALU_Control_IDEX),

        .ALU_res(ALU_res_EXMEM_wire)
    );

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            rd_addr_EXMEM <= 0;
            MemtoReg_EXMEM <= 0;
            RegWrite_EXMEM <= 0;
            MemRW_EXMEM <= 0;
            PC_EXMEM <= 0;
            ALU_res_EXMEM <= 0;
            rs2_data_EXMEM <= 0;
        end
        else begin
            rd_addr_EXMEM <= rd_addr_IDEX;
            MemtoReg_EXMEM <= MemtoReg_IDEX;
            RegWrite_EXMEM <= RegWrite_IDEX;
            MemRW_EXMEM <= MemRW_IDEX;
            PC_EXMEM <= PC_IDEX;
            ALU_res_EXMEM <= ALU_res_EXMEM_wire;
            rs2_data_EXMEM <= rs2_data_IDEX;
        end
    end

    ////////////////////////////////////////////////////////
    //MEM: Access Memory

    assign Addr_out = ALU_res_EXMEM;
    assign Data_out = rs2_data_EXMEM;
    assign MemRW = MemRW_EXMEM;

    reg [4:0] rd_addr_MEMWB;
    reg [1:0] MemtoReg_MEMWB;
    reg RegWrite_MEMWB;
    reg [31:0] PC_MEMWB;
    reg [31:0] ALU_res_MEMWB;
    reg [31:0] Mem_res_MEMWB;

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            rd_addr_MEMWB <= 0;
            MemtoReg_MEMWB <= 0;
            RegWrite_MEMWB <= 0;
            PC_MEMWB <= 0;
            ALU_res_MEMWB <= 0;
            Mem_res_MEMWB <= 0;
        end
        else begin
            rd_addr_MEMWB <= rd_addr_EXMEM;
            MemtoReg_MEMWB <= MemtoReg_EXMEM;
            RegWrite_MEMWB <= RegWrite_EXMEM;
            PC_MEMWB <= PC_EXMEM;
            ALU_res_MEMWB <= ALU_res_EXMEM;
            Mem_res_MEMWB <= Data_in;
        end
    end
    

    ////////////////////////////////////////////////////////
    //WB: Write Back

    wire [31:0] wb_data;

    Pipeline_WB WB(
        .ALU_res(ALU_res_MEMWB),
        .Mem_res(Mem_res_MEMWB),
        .PC(PC_MEMWB),
        .MemtoReg(MemtoReg_MEMWB),
        .wb_data(wb_data)
    );



    // end Pipeline Stages

    // Regs

    regs regfile(
        .clk(~clk),
        .rst(rst),
        .RegWrite(RegWrite_MEMWB),
        .Rs1_addr(rs1_addr_IDEX_wire),
        .Rs2_addr(rs2_addr_IDEX_wire),
        .Wt_addr(rd_addr_MEMWB),
        .Wt_data(wb_data),
        .Rs1_data(rs1_data_IDEX_wire),
        .Rs2_data(rs2_data_IDEX_wire)
    );

    // end Regs

    // IO configuration


    // end IO configuration

endmodule
