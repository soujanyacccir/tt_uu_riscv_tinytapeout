`default_nettype none
// tiny_core: extremely compact RV-like core for 1x1 tile
module tiny_core #(parameter ROM_ADDR_BITS = 4) (
    input  wire         clk,
    input  wire         reset,
    input  wire [7:0]   gpio_in,
    output wire [7:0]   gpio_out
);

    // program counter (32-bit)
    reg [31:0] pc;
    wire [31:0] pc_next;

    // small ROM address bits (word addressed)
    wire [ROM_ADDR_BITS-1:0] rom_addr = pc[ROM_ADDR_BITS+1:2];

    wire [31:0] instr;
    rom16 #(.ADDR_BITS(ROM_ADDR_BITS)) u_rom ( .addr(rom_addr), .data(instr) );

    // fields
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    // small regfile: 8 registers (r0..r7), r0 is hardwired zero
    wire [31:0] rd1, rd2;
    regfile8 u_rf (
        .clk(clk),
        .we(reg_we),
        .ra1(rs1[2:0]),
        .ra2(rs2[2:0]),
        .wa (rd[2:0]),
        .wd (reg_wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // immediate
    wire [31:0] imm;
    imm8 u_imm ( .instr(instr), .imm(imm) );

    // control signals (very small)
    wire alu_src_imm;
    wire reg_we;
    wire branch;
    wire [2:0] alu_op;
    control8 u_ctrl ( .instr(instr), .alu_src_imm(alu_src_imm),
                      .reg_we(reg_we), .branch(branch), .alu_op(alu_op) );

    // ALU
    wire [31:0] alu_b = alu_src_imm ? imm : rd2;
    reg  [31:0] alu_y;
    always @(*) begin
        case (alu_op)
            3'b000: alu_y = rd1 + alu_b; // ADD
            3'b001: alu_y = rd1 - alu_b; // SUB
            3'b010: alu_y = rd1 & alu_b; // AND
            3'b011: alu_y = rd1 | alu_b; // OR
            3'b100: alu_y = rd1 ^ alu_b; // XOR (if used)
            default: alu_y = 32'd0;
        endcase
    end

    // next PC: branch if branch && (rd1 == rd2)
    assign pc_next = (branch && (rd1 == rd2)) ? (pc + imm) : (pc + 4);

    // writeback: ALU result
    wire [31:0] reg_wd = alu_y;

    // pc update
    always @(posedge clk) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc_next;
    end

    // simple GPIO mapping: drive GPIO from register x1 (index 1)
    // note: regfile8 index 1 maps to RF[1]
    // present only the lower 8 bits on gpio_out
    assign gpio_out = rd1[7:0];

endmodule
`default_nettype wire
