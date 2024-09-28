# RTL Design and Implementation for Precision Servo Motor Control using PWM on Nexys 4 DDR FPGA in Verilog!



This project implements PWM (Pulse Width Modulation) to control the movement of a servo motor. The code is designed to sweep the servo from -90° to 90° by generating a PWM signal with a specific duty cycle. The code is written in Verilog and intended for FPGA-based designs.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Hardware used](#hardware-used)
- [Code Description](#code-description)

## Overview

This project controls a servo motor using a PWM signal. It generates a pulse width of 1ms to 2ms with a period of 20ms to rotate the servo between -90° and 90°. The movement is controlled by adjusting the duty cycle of the PWM signal.

## Features

- Generates a PWM signal to control the servo motor.
- Sweeps the servo from -90° to 90°.
- Adjustable speed of the servo sweep.
- Reset functionality to restart the sweep cycle.

## Getting Started

To get started with this project, you need to have a working FPGA development environment with support for Verilog. This project is configured to work with a 100 MHz clock source to achieve the necessary timing for PWM control.


## Hardware Used

- **Nexus 4 DDR FPGA**: The primary FPGA board used for deploying the design.
- **Servo Motor**: (Tower Pro 9g)
- **External Power Supply**: The Nexus 4 DDR FPGA board's power supply is insufficient to drive the servo motor directly, which is why an external power supply was used to provide the necessary power.


## Software Used

- **Vivado** 


## Code Description

The main module (`servo`) contains the logic to generate the required PWM signal for controlling a servo motor. Here’s a breakdown of the key components of the code:

- **Tick Generation**: 
  The `clk_ns` prescaler reduces the system clock frequency (100 MHz) to 100 kHz, which is used to move the servo by 1 degree for each clock tick.
  ```
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
  ```

- **PWM Pulse Generation**: 
  The PWM signal is generated with a period of 20ms, and the pulse width varies from 1ms (for -90°) to 2ms (for +90°).

  ```
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

  ```

- **`flag`:**  
  Controls the direction of the servo sweep.  
  - If `flag = 1`, the servo moves **upward** from 0° to 180°.  
  - If `flag = 0`, the servo moves **downward** from 180° to 0°.

- **`counter`:**  
  Counts clock ticks to manage the timing for the PWM signal.

- **`Ton`:**  
  Represents the on-time (pulse width) of the signal, controlling the position of the servo.

- **Reset Behavior:**  
  When reset, the `counter` is set to 0, `Ton` is initialized to 1, and `flag` is set to 1, starting an upward sweep.

- **Increment Block:**  
  The PWM signal starts with a 1ms pulse (for -90°) and increments `Ton` step by step until it reaches 2ms (for +90°). After reaching 180°, the `flag` is set to 0, and the sweep reverses, moving the servo from 180° back to 0°. Each pulse is followed by a 20ms period to ensure smooth operation.



## Demo



********************************************************************************************
![demo1](https://github.com/user-attachments/assets/5716d3de-3367-416d-b3d6-9ee093bfc023)

![demo2](https://github.com/user-attachments/assets/a884e000-de8c-421b-8c80-dbe908010dab)

