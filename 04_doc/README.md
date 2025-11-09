# Project Documentation

This directory contains all technical documentation for the RISC-V RV32I single-cycle processor project.

## 📁 Documentation Structure

### Core Specification
- **milestone-2.md** - Complete milestone-2 specification and requirements

### Verification & Compliance
- **COMPLIANCE_CHECK.md** - Full milestone-2 compliance verification report
- **../03_sim/TEST_RESULTS.md** - ISA test results (37/38 pass)

### Implementation Guides  
- **DEPLOYMENT_CHECKLIST.md** - FPGA deployment instructions
- **TIMING_FIXES.md** - Timing constraint setup and SDC file usage

### Test Programs
- **../02_test/PROGRAM_SUMMARY.md** - Overview of all test programs
- **../02_test/COUNTER_V3_README.md** - Stopwatch demo documentation

---

## 📊 Project Status

**Processor Status:** ✅ Fully Functional  
**ISA Tests:** 37/38 Pass (97.4%)  
**Milestone-2 Compliance:** ✅ Verified  
**FPGA Ready:** ✅ Yes  

---

## 🔍 Quick Start Guide

### Understanding the Design
1. Read `milestone-2.md` for requirements and architecture
2. Review `COMPLIANCE_CHECK.md` for verification details

### Running Tests
1. ISA tests: `cd 03_sim && make clean && make sim`
2. Results: See `../03_sim/TEST_RESULTS.md`
3. Programs: See `../02_test/PROGRAM_SUMMARY.md`

### FPGA Deployment
1. Follow `DEPLOYMENT_CHECKLIST.md` step-by-step
2. Configure timing: See `TIMING_FIXES.md`
3. Load counter demo: Use `counter_v3.hex`

---

**Last Updated:** 2025-11-09  
**Documentation Status:** Organized and Current
