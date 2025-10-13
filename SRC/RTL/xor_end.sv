`timescale 1ns / 1ps

module xor_end import ascon_pack ::*;(
	input logic en_xor_lsb_i,en_xor_end_key_i,
	input logic[127:0] key_i,
	input type_state state_i,
	output type_state state_o
);

logic [63:0] state_inter4_s;

	assign state_o[0] = state_i[0];
	assign state_o[1] = state_i[1];
	assign state_o[2] = state_i[2];
	assign state_o[3] = en_xor_end_key_i==1 ? state_i[3]^key_i[63:0]:state_i[3];
	assign state_inter4_s = state_i[4]^{en_xor_lsb_i,63'b0};
	assign state_o[4] = en_xor_end_key_i==1 ? state_inter4_s^key_i[127:64]:state_inter4_s;

endmodule : xor_end
