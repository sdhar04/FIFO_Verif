import uvm_pkg::*;
`include "uvm_macros.svh"

interface fifo_if(input logic clock, reset);
  logic wn;
  logic rn;
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic empty;
  logic full;

  clocking driver_cb@(posedge clock);
    default input #1 output #1;
    output wn;
    output rn;
    output data_in;
    input full;
    input empty;
    input data_out;
  endclocking

  clocking monitor_cb@(posedge clock);
    default input #1 output #1;
    input wn;
    input rn;
    input data_in;
    input full;
    input empty;
    input data_out;
  endclocking

  modport DRIVER (clocking driver_cb, input clock, reset);
  modport MONITOR (clocking monitor_cb, input clock, reset);

endinterface
    
package fifo_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "seq_item.sv"
  `include "base_seq.sv"
  `include "fill_and_empty_seq.sv"
  `include "alternating_access_seq.sv"
  `include "sequencer.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "scoreboard.sv"
  `include "agent.sv"
  `include "env.sv"
  `include "base_test.sv"
endpackage
    

import fifo_pkg::*;

module tb_top;
  bit clock;
  bit reset;

  always #5 clock = ~clock;

  initial begin
    clock = 0;
    reset = 1;
    #10 reset = 0;
  end

  fifo_if vif(clock, reset);
  FIFO DUT (
    .data_out(vif.data_out),
    .full(vif.full),
    .empty(vif.empty),
    .clock(vif.clock),
    .reset(vif.reset),
    .wn(vif.wn),
    .rn(vif.rn),
    .data_in(vif.data_in)
  );

  initial begin
    uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*", "vif", vif);
    run_test("base_test");
  end

endmodule