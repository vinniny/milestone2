# 6-Digit Stopwatch - Quick Reference

## Features
- **Display:** 000000 to 999999 on HEX5-HEX4-HEX3-HEX2-HEX1-HEX0
- **Count Speed:** ~1 second per increment (10MHz clock)
- **Auto-wrap:** Resets to 000000 after 999999

## Controls
| Control | Function |
|---------|----------|
| **SW[0]** | ON = Pause, OFF = Resume counting |
| **KEY[0]** | Press to reset counter to 000000 |
| **KEY[1]** | Processor reset (emergency use only) |

## Technical Specifications
- **Code Size:** 244 instructions (976 bytes)
- **Algorithm:** Decimal digit extraction via division by 10
- **Display:** Active-low 7-segment encoding (DE-10 Standard)
- **Optimization:** Early-exit search (22% faster per digit)

## Quick Start
1. Load `counter_v2.hex` into RISC-V processor
2. Program to DE-10 Standard FPGA
3. Power on - displays `000000`
4. Watch automatic counting
5. Use SW[0] to pause/resume
6. Press KEY[0] to reset to 000000

## Optimization Highlights
✓ 5.1% smaller code (257 → 244 instructions)  
✓ 22% faster digit processing (41 → 32 inst/digit)  
✓ 45% fewer comparisons on average (early-exit strategy)  
✓ Works with Harvard architecture (IMEM/DMEM separation)  
✓ No initialization overhead  

## Memory Map
| Address | Function |
|---------|----------|
| 0x0000-0x03CF | Program code (244 instructions) |
| 0x10007020 | HEXL output (HEX2-HEX1-HEX0) |
| 0x10007024 | HEXH output (HEX5-HEX4-HEX3) |
| 0x10017800 | Input: SW[9:0] switches, KEY[3:0] buttons (bits 13:10) |

## 7-Segment Encoding
```
Digit: 0    1    2    3    4    5    6    7    8    9
Code:  0x40 0x79 0x24 0x30 0x19 0x12 0x02 0x78 0x00 0x10
```
(Active-low for common anode displays)

## Files
- `02_test/counter_v2.hex` - Program machine code
- `04_doc/STOPWATCH_OPTIMIZATIONS.md` - Detailed optimization analysis

---
*For DE-10 Standard FPGA • RV32I ISA • 10MHz Clock*
