// Code your testbench here
// or browse Examples
`timescale 1us/1ns  // 1 µs resolution

module tb_row_col_traversal;

    reg clk, rst;
    wire [8:0] col_enable;
    wire [8:0] row_enable;

    row_col_traversal uut (
        .clk(clk),
        .rst(rst),
        .col_enable(col_enable),
        .row_enable(row_enable)
    );

    // Generate 1 MHz clock (1 µs period)
    always #0.5 clk = ~clk;

    initial begin
        // VCD waveform generation (for GTKWave or Cadence)
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_row_col_traversal);

        clk = 0;
        rst = 1;
        #5;   // 5 µs reset
        rst = 0;

        // Run for some time
        #2000;  // Simulate 10 ms
        $finish;
    end

endmodule
