# Verification Environment for a FIFO

This project provides a complete SystemVerilog UVM (Universal Verification Methodology) testbench for a Verilog-based FIFO buffer.

## Overview

The primary goal of this repository is to demonstrate a standard, reusable UVM environment for verifying a simple hardware block. The environment is built to be "plug-and-play," allowing for easy integration and extension.

The **Design Under Test (DUT)** is a synchronous FIFO written in Verilog (`fifo.v`). The testbench is written entirely in SystemVerilog using UVM 1.2.

## How to Run

This entire project is set up and ready to run on EDA Playground. I used Questa and Riviera.
**[EDA Playground link](https://www.edaplayground.com/x/vbsN)**

## Testbench Architecture

The testbench follows a standard UVM architecture.


* **`tb_top` (Top-Level Module):**
    * Defined inside (`testbench.sv`).
    * Instantiates the DUT (`fifo.v`).
    * Instantiates the `SystemVerilog interface` (`interface.sv`).
    * Connects the interface to the DUT.
    * Calls `run_test()` to start the UVM simulation.

* **UVM Components (separate files included in `fifo_pkg`):**
    * **`seq_item`**: The transaction item, defining the basic operations (`wr_en`, `rd_en`, `wdata`).
    * **`base_seq`**: Defines base test sequence.
    * **`fill_and_empty_seq`**: Defines a test sequence to repeatedly fill and empty the FIFO.
    * **`alternating_access_seq`**: Defines a test sequence to alternate between reads and writes.
    * **`driver`**: Drives the `seq_item` transactions to the DUT.
    * **`monitor`**: Passively observes the interface, collects pin-level activity, and broadcasts transactions to the `scoreboard`.
    * **`sequencer`**: Defines sequencer class.
    * **`agent`**: A container that encapsulates the driver, monitor, and sequencer. Functions as only monitor when `UVM_PASSIVE`.
    * **`scoreboard`**: Contains an internal reference model (queue) to predict behavior and compare it against the DUT's output.
    * **`env`**: The top-level UVM environment that instantiates the agent and the scoreboard.
    * **`base_test`**: Builds the environment and starts all sequences parallelly.
