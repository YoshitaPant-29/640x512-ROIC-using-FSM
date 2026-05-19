# 640x512-ROIC-using-FSM
640×512 ROIC — System Overview

Detector array captures the infrared scene and generates weak photocurrent signals proportional to incident radiation.
Analog front end (AFE) receives photocurrent signals; an integration capacitor accumulates charge during a controlled integration window, and a source follower buffers the integrated voltage for downstream readout.
Correlated double sampling (CDS) eliminates kTC noise and fixed-pattern offset by subtracting the reset-level sample from the signal-level sample before the voltage leaves the pixel.
Verilog FSM digital controller sequences the entire readout by driving a 512-bit one-hot row shift register and a 640-bit one-hot column shift register, ensuring glitch-free pixel selection and precise timing of integration, sampling, and readout signals.
Digitization is performed either on-chip via a column-parallel ADC bank or off-chip, depending on the system architecture.
Image-processing pipeline applies non-uniformity correction (NUC), offset correction, bad-pixel replacement, and contrast enhancement to the raw digital frame before final output.
<img width="855" height="546" alt="image" src="https://github.com/user-attachments/assets/04d561ad-0059-4ab8-952a-968fd2c5a85e" />

This repository contains the hardware description language (HDL) code for the digital architecture of a 640x512 Readout Integrated Circuit (ROIC), a crucial component in infrared image sensors. The primary goal of this project is to design an optimized digital readout mechanism that efficiently processes pixel data while meeting stringent timing, power, and area constraints.
The digital design incorporates a Finite State Machine (FSM)-based control logic to systematically access pixel data in a sequential manner. Additionally, counters, multiplexers (MUX), and decoders are utilized to optimize the column-wise readout process. The design focuses on achieving minimal latency, efficient clock cycle utilization, and reduced power consumption to enhance overall system performance.
The current work involves implementing this architecture using Verilog RTL coding and performing functional verification and timing analysis. 
The optimization goals include achieving a column access time of 70 µs, enabling high-speed data transfer suitable for real-time imaging applications.

<img width="734" height="716" alt="image" src="https://github.com/user-attachments/assets/d706c816-b9e1-4e2b-a945-f345931f1b56" />
<img width="440" height="348" alt="image" src="https://github.com/user-attachments/assets/cfef4abb-8225-4fe5-8e55-5d8dd30bf2d8" />
