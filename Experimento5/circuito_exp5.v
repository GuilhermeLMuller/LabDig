//------------------------------------------------------------------
// Arquivo   : circuito_exp4.v
// Projeto   : Circuito da experiência 4
//------------------------------------------------------------------
// Descricao : Circuito de integração para experiência 4
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor               Descricao
//     29/01/2026  1.0     Thiago Martins     versao inicial
//     31/01/2026  1.1     Fernando Ivanov    ajuste dos leds
//------------------------------------------------------------------
//

module circuito_exp5 (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    input modo,
    output acertou,
    output errou,
    output pronto,
    output [3:0] leds,
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
        .iniciar (iniciar),
        .jogada (jogada_wire),
        .reset (reset),
        .fimT(fim_timeout),
        .acertou (acertou),
        .contaC (contaC_wire),
        .db_estado (db_estado_wire),
        .errou (errou),
        .pronto (pronto),
		.errou_timeout(db_timeout),
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
		.modo (modo),
        .clock (clock),
        .zeraC (zeraC_wire),
        .contaC (contaC_wire),
        .zeraR (zeraR_wire),
        .registraR (registraR_wire),
        .chaves (chaves),
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
    assign db_iniciar = iniciar;
    assign db_fimRodada = fimRodada_wire;
    assign db_zeraCL = zeraCL_wire;

endmodule
