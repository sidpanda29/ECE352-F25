module cmp1bit(
  input 	A,				// incoming A-bit to compare
  input 	B,				// incoming B-bit to compare
  input 	AgtBi,			// bit below was greater
  input		AeqBi,			// bit below was equal
  input		AltBi,			// bit below was less

  output 	AgtBo,			// outgoing compare result
  output	AeqBo,			// outgoing compare result
  output	AltBo			// outgoing compare resul
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
	
  wire NA, NB;
    not nota (NA, A);
    not notb (NB, B);

  wire AgtBl; // A Greater Than B Local
  wire AgtBc; // A Greater Than B Cascade
  wire AeqBl; // A Equals B Local
  wire AltBl; // A Less Than B Local
  wire AltBc; // A Less Than B Cascade

  wire AandB; // First and in the XNOR logic
  wire NAandNB; // Second and in the XNOR logic

  wire orGT;
  wire orLT;
  
  //////////////////////////////////////////////
  // Implement cmp1bit logic as structural   //
  // (placement of primitive gates) verilog //
  ///////////////////////////////////////////

	// This section is meant for the greater than and less than parts
	// of the less than bits of the comparator. These are stored locally,
	// but will be used later to determine final output

  and and0 (AgtBl, A, NB); // AND A and Not B for Greater than logic
  and and1 (AltBl, NA, B); // AND Not A and B fof Less than logic
  
	// This section creates the XNOR bit but in structural verilog

  and and2 (AandB, A, B);
  and and3 (NAandNB, NA, NB);

  or or0 (AeqBl, AandB, NAandNB);

	// This section uses the input bits to account for the cascade of the 
	// other inputs. If they are equivalent and 
	
  and and4 (AgtBc, AgtBi, AeqBl);
  and and5 (AltBc, AltBi, AeqBl);
  and and6 (AeqBo, AeqBi, AeqBl);


	// This section compares the cascade bits with the bits from the logic 
	// up above and returns the result

  or or1 (AgtBo, AgtBl, AgtBc);
  or or2 (AltBo, AltBl, AltBc);
  

endmodule