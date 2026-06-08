module seg(
    input clk,
    input reset,
    output reg[3:0]dig,
    output reg[6:0]abcdefg
);
reg [19:0]t=0;
always@(posedge clk)begin
    if(reset)begin
        t<=0;
        abcdefg<=0;
        dig<=4'b0;
    end
    else begin
        t<=t+1;
        if(t>50000 &&t<100000)begin
            abcdefg<=~(7'b0000110);
            dig<=4'b0001;
        end
        else if(t>100000&&t<150000)begin
            abcdefg<=~(7'b1101101);
            dig<=4'b0010;
        end
        else if(t>150000&&t<200000)begin
            abcdefg<=~(7'b1111001);
            dig<=4'b0100;
        end
        else if(t>200000&&t<250000)begin
            abcdefg<=~(7'b0110011);
            dig<=4'b1000;
            t<=0;
        end
    end
end
endmodule





    
