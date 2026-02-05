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
//     05/02/2026  1.3     Guilherme Muller    adaptado para Experimento 5
//------------------------------------------------------------------
//


module fluxo_dados (
    input zeraL, //MUDANCA: SINAL ZERA O contadorLimite
    input contaCL, //MUDANCA: SINAL QUE CONTA O contadorLimite
    input modo,  //MUDANCA: entrada modo
    input clock,
    input zeraC,
    input contaC,
    input zeraR,
    input registraR,
    input [3:0] chaves,
    input conta,
    output fimL,
    output fimRodada, //MUDANCA: sinal para ver se a rodada atual acabou
    output fimTotal, //MUDANCA: sinal para ver se chegou na ultima rodada
    output igual,
    output fimC,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada,
    output fimT
);

    wire [3:0] memoria_address_wire;
    wire [3:0] B_wire;
    wire WideOr0;
    wire reset_wire;
    wire [3:0] data_out_wire;

    wire ALBo_wire;
    wire AGBo_wire;

    wire ALBoL_wire;
    wire AGBoL_wire;
    wire ALBoR_wire;
    wire AGBoR_wire;
	 
	wire zera_as_wire;
	wire Q_wire;
	wire meio_wire;
    
    wire mux_wire;
    wire comparadorLimite_wire;

    contador_163 contadorLimite ( //conta qual a rodada atual
        .clock (clock),
        .clr (~zeraL),
        .ld (1'h1),
        .ent (1'h1),
        .enp (contaCL),
        .D (4'h0),
        .Q (comparadorLimite_wire),
        .rco (fimL)
    );

    mux2x1 muxL (
        .D0 (4'b1111),
        .D1 (4'b0011),
        .SEL (modo),
        .OUT (mux_wire)
    );

    comparador_85 comparadorFim ( //COMPARADOR que checa se chegou na ultima rodada
        .ALBi (1'h0), 
        .AGBi (1'h0), 
        .AEBi (1'h1), 
        .A (mux_wire), 
        .B (comparadorLimite_wire),
        .ALBo (ALBoL_wire), 
        .AGBo (AGBoL_wire), 
        .AEBo (fimTotal)
    );

    comparador_85 comparadorRodada ( //Comparador que checa se a rodada atual acabou
        .ALBi (1'h0), 
        .AGBi (1'h0), 
        .AEBi (1'h1), 
        .A (memoria_address_wire), 
        .B (comparadorLimite_wire),
        .ALBo (ALBoR_wire), 
        .AGBo (AGBoR_wire), 
        .AEBo (fimRodada)
    );

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

    contador_m contadorM (
        .clock (clock),
        .zera_as (zera_as_wire),
        .zera_s (zeraC || jogada_feita),
        .conta (conta),
        .Q (Q_wire),
        .fim (fimT),
        .meio (meio_wire)
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

    assign reset_wire = zeraC;  

endmodule