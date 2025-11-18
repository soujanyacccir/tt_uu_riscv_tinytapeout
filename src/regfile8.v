`default_nettype none

module regfile8 (
    input  wire        clk,
    input  wire        reset,
    input  wire        we,
    input  wire [2:0]  ra1,
    input  wire [2:0]  ra2,
    input  wire [2:0]  wa,
    input  wire [31:0] wd,
    output wire [31:0] rd1,
    output wire [31:0] rd2
);

    reg [31:0] rf [0:7];

    // Read ports (r0 = 0)
    assign rd1 = (ra1 == 3'd0) ? 32'd0 : rf[ra1];
    assign rd2 = (ra2 == 3'd0) ? 32'd0 : rf[ra2];

    always @(posedge clk) begin
        if (reset) begin
            rf[0] <= 0;
            rf[1] <= 0;
            rf[2] <= 0;
            rf[3] <= 0;
            rf[4] <= 0;
            rf[5] <= 0;
            rf[6] <= 0;
            rf[7] <= 0;
        end
        else if (we && wa != 3'd0) begin
            rf[wa] <= wd;
        end
    end

endmodule

`default_nettype wire
