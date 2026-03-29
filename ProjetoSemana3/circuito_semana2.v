//------------------------------------------------------------------
// Arquivo   : circuito_semana1.v
// Projeto   : Circuito da semana 1 de desenvolvimento do projeto
//------------------------------------------------------------------
// Descricao : Circuito de integração para a semana 1
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor               Descricao
//     29/01/2026  1.0     Thiago Martins     versao inicial
//     31/01/2026  1.1     Fernando Ivanov    ajuste dos leds
//     07/02/2026  1.2     Guilherme Muller   adaptacao para experiencia 5
//     20/02/2026  1.3     Fernando Ivanov    adaptacao para experiencia 6
//     14/03/2026  2.0     Fernando Ivanov    adaptação para a semana 1
//     21/03/2026  2.1     Thiago Martins     Adaptação para a semana 2
//------------------------------------------------------------------
//

module circuito_semana2 (
    input clock,
    input reset,
    input contar,  
    input recontar,
    input relembrar,
    input [5:0] botoes,  
    input [1:0] escolhe_tamanho,
    input [1:0] historia,

    output acertou,
    output errou,   
    output contando,
    output recontando,
    output relembrando,

    output [6:0] db_contagem,
    output [6:0] db_estado,
    output [5:0] db_memoria,

    output led_vermelho,
    output led_verde,
    output led_amarelo,
    output led_azul,
    output led_ciano,
    output led_roxo,

    output serial,
    output pronto_serial
 );

    // Fios para ligação

    wire fimHistoria_w, fimExibicao_w;
    wire igual_w, jogada_feita_w;
    wire contaC_w, zeraC_w, registraR_w, zeraR_w;
    wire registraModo_w, escreve_w, leds_BM_w;
    wire contaExibicao_w, zeraExibicao_w;
    wire resetEdgeDetector_w;
    wire [5:0] leds_saida_w;
    wire limpaHistoria_w, registraHistoria_w;
    wire [6:0] historiaRegistrada_w;
    wire partida_serial_w;
    wire pronto_serial_w;

    wire [4:0] db_estado_w;
    wire [3:0] db_contagem_w;
    wire [5:0] db_memoria_w;


    unidade_controle UC (
        // Entradas do fluxo de dados
        .fimHistoria (fimHistoria_w),
        .fimExibicao (fimExibicao_w),
        .jogada (jogada_feita_w),
        .igual (igual_w),

        // Entradas externas
        .clock (clock),
        .reset (reset),
        .contar (contar),
        .recontar (recontar),
        .relembrar (relembrar),

        .pronto_serial (pronto_serial_w),

        // Saídas externas
        .acertou (acertou),
        .errou (errou),
        .contando (contando),
        .relembrando (relembrando),
        .recontando (recontando),

        // Saídas para o fluxo de dados
        .contaC (contaC_w),
        .zeraC (zeraC_w),
        .registraR (registraR_w),
        .zeraR (zeraR_w),
        .registraModo (registraModo_w),
        .escreve (escreve_w),
        .leds_BM (leds_BM_w),
        .contaExibicao (contaExibicao_w),
        .zeraExibicao (zeraExibicao_w),
        .resetEdgeDetector (resetEdgeDetector_w),
        .registraHistoria (registraHistoria_w),
        .limpaHistoria (limpaHistoria_w),

        .partida_serial (partida_serial_w),

        // Debug
        .db_estado (db_estado_w)
    );

    fluxo_dados FD (
        // Entradas
        .escolhe_tamanho (escolhe_tamanho),
        .registraModo (registraModo_w),
        .clock (clock),
        .zeraC (zeraC_w),
        .contaC (contaC_w),
        .escreve (escreve_w),
        .zeraR (zeraR_w),
        .registraR (registraR_w),
        .botoes (botoes),
        .contaExibicao (contaExibicao_w),
        .zeraExibicao (zeraExibicao_w),
        .resetEdgeDetector (resetEdgeDetector_w),
        .seletorLedsBM (leds_BM_w),
        .historia (historia),
        .registraHistoria (registraHistoria_w),
        .limpaHistoria (limpaHistoria_w),

        // Saídas
        .fimHistoria (fimHistoria_w),
        .igual (igual_w),
        .jogada_feita (jogada_feita_w),
        .fimExibicao (fimExibicao_w),
        .leds_saida (leds_saida_w),
        .historiaRegistrada (historiaRegistrada_w),

        // Debug
        .db_contagem (db_contagem_w),
        .db_memoria (db_memoria_w)
    );

    tx_serial_7N2 modulo_serial (
        .clock (clock),
        .reset (reset),
        .partida (partida_serial_w), // entradas
        .dados_ascii (historiaRegistrada_w),
        .saida_serial (serial), // saidas 
        .pronto (pronto_serial_w),
        .db_clock (), // DESCONECTADA saidas de depuracao
        .db_tick (), // DESCONECTADA
        .db_partida (), // DESCONECTADA
        .db_saida_serial (), // DESCONECTADA
        .db_estado () // DESCONECTADA       
    );

    estado7seg HEX3 (
        .estado (db_estado_w),
        .display(db_estado)
    );

    hexa7seg HEX0 (
        .hexa   (db_contagem_w),
        .display(db_contagem)
    );

    assign db_memoria = db_memoria_w;

    assign led_vermelho = leds_saida_w[0];
    assign led_amarelo = leds_saida_w[1];
    assign led_azul = leds_saida_w[2];
    assign led_ciano = leds_saida_w[3];
    assign led_verde = leds_saida_w[4];
    assign led_roxo = leds_saida_w[5];

    assign pronto_serial = pronto_serial_w;

endmodule