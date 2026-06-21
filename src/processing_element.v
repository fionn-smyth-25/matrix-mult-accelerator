`timescale 1ns / 1ps

module processing_element
#(parameter DATA_WIDTH = 64)
(
    input clk, rst, en,
    input[DATA_WIDTH-1:0] i_north, i_west,
    output reg[DATA_WIDTH-1:0] o_east, o_south, 
    output reg[2*DATA_WIDTH:0] result
);

    wire[2*DATA_WIDTH:0] acc;
    
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
