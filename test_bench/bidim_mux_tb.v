module bidim_mux_tb ();

  /* local parameters */
  localparam  WIDTH       = 32;
  localparam  DEPTH       = 19;
  localparam  TOTAL_BITS  = WIDTH*DEPTH;
  localparam  SEL_WIDTH   = $clog2(DEPTH);
  localparam  MAX_VAL     = 2**WIDTH;

  /* dut regs and wires */
  reg   [WIDTH-1:0]       m_entries [DEPTH-1:0];
  wire  [TOTAL_BITS-1:0]  m_in;
  reg   [SEL_WIDTH-1:0]   m_ctrl;
  wire  [WIDTH-1:0]       m_out;
  reg   [SEL_WIDTH:0]     sim_count;

  /* integers and genvars */
  integer i,idx;
  genvar I;

  /* gather */
  generate
    for(I=0; I<DEPTH; I=I+1) begin: gather_forloop
      assign m_in[(I*WIDTH)+:WIDTH] = m_entries[I];
    end
  endgenerate

  /* dut */
  bidim_mux
    # (
        .WIDTH (WIDTH),
        .DEPTH (DEPTH)
      )
    dut (
        .m_in   (m_in),
        .m_ctrl (m_ctrl),
        .m_out  (m_out)
      );

  /* initial */
  initial begin
    for(i=0; i<DEPTH; i=i+1) begin
      m_entries[i] = $urandom%(MAX_VAL-1);
    end
    m_ctrl    = 0;
    sim_count = 0;
    $dumpfile("bidim_mux.vcd");
    $dumpvars();
    for (idx = 0; idx < DEPTH; idx = idx+1) $dumpvars(0, bidim_mux_tb.m_entries[idx]);
  end

  /* simulation */
  always begin
    while(sim_count<DEPTH) begin
      #100 m_ctrl = m_ctrl + 1;
           sim_count = sim_count + 1;
    end
    $finish;
  end

endmodule // bidim_mux_tb
