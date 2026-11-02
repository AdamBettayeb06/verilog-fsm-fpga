`timescale 1ns / 1ps
`default_nettype none

module tlc_fsm(
    output reg [2:0] state,
    output reg RstCount,
    output reg [1:0] highwaySignal,
    output reg [1:0] farmSignal,
    input wire [30:0] Count,
    input wire Clk,
    input wire Rst
);

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;
    localparam S5 = 3'b101;

    reg [2:0] next_state;

    always @(*) begin
        case (state)
            S0:  next_state = (Count == 50_000_000)      ? S1 : S0;
            S1:  next_state = (Count == 1_500_000_000)   ? S2 : S1;
            S2:  next_state = (Count == 150_000_000)     ? S3 : S2;
            S3:  next_state = (Count == 50_000_000)      ? S4 : S3;
            S4:  next_state = (Count == 750_000_000)     ? S5 : S4;
            S5:  next_state = (Count == 150_000_000)     ? S0 : S5;
            default: next_state = S0;
        endcase
    end

    always @(posedge Clk) begin
        if (Rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        RstCount = 1'b0;

        case (state)
            S0: begin
                highwaySignal = 2'b01;
                farmSignal    = 2'b01;
                RstCount      = (Count == 0);
            end

            S1: begin
                highwaySignal = 2'b11;
                farmSignal    = 2'b01;
                RstCount      = (Count == 0);
            end

            S2: begin
                highwaySignal = 2'b10;
                farmSignal    = 2'b01;
                RstCount      = (Count == 0);
            end

            S3: begin
                highwaySignal = 2'b01;
                farmSignal    = 2'b01;
                RstCount      = (Count == 0);
            end

            S4: begin
                highwaySignal = 2'b01;
                farmSignal    = 2'b11;
                RstCount      = (Count == 0);
            end

            S5: begin
                highwaySignal = 2'b01;
                farmSignal    = 2'b10;
                RstCount      = (Count == 0);
            end

            default: begin
                highwaySignal = 2'b01;
                farmSignal    = 2'b01;
                RstCount      = 1'b1;
            end
        endcase
    end
endmodule
