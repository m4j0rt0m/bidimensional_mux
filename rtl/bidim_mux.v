module bidim_mux
# (
    parameter WIDTH = 2,
    parameter DEPTH = 4
  )
(/*AUTOARG*/
   // Outputs
   m_out,
   // Inputs
   m_in, m_ctrl
   );

  /* local parameters */
  localparam  TOTAL_BITS  = WIDTH * DEPTH;
  localparam  SEL_WIDTH   = $clog2(DEPTH);

  /* ports */
  input   [TOTAL_BITS-1:0]  m_in;
  input   [SEL_WIDTH-1:0]   m_ctrl;
  output  [WIDTH-1:0]       m_out;

  /* regs and wires */
  reg  [WIDTH-1:0] div_in  [DEPTH-1:0];

  integer i;

  /* splitter */
  always @ (*)  begin
    for (i=0; i<DEPTH; i=i+1) begin
      div_in[i]  = m_in[(i*WIDTH)+:WIDTH];  //  div_in[i] = m_in[((i+1)*WIDTH)-1:(i*WIDTH)];
    end
  end

  /* selector */
  assign m_out = div_in[m_ctrl];

endmodule // bidimen_mux
