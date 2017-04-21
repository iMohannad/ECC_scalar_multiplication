`include "../src/modular_multiplier.v"

module modular_multiplication_tb ();

  parameter n = 10;
  reg [n-1:0] a, b;
  wire [n-1:0] c;
  reg clk;
  reg reset;
  wire flag;

  wire [n-1:0] p = 8;

  modular_multiplier #(n) multi (.A(a), .B(b), .p(p), .clk(clk), .reset(reset), .M(c), .flag(flag));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    a <= 10'b1011011001;
    b <= 10'b1101100011;
    wait(flag == 1)
      if(flag == 1) begin
        $write("\na = %0d, b= %0d, c=%0d\n", a, b, c);
        $display("time %0d", $time);
      end
      #10
      $stop;
  end




endmodule // modular_multiplication_tb
