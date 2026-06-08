module top_module(
    input CLOCK_50,
    input [3:0] KEY,   
    input [17:0] SW,   
    output VGA_CLK,
    output VGA_HS,
    output VGA_VS,
    output VGA_BLANK,
    output VGA_SYNC,
    output [9:0] VGA_R,
    output [9:0] VGA_G,
    output [9:0] VGA_B
);

    wire resetn, plot;
    wire [2:0] color;
    wire [7:0] x_new;  
    wire [6:0] y_new;  
    wire width,height;

    assign resetn = KEY[0];  
    assign plot = KEY[1];    
    assign color = SW[17:15]; 

    scrolling u1(.s(SW[3:0]),.clk(CLOCK_50),.reset(resetn),.width(width),.height(height),.x_next(x_new),.y_next(y_new));

    //background u2 (.CLOCK_50(CLOCK_50),.KEY(KEY),.SW(SW),.VGA_CLK(VGA_CLK),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK),.VGA_SYNC(VGA_SYNC),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));

    //show u3 (.width(width),.height(height),.x_new(x_new),.y_new(y_new),.clk(CLOCK_50),.resetn(resetn),.VGA_CLK(VGA_CLK),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK),.VGA_SYNC(VGA_SYNC),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));
	show u3 (.KEY(KEY),.SW(SW),.x_new(x_new),.y_new(y_new),.clk(CLOCK_50),.resetn(resetn),.VGA_CLK(VGA_CLK),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK),.VGA_SYNC(VGA_SYNC),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));


endmodule