module AES_P( e128, d128, segIn_1, segIn_2, segIn_3, segOut_1, segOut_2, segOut_3, clk , set1, set2);

output wire e128;
output reg d128;
input clk, set1, set2;
output [6:0] segIn_1, segIn_2, segIn_3;
output [6:0] segOut_1, segOut_2, segOut_3;

reg en;

reg [127:0] decrypted;
// The plain text used as input
reg[127:0] in = 128'h_00112233445566778899aabbccddeeff;

// The different keys used for testing (one of each type)
reg[127:0] key128 = 128'h_000102030405060708090a0b0c0d0e0f;
reg[191:0] key192 = 192'h_000102030405060708090a0b0c0d0e0f1011121314151617;
reg[255:0] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

// The expected outputs from the encryption module
wire[127:0] expected128 = 128'h_69c4e0d86a7b0430d8cdb78070b4c55a;
wire[127:0] expected192 = 128'h_dda97ca4864cdfe06eaf70a0ec0d7191;
wire[127:0] expected256 = 128'h_8ea2b7ca516745bfeafc49904b496089;

// The result of the encryption module for every type
wire[127:0] encrypted128;
wire[127:0] encrypted192;
wire[127:0] encrypted256;

assign e128 = (encrypted128 == expected128 ) ? 1'b1 : 1'b0;
assign e128 = (encrypted192 == expected192) ? 1'b1 : 1'b0;
assign e128 = (encrypted256 == expected256) ? 1'b1 : 1'b0;

// The result of the decryption module for every type
reg [127:0] decrypted128;
reg [127:0] decrypted192;
reg [127:0] decrypted256;



wire [127:0] cipherOut1;
wire [127:0] cipherOut2;
wire [127:0] cipherOut3;

wire [127:0] decipherOut1;
wire [127:0] decipherOut2;
wire [127:0] decipherOut3;
// edit 
wire [127:0] inputdecipher1;
wire [127:0] inputdecipher2;
wire [127:0] inputdecipher3;
assign inputdecipher1 = cipherOut1;
assign inputdecipher2 = cipherOut2;
assign inputdecipher3 = cipherOut3;
//---------------------------------------------------------------

wire [1407:0] w1;
wire [1663:0] w2;
wire [1919:0] w3;

integer Nr = 10;
integer i = 0;
always @(*)begin
	in <= 128'h_00112233445566778899aabbccddeeff;
	if (set1 == 0 && set2 == 0) begin
		Nr <= 10;
		key128 = 128'h_000102030405060708090a0b0c0d0e0f;
		$monitor("key: %h NR: %d " , key128, Nr);
		
	end
	else if (set1 == 0 && set2 == 1) begin
		Nr <= 12;
		key192 = 192'h_000102030405060708090a0b0c0d0e0f1011121314151617;
		$monitor("key: %h NR: %d " , key192, Nr);
	end
	else if (set1 == 1 && set2 == 0) begin
		Nr <= 14;
		key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
		$monitor("key: %h NR: %d " , key256, Nr);
	end	
	else if(set1 == 1 && set2 == 1) begin
        i = 0;
		en <= 0;
	end
end


KeyExpantion #(4, 10) Ky1(key128 , w1);
KeyExpantion #(6, 12) Ky2(key192 , w2);
KeyExpantion #(8, 14) Ky3(key256 , w3);

Cipher #(128, 10, 4) a1(in, w1 , cipherOut1, clk , en, set1, set2);
Cipher #(128, 12, 6) a2(in, w2 , cipherOut2, clk , en, set1, set2);
Cipher #(128, 14, 8) a3(in, w3 , cipherOut3, clk , en, set1, set2);

reg [127:0] inputDes;

Decipher #(128, 10, 4) d1(inputdecipher1, w1, decipherOut1, clk, en, set1, set2);
Decipher #(128, 12, 6) d2(inputdecipher2, w2, decipherOut2, clk, en, set1, set2);
Decipher #(128, 14, 8) d3(inputdecipher3, w3, decipherOut3, clk, en, set1, set2);

//edit 

// always @(*) begin
			
// 	if(i == 0) begin
// 			Nr <= 14;
// 	end
// 	if (i <= Nr + 2) begin
		
// 		if (set1 == 0 && set2 == 0) begin
// 			decrypted128 <= cipherOut1;
// 			Nr <= 10;
// 		end
// 		else if (set1 == 0 && set2 == 1) begin
// 			decrypted192 <= cipherOut2;
// 			Nr <= 12;
// 		end
// 		else if (set1 == 1 && set2 == 0) begin
// 			decrypted256 <= cipherOut3;
// 			Nr <= 14;
// 		end	
// 		else begin
// 			i = -1; // i = 0;
// 		end

// 		en = 0;
		

