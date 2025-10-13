`timescale 1ns / 1ps

module xor_begin import ascon_pack ::*;(
	input logic[127:0] data_i,key_i,
	input logic en_xor_data_i,en_xor_begin_key_i,
	input type_state state_i,
	output type_state state_o
);

    assign state_o[0] = en_xor_data_i == 1 ? state_i[0] ^ data_i[63:0]  : state_i[0];
    assign state_o[1] = en_xor_data_i == 1 ? state_i[1] ^ data_i[127:64] : state_i[1];
    assign state_o[2] = en_xor_begin_key_i == 1 ? state_i[2] ^ key_i[63:0] : state_i[2];
    assign state_o[3] = en_xor_begin_key_i == 1 ? state_i[3] ^ key_i[127:64] : state_i[3];
    assign state_o[4] = state_i[4];


endmodule : xor_begin
