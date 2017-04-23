

// Input: P = k(x1, y1), k
// Output: kP = (x3, y3)
module double_and_add #(parameter n = 231) (clk, reset, p, k, x1, y1, a, x3, y3, done);
  input clk, reset;
  input [n-1:0] p, x1, y1, a, k;
  output reg [n-1:0] x3, y3;
  output done;

  wire result_double, result_add, infinity_double, infinity_add;

  wire [n-1:0] x1_double, y1_double, x2_add, y2_add, x3_add, y3_add, x3_double, y3_double;

  reg [n-1:0] counter;

  reg doubleflag, addflag, resetdouble;
  wire enable_add = ~addflag;
  wire enable_double = ~doubleflag;

  point_doubling #(n) pdoubling (.clk(clk), .reset(reset), .p(p), .x1(x1_double),
        .y1(y1_double), .a(a), .x3(x3_double), .y3(y3_double), .result(result_double), .infinity(infinity_double));


  point_addition #(n) paddition (.clk(clk), .reset(enable_add), .p(p), .x1(x1),
        .y1(y1), .x2(x2_add), .y2(y2_add), .x3(x3_add), .y3(y3_add), .result(result_add), .infinity(infinity_add));



  assign lastbit = k[n-1];
  assign done = (k == 0) ? 1 : 0;



  assign x2_add = (addflag) ? x3_double : x2_add;
  assign y2_add = (addflag) ? y3_double : y2_add;

  assign x1_double = (resetdouble) ? x1 : (doubleflag) ? x3_add : x1_double;
  assign y1_double = (resetdouble) ? y1 : (doubleflag) ? y3_add : y1_double;


  always @ (posedge clk) begin
    if(reset) begin
      x3 <= 0;
      y3 <= 0;
      resetdouble <= 1;
      counter <= 2;
      doubleflag <= 0;
      addflag <= 0;
    end
    else begin
      //if(mult_result) mult_result <= 0;
      if(resetdouble) resetdouble <= 0;
      //else if(result_add) addflag <= 0;
      //else if(result_double) doubleflag <= 0;
      if(result_double) begin
        if(k[counter]) begin
          addflag <= 1;
        end
        else begin
          counter <= counter - 1;
          doubleflag <= 1;
        end
      end
      if(result_add && addflag) begin
        counter <= counter - 1;
        doubleflag <= 1;
      end
      if (counter == 0) begin
        //mult_result <= 1;
        x3 <= x1_double;
        y3 <= y1_double;
      end

    end
  end

endmodule // double_and_add
