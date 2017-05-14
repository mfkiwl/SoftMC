`timescale 1ns / 1ps

module read_capturer #(parameter DQ_WIDTH = 64) (
	input clk,
	input rst,
	
	//DFI Interface
	input  [4*DQ_WIDTH-1:0] dfi_rddata,
	input                   dfi_rddata_valid,
	input							dfi_rddata_valid_even,
	input							dfi_rddata_valid_odd,
	
	//FIFO interface
	output rdback_fifo_wren,
	output[4*DQ_WIDTH-1:0] rdback_fifo_wrdata
);

	reg[4*DQ_WIDTH-1:0] rd_data_r, rd_data_r2;
	reg rd_data_en_r, rd_data_en_even_r, rd_data_en_odd_r;
	
	always@(posedge clk) begin
		if(rst) begin
			rd_data_r <= 0;
			rd_data_r2 <= 0;
			rd_data_en_r <= 0;
			rd_data_en_even_r <= 0;
			rd_data_en_odd_r <= 0;
		end
		else begin
			rd_data_r <= dfi_rddata;
			rd_data_r2 <= rd_data_r;
			rd_data_en_r <= dfi_rddata_valid;
			rd_data_en_even_r <= dfi_rddata_valid_even;
			rd_data_en_odd_r <= dfi_rddata_valid_odd;
			
		end
	end
	
	assign rdback_fifo_wren = ~rd_data_en_odd_r & rd_data_en_r; //the rd_data_en_odd_r is 1 when the read was a periodic dummy read
	assign rdback_fifo_wrdata = rd_data_en_even_r ? {rd_data_r[DQ_WIDTH*2 - 1:0], rd_data_r2[DQ_WIDTH*2 +: DQ_WIDTH*2]} : rd_data_r;
	
	
endmodule
