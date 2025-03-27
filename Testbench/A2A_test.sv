class A2A_test extends uvm_test;
`uvm_component_utils(A2A_test)
A2A_env_config cfg;
A2A_ahb_agt_config ahb_cfg[];
A2A_apb_agt_config apb_cfg[];
int no_of_ahb_agents=1;
int no_of_apb_agents=1;
int has_scoreboard=1;
int has_virtual_sequencer=1;
A2A_env env;

extern function new(string name="A2A_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function A2A_test:: new(string name="A2A_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void A2A_test:: build_phase(uvm_phase phase);
	apb_cfg=new[no_of_apb_agents];
	ahb_cfg=new[no_of_ahb_agents];
	cfg=A2A_env_config::type_id::create("A2A_env_config");
	cfg.apb_cfg=new[no_of_apb_agents];
	cfg.ahb_cfg=new[no_of_ahb_agents];
	foreach(ahb_cfg[i])
	begin
		ahb_cfg[i]=A2A_ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
		if(!uvm_config_db #(virtual AHB_if)::get(this,"","svif",ahb_cfg[i].vif))
			`uvm_fatal("A2A_test","cannot get interface for  config data");
		ahb_cfg[i].is_active=UVM_ACTIVE;
		cfg.ahb_cfg[i]=ahb_cfg[i];
	end
	foreach(apb_cfg[i])
	begin
		apb_cfg[i]=A2A_apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]",i));
		if(!uvm_config_db #(virtual APB_if)::get(this,"",$sformatf("dvif[%0d]",i),apb_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");
		apb_cfg[i].is_active=UVM_ACTIVE;
		cfg.apb_cfg[i]=apb_cfg[i];
	end
	cfg.no_of_ahb_agents=no_of_ahb_agents;
	cfg.no_of_apb_agents=no_of_apb_agents;
	cfg.has_scoreboard=has_scoreboard;
	cfg.has_virtual_sequencer=has_virtual_sequencer;
	uvm_config_db#(A2A_env_config) ::set(this,"*","A2A_env_config",cfg);
	super.build_phase(phase);
	env=A2A_env::type_id::create("env",this);
endfunction

function void A2A_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

class single_write_test extends A2A_test;//single write transfer

        `uvm_component_utils(single_write_test)

         virtual_single_write_seq t_seqh;

        extern function new(string name = "single_write_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function single_write_test::new(string name = "single_write_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void single_write_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task single_write_test::run_phase(uvm_phase phase);
	$display("in A2A_test");
	phase.raise_objection(this);
        t_seqh = virtual_single_write_seq::type_id::create("t_seqh");
        t_seqh.start(env.v_seqr);

        phase.drop_objection(this);
	endtask
 
 class single_read_test extends A2A_test;//single read transfer

        `uvm_component_utils(single_read_test)

         virtual_single_read_seq t_seqh;

        extern function new(string name = "single_read_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function single_read_test::new(string name = "single_read_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void single_read_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task single_read_test::run_phase(uvm_phase phase);
	$display("in A2A_test");
	phase.raise_objection(this);
        t_seqh = virtual_single_read_seq::type_id::create("t_seqh");
        t_seqh.start(env.v_seqr);

        phase.drop_objection(this);
	endtask
 
 class unspecified_write_test extends A2A_test;//unspecified write test case

        `uvm_component_utils(unspecified_write_test)

         virtual_sequence_unspecified_write_seq t_seqh;

        extern function new(string name = "unspecified_write_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function unspecified_write_test::new(string name = "unspecified_write_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void unspecified_write_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task unspecified_write_test::run_phase(uvm_phase phase);
	$display("in A2A_test");
        phase.raise_objection(this);
	        t_seqh = virtual_sequence_unspecified_write_seq::type_id::create("t_seqh");
        t_seqh.start(env.v_seqr);

        phase.drop_objection(this);
endtask


class unspecified_read_test extends A2A_test;//unspecified read test case

        `uvm_component_utils(unspecified_read_test)

         virtual_sequence_unspecified_read_seq t_seqh;

        extern function new(string name = "unspecified_read_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function unspecified_read_test::new(string name = "unspecified_read_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void unspecified_read_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task unspecified_read_test::run_phase(uvm_phase phase);
	$display("in A2A_test");
        phase.raise_objection(this);
	        t_seqh = virtual_sequence_unspecified_read_seq::type_id::create("t_seqh");
        t_seqh.start(env.v_seqr);

        phase.drop_objection(this);
endtask

//////////////////////////////////////////////////////////////////////////////////////////////////////////

class wrap_test extends A2A_test;//wrap test case

        `uvm_component_utils(wrap_test)

         A2A_virtual_sequence_WRAP_case t_seqh;

        extern function new(string name = "wrap_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function wrap_test::new(string name = "wrap_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void wrap_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task wrap_test::run_phase(uvm_phase phase);
	$display("in A2A_test");
        phase.raise_objection(this);
	        t_seqh = A2A_virtual_sequence_WRAP_case::type_id::create("t_seqh");
          t_seqh.start(env.v_seqr);
        phase.drop_objection(this);
endtask

class wrap_test1 extends wrap_test;//wrap 4

        `uvm_component_utils(wrap_test1)

         A2A_virtual_sequence_WRAP_case t_seqh;

        function new(string name = "wrap_test1", uvm_component parent);
          super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
         set_type_override_by_type(WRAP_sequence::get_type(),WRAP_seq1::get_type());
        endfunction
        
        task run_phase(uvm_phase phase);
          super.run_phase(phase);
        endtask
endclass

class wrap_test2 extends wrap_test;//wrap 8

        `uvm_component_utils(wrap_test2)

         A2A_virtual_sequence_WRAP_case t_seqh;

        function new(string name = "wrap_test2", uvm_component parent);
          super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
         set_type_override_by_type(WRAP_sequence::get_type(),WRAP_seq2::get_type());
        endfunction
        
        task run_phase(uvm_phase phase);
          super.run_phase(phase);
        endtask
endclass

class wrap_test3 extends wrap_test;//wrap 16

        `uvm_component_utils(wrap_test3)

         A2A_virtual_sequence_WRAP_case t_seqh;

        function new(string name = "wrap_test3", uvm_component parent);
          super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
         set_type_override_by_type(WRAP_sequence::get_type(),WRAP_seq3::get_type());
        endfunction
        
        task run_phase(uvm_phase phase);
          super.run_phase(phase);
        endtask
endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////

class incr_test extends A2A_test;//incremental test case

        `uvm_component_utils(incr_test)

         A2A_virtual_sequence_INCR_case t_seqh;

        extern function new(string name = "incr_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function incr_test::new(string name = "incr_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void incr_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task incr_test::run_phase(uvm_phase phase);
	$display("in A2A_test incr");
        phase.raise_objection(this);
	        t_seqh = A2A_virtual_sequence_INCR_case::type_id::create("t_seqh");
        t_seqh.start(env.v_seqr);
        phase.drop_objection(this);
endtask

class incr_test1 extends incr_test;//incremental 4 test case 

        `uvm_component_utils(incr_test1)

         A2A_virtual_sequence_INCR_case t_seqh;

        extern function new(string name = "incr_test1", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function incr_test1::new(string name = "incr_test1", uvm_component parent);
        super.new(name, parent);
endfunction

function void incr_test1::build_phase(uvm_phase phase);
        super.build_phase(phase);
       set_type_override_by_type(INCR_sequence::get_type(),INCR_seq1::get_type());
endfunction

task incr_test1::run_phase(uvm_phase phase);
        super.run_phase(phase);
endtask

class incr_test2 extends incr_test;//incremental 8 test case 

        `uvm_component_utils(incr_test2)

         A2A_virtual_sequence_INCR_case t_seqh;

        extern function new(string name = "incr_test2", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function incr_test2::new(string name = "incr_test2", uvm_component parent);
        super.new(name, parent);
endfunction

function void incr_test2::build_phase(uvm_phase phase);
        super.build_phase(phase);
       set_type_override_by_type(INCR_sequence::get_type(),INCR_seq2::get_type());
endfunction

task incr_test2::run_phase(uvm_phase phase);
        super.run_phase(phase);
endtask

class incr_test3 extends incr_test;//incremental 16 test case 

        `uvm_component_utils(incr_test3)

         A2A_virtual_sequence_INCR_case t_seqh;

        extern function new(string name = "incr_test3", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function incr_test3::new(string name = "incr_test3", uvm_component parent);
        super.new(name, parent);
endfunction

function void incr_test3::build_phase(uvm_phase phase);
        super.build_phase(phase);
       set_type_override_by_type(INCR_sequence::get_type(),INCR_seq3::get_type());
endfunction

task incr_test3::run_phase(uvm_phase phase);
        super.run_phase(phase);
endtask
