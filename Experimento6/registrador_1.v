//------------------------------------------------------------------
// Arquivo   : registrador_1.v
// Projeto   : Experiencia 7 - Projeto do Jogo do Desafio da Memória
//------------------------------------------------------------------
// Descricao : Registrador de 1 bit
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     20/02/2026  1.0     Fernando Ivanov   versao inicial
//     20/02/2026  1.1     Fernando Ivanov   registra 1 bit apenas
//------------------------------------------------------------------

module registrador_1 (
    input clock,
    input clear,
    input enable,
    input D,
    output Q
);

    reg IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end    

    assign Q = IQ;

endmodule