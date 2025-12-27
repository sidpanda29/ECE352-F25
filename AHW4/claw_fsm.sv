//-----------------------------------------------------------------------------
// claw_fsm.sv  (STUDENT FILE)
//-----------------------------------------------------------------------------
// Behavioral (case-based) Mealy FSM for the claw game controller.
//
// States (fixed):
//   IDLE   - wait for game start
//   SWEEP  - sweep window and run timer
//   RESULT - evaluate current attempt
//   SHOW   - prepare for next attempt or end game
//
// You will complete the next-state and output logic in the always_comb block.
// Do NOT change the module name, ports, or state type.
//-----------------------------------------------------------------------------

module claw_fsm (
    input  logic clk,
    input  logic rst_n,          // asynchronous active-low reset

    // FSM inputs
    input  logic start_pulse,
    input  logic grab_pulse,
    input  logic timer_zero,
    input  logic hit,
    input  logic attempts_lt5,
    input  logic attempts_eq5,

    // Control outputs to datapath
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

    //-------------------------------------------------------------------------
    // State encoding (fixed)
    //-------------------------------------------------------------------------
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        SWEEP  = 2'b01,
        RESULT = 2'b10,
        SHOW   = 2'b11
    } state_t;

    state_t state, next_state;

    //-------------------------------------------------------------------------
    // State register
    //-------------------------------------------------------------------------
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    //-------------------------------------------------------------------------
    // Next-state and output logic
    //-------------------------------------------------------------------------
    always_comb begin
        //---------------------------------------------------------------------
        // State-dependent behavior:
        // Figure out next_state and control outputs to datapath
        //---------------------------------------------------------------------
        unique case (state)

            IDLE: begin
                if(start_pulse) begin
                  attempts_clr = 1'b1;
                  score_clr = 1'b1;
                  obj_ld = 1'b1;
                  tmr_ld = 1'b1;
                  next_state = SWEEP;
                end 				    // end conditional
            end 				    // end IDLE

            SWEEP: begin
                sweep_en = 1'b1;
                tmr_en = 1'b1;
                if(hit) begin
                    attempts_inc = 1'b1;
                    score_inc = 1'b1;
                    next_state = RESULT;
                end                                 // end conditional
                if(timer_zero || (grab_pulse && !hit)) begin
                    attempts_inc = 1'b1;
                    score_dec = 1'b1;
                    next_state = RESULT;
                end                                 // end conditional
            end                                     // end SWEEP

            // RESULT: one attempt has completed (grab or timeout).
            RESULT: begin
                if(attempts_eq5) begin
                    next_state = SHOW;
                end				    // end conditional
                if(attempts_lt5) begin
                    next_state = SWEEP;
                end				    // end conditional
            end					    // end RESULT

            // SHOW: decide whether to continue (new attempt) or end game.
            SHOW: begin
                if(start_pulse) begin
                    attempts_clr = 1'b1;
                    score_clr = 1'b1;
                    obj_ld = 1'b1;
                    tmr_ld = 1'b1;
                    next_state = SWEEP;
                end				    // end conditional
            end					    // end SHOW

            // Safety fallback
            default: begin
                obj_ld        = 1'b0;
                sweep_en      = 1'b0;
                tmr_ld        = 1'b0;
                tmr_en        = 1'b0;
                score_inc     = 1'b0;
                score_dec     = 1'b0;
                score_clr     = 1'b0;
                attempts_inc  = 1'b0;
                attempts_clr  = 1'b0;

                next_state = IDLE;
            end                                     // end defaults

        endcase                                     // end unique

    end                                             // end always_comb

endmodule                                           // end program
