//Permutation finale permutation_finale.sv
//Auteur: BELARBI Hamza

`timescale 1 ns / 1 ps

module permutation_finale import ascon_pack ::*; (
	//Entrées
	input logic clock_i,
	input logic resetb_i,
	input logic en_i,
	input logic [127:0]nonce_i,
	input logic [127:0] data_i,
	input logic [127:0] key_i,
	input logic en_xor_data_i,
	input logic en_xor_begin_key_i,
	input logic en_xor_lsb_i,
	input logic en_xor_end_key_i,
	input logic input_mod_i,
	input logic [3:0] round_i,
	input logic en_cipher_i,
	input logic en_tag_i,
	//Sorties
	output logic [127:0] cipher_o,
	output logic [127:0] tag_o
);

type_state mux_to_xor_s;
type_state xor_b_o;
type_state pc_to_ps_s;        
type_state ps_to_pl_s;
type_state pl_to_xor_e_s;
type_state xor_e_to_regstate_s;
type_state state_loop_s;
logic [127:0] cipher_s;
logic [127:0] tag_s;
type_state state_s;

//Definition de l'entrée 
assign state_s={64'h00001000808C0001,key_i[63:0],key_i[127:64],nonce_i[63:0],nonce_i[127:64]}; 

//Permutation intermédiaire défini précédemment
assign mux_to_xor_s = (input_mod_i==1)? state_loop_s:state_s;

xor_begin xor_begin0 (
	.data_i(data_i),
	.state_i(mux_to_xor_s),
	.key_i(key_i),
	.en_xor_data_i(en_xor_data_i),
	.en_xor_begin_key_i(en_xor_begin_key_i),
	.state_o(xor_b_o)
);

pc pc0 (
	.state_i(xor_b_o),
	.round_i(round_i),
	.add_const_o(pc_to_ps_s)
);

ps ps0 (
	.state_i(pc_to_ps_s),
	.substitution_o(ps_to_pl_s)
);

pl pl0 (
	.state_i(ps_to_pl_s),
	.diffusion_o(pl_to_xor_e_s)
);

xor_end xor_end0 (
	.state_i(pl_to_xor_e_s),
	.key_i(key_i),
	.en_xor_lsb_i(en_xor_lsb_i),
	.en_xor_end_key_i(en_xor_end_key_i),
	.state_o(xor_e_to_regstate_s)
);

register_w_en regstate0 (
	.data_i(xor_e_to_regstate_s),
	.en_i(en_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.data_o(state_loop_s)
); 


assign cipher_s={xor_b_o[1],xor_b_o[0]};
//Registre 128 Bits qui contiendra C1,C2 puis C3
register128 cipher(
	.data_i(cipher_s),
	.en_i(en_cipher_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.data_o(cipher_o)
);

assign tag_s={xor_e_to_regstate_s[4],xor_e_to_regstate_s[3]};

//Registre 128 Bits qui contiendra le tag
register128 tag(
	.data_i(tag_s),
	.en_i(en_tag_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.data_o(tag_o)
);


endmodule : permutation_finale
