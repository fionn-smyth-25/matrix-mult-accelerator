`timescale 1ns / 1ps

module processing_element
(
    input clk, rst, en,
    input[63:0] i_north, i_west,
    output reg[63:0] o_east, o_south, 
    output reg[63:0] result
);

    wire[127:0] acc;
    
    assign acc = i_north * i_west;
            
    always @ (posedge clk) begin
        if (rst) begin
            o_east <= 0;
            o_south <= 0;
            result <= 0;
        end
        else if (en) begin
            o_east <= i_west;
            o_south <= i_north;
            result <= result + acc;
        end
    end
                              
endmodule
