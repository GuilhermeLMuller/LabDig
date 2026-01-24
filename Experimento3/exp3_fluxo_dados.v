//------------------------------------------------------------------
// Arquivo   : exp3_fluxo_dados.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Fluxo de dados
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     20/01/2026  1.0     Thiago Martins  versao inicial
//     21/01/2026  1.1     Fernando Ivanov   Revisão
//     24/01/2026  1.2     Guilherme Muller  Revisão
//------------------------------------------------------------------
//

module exp3_fluxo_dados (
    input clock,
    input [3:0] chaves,
    input zeraR,
    input registraR,
    input contaC,
    input zeraC,
    output chavesIgualMemoria,
    output fimC,
    output [3:0] db_contagem,
    output [3:0] db_chaves,
    output [3:0] db_memoria
);

    wire [3:0] s_endereco;
    wire [3:0] s_chaves;
    wire [3:0] s_dado;

    wire maior;
    wire menor;

    contador_163 contador (
        .clock( clock ),
        .clr  ( ~zeraC ),
        .ld   ( 1'b1 ),
        .ent  ( 1'b1 ),
        .enp  ( contaC ),
        .D    ( 4'b0000 ),
        .Q    ( s_endereco ),
        .rco  ( fimC )
    );

    registrador_4 registrador (
        .clock ( clock ),
        .clear ( zeraR ),
        .enable( registraR ),
        .D     ( chaves ),
        .Q     ( s_chaves )
    );

    sync_rom_16x4 memoria (
        .clock    ( clock ),
        .address  ( s_endereco ),
        .data_out ( s_dado )
    );

    comparador_85 comparador (
        .A    ( s_dado ),
        .B    ( s_chaves ),
        .ALBi ( 1'b0 ),
        .AGBi ( 1'b0 ),
        .AEBi ( 1'b1 ),
        .ALBo ( menor ),
        .AGBo ( maior ),
        .AEBo ( chavesIgualMemoria )
    );

    assign db_contagem = s_endereco;
    assign db_memoria = s_dado;
    assign db_chaves = s_chaves;

endmodule