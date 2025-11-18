`default_nettype none
module rom16 #(parameter ADDR_BITS = 4) (
    input  wire [ADDR_BITS-1:0] addr,
    output wire [31:0] data
);
    reg [31:0] mem [0:(1<<ADDR_BITS)-1];

    initial begin
        // Encoding examples (RISC-V 32-bit little endian words)
        // We'll use:
        // mem[0] = addi x1, x0, 1
        // mem[1] = addi x1, x1, 1
        // mem[2] = addi x2, x0, 0   -- nop-ish
        // mem[3] = beq  x2, x2, -8  -- branch to mem[1] (loop)
        // The actual machine codes:
        mem[0] = 32'h00100093; // addi x1,x0,1
        mem[1] = 32'h00108093; // addi x1,x1,1
        mem[2] = 32'h00010113; // addi x2,x2,0
        mem[3] = 32'hFFE1F0E3; // beq x2,x2, -8  -> branch back to mem[1]
        // fill rest with zeros (nop)
        mem[4] = 32'h00000013;
        mem[5] = 32'h00000013;
        mem[6] = 32'h00000013;
        mem[7] = 32'h00000013;
        mem[8] = 32'h00000013;
        mem[9] = 32'h00000013;
        mem[10] = 32'h00000013;
        mem[11] = 32'h00000013;
        mem[12] = 32'h00000013;
        mem[13] = 32'h00000013;
        mem[14] = 32'h00000013;
        mem[15] = 32'h00000013;
    end

    assign data = mem[addr];

endmodule
`default_nettype wire
