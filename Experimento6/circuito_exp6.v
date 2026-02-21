//------------------------------------------------------------------
// Arquivo   : circuito_exp5.v
// Projeto   : Circuito da experiência 5
//------------------------------------------------------------------
// Descricao : Circuito de integração para experiência 5
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor               Descricao
//     29/01/2026  1.0     Thiago Martins     versao inicial
//     31/01/2026  1.1     Fernando Ivanov    ajuste dos leds
//     07/02/2026  1.2     Guilherme Muller   adaptacao para experiencia 5
//------------------------------------------------------------------
//

module circuito_exp5 (
    input clock,
    input reset,
    input jogar,  
    input [3:0] botoes,  
    input [1:0] configuracao,

    output ganhou,
    output perdeu,  
    output pronto,  
    output [2:0] leds, 
    output timeout,

    output db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output db_clock,
    output db_iniciar,
    output db_tem_jogada,
    output db_timeout,
    output db_fimRodada,
    output db_zeraCL
 );

    // Fios para ligação

    wire fimTotal_w, fimRodada_w, fimTimeout_w, fimExibicao_w;
    wire igual_w, jogada_feita_w;

    wire contaC_w, zeraC_w, registraR_w, zeraR_w, zeraCL_w, contaCL_w;
    wire registraModo_w, escreve_w, leds_BM_w, mostraLeds_w;
    wire contaExibicao_w, zeraExibicao_w;
    wire contaTimeout_w, zeraTimeout_w;
    wire resetEdgeDetector_w;

    wire [4:0] db_estado_w;

    wire [3:0] db_contagem_hex_w;
    wire [3:0] db_memoria_hex_w;
    wire [3:0] db_jogada_hex_w;

    wire configTimeout_reg_w;
    wire [2:0] leds_rgb_w;

    unidade_controle UC (
        .fimTotal (fimTotal_w),
        .fimRodada (fimRodada_w),
        .fimTimeout (fimTimeout_w),
        .fimExibicao (fimExibicao_w),
        .clock (clock),
        .igual (igual_w),
        .iniciar (jogar),
        .jogada (jogada_feita_w),
        .reset (reset),
        .configuracaoTimeout (configTimeout_reg_w),
        .acertou (ganhou),
        .errou (perdeu),
        .pronto (pronto),
        .errou_timeout (timeout),
        .contaC (contaC_w),
        .zeraC (zeraC_w),
        .registraR (registraR_w),
        .zeraR (zeraR_w),
        .zeraCL (zeraCL_w),
        .contaCL (contaCL_w),
        .registraModo (registraModo_w),
        .escreve (escreve_w),
        .leds_BM (leds_BM_w),
        .mostraLeds (mostraLeds_w),
        .contaExibicao (contaExibicao_w),
        .zeraExibicao (zeraExibicao_w),
        .contaTimeout (contaTimeout_w),
        .zeraTimeout (zeraTimeout_w),
        .resetEdgeDetector (resetEdgeDetector_w),
        .db_estado (db_estado_w)
    );

    fluxo_dados FD (
        .zeraCL (zeraCL_w),
        .contaCL (contaCL_w),
        .modo (configuracao),
        .registraModo (registraModo_w),
        .clock (clock),
        .zeraC (zeraC_w),
        .contaC (contaC_w),
        .escreve (escreve_w),
        .zeraR (zeraR_w),
        .registraR (registraR_w),
        .botoes (botoes),
        .contaTimeout (contaTimeout_w),
        .zeraTimeout (zeraTimeout_w),
        .contaExibicao (contaExibicao_w),
        .zeraExibicao (zeraExibicao_w),
        .resetEdgeDetector (resetEdgeDetector_w),
        .seletorLedsBM (leds_BM_w),
        .mostraLeds (mostraLeds_w),
        .fimRodada (fimRodada_w),
        .fimTotal (fimTotal_w),
        .igual (igual_w),
        .fimC (),
        .jogada_feita (jogada_feita_w),
        .fimTimeout (fimTimeout_w),
        .fimExibicao (fimExibicao_w),
        .leds_rgb (leds_rgb_w),
        .configTimeout_reg (configTimeout_reg_w),
        .db_tem_jogada (db_tem_jogada),
        .db_contagem (db_contagem_hex_w),
        .db_memoria (db_memoria_hex_w),
        .db_jogada (db_jogada_hex_w),
        .db_sequencia ()
    );

    estado7seg HEX3 (
        .estado (db_estado_w),
        .display(db_estado)
    );

    hexa7seg HEX0 (
        .hexa   (db_contagem_hex_w),
        .display(db_contagem)
    );

    hexa7seg HEX2 (
    .hexa   (db_jogada_hex_w),
    .display(db_jogadafeita)
);

    hexa7seg HEX1 (
        .hexa   (db_memoria_hex_w),
        .display(db_memoria)
    );


    assign leds = leds_rgb_w;
    assign db_igual = igual_w;
    assign db_clock = clock;
    assign db_iniciar = jogar;
    assign db_timeout = timeout;  
    assign db_fimRodada = fimRodada_w;
    assign db_zeraCL = zeraCL_w;


endmodule
