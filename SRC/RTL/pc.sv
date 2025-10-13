//Module d'addition de constante pc.sv
//Auteur : Hamza BELARBI 

`timescale 1ns/1ps

module pc import ascon_pack ::*; (
	input logic[3:0] round_i,
	input type_state state_i,
	output type_state add_const_o
);

//Ici on recopie les registres qui ne sont pas modifiés.
assign add_const_o[0]=state_i[0];
assign add_const_o[1]=state_i[1];
assign add_const_o[3]=state_i[3];
assign add_const_o[4]=state_i[4];


assign add_const_o[2][63:8]=state_i[2][63:8];//Ici on recopie les bits du registre 2 qui ne sont pas modifié.
assign add_const_o[2][7:0]=state_i[2][7:0]^round_constant[round_i];//On procède à l'addition de constante, qui est en fait un xor bit à bit entre les 8 premiers bits et la constante correspondante. 


endmodule : pc
