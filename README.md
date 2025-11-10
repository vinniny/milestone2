# RISC-V Single-Cycle Processor - Milestone 2# RISC-V Single-Cycle Processor - DE-10 Standard FPGA



This project implements a RISC-V RV32I single-cycle processor with memory-mapped I/O and a BCD stopwatch demonstration.A complete RISC-V RV32I processor implementation with 6-digit stopwatch demonstration running on the Terasic DE-10 Standard FPGA board.



## 📁 Project Structure---



```## 🎯 Project Overview

riscv/

├── 00_src/          # RTL source files (Verilog/SystemVerilog)This project implements a single-cycle RISC-V processor with Harvard architecture (separate instruction and data memory) designed for the DE-10 Standard FPGA. The demonstration program is an optimized 6-digit stopwatch that counts from 000000 to 999999 on the board's 7-segment displays.

├── 01_bench/        # Testbenches

├── 02_test/         # Test programs and hex files### Key Features

├── 03_sim/          # Simulation scripts and configuration- **Processor**: RISC-V RV32I instruction set architecture

└── 04_doc/          # Documentation- **Architecture**: Single-cycle, Harvard (separate IMEM/DMEM)

```- **Clock**: 50 MHz input → 10 MHz processor clock (divide-by-5)

- **Display**: 6× 7-segment displays (HEX5-HEX0)

## 🚀 Quick Start- **I/O**: Memory-mapped switches, buttons, LEDs, and displays

- **Demo**: Optimized stopwatch with pause/resume and reset controls

### Running the Stopwatch Test

---

```bash

cd 03_sim## 🎮 Stopwatch Controls

./run_hexled_test.sh

```| Control | Function | Description |

|---------|----------|-------------|

This will:| **SW[0]** | Pause/Resume | ON = Pause counting, OFF = Resume |

1. Compile the testbench with the stopwatch program| **KEY[0]** | Reset Counter | Press to reset display to 000000 |

2. Run comprehensive tests (display, BCD encoding, pause/resume, etc.)| **KEY[1]** | System Reset | Emergency processor reset |

3. Display results with ✅/❌ indicators

### Display Behavior

### Expected Output- **Range**: 000000 to 999999 (1 million counts)

- **Update Rate**: 1 count per second

```- **Format**: Leading zeros displayed (e.g., 000042)

╔══════════════════════════════════════════════════════════════╗- **Wraparound**: Automatically resets to 000000 after 999999

║  ✅✅✅  ALL TESTS PASSED - HEXLED FULLY FUNCTIONAL  ✅✅✅  ║

╚══════════════════════════════════════════════════════════════╝---



✓ Display encoding: CORRECT## 📁 Project Structure

✓ Counter logic: WORKING

✓ Pause/Resume: FUNCTIONAL```

✓ Memory I/O: VERIFIEDriscv/

✓ Edge cases: HANDLED├── 00_src/              # RTL source files

```│   ├── wrapper.sv       # Top-level DE-10 interface

│   ├── clock_25M.sv     # Clock divider (50MHz → 10MHz)

## 📊 Test Programs│   ├── single_cycle.sv  # RISC-V processor core

│   ├── control_unit.sv  # Instruction decoder

### `stopwatch.s` / `stopwatch_fast.hex`│   ├── alu.sv          # Arithmetic logic unit

**Full BCD Stopwatch** (270 instructions)│   ├── regfile.sv      # 32× 32-bit register file

- Format: MM:SS:CC (minutes:seconds:centiseconds)│   ├── i_mem.sv        # Instruction memory

- Range: 00:00:00 to 99:59:99│   ├── dmem.sv         # Data memory

- Pause/Resume: SW[0] (0=pause, 1=run)│   ├── lsu.sv          # Load/store unit

- Display: HEX5-HEX0 with proper 7-segment encoding│   └── ...             # Other modules

- Features:│

  - BCD rollover logic (centiseconds 0-99, seconds 0-59, minutes 0-99)├── 01_bench/           # Testbench files

  - Inline digit-to-7segment conversion│   ├── tbench.sv       # Top-level testbench

  - No function calls (compatible with simple single-cycle processor)│   ├── driver.sv       # Test driver

│   └── scoreboard.sv   # Result checker

### ISA Test Programs│

- `isa_1b.hex` - ISA tests (1-byte data)├── 02_test/            # Test programs (hex format)

- `isa_4b.hex` - ISA tests (4-byte data)│   ├── counter_v2.hex  # Optimized stopwatch (244 instructions)

│   ├── isa_1b.hex      # ISA test program

## 🧪 Testbench│   └── isa_4b.hex      # ISA test program

│

### `tb_hexled.sv` - Comprehensive HEXLED Test Suite├── 03_sim/             # Simulation files

│   ├── makefile        # Build automation

**10 Test Categories:**│   ├── flist           # File list for compilation

1. ✅ Initialization & Reset│   └── dump.vcd        # Waveform output

2. ✅ Display Validation (all digits 0-9 or blank)│

3. ✅ 7-Segment Encoding Validation└── 04_doc/             # Documentation

4. ✅ First Counter Increment    ├── README.md              # This file

5. ✅ Multiple Increment Sequence    ├── STOPWATCH_README.md    # Quick reference guide

6. ✅ Pause Functionality (SW[0]=0)    ├── DEPLOYMENT_CHECKLIST.md # Complete deployment guide

7. ✅ Resume Functionality (SW[0]=1)    ├── STOPWATCH_OPTIMIZATIONS.md # Technical optimization details

8. ✅ Memory-Mapped I/O Addresses    └── de10_pin_assign.qsf    # Quartus pin assignments

9. ✅ Edge Cases & Boundary Conditions```

