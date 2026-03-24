module room_fsm (
   	 input  logic clk,
   	 input  logic reset,
   	 input  logic N, S, E, W,
    	 input  logic has_sword,
    	 output logic in_stash,
   	 output logic WIN,
   	 output logic DIE
);


    	localparam CAVE      = 3'b000;
  	localparam TUNNEL    = 3'b001;
  	localparam RIVER     = 3'b010;
 	localparam STASH     = 3'b011;
	localparam DEN       = 3'b100;
	localparam VAULT     = 3'b101;
    	localparam GRAVEYARD = 3'b110;

	
	logic [2:0] state, next_state;


	// Block 1: State Register
	    always_ff @(posedge clk or posedge reset) begin
        	if (reset)
            	state <= CAVE;
       	        else
                state <= next_state;
   	    end


 	// Block 2: Next-State Logic
   	    always_comb begin
        	next_state = state;
       		case (state)
          	  CAVE:      next_state = TUNNEL;
          	  TUNNEL:    if (W) next_state = CAVE;
                             else   next_state = RIVER;
          	  RIVER:     if (N)      next_state = TUNNEL;
                             else if (W) next_state = STASH;
                             else        next_state = DEN;
            	  STASH:     next_state = RIVER;
            	  DEN:       next_state = has_sword ? VAULT : GRAVEYARD;
           	  VAULT:     next_state = VAULT;
                  GRAVEYARD: next_state = GRAVEYARD;
                  default:   next_state = CAVE;
                endcase
	    end


       // Block 3: Output Logic
    	   always_comb begin
        	in_stash = (state == STASH);
       		WIN      = (state == VAULT);
       		DIE      = (state == GRAVEYARD);
    	   end

endmodule