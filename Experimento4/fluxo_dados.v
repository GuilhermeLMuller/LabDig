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
//------------------------------------------------------------------
//


// NOTA: Me parece correto a implementação do reset (Fernando)

module fluxo_dados (
    input clock,
    input zeraC,
    input contaC,
    input zeraR,
    input registraR,
    input [3:0] chaves,
    output igual,
    output fimC,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada
);

    wire memoria_address_wire;
    wire B_wire;
    wire WideOr0;
    wire reset_wire;
    wire data_out_wire;

    wire ALBo_wire;
    wire AGBo_wire;

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

    registrador_4 registradorJ (
        .clock (clock),
        .clear (zeraR),
        .enable (registraR),
        .D (chaves),
        .Q (B_wire)
    );

    sync_rom_16x4  memoria(
        .clock (clock),
        .address (memoria_address_wire),
        .data_out (data_out_wire)
    );

    edge_detector detector (
        .clock (clock),
        .reset (reset_wire),
        .sinal (WideOr0),
        .pulso (jogada_feita)
    );

    comparador_85 comparador (
        .ALBi (1'h0), 
        .AGBi (1'h0), 
        .AEBi (1'h1), 
        .A (data_out_wire), 
        .B (B_wire),
        .ALBo (ALBo_wire), 
        .AGBo (AGBo_wire), 
        .AEBo (igual)
    );

    assign db_contagem = memoria_address_wire;
    assign db_jogada = B_wire;
    assign WideOr0 = (chaves[0] || chaves[1] || chaves[2] || chaves[3]);
    assign db_memoria = data_out_wire;
    assign db_tem_jogada = WideOr0;

    assign reset_wire = (zeraC || contaC);  

endmodule