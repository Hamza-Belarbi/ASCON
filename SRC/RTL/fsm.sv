//Machine d'états fsm.sv
//BELARBI Hamza

`timescale 1ns / 1ps

module fsm (
	//Entrées
	input logic clock_i,
	input logic resetb_i,
	input [3:0] round_i,
	input logic start_i,
	input logic data_valid_i,

	//Sorties
	output logic end_o,
	output logic end_init_o,
	output logic end_associate_o,
	output logic cipher_valid_o,
	output logic end_cipher_o,
	output logic en_cpt_o,
	output logic init_a_o,
	output logic init_b_o,
	output logic en_xor_begin_key_o,
	output logic en_xor_data_o,
	output logic en_xor_end_key_o,
	output logic en_xor_lsb_o,
	output logic input_mod_o,
	output logic en_tag_o,
	output logic en_cipher_o,
	output logic en_reg_state_o
);

import ascon_pack::*;

// Définition des états
typedef enum logic [4:0] {idle, conf_init, end_conf_init, init, end_init,idle_da, conf_da, end_conf_da, da, end_da,idle_tc1, conf_tc1, end_conf_tc1, tc1, end_tc1,idle_tc2, conf_tc2, end_conf_tc2, tc2, end_tc2,idle_final, conf_final, end_conf_final, finalisation, end_final, ascon_end} t_state;

// Déclaration des variables d'état
t_state etat_present;
t_state etat_futur;

// Modélisation du registre d'état
always_ff @(posedge clock_i or negedge resetb_i) begin
	if (resetb_i == 1'b0)
		etat_present <= idle;
	else
		etat_present <= etat_futur;
end

// Modélisation des transitions
always_comb begin
case (etat_present)

//Phase d'initialisation
	idle:
		if (start_i == 1'b1)
			etat_futur=conf_init;
		else
			etat_futur = idle;

	conf_init: 
		etat_futur =end_conf_init;

	end_conf_init: 
		etat_futur = init;

	init:
		if (round_i == 4'ha)
			etat_futur = end_init;
		else
			etat_futur = init;

	end_init: 
		etat_futur = idle_da;
	
//Phase de donnée associée
	idle_da:
		if (data_valid_i == 1'b0)
			etat_futur = idle_da;
		else
			etat_futur = conf_da;

	conf_da:
		etat_futur = end_conf_da;
	end_conf_da:
		etat_futur = da;

	da:
		if (round_i == 4'ha)
			etat_futur = end_da;
		else
			etat_futur = da;

	end_da: 
		etat_futur = idle_tc1;

//Phase de texte clair
	idle_tc1:
		if (data_valid_i == 1'b0)
			etat_futur = idle_tc1;
		else
			etat_futur = conf_tc1;

	conf_tc1: 
		etat_futur = end_conf_tc1;

	end_conf_tc1: 
		etat_futur = tc1;

	tc1:
		if (round_i == 4'ha)
			etat_futur = end_tc1;
		else
			etat_futur = tc1;

	end_tc1:
		etat_futur = idle_tc2;

	idle_tc2:
		if (data_valid_i == 1'b0)
			etat_futur = idle_tc2;
		else
			etat_futur = conf_tc2;

	conf_tc2:
		etat_futur = end_conf_tc2;

	end_conf_tc2: 
		etat_futur = tc2;

	tc2:
		if (round_i == 4'ha)
			etat_futur = end_tc2;
		else
			etat_futur = tc2;

	end_tc2:
		etat_futur = idle_final;

//Phase de finalisation
	idle_final:
		if (data_valid_i == 1'b0)
			etat_futur = idle_final;
		else
			etat_futur = conf_final;

	conf_final:
		etat_futur = end_conf_final;

	end_conf_final: 
		etat_futur = finalisation;

	finalisation:
		if (round_i == 4'ha)
			etat_futur = end_final;
		else
			etat_futur = finalisation;

	end_final: 
		etat_futur = ascon_end;

	ascon_end: 
		etat_futur = idle;

	default:
		 etat_futur = idle;

	endcase
end

// Modélisation des sorties
always_comb begin
case (etat_present)

	idle: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	conf_init: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b1;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	end_conf_init: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	init: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	end_init: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b1;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	idle_da: begin
		end_o=1'b0;
		end_init_o=1'b1;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	conf_da: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b1;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	end_conf_da: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b1;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	da: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	end_da: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b1;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	idle_tc1: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b1;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
        end

	conf_tc1: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b1;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	end_conf_tc1: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b1;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b1;
		en_reg_state_o=1'b1;
        end

	tc1: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	end_tc1: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	idle_tc2: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b1;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	conf_tc2: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b1;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	end_conf_tc2: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b1;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b1;
		en_reg_state_o=1'b1;
	end

	tc2: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	end_tc2: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	idle_final: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b1;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	conf_final: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b1;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	end_conf_final: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b1;
		en_xor_data_o=1'b1;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b1;
		en_reg_state_o=1'b1;
	end

	finalisation: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	end_final: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b1;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b1;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b1;
		en_tag_o=1'b1;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b1;
	end

	ascon_end: begin
		end_o=1'b1;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

	default: begin
		end_o=1'b0;
		end_init_o=1'b0;
		end_associate_o=1'b0;
		cipher_valid_o=1'b0;
		end_cipher_o=1'b0;
		en_cpt_o=1'b0;
		init_a_o=1'b0;
		init_b_o=1'b0;
		en_xor_begin_key_o=1'b0;
		en_xor_data_o=1'b0;
		en_xor_end_key_o=1'b0;
		en_xor_lsb_o=1'b0;
		input_mod_o=1'b0;
		en_tag_o=1'b0;
		en_cipher_o=1'b0;
		en_reg_state_o=1'b0;
	end

endcase
end 

endmodule : fsm



