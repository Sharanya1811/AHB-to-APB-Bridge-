class A2A_ahb_agent extends uvm_agent;
`uvm_component_utils(A2A_ahb_agent);
A2A_ahb_agt_config ahb_cfg;
ahb_wr_seqr w_seqr;
ahb_wr_driver wr_dr;
ahb_wr_mon wr_mon;
extern function new(string name="A2A_ahb_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function A2A_ahb_agent::new(string name="A2A_ahb_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void A2A_ahb_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_ahb_agt_config)::get(this,"","A2A_ahb_agt_config",ahb_cfg))
		`uvm_fatal("wr_agt","cannot get config data");
	super.build_phase(phase);
	wr_mon=ahb_wr_mon::type_id::create("wr_mon",this);
	if(ahb_cfg.is_active==UVM_ACTIVE)
		begin
			w_seqr=ahb_wr_seqr::type_id::create("w_seqr",this);
			wr_dr=ahb_wr_driver::type_id::create("wr_dr",this);
		end
endfunction

function void A2A_ahb_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	wr_dr.seq_item_port.connect(w_seqr.seq_item_export);
endfunction
