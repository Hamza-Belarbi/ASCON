//Testbench du module de substitution ps_tb.sv
//Auteur: BELARBI Hamza

`timescale 1ns / 1ps

module ps_tb import ascon_pack ::*; (
);

type_state state_s, substitution_s;

ps DUT(
	.state_i(state_s),
	.substitution_o(substitution_s)
);

initial begin
 state_s=320'h00001000808c00016cb10ad9ca912f80691aed630e8190ef0c4c36a20853217c46487b3e06d9d7a8;
//Valeur tirée du sujet, on connait le résultat attend et de cette manière on peut vérifier l'intégrité du module.
end
endmodule:ps_tb
