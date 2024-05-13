module AES_P_tb;

reg clk;
wire [6:0] segIn_1, segIn_2, segIn_3;
wire [6:0] segOut_1, segOut_2, segOut_3;
wire e128;
wire d128;
reg set1, set2;

// Instantiate the AES_P module
AES_P AES_P_inst (
    .e128(e128),
    .d128(d128),
    .segIn_1(segIn_1),
    .segIn_2(segIn_2),
    .segIn_3(segIn_3),
    .segOut_1(segOut_1),
    .segOut_2(segOut_2),
    .segOut_3(segOut_3),
    .clk(clk),
    .set1(set1),
    .set2(set2)
);

// Clock generation
always #5 clk = ~clk;

// Test stimulus
initial begin
    clk = 1'b0;
    set1 = 1'b0;
    set2 = 1'b0;
    #500;

    set1 = 1'b1;
    set2 = 1'b1; 
    #10

    set1 = 1'b1;
    set2 = 1'b0;
    #500;

    set1 = 1'b1;
    set2 = 1'b1; 
    #10

    set1 = 1'b0;
    set2 = 1'b1;
    #500;

end

// Monitor for debugging
always @(posedge clk) begin
    $display("Time: %t, e128: %b, d128: %b, segIn_1: %h, segIn_2: %h, segIn_3: %h, segOut_1: %h, segOut_2: %h, segOut_3: %h",
    $time, e128, d128, segIn_1, segIn_2, segIn_3, segOut_1, segOut_2, segOut_3);
end

endmodule
