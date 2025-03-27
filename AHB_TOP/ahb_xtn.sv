class ahb_xtn extends uvm_sequence_item;
`uvm_object_utils(ahb_xtn);
logic Hclk, Hresetn;
        randc logic HWRITE; 
        randc logic [2:0] HSIZE;
        rand logic [1:0] HTRANS;
        rand logic [31:0] HADDR;
        randc logic [2:0] HBURST;
        rand logic [31:0] HWDATA;
        logic [31:0] HRDATA; 
        logic reset;                
	rand logic [7:0] length;
	
                constraint valid_size {HSIZE inside {[0:2]};}
                constraint valid_length {((2**HSIZE) * length) <= 1024;}
                constraint valid_haddr {HSIZE== 1 -> HADDR % 2 == 0; HSIZE== 2 -> HADDR % 4 == 0;}
                constraint valid_haddr1 {HADDR inside {[32'h8000_0000 : 32'h8000_03ff],
                                               [32'h8400_0000 : 32'h8400_03ff],
                                               [32'h8800_0000 : 32'h8800_03ff],
                                               [32'h8c00_0000 : 32'h8c00_03ff]};}

extern function void do_print(uvm_printer printer);
extern function new(string name = "ahb_xtn");
endclass:ahb_xtn



	function ahb_xtn::new(string name = "ahb_xtn");
		super.new(name);
	endfunction:new

 function void ahb_xtn::do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("HADDR", this.HADDR, 32, UVM_HEX);
        printer.print_field("HWDATA", this.HWDATA, 32, UVM_HEX);
	printer.print_field("HRDATA", this.HRDATA, 32, UVM_HEX);
        printer.print_field("HWRITE", this.HWRITE, 1, UVM_DEC);
        printer.print_field("HTRANS", this.HTRANS, 2, UVM_DEC);
        printer.print_field("HBURST", this.HBURST, 3, UVM_DEC);
 	printer.print_field("HSIZE", this.HSIZE, 3, UVM_DEC);
	printer.print_field("length", this.length, 8, UVM_DEC);

endfunction

  
