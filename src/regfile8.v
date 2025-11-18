`default_nettype none
module regfile8 (
    input  wire        clk,
    input  wire        we,
    input  wire [2:0]  ra1,
    input  wire [2:0]  ra2,
    input  wire [2:0]  wa,
    input  wire [31:0] wd,
    output wire [31:0] rd1,
    output wire [31:0] rd2
);

    reg [31:0] rf [0:7];

    // r0 is hardwired zero from read side
    assign rd1 = (ra1 == 3'd0) ? 32'd0 : rf[ra1];
    assign rd2 = (ra2 == 3'd0) ? 32'd0 : rf[ra2];

    always @(posedge clk) begin
        if (we && (wa != 3'd0)) // protect r0
            rf[wa] <= wd;
    end
endmodule
`default_nettype wire
