class base_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(base_seq)

  function new(string name="base_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), $sformatf("******** Generate 64 Write REQS *********"), UVM_LOW)
    repeat (64) begin
      req = seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {wn==1;});
      finish_item(req);
    end

    `uvm_info(get_type_name(), $sformatf("******** Generate 64 Read REQS ********"), UVM_LOW)
    repeat (64) begin
      req = seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {rn==1;});
      finish_item(req);
    end

    `uvm_info(get_type_name(), $sformatf("******** Generate 128 Random REQS *********"), UVM_LOW)
    repeat (128) begin
      req = seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
endclass