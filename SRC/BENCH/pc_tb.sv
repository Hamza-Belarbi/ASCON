//Testbench du module d'addition de constante pc_tb.sv
//Auteur: BELARBI Hamza
`timescale 1ns/1ps

module pc_tb import ascon_pack ::*; (
);

logic[3:0] round_s;
type_state state_s,add_const_s;

pc DUT (
	.round_i(round_s),
	.state_i(state_s),
	.add_const_o(add_const_s)
);


initial begin
	state_s = {64'h0000000000000000,64'h0000000000000000,64'h0000000000000000,64'h0000000000000000,64'h0000000000000000};
	//On initialise l'entrée à 0 afin d'uniquement observer les constantes à chaque rondes.
	for (int i=0; i<12; i++)begin
		round_s=i;
		#20;
	end	
end

endmodule : pc_tb
