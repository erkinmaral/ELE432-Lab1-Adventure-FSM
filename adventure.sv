module adventure (
   	 input  logic clk,
   	 input  logic reset,
   	 input  logic N, S, E, W,
  	 output logic WIN,
  	 output logic DIE
);

    logic has_sword;
    logic in_stash;

    room_fsm room (
        .clk      (clk),
        .reset    (reset),
        .N        (N),
        .S        (S),
        .E        (E),
        .W        (W),
        .has_sword(has_sword),
        .in_stash (in_stash),
        .WIN      (WIN),
        .DIE      (DIE)
    );

    sword_fsm sword (
        .clk      (clk),
        .reset    (reset),
        .in_stash (in_stash),
        .has_sword(has_sword)
    );

endmodule