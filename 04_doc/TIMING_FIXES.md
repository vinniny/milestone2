# Timing Fixes Implementation Guide

## Overview
The timing report shows **-21.272 ns slack**, meaning the design violates timing by a large margin. The root cause is an **incorrect clock constraint** of 1 ns (1 GHz), when the actual target is 10 MHz (100 ns period).

---

## Critical Path Analysis

**Worst Path:**
- From: `PC:program_counter|o_pc[9]`
- To: `regfile:register|registers[5][25]`
- Data Delay: **22.079 ns**
- Clock Requirement: **1.000 ns** ❌ (INCORRECT!)

This is the entire single-cycle processor critical path:
```
PC → Instruction Memory → Control Unit → ALU → Register File Write
```

In a single-cycle design, all instruction execution happens in one clock cycle, so this path is unavoidable without pipelining.

---

## ✅ Solution 1: Add Timing Constraints (PRIMARY FIX)

### Step 1: Import SDC File into Quartus

1. **Open your Quartus project**

2. **Go to:** Assignments → Settings → Category: "Timing Analyzer"

3. **Click:** "..." button next to "SDC File"

4. **Add:** `04_doc/timing_constraints.sdc`

5. **Click:** OK to save

### Step 2: Recompile Design

```
Processing → Start Compilation
```

or use keyboard shortcut: **Ctrl+L**

### Step 3: Verify Timing

After compilation:
```
Tools → Timing Analyzer → Report → Custom Reports → Report Timing
```

**Expected Result:**
- Clock Period: **100.000 ns** (10 MHz)
- Worst Path Delay: ~22 ns
- **Slack: +78 ns** ✅ PASSING!

---

## ✅ Solution 2: RTL Optimizations (Applied)

### Fix 1: Register File - Remove Forbidden `for` Loop

**Issue:** 
- Used `for` loop in reset logic
- Violates Milestone-2 constraint: "No for loops in RTL (00_src)"

**Fix Applied:**
```systemverilog
// OLD (FORBIDDEN):
always_ff @(posedge i_clk or negedge i_reset) begin
  if (!i_reset) begin
    integer i;
    for (i = 0; i < 32; i = i + 1)  // ❌ NOT ALLOWED
      registers[i] <= 32'b0;
  end
  ...
end

// NEW (COMPLIANT):
always_ff @(posedge i_clk) begin
  if (i_rd_wren && (i_rd_addr != 5'd0)) begin
    registers[i_rd_addr] <= i_rd_data;
  end
end
```

**Impact:**
- Registers no longer reset to zero (acceptable per RV32I spec)
- x0 still reads as zero via combinational logic
- Faster synthesis, no `for` loop unrolling
- **Complies with Milestone-2 constraints**

---

## 📊 Timing Budget Breakdown (@ 10 MHz)

| Stage | Estimated Delay | Notes |
|-------|----------------|-------|
| PC Register | 1 ns | Clock-to-Q delay |
| Instruction Memory | 5 ns | BRAM read (async) |
| Instruction Decode | 2 ns | Control unit one-hot decode |
| Immediate Generation | 1 ns | Parallel extraction |
| Register File Read | 3 ns | Array access |
| ALU Computation | 8 ns | 32-bit adder + shifters |
| Register File Write Setup | 2 ns | Address decode + setup |
| **Total** | **22 ns** | |
| **Clock Period** | **100 ns** | 10 MHz target |
| **Slack** | **+78 ns** | ✅ Meets timing |

---

## 🔍 Additional Optimizations (If Still Needed)

### Optimization A: ALU - Reuse Subtractor for Comparisons

**Current Implementation:**
```systemverilog
// Separate adders for ADD, SUB, SLT, SLTU (4 adders!)
FA_32bit add_fa(...);   // Addition
FA_32bit sub_fa(...);   // Subtraction  
FA_32bit slt_fa(...);   // SLT comparison
FA_32bit sltu_fa(...);  // SLTU comparison
```

**Optimized Version:**
```systemverilog
// Reuse SUB result for comparisons (2 adders)
FA_32bit add_fa(...);   // Addition
FA_32bit sub_fa(...);   // Subtraction + comparisons

// For SLT: Check MSB of (A - B) with sign handling
assign slt_result = (sign_diff) ? A[31] : sub_result[31];

// For SLTU: Check carry-out of (A - B)
assign sltu_result = ~sub_cout;
```

**Benefit:** Reduces area by 50% for comparison logic

### Optimization B: Control Unit - Already Optimal

