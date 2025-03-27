class A2A_ahb_agt_config extends uvm_object;

`uvm_object_utils(A2A_ahb_agt_config)
uvm_active_passive_enum is_active=UVM_ACTIVE;
virtual AHB_if vif;

extern function new(string name="A2A_ahb_agt_config");

endclass

function A2A_ahb_agt_config::new(string name="A2A_ahb_agt_config");
	super.new(name);
endfunction