10. ✅ Performance & Timing

---

**Key Features:**

- BCD value tracking (not decimal)## 🚀 Quick Start

- Handles blank displays (0x7F)

- Pause settling time (handles in-flight instructions)### Prerequisites

- Proper rollover detection (BCD wraps at 10, not monotonic)- **Hardware**: Terasic DE-10 Standard FPGA board

- **Software**: Intel Quartus Prime (tested with Standard Edition)

## 🔧 Building & Running- **Cable**: USB-Blaster programming cable



### Option 1: Using the test script (Recommended)### Deployment Steps

```bash

cd 03_sim1. **Open Project**

./run_hexled_test.sh   ```

```   Open your Quartus project file (.qpf)

   ```

### Option 2: Manual compilation

```bash2. **Set Top-Level Entity**

cd 03_sim   - Set `wrapper.sv` as the top-level design entity

iverilog -g2012 -o sim_hexled.vvp -f flist_hexled

vvp sim_hexled.vvp3. **Import Pin Assignments**

```   - Load `04_doc/de10_pin_assign.qsf` into your project

   - This maps all FPGA pins to board components

### Option 3: Using Make (for standard ISA tests)

```bash4. **Compile Design**

cd 03_sim   - Processing → Start Compilation

make          # Compile and run   - Wait for successful compilation (~5-10 minutes)

make clean    # Clean generated files

```5. **Program FPGA**

   - Tools → Programmer

## 📝 Memory Map   - Select USB-Blaster

   - Load `wrapper.sof` file

| Device    | Address Range              | Description           |   - Click Start to program

|-----------|----------------------------|-----------------------|

| HEX0-3    | 0x1000_2000 - 0x1000_2FFF | 7-segment displays    |6. **Test Stopwatch**

| HEX4-7    | 0x1000_3000 - 0x1000_3FFF | 7-segment displays    |   - Display should show `000000`

| Switches  | 0x1001_0000 - 0x1001_0FFF | SW[17:0] input        |   - Counting starts automatically (1 count/second)

| LEDR      | 0x1000_0000 - 0x1000_0FFF | Red LEDs output       |   - Test SW[0] for pause/resume

| LEDG      | 0x1000_1000 - 0x1000_1FFF | Green LEDs output     |   - Press KEY[0] to reset to 000000

| LCD       | 0x1000_4000 - 0x1000_4FFF | LCD display           |

---

## 🎯 Stopwatch Controls

## 🔧 Technical Specifications

- **SW[0] = 1**: Running (counter increments)

- **SW[0] = 0**: Paused (counter frozen)### Processor Core

- **KEY[0]**: Reset (hardware only, not in simulation)- **ISA**: RISC-V RV32I (32-bit base integer instruction set)

- **Architecture**: Single-cycle execution, Harvard memory

## 🔢 7-Segment Encoding- **Registers**: 32× 32-bit general purpose (x0-x31)

- **Memory**: 

| Digit | Code | Display |  - Instruction Memory: 16KB (4096 words)

|-------|------|---------|  - Data Memory: 16KB (4096 words)

| 0     | 0x40 | ⁰       |

| 1     | 0x79 | ¹       |### Clock System

