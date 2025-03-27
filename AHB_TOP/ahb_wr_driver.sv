class ahb_wr_driver extends uvm_driver #(ahb_xtn);
`uvm_component_utils(ahb_wr_driver);

virtual AHB_if.AHB_DRV_MP vif;
A2A_ahb_agt_config ahb_cfg;

extern function new(string name="ahb_wr_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task drive(ahb_xtn xtn);
endclass

function ahb_wr_driver::new(string name="ahb_wr_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void ahb_wr_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_ahb_agt_config)::get(this,"","A2A_ahb_agt_config",ahb_cfg))
		`uvm_fatal("DR","cannot get config data");
	super.build_phase(phase);
endfunction

function void ahb_wr_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=ahb_cfg.vif;
endfunction

task ahb_wr_driver::run_phase(uvm_phase phase);
	`uvm_info("DRIVER","in run_phase of ahb driver",UVM_MEDIUM);
	      @(vif.ahb_dr_cb);
        vif.ahb_dr_cb.HRESETn <= 1'b0;
        repeat(1)
        @(vif.ahb_dr_cb);
        vif.ahb_dr_cb.HRESETn <= 1'b1;
	forever
                begin
                        seq_item_port.get_next_item(req);
                                if(req.reset)
                                begin
                                    @(vif.ahb_dr_cb);
                                    vif.ahb_dr_cb.HRESETn <= 1'b0;
                                    repeat(1)
                                    @(vif.ahb_dr_cb);
                                    vif.ahb_dr_cb.HRESETn <= 1'b1;
                                    drive(req);
                                end
                                else
                                   drive(req);
                        seq_item_port.item_done(req);
                end
	
endtask

task ahb_wr_driver::drive(ahb_xtn xtn);

//	`uvm_info("DRIVER","in run_phase task of ahb driver",UVM_MEDIUM);
	      vif.ahb_dr_cb.HWRITE  <= xtn.HWRITE;
        vif.ahb_dr_cb.HTRANS <= xtn.HTRANS;
        vif.ahb_dr_cb.HSIZE   <= xtn.HSIZE;
        vif.ahb_dr_cb.HADDR   <= xtn.HADDR;
        vif.ahb_dr_cb.HBURST   <= xtn.HBURST;
        vif.ahb_dr_cb.Hreadyin <= 1'b1;
        @(vif.ahb_dr_cb);    
        wait(vif.ahb_dr_cb.Hreadyout)//to ensure that address phase and data phase are extended for next cycle if Bridge is not ready
 if(xtn.HWRITE)
     vif.ahb_dr_cb.HWDATA<=xtn.HWDATA;
 else
   vif.ahb_dr_cb.HWDATA <= 32'h0;
       
 
endtask
