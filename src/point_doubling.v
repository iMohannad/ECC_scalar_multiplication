

// Input: P = (x1, y1),
// Output: P + Q = (x3, y3)
module point_doubling #(parameter n = 231) (clk, reset, p, x1, y1, a, x3, y3, result, infinity);
  input clk, reset;
  input [n-1:0] p, x1, y1, a;
  output reg [n-1:0] x3, y3;
  output infinity;
  output reg result;
  wire [n-1:0] lambda;
  wire [n-1:0] x1x3_diff;
  wire [n-1:0] denominator;   //denominator of lambda
  wire [n-1:0] numerator;     //numerator of lambda
  wire result_ready;          //to check if the modular inverse is ready
  reg enable; //to reset multiplicative inverse
  wire [n-1:0] denominator_inv, x1x1, lambda2;
  reg [n-1:0] xreg = 'hx;
  wire multi_result, multi_result1;
  reg [n-1:0] A, B, A1, B1;
  wire [n-1:0] M, M1;
  //compute the numerator 3x1^2 + a
  assign numerator = (multi_result1) ? 3*M1 + a % p : numerator;
  //compute the denominator 2y
  assign denominator = (2*y1) % p;

  wire lambda2_flag;
  assign lambda2_flag = (reset) ? 0 : (A === xreg || A === 0) ? 0 : (A == lambda && B == lambda);

  //find the negative of y1 to check if the result is infinity.
  //The result is infinity if x1 = x2, and y1 = -y2
  wire [n-1:0] neg_y = (-y1 < 0) ? -y1 + p : -y1;

  //it needs to be multiplied by the inverse.
  assign lambda = (multi_result && lambda2_flag !== 1) ? M : lambda;
  assign x1x1 = (x1 + x1)  % p;
  assign lambda2 = (lambda2_flag && multi_result) ? M : lambda2; //lambda^2
  assign x1x3_diff = (x1 >= x3) ? (x1 - x3) : (x1 + p - x3);
  assign infinity = (y1 == -y1) ? 1 : 0; //The result is infinity if y1 == -y1
  reg enable_mult;
  reg reset1;
  reg numerator_flag, denominator_flag;
  reg flagx3, flag1;
  reg init;
  
  wire flag2 = (init) ? 0 : (result) ? 1 : result;

  modular_multiplier #(n) multiplier1 (.clk(clk), .reset(reset1), .A(A1), .B(B1), .M(M1), .p(p), .flag(multi_result1));

  modular_multiplier #(n) multiplier (.clk(clk), .reset(enable_mult), .A(A), .B(B), .M(M), .p(p), .flag(multi_result));
  multiplicative_inverse #(n) multi_inv (.clk(clk), .reset(reset), .enable(enable), .p(p), .A(denominator), .X(denominator_inv), .result_ready(result_ready));


  always @ (posedge clk) begin
    if (reset) begin
      x3 <= x1;
      flagx3 <= 0;
      result <= 0;
      init <= 1;
      reset1 <= 1;
      //reset <= 0;
    end
    else begin
      if (init) begin
        A1 <= x1;
        B1 <= x1;
        x3 <= x1;
        flag1 <= 0;
        flagx3 <= 0;
        init <= 0;
        reset1 <= 0;
        //denominator_flag <= 0;
      end
      if (multi_result1) begin
        reset1 <= 1;
        //numerator_flag <= 1;
      end
      //if (result_ready) denominator_flag <= 1;
      if (enable_mult) enable_mult <= 0;
      if (enable) enable <= 0;
      //Check if y1 == -y1, then the point is infinity
      if (infinity) begin
        x3 = 'hz;
        y3 = 'hz;
      end
      else begin
        if (lambda2_flag !== 1) begin
          if (result_ready && ~flagx3) begin
            A <= numerator;
            B <= denominator_inv;
            flag1 <= 1;
          end
          else if (multi_result && flag1) begin
            //get lambda^2
            A <= lambda;
            B <= lambda;
          end
        end
        //only assign the results once the modular_inverse is ready
        if (lambda2_flag && multi_result) begin
          if(lambda2 < x1x1) x3 = (lambda2 + p - x1x1) % p;
          else x3 = (lambda2 - x1x1) % p;
          flagx3 <= 1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      y3 <= y1;
    end
    else begin
      if (result) begin
        result <= 0;
        flagx3 <= 0;
        enable <= 1;
        //reset <= 1;
      end
      if (flagx3 && ~multi_result && ~flag2) begin
        A <= lambda;
        B <= x1x3_diff;
      end
      else if(flagx3) begin
        y3 <= (M - y1 + p) % p;
        result <= 1;
        numerator_flag <= 0; //reset the value;
        denominator_flag <= 0;
      end
    end
  end

  always @ (A or B) begin
    enable_mult <= 1;
  end

  always @ (x1 or y1) begin
    init <= 1;
    reset1 <= 1;
  end

endmodule // point_doubling
