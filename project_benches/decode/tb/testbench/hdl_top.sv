module hdl_top();


import uvm_pkg::*;
import uvmf_base_pkg_hdl::*;
import uvmf_base_pkg::*;
`include "uvm_macros.svh"
import decode_in_pkg::*;
import decode_out_pkg::*;
import decode_test_pkg::*;

// CLOCK AND RESET SIGNALS
bit clock;
bit reset;

//DECODE BLOCK INPUT SIGNALS
wire [15:0] npc_in;
wire [15:0] instr_dout;
wire enable_decode;
wire [2:0] psr;

//DECODE BLOCK OUTPUT SIGNALS
wire Mem_control;
wire [1:0] W_control;
wire [5:0] E_control;
wire [15:0] IR;
wire [15:0] npc_out;


//Instantiate the DUT
Decode DECODE_DUT (.clock(clock), .reset(reset), .enable_decode(enable_decode), .dout(instr_dout), .E_Control(E_control), .npc_in(npc_in), .Mem_Control(Mem_control), .W_Control(W_control), .IR(IR), .npc_out(npc_out));

//Decode Input Interfaces and BFMs
decode_in_if decode_in_if_top (.clock(clock), .reset(reset), .npc_in(npc_in), .instr_dout(instr_dout), .enable_decode(enable_decode), .psr(psr));
decode_in_driver_bfm decode_in_driver_bfm_top (decode_in_if_top);
decode_in_monitor_bfm decode_in_monitor_bfm_top (decode_in_if_top);

//Decode Output Interfaces and BFMs
decode_out_if decode_out_if_top (.clock(clock), .reset(reset), .E_control(E_control), .npc_out(npc_out), .Mem_control(Mem_control), .W_control(W_control), .IR(IR));
decode_out_driver_bfm decode_out_driver_bfm_top (decode_out_if_top);
decode_out_monitor_bfm decode_out_monitor_bfm_top (decode_out_if_top);


//Generate Clock and Reset
initial
	begin
	forever #5 clock = ~clock;
	end

initial begin
	#20 reset = 1'b1;
	#10 reset = 1'b0;
	end

//Set the virtual interface handles in Config_db
initial begin
	uvm_config_db#(virtual decode_in_driver_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in_if", decode_in_driver_bfm_top);
	uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in_if", decode_in_monitor_bfm_top);

	uvm_config_db#(virtual decode_out_driver_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_out_if", decode_out_driver_bfm_top);
	uvm_config_db#(virtual decode_out_monitor_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_out_if", decode_out_monitor_bfm_top);
    	end

endmodule
