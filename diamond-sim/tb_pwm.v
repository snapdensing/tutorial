`timescale 1ns/1ps
`define CLK_PERIOD 34  //~29.4MHz
module tb_pwm;
  parameter SEL0_HI = 32'd10;
  parameter SEL0_LO = 32'd10;
  parameter SEL1_HI = 32'd10;
  parameter SEL1_LO = 32'd20;
  parameter SEL2_HI = 32'd20;
  parameter SEL2_LO = 32'd10;
  parameter SEL3_HI = 32'd100;
  parameter SEL3_LO = 32'd300;

  reg clk, nrst, en;
  reg [1:0] sel;
  wire pwm_out;

  pwm #(
    .SEL0_HI (SEL0_HI),
    .SEL0_LO (SEL0_LO),
    .SEL1_HI (SEL1_HI),
    .SEL1_LO (SEL1_LO),
    .SEL2_HI (SEL2_HI),
    .SEL2_LO (SEL2_LO),
    .SEL3_HI (SEL3_HI),
    .SEL3_LO (SEL3_LO)
    ) UUT(
    .clk     (clk),
    .nrst    (nrst),
    .en      (en),
    .sel     (sel),
    .pwm_out (pwm_out)
    );

  always begin
    #(`CLK_PERIOD/2.0) clk = ~clk;
  end

  initial begin
    clk = 0;
    nrst = 0;
    en = 0;
    sel = 2'd0;

    #(`CLK_PERIOD * 10) nrst = 1'b1;

    #(`CLK_PERIOD * 10);
    en = 1'b1;

    #(`CLK_PERIOD * 200) en = 0;

    #(`CLK_PERIOD * 100) en = 1'b1;
    sel = 2'b01;

    #(`CLK_PERIOD * 200) en = 1'b1;
    sel = 2'b01;

    #(`CLK_PERIOD * 200) en = 1'b1;
    sel = 2'h3;

    #(`CLK_PERIOD * 300) en = 0;
  end
endmodule
