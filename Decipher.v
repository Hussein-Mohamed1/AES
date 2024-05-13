module Decipher#(parameter N=128,parameter Nr=10,parameter Nk=4)(in, word, out,clk , en, set1, set2);
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

addRoundKey addrk1 (in,firstRound,word[127:0]);

decryptRound er(currentState, word[i*128+:128] ,midRounds);

inv_subByte sb(currentState, afterSubBytes);
inverseShiftRows sr(afterSubBytes, afterShiftRows);

addRoundKey addrk2(afterShiftRows, FinalOut2, word[((128*(Nr+1))-1)-:128]);

always @(posedge clk ) begin
    if (en == 1 ) begin
		if (i<=Nr) begin
        if (i == 0 && firstRound !== 'bx) begin
            currentState <= firstRound;
            out <= firstRound;
            i <= i + 1;
        end
        else if (i < Nr && midRounds !== 'bx) begin
            currentState <= midRounds;
            out <= midRounds;
            i <= i + 1;
        end
        else if (i == Nr && midRounds !== 'bx) begin
            out <= FinalOut2;
        end
        //i <= i + 1; // Increment i here
    end
    else begin
        i <= 0; // Reset i when both set1 and set2 are high
    end
	end
end





endmodule

