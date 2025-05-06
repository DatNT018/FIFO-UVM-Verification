import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"


class fifo_agent extends uvm_agent;
	`uvm_component_utils(fifo_agent)
	fifo_sequencer sqr;
	fifo_driver drv;
	fifo_monitor mon;

	uvm_analysis_port#(fifo_transaction) mon2scor;

	function new(string name="fifo_agent", uvm_component parent =null);
		super.new(name, parent);
	endfunction: new
	// If Agent is Active, create Driver and Sequencer, else skip
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active()) begin
			sqr = fifo_sequencer::type_id::create("sqr", this);
			drv = fifo_driver::type_id::create("drv", this);
		end

		mon2scor = new("mon2scor", this);
		if(!uvm_config_db#(virtual fifo_if)::get(this, "", "ffif", mon.ffif)) begin
			`uvm_fatal("fifo_agent", "Could not get handle to virtual interface for monitor");
		end
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction: connect_phase

	task run_phase(uvm_phase phase);
		`uvm_info("Agent run phase","",UVM_NONE);
	endtask

endclass

