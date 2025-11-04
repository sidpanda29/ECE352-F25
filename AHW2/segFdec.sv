// note that this is NOT a program - it is a hardware description that gets turned into logic!
module segFdec

(
	input [3:0] D,
	output segF
);

/// You figure out implementation as instances of verilog primitive gates ///

/// if the BCD is 0, 4, 5, 6, 8, 9 - then the value should be ON  (0)
/// if the BCD is 1, 2, 3, 7       - then the value should be OFF (1)
/// else the value is a DONT CARE
 
        wire D3 = D[3];
        wire D2 = D[2];
        wire D1 = D[1];
        wire D0 = D[0];

wire ND3, ND2, ND1, ND0;

        not not3 (ND3, D3);
        not not2 (ND2, D2);
//      not not1 (ND1, D1);
//      not not0 (ND0, D0);

wire D1orD0, D1orND2, D0orND2;

	// OR terms
        or or1 (D1orD0, D1, D0);
        or or2 (D1orND2, D1, ND2);
        or or3 (D0orND2, D0, ND2);

        // AND terms
        and and1 (segF, D1orD0, D1orND2, D0orND2, ND3);

endmodule
