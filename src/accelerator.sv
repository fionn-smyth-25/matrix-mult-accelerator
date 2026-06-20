`timescale 1ns / 1ps

module accelerator
#(parameter N = 4) //N X N grid of processing elements
(
    input clk, rst, ready,
    input[63:0] a[5 * (N - 1):0], 
    input[63:0] b[5 * (N - 1):0], 
    output[63:0] result[5 * (N - 1):0],
    output finished
);

    wire en, done;
    reg[63:0] north_wires[N-1:0];
    reg[63:0] west_wires[N-1:0];
    
    assign finished = done;
    
    localparam CYCLES = (3 * N) - 2; //MAC operations required

    systolic_array #(N) s_arr (.clk(clk), .rst(rst), .en(en),
                               .i_north(north_wires),
                               .i_west(west_wires),
                               .done(done),
                               .result(result));
                               
    controller cntrl (.clk(clk), .rst(rst), .ready(ready), .done(done),
                      .en(en));
      
    logic[$clog2(2*N):0] cycle;
    
    always @ (posedge clk) begin
        if (rst) begin
            cycle <= 0;
            for (int i = 0; i < N; i++) begin
                north_wires[i] <= 64'b0;
                west_wires[i] <= 64'b0;
            end     
        end
        else if (ready) begin
            if (cycle == CYCLES) begin
                for (int i = 0; i < N; i++) begin
                    north_wires[i] <= 64'b0;
                    west_wires[i] <= 64'b0;
                end      
            end
            else begin
                for (int r = 0; r < N; r++) begin
                    if ((cycle >= r) && ((cycle - r) < N)) begin
                        west_wires[r] <= a[r*N + (cycle-r)];
                    end
                    else begin
                        west_wires[r] <= 64'b0;
                    end                    
                end
                for (int c = 0; c < N; c++) begin
                    if ((cycle >= c) && ((cycle - c) < N)) begin
                        north_wires[c] <= b[(cycle-c)*N + c];
                    end
                    else begin
                        north_wires[c] <= 64'b0;
                    end     
                end
                
                cycle <= cycle + 1;
            end
        end
        else begin
            cycle <= 0;
        end
    end
    
endmodule