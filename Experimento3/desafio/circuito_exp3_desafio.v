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
 *     24/01/2026  1.2     Fernando Ivanov   acertou/errou display
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
    output [6:0] db_estado,
    output [6:0] db_acertou_errou  // MUDANÇA: há uma saída de 7 bits de acertou/errou para o display
);

    wire zeraR_wire;
    wire registraR_wire;
    wire contaC_wire;
    wire zeraC_wire;
    wire fimC_wire;
    wire fimDiferente_wire; // MUDANÇA: wire que recebe fimDiferente do fluxo de dados
    wire [3:0] acertou_errou_wire;  // MUDANÇA: wire que tem a informação se acertou ou errou
    wire [3:0] db_contagem_wire;
    wire [3:0] db_chaves_wire;
    wire [3:0] db_memoria_wire;
    wire [3:0] db_estado_wire;

    assign acertou_errou_wire = (acertou) ? 4'b1010
                              : (errou) ? 4'b1110 : 4'b0000; // MUDANÇA: se acertou vai para 10 (A) se errou vai para 14 (E)

    exp3_fluxo_dados_desafio FD (
        .clock              (clock),
        .chaves             (chaves),
        .zeraR              (zeraR_wire),
        .registraR          (registraR_wire),
        .contaC             (contaC_wire),
        .zeraC              (zeraC_wire),
        .chavesIgualMemoria (db_igual),
        .fimC               (fimC_wire),
        .fimDiferente       (fimDiferente_wire), // MUDANÇA: wire recebe fimDiferente
        .db_contagem        (db_contagem_wire),
        .db_chaves          (db_chaves_wire),
        .db_memoria         (db_memoria_wire)
    );

    exp3_unidade_controle_desafio UC (
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

    hexa7seg HEX3 (                      // MUDANÇA: acertou errou no display 3
        .hexa    (acertou_errou_wire),
        .display (db_acertou_errou)
    );

    assign db_iniciar = iniciar;

endmodule
