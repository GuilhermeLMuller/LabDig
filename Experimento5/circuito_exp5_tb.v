      /* --------------------------------------------------------------------
 * Arquivo   : circuito_exp5_tb.v
 * Projeto   : Experiencia 5 - Jogo com rodadas
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog MODELO para circuito da Experiencia 4 
 *
 *             1) Plano de teste acertando os dados
 *              até o final da contagem e modo = 0.
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     07/02/2026  1.0     Guilherme Muller  versao inicial
 *     
 * --------------------------------------------------------------------
 */

`timescale 1ns/1ns

module circuito_exp5_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;

    wire       acertou_out;
    wire       errou_out  ;
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    wire       db_igual_out      ;
    wire [6:0] db_contagem_out   ;
    wire [6:0] db_memoria_out    ;
    wire [6:0] db_estado_out     ;
    wire [6:0] db_jogadafeita_out;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp4 dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .chaves         ( chaves_in   ),
      .acertou        ( acertou_out ),
      .errou          ( errou_out   ),
      .pronto         ( pronto_out  ),
      .leds           ( leds_out    ),
      .db_igual       ( db_igual_out       ),
      .db_contagem    ( db_contagem_out    ),
      .db_memoria     ( db_memoria_out     ),
      .db_estado      ( db_estado_out      ),
      .db_jogadafeita ( db_jogadafeita_out ),
      .db_clock       ( db_clock_out       ),
      .db_iniciar     ( db_iniciar_out     ),    
      .db_tem_jogada  ( db_tem_jogada_out  )
    );

task jogada;
    input [3:0] valor;
    input integer tempo_on;
    input integer tempo_off;
begin
    @(negedge clock_in);
    chaves_in = valor;
    #(tempo_on * clockPeriod);
    chaves_in = 4'b0000;
    #(tempo_off * clockPeriod);
end
endtask


    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      /*
       * Cenario de Teste exemplo - modo = 1 e acerta tudo
       */

      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 2. escolhe modo = 1 e iniciar=1 por 5 periodos de clock
      caso = 2;
      modo_in = 1;
      #(clockPeriod);
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);

      caso = 3;
      jogada(4'b0001, 10, 10);

      caso = 4;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
     
      caso = 5;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);

      caso = 6;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);

      caso = 7;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);

      caso = 8;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);

      caso = 9;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
     
      caso = 10;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
     
      caso = 11;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
     
      caso = 12;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);

      caso = 13;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);

      caso = 14;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0100, 10, 10);

      caso = 15;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
     
      caso = 16;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b1000, 10, 10);

      caso = 17;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0001, 10, 10);

      caso = 18;
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0010, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b0100, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b1000, 10, 10);
      jogada(4'b0001, 10, 10);
      jogada(4'b0100, 10, 10);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule