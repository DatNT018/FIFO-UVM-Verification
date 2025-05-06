`include "fifo_param_pkg.svh"
`include "fifo_if.svh"

`timescale 1ps/1ps

module tb_fifo ();
    import fifo_param_pkg::*;

    parameter PERIOD = 10;
    logic clk = 0, nRST;

    bit [3:0] i;
    integer j;

    // Clock generation
    always #(PERIOD / 2) CLK++;

    fifo_if fifo_if();

    fifo DUT(
        .clk(clk),
        .rstn(nRST),
        .syn_fifo_if(fifo_if)
    );

    task reset_dut;
        begin
            nRST = 1'b0;
            @(posedge CLK); @(posedge CLK);
            @(negedge CLK); nRST = 1'b1;
            @(posedge CLK); @(posedge CLK);
        end
    endtask

    task print_case(input int num, input string name);
        $display("\n[Time %0t] TEST %0d: %s", $time, num, name);
    endtask

    task test1_write_2_times();
        print_case(1, "Write 2 times");
        fifo_if.wr_en = 1;
        fifo_if.wr_data = ++i;
        @(posedge clk);
        fifo_if.wr_data = ++i;
        @(posedge clk);
        fifo_if.wr_en = 0;
    endtask

    task test2_read_2_times();
        print_case(2, "Read 2 times");
        fifo_if.rd_en = 1;
        repeat(2) @(posedge clk);
        fifo_if.rd_en = 0;
    endtask

    task test3_write_read_same_time();
        print_case(3, "Write and read at the same time");
        fifo_if.wr_en = 1;
        fifo_if.rd_en = 1;
        fifo_if.wr_data = ++i;
        repeat(4) @(posedge clk);
        fifo_if.wr_en = 0;
        fifo_if.rd_en = 0;
    endtask

    task test4_write_more_than_32();
        print_case(4, "Write more than 32 times");
        fifo_if.wr_en = 1;
        for (j = 0; j < 37; ++j) begin
            fifo_if.wr_data = ++i;
            @(posedge clk);
        end
        fifo_if.wr_en = 0;
    endtask

    task test5_read_more_than_32();
        print_case(5, "Read more than 32 times");
        fifo_if.rd_en = 1;
        repeat(40) @(posedge clk);
        fifo_if.rd_en = 0;
    endtask

    initial begin
        i = 0;
        fifo_if.wr_en = 0;
        fifo_if.rd_en = 0;
        fifo_if.wr_data = 0;

        reset_dut();
        test1_write_2_times();
        test2_read_2_times();

        reset_dut();
        test3_write_read_same_time();

        reset_dut();
        test4_write_more_than_32();

        test5_read_more_than_32();

        $display("All test cases finished at time %0t", $time);
        $finish();
    end

endmodule

