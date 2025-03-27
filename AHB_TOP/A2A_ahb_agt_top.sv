class A2A_ahb_agt_top extends uvm_env;
`uvm_component_utils(A2A_ahb_agt_top);

A2A_env_config cfg;
A2A_ahb_agt_config ahb_cfg[];
A2A_ahb_agent ahb_agt[];

extern function new(string name="A2A_ahb_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function A2A_ahb_agt_top::new(string name="A2A_ahb_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction 

function void A2A_ahb_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_env_config)::get(this,"","A2A_env_config",cfg))
		`uvm_fatal("A2A_ahb_agt_top","cannot get env config data");
	ahb_cfg=new[cfg.no_of_ahb_agents];
	ahb_agt=new[cfg.no_of_ahb_agents];
	foreach(ahb_agt[i])
	 begin
		ahb_cfg[i]=cfg.ahb_cfg[i];
		ahb_agt[i]=A2A_ahb_agent::type_id::create($sformatf("ahb_agt[%0d]",i),this);
		uvm_config_db#(A2A_ahb_agt_config)::set(this,$sformatf("ahb_agt[%0d]*",i),"A2A_ahb_agt_config",ahb_cfg[i]);
       	 end
endfunction
