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
    reg [24:0] clk_div;
    wire tick;

    // This runs on every rising clock edge
    always @(posedge clk) begin
        if (!rst_n)
            clk_div <= 0;        // reset
        else
            clk_div <= clk_div + 1; // count up
    end

    assign tick = (clk_div == 25'b1111111111111111111111111);

    //9-bit down counter
    reg [7:0] count;

    always @(posedge clk) begin
      if (!rst_n)
          count <= 8'hFF;
      else if (tick && count != 0)
          count <= count - 1;
    end

    // Done signal - high when count reaches zero
    wire done = (count == 0);

    // Output - count on bits [6:0], done on bit [7]
    assign uo_out = {done, count[6:0]};

    wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule