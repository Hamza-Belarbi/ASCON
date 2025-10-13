`timescale 1ns / 1ps

module sbox
import ascon_pack::*; (
	input logic[4:0] sbox_i,
	output logic[4:0] sbox_o
	);
always @(sbox_i) begin:label 
	case(sbox_i)
	5'h00:begin
		sbox_o=5'h04;
	end
	5'h01:begin
		sbox_o=5'h0b;
	end
	5'h02:begin
		sbox_o=5'h1f;
	end
	5'h03:begin
		sbox_o=5'h14;
	end
	5'h04:begin
		sbox_o=5'h1a;
	end
	5'h05:begin
		sbox_o=5'h15;
	end
	5'h06:begin
		sbox_o=5'h09;
	end
	5'h07:begin	
		sbox_o=5'h02;
	end
	5'h08:begin
		sbox_o=5'h1b;
	end
	5'h09:begin
		sbox_o=5'h05;
	end
	5'h0a:begin
		sbox_o=5'h08;
	end
	5'h0b:begin
		sbox_o=5'h12;
	end
	5'h0c:begin
		sbox_o=5'h1d;
	end
	5'h0d:begin
		sbox_o=5'h03;
	end
	5'h0e:begin
		sbox_o=5'h06;
	end
	5'h0f:begin
		sbox_o=5'h1c;
	end
	5'h10:begin
		sbox_o=5'h1e;
	end
	5'h11:begin
		sbox_o=5'h13;
	end
	5'h12:begin
		sbox_o=5'h07;
	end
	5'h13:begin
		sbox_o=5'h0e;
	end
	5'h14:begin
		sbox_o=5'h00;
	end
	5'h15:begin
		sbox_o=5'h0d;
	end
	5'h16:begin
		sbox_o=5'h11;
	end
	5'h17:begin
		sbox_o=5'h18;
	end
	5'h18:begin
		sbox_o=5'h10;
	end
	5'h19:begin
		sbox_o=5'h0c;
	end
	5'h1a:begin
		sbox_o=5'h01;
	end
	5'h1b:begin
		sbox_o=5'h19;
	end
	5'h1c:begin
		sbox_o=5'h16;
	end
	5'h1d:begin
		sbox_o=5'h0a;
	end
	5'h1e:begin
		sbox_o=5'h0f;
	end
	5'h1f:begin
		sbox_o=5'h17;
	end

	default:begin
	end
	
	endcase
end:label

endmodule : sbox
