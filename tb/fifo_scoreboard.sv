import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_transaction.sv"

class fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(fifo_scoreboard) 

	uvm_tlm_analysis_fifo#(fifo_transaction) mon2scor;

	bit [31:0] wmem[$];
	bit [31:0] rmem[$];
	bit [31:0] data;

	function new(string name = "fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon2scor = new("mon2scor", this);
	endfunction

	task run_phase(uvm_phase phase);
		fifo_transaction trans;
		forever begin
			mon2scor.get(trans);
			if(trans.wr_en ==1 && !trans.fifo_full) begin
				wmem.push_back(trans.wr_data);
			end

			if (trans.rd_en == 1 && !trans.fifo_empty) begin
				rmem.push_back(trans.rd_data);
				if (!wmem.empty()) begin
					data = wmem.pop_front();
					if (data == trans.rd_data) begin
						`uvm_info("SCOREBOARD_PASSED", $sformatf("rd_data = %0d", trans.rd_data), UVM_LOW);
				end else begin
					`uvm_error("SCOREBOARD_FAILED", $sformatf("Expected = %0d, Got = %0d", data, trans.rd_data));
				end		
			end	

		end
	endtask
endclass
