
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saideep 
// 
// Create Date: 01.09.2024 21:27:59
// Design Name: 
// Module Name: PWM Servo Sweep
// Project Name: Controlling Servo using PWM
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module servo(
input clk, rst,
output reg servo
    ); 
    
/*************************************************************************************/
//This clk_ns Prescallar is to move Servo by 1 degree  for every Clk tick;
//As per Micro Servo Data Sheet -90 to 90 is 1ms to 2ms, Difference is 1ms.So it takes 1ms from -90 to 90 
// For 1 degree => 1ms / 180 = 5560ns  we are taking 10000ns or 100KHz
//As System Clock is running at 100MHz which is 10ns. To achieve the Frequency of 100KHz: 10000ns/10ns => 1000 Ticks
/*************************************************************************************/
reg [19:0] Tick_ns = 0;
parameter Prescallar_ns = 500; //1000/2  On Pulse + Off Pulse
reg clk_ns = 0;
always@(posedge clk) begin

if(Tick_ns < Prescallar_ns) begin
Tick_ns = Tick_ns+1;
end

else begin
clk_ns <= ~clk_ns; //For every 10000ns or 1000 Ticks
Tick_ns <= 0;
end

end


 //To Generate a Pulse of 1ms and Period of 20ms
parameter Period = 2000;                         // 2000 * 10000 => 20ms Period
reg flag = 1;
reg [15:0] counter = 0;
reg [15:0] Ton = 0;

always@(posedge clk_ns)
if(rst) begin
counter <= 0;
Ton <= 1;                                        
flag <= 1;                                       //set flag = 1 for UP 0-180 , flag = 0 for 180-0 DOWN
end

else begin
    if(counter < ('d100 + Ton)) begin            //('d100 + Ton2)) => 1ms + 1000ns
    servo <= 1'b1;
    counter <= counter+1;
    end
      
    else if(counter < Period) begin              // To maintain 20ms Period
    servo <= 1'b0;
    counter <= counter+1;
    end
      
    else begin
    counter <= 0;
        if(Ton == 100) flag <= 0;
        else if(Ton == 1) flag <= 1;

        if(flag == 1) Ton <= Ton + 1; // 0-180   // this value  can be change according to speed!
        else Ton <= Ton - 1; //180-0              // this value can be change according to speed!
      
    end

end

endmodule