// 		if(i == Nr + 2) begin
// 			if (set1 == 0 && set2 == 0) begin
// 				decrypted128 <= inputdecipher1;
// 				Nr <= 10;
// 			end
// 			else if (set1 == 0 && set2 == 1) begin
// 				decrypted192 <= inputdecipher2;
// 				Nr <= 12;
// 			end
// 			else if (set1 == 1 && set2 == 0) begin
// 				decrypted256 <= inputdecipher3;
// 				Nr <= 14;
// 			end
// 			else begin
// 				i = 0;
				
// 			end

// 			en = 1;
// 		end
// 	end

// 	else if (i < (2 * (Nr + 2)) ) begin

// 		if (set1 == 0 && set2 == 0) begin
// 			decrypted128 <= decipherOut1;
// 			Nr <= 10;
// 		end
// 		else if (set1 == 0 && set2 == 1) begin
// 			decrypted192 <= decipherOut2;
// 			Nr <= 12;
// 		end
// 		else if (set1 == 1 && set2 == 0) begin
// 			decrypted256 <= decipherOut3;
// 			Nr <= 14;
// 		end
// 		else begin
// 			i = -1; // i = 0;
// 		end

	
// 		en = 1;
// 	end
// end

//----------------------------------------------------------------
//edit
// always @(*) begin
// 	if(i == 0) begin
		
// 		if (set1 == 0 && set2 == 0) begin
// 			decrypted128 <= cipherOut1;
// 			Nr <= 10;
// 		end
// 		else if (set1 == 0 && set2 == 1) begin
// 			decrypted192 <= cipherOut2;
// 			Nr <= 12;
// 		end
// 		else if (set1 == 1 && set2 == 0) begin
// 			decrypted256 <= cipherOut3;
// 			Nr <= 14;
// 		end	
// 		else begin
// 			i = -1; // i = 0;
// 		end
// 	end
// end
//----------------------------------------------------------------

always @ (posedge clk) begin

	if (i <= Nr + 2) begin
		
		if (set1 == 0 && set2 == 0) begin
			decrypted128 <= cipherOut1;
			Nr <= 10;
		end
		else if (set1 == 0 && set2 == 1) begin
			decrypted192 <= cipherOut2;
			Nr <= 12;
		end
		else if (set1 == 1 && set2 == 0) begin
			decrypted256 <= cipherOut3;
			Nr <= 14;
		end	
		else begin
			i = -1; // i = 0;
			en <= 0;
		end

		en = 0;
		i = i +1;
		
		if(i == Nr + 2) begin
			if (set1 == 0 && set2 == 0) begin
				decrypted128 <= inputdecipher1;
				Nr <= 10;
			end
			else if (set1 == 0 && set2 == 1) begin
				decrypted192 <= inputdecipher2;
				Nr <= 12;
			end
			else if (set1 == 1 && set2 == 0) begin
				decrypted256 <= inputdecipher3;
				Nr <= 14;
			end
			else begin
				i = 0;
				en <= 0;
				
			end

			en = 1; // en = 0 ;
		end

	end

	else if (i < (2 * (Nr + 2))) begin
		en = 1;

		if (set1 == 0 && set2 == 0) begin
			decrypted128 <= decipherOut1;
			Nr <= 10;
		end
		else if (set1 == 0 && set2 == 1) begin
			decrypted192 <= decipherOut2;
			Nr <= 12;
		end
		else if (set1 == 1 && set2 == 0) begin
			decrypted256 <= decipherOut3;
			Nr <= 14;
		end
		else begin
			i = -1; // i = 0;
			en <= 0;
		end

		i = i + 1;
	end

end

always @(*) begin
	
	if (set1 == 0 && set2 == 0) begin
		d128 = (decrypted128 == in) ? 1'b1 : 1'b0;
		decrypted = decrypted128;
	end
	else if (set1 == 0 && set2 == 1) begin
		d128 = (decrypted192 == in) ? 1'b1 : 1'b0;
		decrypted = decrypted192;
	end
	else if (set1 == 1 && set2 == 0) begin
		d128 = (decrypted256 == in) ? 1'b1 : 1'b0;
		decrypted = decrypted256;
	end

	else if (set1 == 1 && set2 == 1) begin
		d128 = 1'b0;
		decrypted = 0;
	end

end

convertBinToBcd Cin(in[120+:8], segIn_1, segIn_2, segIn_3);
convertBinToBcd Cout(decrypted[120+:8], segOut_1, segOut_2, segOut_3);

always@(*) begin
$monitor("out: %h NR: %d i: %d  en: %b " , decrypted, Nr , i , en);
end

always @(*)begin
	in <= 128'h_00112233445566778899aabbccddeeff;
	if (set1 == 0 && set2 == 0) begin
		Nr <= 10;
		$monitor("key: %h NR: %d " , key128, Nr);
	end
	else if (set1 == 0 && set2 == 1) begin
		Nr <= 12;
		$monitor("key: %h NR: %d " , key192, Nr);
	end
	else if (set1 == 1 && set2 == 0) begin
		Nr <= 14;
		$monitor("key: %h NR: %d " , key256, Nr);
	end	
end
endmodule
