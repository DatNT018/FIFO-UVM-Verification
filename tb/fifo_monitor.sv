import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_transaction.sv"
`include "fifo_if.svh"

class fifo_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_monitor)

	uvm_analysis_port #(fifo_transaction) mon2scor;
	virtual fifo_if ffif;

	function new(string name ="fifo_monitor", uvm_component parent);
		super.new(name, parent);
		mon2scor = new("mon_ap", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(virtual fifo_if)::get(this, "", "ffif", ffif)) begin
			`uvm_fatal("MONITOR_CONNECTION", "Could not get interface from uvm_agt")
		end else begin
			`uvm_info("MONITOR_CONNECTION","",UVM_NONE);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			fifo_transaction ff_tx;
			@(ffif.monitor_ck);
			ff_tx = fifo_transaction::type_id::create("ff_tx",this);
			ff_tx.wr_en      = ffif.monitor_ck.wr_en;
			ff_tx.rd_en      = ffif.monitor_ck.rd_en;
			ff_tx.fifo_full  = ffif.monitor_ck.fifo_full;
			ff_tx.fifo_empty = ffif.monitor_ck.fifo_empty;
			ff_tx.wr_data    = ffif.monitor_ck.wr_data;
			ff_tx.rd_data    = ffif.monitor_ck.rd_data;

			
			mon2scor.write(ff_tx);
			`uvm_info("Monitor_to_scoreboard_sent","",UVM_NONE);
		end                                    
	endtask: run_phase
endclass: fifo_monitor

	
