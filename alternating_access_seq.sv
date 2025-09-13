class alternating_access_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(alternating_access_seq)

  function new(string name="alternating_access_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting alternating write/read test...", UVM_LOW)
    // Do 20 alternating write/read pairs
    repeat (20) begin
      // Write one item
      req = seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { wn == 1; });
      finish_item(req);

      // Read one item
      req = seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { rn == 1; });
      finish_item(req);
    end
  endtask
endclass