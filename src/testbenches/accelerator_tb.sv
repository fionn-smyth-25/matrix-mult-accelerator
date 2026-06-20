`timescale 1ns / 1ps

module accelerator_tb;

    parameter N = 4;
    parameter MAX = 5 * (N - 1); //max amount of proccessing elements required
    logic clk, rst, ready, finished;
    logic[63:0] a[MAX:0];
    logic[63:0] b[MAX:0]; 
    logic[63:0] result[MAX:0];
    logic[63:0] r[MAX:0];
    
    //----------Helper Functions----------
    task automatic mult_ref
    (
        input logic[63:0] x[MAX:0],
        input logic[63:0] y[MAX:0],
        output logic[63:0] z[MAX:0]
    );
        logic[63:0] sum;
        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                sum = 0;
                for (int k = 0; k < N; k++) begin
                    sum += x[i*N + k] * y[k*N + j];
                end
                z[i*N + j] = sum;
                $display("ref @ index %0d %0d", i*N + j, sum);
            end
        end
    endtask
    
    task automatic cmp_mat
    (
        input logic[63:0] x[MAX:0],
        input logic[63:0] y[MAX:0]
    );
        for (int i = 0; i <= MAX; i++) begin
            if (x[i] !== y[i]) $display("Mismatch at %0d: expected=%0d got=%0d", i, x[i], y[i]);
            else $display("Passed at %0d", i);
        end
    endtask
    
    //------------------------------------

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
    
    initial begin
        //init
        ready = 1'b0;
        for (int i = 0; i < MAX + 1; i++) begin
            if (i < 4 && i > 0) begin
                a[i] = a[i - 1] - 1;
                b[i] = b[i - 1] - 1;
            end
            else begin
            a[i] = 64'b11;
            b[i] = 64'b11;
            end
        end
        
        //rst high for 2 clk cycles
        rst = 1'b1;

        #(T * 2);
        
        rst = 1'b0;
        ready = 1'b1;
        mult_ref(a, b, r);
        @(posedge finished) cmp_mat(r, result);
    end
    
endmodule