| 2     | 0x24 | ²       |- **Input**: 50 MHz (CLOCK_50, PIN_AF14)

| 3     | 0x30 | ³       |- **Divider**: Divide-by-5 implementation

| 4     | 0x19 | ⁴       |- **Output**: 10 MHz processor clock

| 5     | 0x12 | ⁵       |- **Module**: `clock_25M.sv` (name is historical)

| 6     | 0x02 | ⁶       |

| 7     | 0x78 | ⁷       |### Memory Map

| 8     | 0x00 | ⁸       || Address Range | Device | Description |

| 9     | 0x10 | ⁹       ||--------------|--------|-------------|

| Blank | 0x7F | (off)   || 0x00000000 - 0x00003FFF | IMEM | Instruction memory (16KB) |

| 0x10000000 - 0x10003FFF | DMEM | Data memory (16KB) |

*Active-low encoding*| 0x10007020 | HEXL | 7-segment displays HEX2-HEX1-HEX0 |

| 0x10007024 | HEXH | 7-segment displays HEX5-HEX4-HEX3 |

## 🛠️ Development| 0x10017800 | Input | Switches SW[9:0] + Buttons KEY[3:0] |



### Creating New Test Programs### I/O Mapping

**Input Register (0x10017800):**

1. Write assembly in `02_test/yourprogram.s`- Bits [9:0]: SW[9:0] switches

2. Assemble:- Bits [13:10]: KEY[3:0] buttons (inverted to active-high)

   ```bash- Bits [31:14]: Reserved (read as 0)

   cd 02_test

   riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o yourprogram.o yourprogram.s**Output Registers:**

   riscv64-unknown-elf-objcopy -O binary yourprogram.o yourprogram.bin- 0x10007020: Lower 3 digits (HEX2-HEX1-HEX0)

   hexdump -v -e '1/4 "%08x\n"' yourprogram.bin > yourprogram.hex- 0x10007024: Upper 3 digits (HEX5-HEX4-HEX3)

   ```

3. Update `counter_v3_fast.hex` symlink or modify flist---



### Cleaning Up## 📊 Stopwatch Optimization



```bashThe stopwatch program (`counter_v2.hex`) has been optimized for size and performance:

cd 02_test && ./CLEANUP.sh  # Clean test directory

cd 03_sim && ./CLEANUP.sh   # Clean simulation directory### Performance Metrics

```- **Code Size**: 244 instructions (976 bytes)

- **Improvement**: 5.1% smaller than original (257 instructions)

## 📚 Documentation- **Speed**: 22% faster digit processing

- **Algorithm**: Early-exit search for 7-segment encoding

See `04_doc/` for additional documentation:

- STOPWATCH_IMPLEMENTATION.md - Detailed implementation notes### Key Optimizations

- milestone-2.md - Project requirements1. **Early-Exit Strategy**: Checks most common digits first (0, then 5)

2. **Harvard-Compatible**: Uses register-based lookup (no memory tables)

## ⚙️ Requirements3. **Minimal Overhead**: Direct calculation via division by 10

4. **Efficient Loops**: Calibrated timing for exactly 1.0 second per count

- **Icarus Verilog** (iverilog) - For simulation

- **RISC-V GNU Toolchain** (binutils-riscv64-unknown-elf) - For assemblySee `04_doc/STOPWATCH_OPTIMIZATIONS.md` for detailed technical analysis.

- **GTKWave** (optional) - For waveform viewing

---

### Installation (Ubuntu/Debian)

```bash## 🧪 Testing & Simulation

sudo apt install iverilog gtkwave binutils-riscv64-unknown-elf

```### ModelSim/Questa Simulation

```bash

## 🎓 Key Implementation Detailscd 03_sim

make clean

### BCD Rollover Logicmake compile

```make simulate

Centiseconds: 00 -> 99 -> 00 (ones: 0-9, tens: 0-9)```

Seconds:      00 -> 59 -> 00 (ones: 0-9, tens: 0-5)

Minutes:      00 -> 99 -> 00 (ones: 0-9, tens: 0-9)### Waveform Analysis

```- Output: `03_sim/dump.vcd`

- View with GTKWave or ModelSim

### Testbench Improvements

- ✅ **Packed BCD representation** instead of decimal### Hardware Testing

- ✅ **Blank display support** (0x7F = valid)1. **Power-On Test**: Display shows 000000

- ✅ **Pause settling time** (100 cycles for in-flight instructions)2. **Counting Test**: Increments every second

