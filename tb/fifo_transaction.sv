import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter_def.sv"

class fifo_transaction extends uvm_sequence_item;
	rand bit wr_en;
	rand bit rd_en;
	rand bit [FIFO_WIDTH -1:0] wr_data;
	bit [FIFO_WIDTH -1:0] rd_data;
	bit fifo_full;
	bit fifo_empty;


	constraint c_indata{wr_data inside{[0:25]};}
	constraint ctrl{soft rd_en inside {0,1}; wr_en inside {0,1};}

	`uvm_object_utils_begin(fifo_transaction)
	`uvm_field_int(rd_en, UVM_ALL_ON)
	`uvm_field_int(wr_en, UVM_ALL_ON)
	`uvm_field_int(rd_data, UVM_ALL_ON)
	`uvm_field_int(wr_data, UVM_ALL_ON)
	`uvm_field_int(fifo_full, UVM_ALL_ON)
	`uvm_field_int(fifo_empty, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="fifo_transaction");
		super.new(name);
	endfunction
endclass


	
