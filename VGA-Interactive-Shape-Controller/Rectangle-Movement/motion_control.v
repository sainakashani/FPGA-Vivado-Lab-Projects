module motion_control(
	input [3:0]z,
	input clk,
	input resetn,
	output reg x_next,
	output reg y_next
);
reg [7:0]x=80;
reg [6:0]y=60;
always@(posedge clk or negedge reset)begin
	if(!resetn)begin
		x_next<=80;
		y_next<=60;
	end
	else
	case(z)
    4'b1000:if(x<159) x_next<=x+1;  //right
    4'b0100:if(x>0) x_next<=x-1;  //left
    4'b0010:if(y<119) y_next<=y+1;     //down
    4'b0001:if(y>0) y_next<=y-1;     //up
    default: begin
             x_next<=x;
             y_next<=y;
        end
        endcase
end
endmodule