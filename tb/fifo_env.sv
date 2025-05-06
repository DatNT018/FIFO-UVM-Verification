import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_agent.sv"
`include "fifo_subscriber.sv"
`include "fifo_scoreboard.sv"
`include "fifo_transaction.sv"

class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)

	fifo_agent agt;
	fifo_predictor pred;
	fifo_comparator comp;

	function new(string name="fifo_env", uvm_component parent);
		super.new(name,parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		agt = fifo_agent::type_id::create("fifo_agent", this);
		pred = fifo_predictor::type_id::create("fifo_predictor",this);
		comp = fifo_comparator::type_id::create("fifo_comparator", this);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase);
		agt.mon.stimulus_in_ap.connect(pred.analysis_export);
		pred.analysis_export.connect(comp.expected_export_imp);
		agt.mon.result_ap.connect(comp.actual_export_imp);
	endfunction: connect_phase
endclass: fifo_env
