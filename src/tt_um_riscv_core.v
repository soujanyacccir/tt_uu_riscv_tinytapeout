`default_nettype none

module tt_um_riscv_core (
    // Dedicated Inputs (8 pins)
    input  wire [7:0] ui_in,

    // Dedicated Outputs (8 pins)
    output wire [7:0] uo_out,

    // Bidirectional (unused)
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    // Always-1 enable
    input  wire       ena,

    // 50 MHz clock
    input  wire       clk,

    // Active-low reset
    input  wire       rst_n
);

    // active-high reset inside core
    wire reset = ~rst_n;

    // small GPIO interface
    wire [7:0] gpio_in  = ui_in;
    wire [7:0] gpio_out;

    assign uo_out = gpio_out;

    // tie off unused bidir
    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;
    // avoid unused warnings
    wire _unused = &{uio_in, ena, 1'b0};

    // instantiate the tiny core
    tiny_core #(
        .ROM_ADDR_BITS(4)  // 16-word ROM
    ) core_i (
        .clk     (clk),
        .reset   (reset),
        .gpio_in (gpio_in),
        .gpio_out(gpio_out)
    );

endmodule

`default_nettype wire
