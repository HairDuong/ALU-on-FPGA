module ALU(
input clk,
input rst,
input rx,
output srclk,
output ser,
output rclk);


wire data_valid, Cout, Bout, div0;
    wire [7:0] value, Sum, Diff, P, Q, R, A, B, out;
    wire [1:0] operator;  // Thêm wire cho operator
    wire Cin = 1'b0;      // Thêm Cin cho adder
    wire Bin = 1'b0;      // Thêm Bin cho subtractor
// UART
UART_RX uart_inst
(
.clk(clk),
.rst(rst),
.rx(rx),
.value(value),
.data_valid(data_valid));

// INPUT DATA
data_input data_input_inst(
.clk(clk),
.rst(rst),
.value(value),
.data_valid(data_valid),
.A(A),
.B(B),
.operator(operator));

// FULL ADDER
Full_adder_8bit full_adder_8bit_inst (
.A(A),
.B(B),
.Cin(Cin),
.Sum(Sum),
.Cout(Cout));

// FULL SUBTATOR
Full_subtractor_8bit Full_subtractor_8bit_inst(
.A(A),
.B(B),
.Bin(Bin),
.Diff(Diff),
.Bout(Bout));

// MULTIPLIER
    multiplier_8bit multiplier_8bit_inst (  // Sửa tên instance
        .A(A),
        .B(B),
        .P(P)
    );


//DIVIDER
divider_8bit divider_8bit_inst(
.A(A),
.B(B),
.Q(Q),
.R(R),
.div0(div0)
);

//MUX
mux_8bit_4to1 mux_8bit_4to1_inst(
.i_add(Sum),
.i_sub(Diff),
.i_mul(P),
.i_div(Q),
.sel(operator),
.out(out)
);

// display LED
    led_driver_4digit_595 led_display (
        .clk(clk),
        .reset(rst),
        .value(out),
        .srclk(srclk),
        .rclk(rclk),
        .ser(ser)
    );


endmodule