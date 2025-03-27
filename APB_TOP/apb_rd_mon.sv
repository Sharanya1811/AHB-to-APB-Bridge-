class apb_rd_mon extends uvm_monitor;
`uvm_component_utils(apb_rd_mon);
virtual APB_if.APB_MON_MP vif;
A2A_apb_agt_config apb_cfg;
uvm_analysis_port #(apb_xtn) analysis_port_rmon;
apb_xtn xtn;
extern function new(string name="apb_rd_mon",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data;
endclass

function apb_rd_mon::new(string name="apb_rd_mon",uvm_component parent);
	super.new(name,parent);
	analysis_port_rmon=new("analysis_port_rmon",this);
endfunction

function void apb_rd_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_apb_agt_config)::get(this,"","A2A_apb_agt_config",apb_cfg))
		`uvm_fatal("apb_rd_mon","cannot get config data");
	super.build_phase(phase);
endfunction

function void apb_rd_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=apb_cfg.vif;
endfunction

task apb_rd_mon::run_phase(uvm_phase phase);
	`uvm_info("MONITOR","in run_phase of apb monitor",UVM_MEDIUM);
	forever
	begin
	collect_data;
	end
endtask

task apb_rd_mon::collect_data;
	xtn=apb_xtn::type_id::create("xtn");
  @(vif.apb_mon_cb); 
	wait(vif.apb_mon_cb.PENABLE)//wait for PENABLE which will be asserted by the BRidge and the slave will sample the address and data on its rising edge
                xtn.PADDR = vif.apb_mon_cb.PADDR;
                xtn.PWRITE = vif.apb_mon_cb.PWRITE; 
                xtn.PSELx = vif.apb_mon_cb.PSELx;
        if(xtn.PWRITE == 0)
            xtn.PRDATA = vif.apb_mon_cb.PRDATA;
				    
	     else
           begin
           xtn.PWDATA = vif.apb_mon_cb.PWDATA;    
		       end
analysis_port_rmon.write(xtn);
     	
endtask


