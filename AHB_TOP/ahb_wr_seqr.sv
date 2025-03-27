class ahb_wr_seqr extends uvm_sequencer #(ahb_xtn);
`uvm_component_utils(ahb_wr_seqr);
extern function new(string name="ahb_wr_seqr",uvm_component parent);
endclass

function ahb_wr_seqr::new(string name="ahb_wr_seqr",uvm_component parent);
	super.new(name,parent);
endfunction
