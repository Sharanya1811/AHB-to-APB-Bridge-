class A2A_scoreboard extends uvm_scoreboard;
`uvm_component_utils(A2A_scoreboard);
uvm_tlm_analysis_fifo#(ahb_xtn) analysis_fifo_wmon[];
uvm_tlm_analysis_fifo#(apb_xtn) analysis_fifo_rmon[];
A2A_env_config cfg;
ahb_xtn xtn,ahb_cov_data;
apb_xtn rxtn,apb_cov_data;
ahb_xtn q[$];
event ev,ev1;
int count;
extern function new(string name="A2A_scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void check_packet(apb_xtn rd);
extern function void compare_data(int Hdata, Pdata, Haddr, Paddr);

covergroup ahb_cg;
                option.per_instance = 1;

                SIZE : coverpoint ahb_cov_data.HSIZE {bins ad[] = {[0:2]};}
				        TRANS: coverpoint ahb_cov_data.HTRANS {bins trans[] = {[2:3]};}
                BURST: coverpoint ahb_cov_data.HBURST {bins burst = {[0:7]};}
                ADDR : coverpoint ahb_cov_data.HADDR {bins first_slave = {[32'h8000_0000:32'h8000_03ff]};
                                                      bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                                      bins third_slave = {[32'h8800_0000:32'h8800_03ff]};
                                                      bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}
                WRITE : coverpoint ahb_cov_data.HWRITE;
endgroup: ahb_cg

covergroup apb_cg;
                option.per_instance = 1;

                ADDR : coverpoint apb_cov_data.PADDR {bins first_slave = {[32'h8000_0000:32'h8000_03ff]};
                                                      bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                                      bins third_slave = {[32'h8800_0000:32'h8800_03ff]};
                                                      bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}

                WRITE : coverpoint apb_cov_data.PWRITE;

                PSEL : coverpoint apb_cov_data.PSELx {bins first_slave = {4'b0001};
                                                      bins second_slave = {4'b0010};
                                                      bins third_slave = {4'b0100};
                                                      bins fourth_slave = {4'b1000};}
endgroup: apb_cg

endclass

function A2A_scoreboard::new(string name="A2A_scoreboard",uvm_component parent);
	super.new(name,parent);
  ahb_cov_data = new;
  apb_cov_data = new;
  ahb_cg = new();
  apb_cg = new();
endfunction

function void A2A_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(A2A_env_config)::get(this,"","A2A_env_config",cfg))
		`uvm_fatal("SB","cannot get config data");
	analysis_fifo_rmon=new[cfg.no_of_ahb_agents];
	analysis_fifo_wmon=new[cfg.no_of_apb_agents];
	foreach(analysis_fifo_rmon[i])
		analysis_fifo_rmon[i]=new($sformatf("analysis_fifo_rmon[%0d]",i),this);
	foreach(analysis_fifo_wmon[i])
		analysis_fifo_wmon[i]=new($sformatf("analysis_fifo_wmon[%0d]",i),this);

	super.build_phase(phase);
endfunction


task A2A_scoreboard::run_phase(uvm_phase phase);
	  `uvm_info("A2A_scoreboard","In run phase",UVM_MEDIUM);
                forever
                        begin
                                analysis_fifo_wmon[0].get(xtn);  
                               // xtn.print();
                                ahb_cov_data=xtn;
                                q.push_back(xtn);
                                analysis_fifo_rmon[0].get(rxtn);
                                apb_cov_data=rxtn;
                                //rxtn.print();
                                 $display("ahb address =%0h and ahb hwdata =%0h  ahb hrdata =%0h",xtn.HADDR,xtn.HWDATA,xtn.HRDATA);
                                $display("apb address =%0h and apb pwdata =%0h  apb prdata =%0h",rxtn.PADDR,rxtn.PWDATA,rxtn.PRDATA);
                                check_packet(rxtn);
                                 ahb_cg.sample();
                                 apb_cg.sample();
                                 $display("ahb_cov=%0d   apb_cov=%0d",ahb_cg.get_coverage(),apb_cg.get_coverage());
                               
                        end
endtask

function void A2A_scoreboard::check_packet(apb_xtn rd);
	xtn = q.pop_front();

        if(xtn.HWRITE)
        begin
                case(xtn.HSIZE)

                2'b00:
                begin
                        if(xtn.HADDR[1:0] == 2'b00)
                                compare_data(xtn.HWDATA[7:0], rd.PWDATA[7:0], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b01)
                                compare_data(xtn.HWDATA[15:8], rd.PWDATA[7:0], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b10)
                                compare_data(xtn.HWDATA[23:16], rd.PWDATA[7:0], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b11)
                                compare_data(xtn.HWDATA[31:24], rd.PWDATA[7:0], xtn.HADDR, rd.PADDR);

                end
              2'b01:
                begin
                        if(xtn.HADDR[1:0] == 2'b00)
                                compare_data(xtn.HWDATA[15:0], rd.PWDATA[15:0], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b10)
                                compare_data(xtn.HWDATA[31:16], rd.PWDATA[15:0], xtn.HADDR, rd.PADDR);
                end

              2'b10:
                        compare_data(xtn.HWDATA, rd.PWDATA, xtn.HADDR, rd.PADDR);

                endcase
        end

        else
        begin
                case(xtn.HSIZE)

                2'b00:
                begin
                        if(xtn.HADDR[1:0] == 2'b00)
                                compare_data(xtn.HRDATA[7:0], rd.PRDATA[7:0], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b01)
                                compare_data(xtn.HRDATA[7:0], rd.PRDATA[15:8], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b10)
                                compare_data(xtn.HRDATA[7:0], rd.PRDATA[23:16], xtn.HADDR, rd.PADDR);
                        if(xtn.HADDR[1:0] == 2'b11)
                                compare_data(xtn.HRDATA[7:0], rd.PRDATA[31:24], xtn.HADDR, rd.PADDR);

                end

                2'b01:
                begin
						if(xtn.HADDR[1:0] == 2'b00)
                                compare_data(xtn.HRDATA[15:0], rd.PRDATA[15:0], xtn.HADDR, rd.PADDR);
						if(xtn.HADDR[1:0] == 2'b10)
                                compare_data(xtn.HRDATA[15:0], rd.PRDATA[31:16], xtn.HADDR, rd.PADDR);
                end

                2'b10:
                        compare_data(xtn.HRDATA, rd.PRDATA, xtn.HADDR, rd.PADDR);

                endcase
        end
endfunction

function void A2A_scoreboard::compare_data(int Hdata, Pdata, Haddr, Paddr);
        $display("%0h %0h %0h %0h",Haddr,Hdata,Paddr,Pdata);
        if(Haddr == Paddr)
                $display("\033[32mAddress MATCHED\033[0m ");
        else
        begin
                $display("\033[31mAddress not MATCHED\033[0m");
        end

        if(Hdata == Pdata)
                $display("\033[34mDATA MATCHED\033[0m");
        else
        begin
                $display("\033[31mDATA not MATCHED\033[0m");
        end

       
endfunction

