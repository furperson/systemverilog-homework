//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output reg [31:0] res
);
    // Task:
    //
    // Implement a pipelined module formula_1_pipe that computes the result
    // of the formula defined in the file formula_1_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_1_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm
    logic [31:0] a_f,b_f,c_f;
    logic [31:0] a_o,b_o,c_o;
    logic aivl,bivl,civl;
    logic aovl,bovl,covl;
    isqrt asqrt(.rst (rst), .clk (clk), .x_vld(arg_vld), .x(a_f), .y(a_o),.y_vld(aovl));
    isqrt bsqrt(.rst (rst), .clk (clk), .x_vld(arg_vld), .x(b_f), .y(b_o),.y_vld(bovl));
    isqrt csqrt(.rst (rst), .clk (clk), .x_vld(arg_vld), .x(c_f), .y(c_o),.y_vld(covl));
    assign res_vld = aovl & bovl & covl;
    always @(clk) begin
        if(~rst) begin
        if (arg_vld)begin
            a_f <= a;
            b_f <= b;
            c_f <= c;
        end
        if (aovl)begin
            res <= a_o + b_o + c_o;
            end
        end
    end









endmodule
