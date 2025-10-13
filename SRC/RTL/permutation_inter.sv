//Module de permutation intermédiaire qui ne contient pas les registres de 128 bits du cipher et du tag 
//Auteur:BELARBI Hamza

`timescale 1ns / 1ps

module permutation_inter
    import ascon_pack ::*;
(
input logic clock_i,
input logic resetb_i,
input logic en_i,
input type_state state_i,
input logic [127:0] data_i,
input logic [127:0] key_i,
input logic en_xor_data_i,
input logic en_xor_begin_key_i,
input logic en_xor_lsb_i,
input logic en_xor_end_key_i,
input logic mod_i,
input logic [3:0] round_i,
output type_state state_o
);

type_state mux_to_xor_s;
type_state xor_b_to_pc_s;
type_state pc_to_ps_s;        
type_state ps_to_pl_s;
type_state pl_to_xor_e_s;
type_state xor_e_to_regstate_s;
type_state state_loop_s;

//Multiplexeur qui permet la répétition du bloc de permutation simple (pc->ps->pl)
assign mux_to_xor_s = (mod_i==1)? state_loop_s:state_i;


xor_begin xor_begin0 (
.data_i(data_i),
.state_i(mux_to_xor_s),
.key_i(key_i),
.en_xor_data_i(en_xor_data_i),
.en_xor_begin_key_i(en_xor_begin_key_i),
.state_o(xor_b_to_pc_s)
);

//Permutation simple 
pc pc0 (
.state_i(xor_b_to_pc_s),
.round_i(round_i),
.add_const_o(pc_to_ps_s)
);
//sortie de pc=entrée de ps
ps ps0 (
.state_i(pc_to_ps_s),
.substitution_o(ps_to_pl_s)
);
//sortie de ps=entrée de pl
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

//registre qui permet d'enregistrer les 5 registres 
register_w_en regstate0 (
.data_i(xor_e_to_regstate_s),
.en_i(en_i),
.clock_i(clock_i),
.resetb_i(resetb_i),
.data_o(state_loop_s)
);

assign state_o = state_loop_s;

endmodule : permutation_inter
