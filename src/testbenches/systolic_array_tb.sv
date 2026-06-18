`timescale 1ns / 1ps

module systolic_array_tb;

    logic clk, rst, en, done;
    logic[63:0] i_north[3:0];
    logic[63:0] i_west[3:0];
    
    logic[63:0] a_row0[6:0];
    logic[63:0] a_row1[6:0];
    logic[63:0] a_row2[6:0];
    logic[63:0] a_row3[6:0];
    
    logic[63:0] b_row0[6:0];
    logic[63:0] b_row1[6:0];
    logic[63:0] b_row2[6:0];
    logic[63:0] b_row3[6:0];
    
    //----------helper functions----------
    task automatic fill_four_by_four
    (
        input[63:0] a11, a12, a13, a14,
        input[63:0] a21, a22, a23, a24,
        input[63:0] a31, a32, a33, a34,
        input[63:0] a41, a42, a43, a44,
        output[63:0] x_row0[6:0], x_row1[6:0], x_row2[6:0], x_row3[6:0]
    );
        begin
            x_row0[6] = a14;
            x_row0[5] = a13;
            x_row0[4] = a12;
            x_row0[3] = a11;
            x_row0[2] = 0;
            x_row0[1] = 0;
            x_row0[0] = 0;
            
            x_row1[6] = 0;
            x_row1[5] = a24;
            x_row1[4] = a23;
            x_row1[3] = a22;
            x_row1[2] = a21;
            x_row1[1] = 0;
            x_row1[0] = 0;   
            
            x_row2[6] = 0;
            x_row2[5] = 0;
            x_row2[4] = a34;
            x_row2[3] = a33;
            x_row2[2] = a32;
            x_row2[1] = a31;
            x_row2[0] = 0;
            
            x_row3[6] = 0;
            x_row3[5] = 0;
            x_row3[4] = 0;
            x_row3[3] = a44;
            x_row3[2] = a43;
            x_row3[1] = a42;
            x_row3[0] = a41;        
        end
    endtask
    
    task automatic fill_two_by_two
    (
        input[63:0] a11, a12, 
        input[63:0] a21, a22,
        output[63:0] x_row0[6:0], x_row1[6:0]
    );
        begin
            x_row0[6] = a12;
            x_row0[5] = a11;
            x_row0[4] = 0;
            x_row0[3] = 0;
            x_row0[2] = 0;
            x_row0[1] = 0;
            x_row0[0] = 0;
            
            x_row1[6] = 0;
            x_row1[5] = a22;
            x_row1[4] = a21;
            x_row1[3] = 0;
            x_row1[2] = 0;
            x_row1[1] = 0;
            x_row1[0] = 0;        
        end
    endtask
    
    systolic_array uut (.clk(clk), .rst(rst), .en(en),
                        .i_north(i_north),
                        .i_west(i_west),
                        .done(done));
    
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
        for (int i = 0; i < 4; i++) begin
            i_north[i] = 0;
            i_west[i] = 0;
        end
        
        fill_four_by_four (1, 1, 1, 1,
                           1, 1, 1, 1,
                           1, 1, 1, 1,
                           1, 1, 1, 1,
                           a_row0,
                           a_row1,
                           a_row2,
                           a_row3);
                           
        fill_four_by_four (1, 1, 1, 1,
                           1, 1, 1, 1,
                           1, 1, 1, 1,
                           1, 1, 1, 1,
                           b_row0,
                           b_row1,
                           b_row2,
                           b_row3);
        
        //rst high for 2 clk cycles
        rst = 1'b1;
        en = 1'b0;
        
        #(T * 2);
        
        rst = 1'b0;
        en = 1'b1;
        
        for (int i = 0; i < 7; i++) begin 
            i_north[0] = b_row3[i];
            i_north[1] = b_row2[i];
            i_north[2] = b_row1[i];
            i_north[3] = b_row0[i];
            
            i_west[0] = a_row0[6-i];
            i_west[1] = a_row1[6-i];
            i_west[2] = a_row2[6-i];
            i_west[3] = a_row3[6-i];
            #(T);
        end
        
        for (int i = 0; i < 4; i++) begin
            i_north[i] = 0;
            i_west[i] = 0;
        end
        
        #(T * 5);
        
        fill_two_by_two (1, 2,
                         3, 4,
                         a_row0,
                         a_row1);
                         
        fill_two_by_two (1, 2,
                         3, 4,
                         a_row0,
                         a_row1);
                         
        for (int i = 0; i < 7; i++) begin 
            i_north[1] = b_row1[i];
            i_north[0] = b_row0[i];
            
            i_west[0] = a_row0[6-i];
            i_west[1] = a_row1[6-i];
            #(T);
        end
        
        for (int i = 0; i < 4; i++) begin
            i_north[i] = 0;
            i_west[i] = 0;
        end
        
        #(T * 5);
        $stop;       
    end   
endmodule
