`timescale 1ns / 1ps

module systolic_array
(
    input clk, rst, en,
    input[63:0] i_north0, i_north1, i_north2, i_north3,
    input[63:0] i_west0, i_west4, i_west8, i_west12,
    output reg done  
);

    reg[3:0] count;
    wire[63:0] o_east[0:15];
    wire[63:0] o_south[0:15];
    wire[63:0] result[0:15];
    
    processing_element p0 (.clk(clk), .rst(rst), .en(en),
                           .i_north(i_north0), .i_west(i_west0),
                           .o_east(o_east[0]), .o_south(o_south[0]),
                           .result(result[0]));
                           
    processing_element p1 (.clk(clk), .rst(rst), .en(en),
                       .i_north(i_north1), .i_west(o_east[0]),
                       .o_east(o_east[1]), .o_south(o_south[1]),
                       .result(result[1]));
                       
    processing_element p2 (.clk(clk), .rst(rst), .en(en),
                           .i_north(i_north2), .i_west(o_east[1]),
                           .o_east(o_east[2]), .o_south(o_south[2]),
                           .result(result[2]));
                           
    processing_element p3 (.clk(clk), .rst(rst), .en(en),
                       .i_north(i_north3), .i_west(o_east[2]),
                       .o_east(o_east[3]), .o_south(o_south[3]),
                       .result(result[3]));
                       
    processing_element p4 (.clk(clk), .rst(rst), .en(en),
                           .i_north(o_south[0]), .i_west(i_west4),
                           .o_east(o_east[4]), .o_south(o_south[4]),
                           .result(result[4]));
                           
    processing_element p5 (.clk(clk), .rst(rst), .en(en),
                       .i_north(o_south[1]), .i_west(o_east[4]),
                       .o_east(o_east[5]), .o_south(o_south[5]),
                       .result(result[5]));
                       
    processing_element p6 (.clk(clk), .rst(rst), .en(en),
                           .i_north(o_south[2]), .i_west(o_east[5]),
                           .o_east(o_east[6]), .o_south(o_south[6]),
                           .result(result[6]));
                           
    processing_element p7 (.clk(clk), .rst(rst), .en(en),
                       .i_north(o_south[3]), .i_west(o_east[6]),
                       .o_east(o_east[7]), .o_south(o_south[7]),
                       .result(result[7]));
                       
    processing_element p8 (.clk(clk), .rst(rst), .en(en),
                           .i_north(o_south[4]), .i_west(i_west8),
                           .o_east(o_east[8]), .o_south(o_south[8]),
                           .result(result[8]));
                           
    processing_element p9 (.clk(clk), .rst(rst), .en(en),
                       .i_north(o_south[5]), .i_west(o_east[8]),
                       .o_east(o_east[9]), .o_south(o_south[9]),
                       .result(result[9]));
                       
    processing_element p10 (.clk(clk), .rst(rst), .en(en),
                           .i_north(o_south[6]), .i_west(o_east[9]),
                           .o_east(o_east[10]), .o_south(o_south[10]),
                           .result(result[10]));
                           
    processing_element p11 (.clk(clk), .rst(rst), .en(en),
                       .i_north(o_south[7]), .i_west(o_east[10]),
                       .o_east(o_east[11]), .o_south(o_south[11]),
                       .result(result[11]));
                       
    processing_element p12 (.clk(clk), .rst(rst), .en(en),
                           .i_north(o_south[8]), .i_west(i_west12),
                           .o_east(o_east[12]), .o_south(o_south[12]),
                           .result(result[12]));
                           
    processing_element p13 (.clk(clk), .rst(rst), .en(en),
                       .i_north(o_south[9]), .i_west(o_east[12]),
                       .o_east(o_east[13]), .o_south(o_south[13]),
                       .result(result[13]));
                       
    processing_element p14 (.clk(clk), .rst(rst), .en(en),
                           .i_north(o_south[10]), .i_west(o_east[13]),
                           .o_east(o_east[14]), .o_south(o_south[14]),
                           .result(result[14]));
                           
    processing_element p15 (.clk(clk), .rst(rst), .en(en),
                       .i_north(o_south[11]), .i_west(o_east[14]),
                       .o_east(o_east[15]), .o_south(o_south[15]),
                       .result(result[15]));
                       
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            count <= 0;
        end
        else if (en) begin
            done <= 0;
            count <= count + 1;
            if (count == 10) begin
                done <= 1;
                count <= 0;
            end
        end
    end
endmodule
