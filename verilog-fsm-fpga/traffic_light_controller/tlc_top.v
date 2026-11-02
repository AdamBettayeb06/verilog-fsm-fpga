`timescale 1ns / 1ps
`default_nettype none

module tlc_top(
    output wire [2:0] JB,
    output wire [1:0] highwaySignal,
    output wire [1:0] farmSignal,
    input wire Clk,
    input wire Reset
);

    wire [30:0] Count;
    wire RstCount;

    counter CNT(
        .Count(Count),
        .RstCount(RstCount),
        .Clk(Clk)
    );

    tlc_fsm FSM(
        .state(JB),
        .RstCount(RstCount),
        .highwaySignal(highwaySignal),
        .farmSignal(farmSignal),
        .Count(Count),
        .Clk(Clk),
        .Rst(Reset)
    );

endmodule
