///////////////////////////////////////////////////
// FA.sv  This design will take in 3 bits       //
// and add them to produce a sum and carry out //
////////////////////////////////////////////////
module FA(
  input 	A,B,Cin,	// three input bits to be added
  output	S,Cout		// Sum and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	
	wire Aandb, AandCin, BandCin;
	
	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////

	xor xor0(S, A, B, Cin);
	and and0(AandB, A, B);
	and and1(AandCin, A, Cin);
	and and2(BandCin, B, Cin);
	or or0(Cout, AandB, AandCin, BandCin);
	
	
endmodule

