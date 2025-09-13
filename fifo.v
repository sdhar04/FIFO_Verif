module FIFO (
  output [7:0] data_out,
  output full, empty,
  input [7:0] data_in,
  input clock, reset, wn, rn
);
  // Choose pointers to be 4 bits wide
  reg [3:0] wptr, rptr; 
  reg [7:0] memory [7:0];

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      integer i;
      for (i=0; i < 8; i=i+1)
        memory[i] <= 0;
      wptr <= 0;
      rptr <= 0;
    end
    else begin
      if (wn && !full) begin
        // Use lower 3 bits of wptr
        memory[wptr[2:0]] <= data_in; 
        wptr <= wptr + 1;
      end
      if (rn && !empty) begin
        rptr <= rptr + 1;
      end
    end
  end

  // Use lower 3 bits of rptr
  assign data_out = !empty ? memory[rptr[2:0]] : 8'd0;

  // Full and empty logic for 4-bit pointers
  assign full = (wptr[2:0] == rptr[2:0]) && (wptr[3] != rptr[3]);
  assign empty = (wptr == rptr);

endmodule
