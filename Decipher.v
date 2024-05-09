module Decipher#(parameter N=128,parameter Nr=10,parameter Nk=4)(in, word, out,clk , en);
input [127:0] in;
input [1407:0] word; 
input clk;
output reg [127:0] out;
input en;

reg [127:0] currentState;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] firstRound;
wire [127:0] midRounds;
wire [127:0] FinalOut2;

integer i = 0;

addRoundKey addrk1 (in,firstRound,word[127:0]);

decryptRound er(currentState, word[i*128+:128] ,midRounds);

inv_subByte sb(currentState, afterSubBytes);
inverseShiftRows sr(afterSubBytes, afterShiftRows);

addRoundKey addrk2(afterShiftRows, FinalOut2, word[((128*(Nr+1))-1)-:128]);



always@(posedge clk or posedge en)

	if(en==1) begin

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