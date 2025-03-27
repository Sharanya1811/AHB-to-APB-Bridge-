class A2A_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
`uvm_component_utils(A2A_virtual_sequencer);
ahb_wr_seqr w_seqr[];
A2A_env_config cfg;
apb_rd_seqr r_seqr[];
extern function new(string name="A2A_virtual_sequencer",uvm_component parent);
extern function void build_phase (uvm_phase phase);
endclass

function A2A_virtual_sequencer::new(string name="A2A_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

function void A2A_virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_env_config)::get(this,"","A2A_env_config",cfg))
		`uvm_fatal("VIRTUAL_SEQUENCER","cannot get config data");
	w_seqr=new[cfg.no_of_ahb_agents];
	r_seqr=new[cfg.no_of_apb_agents];
endfunction
