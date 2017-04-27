`include "../src/double_and_add.v"

module double_and_add_tb ();

  parameter n = 193;
  reg [n-1:0] x1, y1;
  wire [n-1:0] x3, y3;
  reg clk, reset;
  reg [n-1:0] a, c;

  wire done;

  reg [n-1:0] p;

  double_and_add #(n) doubleandadd (.clk(clk), .reset(reset), .p(p), .c(c), .x1(x1), .y1(y1), .a(a), .x3(x3), .y3(y3), .done(done));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    //c <= 521'h000001eb7f81785c9629f136a7e8f8c674957109735554111a2a866fa5a166699419bfa9936c78b62653964df0d6da940a695c7294d41b2d6600de6dfcf0edcfc89fdcb1;
     c <= 2;
    #20 reset <= 0;
    p <= 192'hfffffffffffffffffffffffffffffffeffffffffffffffff;
    // p <= 17;
    //Adding point P = (x1, y1)
    // p <= 521'h000001ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    // x1 <= 521'h000001d5c693f66c08ed03ad0f031f937443458f601fd098d3d0227b4bf62873af50740b0bb84aa157fc847bcf8dc16a8b2b8bfd8e2d0a7d39af04b089930ef6dad5c1b4;
    // y1 <= 521'h00000144b7770963c63a39248865ff36b074151eac33549b224af5c8664c54012b818ed037b2b7c1a63ac89ebaa11e07db89fcee5b556e49764ee3fa66ea7ae61ac01823;
    // a <= 521'h000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc;
    // p <= 384'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffff0000000000000000ffffffff;
    // x1 <= 384'hfba203b81bbd23f2b3be971cc23997e1ae4d89e69cb6f92385dda82768ada415ebab4167459da98e62b1332d1e73cb0e;
    // y1 <= 384'h5ffedbaefdeba603e7923e06cdb5d0c65b22301429293376d5c6944e3fa6259f162b4788de6987fd59aed5e4b5285e45;
    // a <= 384'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffff0000000000000000fffffffc;
    // p <= 224'hffffffffffffffffffffffffffffffff000000000000000000000001;
    // x1 <= 224'h6eca814ba59a930843dc814edd6c97da95518df3c6fdf16e9a10bb5b;
    // y1 <= 224'hef4b497f0963bc8b6aec0ca0f259b89cd80994147e05dc6b64d7bf22;
    x1 <= 192'hd458e7d127ae671b0c330266d246769353a012073e97acf8;
    y1 <= 192'h325930500d851f336bddc050cf7fb11b5673a1645086df3b;
    // x1 <= 5;
    // y1 <= 1;
    // p <= 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;
    // x1 <= 256'hde2444bebc8d36e682edd27e0f271508617519b3221a8fa0b77cab3989da97c9;
    // y1 <= 256'hc093ae7ff36e5380fc01a5aad1e66659702de80f53cec576b6350b243042a256;
    // a <= 256'hffffffff00000001000000000000000000000000fffffffffffffffffffffffc;
    //Depends on the elliptic curve function Y^2 = X^3 + bX + a
    // a <= 224'hfffffffffffffffffffffffffffffffefffffffffffffffffffffffe;
    // a <= 2;
    //c <= 4;
    a <= 192'hfffffffffffffffffffffffffffffffefffffffffffffffc;

    #10
    //checks if the result is ready, or the point is infinity.
    wait(done == 1);
    #20 //I have to wait at least one cycle in order for the results to be shown in the registers.
    $write("\nP = (%0h, %0h), kP = (%h, %h)\n",
          x1, y1, x3, y3);
    $display("time %0d", $time);





    $stop;
  end




endmodule // modular_multiplication_tb
