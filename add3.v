module seven_segment_decoder(
    input [3:0] in,
    output reg [6:0] out
);

// Seven-segment display truth table
always @(*)
    case (in)
        4'b0000: out = 7'b1000000; // 0
        4'b0001: out = 7'b1111001; // 1
        4'b0010: out = 7'b0100100; // 2
        4'b0011: out = 7'b0110000; // 3
        4'b0100: out = 7'b0011001; // 4
        4'b0101: out = 7'b0010010; // 5
        4'b0110: out = 7'b0000010; // 6
        4'b0111: out = 7'b1111000; // 7
        4'b1000: out = 7'b0000000; // 8
        4'b1001: out = 7'b0010000; // 9
        default: out = 7'b1111111; // Off
    endcase

endmodule



module add3(
    input [3:0]in,
    output reg [3:0] out
);

always @(in) begin
    case (in)
	    4'b0000: out <= 4'b0000;
	    4'b0001: out <= 4'b0001;
	    4'b0010: out <= 4'b0010;
	    4'b0011: out <= 4'b0011;
	    4'b0100: out <= 4'b0100;
	    4'b0101: out <= 4'b1000;
	    4'b0110: out <= 4'b1001;
	    4'b0111: out <= 4'b1010;
	    4'b1000: out <= 4'b1011;
	    4'b1001: out <= 4'b1100;
	    default: out <= 4'b0000;
	endcase
end
endmodule



module convertBinToBcd(
    input [7:0] A,
    output[6:0] on, tn, hun
);

wire [3:0] ones, tens;
wire [1:0] hundreds;

wire [3:0] c1,c2,c3,c4,c5,c6,c7;
wire [3:0] d1,d2,d3,d4,d5,d6,d7;

assign d1 = {1'b0,A[7:5]};
assign d2 = {c1[2:0],A[4]};
assign d3 = {c2[2:0],A[3]};
assign d4 = {c3[2:0],A[2]};
assign d5 = {c4[2:0],A[1]};
assign d6 = {1'b0,c1[3],c2[3],c3[3]};
assign d7 = {c6[2:0],c4[3]};
add3 m1(d1,c1);
add3 m2(d2,c2);
add3 m3(d3,c3);
add3 m4(d4,c4);
add3 m5(d5,c5);
add3 m6(d6,c6);
add3 m7(d7,c7);
assign ones = {c5[2:0],A[0]};
seven_segment_decoder a1(ones, on);
assign tens = {c7[2:0],c5[3]};
seven_segment_decoder a2(tens, tn);
assign hundreds = {c6[3],c7[3]};
seven_segment_decoder a3(hundreds, hun);

endmodule



