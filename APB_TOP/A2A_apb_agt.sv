class A2A_apb_agent extends uvm_agent;
`uvm_component_utils(A2A_apb_agent);
apb_rd_seqr r_seqr;
apb_rd_driver rd_dr;
apb_rd_mon rd_mon;
A2A_apb_agt_config apb_cfg;
extern function new(string name="A2A_apb_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function A2A_apb_agent::new(string name="A2A_apb_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void A2A_apb_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_apb_agt_config)::get(this,"","A2A_apb_agt_config",apb_cfg))
		`uvm_fatal("R_AGENT","cannot get config data");
	super.build_phase(phase);
	rd_mon=apb_rd_mon::type_id::create("rd_mon",this);
	if(apb_cfg.is_active==UVM_ACTIVE)
		begin
		r_seqr=apb_rd_seqr::type_id::create("r_seqr",this);
		rd_dr=apb_rd_driver::type_id::create("rd_dr",this);
		end
endfunction

function void A2A_apb_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rd_dr.seq_item_port.connect(r_seqr.seq_item_export);
endfunction
