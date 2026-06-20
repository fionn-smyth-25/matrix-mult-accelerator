`timescale 1ns / 1ps

module systolic_array
#(parameter N = 4) //N X N grid of processing elements
(
    input clk, rst, en,
    input[63:0] i_north[N-1:0],
    input[63:0] i_west[N-1:0],
    output reg done,
    output reg[63:0] result[5 * (N - 1):0]
);
    
    localparam MAX = 5 * (N - 1); //max amount of proccessing elements required
    localparam CYCLES = (3 * N) - 2; //MAC operations required

    reg[3:0] count;
    wire[63:0] o_east[MAX:0];
    wire[63:0] o_south[MAX:0];
    
    genvar r, c;
    
    generate
        for (r = 0; r < N; r++) begin
            for (c = 0; c < N; c++) begin
            
                localparam idx = (r * N) + c; 

                //handle corner/edge logic
                processing_element pe_inst (.clk(clk), .rst(rst), .en(en),
                                            .i_north((r == 0) ? i_north[c] : o_south[idx - 4]),
                                            .i_west ((c == 0) ? i_west[r]   : o_east[idx - 1]),
                                            .o_east(o_east[idx]), .o_south(o_south[idx]), .result(result[idx]));             
            end
        end
    endgenerate
                       
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            count <= 0;
            for (int i = 0; i < MAX; i++) begin
                result[i] <= 0;
            end          
        end
        else if (en) begin
            done <= 0;
            count <= count + 1;
            if (count == CYCLES) begin
                done <= 1;
                count <= 0;
            end
        end
    end
endmodule
