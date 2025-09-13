class fill_and_empty_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(fill_and_empty_seq)

  function new(string name="fill_and_empty_seq");
    super.new(name);
  endfunction

  virtual task body();
    // Repeat the fill-and-empty process 5 times
    repeat (5) begin
      `uvm_info(get_type_name(), "Filling the FIFO...", UVM_LOW)
      // Write exactly 8 items to fill it
      repeat (8) begin
        req = seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { wn == 1; });
        finish_item(req);
      end

      `uvm_info(get_type_name(), "Emptying the FIFO...", UVM_LOW)
      // Read exactly 8 items to empty it
      repeat (8) begin
        req = seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { rn == 1; });
        finish_item(req);
      end
    end
  endtask
endclass