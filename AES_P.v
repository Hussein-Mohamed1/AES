module AES_P( e128, d128, segIn_1, segIn_2, segIn_3, segOut_1, segOut_2, segOut_3, clk );

output wire e128;
output wire d128;
input clk;
output [6:0] segIn_1, segIn_2, segIn_3;
output [6:0] segOut_1, segOut_2, segOut_3;
reg en;
// The plain text used as input
wire[127:0] in = 128'h_00112233445566778899aabbccddeeff;

// The different keys used for testing (one of each type)
wire[127:0] key128 = 128'h_000102030405060708090a0b0c0d0e0f;
//wire[191:0] key192 = 192'h_000102030405060708090a0b0c0d0e0f1011121314151617;
//wire[255:0] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

// The expected outputs from the encryption module
wire[127:0] expected128 = 128'h_69c4e0d86a7b0430d8cdb78070b4c55a;
//wire[127:0] expected192 = 128'h_dda97ca4864cdfe06eaf70a0ec0d7191;
//wire[127:0] expected256 = 128'h_8ea2b7ca516745bfeafc49904b496089;

// The result of the encryption module for every type
wire[127:0] encrypted128;
//wire[127:0] encrypted192;
//wire[127:0] encrypted256;

assign e128 = (encrypted128 == expected128 ) ? 1'b1 : 1'b0;
//assign e128 = (encrypted192 == expected192 && enable) ? 1'b1 : 1'b0;
//assign e128 = (encrypted256 == expected256 && enable) ? 1'b1 : 1'b0;

// The result of the decryption module for every type
reg [127:0] decrypted128;
//reg [127:0] decrypted192;
//reg [127:0] decrypted256;
//
wire [127:0] cipherOut;
wire [127:0] decipherOut;
wire [1407:0] w; 
KeyExpantion Ky(key128 , w);
Cipher a(in, w , cipherOut, clk);
reg [127:0] inputDes;
Decipher d(inputDes, w, decipherOut, clk, en);
integer i=0;
always @ (posedge clk) begin

	if (  i <= 12) begin
		decrypted128 <= cipherOut;
		en = 0;
		i = i +1;
		if(i==12) begin
		inputDes<=cipherOut;
		en = 1;
		end
		end
	else if (i < 24) begin
		decrypted128 <= decipherOut;
		i= i+1 ;
		en = 1;
end
end

assign d128 = (decrypted128 == in) ? 1'b1 : 1'b0;
//assign d192 = (decrypted192 == in && enable) ? 1'b1 : 1'b0;
//assign d128 = (decrypted256 == in && enable) ? 1'b1 : 1'b0;

convertBinToBcd Cin(in[120+:8], segIn_1, segIn_2, segIn_3);
convertBinToBcd Cout(decrypted128[120+:8], segOut_1, segOut_2, segOut_3);
always@(*) begin
$monitor("out: %h " , decrypted128);
end
endmodule
