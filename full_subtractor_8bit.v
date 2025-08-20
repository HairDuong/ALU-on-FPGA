module full_subtractor (
  input A,B,Bin,
  output Diff, Bout);
  assign Diff = A ^ B ^ Bin;
  assign Bout = (~A & B) | ((~A | B) & Bin);
endmodule
  
module Full_subtractor_8bit (
  input [7:0] A,B,
  output [7:0] Diff,
  input Bin,
  output Bout);
  wire b1, b2, b3;

  
  full_subtractor fs0 (.A(A[0]), .B(B[0]), .Bin(Bin),  .Diff(Diff[0]), .Bout(b1));
  full_subtractor fs1 (.A(A[1]), .B(B[1]), .Bin(b1),   .Diff(Diff[1]), .Bout(b2));
  full_subtractor fs2 (.A(A[2]), .B(B[2]), .Bin(b2),   .Diff(Diff[2]), .Bout(b3));
  full_subtractor fs3 (.A(A[3]), .B(B[3]), .Bin(b3),   .Diff(Diff[3]), .Bout(b4));
  full_subtractor fs4 (.A(A[4]), .B(B[4]), .Bin(b4),   .Diff(Diff[4]), .Bout(b5));
  full_subtractor fs5 (.A(A[5]), .B(B[5]), .Bin(b5),   .Diff(Diff[5]), .Bout(b6));
  full_subtractor fs6 (.A(A[6]), .B(B[6]), .Bin(b6),   .Diff(Diff[6]), .Bout(b7));
  full_subtractor fs7 (.A(A[7]), .B(B[7]), .Bin(b7),   .Diff(Diff[7]), .Bout(Bout));

endmodule