`ifndef FIFO_IF_SVH
`define FIFO_IF_SVH

`include "fifo_param_pkg.svh"

`timescale 1ns/1ps

interface fifo_if(input bit clk);
	import fifo_param_pkg::*;

	//write logic
	//input signals
	logic wr_en; 
	logic [FIFO_WIDTH -1: 0] wr_data; //write to memory
	logic rd_en;
	logic fifo_full; //already fifo?
	logic wr_err; //full?
	logic fifo_empty;
	logic rd_err;
	logic [FIFO_WIDTH -1: 0] rd_data; //read from mem

	clocking driver_ck @(posedge clk);
		input fifo_full, fifo_empty, rd_err,wr_err, rd_data;
		output wr_en, wr_data, rd_en;
	endclocking: driver_ck

	clocking monitor_ck @(posedge clk);
		input fifo_full, wr_err, fifo_empty, rd_err, rd_data, wr_en, wr_data, rd_en;
	endclocking: monitor_ck

	modport fifo(
		output wr_en, wr_data, rd_en;
		input fifo_full, fifo_empty, rd_err, wr_err, rd_data);

endinterface

`endif

	
