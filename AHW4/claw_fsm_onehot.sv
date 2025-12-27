//-----------------------------------------------------------------------------
// claw_fsm_onehot.sv
// One-hot FSM implementation of the claw game controller
// Behavior matches claw_fsm.sv (2-bit encoded version).
//
// One-hot state bits:
//   idle   = in IDLE state
//   sweep  = in SWEEP state
//   result = in RESULT state
//   show   = in SHOW state
//-----------------------------------------------------------------------------

module claw_fsm_onehot (
    input  logic clk,
    input  logic rst_n,   // active-low global reset 

    input  logic start_pulse,
    input  logic grab_pulse,
    input  logic timer_zero,
    input  logic hit,
    input  logic attempts_lt5,
    input  logic attempts_eq5,

    output logic obj_ld,
    output logic sweep_en,
    output logic tmr_ld,
    output logic tmr_en,
    output logic score_inc,
    output logic score_dec,
    output logic score_clr,
    output logic attempts_inc,
    output logic attempts_clr
);

    // One-hot state registers
    logic idle,   idle_d;
    logic sweep,  sweep_d;
    logic result, result_d;
    logic show,   show_d;


    //--------------------------------------------------------------------------
    // Declaring state flip-flops
    //--------------------------------------------------------------------------

    d_ff IDLE	(.clk(clk), .D(idle_d),   .Q(idle),   .CLRN(1'b1),  .PRN(rst_n));
    d_ff SWEEP	(.clk(clk), .D(sweep_d),  .Q(sweep),  .CLRN(rst_n), .PRN(1'b1));
    d_ff RESULT	(.clk(clk), .D(result_d), .Q(result), .CLRN(rst_n), .PRN(1'b1));
    d_ff SHOW	(.clk(clk), .D(show_d),   .Q(show),   .CLRN(rst_n), .PRN(1'b1));
	
    //--------------------------------------------------------------------------
    // Next-state equations (D inputs) derived from the behavioral FSM
    //--------------------------------------------------------------------------

    assign idle_d   = show & attempts_eq5 & !start_pulse;
    assign sweep_d  = (idle & start_pulse) | (result & attempts_lt5) | (show & start_pulse);
    assign result_d = sweep & (grab_pulse | timer_zero);
    assign show_d   = result & attempts_eq5;

    //--------------------------------------------------------------------------
    // TODO: Outputs equations(Mealy), same behavior as in claw_fsm.sv
    //--------------------------------------------------------------------------

    assign obj_ld       = (idle | show) & start_pulse;
    assign sweep_en     = sweep;
    assign tmr_ld       = (idle | show) & start_pulse;
    assign tmr_en       = sweep;
    assign score_inc    = sweep & hit;
    assign score_dec    = sweep & (timer_zero | (grab_pulse & !hit));
    assign score_clr    = (idle | show) & start_pulse;
    assign attempts_inc = sweep & (grab_pulse | timer_zero);
    assign attempts_clr = (idle | show) & start_pulse;

endmodule
