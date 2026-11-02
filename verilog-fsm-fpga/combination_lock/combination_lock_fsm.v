`timescale 1ns / 1ps
`default_nettype none

module combination_lock_fsm(
    output reg [1:0] state,
    output wire [3:0] Lock,
    input wire Key1,
    input wire Key2,
    input wire [3:0] Password,
    input wire Reset,
    input wire Clk
);

    // State encoding
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] nextState;

    // Next-state logic
    always @(*) begin
        case (state)

            S0: begin
                if (Key1 && Password == 4'd13)
                    nextState = S1;
                else
                    nextState = S0;
            end

            S1: begin
                if (Key2 && Password == 4'd7)
                    nextState = S2;
                else if (Key2 && Password != 4'd7)
                    nextState = S0;
                else
                    nextState = S1;
            end

            S2: begin
                if (Key1 && Password == 4'd9)
                    nextState = S3;
                else if (Key1 && Password != 4'd9)
                    nextState = S0;
                else
                    nextState = S2;
            end

            S3: begin
                nextState = S3;
            end

        endcase
    end

    // State registers
    always @(posedge Clk) begin
        if (Reset)
            state <= S0;
        else
            state <= nextState;
    end

    // Output logic
    assign Lock = (state == S3) ? 4'b1111 : 4'b0000;

endmodule


`timescale 1ns / 1ps
`default_nettype none

module synchronizer(
    input wire Clk,
    input wire async_in,
    output reg sync_out
);
    reg stage1;

    always @(posedge Clk) begin
        stage1 <= async_in;
        sync_out <= stage1;
    end
endmodule



`timescale 1ns / 1ps
`default_nettype none

module combination_lock(
    input wire [3:0] SW,
    input wire BTN0,
    input wire BTN1,
    input wire Reset,
    input wire Clk,
    output wire [3:0] LED
);

    // Synchronized signals
    wire Key1_sync;
    wire Key2_sync;
    wire Reset_sync;

    synchronizer sync0(Clk, BTN0, Key1_sync);
    synchronizer sync1(Clk, BTN1, Key2_sync);
    synchronizer sync2(Clk, Reset,  Reset_sync);

    // FSM state exposed for debugging
    wire [1:0] f_state;

    combination_lock_fsm fsm(
        .state(f_state),
        .Lock(LED),
        .Key1(Key1_sync),
        .Key2(Key2_sync),
        .Password(SW),
        .Reset(Reset_sync),
        .Clk(Clk)
    );

endmodule



`timescale 1ns / 1ps
`default_nettype none

module combination_lock_fsm_4pass(
    output reg [2:0] state,
    output wire [3:0] Lock,
    input wire Key1,
    input wire Key2,
    input wire [3:0] Password,
    input wire Reset,
    input wire Clk
);

    // State encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;   // Final unlock state

    reg [2:0] nextState;

    always @(*) begin
        case (state)

            S0: begin
                if (Key1 && Password == 4'd13)
                    nextState = S1;
                else
                    nextState = S0;
            end

            S1: begin
                if (Key2 && Password == 4'd7)
                    nextState = S2;
                else if (Key2 && Password != 4'd7)
                    nextState = S0;
                else
                    nextState = S1;
            end

            S2: begin
                if (Key1 && Password == 4'd9)
                    nextState = S3;
                else if (Key1 && Password != 4'd9)
                    nextState = S0;
                else
                    nextState = S2;
            end

            S3: begin
                if (Key2 && Password == 4'd5)
                    nextState = S4;
                else if (Key2 && Password != 4'd5)
                    nextState = S0;
                else
                    nextState = S3;
            end

            S4: begin
                nextState = S4;
            end

        endcase
    end

    always @(posedge Clk) begin
        if (Reset)
            state <= S0;
        else
            state <= nextState;
    end

    assign Lock = (state == S4) ? 4'b1111 : 4'b0000;

endmodule
