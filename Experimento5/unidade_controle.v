//------------------------------------------------------------------
// Arquivo   : unidade_controle.v
// Projeto   : Unidade de controle da experiência 4
//------------------------------------------------------------------
// Descricao : Unidade de controle do circuito da experiência 4
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     29/01/2026  1.0     Thiago Martins  versao inicial
//     31/01/2026  1.1     Guilherme Muller Correcao de erros
//     31/01/2026  1.4     Fernando Ivanov   ajuste nos estados
//------------------------------------------------------------------
//

module unidade_controle (
    input clock,
    input fim,
    input igual,
    input iniciar,
    input jogada,
    input reset,
    input fimT,
    output reg acertou,
    output reg contaC,
    output reg [3:0] db_estado,
    output reg errou,
    output reg pronto,
	 output reg errou_timeout,
    output reg registraR,
    output reg zeraC,
    output reg zeraR,
    output reg conta
);

    // Define estados
    parameter inicial      = 4'b0000;  // 0
    parameter inicializa   = 4'b0001;  // 1
    parameter espera       = 4'b0010;  // 2
    parameter registra     = 4'b0011;  // 3
    parameter compara      = 4'b0100;  // 4
    parameter proxima      = 4'b0101;  // 5
    parameter final_acerto = 4'b1010;  // A
    parameter final_erro   = 4'b1110;  // E
    parameter final_timeout = 4'b1100; // C

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
            inicial:      Eprox = iniciar ? inicializa : inicial;
            inicializa:   Eprox = espera;
            espera:       Eprox = fimT ? final_timeout : (jogada ? registra : espera);
            registra:     Eprox = compara;
            compara:      Eprox = igual ? (fim ? final_acerto : proxima) : final_erro;
            proxima:      Eprox = espera;
            final_acerto: Eprox = iniciar ? inicializa : final_acerto;
            final_erro:   Eprox = iniciar ? inicializa : final_erro;
            final_timeout: Eprox = iniciar ? inicializa  : final_timeout;
            default:      Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == inicializa) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC    = (Eatual == proxima) ? 1'b1 : 1'b0;
        pronto    = (Eatual == final_acerto || Eatual == final_erro) ? 1'b1 : 1'b0;
        errou     = (Eatual == final_erro || Eatual == final_timeout) ? 1'b1 : 1'b0;
        acertou   = (Eatual == final_acerto) ? 1'b1 : 1'b0;
        conta     = (Eatual == espera) ? 1'b1 : 1'b0;
		  errou_timeout = (Eatual == final_timeout) ? 1'b1 : 1'b0;
        

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:      db_estado = 4'b0000;  // 0
            inicializa:   db_estado = 4'b0001;  // 1
            espera:       db_estado = 4'b0010;  // 2
            registra:     db_estado = 4'b0011;  // 3
            compara:      db_estado = 4'b0100;  // 4
            proxima:      db_estado = 4'b0101;  // 5
            final_acerto: db_estado = 4'b1010;  // A
            final_erro:   db_estado = 4'b1110;  // E
				final_timeout: db_estado = 4'b1100; // C
            default:      db_estado = 4'b1001;  // 9 (erro)
        endcase
    end


endmodule