- ✅ **Successive change tracking** for pause test3. **Pause Test**: SW[0] ON freezes display

- ✅ **BCD boundary handling** (no monotonic assumption)4. **Reset Test**: KEY[0] returns to 000000

5. **Wraparound**: Verify 999999 → 000000

## 📊 Performance

---

- **Stopwatch program**: 270 instructions

- **Increment period**: ~83 cycles (fast simulation version)## 🐛 Troubleshooting

- **Testbench runtime**: ~5600 cycles

- **All tests**: PASSING ✅### Display Shows All Segments Lit/Dark

- **Cause**: 7-segment polarity mismatch

## 🐛 Troubleshooting- **Fix**: Verify active-low encoding (0x40=0, 0x79=1, etc.)



### "counter_v3_fast.hex not found"### Wrong Count Speed

```bash- **Cause**: Clock frequency mismatch

cd 02_test- **Fix**: Verify clock divider outputs 10 MHz

ln -sf stopwatch_fast.hex counter_v3_fast.hex- **Adjust**: Modify `counter_v2.hex` line 226 for timing

```

### Display Frozen at 000000

### "Simulation produces no output"- **Cause**: Clock not toggling or processor held in reset

Check that scoreboard early $finish is disabled in `01_bench/scoreboard.sv`- **Check**: 

  - LEDR[9] should blink (instruction valid indicator)

### "VCD file too large"  - Release KEY[1] (processor reset)

Delete with `rm 03_sim/dump.vcd` (regenerated on next run)  - Verify clock divider is running



## 📄 License### Some Digits Missing

- **Cause**: Pin assignment or address decode issue

Educational project - RISC-V Processor Implementation- **Fix**: 

  - Reload pin assignments from `.qsf` file

## 👤 Author  - Check `output_buffer.sv` address decode logic



Milestone 2 Implementation - BCD Stopwatch with Comprehensive TestingSee `04_doc/DEPLOYMENT_CHECKLIST.md` for complete troubleshooting guide.


---

## 📚 Documentation

- **[STOPWATCH_README.md](04_doc/STOPWATCH_README.md)** - Quick reference for stopwatch controls and specs
- **[DEPLOYMENT_CHECKLIST.md](04_doc/DEPLOYMENT_CHECKLIST.md)** - Step-by-step deployment guide with verification
- **[STOPWATCH_OPTIMIZATIONS.md](04_doc/STOPWATCH_OPTIMIZATIONS.md)** - Detailed optimization strategy and analysis

---

## 🔌 Hardware Requirements

### DE-10 Standard FPGA Board Components Used
- **FPGA**: Intel Cyclone V 5CSXFC6D6F31C6
- **Clock**: 50 MHz oscillator
- **Switches**: SW[0] for pause/resume
- **Buttons**: KEY[0] for reset, KEY[1] for system reset
- **Displays**: HEX5-HEX0 (6× 7-segment, common anode)
- **LEDs**: LEDR[9:0] for status (optional)

### Pin Assignments
All pin assignments are defined in `04_doc/de10_pin_assign.qsf`. Key pins:
- CLOCK_50: PIN_AF14
- SW[0]: PIN_AB30
- KEY[0]: PIN_AJ4 (counter reset)
- KEY[1]: PIN_AK4 (processor reset)
- HEX0-HEX5: 42 pins total (7 segments × 6 displays)

---

## 🎓 Educational Value

This project demonstrates:
- **Computer Architecture**: Single-cycle RISC-V processor design
- **Digital Logic**: RTL design with SystemVerilog
- **Memory Systems**: Harvard architecture with memory-mapped I/O
- **FPGA Development**: Complete workflow from RTL to hardware
- **Algorithm Optimization**: Code size and performance tradeoffs
- **Hardware/Software Interface**: Memory-mapped I/O programming

---

## 📝 License

Educational project for computer architecture coursework.

---

## 🙏 Acknowledgments

- RISC-V International for the open ISA specification
- Terasic for DE-10 Standard board documentation
- Intel for Quartus Prime development tools

---

## 📞 Support

For issues or questions:
1. Check `04_doc/DEPLOYMENT_CHECKLIST.md` troubleshooting section
2. Verify all pin assignments are loaded
3. Confirm clock divider is producing 10 MHz output
4. Review simulation waveforms for debugging

---

**Status**: ✅ Fully verified and ready for deployment  
**Last Updated**: November 8, 2025  
**Version**: Milestone 2 - Optimized Stopwatch
