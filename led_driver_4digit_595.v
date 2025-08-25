module led_driver_4digit_595 (
    input wire clk,               // 12MHz
    input wire reset,
    input wire [7:0] value,      // Số cần hiển thị
    output reg srclk,
    output reg rclk,
    output reg ser
);

    reg [15:0] shift_data;
    reg [4:0] bit_cnt;
    reg [2:0] state;
    reg [7:0] seg_code;
    reg [7:0] digit_sel;
    reg [3:0] digit_val;
    reg [1:0] digit_index;

    // Tách từng chữ số (đơn vị đến nghìn)
    reg [7:0] digits[3:0];
    reg [7:0] value_sync;
    
    // Đồng bộ và reset giá trị - SỬA THỨ TỰ DIGITS
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            value_sync <= 8'd0;
            digits[0] <= 8'd0;  // Digit 0: Nghìn (luôn 0)
            digits[1] <= 8'd0;  // Digit 1: Trăm
            digits[2] <= 8'd0;  // Digit 2: Chục
            digits[3] <= 8'd0;  // Digit 3: Đơn vị
        end else begin
            value_sync <= value;
            // Tính toán các digits từ giá trị binary - ĐÚNG THỨ TỰ
            digits[2] <= 8'd0;                      // nghìn (luôn 0)
            digits[1] <= (value_sync / 100) % 10;   // trăm
            digits[0] <= (value_sync / 10) % 10;    // chục
            digits[3] <= value_sync % 10;           // đơn vị
        end
    end

    function [7:0] seg7;
        input [3:0] d;
        begin
            case (d)
                4'd0: seg7 = 8'b00111111;
                4'd1: seg7 = 8'b00000110;
                4'd2: seg7 = 8'b01011011;
                4'd3: seg7 = 8'b01001111;
                4'd4: seg7 = 8'b01100110;
                4'd5: seg7 = 8'b01101101;
                4'd6: seg7 = 8'b01111101;
                4'd7: seg7 = 8'b00000111;
                4'd8: seg7 = 8'b01111111;
                4'd9: seg7 = 8'b01101111;
                default: seg7 = 8'b00000000;
            endcase
        end
    endfunction

    localparam IDLE      = 3'd0,
               SHIFT_HI  = 3'd1,
               SHIFT_LO  = 3'd2,
               LATCH_HI  = 3'd3,
               LATCH_LO  = 3'd4;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            srclk <= 0;
            rclk <= 0;
            ser <= 0;
            bit_cnt <= 0;
            digit_index <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    digit_val <= digits[digit_index];
                    case (digit_index)
                        2'd3: digit_sel <= 8'b11110111;
                        2'd2: digit_sel <= 8'b11111011;
                        2'd1: digit_sel <= 8'b11111101;
                        2'd0: digit_sel <= 8'b11111110;
                        default: digit_sel <= 8'b11111111;
                    endcase
                    seg_code <= seg7(digit_val);
                    shift_data <= {~seg_code, ~digit_sel};
                    bit_cnt <= 15;
                    state <= SHIFT_HI;
                end
                SHIFT_HI: begin
                    ser <= shift_data[bit_cnt];
                    srclk <= 1;
                    state <= SHIFT_LO;
                end
                SHIFT_LO: begin
                    srclk <= 0;
                    if (bit_cnt == 0)
                        state <= LATCH_HI;
                    else begin
                        bit_cnt <= bit_cnt - 1;
                        state <= SHIFT_HI;
                    end
                end
                LATCH_HI: begin
                    rclk <= 1;
                    state <= LATCH_LO;
                end
                LATCH_LO: begin
                    rclk <= 0;
                    digit_index <= (digit_index == 3) ? 0 : digit_index + 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule