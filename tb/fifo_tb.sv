import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo.sv"
`include "fifo_if.svh"
`include "fifo_param_pkg.svh"
`include "fifo_test.sv"

`timescale 1ps/1ps

module fifo_tb;
	logic clk, rstn;

	//clock generate
	initial begin
		clk <= 0;
		forever begin
			#5 clk <= !clk;
		end
	end

	//rst generate
	initial begin
		#10 rstn <= 0;
		repeat(10) @(posedge clk);
		rstn <= 1;
	end

	fifo_if syn_fifo_if(.clk(clk));

	fifo DUT(.clk(clk), .rstn(rstn), .syn_fifo_if(syn_fifo_if));

	initial begin
		uvm_config_db#(virtual fifo_if)::set(this, "*", "syn_fifo_if", syn_fifo_if);
		run_test("fifo_basic_test");
	end
endmodule
