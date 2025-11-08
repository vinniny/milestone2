module wrapper (
    input  logic        CLOCK_50,
    input  logic [9:0]  SW,          // DE10-Standard: 10 switches
    input  logic [3:0]  KEY,         // use KEY[0] as reset_n (active-low)
    output logic [9:0]  LEDR,        // 10 red LEDs
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

	 // logic [6:0]  HEX0_tmp, HEX1_tmp, HEX2_tmp, HEX3_tmp, HEX4_tmp, HEX5_tmp;
    // -------------------------------------------------------------------------
    // Clock & Reset
    // -------------------------------------------------------------------------
    logic clk_25;
    logic reset_n;            // active-low reset as expected by single_cycle
    assign reset_n = KEY[1];  // KEY[1] is processor reset, KEY[0] used for counter reset

    // 50MHz -> 25MHz clock divider (module you already have)
    // NOTE: keep reset polarity consistent with your divider's expectation.
    // If your clock_25M expects active-low reset, pass reset_n directly.
    clock_10M u_clkdiv (
        .clk50   (CLOCK_50),
        .i_reset (reset_n),
        .o_clk   (clk_25)
    );

    // -------------------------------------------------------------------------
    // Interconnect to single_cycle
    // -------------------------------------------------------------------------
    logic        insn_vld;
    logic [31:0] ledr32;

    // Unused 7-seg from core (the core outputs 8 digits, board has 6)
    logic [6:0] hex6_nc, hex7_nc;

    single_cycle dut (
        .i_clk      (clk_25),
        .i_reset    (reset_n),

        // Map switches and KEY buttons to 32-bit input
        // i_io_sw[9:0] = SW[9:0], i_io_sw[13:10] = KEY[3:0] (inverted for active-high logic)
        .i_io_sw    ({18'd0, ~KEY, SW}),

        // Optional debug (left unconnected)
        .o_pc_debug (),
        .o_insn_vld (insn_vld),

        // Map LEDRs (core drives 32; board shows 10)
        .instr(ledr32),
        .o_io_ledg  (),           // not brought to the board
        .o_io_hex0  (HEX0),
        .o_io_hex1  (HEX1),
        .o_io_hex2  (HEX2),
        .o_io_hex3  (HEX3),
        .o_io_hex4  (HEX4),
        .o_io_hex5  (HEX5),
		  /*.o_io_hex0  (HEX0_tmp),
        .o_io_hex1  (HEX1_tmp),
        .o_io_hex2  (HEX2_tmp),
        .o_io_hex3  (HEX3_tmp),
        .o_io_hex4  (HEX4_tmp),
        .o_io_hex5  (HEX5_tmp),*/
        .o_io_hex6  (hex6_nc),    // tie off extra digits
        .o_io_hex7  (hex7_nc),
        .o_io_lcd   ()            // not used on DE10-Standard
    );

    // -------------------------------------------------------------------------
    // Board LED assignments
    // -------------------------------------------------------------------------
    // Show core LEDR[8:0] on board, and use LEDR[9] as "instruction valid" pulse
    always_comb begin
        LEDR[8:0] = ledr32[8:0];
        LEDR[9]   = insn_vld;
		  /*HEX0 = {~HEX0_tmp[6], ~HEX0_tmp[5], ~HEX0_tmp[4], ~HEX0_tmp[3], ~HEX0_tmp[2], ~HEX0_tmp[1], ~HEX0_tmp[0]};
		  HEX1 = {~HEX1_tmp[6], ~HEX1_tmp[5], ~HEX1_tmp[4], ~HEX1_tmp[3], ~HEX1_tmp[2], ~HEX1_tmp[1], ~HEX1_tmp[0]};
		  HEX2 = {~HEX2_tmp[6], ~HEX2_tmp[5], ~HEX2_tmp[4], ~HEX2_tmp[3], ~HEX2_tmp[2], ~HEX2_tmp[1], ~HEX2_tmp[0]};
		  HEX3 = {~HEX3_tmp[6], ~HEX3_tmp[5], ~HEX3_tmp[4], ~HEX3_tmp[3], ~HEX3_tmp[2], ~HEX3_tmp[1], ~HEX3_tmp[0]};
		  HEX4 = {~HEX4_tmp[6], ~HEX4_tmp[5], ~HEX4_tmp[4], ~HEX4_tmp[3], ~HEX4_tmp[2], ~HEX4_tmp[1], ~HEX4_tmp[0]};
		  HEX5 = {~HEX5_tmp[6], ~HEX5_tmp[5], ~HEX5_tmp[4], ~HEX5_tmp[3], ~HEX5_tmp[2], ~HEX5_tmp[1], ~HEX5_tmp[0]};*/
    end

endmodule
