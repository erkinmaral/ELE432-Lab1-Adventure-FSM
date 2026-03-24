module sword_fsm (
	input logic clk,
	input logic reset,
	input logic in_stash,  //	From room FSM: am i in stash?
	output logic has_sword //	To room FSM: has swrod or not.
);


	//State encoding
	localparam NO_SWORD  = 1'b0;
	localparam GOT_SWORD = 1'b1;
	
	logic state, next_state;


	// BLOCK 1: State Register
	always_ff @(posedge clk or posedge reset) begin
	    if (reset)
		state <= NO_SWORD;
	    else
		state <= next_state;
	end

	// BLOCK 2: Next-State Logic
	always_comb begin
	     case (state)
		NO_SWORD:  next_state = in_stash ? GOT_SWORD : NO_SWORD;
                GOT_SWORD: next_state = GOT_SWORD;
                default:   next_state = NO_SWORD;
      	     endcase

	end

	// BLOCK 3: Output Logic
	always_comb begin
	     has_sword = state;
	end

endmodule
	

