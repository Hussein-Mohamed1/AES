module mixColumns(
    input [127:0] state_in,
    output [127:0] state_out
);

function [7:0] multBy2;
    input [7:0] term;

    begin
      if (term[7] == 1) 
        multBy2 = ((term << 1) ^ 8'h1b);
      else  
        multBy2 =  term << 1;
    end
    
endfunction

function [7:0] multBy3;
    input [7:0] term;

    begin
      multBy3 = multBy2(term) ^ term;
    end
    
endfunction

genvar i;

generate

    for (i = 0; i < 4; i = i + 1) begin : Column

    assign state_out[(i*32 + 24)+:8]= multBy2(state_in[(i*32 + 24)+:8]) ^ multBy3(state_in[(i*32 + 16)+:8]) ^ state_in[(i*32 + 8)+:8] ^ state_in[i*32+:8];
	  assign state_out[(i*32 + 16)+:8]= state_in[(i*32 + 24)+:8] ^ multBy2(state_in[(i*32 + 16)+:8]) ^ multBy3(state_in[(i*32 + 8)+:8]) ^ state_in[i*32+:8];
	  assign state_out[(i*32 + 8)+:8]= state_in[(i*32 + 24)+:8] ^ state_in[(i*32 + 16)+:8] ^ multBy2(state_in[(i*32 + 8)+:8]) ^ multBy3(state_in[i*32+:8]);
    assign state_out[i*32+:8]= multBy3(state_in[(i*32 + 24)+:8]) ^ state_in[(i*32 + 16)+:8] ^ state_in[(i*32 + 8)+:8] ^ multBy2(state_in[i*32+:8]);

    end

endgenerate



endmodule