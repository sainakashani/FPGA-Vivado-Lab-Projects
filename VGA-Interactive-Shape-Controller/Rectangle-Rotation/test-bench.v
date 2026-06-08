`timescale 1ns / 1ps

module scrolling_tb;
    reg CLOCK_50;
    reg [3:0] KEY;  // دکمه‌های ورودی
    wire [7:0] x, y;
    wire vertical;
    
    // نمونه‌سازی از ماژول اصلی
    scrolling uut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .x(x),
        .y(y),
        .vertical(vertical)
    );

    // تولید کلاک 50MHz
    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        $dumpfile("scrolling.vcd");  // برای مشاهده در GTKWave
        $dumpvars(0, scrolling_tb);
        
        CLOCK_50 = 0;
        KEY = 4'b1111; // همه دکمه‌ها آزاد

        // ریست کردن
        #20 KEY[0] = 0; #20 KEY[0] = 1;
        
        // حرکت به راست (افقی شود)
        #50 KEY = 4'b0001; #20 KEY = 4'b1111;
        
        // حرکت به چپ (افقی شود)
        #50 KEY = 4'b0100; #20 KEY = 4'b1111;
        
        // حرکت به بالا (عمودی شود)
        #50 KEY = 4'b1000; #20 KEY = 4'b1111;
        
        // حرکت به پایین (عمودی شود)
        #50 KEY = 4'b0010; #20 KEY = 4'b1111;
        
        // پایان شبیه‌سازی
        #500 $finish;
    end
endmodule
