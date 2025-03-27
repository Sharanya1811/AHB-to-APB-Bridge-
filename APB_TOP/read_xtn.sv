class apb_xtn extends uvm_sequence_item;

        `uvm_object_utils(apb_xtn)

        logic PENABLE, PWRITE; 
        logic [31:0] PWDATA;
	logic [31:0] PADDR;
        logic PSELx;
        rand logic [31:0] PRDATA;

               
        extern function void do_print(uvm_printer printer);
endclass

function void apb_xtn::do_print(uvm_printer printer);

        super.do_print(printer);
        printer.print_field("PADDR", this.PADDR, 32, UVM_HEX);
        printer.print_field("PENABLE", this.PENABLE, 1, UVM_DEC);
        printer.print_field("PWRITE", this.PWRITE, 1, UVM_DEC);
        printer.print_field("PSELx", this.PSELx, 1, UVM_DEC);
        printer.print_field("PRDATA", this.PRDATA, 32, UVM_HEX);
        printer.print_field("PWDATA", this.PWDATA, 32, UVM_HEX);
endfunction

