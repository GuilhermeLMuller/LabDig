/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp3_desafio_tb2.v
 * Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog para desafio da Experiencia 3 
 *             adaptado a partir do testbench do circuito da experiencia 3
 *
 *             1) plano de teste: 16 casos de teste
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     16/01/2024  1.0     Edson Midorikawa  versao inicial
 *     25/01/2026  1.1     Guilherme Muller  adaptado para o desafio
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp3_desafio_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;
    wire       pronto_out;
    wire       acertou_out; //MUDANCA: sinal adicionado
    wire       errou_out; //MUDANCA: sinal adicionado
    wire       db_igual_out;
    wire       db_iniciar_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_chaves_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_acertou_errou_out; //MUDANCA: adicao de sinal

    // Configura��o do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp3_desafio dut (
      .clock      ( clock_in        ),
      .reset      ( reset_in        ),
      .iniciar    ( iniciar_in      ),
      .chaves     ( chaves_in       ),
      .acertou    ( acertou_out     ), //MUDANCA: sinal adicionado
      .errou      ( errou_out       ), //MUDANCA: sinal adicionado
      .pronto     ( pronto_out      ),
      .db_igual   ( db_igual_out    ),
      .db_iniciar ( db_iniciar_out  ),
      .db_contagem( db_contagem_out ),
      .db_memoria ( db_memoria_out  ),
      .db_chaves  ( db_chaves_out   ),
      .db_estado  ( db_estado_out   ),
      .db_acertou_errou (db_acertou_errou_out) //MUDANCA: sinal adicionado
    );

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

      // Teste 1 (resetar circuito)
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;

      // Teste 2 (iniciar=0 por 5 periodos de clock)
      caso = 2;
      #(clockPeriod);

      // Teste 3 (ajustar chaves para 0001, acionar iniciar por 1 periodo de clock)
      caso = 3;
      @(negedge clock_in);
      chaves_in = 4'b0001;   //MUDANCA: chaves
      // pulso em iniciar
      iniciar_in = 1;
      #(clockPeriod);
      iniciar_in = 0;

      // Teste 4 (manter chaves em 0001 por 1 periodo de clock)
      caso = 4;
      @(negedge clock_in);
      chaves_in = 4'b0001;  //MUDANCA: chaves
      #(clockPeriod);

      // Teste 5 (manter chaves em 0001 por 1 periodo de clock)
      caso = 5;
      @(negedge clock_in);
      chaves_in = 4'b0001; //MUDANCA: chaves
      #(clockPeriod);

      // Teste 6 (manter chaves em 0001 por 1 periodo de clock)
      caso = 6;
      @(negedge clock_in);
      chaves_in = 4'b0001; //MUDANCA: chaves
      #(clockPeriod);

      // Teste 7 (manter chaves em 0010 por 3 periodos de clock)
      caso = 7;
      @(negedge clock_in);
      chaves_in = 4'b0010; //MUDANCA: chaves
      #(3*clockPeriod);

      // Teste 8 (manter chaves em 0100 por 3 periodos de clock)
      caso = 8;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      // Teste 9 (manter chaves em 1000, despois 0100, depois 0010 por 3 periodos de clock)
      caso = 9;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(3*clockPeriod);
      chaves_in = 4'b0100;
      #(3*clockPeriod);
      chaves_in = 4'b0010;
      #(3*clockPeriod);

      // Teste 10(manter chaves em 0001 por 6 periodos de clock)
      caso = 10;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(6*clockPeriod);

      // Teste 11(manter chaves em 0010 por 6 periodos de clock)
      caso = 11;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(6*clockPeriod);

      // Teste 12(manter chaves em 0100 por 6 periodos de clock)
      caso = 12;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(6*clockPeriod);

      // Teste 13(manter chaves em 1000 por 6 periodos de clock)
      caso = 13;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(6*clockPeriod);

      // Teste 14(manter chaves em 0001 por 3 periodos de clock)
      caso = 14;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(3*clockPeriod);

      // Teste 15(manter chaves em 0100 por 3 periodos de clock)
      caso = 15;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      // Teste 16(fim da contagem)
      caso = 16;
      @(negedge clock_in);
      chaves_in = 4'b0000;
      #(1*clockPeriod);

      
      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule