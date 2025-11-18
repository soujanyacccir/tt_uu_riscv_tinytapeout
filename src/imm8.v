`default_nettype none
module imm8 (
    input  wire [31:0] instr,
    output reg  [31:0] imm
);
    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011: // I-type (ADDI)
                imm = {{20{instr[31]}}, instr[31:20]};
            7'b1100011: // B-type (BEQ): imm[12|10:5|4:1|11] <<1
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            7'b0110111: // LUI: imm[31:12] << 12
                imm = {instr[31:12], 12'd0};
            default:
                imm = 32'd0;
        endcase
    end
endmodule
`default_nettype wire
