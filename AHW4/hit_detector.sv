//-----------------------------------------------------------------------------
// hit.sv   
//-----------------------------------------------------------------------------

module hit_detector (
    input  logic [17:0] window_mask,
    input  logic [17:0] obj_mask,
    output logic        hit
);

    //TODO: Complete the combinational logic.
    // hit = 1 if ANY overlapping bit is 1

	// temp array to store the status of the hit markers
    logic [17:0] status;

	// anding all the bits in the array one at a time, then xor'ing the 
	// whole result. This will return 1 if there is a bit that has both the
	// bits in the same spot, and will return a 0 if there isn't.
    and andt[17:0](status[17:0], obj_mask[17:0], window_mask[17:0]);
    assign hit = ^status;
   
endmodule
