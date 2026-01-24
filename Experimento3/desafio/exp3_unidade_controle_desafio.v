//------------------------------------------------------------------
// Arquivo   : exp3_unidade_controle_desafio.v
// Projeto   : Desafio de experiencia 3 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     24/01/2026  1.0     Thiago Martins  versao inicial
//     24/01/2026  1.1     Fernando Ivanov segunda versão
//------------------------------------------------------------------
//
module exp3_unidade_controle_desafio (
    input      clock,
    input      reset,
    input      iniciar,
    input      fimC,
    input      fimDiferente, // MUDANÇA: entrada para o wire fimDiferente_wire do circuito
    output reg zeraC,
    output reg contaC,
    output reg zeraR,
    output reg registraR,
    output reg pronto,
    output reg acertou_reg, // MUDANÇA: Registrador que guarda o valor do output acertou
    output reg errou_reg, // MUDANÇA: Registrador que guarda o valor do output errou
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0001;  // 1
    parameter registra   = 4'b0100;  // 4
    parameter comparacao = 4'b0101;  // 5
    parameter proximo    = 4'b0110;  // 6
    parameter fim        = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:     Eprox = iniciar ? preparacao : inicial;
            preparacao:  Eprox = registra;
            registra:    Eprox = comparacao;
            comparacao:  Eprox = (fimC || fimDiferente) ? fim : proximo; // MUDANÇA: o circuito
                                                                // vai do estado comparação para
                                                                // fim se a contagem termina ou se
                                                                // os valores não forem iguais
            
            proximo:     Eprox = registra;
            fim:         Eprox = inicial;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC       = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR       = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraR   = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC      = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto      = (Eatual == fim) ? 1'b1 : 1'b0;
        acertou_reg = (Eatual == fim) && fimC ? 1'b1 : 1'b0; // MUDANÇA: definição de acertou_reg
        errou_reg   = (Eatual == fim) && fimDiferente ? 1'b1 : 1'b0; // MUDANÇA: definição de errou_reg

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
            fim:         db_estado = 4'b1111;  // F
            default:     db_estado = 4'b1110;  // E (erro)
        endcase
    end

endmodule