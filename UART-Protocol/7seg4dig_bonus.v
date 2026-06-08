module seg_2(
    input clk,
    input reset,
    output reg [3:0]dig,
    output reg [6:0]abcdefg
);
    parameter CLK=50000000;
    parameter refresh=10000;
 localparam integer REFRESH_CYCLES=CLK/refresh;
    reg [18:0] t = 0; 
    reg [6:0] num;      
    assign abcdefg=num;
    reg [1:0]t_2=0;
    always @(posedge clk) begin
        if (reset) begin
            t<=0;
            num<=0;
            dig<=4'b0000;
            t_2<=0;
        end
        else begin
            t<=t+1;
            if (t>REFRESH_CYCLES) begin
                t<=0;
                t_2<=t_2+1;
            end
            if(t_2>2'b11)begin
                t_2<=0;
            end
        end
        case (t_2)
        2'b00:begin
            abcdefg<=~(7'b0110011);
            dig<=4'b0001;
        end
        2'b01:begin
            abcdefg<=~(7'b1111001);
            dig<=4'0010;
        end
        2'b10:begin
            abcdefg<=~(7'b1101101);
            dig<=4'0100;
        end
        2'b11:begin
            abcdefg<=~(7'b0000110);
            dig<=4'b1000;
        end
    endcase
    end
endmodule