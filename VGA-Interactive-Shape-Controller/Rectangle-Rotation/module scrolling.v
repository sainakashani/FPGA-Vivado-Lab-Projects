module scrolling(
	input [3:0]s,
	input clk,
	input reset,
	output reg [4:0]width,
	output reg [4:0]height,
	output reg [7:0]x_next,
	output reg [6:0]y_next
);
reg [7:0]x=80;
reg [6:0]y=60;
reg vertical=0;
always@(posedge clk or negedge reset)begin
	if(!reset)begin
		x_next<=80;
		y_next<=60;
		vertical=0;
        width=10;
        height=20;
	end
	else
	case(s)
	4'b1000:begin				//right
		if(vertical)begin
		width<=20;
		height<=10;
		vertical<=0;
		x<=x;
        y<=y;
		end
		else
		begin
		width<=20;
		height<=10;
		x<=x;
		y<=y;
		vertical<=0;
		end
	end

	4'b0100:begin				//left
		if(vertical)begin
			width<=20;
			height<=10;
			vertical<=0;
			x<=x-10;
            y<=y+10;
		end
		else
		begin
		width<=20;
		height<=10;
		x<=x;
		y<=y;
		vertical<=0;
	end
	end


	4'b0010:begin				//up
		if(!vertical)begin
			width<=10;
			height<=20;
			vertical<=1;
			y<=y;
            x<=x;
		end
		else 
		begin
			width<=10;
			height<=20;
			y<=y;
            x<=x;
			vertical<=1;
		end
	end

	4'b0001:begin				//down
		if(!vertical)begin
			width<=10;
			height<=20;
			y<=y;
            x<=x;
			vertical<=1;
			end
			else
			begin
				width<=10;
				height<=20;
				y<=y;
                x<=x;
				vertical<=1;
			end
	end
	endcase
end
endmodule
