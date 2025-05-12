// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_roic_shift_based;

    reg clk;
    reg rst;
    wire [639:0] col_enable;
    wire [511:0] row_enable;
    wire done;

    // Instantiate DUT
    roic_shift_based uut (
        .clk(clk),
        .rst(rst),
        .col_enable(col_enable),
        .row_enable(row_enable),
        .done(done)
    );

    // 10 MHz Clock → 100 ns period
    always #50 clk = ~clk;

    initial begin
        $dumpfile("roic.vcd");
        $dumpvars(0, uut);

        clk = 0;
        rst = 1;
        #200;
        rst = 0;

        // Enough time to process a few rows
        #20000000;
        $finish;
    end

endmodule
