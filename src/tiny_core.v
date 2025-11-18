`default_nettype none

module tiny_core #(parameter ROM_ADDR_BITS = 4) (
    input  wire         clk,
    input  wire         reset,
    input  wire [7:0]   gpio_in,
    output wire [7:0]   gpio_out
);

    // PC
    reg [31:0] pc;
    wire [31:0] pc_next;

    wire [ROM_ADDR_BITS-1:0] rom_addr = pc[ROM_ADDR_BITS+1:2];
    wire [31:0] instr;

    // ROM
    rom16 #(.ADDR_BITS(ROM_ADDR_BITS)) u_rom (
        .addr(rom_addr),
        .data(instr)
    );

    // Instruction fields
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    // regfile signals
    wire [31:0] rd1, rd2;
    wire [31:0] reg_wd;
    wire        reg_we;

    // imm generator
    wire [31:0] imm;

    imm8 u_imm (
        .instr(instr),
        .imm(imm)
    );

    // control logic
    wire alu_src_imm;
    wire branch;
    wire [2:0] alu_op;

    control8 u_ctrl (
        .instr(instr),
        .alu_src_imm(alu_src_imm),
        .reg_we(reg_we),
        .branch(branch),
        .alu_op(alu_op)
    );

    // ALU
    wire [31:0] alu_b = alu_src_imm ? imm : rd2;
    reg  [31:0] alu_y;

    always @(*) begin
        case (alu_op)
            3'b000: alu_y = rd1 + alu_b; // ADD
            3'b001: alu_y = rd1 - alu_b; // SUB
            3'b010: alu_y = rd1 & alu_b; // AND
            3'b011: alu_y = rd1 | alu_b; // OR
            3'b100: alu_y = rd1 ^ alu_b; // XOR
            default: alu_y = 32'd0;
        endcase
    end

    assign reg_wd = alu_y;

    // -------------------------------
    // PC update
    // -------------------------------
    assign pc_next = (branch && (rd1 == rd2)) ? (pc + imm) : (pc + 4);

    always @(posedge clk) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc_next;
    end

    // -------------------------------
    // Register file (FIXED)
    // -------------------------------
    regfile8 u_rf (
        .clk   (clk),
        .reset (reset),
        .we    (reg_we),
        .ra1   (rs1[2:0]),
        .ra2   (rs2[2:0]),
        .wa    (rd[2:0]),
        .wd    (reg_wd),
        .rd1   (rd1),
        .rd2   (rd2)
    );

    // -------------------------------
    // GPIO output = lower 8 bits of rd1
    // -------------------------------
    assign gpio_out = rd1[7:0];

endmodule

`default_nettype wire
