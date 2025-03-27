class A2A_apb_agt_top extends uvm_env;
`uvm_component_utils(A2A_apb_agt_top);

A2A_env_config cfg;
A2A_apb_agt_config apb_cfg[];
A2A_apb_agent apb_agt[];

extern function new(string name="A2A_apb_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function A2A_apb_agt_top::new(string name="A2A_apb_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction 

function void A2A_apb_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_env_config)::get(this,"","A2A_env_config",cfg))
		`uvm_fatal("AGT_TOP","cannot get config data");
	apb_cfg=new[cfg.no_of_apb_agents];
	apb_agt=new[cfg.no_of_apb_agents];
	foreach(apb_agt[i]) begin
	apb_cfg[i]=cfg.apb_cfg[i];
	apb_agt[i]=A2A_apb_agent::type_id::create($sformatf("apb_agt[%0d]",i),this);
	uvm_config_db#(A2A_apb_agt_config)::set(this,$sformatf("apb_agt[%0d]*",i),"A2A_apb_agt_config",apb_cfg[i]);
	end
endfunction
