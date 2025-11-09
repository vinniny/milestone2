// ============================================================================
// Module: output_mux
// Description: Load Data Multiplexer and I/O Output Router
//              Selects between DMEM data and memory-mapped I/O registers
//              Routes I/O buffer values to output ports
// ============================================================================
module output_mux(
  input  logic        i_clk,         // Clock (unused in combinational logic)

  // Input buffers (from I/O peripherals)
  input  logic [31:0] b_io_btn,      // Button input buffer
  input  logic [31:0] b_io_sw,       // Switch input buffer

  // Output buffers (to I/O peripherals)
  input  logic [31:0] b_io_ledr,     // Red LED buffer
  input  logic [31:0] b_io_ledg,     // Green LED buffer
  input  logic [31:0] b_io_hexl,     // 7-segment display low (HEX3-0)
  input  logic [31:0] b_io_hexh,     // 7-segment display high (HEX7-4)
  input  logic [31:0] b_io_lcd,      // LCD buffer

  // DMEM data
  input  logic [31:0] b_dmem_data,   // Data memory read data

  // Address decode flags
  input  logic        f_dmem_valid,  // DMEM address valid
  input  logic        f_io_valid,    // I/O address valid
  input  logic [31:0] i_ld_addr,     // Load address

  // Load data output
  output logic [31:0] o_ld_data,     // Multiplexed load data

  // I/O outputs to top level
  output logic [31:0] o_io_ledr,     // Red LEDs
  output logic [31:0] o_io_ledg,     // Green LEDs
  output logic [ 6:0] o_io_hex0,     // 7-segment digit 0
  output logic [ 6:0] o_io_hex1,     // 7-segment digit 1
  output logic [ 6:0] o_io_hex2,     // 7-segment digit 2
  output logic [ 6:0] o_io_hex3,     // 7-segment digit 3
  output logic [ 6:0] o_io_hex4,     // 7-segment digit 4
  output logic [ 6:0] o_io_hex5,     // 7-segment digit 5
  output logic [ 6:0] o_io_hex6,     // 7-segment digit 6
  output logic [ 6:0] o_io_hex7,     // 7-segment digit 7
  output logic [31:0] o_io_lcd       // LCD output
);

  // Load data multiplexer: select DMEM or I/O based on address
  always_comb begin
    o_ld_data = 32'd0;
    if (f_dmem_valid) begin
      o_ld_data = b_dmem_data;
    end else if (f_io_valid) begin
      // Decode I/O address using lower 16 bits to match output_buffer addressing
      case (i_ld_addr[15:0])
        16'h7000: o_ld_data = b_io_ledr;  // 0x1000_7000: Red LEDs
        16'h7010: o_ld_data = b_io_ledg;  // 0x1000_7010: Green LEDs
        16'h7020: o_ld_data = b_io_hexl;  // 0x1000_7020: HEX3-0
        16'h7024: o_ld_data = b_io_hexh;  // 0x1000_7024: HEX7-4
        16'h7030: o_ld_data = b_io_lcd;   // 0x1000_7030: LCD
        16'h7800: o_ld_data = b_io_sw;    // 0x1001_7800: Switches
        default:   o_ld_data = 32'd0;
      endcase
    end
  end

  // Route I/O buffers to output ports
  assign o_io_ledr = b_io_ledr;
  assign o_io_ledg = b_io_ledg;
  assign o_io_lcd  = b_io_lcd;

  // Unpack 7-segment displays (4 digits per 32-bit word)
  assign o_io_hex0 = b_io_hexl[ 6: 0];  // Bits [6:0]
  assign o_io_hex1 = b_io_hexl[14: 8];  // Bits [14:8]
  assign o_io_hex2 = b_io_hexl[22:16];  // Bits [22:16]
  assign o_io_hex3 = b_io_hexl[30:24];  // Bits [30:24]
  assign o_io_hex4 = b_io_hexh[ 6: 0];  // Bits [6:0]
  assign o_io_hex5 = b_io_hexh[14: 8];  // Bits [14:8]
  assign o_io_hex6 = b_io_hexh[22:16];  // Bits [22:16]
  assign o_io_hex7 = b_io_hexh[30:24];  // Bits [30:24]

endmodule