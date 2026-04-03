`timescale 1ns/1ns

module circuito_semana2_tb1;

    // Entradas do DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        contar_in   = 0;
    reg        recontar_in = 0;
    reg        relembrar_in = 0;
    reg  [5:0] botoes_in  = 6'b000000;
    reg  [1:0] escolhe_tamanho_in = 2'b00;
    reg  [1:0] historia_in = 2'b00;

    // Saídas do DUT
    wire       acertou_out;
    wire       errou_out;
    wire       contando_out;
    wire       recontando_out;
    wire       relembrando_out;
    wire       led_vermelho_out;
    wire       led_verde_out;
    wire       led_amarelo_out;
    wire       led_azul_out;
    wire       led_ciano_out;
    wire       led_roxo_out;

    // NOVAS SAÍDAS
    wire       serial_out;
    wire       pronto_serial_out;

    // Depuração
    wire [6:0] db_contagem_out;
    wire [5:0] db_memoria_out;
    wire [6:0] db_estado_out;

    // Clock 1 kHz
    parameter clockPeriod = 1_000_000; // ns
    reg [31:0] caso = 0;

    always #((clockPeriod/2)) clock_in = ~clock_in;

    // DUT
    circuito_semana2 dut (
        .clock        (clock_in),
        .reset        (reset_in),
        .contar       (contar_in),
        .recontar     (recontar_in),
        .relembrar    (relembrar_in),
        .botoes       (botoes_in),
        .escolhe_tamanho (escolhe_tamanho_in),
        .historia     (historia_in),

        .acertou       (acertou_out),
        .errou         (errou_out),
        .contando      (contando_out),
        .recontando    (recontando_out),
        .relembrando   (relembrando_out),

        .db_contagem  (db_contagem_out),
        .db_memoria   (db_memoria_out),
        .db_estado    (db_estado_out),

        .led_vermelho (led_vermelho_out),
        .led_verde    (led_verde_out),
        .led_amarelo  (led_amarelo_out),
        .led_azul     (led_azul_out),
        .led_ciano    (led_ciano_out),
        .led_roxo     (led_roxo_out),

        // NOVAS CONEXÕES
        .serial        (serial_out),
        .pronto_serial (pronto_serial_out)
    );

    initial begin
        $display("Inicio da simulacao");

        // Reset
        caso = 1;
        reset_in = 1;
        #(2*clockPeriod);
        reset_in = 0;
        #(10*clockPeriod);

        // Configuração
        caso = 2;
        escolhe_tamanho_in = 2'b00;
        historia_in = 2'b00;
        #(10*clockPeriod);

        // Início transmissão
        contar_in = 1;
        #(5*clockPeriod);
        contar_in = 0;

        // Sequência de botões
        caso = 3;
        botoes_in = 6'b000001; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);
        botoes_in = 6'b000010; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);
        botoes_in = 6'b000100; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);
        botoes_in = 6'b001000; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);

        // Repetição
        caso = 4;
        botoes_in = 6'b000001; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);
        botoes_in = 6'b000010; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);
        botoes_in = 6'b000100; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);
        botoes_in = 6'b001000; #(20*clockPeriod); botoes_in = 0; #(80*clockPeriod);

        #(300*clockPeriod);

        $display("Fim da simulacao");
        $stop;
    end

endmodule