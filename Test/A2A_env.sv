class A2A_env extends uvm_env;
`uvm_component_utils(A2A_env);
A2A_env_config cfg;
A2A_scoreboard sb;
A2A_virtual_sequencer v_seqr;
A2A_ahb_agt_top ahb_top;
A2A_apb_agt_top apb_top;

extern function new(string name="A2A_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function A2A_env::new(string name="A2A_env",uvm_component parent);
	super.new(name,parent);
endfunction

function void A2A_env::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_env_config)::get(this,"","A2A_env_config",cfg))
		`uvm_fatal("env","cannot get config data");
	super.build_phase(phase);
	if(cfg.has_scoreboard)
		sb=A2A_scoreboard::type_id::create("sb",this);
	if(cfg.has_virtual_sequencer)
		v_seqr=A2A_virtual_sequencer::type_id::create("v_seqr",this);

		ahb_top=A2A_ahb_agt_top::type_id::create("ahb_top",this);

		apb_top=A2A_apb_agt_top::type_id::create("apb_top",this);
endfunction

function void A2A_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(cfg.has_virtual_sequencer)
	begin
	foreach(v_seqr.w_seqr[i])
		v_seqr.w_seqr[i]=ahb_top.ahb_agt[i].w_seqr;
	foreach(v_seqr.r_seqr[i])
		v_seqr.r_seqr[i]=apb_top.apb_agt[i].r_seqr;
	end
	if(cfg.has_scoreboard)
	begin
		foreach(ahb_top.ahb_agt[i])
		ahb_top.ahb_agt[i].wr_mon.analysis_port_wmon.connect(sb.analysis_fifo_wmon[i].analysis_export);
		foreach(apb_top.apb_agt[i])
		apb_top.apb_agt[i].rd_mon.analysis_port_rmon.connect(sb.analysis_fifo_rmon[i].analysis_export);
	end
endfunction
