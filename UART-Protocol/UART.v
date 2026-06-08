module uart_data_gnerator(
    parameter clk_freq=50000000,
    parameter baud_rate=9600,
    input clk,
    input reset,
    output reg baud_tick
);
localparam integer count_max=clk_freq/baud_rate;
reg [31:0]count;
always@(posedge clk)begin
    if(reset)begin
        count<=0;
        baud_tick<=0;
    end 
    else
    begin
        if(count>=(count_max>>1))begin
            baud_tick<=~baud_tick;
            count<=0;
        end
        else
        begin
            count<=count+1;
        end
    end
end
endmodule




module TX(
    input clk,
    input reset,
    input send,
    input [3:0]SW,
    output reg tx
);
reg [6:0]data;
reg [3:0]bitpos;
reg sending;
always@(posedge clk)begin
    if(reset)begin
        sending<=0;
        bitpos<=0;
        tx<=1;
    end
    else if(start&&!sending)begin
        data<={1'b1,^{SW,3'b000},SW,1'b0};
        sending<=1;
        bitpos<=0;
    end else if(sending)begin
        tx<=data[bitpos];
        bitpos<=bitpos+1;
        if(bitpos==10) sending<=0;
    end
end
endmodule





module RX(
    input clk,
    input reset,
    input rx,
    output reg [3:0] leds
);
    reg [10:0] shift_reg;
    reg [3:0] bit_pos = 0;
    reg receiving = 0;

    always @(posedge clk) begin
        if (reset) begin
            receiving <= 0;
            bit_pos <= 0;
            leds <= 4'b0000;
        end else begin
            if (!rx && !receiving) begin
                receiving <= 1; 
                bit_pos <= 0;
            end else if (receiving) begin
                shift_reg[bit_pos] <= rx;
                bit_pos <= bit_pos + 1;
                if (bit_pos == 10) begin
                    receiving <= 0;
                    leds <= shift_reg[6:3];
                end
            end
        end
    end
endmodule



module top (
    input clk, reset, button, rx,
    input [3:0] switches,
    output tx,
    output [3:0] leds
);
    wire baud_tick;
    uart_data_gnerator #(.clk_freq(50000000), .baud_rate(9600)) u1 (
        .clk(clk), .reset(reset), .baud_tick(baud_tick)
    );
    tx u2 (
        .clk(baud_tick), .reset(reset), .send(button),.SW(switches), .tx(tx)
    );
   RX u3 (
        .clk(baud_tick), .reset(reset), .rx(rx),.leds(leds)
    );
endmodule















