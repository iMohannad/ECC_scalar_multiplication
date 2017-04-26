

// Input: P = (x1, y1), Q = (x2, y2).
// Output: P + Q = (x3, y3)
module point_addition #(parameter n = 231) (clk, reset, p, x1, y1, x2, y2, x3, y3, result, infinity);
  input clk, reset;
  input [n-1:0] p, x1, y1, x2, y2;
  output reg [n-1:0] x3, y3;
  output infinity;
  output reg result;
  wire [n-1:0] lambda;
  wire [n-1:0] y_diff;
  wire [n-1:0] x_diff;
  wire [n-1:0] x1x3_diff;
  wire result_ready;
  assign y_diff = (y2 >= y1) ? y2 - y1 : (y2-y1)+p;
  assign x_diff = (x2 >= x1) ? x2 - x1 : (x2 - x1) + p;
  reg enable;
  wire [n-1:0] x_diff_inv, x1x2, lambda2;

  reg [n-1:0] zreg = 'hz; //a register to compare infintiy points
  reg [n-1:0] xreg = 'hx;
  wire multi_result;
  reg [n-1:0] A, B;
  wire [n-1:0] M;

  wire lambda2_flag;
  assign lambda2_flag = (reset) ? 0 : (A === xreg) ? 0 : (A == lambda && B == lambda);
  //find the negative of y1 to check if the result is infinity.
  //The result is infinity if x1 = x2, and y1 = -y2
  wire [n-1:0] neg_y = (-y1 < 0) ? -y1 + p : -y1;

  wire result_ready_flag = lambda2_flag;
  wire addinf = ((x2 === zreg && y2 === zreg) && (x1 !== zreg && y1 !== zreg)) || ((x1 === zreg && y1 === zreg) && (x2 !== zreg && y2 !== zreg));


  //it needs to be multiplied by the inverse.
  //assign lambda = (result_ready) ? (y_diff * x_diff_inv) % p : lambda;
  assign lambda = (multi_result && lambda2_flag !== 1) ? M : lambda;
  assign x1x2 = (x1 + x2) % p;
  //assign lambda2 = (lambda * lambda) % p;
  assign lambda2 = (lambda2_flag && multi_result) ? M : lambda2;
  assign x1x3_diff = (x1 >= x3) ? (x1 - x3) : (x1 + p - x3);
  assign infinity = (x_diff == 0) ? 1 : 0; //The result is infinity if x_diff is 0
  reg enable_mult;
  wire reset_mult = enable_mult;
  modular_multiplier #(n) multiplier (.clk(clk), .reset(enable_mult), .A(A), .B(B), .M(M), .p(p), .flag(multi_result));
  multiplicative_inverse #(n) multi_inv (.clk(clk), .reset(reset), .enable(enable), .p(p), .A(x_diff), .X(x_diff_inv), .result_ready(result_ready));

  reg x3_ready;

  always @ (posedge clk) begin
    if (reset) begin
      x3 <= 0;
      result <= 0;
      enable_mult <= 1;
    end
    else begin
      if (enable_mult) enable_mult <= 0;
      if (result) begin
        result <= 0;
        x3_ready <= 0;
        enable <= 1;
      end
      else if(addinf) begin
        if (x1 === zreg) begin
          x3 <= x2;
          y3 <= y2;
        end
        else begin
          x3 <= x1;
          y3 <= y1;
        end
        result <= 1;
      end
      //Check if xdiff = 0, then the point is infinity
      else if (infinity) begin
        x3 = 'hz;
        y3 = 'hz;
        result <= 1;
      end
      else begin
        if (lambda2_flag !== 1) begin
          if (result_ready) begin
            A <= y_diff;
            B <= x_diff_inv;
          end
          else if (multi_result) begin
            A <= lambda;
            B <= lambda;
            //lambda2_flag <= 1;
          end
        end

        //only assign the results once the modular_inverse is ready
        if (lambda2_flag && multi_result) begin
          if(lambda2 < x1x2) x3 <= (lambda2 + p - x1x2) % p;
          else x3 <= (lambda2 - x1x2) % p;
          x3_ready <= 1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      y3 = 0;
    end
    else begin
      if(x3_ready && ~multi_result) begin
        A <= lambda;
        B <= x1x3_diff;
        //enable_mult <= 1;
      end
      else if (x3_ready) begin
        y3 <= (M - y1 + p) % p;
        result <= 1;
      end
    end
  end

  always @ (A or B) begin
    enable_mult <= 1;
  end

endmodule // point_addition
