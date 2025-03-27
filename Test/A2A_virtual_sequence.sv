class A2A_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
`uvm_object_utils(A2A_virtual_sequence);
A2A_virtual_sequencer v_seqr;
ahb_wr_seqr w_seqr[];
apb_rd_seqr r_seqr[];
A2A_env_config cfg;
//router_wr_seq_case1 w_seq[]; 
//router_rd_seq_case1 r_seq[];

extern function new(string name="A2A_virtual_sequence");
extern task body;
endclass

function A2A_virtual_sequence::new(string name="A2A_virtual_sequence");
	super.new(name);
endfunction

task A2A_virtual_sequence::body;
	if(!uvm_config_db#(A2A_env_config)::get(null,get_full_name(),"A2A_env_config",cfg))
		`uvm_fatal("virtual_sequence","cannot get cfg");
	$cast(v_seqr,m_sequencer);
	w_seqr=new[cfg.no_of_ahb_agents];
	r_seqr=new[cfg.no_of_apb_agents];
	foreach(w_seqr[i])
		w_seqr[i]=v_seqr.w_seqr[i];
	foreach(r_seqr[i])
		r_seqr[i]=v_seqr.r_seqr[i];
endtask

//single write transfer sequence
class virtual_single_write_seq extends A2A_virtual_sequence;
`uvm_object_utils(virtual_single_write_seq);
single_write_seq w_seq[]; 

extern function new(string name="virtual_single_write_seq");
extern task body;

endclass

function virtual_single_write_seq::new(string name="virtual_single_write_seq");
	super.new(name);
endfunction

task virtual_single_write_seq::body;
	super.body;

	w_seq=new[cfg.no_of_ahb_agents];
	foreach(w_seq[i])
	begin
	w_seq[i]=single_write_seq::type_id::create($sformatf("w_seq[%0d]",i));
	w_seq[i].start(w_seqr[i]);
	end
endtask

//single read transfer sequence
class virtual_single_read_seq extends A2A_virtual_sequence;
`uvm_object_utils(virtual_single_read_seq);
single_read_seq w_seq[]; 

extern function new(string name="virtual_single_read_seq");
extern task body;

endclass

function virtual_single_read_seq::new(string name="virtual_single_read_seq");
	super.new(name);
endfunction

task virtual_single_read_seq::body;
	super.body;

	w_seq=new[cfg.no_of_ahb_agents];
	foreach(w_seq[i])
	begin
	w_seq[i]=single_read_seq::type_id::create($sformatf("w_seq[%0d]",i));
	w_seq[i].start(w_seqr[i]);
	end
endtask

//unspecified write sequence

class virtual_sequence_unspecified_write_seq extends A2A_virtual_sequence;
`uvm_object_utils(virtual_sequence_unspecified_write_seq);
unspecified_write_seq w_seq[]; 

extern function new(string name="virtual_sequence_unspecified_write_seq");
extern task body;

endclass

//unspecified virstual sequence
function virtual_sequence_unspecified_write_seq::new(string name="virtual_sequence_unspecified_write_seq");
	super.new(name);
endfunction

task virtual_sequence_unspecified_write_seq::body;
	super.body;

	w_seq=new[cfg.no_of_ahb_agents];
	foreach(w_seq[i])
	begin
	w_seq[i]=unspecified_write_seq::type_id::create($sformatf("w_seq[%0d]",i));
	w_seq[i].start(w_seqr[i]);
	end
endtask

//unspecified read sequence

class virtual_sequence_unspecified_read_seq extends A2A_virtual_sequence;
`uvm_object_utils(virtual_sequence_unspecified_read_seq);
unspecified_read_seq w_seq[]; 

extern function new(string name="virtual_sequence_unspecified_read_seq");
extern task body;

endclass

//unspecified virstual sequence
function virtual_sequence_unspecified_read_seq::new(string name="virtual_sequence_unspecified_read_seq");
	super.new(name);
endfunction

task virtual_sequence_unspecified_read_seq::body;
	super.body;

	w_seq=new[cfg.no_of_ahb_agents];
	foreach(w_seq[i])
	begin
	w_seq[i]=unspecified_read_seq::type_id::create($sformatf("w_seq[%0d]",i));
	w_seq[i].start(w_seqr[i]);
	end
endtask

//wrap virtual sequence
class A2A_virtual_sequence_WRAP_case extends A2A_virtual_sequence;
`uvm_object_utils(A2A_virtual_sequence_WRAP_case);
WRAP_sequence w_seq[]; 

extern function new(string name="A2A_virtual_sequence_WRAP_case");
extern task body;

endclass

function A2A_virtual_sequence_WRAP_case::new(string name="A2A_virtual_sequence_WRAP_case");
	super.new(name);
endfunction

task A2A_virtual_sequence_WRAP_case::body;
	super.body;

	w_seq=new[cfg.no_of_ahb_agents];
	foreach(w_seq[i])
	begin
	w_seq[i]=WRAP_sequence::type_id::create($sformatf("w_seq[%0d]",i));
	w_seq[i].start(w_seqr[i]);
	end
endtask

//incremental virtual sequence

class A2A_virtual_sequence_INCR_case extends A2A_virtual_sequence;
`uvm_object_utils(A2A_virtual_sequence_INCR_case);
INCR_sequence w_seq[]; 

extern function new(string name="A2A_virtual_sequence_INCR_case");
extern task body;

endclass

function A2A_virtual_sequence_INCR_case::new(string name="A2A_virtual_sequence_INCR_case");
	super.new(name);
endfunction

task A2A_virtual_sequence_INCR_case::body;
	super.body;

	w_seq=new[cfg.no_of_ahb_agents];
	foreach(w_seq[i])
	begin
	w_seq[i]=INCR_sequence::type_id::create($sformatf("w_seq[%0d]",i));
	w_seq[i].start(w_seqr[i]);
	end
endtask


