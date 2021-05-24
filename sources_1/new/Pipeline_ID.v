module Pipeline_ID(
    input clk,
    input rst,
    input [31:0] inst,
    
    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [31:0] imm_data,
    

    output reg ALUSrc_B,
    output reg MemtoReg,
    output reg Branch,
    output reg Jump,
    output reg RegWrite,
    output reg MemRW,
    output reg ALU_Control,
    output reg [1:0] ImmSel
);

    reg [1:0] ALU_op;
    wire [4:0] OPcode = inst[6:2];
    wire [2:0] Fun3 = inst[14:12];
    wire Fun7 = inst[30];
    always @(*) begin
        case(OPcode)
            5'b01100: begin //R-Type
                ImmSel = 2'bxx;
                ALUSrc_B = 0;
                MemtoReg = 0;
                Jump = 0;
                Branch = 0;
                RegWrite = 1;
                MemRW = 0;
                ALU_op = 2'b10;    
            end
            5'b00100: begin //I-type arithmetic & logic
                ImmSel = 2'b00;
                ALUSrc_B = 1;
                MemtoReg = 0;
                Jump = 0;
                Branch = 0;
                RegWrite = 1;
                MemRW = 0;
                ALU_op = 2'b10; 
            end
            5'b00000: begin //lw
                ImmSel = 2'b00;
                ALUSrc_B = 1;
                MemtoReg = 1;
                Jump = 0;
                Branch = 0;
                RegWrite = 1;
                MemRW = 0;
                ALU_op = 2'b00;
            end
            5'b01000: begin //S-Type
                ImmSel = 2'b01;
                ALUSrc_B = 1;
                MemtoReg = 2'bxx;
                Jump = 0;
                Branch = 0;
                RegWrite = 0;
                MemRW = 1;
                ALU_op = 2'b00; 
            end
            5'b11000: begin //B-Type
                ImmSel = 2'b10;
                ALUSrc_B = 0;
                MemtoReg = 2'bxx;
                Jump = 0;
                Branch = 1;
                RegWrite = 0;
                MemRW = 0;
                ALU_op = 2'b01;
            end
            5'b11011: begin //J-Type
                ImmSel = 2'b11;
                ALUSrc_B = 1'bx;
                MemtoReg = 2'b10;
                Jump = 1;
                Branch = 0;
                RegWrite = 1;
                MemRW = 0;
                ALU_op = 2'b00;
            end
            default: begin
                ImmSel = 2'bxx;
                ALUSrc_B = 1'bx;
                MemtoReg = 2'bxx;
                Jump = 1'bx;
                Branch = 1'bx;
                RegWrite = 1'bx;
                MemRW = 1'bx;
                ALU_Control = 3'bxxx;
            end
        endcase
    end 

    always @(*) begin
        case(ALU_op)
            2'b00: begin // add
                ALU_Control = 3'b010;
            end
            2'b01: begin // sub
                ALU_Control = 3'b110;
            end
            default: begin // R-type
                case(Fun3) 
                    3'b000: begin // add
                        ALU_Control = {Fun7, 2'b10};
                    end
                    3'b010: begin
                        ALU_Control = 3'b111;
                    end
                    3'b100: begin
                        ALU_Control = 3'b011;
                    end
                    3'b101: begin
                        ALU_Control = 3'b101;
                    end
                    3'b110: begin
                        ALU_Control = 3'b001;
                    end
                    3'b111: begin
                        ALU_Control = 3'b000;
                    end
                    default: begin
                        ALU_Control = 3'b010;
                    end
                endcase 
            end
        endcase
        
    end

endmodule