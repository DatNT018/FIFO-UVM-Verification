import uvm_pkg::*;

`include "uvm_macros.svh"
`include "fifo_env.sv"
`include "fifo_sequence.sv"

class fifo_basic_test extends uvm_test;
	`uvm_component_utils(fifo_test)

	virtual fifo_if syn_fifo_if;
	fifo_env env;
	fifo_sequence seq;

	function new(string name ="fifo_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = fifo_env::type_id::create("env", this);
		seq = fifo_sequence::type_id::create("seq", this);

		if (!uvm_config_db#(virtual fifo_if)::get(this, "", "syn_fifo_if", syn_fifo_if)) begin
			`uvm_fatal(get_type_name(), "could not get handle to virtual interface")
		end
	endfunction: build_phase

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction: end_of_elaboration_phase

	virtual task run_phase (uvm_phase, phase);
		phase.raise_objection(this, "raise object for basic test");
		$display("%t run_phase of fifo_test started", $time);
		seq.start(env.agt.sqr);
		phase.drop_objection(this, "drop objection for basic test");
	endtask: run_phase

endclass
