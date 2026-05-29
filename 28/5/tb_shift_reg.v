`timescale 1ns/1ps

module tb_shift_reg;

    parameter NB_SHIFTER = 4;

    reg clk, rst, i_data, i_enable_load, i_valid;
    wire [NB_SHIFTER-1:0] r_shift_reg;

    shift_reg #(.NB_SHIFTER(NB_SHIFTER)) u_shift_reg (
        .clk(clk),
        .rst(rst),
        .i_data(i_data),
        .i_enable_load(i_enable_load),
        .i_valid(i_valid),
        .r_shift_reg(r_shift_reg)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; i_data = 0; i_enable_load = 0; i_valid = 0;
        #10;
        rst = 0;

        // shift in: 1 0 1 1
        i_valid = 1; i_enable_load = 0;
        i_data = 1; #10;
        i_data = 0; #10;
        i_data = 1; #10;
        i_data = 1; #10;
        $display("Shift in (esperado 1011): %b", r_shift_reg);

        // rotacion circular
        i_enable_load = 1;
        #10; $display("Rotacion 1 (esperado 0111): %b", r_shift_reg);
        #10; $display("Rotacion 2 (esperado 1110): %b", r_shift_reg);

        // i_valid = 0, no cambia
        i_valid = 0;
        #20;
        $display("Sin valid (esperado 1110): %b", r_shift_reg);

        // reset
        rst = 1; #10; rst = 0;
        $display("Reset (esperado 0000): %b", r_shift_reg);

        i_valid = 1; i_enable_load = 1;
        i_data = 1; #10;
        i_data = 0; #10;
        i_data = 1; #10;
        i_data = 1; #10;

        if (r_shift_reg !== 4'b0000) begin
        #10 $display("ERROR: shift_reg = %h, esperado = 0000", r_shift_reg);
        end else begin
        $display("Reset correcto (esperado 0000): %b", r_shift_reg
        );
        end

        i_valid = 1; i_enable_load = 0;
        i_data = 0; #10;
        i_data = 0; #10;
        i_data = 0; #10;
        i_data = 1; #10;
        i_valid = 0;
        if (r_shift_reg !== 4'b0001) begin
        #10 $display("ERROR: shift_reg = %h, esperado = 1000", r_shift_reg);
        end else begin
        $display("Shift correcto (esperado 0001): %b", r_shift_reg);
        end 

        i_valid = 1; i_enable_load = 1; 
        #10;
        i_valid =0;
        if (r_shift_reg !== 4'b0010) begin
        $display("ERROR: shift_reg = %b, esperado = 0100", r_shift_reg);
        end else begin
        $display("Rotacion correcto (esperado 0010): %b", r_shift_reg);
        end 
        
        i_valid = 1; i_enable_load = 1; 
        #10;
        i_valid =0;
        if (r_shift_reg !== 4'b0100) begin
        $display("ERROR: shift_reg = %b, esperado = 0100", r_shift_reg);
        end  else begin
        $display("Rotacion correcto (esperado 0100): %b", r_shift_reg);
        end


        // ciclo a ciclo
        rst = 1; i_valid = 0; #10;
        $display("[C01] rst=1          r_shift_reg=%b  (esp 0000)", r_shift_reg);
        rst = 0; i_valid = 1; i_enable_load = 0;
        i_data = 1; #10; $display("[C02] load=0 d=1     r_shift_reg=%b  (esp 0001)", r_shift_reg);
        i_data = 0; #10; $display("[C03] load=0 d=0     r_shift_reg=%b  (esp 0010)", r_shift_reg);
        i_data = 1; #10; $display("[C04] load=0 d=1     r_shift_reg=%b  (esp 0101)", r_shift_reg);
        i_data = 1; #10; $display("[C05] load=0 d=1     r_shift_reg=%b  (esp 1011)", r_shift_reg);
        i_enable_load = 1;
        #10; $display("[C06] load=1 rot     r_shift_reg=%b  (esp 0111)", r_shift_reg);
        #10; $display("[C07] load=1 rot     r_shift_reg=%b  (esp 1110)", r_shift_reg);
        #10; $display("[C08] load=1 rot     r_shift_reg=%b  (esp 1101)", r_shift_reg);
        #10; $display("[C09] load=1 rot     r_shift_reg=%b  (esp 1011)", r_shift_reg);
        i_valid = 0;
        #10; $display("[C10] valid=0        r_shift_reg=%b  (esp 1011)", r_shift_reg);
        #10; $display("[C11] valid=0        r_shift_reg=%b  (esp 1011)", r_shift_reg);

        $finish;
    end

endmodule
