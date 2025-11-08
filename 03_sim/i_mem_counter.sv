// ============================================================================
// Module: i_mem_counter
// Description: Instruction Memory for Counter Demo
//              Loads counter.hex program
// ============================================================================
module i_mem(
  input  [31:0] i_addr,              // Byte address input
  output [31:0] o_data               // 32-bit instruction output
);

  // Memory array with FPGA BRAM synthesis attributes
  (* ramstyle = "M10K" *)        // Quartus: Use M10K block RAM
  (* ram_style = "block" *)      // Vivado: Use block RAM
  (* rom_style = "block" *)      // Additional hint for ROM inference
  logic [31:0] mem [0:2047];     // 2048 words × 4 bytes = 8 KiB

  // Load counter program from hex file at simulation start
  initial begin
    static string test_file = "/home/vinniny/projects/riscv/02_test/counter_v2.hex";
    $readmemh(test_file, mem);
    $display("INFO: Loaded counter program from: %s", test_file);
  end

  // Asynchronous read: convert byte address to word address
  assign o_data = mem[i_addr[12:2]];  // Drop lower 2 bits for word alignment

endmodule
