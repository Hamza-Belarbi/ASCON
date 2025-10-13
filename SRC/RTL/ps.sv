//Module de couche de substitution ps.sv
//Auteur: Hamza BELARBI

`timescale 1ns / 1ps

module ps import ascon_pack ::*;(
	input type_state state_i,
	output type_state substitution_o
	);


genvar i;
generate
for(i=0;i<64;i++) begin:g_vari
	sbox s1(
	.sbox_i({state_i[0][i],state_i[1][i],state_i[2][i],state_i[3][i],state_i[4][i]}),
	.sbox_o({substitution_o[0][i],substitution_o[1][i],substitution_o[2][i],substitution_o[3][i],substitution_o[4][i]})
);//On applique la S_Box a chacune des colonnes   
end
endgenerate
endmodule : ps

