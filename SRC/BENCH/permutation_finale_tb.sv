//Testbench de la permutation finale
//Auteur: BELARBI Hamza 
`timescale 1ns / 1ps

module permutation_finale_tb
    import ascon_pack ::*;
(
);

logic clock_s; 
logic resetb_s;
logic en_s;
type_state state_s;
logic en_cipher_s;
logic en_tag_s;
logic [127:0] nonce_s;
logic [127:0] data_s;
logic [127:0] key_s;
logic en_xor_data_s;
logic en_xor_begin_key_s;
logic en_xor_lsb_s;
logic en_xor_end_key_s;
logic input_mod_s;
logic [3:0] round_s;
logic [127:0] cipher_s;
logic [127:0] tag_s;


permutation_finale DUT (
    .resetb_i(resetb_s),
    .en_i(en_s),
    .nonce_i(nonce_s),
    .en_cipher_i(en_cipher_s),
    .en_tag_i(en_tag_s),
    .clock_i(clock_s),
    .data_i(data_s),
    .key_i(key_s),
    .en_xor_data_i(en_xor_data_s),
    .en_xor_begin_key_i(en_xor_begin_key_s),
    .en_xor_lsb_i(en_xor_lsb_s),
    .en_xor_end_key_i(en_xor_end_key_s),
    .input_mod_i(input_mod_s),
    .round_i(round_s),
    .cipher_o(cipher_s),
    .tag_o(tag_s)
);

// Le testbench est quasiment identique on permet juste aux registres de mémoriser cipher et tag à certains moments
initial begin
    clock_s=1'b0;
    forever #10 clock_s=~clock_s;
end

initial begin         
	resetb_s=1'b0;
	input_mod_s=1'b0;   
	en_s=1'b1;
	en_cipher_s=1'b0;
	en_tag_s=1'b0;
	round_s=4'h0;
	en_xor_data_s=1'b0;
	en_xor_begin_key_s=1'b0;
	en_xor_lsb_s=1'b0;
	en_xor_end_key_s=1'b0;
	nonce_s=128'h46487B3E06D9D7A80C4C36A20853217C;
	key_s=128'h691aed630e81901f6cb10ad9ca912f80;
	data_s=128'h00000001626F42206F74206563696C41;
	#35;
	resetb_s=1'b1;
	#20;
	input_mod_s=1'b1;
	for(int i=1;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==10)
			en_xor_end_key_s=1'b1;
	end
	en_xor_end_key_s=1'b0;
	en_xor_data_s=1'b1;
	for(int i=4;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==4) begin
			en_xor_data_s=1'b0;
			data_s=128'h704f2065726964207475657620657551;  
		end            
		if(round_s==10)
			en_xor_lsb_s=1'b1;
	end
	en_xor_lsb_s=1'b0;
	en_xor_data_s=1'b1;
	en_cipher_s=1'b1;// C1 
	for(int i=4;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==4) begin
			en_xor_data_s=1'b0;
			en_cipher_s=1'b0;
			data_s=128'h766e49206561727574614e2061747265;
		end
	end
	en_xor_data_s=1'b1;
	en_cipher_s=1'b1;//C2
	for(int i=4;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==4) begin
			en_xor_data_s=1'b0;
			en_cipher_s=1'b0;
			data_s=128'h013f206172656e754d20746e75696e65;
		end    
	end
	en_xor_data_s=1'b1;
	en_cipher_s=1'b1;//C3
	en_xor_begin_key_s=1'b1;
	for(int i=0;i<12;i++) begin
		round_s=i;
		#20;
		if(round_s==0) begin
			en_xor_data_s=1'b0;
			en_cipher_s=1'b0;
			en_xor_begin_key_s=1'b0;
		end
		if(round_s==10) begin            
			en_xor_end_key_s=1'b1;
			en_tag_s=1'b1;//Tag
		end
	end
	en_xor_begin_key_s=1'b0;
	en_tag_s=1'b0;
	en_s=1'b0;
	input_mod_s=1'b0;
            
end
endmodule : permutation_finale_tb
