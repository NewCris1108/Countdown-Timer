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

    // State machine
    localparam IDLE = 2'd0, RUN = 2'd1, DONE = 2'd2;
    reg [1:0] state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    count <= {1'b0, ui_in[7:1]};
                    if (ui_in[0])
                        state <= RUN;
                end
                RUN: begin
                    if (tick && count != 0)
                        count <= count - 1;
                    else if (count == 0)
                        state <= DONE;
                end
                DONE: begin
                    // hold here until reset
                end
            endcase
        end
    end

    // Done signal - high when count reaches zero
    wire done = (count == 0);

    // Output - count on bits [6:0], done on bit [7]
    wire [6:0] segments;
    seg7_decoder decoder(.digit(count[3:0]), .segments(segments));
    assign uo_out = {done, segments};

    wire _unused = &{ena, uio_in, 1'b0};

endmodule
module seg7_decoder (
    input  wire [3:0] digit,
    output reg  [6:0] segments
);
    always @(*) begin
        case (digit)
            4'd0: segments = 7'b0111111; // 0
            4'd1: segments = 7'b0000110; // 1
            4'd2: segments = 7'b1011011; // 2
            4'd3: segments = 7'b1001111; // 3
            4'd4: segments = 7'b1100110; // 4
            4'd5: segments = 7'b1101101; // 5
            4'd6: segments = 7'b1111101; // 6
            4'd7: segments = 7'b0000111; // 7
            4'd8: segments = 7'b1111111; // 8
            4'd9: segments = 7'b1101111; // 9
            default: segments = 7'b0000000;
        endcase
    end
endmodule