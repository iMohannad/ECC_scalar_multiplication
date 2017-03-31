module multiplicative_inverse #(parameter n = 231)(clk, reset, p, A, X, result_ready);
  input clk, reset;
  input wire [n-1:0] p;
  input wire [n-1: 0] A;
  output reg [n-1:0] X;
  output reg result_ready;

  //flag to initalize variables when reset
  reg flag;


  reg [n-1:0] Y, D, B;

  wire Y0 = (Y[0] == 0) ? 1 : 0;
  wire D0 = (D[0] == 0) ? 1 : 0;

  reg flagY0 = 1;
  reg flagD0 = 1;

  always @ (posedge clk) begin
    if (reset) begin
      X <= 0;
      flag <= 1;
      result_ready <= 0;
    end
    else begin
      if (flag) begin
        Y <= A;
        D <= p;
        B <= 1;
        X <= 0;
        flag <= 0;
      end
      else begin
        if (Y != 0) begin
          if (Y0 && flagY0) begin
            Y = Y >> 1;
            B = (B + (B[0]*p)) >> 1;
          end //end if
          else begin
            flagY0 = 0;
          end
          if (D0 && flagD0) begin
            D = D >> 1;
            X = (X + (X[0]*p)) >> 1;
          end //end if
          else begin
            flagD0 = 0;
          end
          if((flagY0 == 0) && (flagD0 == 0)) begin
            if (Y >= D) begin
              Y = Y - D;
              if(B < X) B = B + p;
              B = (B - X) % p;
            end
            else begin
              if(D < Y) D = D + p;
              D = D - Y;
              if(X < B) X = X + p;
              X = (X - B) % p;
            end //else
            flagY0 = 1;
            flagD0 = 1;
          end //else
        end //end if
        else begin
          result_ready <= 1;
        end
      end
    end
  end




endmodule // multiplicative_inverse
