module AES_P(enable, e128, d128);

output wire e128;
output wire d128;
input enable;

// The plain text used as input
wire[127:0] in = 128'h_00112233445566778899aabbccddeeff;

// The different keys used for testing (one of each type)
wire[127:0] key128 = 128'h_000102030405060708090a0b0c0d0e0f;

// The expected outputs from the encryption module
wire[127:0] expected128 = 128'h_69c4e0d86a7b0430d8cdb78070b4c55a;

// The result of the encryption module for every type
wire[127:0] encrypted128;

assign e128 = (encrypted128 == expected128 && enable) ? 1'b1 : 1'b0;

// The result of the decryption module for every type
wire[127:0] decrypted128;

Cipher a(in,key128,encrypted128);

Decipher a2(encrypted128,key128,decrypted128);


assign d128 = (decrypted128 == in && enable) ? 1'b1 : 1'b0;


endmodule