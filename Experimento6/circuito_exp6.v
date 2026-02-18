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
    output [3:0] leds,  // Trocar para leds_rgb (de 3 bits [2:0] leds_rgb)
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

    wire fim_wire;
    wire igual_wire;
    wire jogada_wire; 
    wire contaC_wire; 
    wire [3:0] db_estado_wire;
    wire registraR_wire;
    wire zeraC_wire;
    wire zeraR_wire;
    wire [3:0] db_contagem_wire;
    wire [3:0] db_memoria_wire;
    wire conta_wire;
    wire [3:0] db_jogada_wire;
    wire fim_timeout;
    wire zeraCL_wire;            //adicionados novos fios
    wire contaCL_wire;
    wire fimTotal_wire;
    wire fimRodada_wire;

    unidade_controle UC (
        .clock (clock),
        .igual (igual_wire),
        .iniciar (jogar),
        .jogada (jogada_wire),
        .reset (reset),
        .fimT(fim_timeout),
        .acertou (ganhou),
        .contaC (contaC_wire),
        .db_estado (db_estado_wire),
        .errou (perdeu),
        .pronto (pronto),
		.errou_timeout(timeout),
        .registraR (registraR_wire),
        .zeraC (zeraC_wire),
        .zeraR (zeraR_wire),
        .conta (conta_wire),
        .zeraCL (zeraCL_wire),
        .contaCL (contaCL_wire),
        .fimTotal (fimTotal_wire),
        .fimRodada (fimRodada_wire)
    );

    fluxo_dados FD (
		.modo (configuracao),
        .clock (clock),
        .zeraC (zeraC_wire),
        .contaC (contaC_wire),
        .zeraR (zeraR_wire),
        .registraR (registraR_wire),
        .chaves (botoes),
        .conta(conta_wire),
        .igual (igual_wire),
        .fimC (fim_wire),
        .jogada_feita (jogada_wire),
        .db_tem_jogada (db_tem_jogada),
        .db_contagem (db_contagem_wire),
        .db_memoria (db_memoria_wire),
        .db_jogada (db_jogada_wire),
        .zeraCL (zeraCL_wire),
        .contaCL (contaCL_wire),
        .fimTotal (fimTotal_wire),
        .fimRodada (fimRodada_wire),
        .fimT(fim_timeout)
    );

    hexa7seg HEX3(
        .hexa (db_estado_wire),
        .display (db_estado)
    );

    hexa7seg HEX0(
        .hexa (db_contagem_wire),
        .display (db_contagem)
    );

    hexa7seg HEX2(
        .hexa (db_jogada_wire),
        .display (db_jogadafeita)
    );

    hexa7seg HEX1(
        .hexa (db_memoria_wire),
        .display (db_memoria)
    );

    assign db_clock = clock;
    assign leds = db_memoria_wire;
    assign db_igual = igual_wire;
    assign db_iniciar = jogar;
    assign db_fimRodada = fimRodada_wire;
    assign db_zeraCL = zeraCL_wire;
    assign db_timeout = timeout;

endmodule
