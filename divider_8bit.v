module divider_8bit (
    input  [7:0] A, B,      // Số bị chia và số chia
    output reg [7:0] Q, R,  // Thương và Số dư
    output reg div0         // Cờ báo lỗi chia cho 0
);
    always @(*) begin
        if (B == 0) begin
            Q    = 0;
            R    = 0;
            div0 = 1'b1; // Lỗi chia 0
        end else begin
            Q    = A / B; // Thương
            R    = A % B; // Số dư
            div0 = 1'b0;  // Không lỗi
        end
    end
endmodule
