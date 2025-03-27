class apb_rd_seqr extends uvm_sequencer #(apb_xtn);
`uvm_component_utils(apb_rd_seqr);
extern function new(string name="apb_rd_seqr",uvm_component parent);
endclass

function apb_rd_seqr::new(string name="apb_rd_seqr",uvm_component parent);
	super.new(name,parent);
endfunction
