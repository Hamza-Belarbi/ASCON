`timescale 1ns / 1ps

module sbox_tb(
);


logic[4:0] sbox_i_s;
logic[4:0] sbox_o_s;

sbox DUT(
	.sbox_i(sbox_i_s),
	.sbox_o(sbox_o_s)
);

initial begin
	sbox_i_s =5'h00;
	for (int i=0; i<32; i++) begin
		sbox_i_s=i;
		#20;
	end
end

endmodule :sbox_tb
	
