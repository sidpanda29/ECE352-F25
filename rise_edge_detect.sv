/////////////////////////////////////////////////////////
// rise_edge_detect.sv:  This design implements a     //
// circuit that interfaces to a PB swtich and  	     //
// gives a 1 clk wide puse on a rise of the signal. //
//                                                 //
// Student 1 Name: << Sidorian Pandovski >>       //
// Student 2 Name: << Carlos Castro-Lopez >>     //
//////////////////////////////////////////////////
module rise_edge_detect(
  input clk,			// hook to CLK of flops
  input rst_n,			// hook to PRN
  input sig,			// signal we are detecting a rising edge on
  output sig_rise		// high for 1 clock cycle on rise of sig
);

	//////////////////////////////////////////
	// Declare any needed internal signals //
	////////////////////////////////////////

	logic q0, q1, sig_held;
	
	///////////////////////////////////////////////////////
	// Instantiate flops to synchronize and edge detect //
	/////////////////////////////////////////////////////

	d_ff ff0(.clk(clk), .D(sig), .CLRN(1'b1), .PRN(rst_n), .Q(q0));
	d_ff ff1(.clk(clk), .D(q0), .CLRN(1'b1), .PRN(rst_n), .Q(q1));
	d_ff ff2(.clk(clk), .D(q1), .CLRN(1'b1), .PRN(rst_n), .Q(sig_held));
  
	//////////////////////////////////////////////////////////
	// Infer any needed logic (data flow) to form sig_rise //
	////////////////////////////////////////////////////////
 
	assign sig_rise = q1 & ~sig_held; 
	
endmodule