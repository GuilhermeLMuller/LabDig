`timescale 1ms/1us

module debounce_tb;

    reg clk;
    reg button_in;
    wire button_out;

    // Instancia o DUT (Device Under Test)
    debounce #(
        .DELAY(20)
    ) dut (
        .clk(clk),
        .button_in(button_in),
        .button_out(button_out)
    );

    // Clock de 1 kHz → período = 1 ms
    always #0.5 clk = ~clk;

    initial begin
        // Inicialização
        clk = 0;
        button_in = 0;

        // Espera inicial
        #10;

        button_in = 1; #1;
        button_in = 0; #1;
        button_in = 1; #1;
        button_in = 0; #1;
        button_in = 1; // finalmente estabiliza

        // Espera tempo suficiente (mais que DELAY)
        #30;
        #50;

        button_in = 0; #1;
        button_in = 1; #1;
        button_in = 0; #1;
        button_in = 1; #1;
        button_in = 0; // estabiliza em 0

        // Espera tempo suficiente
        #30;
        #20;

        $finish;
    end

endmodule