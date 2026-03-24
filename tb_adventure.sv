`timescale 1ns/1ps

module tb_adventure;

    // Inputs
    logic clk, reset;
    logic N, S, E, W;

    // Outputs
    logic WIN, DIE;

    // Instantiate DUT
    adventure dut (
        .clk  (clk),
        .reset(reset),
        .N    (N),
        .S    (S),
        .E    (E),
        .W    (W),
        .WIN  (WIN),
        .DIE  (DIE)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Task: take one step in a direction
    task step;
        input logic n, s, e, w;
        begin
            N = n; S = s; E = e; W = w;
            @(posedge clk); #1;
            $display("t=%0t | N=%b S=%b E=%b W=%b | WIN=%b DIE=%b",
                      $time, N, S, E, W, WIN, DIE);
        end
    endtask

    initial begin
        // Initialize
        reset = 1; N = 0; S = 0; E = 0; W = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        $display("=== SCENARIO 1: WIN ===");
        step(0,0,1,0); // Cave → Tunnel
        step(0,1,0,0); // Tunnel → River
        step(0,0,0,1); // River → Stash (get sword!)
        step(0,0,1,0); // Stash → River
        step(0,0,1,0); // River → Den
        step(0,0,1,0); // Den → Vault (WIN!)

        // Check WIN
        if (WIN) $display("PASSED: WIN correct!");
        else     $display("FAILED: WIN expected!");

        $display("=== SCENARIO 2: DIE ===");
        // Reset for new game
        reset = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        step(0,0,1,0); // Cave → Tunnel
        step(0,1,0,0); // Tunnel → River
        step(0,0,1,0); // River → Den (no sword!)
        step(0,0,1,0); // Den → Graveyard (DIE!)

        // Check DIE
        if (DIE) $display("PASSED: DIE correct!");
        else     $display("FAILED: DIE expected!");

        $display("=== Simulation Complete ===");
        $stop;
    end

endmodule