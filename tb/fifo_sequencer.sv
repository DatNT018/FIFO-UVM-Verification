import uvm_pkg::*;

`include "uvm_macros.svh"
`include "fifo_transaction.sv"

class fifo_sequencer extends uvm_sequencer#(fifo_transaction)
	`uvm_component_utils(fifo_sequencer)

	function new(input string name="fifo_sequencer", uvm_component parent =null);
		super.new(name,parent);
	endfunction: new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info("sequencer_run","",UVM_NONE);
	endtask
endclass: fifo_sequencer
