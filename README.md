# 640x512-ROIC-using-FSM

<img width="855" height="546" alt="image" src="https://github.com/user-attachments/assets/04d561ad-0059-4ab8-952a-968fd2c5a85e" />

## ROIC Digital Controller — 640×512 Infrared Image Sensor Readout
A Verilog implementation of the digital readout controller for a 640×512 ROIC (Readout Integrated Circuit), designed to mimic how real infrared image sensors sequence pixel data output. Built and verified on EDA Playground using Icarus Verilog.

### What This Project Does
An infrared image sensor cannot output all 327,680 pixels at once. Instead, a digital controller activates one row at a time and scans through all 640 columns in that row before moving to the next. This project implements that controller using:

A Finite State Machine (FSM) that controls the scan sequence
One-hot shift registers that activate exactly one row and one column at a time
Integer counters that track position within the 640×512 grid
A SystemVerilog testbench with scoreboard, assertions, and functional coverage

### System Architecture

clk ──┐
rst ──┤──► FSM Controller ──► Row Shift Register (512-bit) ──► row_enable[511:0]
      │         │
      │         └──────────► Col Shift Register (640-bit) ──► col_enable[639:0]
      │
      └── Counters: row_count (0→511), col_count (0→639)

### FSM State Machine
The FSM drives the entire readout sequence through five states:
IDLE ──► ROW_ENABLE ──► COL_ENABLE ──► NEXT_ROW ──► DONE
                             │               │
                             └───── col < 639 ┘  (inner loop)
                                    row < 511       (outer loop)
One-Hot Shift Register Logic
Rather than using a binary decoder, both enable buses use a shift register pattern:
verilog// Column scan — shifts '1' left each clock
col_enable <= col_enable << 1;

// Row advance — shifts '1' left when moving to next row
row_enable <= row_enable << 1;

This produces a glitch-free one-hot output at every clock edge:
Clock 1:  col_enable = 640'b000...0001  (col 0 active)
Clock 2:  col_enable = 640'b000...0010  (col 1 active)
Clock 3:  col_enable = 640'b000...0100  (col 2 active)
  ...
Clock 640: col_enable = 640'b100...0000  (col 639 active)
→ NEXT_ROW: row_enable shifts, col_enable reloads from bit 0
### -->Timing Parameter:
Timing Parameter        Value
Clock frequency        10 MHz
Clock period           100 ns
Columns per row        640
Rows per frame         512
Total pixels per frame 327,680
Time per frame (no integration)~ 32.8 ms

### --Verification Environment
The testbench (tb_roic_shift.sv) implements a complete verification environment targeting Icarus Verilog on EDA Playground.
Scoreboard
An independent expected model tracks the correct row_enable and col_enable value at every clock edge. The scoreboard compares the DUT output against the model and flags any mismatch using $error:
verilog// Compare first, then advance — avoids one-cycle phase slip
assert (col_enable === (640'b1 << expected_col))
  else $error("Col mismatch: got %0h exp col=%0d at %t", ...);

if (expected_col < COLS-1) expected_col++;
else begin expected_col = 0; expected_row++; end

### --Functional Coverage
Coverage is taken on counter indices (not raw enable buses) to avoid 2^640 bin explosion:
verilogcovergroup cg_scan @(posedge clk);
  cp_col:   coverpoint col_cnt  { bins all_cols[] = {[0:COLS-1]}; }
  cp_row:   coverpoint row_cnt  { bins all_rows[] = {[0:ROWS-1]}; }
  cp_state: coverpoint state    { bins idle=IDLE; bins scan=SCAN; bins done=DONE; }
  cx_row_col: cross cp_row, cp_col; // every (row, col) combination
endgroup


### --Key Design Decisions
Why one-hot shift registers instead of a binary counter + decoder?
A shift register produces glitch-free one-hot outputs with no combinational decode delay on the critical path. It also makes the verification assertion trivial — $onehot0(col_enable) covers the entire correctness requirement in one line.
Why cover col_cnt instead of col_enable in the covergroup?
Covering a 640-bit bus directly creates 2^640 possible bins. Covering the 10-bit counter index instead produces exactly 640 meaningful bins, one per column position, and closes to 100% after a single full scan.
Why a LAST state between SCAN and DONE?
Without it, the FSM transitions to DONE on the same clock cycle that the final pixel's enables are asserted. Any downstream logic with even one cycle of pipeline latency would miss the last pixel. The LAST state holds enables for one extra cycle before going dark.

### --Concepts Demonstrated

1.Finite State Machine design in Verilog (typedef enum, always_ff)

2.One-hot shift register generation using bit-shift (<<)

3.Parameterized design with $clog2 for synthesizable counter sizing

4.SystemVerilog Assertions (SVA) with property, assert property, disable iff

5.Functional coverage with covergroup, coverpoint, cross coverage

6.Scoreboard-based verification with independent expected model

7.VCD waveform generation for GTKWave inspection


<img width="734" height="716" alt="image" src="https://github.com/user-attachments/assets/d706c816-b9e1-4e2b-a945-f345931f1b56" />
<img width="440" height="348" alt="image" src="https://github.com/user-attachments/assets/cfef4abb-8225-4fe5-8e55-5d8dd30bf2d8" />
