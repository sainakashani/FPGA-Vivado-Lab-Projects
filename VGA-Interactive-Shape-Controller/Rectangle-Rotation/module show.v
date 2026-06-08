module show(
    input clk,         
    input resetn,
	input [7:0]x_new,
	input [6:0]y_new,
	input	[3:0] KEY,				//	Button[0:0]
	input	[17:0] SW,				//	Button[0:0]
    output VGA_CLK,    
    output VGA_HS,     
    output VGA_VS,     
    output VGA_BLANK,  
    output VGA_SYNC,   
    output [9:0] VGA_R,
    output [9:0] VGA_G,
    output [9:0] VGA_B
);
    reg [7:0] x;       
    reg [6:0] y;       
    reg plot;          
    parameter start_x = 0;  
    parameter start_y = 0;
    parameter width = 20;
    parameter height = 10;
    reg [4:0] count_x = 0;  
    reg [3:0] count_y = 0;  
    reg[7:0]x_1;
    reg[6:0]y_1;

	
	//wire resetn;
	reg [2:0] color;
    wire colour;
    //reg [7:0]x=80;
   // reg [6:0]y=60;
	//assign resetn = KEY[0];
    //assign plot=KEY[1];
	// Further assignments go here...
    assign colour=SW[17:15];
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.


    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            x<=start_x;
            y<=start_y;
            x_1<=start_x;
            y_1<=start_y;
            count_x<=0;
            count_y<=0;
            plot<=0;
        end 
        else begin
        if (count_x < width && count_y < height) begin
            x <= x_1 + count_x;
            y <= y_1+ count_y;
            color <= 3'b001;       //blue
            plot <= 1;
            if (count_x < width - 1)
                count_x <= count_x + 1;
            else begin
                count_x <= 0;
                if (count_y < height - 1)
                    count_y <= count_y + 1;
                else begin
                    count_y <= 0;
                    x_1<= x_new;
                    y_1<= y_new;
                    x <= x_new;
                    y <= y_new;
                    plot <= 1;
                end
            end
        end
        else begin
            plot<=0;
        end
    end
    end
    	vga_adapter VGA(
			.resetn(resetn),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "display.mif";

endmodule