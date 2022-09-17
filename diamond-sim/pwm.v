module pwm #(
  parameter SEL0_HI = 32'd10,
  parameter SEL0_LO = 32'd10,
  parameter SEL1_HI = 32'd10,
  parameter SEL1_LO = 32'd20,
  parameter SEL2_HI = 32'd20,
  parameter SEL2_LO = 32'd10,
  parameter SEL3_HI = 32'd100,
  parameter SEL3_LO = 32'd300
  )(
  input  wire       clk,
  input  wire       nrst,
  input  wire       en,
  input  wire [1:0] sel,
  output reg        pwm_out
  );

  reg [31:0] per_hi, per_lo;
  always@(*)
    case(sel)
      2'd0: begin
        per_hi <= SEL0_HI - 1;
        per_lo <= SEL0_LO - 1;
        end
      2'd1: begin
        per_hi <= SEL1_HI - 1;
        per_lo <= SEL1_LO - 1;
        end
      2'd2: begin
        per_hi <= SEL2_HI - 1;
        per_lo <= SEL2_LO - 1;
        end
      2'd3: begin
        per_hi <= SEL3_HI - 1;
        per_lo <= SEL3_LO - 1;
        end
    endcase
  reg [31:0] ctr;

  reg [1:0] state;
  localparam S_IDLE = 0;
  localparam S_HI   = 1;
  localparam S_LO   = 2;
  always@(posedge clk or negedge nrst)
    if (!nrst)
      state <= S_IDLE;
    else
      if (en)
        case(state)
          S_IDLE:
            state <= S_HI;
          S_HI:
            if (ctr == 0)
              state <= S_LO;
            else
              state <= S_HI;
          S_LO:
            if (ctr == 0)
              state <= S_HI;
            else
              state <= S_LO;
          default:
            state <= S_IDLE;
        endcase
      else
        state <= S_IDLE;

  always@(posedge clk or negedge nrst)
    if (!nrst)
      ctr <= 0;
    else
      case(state)
        S_IDLE:
          ctr <= per_hi;
        S_HI:
	  if (ctr == 0)
            ctr <= per_lo;
          else
	    ctr <= ctr - 1;
        S_LO:
	  if (ctr == 0)
            ctr <= per_hi;
          else
            ctr <= ctr - 1;
        default:
          ctr <= 0;
      endcase

  always@(*)
    case(state)
      S_HI:    pwm_out <= 1'b1;
      default: pwm_out <= 0;
    endcase

endmodule