Current implementation uses **one-hot decoding**:
```systemverilog
assign is_rtype  = (opcode == 7'b0110011);
assign is_itype  = (opcode == 7'b0010011);
...
assign rd_wren = is_rtype | is_itype | is_load | ...;
```

This is already the **fastest decode method** (parallel comparisons, simple OR gates).

### Optimization C: Immediate Generator - Already Optimal

Current implementation uses **parameterized sign extension** which synthesizes to optimal logic.

---

## ⚠️ Milestone-2 Compliance Verification

### Forbidden Constructs in RTL (00_src):
| Construct | Status | Location |
|-----------|--------|----------|
| `for` loop | ✅ REMOVED | regfile.sv (was in reset) |
| `generate` | ✅ NOT USED | - |
| `function` | ✅ NOT USED | - |
| `#delay` | ✅ NOT USED | - |
| Operators: `-, <, >, <<, >>, >>>, *, /, %` | ✅ NOT USED | All use FA_32bit, SLL/SRL/SRA modules |

### Allowed Constructs:
| Construct | Usage |
|-----------|-------|
| `always_ff` | ✅ Sequential logic (regfile, PC, memories) |
| `always_comb` | ✅ Combinational logic (ALU, control, muxes) |
| `case` statements | ✅ ALU operation decode, control decode |
| `assign` | ✅ Wire connections, simple logic |
| `initial` | ✅ Only in IMEM/DMEM for `$readmemh` |

---

## 📋 Verification Checklist

After applying fixes:

### Timing:
- [ ] Import `04_doc/timing_constraints.sdc` into Quartus
- [ ] Recompile design
- [ ] Verify clock constraint is 100 ns (10 MHz)
- [ ] Check worst-case slack is positive (+78 ns expected)
- [ ] Verify setup and hold times pass

### Functional:
- [ ] Run ISA tests (make sim in 03_sim/)
- [ ] Verify all tests PASS
- [ ] Check stopwatch demo works on FPGA
- [ ] Verify SW[0] pause, KEY[0] reset functions

### Compliance:
- [ ] No `for` loops in 00_src/ (check regfile.sv)
- [ ] All sequential: `always_ff` with `<=`
- [ ] All combinational: `always_comb` with `=`
- [ ] No forbidden operators in 00_src/

---

## 🎯 Expected Results

### Before Fix:
```
Worst-case slack: -21.272 ns ❌
Clock period: 1.000 ns (1 GHz)
Status: FAILS TIMING
```

### After Fix:
```
Worst-case slack: +78 ns ✅
Clock period: 100.000 ns (10 MHz)
Status: MEETS TIMING
```

---

## 🚀 Deployment Steps

1. **Apply SDC file:**
   - Quartus: Assignments → Settings → Timing Analyzer → Add `timing_constraints.sdc`

2. **Recompile:**
   - Processing → Start Compilation

3. **Verify timing:**
   - Tools → Timing Analyzer → Report → Report Timing
   - Check "Setup" and "Hold" summaries
   - Ensure all paths have positive slack

4. **Program FPGA:**
   - Tools → Programmer
   - Load `wrapper.sof`
   - Test stopwatch demo

5. **Functional verification:**
   - Power on → Display shows 000000
   - Counting every 1 second
   - SW[0] pauses
   - KEY[0] resets to 000000

---

## 📞 Troubleshooting

### Issue: Still failing timing after SDC import

**Check:**
1. SDC file actually loaded (check Compilation Report → Timing Analyzer → SDC commands)
2. Correct clock name in SDC (should match top-level port `i_clk`)
3. Clock divider properly constrained (50 MHz input, 10 MHz output)

**Solution:**
```tcl
# Verify in Quartus Tcl Console:
report_clocks
# Should show i_clk with 100ns period
```

### Issue: Stopwatch not working after changes

**Check:**
1. Register file writes still enabled (check `i_rd_wren` signal)
2. Removed reset doesn't affect initial program execution
3. IMEM still loads `counter_v2.hex` correctly

**Solution:**
- Run simulation: `cd 03_sim && make clean && make sim`
- Check waveforms for register file writes

---

## 📚 References

- **Timing Report:** `single_cycle-Setup-i_clk.rpt`
- **SDC File:** `04_doc/timing_constraints.sdc`
- **Milestone Spec:** `04_doc/milestone-2.md`
- **Fixed Files:** `00_src/regfile.sv`

---

**Status:** ✅ Ready for recompilation  
**Expected Outcome:** All timing violations resolved  
**Compliance:** Milestone-2 constraints satisfied
