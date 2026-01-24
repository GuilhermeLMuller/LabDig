//------------------------------------------------------------------
// Arquivo   : exp3_fluxo_dados_desafio.v
// Projeto   : Desafio de experiencia 3 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Fluxo de dados
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     24/01/2026  1.0     Thiago Martins  versao inicial
//------------------------------------------------------------------
//

module exp3_fluxo_dados_desafio (
    input clock,
    input [3:0] chaves,
    input zeraR,
    input registraR,
    input contaC,
    input zeraC,
    output chavesIgualMemoria,
    output fimC,
    output fimDiferente, // MUDANÇA: output para caso os valores do comparador sejam diferentes
    output [3:0] db_contagem,
    output [3:0] db_chaves,
    output [3:0] db_memoria
);

    wire [3:0] s_endereco;
    wire [3:0] s_chaves;
    wire [3:0] s_dado;

    wire maior;
    wire menor;
    wire chavesIgualMemoria_wire; // MUDANÇA: Wire para guardar chavesIgualMemoria do comparador

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
        .AEBo ( chavesIgualMemoria_wire ) // MUDANÇA: Wire que se liga a AEBo do comparador
    );

    assign db_contagem = s_endereco;
    assign db_memoria = s_dado;
    assign db_chaves = s_chaves;
    assign chavesIgualMemoria = chavesIgualMemoria_wire // MUDANÇA: output chavesIgualMemoria 
                                                        // recebe o wire chavesIgualMemoria_wire

    assign fimDiferente = ~chavesIgualMemoria_wire // MUDANÇA: output fimDiferente guarda se os
                                                   // valores inseridos são diferentes

endmodule