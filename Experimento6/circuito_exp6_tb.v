`timescale 1ns/1ns

module circuito_exp6;

    // Entradas do DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in   = 0;
    reg  [3:0] botoes_in  = 4'b0000;
    reg  [1:0] configuracao_in = 2'b00; // [0]=modo, [1]=timeout_cfg

    // Saídas do DUT
    wire       ganhou_out;
    wire       perdeu_out;
    wire       pronto_out;
    wire [2:0] leds_out;
    wire       timeout_out;

    // Depuração
    wire       db_igual_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_jogadafeita_out;
    wire       db_clock_out;
    wire       db_iniciar_out;
    wire       db_tem_jogada_out;
    wire       db_timeout_out;
    wire       db_fimRodada_out;
    wire       db_zeraCL_out;

    // Clock 1 kHz (como você vinha usando)
    parameter clockPeriod = 1_000_000; // ns
    reg [31:0] caso = 0;

    always #((clockPeriod/2)) clock_in = ~clock_in;

    // DUT
    circuito_exp6 dut (
        .clock        (clock_in),
        .reset        (reset_in),
        .jogar        (jogar_in),
        .botoes       (botoes_in),
        .configuracao (configuracao_in),

        .ganhou       (ganhou_out),
        .perdeu       (perdeu_out),
        .pronto       (pronto_out),
        .leds         (leds_out),
        .timeout      (timeout_out),

        .db_igual     (db_igual_out),
        .db_contagem  (db_contagem_out),
        .db_memoria   (db_memoria_out),
        .db_estado    (db_estado_out),
        .db_jogadafeita (db_jogadafeita_out),
        .db_clock     (db_clock_out),
        .db_iniciar   (db_iniciar_out),
        .db_tem_jogada (db_tem_jogada_out),
        .db_timeout   (db_timeout_out),
        .db_fimRodada (db_fimRodada_out),
        .db_zeraCL    (db_zeraCL_out)
    );

    initial begin
        $display("Inicio da simulacao");

        // -------------------------
        // Caso 1: Reset
        // -------------------------
        caso = 1;
        reset_in = 1;
        #(2*clockPeriod);
        reset_in = 0;
        #(10*clockPeriod);

        // ----------------------------------------------------------
        // Caso 2: Modo demonstracao (4 rodadas) e SEM timeout
        //   - configuracao[0]=1 => limite 4 (muxL = 0011)
        //   - configuracao[1]=0 => timeout desabilitado
        // ----------------------------------------------------------
        caso = 2;
        configuracao_in = 2'b01; // modo=1, timeout=0
        #(clockPeriod);

        // pulso de jogar (registra configuracao e inicia)
        jogar_in = 1;
        #(5*clockPeriod);
        jogar_in = 0;

        // espera terminar a exibicao inicial (2s = 2000 clocks)
        #(2100*clockPeriod);

        // ----------------------------------------------------------
        // REGRA DO SEU JOGO (do jeito que você implementou):
        // - Só mem[0] precisa estar correto no começo.
        // - Depois, quem define mem[1], mem[2], mem[3]... é o jogador
        //   (pela escrita na RAM em grava_jogada).
        //
        // Como sua ram_init.txt tem mem[0]=0001, vamos:
        //  Rodada 1: repete 0001 e adiciona 0010  -> escreve mem[1]=0010
        //  Rodada 2: repete 0001,0010 e adiciona 0100 -> escreve mem[2]=0100
        //  Rodada 3: repete 0001,0010,0100 e adiciona 1000 -> escreve mem[3]=1000
        //  Rodada 4: repete 0001,0010,0100,1000 e adiciona 0001 (qualquer válida)
        // ----------------------------------------------------------

        // -------------------------
        // Rodada 1 (limite = 0): 0001 + add 0010
        // -------------------------
        caso = 3;
        botoes_in = 4'b0001; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0010; #(20*clockPeriod); botoes_in = 4'b0000; #(200*clockPeriod);

        // -------------------------
        // Rodada 2 (limite = 1): 0001, 0010 + add 0100
        // -------------------------
        caso = 4;
        botoes_in = 4'b0001; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0010; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0100; #(20*clockPeriod); botoes_in = 4'b0000; #(200*clockPeriod);

        // -------------------------
        // Rodada 3 (limite = 2): 0001, 0010, 0100 + add 1000
        // -------------------------
        caso = 5;
        botoes_in = 4'b0001; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0010; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0100; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b1000; #(20*clockPeriod); botoes_in = 4'b0000; #(200*clockPeriod);

        // -------------------------
        // Rodada 4 (limite = 3): 0001, 0010, 0100, 1000 + add 0001
        // (esse "add" final é o que faz você atingir fimTotal depois do aumenta_limite)
        // -------------------------
        caso = 6;
        botoes_in = 4'b0001; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0010; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0100; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b1000; #(20*clockPeriod); botoes_in = 4'b0000; #(80*clockPeriod);
        botoes_in = 4'b0001; #(20*clockPeriod); botoes_in = 4'b0000; #(400*clockPeriod);

        // tempo pro FSM concluir (verifica_fim -> final_acerto)
        #(300*clockPeriod);

        // Checagens
        if (timeout_out) $display("ERRO: timeout_out deveria ser 0 (timeout desabilitado).");
        if (perdeu_out)  $display("ERRO: perdeu_out deveria ser 0 (jogadas corretas).");
        if (!ganhou_out) $display("ERRO: esperado ganhou_out=1 ao final do modo demonstracao.");
        if (!pronto_out) $display("AVISO: esperado pronto_out=1 no estado final (confira waveform).");

        $display("Fim da simulacao");
        $stop;
    end

endmodule