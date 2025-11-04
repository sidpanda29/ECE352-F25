////////////////////////////////////////////////////////
// d_en_ff.sv: Models a FF with active high enable   //
//                                                  //
// Student 1 Name: << Sidorian Pandovski >>        //
// Student 2 Name: << Carlos Castro-Lopez>>       //
///////////////////////////////////////////////////
module d_en_ff(
  input  logic clk,
  input  logic rst_n,
  input  logic en,
  input  logic d,
  output logic q
);

  ////////////////////////////////////////////////////
  // Declare any needed internal sigals below here //
  //////////////////////////////////////////////////
 
  logic Dmux;
  
  ///////////////////////////////////////////////////
  // Infer logic needed to feed d input of simple //
  // flop to form an enabled flop (use dataflow) //
  ////////////////////////////////////////////////
 
  assign Dmux = (en) ? d : q;

  //////////////////////////////////////////////
  // Instantiate simple d_ff without enable  //
  // and tie PRN inactive.  Connect d input //    
  // to logic you inferred above.          //
  //////////////////////////////////////////

  d_ff ff0(.clk(clk), .D(Dmux), .CLRN(rst_n), .PRN(1'b1), .Q(q));
 
endmodule
