class print_component extends uvm_component;
`uvm_analysis_imp_decl(_decode_in_ap);
`uvm_analysis_imp_decl(_decode_out_ap);
`uvm_component_utils( print_component );


uvm_analysis_imp_decode_in_ap #(decode_in_transaction, print_component) decode_in_ap;
uvm_analysis_imp_decode_out_ap #(decode_out_transaction, print_component) decode_out_ap;

function new (string name="", uvm_component parent=null);
	super.new(name,parent);
	decode_in_ap = new("decode_in_ap", this);
	decode_out_ap = new("decode_out_ap", this);
endfunction 


virtual function void write_decode_in_ap(decode_in_transaction trans);
	//$display("Time:%d DECODE_IN_TRANSACTION RECEIVED AT PRINT_COMPONENT- ENABLE_DECODE:%b, INSTR_DOUT:%h, NPC_IN:%h", $time, trans.enable_decode,
	 //trans.instr_dout, trans.npc_in);
	`uvm_info("print_component", {"Received DECODE_IN_TRANSACTION: ", trans.convert2string()}, UVM_LOW);
endfunction

virtual function void write_decode_out_ap(decode_out_transaction trans);
	//$display("Time:%d DECODE_OUT_TRANSACTION RECEIVED AT PRINT_COMPONENT - E_control:%h, W_control:%h, Mem_control:%b, IR:%h, NPC_OUT:%h", $time,
		//trans.E_control, trans.W_control, trans.Mem_control, trans.IR, trans.npc_out);
	`uvm_info("print_component", {"Received DECODE_OUT_TRANSACTION: ", trans.convert2string()}, UVM_LOW);
endfunction

endclass