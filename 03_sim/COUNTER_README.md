# RISC-V Counter for 7-Segment HEX Display

## Overview
This is a simple counter program that counts from 0 to 15 and displays the value on a 7-segment HEX LED display through memory-mapped I/O.

## Files Created

### 1. **counter_v2.hex** - Main Program
Located at: `/home/vinniny/projects/riscv/02_test/counter_v2.hex`

**Program Flow**:
```assembly
# Initialize counter
li  x5, 0              # x5 = counter (0-15)
lui x6, 0x10007        # x6 = upper address bits  
addi x6, x6, 0x020     # x6 = 0x10007020 (HEXL memory-mapped address)

# Main loop
sw   x5, 0(x6)         # Write counter value to HEXL register
  
# Small delay loop (10 cycles)
li   x7, 0             # x7 = delay counter
li   x8, 10            # x8 = delay limit
delay:
  addi x7, x7, 1       # Increment delay counter
  blt  x7, x8, delay   # Loop if x7 < 10
  
# Increment and check
addi x5, x5, 1         # counter++
li   x8, 16            # x8 = 16
bne  x5, x8, main_loop # If counter != 16, continue

# Reset counter
li   x5, 0             # Reset to 0
j    main_loop         # Jump back
```

**Machine Code (Hex)**:
```
00000293  // li x5, 0
10007337  // lui x6, 0x10007
02030313  // addi x6, x6, 0x020
00532023  // sw x5, 0(x6)
00000393  // li x7, 0
00A00413  // li x8, 10
00138393  // addi x7, x7, 1
FE83CEE3  // blt x7, x8, -4
00128293  // addi x5, x5, 1
01000413  // li x8, 16
FC829EE3  // bne x5, x8, -24
00000293  // li x5, 0
FC5FF06F  // j -60
```

### 2. **counter_tb.sv** - Testbench
Located at: `/home/vinniny/projects/riscv/03_sim/counter_tb.sv`

Monitors the HEX0 output and displays changes.

### 3. **i_mem_counter.sv** - Custom Instruction Memory
Located at: `/home/vinniny/projects/riscv/03_sim/i_mem_counter.sv`

Loads the counter program instead of the ISA test suite.

## Memory-Mapped I/O Addresses

According to the LSU design:

| Device | Address | Description |
|--------|---------|-------------|
| LEDR | 0x10007000 | Red LEDs |
| LEDG | 0x10007010 | Green LEDs |
| HEXL | 0x10007020 | 7-segment digits 0-3 (low) |
| HEXH | 0x10007024 | 7-segment digits 4-7 (high) |
| LCD  | 0x10007030 | LCD display |
| SW   | 0x10017800 | Switch inputs |

**Note**: The addresses in `lsu.sv` are defined with localparam using 16-bit values:
```systemverilog
localparam HEXL = 16'h7020;  // Actually 0x1000_7020
```

The full address is constructed by the address decoder in `input_mux.sv` which checks:
- Upper 20 bits for I/O region (0x10007 or 0x10017)
- Lower 12 bits for specific device

## How to Run

### Compile and Simulate:
```bash
cd /home/vinniny/projects/riscv/03_sim
make -f counter_makefile clean
make -f counter_makefile compile
make -f counter_makefile sim
```

### View Waveforms:
```bash
make -f counter_makefile wave
# or
gtkwave counter.vcd &
```

## Expected Behavior

The counter should:
1. Start at 0
2. Increment every ~10-15 clock cycles (with delay loop)
3. Display values 0 through 15 on HEX0
4. Wrap back to 0 after reaching 15
5. Continue indefinitely

## Debugging Notes

**Current Status**: The simulation runs but HEX0 shows 0x00.

**Potential Issues**:
1. **7-Segment Encoding**: The counter writes raw binary values (0-15), but 7-segment displays typically need segment encoding (7 bits: a-g segments).
2. **Output Buffer Logic**: The `output_buffer.sv` module handles the write to HEXL, need to verify it's receiving the stores.
3. **Address Decode**: Verify that writes to 0x10007020 are properly decoded as HEXL writes.

**Signals to Check in Waveform**:
- `dut.lsu_inst.f_io_wren` - Should pulse when storing to I/O
- `dut.lsu_inst.b_io_hexl` - Should show the buffered value
- `dut.lsu_inst.u1.f_io_wren` - Output buffer write enable
- `io_hex0` - Final output (7-bit, should change)

**Quick Test**: Modify counter to write to LED registers (0x10007000) instead, which are simpler (32-bit direct):
```assembly
lui  x6, 0x10007      # x6 = 0x10007000 (LEDR)
sw   x5, 0(x6)        # Write to LEDR
```

## 7-Segment Display Encoding

For actual hardware, the 7-segment needs segment encoding:

```
Digit 0: 0x3F (segments a,b,c,d,e,f)
Digit 1: 0x06 (segments b,c)
Digit 2: 0x5B (segments a,b,d,e,g)
... etc
```

The testbench currently monitors raw HEX0 bits. The processor writes raw binary values (0-F), and the output_buffer module should handle the segment packing.

## Alternative: Simple LED Counter

For easier verification, here's a version that uses LEDs instead:

**File**: `counter_led.hex`
```
00000293  // li x5, 0
10007337  // lui x6, 0x10007    (LEDR at 0x10007000)
00532023  // sw x5, 0(x6)
00000393  // li x7, 0
00A00413  // li x8, 10
00138393  // addi x7, x7, 1
FE83CEE3  // blt x7, x8, -4
00128293  // addi x5, x5, 1
FEDFF06F  // j -20 (back to sw)
```

This continuously increments and displays on the 32-bit LED register, which is simpler to observe.

