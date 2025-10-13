//Testbench de la permutation intermédiaire composé de xor_begin, pc->ps->pl,xor_end et le registre state
//Auteur: BELARBI Hamza

`timescale 1ns / 1ps

module permutation_inter_tb
	import ascon_pack ::*;
(
);

	logic clock_s;
	logic resetb_s;
	logic en_s;
	type_state state_i_s;
	logic [127:0] data_s;
	logic [127:0] key_s;
	logic en_xor_data_s;
	logic en_xor_begin_key_s;
	logic en_xor_lsb_s;
	logic en_xor_end_key_s;
	logic mod_s;
	logic [3:0] round_s;
	type_state state_o_s;

permutation_inter DUT (
	.resetb_i(resetb_s),
	.en_i(en_s),
	.clock_i(clock_s),
	.state_i(state_i_s),
	.data_i(data_s),
	.key_i(key_s),
	.en_xor_data_i(en_xor_data_s),
	.en_xor_begin_key_i(en_xor_begin_key_s),
	.en_xor_lsb_i(en_xor_lsb_s),
	.en_xor_end_key_i(en_xor_end_key_s),
	.mod_i(mod_s),
	.round_i(round_s),
	.state_o(state_o_s)
);

//horloge
initial begin
	clock_s=1'b0;
	forever #10 clock_s=~clock_s;
end

initial begin         
	resetb_s=1'b0;
	mod_s=1'b0;
	state_i_s={64'h00001000808c0001, 64'h6cb10ad9ca912f80, 64'h691aed630e81901f, 64'h0c4c36a20853217c, 64'h46487b3e06d9d7a8};     
	en_s=1'b1;
	round_s=4'h0;
	en_xor_data_s=1'b0;
	en_xor_begin_key_s=1'b0;
	en_xor_lsb_s=1'b0;
	en_xor_end_key_s=1'b0;
	key_s=128'h691aed630e81901f6cb10ad9ca912f80;
	data_s=128'h00000001626F42206F74206563696C41;    

	#35;
	resetb_s=1'b1;
	#20;
	mod_s=1'b1;
//Douze permutations (on a initialisé round à 0 donc on ne le fait que 11 fois)
	for(int i=1;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==10)
			en_xor_end_key_s=1'b1;//xor_end, on le lance à round=10 pour pouvoir le faire au bon front d'horloge
	end
	en_xor_end_key_s=1'b0;
	en_xor_data_s=1'b1;//xor_begin

//8 permutations
	for(int i=4;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==4) begin
			en_xor_data_s=1'b0;
			data_s=128'h704f2065726964207475657620657551;  
		end            
		if(round_s==10)
			en_xor_lsb_s=1'b1;//xor_end
	end
	en_xor_lsb_s=1'b0;
	en_xor_data_s=1'b1;//xor_begin
//8 permutations
	for(int i=4;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==4) begin
			en_xor_data_s=1'b0;
			data_s=128'h766e49206561727574614e2061747265;
		end
	end 
	en_xor_data_s=1'b1;//xor_begin
//8 permutations
	for(int i=4;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==4) begin
			en_xor_data_s=1'b0;
			data_s=128'h013f206172656e754d20746e75696e65;
		end    
	end
	en_xor_data_s=1'b1;//xor_begin
	en_xor_begin_key_s=1'b1;//xor_begin
	for(int i=0;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==0) begin
			en_xor_data_s=1'b0;
			en_xor_begin_key_s=1'b0;
		end
		if(round_s==10)
			en_xor_end_key_s=1'b1;//xor_end
	end
	en_xor_begin_key_s=1'b0;
	en_s=1'b0;
	mod_s=1'b0;
            
end
endmodule : permutation_inter_tb
