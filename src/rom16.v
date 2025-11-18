`default_nettype none
module rom16 #(parameter ADDR_BITS = 4) (
    input  wire [ADDR_BITS-1:0] addr,
    output reg  [31:0] data
);
    // small register-based ROM (no inferred RAM)
    reg [31:0] rom [0:(1<<ADDR_BITS)-1];

    initial begin
        rom[0]  = 32'h00100093; // addi x1,x0,1
        rom[1]  = 32'h00108093; // addi x1,x1,1
        rom[2]  = 32'h00010113; // addi x2,x2,0
        rom[3]  = 32'hFFE1F0E3; // beq x2,x2,-8 -> loop
        // rest as NOPs
        rom[4]  = 32'h00000013;
        rom[5]  = 32'h00000013;
        rom[6]  = 32'h00000013;
        rom[7]  = 32'h00000013;
        rom[8]  = 32'h00000013;
        rom[9]  = 32'h00000013;
        rom[10] = 32'h00000013;
        rom[11] = 32'h00000013;
        rom[12] = 32'h00000013;
        rom[13] = 32'h00000013;
        rom[14] = 32'h00000013;
        rom[15] = 32'h00000013;
    end

    always @(*) begin
        data = rom[addr];
    end
endmodule
`default_nettype wire
