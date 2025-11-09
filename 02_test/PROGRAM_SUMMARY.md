# Test Programs Summary

## Available Programs

### 1. ISA Test Suite (Primary Verification)

#### isa_4b.hex - Full ISA Test Suite (4-byte word addressing)
- **Purpose**: Comprehensive RV32I instruction set verification
- **Status**: ✅ **37/38 tests PASS** (97.4%)
- **Coverage**: All 36 RV32I instructions + I/O operations
- **Usage**: Default test file (currently loaded in i_mem.sv)
- **Results**: See `03_sim/TEST_RESULTS.md`

#### isa_1b.hex - Byte-Addressed ISA Tests
- **Purpose**: Alternative addressing format for ISA tests
- **Status**: Available but not currently used
- **Usage**: For environments requiring byte addressing

---

### 2. Stopwatch/Counter Programs

#### counter_v3.hex - **RECOMMENDED** (Milestone-2 Compliant)
- **Size**: 93 instructions (372 bytes)
- **Status**: ✅ **Milestone-2 Compliant**
- **Memory Map**:
  - HEX(0-3): 0x10002000 ✅
  - HEX(4-7): 0x10003000 ✅
  - SW:       0x10010000 ✅
- **Functionality**:
  - Counts seconds (00-59) on HEX1-HEX0
  - SW[0] = 1: Start/Run
  - SW[0] = 0: Pause
  - Auto-reset at 60
- **Documentation**: `COUNTER_V3_README.md`

#### counter_v2.hex - ⚠️ **DEPRECATED** (Non-Compliant)
- **Size**: 244 instructions (976 bytes)
- **Status**: ❌ **Incompatible with milestone-2**
- **Problem**: Uses incorrect addresses (0x10007xxx)
- **Do NOT Use**: Outputs will not work with current RTL

---

## Quick Reference

| File           | Instructions | Size  | Milestone-2 | Purpose               | Recommended |
|----------------|--------------|-------|-------------|-----------------------|-------------|
| isa_4b.hex     | ~1000+       | ~4KB  | ✅ Yes      | ISA verification      | ✅ Yes      |
| isa_1b.hex     | ~1000+       | ~4KB  | ✅ Yes      | ISA verification      | 🔹 Alt     |
| counter_v3.hex | 93           | 372B  | ✅ Yes      | Stopwatch demo        | ✅ Yes      |
| counter_v2.hex | 244          | 976B  | ❌ No       | Old stopwatch (broken)| ❌ No       |

---

## How to Switch Programs

### In i_mem.sv (line 23):

**For ISA Tests** (default):
```systemverilog
$readmemh("../02_test/isa_4b.hex", mem);
```

**For Stopwatch Demo**:
```systemverilog
$readmemh("../02_test/counter_v3.hex", mem);
```

### After Changing:
```bash
cd 03_sim
make clean
make sim
```

---

## Program Details

### ISA Tests (isa_4b.hex)
**What it tests:**
- ✅ All arithmetic operations (ADD, SUB, AND, OR, XOR, SLT, SLTU)
- ✅ All shift operations (SLL, SRL, SRA, SLLI, SRLI, SRAI)
- ✅ All branch operations (BEQ, BNE, BLT, BGE, BLTU, BGEU)
- ✅ Jump operations (JAL, JALR)
- ✅ Load operations (LB, LH, LW, LBU, LHU)
- ✅ Store operations (SB, SH, SW)
- ✅ Memory-mapped I/O (LED, HEX, switch reads)
- ✅ Upper immediate (LUI, AUIPC)

**Pass Criteria:**
- Each test writes PASS/FAIL to console
- 37 tests must show "PASS"
- Only "malgn" test fails (expected - no trap on misalignment)

### Counter Program (counter_v3.hex)
**Features:**
- Simple seconds counter (0-59)
- Controlled by switch SW[0]
- Displays on 7-segment HEX1-HEX0
- Uses proper milestone-2 memory map
- ~1 second per increment (timing approximate)

**7-Segment Display:**
- Active-low encoding (common-anode)
- Shows seconds in decimal (00-59)
- Upper displays (HEX4-7) cleared

---

## Verification Summary

### ISA Tests Result:
```
✅ 37 PASS / 38 total = 97.4% success rate
❌ 1  FAIL (malgn - expected per spec)
```

### Counter V3 Verification:
```
✅ Addresses verified correct
✅ Compatible with milestone-2 RTL
✅ Tested with manual assembly
```

---

## Recommendations

**For Verification/Testing:**
→ Use `isa_4b.hex` (proves processor works correctly)

**For Demo/FPGA:**
→ Use `counter_v3.hex` (visual confirmation on hardware)

**Never Use:**
→ `counter_v2.hex` (will not work with milestone-2 RTL)

---

**Last Updated:** 2025-11-09  
**Status:** All recommended programs verified and ready
