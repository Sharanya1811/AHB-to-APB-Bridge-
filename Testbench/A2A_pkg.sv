package A2A_pkg;

import uvm_pkg::*;
	`include "uvm_macros.svh"
//`include "tb_defs.sv"
`include "ahb_xtn.sv"
`include "A2A_ahb_agt_config.sv"
`include "A2A_apb_agt_config.sv"
`include "A2A_env_config.sv"
`include "ahb_wr_driver.sv"
`include "ahb_wr_mon.sv"
`include "ahb_wr_seqr.sv"
`include "A2A_ahb_agt.sv"
`include "A2A_ahb_agt_top.sv"
`include "ahb_sequence.sv"

`include "read_xtn.sv"
`include "apb_rd_mon.sv"
`include "apb_rd_seqr.sv"
//`include "ahb_rd_seq.sv"
`include "apb_rd_driver.sv"
`include "A2A_apb_agt.sv"
`include "A2A_apb_agt_top.sv"

`include "A2A_virtual_sequencer.sv"
`include "A2A_virtual_sequence.sv"
`include "A2A_scoreboard.sv"

`include "A2A_env.sv"


`include "A2A_test.sv"
endpackage

