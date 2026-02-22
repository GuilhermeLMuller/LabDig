//------------------------------------------------------------------
// Arquivo   : fluxo_dados.v
// Projeto   : Fluxo de dados da experiência 4
//------------------------------------------------------------------
// Descricao : Fluxo de dados do circuito da experiência 4
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor                 Descricao
//     29/01/2026  1.0     Thiago Martins      versao inicial
//     31/01/2026  1.1     Fernando Ivanov       revisão
//     31/01/2026  1.2     Guilherme Muller    correcao de erros
//     05/02/2026  1.3     Guilherme Muller    adaptado para Experimento 5
//     20/02/2026  1.4     Fernando Ivanov     adaptado para Experimento 6
//------------------------------------------------------------------
//


module fluxo_dados (
    input zeraCL, // zera o contador de limite de rodadas
    input contaCL, // sinal que conta as rodadas
    input [1:0] modo, // sinal que indica o modo de jogo (onfiguração[0])
    input registraModo, // sinal que permite o registro do modo de jogo
    input clock, // sinal de clock
    input zeraC, // sinal que zera contador de jogadas
    input contaC, // sinal que conta no contador de jogadas
    input escreve, // sinal que permite escrita na ram
    input zeraR,  // sinal que zera registrador de botões
    input registraR,  // sinal que permite o registro dos botões 
    input [3:0] botoes, // botoes com as jogadas feitas
    input contaTimeout,  // sinal que permite a contagem do contador de timeout
    input zeraTimeout, // sinal que zera o contador de timeout
    input contaExibicao, // sinal que permite a contagem do contador do timer
    input zeraExibicao,  // sinal que zera o contador do timer
    input resetEdgeDetector, // sinal que zera o edge detector
    input seletorLedsBM, // seleciona qual a saída será exibida nos leds
    input mostraLeds,  // sinal que permite a exibição dos leds
    input botoes_fixo, // sinal que indica se o dado da memória é botões ou valor fixo
    output fimRodada, // sinal que indica o fim da rodada
    output fimTotal, // sinal que indica o final do jogo
    output igual, // sinal que indica que botões é igual a dado de memória
    output fimC, // sinal que indica o fim da contagem do contador de jogadas
    output jogada_feita, // sinal que indica que houve jogada
    output fimTimeout, // sinal que indica que houve timeout
    output fimExibicao, // sinal que indica que houve fim dos 2 segundos
    output [2:0] leds_rgb, // sinal que indica os leds RGB
    output configTimeout_reg, // sinal que indica a configuração do timeout

    // SINAIS DE DEPURAÇÃO:

    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada,
    output [3:0] db_sequencia // NÃO CONECTADO AINDA
);


    // Fios de conexão 


    wire [3:0] memoria_address_wire;
    wire [3:0] B_wire;
    wire WideOr0;
    wire [3:0] data_out_wire;
    wire ALBo_wire;
    wire AGBo_wire;
    wire ALBoL_wire;
    wire AGBoL_wire;
    wire ALBoR_wire;
    wire AGBoR_wire;
	wire [12:0] Q_wire_timeout;
    wire [10:0] Q_wire_exibicao;
	wire meio_wire_timeout;
    wire meio_wire_exibicao;
    wire fimL_wire;
    wire [3:0] muxL_wire;
    wire [3:0] contadorLimite_wire;
    wire RegModo_wire;
    wire [3:0] muxDecoder_wire;
    wire [3:0] muxBotoesFixo_wire;


    // COMPONENTES:


    contador_163 contadorLimite ( //conta qual a rodada atual
        .clock (clock),
        .clr (~zeraCL),  //zeraCL
        .ld (1'h1),
        .ent (1'h1),
        .enp (contaCL),  //contaCL
        .D (4'h0),
        .Q (contadorLimite_wire),
        .rco (fimL_wire)
    );

    registrador_1 RegModo (
        .clock(clock),
        .clear(1'b0),
        .enable(registraModo),
        .D(modo[0]),
        .Q(RegModo_wire)
    );

    registrador_1 RegTimeoutCfg (
        .clock(clock),
        .clear(1'b0),
        .enable(registraModo),   // ou um sinal próprio
        .D(modo[1]),
        .Q(configTimeout_reg)
    );

    mux2x1 muxL (
        .D0 (4'b1111),
        .D1 (4'b0011),
        .SEL (RegModo_wire),
        .OUT (muxL_wire)
    );

    comparador_85 comparadorFim ( //COMPARADOR que checa se chegou na ultima rodada
        .ALBi (1'h0), 
        .AGBi (1'h0), 
        .AEBi (1'h1), 
        .A (muxL_wire), 
        .B (contadorLimite_wire),
        .ALBo (ALBoL_wire), 
        .AGBo (AGBoL_wire), 
        .AEBo (fimTotal)
    );

    comparador_85 comparadorRodada ( //Comparador que checa se a rodada atual acabou
        .ALBi (1'h0), 
        .AGBi (1'h0), 
        .AEBi (1'h1), 
        .A (memoria_address_wire), 
        .B (contadorLimite_wire),
        .ALBo (ALBoR_wire), 
        .AGBo (AGBoR_wire), 
        .AEBo (fimRodada)
    );

    contador_163 contadorJ (
        .clock (clock), 
        .clr (~zeraC), 
        .ld (1'h1), 
        .ent (1'h1), 
        .enp (contaC),
        .D (4'h0),
        .Q (memoria_address_wire),
        .rco (fimC)  
    );

    registrador_4 registradorBotoes (
        .clock (clock),
        .clear (zeraR),
        .enable (registraR),
        .D (botoes),
        .Q (B_wire)
    );

    sync_ram_16x4_file #(.BINFILE("ram_init.txt")) MemJog (
        .clk  (clock),  
        .we   (escreve),  
        .data (muxBotoesFixo_wire),
        .addr (memoria_address_wire),
        .q    (data_out_wire)   
    );

    edge_detector detector ( 
        .clock (clock),
        .reset (resetEdgeDetector),
        .sinal (WideOr0),
        .pulso (jogada_feita)
    );

    contador_m #(.M(5000), .N(13)) timerJogada (
        .clock (clock),
        .zera_as (1'b0),
        .zera_s (zeraTimeout),
        .conta (contaTimeout),
        .Q (Q_wire_timeout),
        .fim (fimTimeout),
        .meio (meio_wire_timeout)
    );
    
    contador_m #(.M(2000), .N(11)) timerExibicao (
        .clock (clock),
        .zera_as (1'b0),
        .zera_s (zeraExibicao),
        .conta (contaExibicao),
        .Q (Q_wire_exibicao),
        .fim (fimExibicao),
        .meio (meio_wire_exibicao)
    );

    comparador_85 comparadorJogada (
        .ALBi (1'h0), 
        .AGBi (1'h0), 
        .AEBi (1'h1), 
        .A (data_out_wire), 
        .B (B_wire),
        .ALBo (ALBo_wire), 
        .AGBo (AGBo_wire), 
        .AEBo (igual)
    );


    mux2x1 muxLed (
        .D0(botoes),
        .D1(data_out_wire),
        .SEL(seletorLedsBM),
        .OUT(muxDecoder_wire)
    );


    decodificador_rgb decodificador (
        .en(mostraLeds),
        .dados(muxDecoder_wire),
        .leds_rgb(leds_rgb)
    );


    mux2x1 muxBotoesFixo (
        .D0(botoes),
        .D1(4'b0001), // Vermelho
        .SEL(botoes_fixo),
        .OUT(muxBotoesFixo_wire)
    );

    // ASSIGNS DE DEPURAÇÃO

    assign db_contagem = memoria_address_wire;
    assign db_jogada = B_wire;
    assign db_sequencia = contadorLimite_wire;
    assign db_memoria = data_out_wire;
    assign db_tem_jogada = WideOr0;


    // ASSIGNS ADICIONAIS PARA LÓGICA COMBINATÓRIA

    assign WideOr0 = (botoes[0] || botoes[1] || botoes[2] || botoes[3]);


endmodule
