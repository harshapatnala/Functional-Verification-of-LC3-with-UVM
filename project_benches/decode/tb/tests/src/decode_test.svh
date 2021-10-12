class test_top extends uvm_test;

	`uvm_component_utils(test_top)

	decode_in_configuration decode_in_cfg_inst;
	decode_in_agent decode_in_agent_inst;

	decode_out_agent decode_out_agent_inst;
	decode_out_configuration decode_out_cfg_inst;

	decode_in_random_sequence decode_in_rand_seq;

	print_component print_component_inst;

	//uvmf_active_passive_t decode_in_agent_activity = ACTIVE;
	//uvmf_active_passive_t decode_out_agent_activity = PASSIVE;

	function new(string name = "", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		decode_in_cfg_inst = decode_in_configuration::type_id::create("decode_in_cfg_inst", this);
		decode_in_agent_inst = decode_in_agent::type_id::create("decode_in_agent_inst", this);
		decode_out_cfg_inst = decode_out_configuration::type_id::create("decode_out_cfg_inst", this);
		decode_out_agent_inst = decode_out_agent::type_id::create("decode_out_agent_inst", this);
		
		decode_in_cfg_inst.initialize(ACTIVE, "uvm_test_top.decode_in_agent_inst", "decode_in_if");
		decode_out_cfg_inst.initialize(PASSIVE, "uvm_test_top.decode_out_agent_inst", "decode_out_if");
		decode_in_cfg_inst.initiator_responder = INITIATOR;

		print_component_inst = print_component::type_id::create("print_component_inst", this);

		decode_in_rand_seq = decode_in_random_sequence::type_id::create("decode_in_rand_seq");
		
	
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		decode_in_agent_inst.monitored_ap.connect(print_component_inst.decode_in_ap);
		decode_out_agent_inst.monitored_ap.connect(print_component_inst.decode_out_ap);
	endfunction


	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this, "OBJECTION RAISED BY DECODE TEST");
		decode_in_cfg_inst.monitor_bfm.wait_for_reset();
		repeat(25) decode_in_rand_seq.start(decode_in_agent_inst.sequencer);
		decode_in_cfg_inst.monitor_bfm.wait_for_num_clocks(3);
		phase.drop_objection(this, "OBJECTION DROPPED BY DECODE TEST");
	
	endtask

endclass
