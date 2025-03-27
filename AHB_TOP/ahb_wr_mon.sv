class ahb_wr_mon extends uvm_monitor;
`uvm_component_utils(ahb_wr_mon);
virtual AHB_if.AHB_MON_MP vif;
A2A_ahb_agt_config ahb_cfg;
uvm_analysis_port #(ahb_xtn) analysis_port_wmon;
ahb_xtn xtn;
extern function new(string name="ahb_wr_mon",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data;
endclass

function ahb_wr_mon::new(string name="ahb_wr_mon",uvm_component parent);
	super.new(name,parent);
	analysis_port_wmon=new("analysis_port_wmon",this);
endfunction

function void ahb_wr_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_ahb_agt_config)::get(this,"","A2A_ahb_agt_config",ahb_cfg))
		`uvm_fatal("MON","cannot get config data");
	super.build_phase(phase);
endfunction

function void ahb_wr_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=ahb_cfg.vif;
endfunction

task ahb_wr_mon::run_phase(uvm_phase phase);
	`uvm_info("MONITOR","in run_phase of WR monitor",UVM_MEDIUM);
	forever 
		begin
			collect_data;
		end
endtask

task ahb_wr_mon::collect_data;
	 xtn=ahb_xtn::type_id::create("xtn");
   	 wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.HTRANS == 2'b10 || vif.ahb_mon_cb.HTRANS == 2'b11))
         xtn.HTRANS = vif.ahb_mon_cb.HTRANS;
         xtn.HWRITE = vif.ahb_mon_cb.HWRITE;
         xtn.HSIZE  = vif.ahb_mon_cb.HSIZE;
         xtn.HADDR  = vif.ahb_mon_cb.HADDR;
         xtn.HBURST = vif.ahb_mon_cb.HBURST;


   @(vif.ahb_mon_cb);

        wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.HTRANS == 2'b10 || vif.ahb_mon_cb.HTRANS == 2'b11))
		if(xtn.HWRITE)
                xtn.HWDATA = vif.ahb_mon_cb.HWDATA;
		else
		xtn.HRDATA = vif.ahb_mon_cb.HRDATA;
      
	    analysis_port_wmon.write(xtn);
   /*      if(xtn.HWRITE==0)
         repeat(2) @(vif.ahb_mon_cb);*/
         
	endtask


