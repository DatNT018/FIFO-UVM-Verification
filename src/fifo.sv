`include "fifo_param_pkg.svh"
`include "fifo_if.svh"

module fifo(
	input logic clk, rstn, fifo_if.fifo syn_fifo_if);
	import fifo_param_pkg::*;

	//count fifo f or e?
	logic [FIFO_ADDR - 1: 0] fifo_count;
	logic [FIFO_DEPTH -1: 0][FIFO_WIDTH -1: 0] fifo_mem;

	//read pointer and write pointer
	logic [FIFO_ADDR -1: 0] rd_ptr;
	logic [FIFO_ADDR -1: 0] wr_ptr;
	
	//f&e count flags
	assign syn_fifo_if.fifo_full = (fifo_count == FIFO_DEPTH);
	assign syn_fifo_if.fifo_empty = (fifo_cont == 0);


	always_ff @(posedge clk, negedge rstn) begin //conuter logic
		if(!rstn) begin
			fifo_count <= '0;
		end else begin
			//if fifo full n wanna write
			//if fifo empty n wanna read
			case ({syn_fifo_if.wr_en, syn_fifo_if.rd_en})
                2'b10: if (!syn_fifo_if.fifo_full)  fifo_count <= fifo_count + 1;
                2'b01: if (!syn_fifo_if.fifo_empty) fifo_count <= fifo_count - 1;
                default: fifo_count <= fifo_count;
            endcase
		end
	end

	always_ff @(posedge clk, negedge rstn) begin  // memory condition logic
		if(!rstn) begin
			fifo_mem <= '0;
			rd_ptr <= '0;
			wr_ptr <= '0;
			syn_fifo_if.rd_data <= '0;
			syn_fifo_if.wr_err <= '0;
			syn_fifo_if.rd_err <= '0;
			syn_fifo_if.fifo_full <= '0;
			syn_fifo_if.fifo_empty <= '0;
		end else begin
			//store data into fifo mem when not full
			if (syn_fifo_if.wr_en && !syn_fifo_if.fifo_full) begin
                fifo_mem[wr_ptr] <= syn_fifo_if.wr_data;
                wr_ptr <= (wr_ptr + 1) % FIFO_DEPTH;
            end else if (syn_fifo_if.wr_en && syn_fifo_if.fifo_full) begin
                syn_fifo_if.wr_err <= 1;
            end
			//read data from fifo mem when not empty
            if (syn_fifo_if.rd_en && !syn_fifo_if.fifo_empty) begin
                syn_fifo_if.rd_data <= fifo_mem[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % FIFO_DEPTH;
            end else if (syn_fifo_if.rd_en && syn_fifo_if.fifo_empty) begin
                syn_fifo_if.rd_data <= 0;
                syn_fifo_if.rd_err <= 1;
		end
	end

endmodule



