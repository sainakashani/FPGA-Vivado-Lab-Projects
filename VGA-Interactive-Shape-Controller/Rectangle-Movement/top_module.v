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

    assign resetn = KEY[0];  
    assign plot = KEY[1];    
    assign color = SW[17:15]; 

    motion_control u1 (.clk(CLOCK_50),.resetn(resetn),.z(SW[3:0]),.x_next(x_new),.y_next(y_new));

    show u3 (.KEY(KEY),.SW(SW),.x_new(x_new),.y_new(y_new),.clk(CLOCK_50),.resetn(resetn),.VGA_CLK(VGA_CLK),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK),.VGA_SYNC(VGA_SYNC),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));

endmodule