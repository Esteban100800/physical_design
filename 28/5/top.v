module top(
    input clk,
    input rst,
    input i_data,
    input i_enable_load,
    input i_valid,
    output [3:0] o_led

);

shift_reg #(
    .NB_SHIFTER(4)
) u_shift_reg (
    .clk(clk),
    .rst(rst),
    .i_data(i_data),
    .i_enable_load(i_enable_load),
    .i_valid(i_valid),
    .r_shift_reg(o_led)
);

endmodule