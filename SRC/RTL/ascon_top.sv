`timescale 1 ns / 1 ps

module ascon_top import ascon_pack::*;
(
	input logic clock_i,
	input logic resetb_i,
	input logic start_i,
	input logic [127:0] key_i,
	input logic [127:0] nonce_i,
	input logic [127:0] data_i,
	input logic data_valid_i,
	output logic cipher_valid_o,
	output logic [127:0] cipher_o,
	output logic end_o,
	output logic end_init_o,
	output logic end_associated_o,
	output logic end_cipher_o,
	output logic [127:0] tag_o
    
);

logic [3:0] round_s;
logic end_s;
logic end_init_s;
logic end_associated_s;
logic cipher_valid_s;
logic end_cipher_s;
logic en_cpt_s;
logic init_a_s;
logic init_b_s;
logic en_xor_begin_key_s;
logic en_xor_data_s;
logic en_xor_end_key_s;
logic en_xor_lsb_s;
logic input_mod_s;
logic en_tag_s;
logic en_cipher_s;
logic en_reg_state_s;

assign end_o = end_s;
assign end_init_o = end_init_s;
assign end_associated_o = end_associated_s;
assign cipher_valid_o = cipher_valid_s;
assign end_cipher_o = end_cipher_s;


fsm machine(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.round_i(round_s),
	.start_i(start_i),
	.data_valid_i(data_valid_i),

	.end_o(end_s),
	.end_init_o(end_init_s),
	.end_associate_o(end_associated_s),
	.cipher_valid_o(cipher_valid_s),
	.end_cipher_o(end_cipher_s),
	.en_cpt_o(en_cpt_s),
	.init_a_o(init_a_s),
	.init_b_o(init_b_s),
	.en_xor_begin_key_o(en_xor_begin_key_s),
	.en_xor_data_o(en_xor_data_s),
	.en_xor_end_key_o(en_xor_end_key_s),
	.en_xor_lsb_o(en_xor_lsb_s),
	.input_mod_o(input_mod_s),
	.en_tag_o(en_tag_s),
	.en_cipher_o(en_cipher_s),
	.en_reg_state_o(en_reg_state_s)

);

permutation_finale perm(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.en_i(en_reg_state_s),
	.nonce_i(nonce_i),
	.data_i(data_i),
	.key_i(key_i),
	.en_xor_data_i(en_xor_data_s),
	.en_xor_begin_key_i(en_xor_begin_key_s),
	.en_xor_lsb_i(en_xor_lsb_s),
	.en_xor_end_key_i(en_xor_end_key_s),
	.input_mod_i(input_mod_s),
	.round_i(round_s),
	.en_cipher_i(en_cipher_s),
	.en_tag_i(en_tag_s),
	.cipher_o(cipher_o),
	.tag_o(tag_o)

);

compteur_double_init compteur(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.en_i(en_cpt_s),
	.init_a_i(init_a_s),
	.init_b_i(init_b_s),
	.cpt_o(round_s)  
); 

endmodule : ascon_top
