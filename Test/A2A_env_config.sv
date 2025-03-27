class A2A_env_config extends uvm_object;

`uvm_object_utils(A2A_env_config)

int no_of_ahb_agents;
int no_of_apb_agents;
int has_scoreboard;
int has_virtual_sequencer;

A2A_ahb_agt_config ahb_cfg[];
A2A_apb_agt_config apb_cfg[];

extern function new(string name="A2A_env_config");

endclass

function A2A_env_config::new(string name="A2A_env_config");
	super.new(name);
endfunction
