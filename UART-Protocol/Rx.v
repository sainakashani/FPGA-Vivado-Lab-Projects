// File: Uart_controller_Rx.v
`timescale 1ns / 1ps
module Uart_controller_Rx (
    input        clk,
    input        reset_n,
    input        Rx_data,
    output reg [3:0] recieved_data,
    output reg      data_recieving_done
);
    
    parameter clk_freq  = 50_000_000;
    parameter baud_rate = 9_600;
    localparam integer clkperbit = clk_freq / baud_rate;
    
    localparam [1:0]
      Rx_idle      = 2'b00,
      Rx_start     = 2'b01,
      Rx_data_recv = 2'b10,
      Rx_stop      = 2'b11;
      
    reg [1:0]  Rx_state;
    reg [35:0] count;
    reg [2:0]  bit_index;
    reg        data_ready;
    reg [6:0]  data_buffer;
    reg [6:0]  sampler;  

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sampler <= 7'h7F;  
        else
            sampler <= {sampler[5:0], Rx_data};
    end
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            Rx_state    <= Rx_idle;
            count       <= 0;
            bit_index   <= 0;
            data_ready  <= 1'b0;
        end else begin
            data_ready <= 1'b0;
            case (Rx_state)
                Rx_idle: begin
                    count     <= 0;
                    bit_index <= 0;
                    // detect falling edge: sampler[6]=1 -> sampler[5]=0
                    if (sampler[6] && !sampler[5])
                        Rx_state <= Rx_start;
                end
                Rx_start: begin
                    count <= count + 1;
                    if (count >= clkperbit/2) begin
                        count    <= 0;
                        Rx_state <= Rx_data_recv;
                    end
                end
                Rx_data_recv: begin
                    count <= count + 1;
                    if (count >= clkperbit) begin
                        count               <= 0;
                        data_buffer[bit_index] <= Rx_data;
                        bit_index           <= bit_index + 1;
                        if (bit_index == 6)
                            Rx_state <= Rx_stop;
                    end
                end
                Rx_stop: begin
                    count <= count + 1;
                    if (count >= clkperbit) begin
                        data_ready <= 1'b1;
                        Rx_state   <= Rx_idle;
                    end
                end
                default: Rx_state <= Rx_idle;
            endcase
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            recieved_data       <= 0;
            data_recieving_done <= 1'b0;
        end else begin
            if (data_ready) begin
                recieved_data       <=~data_buffer[6:3];
                data_recieving_done <= 1'b1;
            end else begin
                data_recieving_done <= 1'b0;
            end
        end
    end

endmodule