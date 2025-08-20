module data_input (
    input clk, rst,
    input wire [7:0] value,
    input wire data_valid,
    output reg [7:0] A, B,
    output reg [1:0] operator,
	 output reg outdata_valid
);

localparam S_A        = 2'b00,
           S_OPERATOR = 2'b01,
           S_B        = 2'b10;
           
reg [1:0] state, operator_reg;
reg [7:0] A_reg, B_reg;
always @(posedge clk or negedge rst)
begin
    if (!rst) begin
        A_reg <= 8'b0;
        B_reg <= 8'b0;
        operator_reg <= 2'b00;
        state <= S_A;
    end else begin
        case (state)
            S_A: begin
				 outdata_valid <= 1'b0;
                if (data_valid) begin  // Kiểm tra data_valid cho mỗi ký tự
                    A_reg <= value;
						 
                    state <= S_OPERATOR;
                end
            end
            
            S_OPERATOR: begin
                if (data_valid) begin  // Kiểm tra data_valid cho mỗi ký tự
                    case (value)
                        8'd43: operator_reg <= 2'b00;  // '+'
                        8'd45: operator_reg <= 2'b01;  // '-'
                        8'd42: operator_reg <= 2'b10;  // '*'
                        8'd47: operator_reg <= 2'b11;  // '/'
                        default: operator_reg <= 2'b00; // Mặc định là cộng
                    endcase
                    state <= S_B;
                end
            end
            
            S_B: begin
                if (data_valid) begin  // Kiểm tra data_valid cho mỗi ký tự
                    B_reg <= value;
						  outdata_valid <=1'b1;
                    state <= S_A;
                end
            end
            
            default: state <= S_A;
        endcase
    end
end
always@(posedge clk or negedge rst)
begin
if(~rst)
	begin
	A<=8'd0;
	B<=8'd0;
	operator <= 2'b00;
	end
	
	else if(outdata_valid)
	begin
	A<= (A_reg - 8'd48);
	B<= (B_reg - 8'd48);
	operator<= operator_reg;
	end
end

endmodule