class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_analysis_imp#(seq_item, scoreboard) item_collect_export;
  int expected_data_queue[$];

  seq_item cov_data_pkt;
  covergroup fifo_coverage;
    option.per_instance = 1;
    DATA_IN: coverpoint cov_data_pkt.data_in { bins MAX[] = {[0:255]}; }
    WRITE_CMD: coverpoint cov_data_pkt.wn { bins write_dut[] = {0,1}; }
    READ_CMD: coverpoint cov_data_pkt.rn { bins read_dut[] = {0,1}; }
    EMPTY_CMD: coverpoint cov_data_pkt.empty { bins empty_dut[] = {0,1}; }
    FULL_CMD: coverpoint cov_data_pkt.full { bins full_dut[] = {0,1}; }
    READXWRITE: cross WRITE_CMD, READ_CMD;
  endgroup

  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
    item_collect_export = new("item_collect_export", this);
    fifo_coverage = new();
  endfunction

  function void write(seq_item req);
    cov_data_pkt = req;
  	fifo_coverage.sample();

  	if (req.wn == 1'b1 && req.full == 1'b0) begin
    	expected_data_queue.push_back(req.data_in);
    	`uvm_info(get_type_name(), $sformatf("SCOREBOARD: Write Accepted. Queueing %d. Queue size: %d", req.data_in, expected_data_queue.size()), UVM_HIGH)
  	end

  	if (req.rn == 1'b1 && req.empty == 1'b0) begin
    	if (expected_data_queue.size() > 0) begin
      		int expected_data = expected_data_queue.pop_front();
      	if (req.data_out == expected_data) begin
        	`uvm_info(get_type_name(), $sformatf("MATCH: DATA_OUT=%d, Expected=%d", req.data_out, expected_data), UVM_LOW);
      	end else begin
        	`uvm_error(get_type_name(), $sformatf("MISMATCH: DATA_OUT=%d, Expected=%d", req.data_out, expected_data));
      	end
    	end else begin
        	`uvm_error(get_type_name(), "SCOREBOARD: DUT provided data when checker expected none.");
    	end
  	end
  endfunction
  
  function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      $display("---------------------------------------------------------");
      $display("                Coverage Report                          ");
      $display("Overall Coverage: %0.2f%%", fifo_coverage.get_inst_coverage());
      $display("---------------------------------------------------------");
  endfunction

endclass
