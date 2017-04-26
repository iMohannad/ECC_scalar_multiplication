`include "../src/modular_multiplier.v"

module modular_multiplication_tb ();

  parameter n = 300;
  reg [n-1:0] a, b;
  wire [n-1:0] c;
  reg clk;
  reg reset;
  wire flag;

  wire [n-1:0] p = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff;

  modular_multiplier #(n) multi (.A(a), .B(b), .p(p), .clk(clk), .reset(reset), .M(c), .flag(flag));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    a <= 192'hf3eaf3b95d6d94260bb91af829600303535b2b331893bd3d;
    b <= 192'h3731fecb6367c15e7503c0ce01380c628aa5fe01fe31c9f3;
    wait(flag == 1)
      if(flag == 1) begin
        $write("\na = %0h, b= %0h, c=%0h\n", a, b, c);
        $display("time %0d", $time);
      end
      #30
      $stop;
  end




endmodule // modular_multiplication_tb
