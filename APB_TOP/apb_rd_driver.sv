class apb_rd_driver extends uvm_driver #(apb_xtn);
`uvm_component_utils(apb_rd_driver);

//apb_xtn xtn;
virtual APB_if.APB_DRV_MP vif;
A2A_apb_agt_config apb_cfg;

extern function new(string name="apb_rd_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task drive(apb_xtn xtn);
endclass

function apb_rd_driver::new(string name="apb_rd_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_rd_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_apb_agt_config)::get(this,"","A2A_apb_agt_config",apb_cfg))
		`uvm_fatal("R_DR","cannot get config data");
	super.build_phase(phase);
endfunction

function void apb_rd_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=apb_cfg.vif;
endfunction

task apb_rd_driver::run_phase(uvm_phase phase);
req=apb_xtn::type_id::create("req");
	forever
		begin
			drive(req);
		end


`uvm_info("DRIVER","in run_phase of ahb driver",UVM_MEDIUM);

endtask

task apb_rd_driver::drive(apb_xtn xtn);
      @(vif.apb_drv_cb);//to make sure only after a positive edge PSELx is checked 
        wait(vif.apb_drv_cb.PSELx != 0);//wait for the PSELx to be high 
        if(vif.apb_drv_cb.PWRITE == 0) //if read operation write data from slave to interface 
	        begin           
	           vif.apb_drv_cb.PRDATA <=$urandom;
	        end
       repeat(1) @(vif.apb_drv_cb);      
endtask


