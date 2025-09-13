class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  env env_o;
  base_seq bseq;
  fill_and_empty_seq fe_seq;
  alternating_access_seq alt_seq;

  function new(string name="base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = base_seq::type_id::create("bseq");
    fe_seq = fill_and_empty_seq::type_id::create("fe_seq");
    alt_seq = alternating_access_seq::type_id::create("alt_seq");

	fork
    	bseq.start(env_o.agt.seqr);
    	fe_seq.start(env_o.agt.seqr);
    	alt_seq.start(env_o.agt.seqr);
  	join
//     bseq.start(env_o.agt.seqr);
    #100;
    phase.drop_objection(this);
  endtask

endclass