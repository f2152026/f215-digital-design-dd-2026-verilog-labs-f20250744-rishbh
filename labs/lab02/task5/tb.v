module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer i, j, k, errors;
  reg [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration (keep whatever your template has)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        for (k = 0; k < 2; k = k + 1) begin   // op is the INNERMOST loop
          t_a  = i;
          t_b  = j;
          t_op = k;
          #5;

          expected = (k == 0) ? (i + j) : (i - j);   // truncates to 4 bits

          if (t_result !== expected) begin
            errors = errors + 1;
            if (errors <= 10)
              $display("FAIL: a=%d b=%d op=%b | got %d, expected %d",
                       t_a, t_b, t_op, t_result, expected);
          end
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 512 combinations correct");
    else
      $display("FAILED: %0d mismatches", errors);
    $finish;
  end

endmodule