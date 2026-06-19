`timescale 1ns / 1ps

module controller
(
    input clk, rst, ready, loaded, done,
    output reg en, load_en
);

    //state encoding
    parameter IDLE    = 2'b00,
              LOAD    = 2'b01,
              COMPUTE = 2'b11,
              DONE    = 2'b10;
  
    reg[1:0] s, ns;

    always @ (posedge clk) begin
        if (rst) begin
            en <= 1'b0;
            load_en <= 1'b0;
            s <= IDLE;
        end
        
        s <= ns;
    end
    
    //next state logic
    always @ (*) begin
        case (s)
            IDLE: ns = ready ? LOAD : IDLE;
            LOAD: begin
                ns = loaded ? COMPUTE : LOAD;
                load_en <= 1'b1;
            end
            COMPUTE: begin
                ns = done ? DONE : COMPUTE;
                load_en <= 1'b0;
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
