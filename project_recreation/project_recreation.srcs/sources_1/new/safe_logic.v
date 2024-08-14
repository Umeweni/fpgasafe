`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2024 09:23:50 PM
// Design Name: 
// Module Name: safe_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module safe_logic(
    input wire CLK,
    input wire K1,
    input wire K2,
    input wire RESET,
    output reg R,
    output reg Y1,
    output reg Y2,
    output reg G
);

// Define the states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam [2:0] LED = 4'b0000;



reg [2:0] present_state, next_state;

// State transition logic
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        present_state <= S0;
    end else begin
        present_state <= next_state;
    end
end

always @(*) begin
    case (present_state)
        S0: begin
            if (!K2 & !K1) 
                next_state = S0;
            else if (!K2 & K1) 
                next_state = S1;
            else 
                next_state = S0;
        end

        S1: begin
            if (!K2 & !K1) 
                next_state = S2;
            else if (!K2 & K1) 
                next_state = S1;
            else 
                next_state = S0;
        end

        S2: begin
            if (RESET) 
                next_state = S0;
            else if (!K2 & !K1) 
                next_state = S2;
            else if ((!K2 & K1) | (K2 & K1)) 
                next_state = S1;
            else if (K2 & !K1) 
                next_state = S3;
            else 
                next_state = S0;
        end

        S3: begin
            if (!K2 & !K1) 
                next_state = S4;
            else if ((~K2 & K1) | (K2 & K1)) 
                next_state = S0;
            else if (K2 & !K1) 
                next_state = S3;
            else 
                next_state = S0;
        end

        S4: begin
            if ((!K2 & !K1) | (!K2 & K1) | (K2 & !K1)) 
                next_state = S4;
            else if (K2 & K1) 
                next_state = S0;
            else 
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic

always @(next_state) begin
    case (present_state)
        S0: begin 
        R <= 1'b1; 
        Y1 <= 1'b0; 
        Y2 = 1'b0; 
        G = 1'b0;
            end
        S1: begin 
        R = 1'b0; 
        Y1 = 1'b0; 
        Y2 = 1'b1; 
        G = 1'b0;
            end
        S2: begin
        R = 1'b0; 
        Y1 = 1'b1; 
        Y2 = 1'b0; 
        G = 1'b0;
            end
        S3: begin 
            R = 1'b0; 
            Y1 = 1'b1; 
            Y2 = 1'b1; 
            G = 1'b0;
            end
        S4: begin
            R = 1'b0; 
            Y1 = 1'b0; 
            Y2 = 1'b0; 
            G = 1'b1;
            end
    endcase
end

endmodule

