module Cipher#(parameter N=128,parameter Nr=10,parameter Nk=4)(in, word, out,clk , en, set1, set2);
input [127:0] in;
input [128*(Nr+1)-1:0] word; 
input clk;
output reg [127:0] out;
input en, set1, set2;

reg [127:0] currentState;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] firstRound;
wire [127:0] midRounds;
wire [127:0] FinalOut2;

integer i = 0;

addRoundKey addrk1 (in,firstRound,word[((128*(Nr+1))-1)-:128]);

encryptRound er(currentState, word[(((128*(Nr+1))-1)-128*i)-:128] ,midRounds);

subBytes sb(currentState, afterSubBytes);
shiftRows sr(afterSubBytes, afterShiftRows);

addRoundKey addrk2(afterShiftRows, FinalOut2, word[127:0]);

always@(posedge clk) begin
	
	if (set1 == 1 && set2 == 1) begin
		i = 0;
	end
	
	if(en == 0) begin
		if (i <= Nr) begin
		if (i == 0 && firstRound !== 'bx) begin
			currentState <= firstRound;
			out <= firstRound;
			i = i + 1;
		end

		else if (i < Nr && midRounds !== 'bx) begin
			currentState <= midRounds;
			out <= midRounds;
			i = i + 1;
		end

		else if (i == Nr && midRounds !== 'bx) begin
			out <= FinalOut2;
		end
		
		end
	end
end

endmodule

/*
module encryptLast(in,key,out);
input [127:0] in;
output [127:0] out;
input [127:0] key;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] afterMixColumns;
wire [127:0] afterAddroundKey;

subBytes s(in,afterSubBytes);
shiftRows r(afterSubBytes,afterShiftRows);
addRoundKey b(afterMixColumns,out,key);
		
endmodule
*/