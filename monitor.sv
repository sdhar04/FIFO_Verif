class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  uvm_analysis_port#(seq_item) item_collect_port;
  virtual fifo_if vif;
  seq_item mon_item;

  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set on top level");
  endfunction

  virtual task run_phase(uvm_phase phase);
    mon_item = seq_item::type_id::create("mon_item");
    forever begin
      @(posedge vif.clock);
      if (vif.wn == 1) begin
        mon_item.data_in = vif.data_in;
        mon_item.wn = 1'b1;
        mon_item.rn = 1'b0;
        mon_item.full = vif.full;
        `uvm_info("MONITOR", $sformatf("Monitoring data: \nwn=%0d \nFULL=%0d \nDATA_IN=%0d", mon_item.wn, mon_item.full, mon_item.data_in), UVM_LOW);
        item_collect_port.write(mon_item);
      end
      else if (vif.rn == 1) begin
        mon_item.data_out = vif.data_out;
        mon_item.rn = 1'b1;
        mon_item.wn = 1'b0;
        mon_item.empty = vif.empty;
        `uvm_info("MONITOR", $sformatf("Monitoring data: \nrn=%0d \nEMPTY=%0d \nDATA_OUT=%0d", mon_item.rn, mon_item.empty, mon_item.data_out), UVM_LOW);
        item_collect_port.write(mon_item);
      end
    end
  endtask
endclass
