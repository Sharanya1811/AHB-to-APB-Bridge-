module top;

bit clk;
always #5 clk=~clk;
import A2A_pkg::*;
import uvm_pkg::*;

AHB_if ahb(clk);
APB_if apb(clk);
//router_chip DUV (sin,din0,din1,din2);
rtl_top	 DUT (.Hclk(ahb.HCLK),.Hresetn(ahb.HRESETn),.Htrans(ahb.HTRANS),.Hsize(ahb.HSIZE),.Hreadyin(ahb.Hreadyin),.Hwdata(ahb.HWDATA),.Haddr(ahb.HADDR),.Hwrite(ahb.HWRITE),
.Prdata(apb.PRDATA),.Hrdata(ahb.HRDATA),.Hresp(ahb.HRESP),.Hreadyout(ahb.Hreadyout),.Pselx(apb.PSELx),.Pwrite(apb.PWRITE),.Penable(apb.PENABLE),.Paddr(apb.PADDR),.Pwdata(apb.PWDATA));	

initial
	begin
 		uvm_config_db#(virtual AHB_if)::set(null,"*","svif",ahb);
		uvm_config_db#(virtual APB_if)::set(null,"*","dvif[0]",apb);
	//	uvm_config_db#(virtual router_dif) ::set(null,"*","dvif[1]",din1);
	//	uvm_config_db#(virtual router_dif) ::set(null,"*","dvif[2]",din2);

		run_test();
	end
endmodule
