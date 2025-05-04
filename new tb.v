module testbench_row_col;

    reg clk;
    reg rst;
    wire [639:0] col_enable;
    wire [511:0] row_enable;

    // Instantiate the module
    row_col_traversal uut (
        .clk(clk),
        .rst(rst),
        .col_enable(col_enable),
        .row_enable(row_enable)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk; // 50 MHz clock (adjust as needed)
    end

    // Reset and start sequence
    initial begin
        rst = 1'b1;
        #20;
        rst = 1'b0;
        #100; // Wait a bit after reset
        # (512 * 640 * 20) ; // Simulate full readout (adjust timing)
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t, rst=%b, row_count=%d, col_count=%d, row_en=%b, col_en=%b",
                 $time, rst, uut.row_count, uut.col_count,
                 row_enable[0], col_enable[0]);
    end

endmodule
