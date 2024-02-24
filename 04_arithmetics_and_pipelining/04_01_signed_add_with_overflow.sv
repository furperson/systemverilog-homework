//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module signed_add_with_overflow
(
  input  [3:0] a, b,
  output [3:0] sum,
  output       overflow
);
  // Task:
  //
  // Implement a module that adds two signed numbers
  // and detects and overflow.
  //
  // By "signed" we mean "two's complement numbers".
  // See https://en.wikipedia.org/wiki/Two%27s_complement for details.
  //
  // The 'overflow' output bit should be set to 1
  // when the sum (either positive or negative)
  // of two input arguments does not fit into 4 bits.
  // Otherwise the 'overflow' should be set to 0.
  wire [3:0]C;
  genvar i;
  generate
  for(i=0;i<4;i=i+1)
  begin 
    if(i==0)
    begin
      assign C[i]=a[i]&b[i];
   assign sum[i]=a[i]^b[i];
    end
    else
    begin
    assign C[i]=(C[i-1]&a[i])|(C[i-1]&b[i])|(a[i]&b[i]);
     assign sum[i]=a[i]^b[i]^C[i-1];
    end
  end
endgenerate

assign overflow = C[3]^C[2];

endmodule

//----------------------------------------------------------------------------
// Testbench
//----------------------------------------------------------------------------

module testbench;

  logic signed [3:0] a, b, sum;
  logic overflow;

  signed_add_with_overflow inst
    (.a (a), .b (b), .sum (sum), .overflow);

  task test
    (
      input [3:0] t_a, t_b,
      input       t_overflow
    );

    logic [3:0] t_sum;

    t_sum = t_a + t_b;

    { a, b } = { t_a, t_b };

    # 1;

    $write ("TEST %d + %d = ", a, b);

    if (overflow === 1'b1)
      $display ("overflow");
    else if (overflow === 1'b0)
      $display ("%d", sum);
    else
      begin
        $display ("\n%s FAIL: overflow is %X",
          `__FILE__, overflow);

        $finish;
      end

    if (overflow !== t_overflow)
      begin
        $display ("%s FAIL: EXPECTED %soverflow",
          `__FILE__, t_overflow ? "" : "no ");

        $finish;
      end
    else if (sum !== t_sum)
      begin
        $display ("%s FAIL: EXPECTED sum %d",
          `__FILE__, t_sum);
        $finish;
      end

  endtask

  initial
    begin
      test (  0,  0, 0);

      test (  1,  2, 0);
      test (  1, -2, 0);
      test ( -1,  2, 0);
      test ( -1, -2, 0);

      test (  4,  7, 1);
      test (  4, -7, 0);
      test ( -4,  7, 0);
      test ( -4, -7, 1);

      test (  3,  5, 1);
      test (  3, -5, 0);
      test ( -3,  5, 0);
      test ( -3, -5, 0);

      test (  3,  6, 1);
      test (  3, -6, 0);
      test ( -3,  6, 0);
      test ( -3, -6, 1);

      test (  2,  1, 0);
      test ( -2,  1, 0);
      test (  2, -1, 0);
      test ( -2, -1, 0);

      test (  7,  4, 1);
      test ( -7,  4, 0);
      test (  7, -4, 0);
      test ( -7, -4, 1);

      test (  5,  3, 1);
      test ( -5,  3, 0);
      test (  5, -3, 0);
      test ( -5, -3, 0);

      test (  6,  3, 1);
      test ( -6,  3, 0);
      test (  6, -3, 0);
      test ( -6, -3, 1);

      test (  1,  1, 0);
      test (  1, -1, 0);
      test ( -1,  1, 0);
      test ( -1, -1, 0);

      test (  4,  4, 1);
      test (  4, -4, 0);
      test ( -4,  4, 0);
      test ( -4, -4, 0);

      $display ("%s PASS", `__FILE__);
      $finish;
    end

endmodule
