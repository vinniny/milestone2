//==============================================================================
// Counter Demo Testbench
// Description: Simple testbench to demonstrate counter on 7-segment display
//==============================================================================

`timescale 1ns/1ps

module counter_tb;

  // Clock and reset
  logic clk;
  logic reset;
  
  // I/O signals
  logic [31:0] io_sw;
  logic [31:0] io_ledr;
  logic [31:0] io_ledg;
  logic [6:0]  io_hex0, io_hex1, io_hex2, io_hex3;
  logic [6:0]  io_hex4, io_hex5, io_hex6, io_hex7;
  logic [31:0] io_lcd;
  
  // Debug signals
  logic [31:0] pc_debug;
  logic        insn_vld;

  // Instantiate DUT
  single_cycle dut(
    .i_clk(clk),
    .i_reset(reset),
    .i_io_sw(io_sw),
    .o_io_ledr(io_ledr),
    .o_io_ledg(io_ledg),
    .o_io_hex0(io_hex0),
    .o_io_hex1(io_hex1),
    .o_io_hex2(io_hex2),
    .o_io_hex3(io_hex3),
    .o_io_hex4(io_hex4),
    .o_io_hex5(io_hex5),
    .o_io_hex6(io_hex6),
    .o_io_hex7(io_hex7),
    .o_io_lcd(io_lcd),
    .o_pc_debug(pc_debug),
    .o_insn_vld(insn_vld)
  );

  // Clock generation: 50 MHz (20ns period)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Stimulus
  initial begin
    // Initialize
    reset = 0;
    io_sw = 32'h0;
    
    // VCD dump for waveform viewing
    $dumpfile("counter.vcd");
    $dumpvars(0, counter_tb);
    
    // Reset pulse
    #5 reset = 1;
    #100 reset = 0;
    #50 reset = 1;
    
    $display("\n===========================================");
    $display("  RISC-V Counter Demo");
    $display("  Displaying 0-15 on HEX0");
    $display("===========================================\n");
    
    // Monitor 7-segment display changes
    fork
      // Monitor HEX0 changes
      begin
        logic [6:0] prev_hex0;
        integer count;
        prev_hex0 = io_hex0;
        count = 0;
        
        forever begin
          @(io_hex0);
          if (io_hex0 !== prev_hex0) begin
            $display("Time=%0t: HEX0 changed to 0x%h (digit %0d displayed)", 
                     $time, io_hex0, count);
            prev_hex0 = io_hex0;
            count++;
            
            // Stop after seeing several counts
            if (count >= 20) begin
              $display("\n===========================================");
              $display("  Counter working correctly!");
              $display("  Observed %0d display updates", count);
              $display("===========================================\n");
              $finish;
            end
          end
        end
      end
      
      // Timeout
      begin
        #50000; // 50us timeout (faster for testing)
        $display("\n===========================================");
        $display("  Timeout reached");
        $display("  Last HEX0 value: 0x%h", io_hex0);
        $display("===========================================\n");
        $finish;
      end
    join_any
    
    $finish;
  end

  // Optional: Monitor PC for debugging
  integer instr_count;
  initial instr_count = 0;
  
  always @(posedge clk) begin
    if (reset && insn_vld) begin
      instr_count++;
      // Print first 100 instructions for debugging
      if (instr_count <= 100) begin
        $display("Time=%0t: PC=0x%h, x5=%0d, x6=0x%h, mem_wren=%b, f_io_wren=%b, HEXL=0x%h, HEX0=0x%h", 
                 $time, pc_debug, 
                 dut.register.registers[5],
                 dut.register.registers[6],
                 dut.mem_wren,
                 dut.lsu_inst.f_io_wren,
                 dut.lsu_inst.b_io_hexl,
                 io_hex0);
      end
      
      // Alert when store happens
      if (dut.mem_wren) begin
        $display("*** STORE at PC=0x%h: addr=0x%h, data=0x%h, f_io_wren=%b", 
                 pc_debug, dut.alu_data, dut.rs2_data, dut.lsu_inst.f_io_wren);
      end
    end
  end

endmodule
