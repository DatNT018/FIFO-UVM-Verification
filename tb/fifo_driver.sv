import uvm_pkg::*;
`include "uvm_macros.svh"

`include "fifo_if.svh"

class fifo_driver extends uvm_driver;
	`uvm_component_utils(fifo_driver)
	function new(string name ="fifo_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	virtual fifo_if syn_fifo_if;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_if)::get(this, "", "syn_fifo_if",syn_fifo_if)) begin
			`uvm_fatal(get_type_name(), "Could not get handle to virtual interfaces");
		end
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		fifo_transaction fifo_data;
		forever begin
			`uvm_info(get_type_name(), "waiting for data from sequencer", UVM_MEDIUM);
			seq_item_port.get_next_item(fifo_data);

			@(syn_fifo_if.driver_ck);
			syn_fifo_if.driver_ck.wr_en   <= fifo_data.wr_en;
			syn_fifo_if.driver_ck.wr_data <= fifo_data.wr_data;
			syn_fifo_if.driver_ck.rd_en   <= fifo_data.rd_en;

			seq_item_port.item_done();
		end
	endtask: run_phase
endclass



