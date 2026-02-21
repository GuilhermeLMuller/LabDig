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
//     31/01/2026  1.2     Fernando Ivanov   ajuste nos estados
//     05/02/2026  1.3     Guilherme Muller  ajuste para exp5
//     20/02/2026  1.4     Fernando Ivanov   ajuste para exp6
//------------------------------------------------------------------
//

module unidade_controle (
    input fimTotal, //fim da ultima rodada
    input fimRodada, //se a rodada atual chegou ao fim
    input fimTimeout,
    input fimExibicao,
    input clock,
    input igual,
    input iniciar,
    input jogada,
    input reset,
    input configuracaoTimeout,

    output reg acertou,
    output reg errou,
    output reg pronto,
    output reg errou_timeout,

    output reg contaC,
    output reg zeraC,
    output reg registraR,
    output reg zeraR,
    output reg zeraCL,
    output reg contaCL,

    output reg registraModo,
    output reg escreve,
    output reg leds_BM,
    output reg mostraLeds,

    output reg contaExibicao,
    output reg zeraExibicao,

    output reg contaTimeout,
    output reg zeraTimeout,

    output reg resetEdgeDetector,


    output reg [4:0] db_estado
);

    // Define estados
    parameter inicial                     = 5'b00000;  // 0
    parameter inicializa                  = 5'b00001;  // 1 
    parameter prepara_exibicao            = 5'b00010;  // 2
    parameter mostra_jogada_inicial       = 5'b00011;  // 3
    parameter inicia_rodada               = 5'b00100;  // 4
    parameter controla_sequencias         = 5'b00101;  // 5
    parameter espera_jogada               = 5'b00110;  // 6
    parameter registra_jogada             = 5'b00111;  // 7
    parameter compara_jogada              = 5'b01000;  // 8
    parameter proxima_jogada              = 5'b01001;  // 9
    parameter final_acerto                = 5'b01010;  // A
    parameter processa_jogada_adicional   = 5'b01011;  // B
    parameter espera_jogada_adicional     = 5'b01100;  // C
    parameter registra_nova_jogada        = 5'b01101;  // D
    parameter final_erro                  = 5'b01110;  // E
    parameter grava_jogada                = 5'b01111;  // F
    parameter aumenta_limite              = 5'b10000;  // 10
    parameter verifica_fim                = 5'b10001;  // 11
    parameter final_timeout               = 5'b10010;  // 12

    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

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
            inicial:            
                Eprox = (iniciar) ? inicializa : inicial;


            inicializa:         
                Eprox = prepara_exibicao;


            prepara_exibicao:
                Eprox = mostra_jogada_inicial;

            
            mostra_jogada_inicial:
                Eprox = (fimExibicao) ? inicia_rodada : mostra_jogada_inicial;

            
            inicia_rodada:
                Eprox = controla_sequencias;


            controla_sequencias:
                Eprox = espera_jogada;

            
            espera_jogada:
                Eprox = ((jogada) ? registra_jogada : 
                                  ((configuracaoTimeout && fimTimeout) ? final_timeout :
                                                                         espera_jogada));


            registra_jogada:
                Eprox = compara_jogada;


            compara_jogada:
                Eprox = (igual) ? ((fimRodada) ? verifica_fim : 
                                                   proxima_jogada) : final_erro;

            
            proxima_jogada:
                Eprox = espera_jogada;

            
            processa_jogada_adicional:
                Eprox = espera_jogada_adicional;

            
            espera_jogada_adicional:
                Eprox = ((jogada) ? registra_nova_jogada :
                                    ((configuracaoTimeout && fimTimeout) ? final_timeout : 
                                                                           espera_jogada_adicional));

            
            registra_nova_jogada:
                Eprox = grava_jogada;


            grava_jogada:
                Eprox = aumenta_limite;

            
            aumenta_limite:
                Eprox = inicia_rodada;

            
            verifica_fim: 
                Eprox = fimTotal ? final_acerto : processa_jogada_adicional;


            
            final_acerto:
                Eprox = iniciar ? inicializa : final_acerto;

            
            final_erro: 
                Eprox = iniciar ? inicializa : final_erro;

            
            final_timeout:
                Eprox = iniciar ? inicializa : final_timeout;


            default: Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        
        acertou = (Eatual == final_acerto) ? 1'b1 : 1'b0;

        errou = (Eatual == final_timeout ||
                 Eatual == final_erro) ? 1'b1 : 1'b0;
            
        pronto = (Eatual == final_acerto ||
                  Eatual == final_erro ||
                  Eatual == final_timeout) ? 1'b1 : 1'b0;
            
        errou_timeout = (Eatual == final_timeout) ? 1'b1 : 1'b0;

        contaC = (Eatual == proxima_jogada ||
                  Eatual == processa_jogada_adicional) ? 1'b1 : 1'b0;

        zeraC = (Eatual == inicial ||
                 Eatual == inicializa ||
                 Eatual == prepara_exibicao ||
                 Eatual == inicia_rodada) ? 1'b1 : 1'b0;

        registraR = (Eatual == registra_jogada ||
                     Eatual == registra_nova_jogada) ? 1'b1 : 1'b0;
                    
        zeraR = (Eatual == inicial || 
                 Eatual == inicializa) ? 1'b1 : 1'b0;

        zeraCL = (Eatual == inicializa) ? 1'b1 : 1'b0;

        contaCL = (Eatual == aumenta_limite) ? 1'b1 : 1'b0;

        registraModo = (Eatual == inicial ||
                        Eatual == final_acerto ||
                        Eatual == final_erro ||
                        Eatual == final_timeout) ? 1'b1 : 1'b0;
        
        escreve = (Eatual == grava_jogada) ? 1'b1 : 1'b0;

        leds_BM = (Eatual == prepara_exibicao ||
                   Eatual == mostra_jogada_inicial) ? 1'b1 : 1'b0;

        mostraLeds = (Eatual == mostra_jogada_inicial ||
                      Eatual == inicia_rodada ||
                      Eatual == controla_sequencias ||
                      Eatual == espera_jogada ||
                      Eatual == registra_jogada ||
                      Eatual == compara_jogada ||
                      Eatual == proxima_jogada ||
                      Eatual == processa_jogada_adicional ||
                      Eatual == espera_jogada_adicional ||
                      Eatual == registra_nova_jogada ||
                      Eatual == grava_jogada ||
                      Eatual == aumenta_limite ||
                      Eatual == verifica_fim) ? 1'b1 : 1'b0;
        

        contaExibicao = (Eatual == mostra_jogada_inicial) ? 1'b1 : 1'b0;

        zeraExibicao = (Eatual == inicial ||
                        Eatual == inicializa ||
                        Eatual == prepara_exibicao) ? 1'b1 : 1'b0;

        contaTimeout = (Eatual == espera_jogada ||
                        Eatual == espera_jogada_adicional) ? 1'b1 : 1'b0;

        zeraTimeout = (Eatual == inicial ||
                       Eatual == inicializa ||
                       Eatual == inicia_rodada ||
                       Eatual == controla_sequencias ||
                       Eatual == proxima_jogada ||
                       Eatual == processa_jogada_adicional ||
                       Eatual == registra_jogada ||      
                       Eatual == registra_nova_jogada ||    
                       Eatual == aumenta_limite) ? 1'b1 : 1'b0;

        resetEdgeDetector = (Eatual == inicial ||
                             Eatual == inicializa) ? 1'b1 : 1'b0;

    end

    // Saida de depuracao (estado)
        always @* begin
            case (Eatual)
                inicial:                    db_estado = 5'b00000; // 0
                inicializa:                 db_estado = 5'b00001; // 1
                prepara_exibicao:           db_estado = 5'b00010; // 2
                mostra_jogada_inicial:      db_estado = 5'b00011; // 3
                inicia_rodada:              db_estado = 5'b00100; // 4
                controla_sequencias:        db_estado = 5'b00101; // 5
                espera_jogada:              db_estado = 5'b00110; // 6
                registra_jogada:            db_estado = 5'b00111; // 7
                compara_jogada:             db_estado = 5'b01000; // 8
                proxima_jogada:             db_estado = 5'b01001; // 9
                final_acerto:               db_estado = 5'b01010; // A
                processa_jogada_adicional:  db_estado = 5'b01011; // B
                espera_jogada_adicional:    db_estado = 5'b01100; // C
                registra_nova_jogada:       db_estado = 5'b01101; // D
                final_erro:                 db_estado = 5'b01110; // E
                grava_jogada:               db_estado = 5'b01111; // F
                aumenta_limite:             db_estado = 5'b10000; // 10
                verifica_fim:               db_estado = 5'b10001; // 11
                final_timeout:              db_estado = 5'b10010; // 12
                default:                    db_estado = 5'b11111; // erro
            endcase
        end


endmodule
