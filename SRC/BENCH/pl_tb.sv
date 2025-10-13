//Testbench du module de diffusion linéaire 
//Auteur: BELARBI Hamza

`timescale 1ns / 1ps

module pl_tb import ascon_pack ::*; (
);

type_state state_s;
type_state diffusion_s;

pl DUT(
	.state_i(state_s),
	.diffusion_o(diffusion_s)
);

initial begin
//Valeur de state tirée du sujet
//On peut vérifier l'intégrité du module pl puisqu'on connait le résultat attendu.
state_s[0]= 64'h25f7c341c45f9912; 
state_s[1]= 64'h23b794c540876856;
state_s[2]= 64'hb85451593d679610;
state_s[3]= 64'h4fafba264a9e49ba;
state_s[4]= 64'h62b54d5d460aded4;
end 
endmodule : pl_tb
