// registrador_2_tb.v

`timescale 1ns/1ns

module registrador_2_tb;
    reg        clk_in;
    reg        clear_in;
    reg        enable_in;
    reg  [1:0] D_in;
    wire [1:0] Q_out;

    registrador_2 dut (
        .clock  ( clk_in    ),
        .clear  ( clear_in  ),
        .enable ( enable_in ),
        .D      ( D_in      ),
        .Q      ( Q_out     )
    );

    // Geração do clock (20ns)
    always begin
        #10 clk_in = ~clk_in;
    end

    integer caso;

    initial begin
        // Inicializa sinais
        clk_in    = 0;
        clear_in  = 0;
        enable_in = 0;
        D_in      = 2'b00;

        // 1) Teste de clear assíncrono
        caso = 1;
        $display("Caso 1: Clear assíncrono (Q deve ir para 00 imediatamente)");
        #5  D_in = 2'b11;
        #5  clear_in = 1;
        #5  clear_in = 0;  // pulso curto de clear
        #20;               // espera um pouco

        // 2) Carregamento com enable=1
        caso = 2;
        $display("Caso 2: enable=1, carrega D no proximo posedge");
        @(negedge clk_in);
        enable_in = 1;
        D_in      = 2'b01;
        @(posedge clk_in); // aqui deve carregar
        #1;
        enable_in = 0;
        #19;

        // 3) Não carrega com enable=0 (mantém valor)
        caso = 3;
        $display("Caso 3: enable=0, muda D mas Q deve manter");
        @(negedge clk_in);
        D_in      = 2'b10;
        enable_in = 0;
        @(posedge clk_in); // não deve carregar
        #20;

        // 4) Carrega outro valor com enable=1
        caso = 4;
        $display("Caso 4: enable=1, carrega novo D no proximo posedge");
        @(negedge clk_in);
        enable_in = 1;
        D_in      = 2'b10;
        @(posedge clk_in); // aqui deve carregar
        #1;
        enable_in = 0;
        #19;

        // Final do testbench
        caso = 99;
        $display("Final do testbench");
        #10 $stop;
    end

endmodule