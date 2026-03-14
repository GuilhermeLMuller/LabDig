// decodificador_rgb_tb.v

`timescale 1ns/1ns

module decodificador_rgb_tb;

    reg        en_in;
    reg  [3:0] dados_in;
    wire [2:0] leds_rgb_out;

    // Instancia o DUT
    decodificador_rgb dut (
        .en       ( en_in        ),
        .dados    ( dados_in     ),
        .leds_rgb ( leds_rgb_out )
    );

    integer caso;

    initial begin
        // Inicialização
        en_in    = 0;
        dados_in = 4'b0000;

        // Caso 1: enable = 0 (LEDs sempre apagados)
        caso = 1;
        $display("Caso 1: en=0, dados=0001 (esperado leds=000)");
        #10 en_in = 0; dados_in = 4'b0001;
        #10;

        // Caso 2: enable = 1, Vermelho
        caso = 2;
        $display("Caso 2: en=1, dados=0001 (Vermelho, esperado leds=010)");
        #10 en_in = 1; dados_in = 4'b0001;
        #10;

        // Caso 3: enable = 1, Azul
        caso = 3;
        $display("Caso 3: en=1, dados=0010 (Azul, esperado leds=100)");
        #10 dados_in = 4'b0010;
        #10;

        // Caso 4: enable = 1, Amarelo
        caso = 4;
        $display("Caso 4: en=1, dados=0100 (Amarelo, esperado leds=011)");
        #10 dados_in = 4'b0100;
        #10;

        // Caso 5: enable = 1, Verde
        caso = 5;
        $display("Caso 5: en=1, dados=1000 (Verde, esperado leds=001)");
        #10 dados_in = 4'b1000;
        #10;

        // Caso 6: enable = 1, valor inválido
        caso = 6;
        $display("Caso 6: en=1, dados=0011 (invalido, esperado leds=000)");
        #10 dados_in = 4'b0011;
        #10;

        // Caso 7: desabilita novamente
        caso = 7;
        $display("Caso 7: en=0, dados=1000 (esperado leds=000)");
        #10 en_in = 0;
        #10;

        // Final do testbench
        caso = 99;
        $display("Final do testbench");
        #10 $stop;
    end

endmodule