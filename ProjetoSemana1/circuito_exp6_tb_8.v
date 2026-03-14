`timescale 1ns/1ns

module circuito_exp6_tb_8;

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

    // Clock 1 kHz
    time clockPeriod = 1_000_000; // ns (1ms)
    reg [31:0] caso = 0;

    // Gerador de clock
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

        .db_igual       (db_igual_out),
        .db_contagem    (db_contagem_out),
        .db_memoria     (db_memoria_out),
        .db_estado      (db_estado_out),
        .db_jogadafeita (db_jogadafeita_out),
        .db_clock       (db_clock_out),
        .db_iniciar     (db_iniciar_out),
        .db_tem_jogada  (db_tem_jogada_out),
        .db_timeout     (db_timeout_out),
        .db_fimRodada   (db_fimRodada_out),
        .db_zeraCL      (db_zeraCL_out)
    );

    initial begin
        $display("Inicio da simulacao (timeout na jogada extra - rodada 1)");

        // -------------------------
        // Caso 1: Reset
        // -------------------------
        caso = 1;
        reset_in = 1;
        #(time'(2) * clockPeriod);
        reset_in = 0;
        #(time'(10) * clockPeriod);

        // ----------------------------------------------------------
        // Caso 2: Modo demonstracao + COM timeout
        //   configuracao[0]=1 => modo demonstracao
        //   configuracao[1]=1 => timeout habilitado
        // ----------------------------------------------------------
        caso = 2;
        configuracao_in = 2'b11; // modo=1, timeout=1
        #(time'(1) * clockPeriod);

        // pulso de jogar
        jogar_in = 1;
        #(time'(5) * clockPeriod);
        jogar_in = 0;

        // espera terminar a exibicao inicial (2s ~ 2000 clocks)
        #(time'(2100) * clockPeriod);

        // ----------------------------------------------------------
        // Rodada 1: jogador repete mem[0] = 0001 corretamente
        // e depois DEIXA ESTOURAR TIMEOUT na jogada extra
        // ----------------------------------------------------------
        caso = 3;

        // Aperta 0001 (jogada correta da rodada 1)
        botoes_in = 4'b0001;
        #(time'(20) * clockPeriod);
        botoes_in = 4'b0000;

        // Dá um tempinho pro FSM sair de compara_jogada/verifica_fim
        // e entrar em espera_jogada_adicional (onde o timeout conta)
        #(time'(300) * clockPeriod);

        // Agora NÃO aperta nada: deixa o timeout estourar
        // (usei um valor grande como você vinha usando)
        #(time'(10100) * clockPeriod);

        // tempo pro FSM concluir no estado final_timeout
        #(time'(300) * clockPeriod);

        // -------------------------
        // Checagens esperadas
        // -------------------------
        if (!timeout_out) $display("ERRO: timeout_out deveria ser 1 (timeout na jogada extra).");
        if (!perdeu_out)  $display("ERRO: perdeu_out deveria ser 1 (perdeu por timeout).");
        if (ganhou_out)   $display("ERRO: ganhou_out deveria ser 0 (nao pode ganhar em timeout).");
        if (!pronto_out)  $display("ERRO: pronto_out deveria ser 1 no estado final.");

        $display("Fim da simulacao (timeout na jogada extra - rodada 1)");
        $stop;
    end

endmodule