// --- Project Neon: 2x2 Systolic Array Integration ---

    // 1. Internal wire connections
    wire [15:0] c00_out, c01_out, c10_out, c11_out;
    wire valid_out;
    wire ready_out;

    // 2. Pin Mapping (Wiring the Array to the Chip Pads)
    // io_in[0]      -> rst
    // io_in[1]      -> clk (You can also use wb_clk_i)
    // io_in[2]      -> start
    // io_in[3]      -> weight_en
    // io_in[5:4]    -> weight_addr
    // io_in[13:6]   -> weight_data (8-bit)
    // io_in[29:14]  -> a_data_in (16-bit)

    systolic_2x2_fsm u_array (
        .clk(wb_clk_i),           // Using the Caravel system clock
        .rst(wb_rst_i),           // Using the Caravel system reset
        .start(io_in[2]),
        
        .weight_en(io_in[3]),
        .weight_addr(io_in[5:4]),
        .weight_data(io_in[13:6]),

        .a_data_in(io_in[29:14]),

        .valid(valid_out),
        .ready(ready_out),
        .c00(c00_out),
        .c01(c01_out),
        .c10(c10_out),
        .c11(c11_out)
    );

    // 3. Assigning Outputs to Pads
    // We'll put the first result (c00) on pins 30-37 so you can see it.
    assign io_out[30] = valid_out;
    assign io_out[31] = ready_out;
    assign io_out[37:32] = c00_out[5:0]; // Showing first 6 bits of C00

    // 4. Critical: Tell the chip which pins are Outputs
    // 0 = Output, 1 = Input
    assign io_oeb[29:0]  = 30'h3FFFFFFF; // Pins 0-29 are Inputs
    assign io_oeb[37:30] = 8'h00;       // Pins 30-37 are Outputs
