module comp (
    input wire a,
    input wire b,
    output wire c
);

assign c = (a == b);

endmodule

module inc_if_eq (
    input wire clk,
    input wire a,
    input wire b,
    output reg [1:0] c
);

wire eq;

comp comp_inst (
    .a(a),
    .b(b),
    .c(eq)
);

always @(posedge clk) begin
    c <= eq ? (a + b) : a;
end

endmodule