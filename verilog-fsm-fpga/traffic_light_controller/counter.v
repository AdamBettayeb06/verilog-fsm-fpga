`timescale 1ns / 1ps
`default_nettype none

module counter(
    output reg [30:0] Count,
    input wire RstCount,
    input wire Clk
);

    always @(posedge Clk) begin
        if (RstCount)
            Count <= 31'd0;
        else
            Count <= Count + 1'b1;
    end

endmodule
