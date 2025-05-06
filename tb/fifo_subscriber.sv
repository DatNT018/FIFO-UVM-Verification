import uvm_pkg::*;

`include "uvm_macros.svh"
`include "fifo_transaction.sv"

class fifo_subscriber extends uvm_subscriber #(fifo_transaction);
	`uvm_component_utils(fifo_subscriber)

	uvm_tlm_analysis_fifo#(fifo_transaction) mon2subs;

	fifo_transaction trans;

	function new(string name = "fifo_subscriber", uvm_component parent);
		super.new(name, parent);
		fifo_cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon2subs=new("mon2subs", this);
	endfunction

	covergroup fifo_cg();
		cp1:coverpoint trans.wr_en;
		cp2:coverpoint trans.rd_en;
		cp3:coverpoint trans.fifo_full;
		cp4:coverpoint trans.fifo_empty;
		cp5:coverpoint trans.wr_data { bins b1[10] = {[0:30]}}

	endgroup

	function void write(T t);
		fifo_cg.sample();
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info("SUBSCRIBER_RUN_PHASE","",UVM_NONE);
		forever begin
			mon2subs.get(trans);
			write(trans);
		end
	endtask

	function void check_phase(uvm_phase phase);
		$display("----------------------------------------------------");
		`uvm_info("MY_CONVERAGE", $sformatf("%0f", fifo_cg.get_coverage()),UVM_NONE);
		$display("-----------------------------------------------------");
	endfunction
endclass


	