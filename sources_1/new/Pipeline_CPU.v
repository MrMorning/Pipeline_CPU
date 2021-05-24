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

    reg [31:0] inst_IFID;

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
        end
        else begin
            inst_IFID <= inst_in;
        end
    end

    // end Pipeline Stages

    // Regs

    // end Regs

    // IO configuration


    // end IO configuration

endmodule
