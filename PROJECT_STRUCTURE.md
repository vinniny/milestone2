# RISC-V RV32I Processor - Project Structure

## 📁 Directory Organization

```
riscv/
├── 00_src/              # RTL source files (SystemVerilog)
├── 01_bench/            # Testbench and verification files
├── 02_test/             # Test programs (hex files)
├── 03_sim/              # Simulation environment (iverilog)
├── 04_doc/              # Documentation
└── README.md            # Project overview
```

---

## 📄 Key Files by Directory

### 00_src/ - RTL Source (19 files)
**Core Modules:**
- `single_cycle.sv` - Top-level processor integration
- `control_unit.sv` - Instruction decoder and control signals
- `alu.sv` - Arithmetic Logic Unit
- `regfile.sv` - 32×32-bit register file
- `PC.sv` - Program Counter

**Memory:**
- `i_mem.sv` - Instruction memory (2 KiB, preloaded)
- `dmem.sv` - Data memory (2 KiB, async read/sync write)

**Load-Store Unit:**
- `lsu.sv` - Load-Store Unit with byte enables
- `input_buffer.sv` - I/O input synchronization
- `output_buffer.sv` - I/O output registers
- `input_mux.sv` - Input data multiplexer
- `output_mux.sv` - Output data multiplexer

**Supporting Modules:**
- `brc.sv` - Branch comparator
- `imm_gen.sv` - Immediate generator
- `FA_32bit.sv` - 32-bit full adder (for PC+4)
- `mux2_1.sv` - 2-to-1 multiplexer
- `wrapper.sv` - FPGA top-level wrapper
- `clock_25M.sv` - Clock divider

**Status:** All files milestone-2 compliant ✅

---

### 02_test/ - Test Programs (5 files)
- `isa_4b.hex` - ISA test suite (default, 37/38 pass) ✅
- `isa_1b.hex` - Alternative ISA tests
- `counter_v3.hex` - Stopwatch demo (milestone-2 compliant) ✅
- `counter_v2.hex` - Old stopwatch (deprecated, incompatible) ❌
- `COUNTER_V3_README.md` - Counter documentation
- `PROGRAM_SUMMARY.md` - Overview of all programs

**Recommended:** Use `isa_4b.hex` for testing, `counter_v3.hex` for demo

---

### 03_sim/ - Simulation (6 files + generated)
**Configuration:**
- `makefile` - Build automation
- `flist` - File list for compilation

**Results:**
- `TEST_RESULTS.md` - Test results summary (37/38 pass)

**Generated Files:** (cleaned with `make clean`)
- `sim.vvp` - Compiled simulation
- `dump.vcd` - Waveform dump
- `*.log` - Compilation/simulation logs

**Usage:** `make clean && make sim`

---

### 04_doc/ - Documentation (6 files)
**Specification:**
- `milestone-2.md` - Complete design specification

**Verification:**
- `COMPLIANCE_CHECK.md` - Compliance verification report
- `README.md` - Documentation index

**Implementation:**
- `DEPLOYMENT_CHECKLIST.md` - FPGA deployment guide
- `TIMING_FIXES.md` - Timing constraints guide
- `timing_constraints.sdc` - SDC file for Quartus

**All documentation current and organized** ✅

---

## �� File Count Summary

| Directory | RTL/HDL | Test/Hex | Docs | Config | Total |
|-----------|---------|----------|------|--------|-------|
| 00_src    | 19      | -        | -    | -      | 19    |
| 01_bench  | ~5      | -        | -    | -      | ~5    |
| 02_test   | -       | 4        | 2    | -      | 6     |
| 03_sim    | -       | -        | 1    | 2      | 3+    |
| 04_doc    | -       | -        | 5    | 1      | 6     |
| Root      | -       | -        | 1    | -      | 1     |

**Total Essential Files:** ~40 files (organized, no bloat)

---

## 🧹 Recently Cleaned Up

**Removed Duplicates:**
- ❌ `00_src/COMPLIANCE_VERIFIED.md` (duplicate)
- ❌ `02_test/COUNTER_ADDRESS_ISSUE.md` (obsolete)
- ❌ `04_doc/STOPWATCH_README.md` (duplicate)

**Kept Essential:**
- ✅ All RTL source files
- ✅ Test programs (ISA + counter v3)
- ✅ Core documentation (spec + compliance)
- ✅ Deployment guides

---

## 📋 Quick Access

### I want to...

**Understand the processor:**
→ Read `04_doc/milestone-2.md`

**Verify compliance:**
→ Read `04_doc/COMPLIANCE_CHECK.md`

**Run tests:**
→ `cd 03_sim && make sim`

**Deploy to FPGA:**
→ Follow `04_doc/DEPLOYMENT_CHECKLIST.md`

**Use stopwatch demo:**
→ See `02_test/COUNTER_V3_README.md`

**Modify code:**
→ Edit files in `00_src/` only

---

## ✅ Organization Status

- **No duplicate files** ✅
- **Clear directory structure** ✅  
- **Documentation organized** ✅
- **Generated files isolated** ✅
- **All files have purpose** ✅

**Project is clean and well-organized!**

---

**Last Updated:** 2025-11-09  
**Status:** Production Ready
