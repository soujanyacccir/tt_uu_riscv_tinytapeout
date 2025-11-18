`default_nettype none
module control8 (
    input  wire [31:0] instr,
    output reg         alu_src_imm,
    output reg         reg_we,
    output reg         branch,
    output reg [2:0]   alu_op
);

    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    always @(*) begin
        alu_src_imm = 1'b0;
        reg_we      = 1'b0;
        branch      = 1'b0;
        alu_op      = 3'b000;

        case (opcode)
            7'b0010011: begin // ADDI
                alu_src_imm = 1'b1;
                reg_we      = 1'b1;
                alu_op      = 3'b000; // ADD
            end
            7'b0110011: begin // R-type: ADD/SUB
                reg_we = 1'b1;
                case ({funct7,funct3})
                    {7'b0000000,3'b000}: alu_op = 3'b000; // ADD
                    {7'b0100000,3'b000}: alu_op = 3'b001; // SUB
                    {7'b0000000,3'b111}: alu_op = 3'b010; // AND
                    {7'b0000000,3'b110}: alu_op = 3'b011; // OR
                    default: alu_op = 3'b000;
                endcase
            end
            7'b1100011: begin // BEQ (branch)
                branch = 1'b1;
                alu_op = 3'b001; // SUB used for compare
            end
            7'b0110111: begin // LUI
                reg_we = 1'b1;
                alu_src_imm = 1'b1;
                alu_op = 3'b000; // use ADD with imm (imm holds upper immediate <<12)
            end
            default: begin
                alu_src_imm = 1'b0;
                reg_we = 1'b0;
                branch = 1'b0;
                alu_op = 3'b000;
            end
        endcase
    end
endmodule
`default_nettype wire
