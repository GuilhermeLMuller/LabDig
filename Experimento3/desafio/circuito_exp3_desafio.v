/* -----------------------------------------------------------------
 *  Arquivo   : circuito_exp3_desafio.v
 *  Projeto   : Desafio de experiencia 3 - Projeto de uma Unidade de Controle
 * -----------------------------------------------------------------
 * Descricao : Circuito do desafio da experiência 3
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/01/2026  1.0     Thiago Martins    Desenvolvimento
 *     24/01/2026  1.1     Fernando Ivanov   Revisão
 * -----------------------------------------------------------------
 */

module circuito_exp3_desafio (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    output pronto,
    output acertou,
    output errou,
    output db_igual,
    output db_iniciar,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_chaves,
    output [6:0] db_estado
);

    wire zeraR_wire;
    wire registraR_wire;
    wire contaC_wire;
    wire zeraC_wire;
    wire fimC_wire;
    wire fimDiferente_wire; // MUDANÇA: wire que recebe fimDiferente do fluxo de dados
    wire [3:0] db_contagem_wire;
    wire [3:0] db_chaves_wire;
    wire [3:0] db_memoria_wire;
    wire [3:0] db_estado_wire;

    exp3_fluxo_dados FD (
        .clock              (clock),
        .chaves             (chaves),
        .zeraR              (zeraR_wire),
        .registraR          (registraR_wire),
        .contaC             (contaC_wire),
        .zeraC              (zeraC_wire),
        .chavesIgualMemoria (db_igual),
        .fimC               (fimC_wire),
        .fimDiferente       (fimDiferente_wire) // MUDANÇA: wire recebe fimDiferente
        .db_contagem        (db_contagem_wire),
        .db_chaves          (db_chaves_wire),
        .db_memoria         (db_memoria_wire)
    );

    exp3_unidade_controle UC (
        .clock        (clock),
        .reset        (reset),
        .iniciar      (iniciar),
        .fimC         (fimC_wire),
        .fimDiferente (fimDiferente_wire), // MUDANÇA: wire fimDiferente_wire no port fimDiferente da UC
        .zeraC        (zeraC_wire),
        .contaC       (contaC_wire),
        .zeraR        (zeraR_wire),
        .registraR    (registraR_wire),
        .pronto       (pronto),
        .acertou_reg  (acertou), // MUDANÇA: output acertou ligado no registrador acertou_reg
        .errou_reg    (errou), // MUDANÇA: output errou ligado no registrador errou_reg
        .db_estado    (db_estado_wire)
    );

    hexa7seg HEX2 (
        .hexa    (db_chaves_wire),
        .display (db_chaves)
    );

    hexa7seg HEX0 (
        .hexa    (db_contagem_wire),
        .display (db_contagem)
    );

    hexa7seg HEX1 (
        .hexa    (db_memoria_wire),
        .display (db_memoria)
    );

    hexa7seg HEX5 (
        .hexa    (db_estado_wire),
        .display (db_estado)
    );

    assign db_iniciar = iniciar;

endmodule
