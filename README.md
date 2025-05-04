# 640x512-ROIC-using-FSM

This repository contains the hardware description language (HDL) code for the digital architecture of a 640x512 Readout Integrated Circuit (ROIC), a crucial component in infrared image sensors. The primary goal of this project is to design an optimized digital readout mechanism that efficiently processes pixel data while meeting stringent timing, power, and area constraints.

The digital design incorporates a Finite State Machine (FSM)-based control logic to systematically access pixel data in a sequential manner. Additionally, counters, multiplexers (MUX), and decoders are utilized to optimize the column-wise readout process. The design focuses on achieving minimal latency, efficient clock cycle utilization, and reduced power consumption to enhance overall system performance.

The current work involves implementing this architecture using Verilog RTL coding and performing functional verification and timing analysis. 
The optimization goals include achieving a column access time of 70 µs, enabling high-speed data transfer suitable for real-time imaging applications.
