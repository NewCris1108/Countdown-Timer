`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Required — leave these alone
    assign uio_out = 0;
    assign uio_oe  = 0;

    // Clock divider register — 25 bits wide
    reg [24:0] counter;

    // This runs on every rising clock edge
    always @(posedge clk) begin
        if (!rst_n)
            counter <= 0;        // reset
        else
            counter <= counter + 1; // count up
    end

    // Send bit 24 (the slow one) to the LED
    assign uo_out = {7'b0, counter[24]};

    wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule