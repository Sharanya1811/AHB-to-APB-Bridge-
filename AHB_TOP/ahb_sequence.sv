class ahb_sequence extends uvm_sequence #(ahb_xtn);

        `uvm_object_utils(ahb_sequence)
	       logic [31:0] haddr;
         logic [2:0] hsize;
         logic hwrite;
         logic [2:0] hburst;
	       logic [3:0] wrap_size,incr_size;
         logic [7:0] len;
        extern function new(string name = "ahb_sequence");
endclass

function ahb_sequence::new(string name = "ahb_sequence");
        super.new(name);
endfunction

///-------single_transfer_write-------/////
class single_write_seq extends ahb_sequence;

        `uvm_object_utils(single_write_seq)
	        extern function new(string name = "single_write_seq");
        extern task body();
endclass

function single_write_seq::new(string name = "single_write_seq");
        super.new(name);
endfunction

task single_write_seq::body();
	
        req = ahb_xtn::type_id::create("req");
  repeat(1)
 begin
   req.reset=0;      
	      repeat(4)
	          begin
	             start_item(req);
	              	assert(req.randomize() with {HTRANS==2'b10;HBURST==3'b000;HWRITE==1;}); 
             	 finish_item(req);
            	haddr = req.HADDR;

	           repeat(8)
            	#5;
              // req.reset=1;
             end
    repeat(4)
           	#5;
end
	    		
	endtask
 
 ///---------single transfer read---------///
 
 class single_read_seq extends ahb_sequence;

        `uvm_object_utils(single_read_seq)
	        extern function new(string name = "single_read_seq");
        extern task body();
endclass

function single_read_seq::new(string name = "single_read_seq");
        super.new(name);
endfunction

task single_read_seq::body();
	
        req = ahb_xtn::type_id::create("req");
 repeat(1)
 begin
     req.reset=1'b0;
	      repeat(4)
	          begin
                   start_item(req);
	              	assert(req.randomize() with {HTRANS==2'b10;HBURST==3'b000;HWRITE==0;}); 
             	    finish_item(req);
             	    haddr = req.HADDR;
                  repeat(4)
	                #5;
                  req.reset=1;               
	           end
        repeat(4)
        #5;
 end
	    		
	endtask
 
 ///-----------unspecified write sequence--------------///

class unspecified_write_seq extends ahb_sequence;

        `uvm_object_utils(unspecified_write_seq)
	        extern function new(string name = "unspecified_write_seq");
        extern task body();
endclass

function unspecified_write_seq::new(string name = "unspecified_write_seq");
        super.new(name);
endfunction

task unspecified_write_seq::body();

        req = ahb_xtn::type_id::create("req");
repeat(1)
begin
	start_item(req);
		assert(req.randomize() with {HTRANS==2'b10;HBURST==3'b001;length inside {[4:8]};HWRITE==1;}); 
    $display("hsize=%0d  length=%0d",req.HSIZE,req.length);
	finish_item(req);
	hwrite = req.HWRITE;
	haddr = req.HADDR;
        hsize = req.HSIZE;
        hburst = req.HBURST;
	len = req.length;
	if(hburst == 3'b001)//unspecified length
        begin
                for(int i=1; i<len; i++)
                begin
			haddr[9:0]=haddr[9:0]+(2**hsize);
                        haddr = {haddr[31:10],haddr[9:0]};

                        start_item(req);
                         assert(req.randomize() with {HSIZE == hsize; HBURST == hburst;HWRITE == hwrite; HTRANS == 2'b11;HADDR == haddr;length==len;});
                        finish_item(req);
                        haddr = req.HADDR;
                end
        end
repeat(10)
#5;
end
		
endtask

///-----------unspecified read sequence--------------///

class unspecified_read_seq extends ahb_sequence;

        `uvm_object_utils(unspecified_read_seq)
	        extern function new(string name = "unspecified_read_seq");
        extern task body();
endclass

function unspecified_read_seq::new(string name = "unspecified_read_seq");
        super.new(name);
endfunction

task unspecified_read_seq::body();

        req = ahb_xtn::type_id::create("req");
repeat(1)
begin
	start_item(req);
		assert(req.randomize() with {HTRANS==2'b10;HBURST==3'b001;length inside {[4:8]}; HWRITE ==0;});  
    $display("hsize=%0d  length=%0d",req.HSIZE,req.length);  
	finish_item(req);
	hwrite = req.HWRITE;
	haddr = req.HADDR;
        hsize = req.HSIZE;
        hburst = req.HBURST;
	len = req.length;
	if(hburst == 3'b001)//unspecified length
        begin
                for(int i=1; i<len; i++)
                begin
			haddr[9:0]=haddr[9:0]+(2**hsize);
                        haddr = {haddr[31:10],haddr[9:0]};

                        start_item(req);
                         assert(req.randomize() with {HSIZE == hsize; HBURST == hburst;HWRITE == hwrite; HTRANS == 2'b11;HADDR == haddr;length==len;});
                        finish_item(req);

                        haddr = req.HADDR;
                end
        end
        repeat(8)
        #5;
end
endtask


class WRAP_sequence extends ahb_sequence;
	`uvm_object_utils(WRAP_sequence)
	extern function new(string name = "WRAP_sequence");
  extern virtual task body();	
endclass

function WRAP_sequence::new(string name = "WRAP_sequence");
        super.new(name);
endfunction

task WRAP_sequence::body();
	req = ahb_xtn::type_id::create("req");
	repeat(1)
	begin
	 start_item(req);
		assert(req.randomize() with {HTRANS==2'b10;HBURST==hburst;HWRITE==hwrite;HSIZE==hsize;}); //      
	finish_item(req);
	hwrite = req.HWRITE;
	haddr = req.HADDR;
        hsize = req.HSIZE;
        hburst = req.HBURST;

	if(hburst == 3'b010)//WRAP 4
        begin
                for(int i=0; i<3; i++)
                begin
			start_item(req);
		        if(hsize == 0)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst; HWRITE== hwrite; HTRANS== 2'b11;HADDR == {haddr[31:2], haddr[1:0] + 1'b1};});
            if(hsize == 1)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst;HWRITE== hwrite; HTRANS== 2'b11; HADDR == {haddr[31:3], haddr[2:0] + 2'b10};});
			      if(hsize == 2)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst;HWRITE== hwrite; HTRANS== 2'b11;HADDR == {haddr[31:4], haddr[3:0] + 3'b100};});
                                                                
                        finish_item(req);

                        haddr = req.HADDR;
		end
        end

	if(hburst == 3'b100)//WRAP 8
        begin
                for(int i=0; i<7; i++)
                begin
			start_item(req);
		        if(hsize == 0)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst; HWRITE== hwrite; HTRANS== 2'b11;HADDR == {haddr[31:3], haddr[2:0] + 1'b1};});
                                                                                                                                                                              
            if(hsize == 1)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst;HWRITE== hwrite; HTRANS== 2'b11; HADDR == {haddr[31:4], haddr[3:0] + 2'b10};});
            if(hsize == 2)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst;HWRITE== hwrite; HTRANS== 2'b11;HADDR == {haddr[31:5], haddr[4:0] + 3'b100};});
                                                                
                        finish_item(req);


               		 haddr = req.HADDR;
       		 end
        end

	if(hburst == 3'b110)//WRAP 16
        begin
                for(int i=0; i<15; i++)
                begin
			start_item(req);
		        if(hsize == 0)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst; HWRITE== hwrite; HTRANS== 2'b11;HADDR == {haddr[31:4], haddr[3:0] + 1'b1};});
                                                                                                                                                                              
                        if(hsize == 1)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst;HWRITE== hwrite; HTRANS== 2'b11; HADDR == {haddr[31:5], haddr[4:0] + 2'b10};});
                                                                                                                                                                              		 			if(hsize == 2)
                                assert(req.randomize() with {HSIZE== hsize; HBURST == hburst;HWRITE== hwrite; HTRANS== 2'b11;HADDR == {haddr[31:6], haddr[5:0] + 3'b100};});
                                                                
                        finish_item(req);


                       
                        haddr = req.HADDR;
        end
        end

	repeat(10)
  #5;
	end
		
endtask

class WRAP_seq1 extends WRAP_sequence;
	`uvm_object_utils(WRAP_seq1)
	 function new(string name = "WRAP_seq1");
     super.new(name);
   endfunction
   
   virtual task body();	
       this.hsize=1;
       this.hburst=2;
       this.hwrite=0;
       super.body();
   endtask
endclass

class WRAP_seq2 extends WRAP_sequence;
	`uvm_object_utils(WRAP_seq2)
	 function new(string name = "WRAP_seq2");
     super.new(name);
   endfunction
   
   virtual task body();	
       this.hsize=1;
       this.hburst=4;
       this.hwrite=0;
       super.body();
   endtask
endclass

class WRAP_seq3 extends WRAP_sequence;
	`uvm_object_utils(WRAP_seq3)
	 function new(string name = "WRAP_seq3");
     super.new(name);
   endfunction
   
   virtual task body();	
       this.hsize=1;
       this.hburst=6;
       this.hwrite=0;
       super.body();
   endtask
endclass

//=========================================================================================================================//

class INCR_sequence extends ahb_sequence;

        `uvm_object_utils(INCR_sequence)
	 extern function new(string name = "INCR_sequence");
        extern virtual task body();
endclass

function INCR_sequence::new(string name = "INCR_sequence");
        super.new(name);
endfunction



task INCR_sequence::body();
	repeat(1)
	begin
  req = ahb_xtn::type_id::create("req");
      start_item(req);
	      	assert(req.randomize() with {HTRANS==2'b10;HBURST ==hburst;HWRITE==hwrite;HSIZE==hsize;}); //011
	    finish_item(req);
	    hwrite = req.HWRITE;
	    haddr = req.HADDR;
      hsize = req.HSIZE;
      hburst = req.HBURST;
	if(hburst == 3'b011||hburst == 3'b101||hburst == 3'b111)//INCR 4||INCR 8||INCR 16
        begin
		incr_size=(hburst+(hburst-2))+((^(hburst))*3);
                for(int i=1; i<incr_size; i++)
                begin
                       

                        start_item(req);
                       	haddr[9:0]=haddr[9:0]+(2**hsize);
                        haddr = {haddr[31:10],haddr[9:0]};
                         assert(req.randomize() with {HSIZE == hsize; HBURST == hburst;HWRITE == hwrite; HTRANS == 2'b11;HADDR == haddr;});
                        finish_item(req);

                        haddr = req.HADDR;
                end
        end
	end
 
 repeat(8)
 #5;
endtask

class INCR_seq1 extends INCR_sequence;//INCR 4
  `uvm_object_utils(INCR_seq1)
  extern function new(string name = "INCR_seq1");
  virtual task body();
      this.hsize=1;
      this.hburst=3'b011;
      this.hwrite=0;
      super.body();
  endtask
endclass

function INCR_seq1::new(string name = "INCR_seq1");
        super.new(name);
endfunction

class INCR_seq2 extends INCR_sequence;//INCR 8
  `uvm_object_utils(INCR_seq2)
  extern function new(string name = "INCR_seq2");
  virtual task body();
      this.hsize=1;
      this.hburst=3'b101;
      this.hwrite=0;
      super.body();
  endtask
endclass

function INCR_seq2::new(string name = "INCR_seq2");
        super.new(name);
endfunction


class INCR_seq3 extends INCR_sequence;//INCR 16
  `uvm_object_utils(INCR_seq3)
  extern function new(string name = "INCR_seq3");
  virtual task body();
      this.hsize=1;
      this.hburst=3'b111;
      this.hwrite=0;
      super.body();
  endtask
endclass

function INCR_seq3::new(string name = "INCR_seq3");
        super.new(name);
endfunction

