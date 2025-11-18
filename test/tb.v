`default_nettype none
module tb();
    reg clk = 0;
    reg rst_n = 0;
    reg [7:0] ui_in = 8'h00;
    wire [7:0] uo_out;

    // 50 MHz -> 20 ns period; for simulation, use 20ns to match doc
    always #10 clk = ~clk;

    tt_um_riscv_core dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(8'h00),
        .uio_out(),
        .uio_oe(),
        .ena(1'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        // reset pulse (active low)
        rst_n = 0;
        #200;
        rst_n = 1;
        #20000;
        $finish;
    end
endmodule
