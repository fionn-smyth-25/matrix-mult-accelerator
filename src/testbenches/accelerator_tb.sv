`timescale 1ns / 1ps

module accelerator_tb;

    parameter N = 4;
    parameter MAX = 5 * (N - 1); //max amount of proccessing elements required
    logic clk, rst, en, ready, finished;
    logic[63:0] a[5 * (N - 1):0];
    logic[63:0] b[5 * (N - 1):0]; 
    logic[63:0] result[5 * (N - 1):0];

    accelerator #(N) uut (.clk(clk), .rst(rst), .ready(ready),
                     .a(a), 
                     .b(b), 
                     .result(result),
                     .finished(finished));
                     
    //clock period (ns)
    parameter T = 10;
    
    always begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end    
    
    always @ (posedge clk) begin
        if (finished) $stop;
    end
    
    initial begin
        //init
        en = 1'b0;
        ready = 1'b0;
        for (int i = 0; i < MAX + 1; i++) begin
            a[i] = 64'b11;
            b[i] = 64'b11;
        end
        
        //rst high for 2 clk cycles
        rst = 1'b1;

        #(T * 2);
        
        rst = 1'b0;
        ready = 1'b1;
    end
    
endmodule
