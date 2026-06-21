`timescale 1ns / 1ps

module systolic_array
#(parameter N = 4, //N X N grid of processing elements
  parameter MAX = N*N, //Number of processing elements required
  parameter CYCLES = (3*N) - 2, //MAC operations required
  parameter DATA_WIDTH = 64) 
(
    input clk, rst, en,
    input[DATA_WIDTH-1:0] i_north[N-1:0],
    input[DATA_WIDTH-1:0] i_west[N-1:0],
    output reg done,
    output reg[2*DATA_WIDTH:0] result[MAX-1:0]
);

    reg[$clog2(2*N):0] count;
    wire[DATA_WIDTH-1:0] o_east[MAX-1:0];
    wire[DATA_WIDTH-1:0] o_south[MAX-1:0];
    
    genvar r, c;
    
    generate
        for (r = 0; r < N; r++) begin
            for (c = 0; c < N; c++) begin
            
                localparam idx = (r * N) + c; 

                //handle corner/edge logic
                processing_element #(DATA_WIDTH) 
                                    pe_inst (.clk(clk), .rst(rst), .en(en),
                                            .i_north((r == 0) ? i_north[c] : o_south[idx - N]),
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
