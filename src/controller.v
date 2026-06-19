`timescale 1ns / 1ps

module controller
(
    input clk, rst, ready, done,
    output reg en
);

    //state encoding
    parameter IDLE    = 2'b00,
              COMPUTE = 2'b10,
              DONE    = 2'b11;
  
    reg[1:0] s, ns;

    always @ (posedge clk) begin
        if (rst) begin
            en <= 1'b0;
            s <= IDLE;
        end
        
        s <= ns;
    end
    
    //next state logic
    always @ (*) begin
        case (s)
            IDLE: ns = ready ? COMPUTE : IDLE;
            COMPUTE: begin
                ns = done ? DONE : COMPUTE;
                en <= 1'b1;
            end
            DONE: begin
                ns = IDLE;
                en <= 1'b0;
            end
            default: ns = IDLE;
        endcase 
    end
endmodule
