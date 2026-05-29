module shift_reg #(
    NB_SHIFTER = 4
)(
    input clk,
    input rst,
    input i_data,
    input i_enable_load,
    input i_valid,
    output reg [NB_SHIFTER-1:0] r_shift_reg
);


// r_shift_reg[0] -->[1] --> [2] --> [3] --> [4] --> [5] --> [6] --> [NB_SHIFTER-1]


always @(posedge clk) begin //sincrono?
    if (rst) begin
        r_shift_reg <= 0;
    end else begin
        if (i_valid) begin  // flanco positivo de i_valid
            case(i_enable_load)
                0: r_shift_reg <= {r_shift_reg[NB_SHIFTER-2:0], i_data}; // 0,1 2 y 3 --> shift anterior y agregamos i_data
                1: r_shift_reg <= {r_shift_reg[NB_SHIFTER-2:0], r_shift_reg[NB_SHIFTER-1]}; // 0,1 2 y 3 --> shift anterior y agregamos i_data
                default: r_shift_reg <= r_shift_reg; // No se realiza ningún cambio
            endcase
        end
    end
end



endmodule