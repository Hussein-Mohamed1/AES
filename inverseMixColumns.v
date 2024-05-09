module inverseMixColumns(
    input [127:0] state_in,
    output [127:0] state_out
);

function [7:0] multBy2_nTimes;
    input [7:0] term;
    input integer n;
    integer i;
    begin
        for (i = 0; i < n; i = i + 1) begin
            if (term[7] == 1) 
                term = ((term << 1) ^ 8'h1b);
            else  
                term = term << 1;
        end
        multBy2_nTimes = term;
    end
endfunction

function [7:0] multBy0e;
    input [7:0] term;
    begin
        multBy0e = multBy2_nTimes(term, 3) ^ multBy2_nTimes(term, 2) ^ multBy2_nTimes(term, 1);
    end
endfunction

function [7:0] multBy09;
    input [7:0] term;
    begin
        multBy09 = multBy2_nTimes(term, 3) ^ term;
    end
endfunction

function [7:0] multBy0d;
    input [7:0] term;
    begin
        multBy0d = multBy2_nTimes(term, 3) ^ multBy2_nTimes(term, 2) ^ term;
    end
endfunction

function [7:0] multBy0b;
    input [7:0] term;
    begin
        multBy0b = multBy2_nTimes(term, 3) ^ multBy2_nTimes(term, 1) ^ term;
    end
endfunction

genvar i;

generate
    for (i = 0; i < 4; i = i + 1) begin : Column
        assign state_out[(i*32 + 24)+:8] = multBy0e(state_in[(i*32 + 24)+:8]) ^ multBy0b(state_in[(i*32 + 16)+:8]) ^ multBy0d(state_in[(i*32 + 8)+:8]) ^ multBy09(state_in[i*32+:8]);
        assign state_out[(i*32 + 16)+:8] = multBy09(state_in[(i*32 + 24)+:8]) ^ multBy0e(state_in[(i*32 + 16)+:8]) ^ multBy0b(state_in[(i*32 + 8)+:8]) ^ multBy0d(state_in[i*32+:8]);
        assign state_out[(i*32 + 8)+:8]  = multBy0d(state_in[(i*32 + 24)+:8]) ^ multBy09(state_in[(i*32 + 16)+:8]) ^ multBy0e(state_in[(i*32 + 8)+:8]) ^ multBy0b(state_in[i*32+:8]);
        assign state_out[i*32+:8]        = multBy0b(state_in[(i*32 + 24)+:8]) ^ multBy0d(state_in[(i*32 + 16)+:8]) ^ multBy09(state_in[(i*32 + 8)+:8]) ^ multBy0e(state_in[i*32+:8]);
    end
endgenerate

endmodule