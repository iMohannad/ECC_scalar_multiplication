

// Input: P = k(x1, y1), k
// Output: kP = (x3, y3)
module double_and_add #(parameter n = 231) (clk, reset, p, c, x1, y1, a, x3, y3, done);
  input clk, reset;
  input [n-1:0] p, x1, y1, a, c;
  output reg [n-1:0] x3, y3;
  output done;

  wire result_double, result_add, infinity_double, infinity_add;

  wire [n-1:0] x1_add, y1_add, x1_double, y1_double, x2_add, y2_add, x3_add, y3_add, x3_double, y3_double;
  wire [n-1:0] x1_done, y1_done;
  reg [n-1:0] k;
  reg initialDouble;
  reg counter, counterLast;
  reg doubleflag, addflag, resetdouble;
  wire enable_add = ~addflag;
  wire enable_double = ~doubleflag;

  point_doubling #(n) pdoubling (.clk(clk), .reset(enable_double), .p(p), .x1(x1_double),
        .y1(y1_double), .a(a), .x3(x3_double), .y3(y3_double), .result(result_double), .infinity(infinity_double));


  point_addition #(n) paddition (.clk(clk), .reset(enable_add), .p(p), .x1(x1_add),
        .y1(y1_add), .x2(x2_add), .y2(y2_add), .x3(x3_add), .y3(y3_add), .result(result_add), .infinity(infinity_add));


  //get the last bit
  assign lastbit = k[0];
  assign done = (k == 0) ? 1 : 0; //check when scalar is done

  assign x1_done = (reset) ? 'hz : (addflag && result_add) ? x3_add : x1_done;
  assign y1_done = (reset) ? 'hz : (addflag && result_add) ? y3_add : y1_done;

  assign x1_add = (reset) ? 'hz : (addflag && counter == 1) ? x1_done : x1_add;
  assign y1_add = (reset) ? 'hz : (addflag && counter == 1) ? y1_done : y1_add;
  //initialize the input for point_addition module
  assign x2_add = (addflag && counter == 1) ? x3_double : x2_add;
  assign y2_add = (addflag && counter == 1) ? y3_double : y2_add;
  //initialize the input for point_doubling module
  assign x1_double = (initialDouble && ~result_double) ? x1 : (doubleflag && result_double) ? x3_double : x1_double;
  assign y1_double = (initialDouble && ~result_double) ? y1 : (doubleflag && result_double) ? y3_double : y1_double;


  always @ (posedge clk) begin
    if(reset) begin
      x3 <= 'hz;
      y3 <= 'hz;
      counterLast <= 0;
      k <= c;
      counter <= 0;
      initialDouble <= 1;
      doubleflag <= 0;
      addflag <= 0;
      resetdouble <= 0;
    end
    else begin
      if (counter == 1) counter <= 0; //only set the input for paddition once in the beginning
      //if pointaddition is taking place, check if it's finished
      if(addflag && result_add) begin
        addflag <= 0;
        doubleflag <= 1;
      end
      //if pointdoubling is taking place, check if it's finished
      if(doubleflag && result_double) begin
        doubleflag <= 0;
        initialDouble <= 0;
        k = k >> 1;
        counterLast <= 0; //to control the lastbit
      end

      if(lastbit && counterLast == 0) begin
        addflag <= 1;
        counter <= 1;
        counterLast <= 1;
        doubleflag <= 0;
      end
      else if (~addflag) doubleflag <= 1;

      if (done) begin
        x3 <= x1_done;
        y3 <= y1_done;
      end

    end
  end


endmodule // double_and_add
