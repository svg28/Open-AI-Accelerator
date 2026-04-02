module pe_mac (
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire [7:0] a_in,
    input  wire [7:0] weight,
    output reg [15:0] acc
);
    // Standard MAC unit for AI inference
    always @(posedge clk) begin
        if (rst)
            acc <= 16'd0;
        else if (en)
            acc <= acc + (a_in * weight);
    end
endmodule

module systolic_2x2_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start,

    // weight loading interface (Bus-based for synthesis)
    input  wire weight_en,
    input  wire [1:0] weight_addr,
    input  wire [7:0] weight_data,

    // A matrix streaming (Flattened for SkyWater 130nm)
    input  wire [15:0] a_data_in, // [7:0] is row 0, [15:8] is row 1

    // outputs
    output reg  valid,
    output wire ready,
    output reg [15:0] c00, c01, c10, c11
);

    reg [7:0] W [0:1][0:1];
    reg running, done, k;
    reg [1:0] count;

    assign ready = !running && !weight_en;

    // Weight loading logic using bit-slicing (Synthesis-friendly)
    always @(posedge clk) begin
        if (weight_en)
            W[weight_addr[1]][weight_addr[0]] <= weight_data;
    end

    wire [15:0] acc00, acc01, acc10, acc11;

    // Mapping weights to PEs based on current cycle 'k'
    pe_mac PE00 (.clk(clk), .rst(rst), .en(running), .a_in(a_data_in[7:0]),  .weight(W[k][0]), .acc(acc00));
    pe_mac PE01 (.clk(clk), .rst(rst), .en(running), .a_in(a_data_in[7:0]),  .weight(W[k][1]), .acc(acc01));
    pe_mac PE10 (.clk(clk), .rst(rst), .en(running), .a_in(a_data_in[15:8]), .weight(W[k][0]), .acc(acc10));
    pe_mac PE11 (.clk(clk), .rst(rst), .en(running), .a_in(a_data_in[15:8]), .weight(W[k][1]), .acc(acc11));

    // Control FSM
    always @(posedge clk) begin
        if (rst) begin
            {running, done, valid, count, k} <= 6'b0;
        end else if (start) begin
            running <= 1;
            {done, valid, count, k} <= 5'b0;
        end else if (running) begin
            k <= k + 1;
            count <= count + 1;
            if (count == 1) begin
                running <= 0;
                done <= 1;
            end
        end else if (done) begin
            {c00, c01, c10, c11} <= {acc00, acc01, acc10, acc11};
            valid <= 1;
            done <= 0;
        end
    end
endmodule
