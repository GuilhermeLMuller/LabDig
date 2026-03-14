/*------------------------------------------------------------------------
 * Arquivo   : decodificador_rgb.v
 * Projeto   : Jogo do Desafio da Memoria
 *------------------------------------------------------------------------
 * Descricao : Decodificador de dados para leds rgb
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     20/02/2026  1.0     Fernando Ivanov   Criacao
 *     20/02/2026  1.1     Fernando Ivanov   Adição do enable
 *------------------------------------------------------------------------
 */

 // Converte [3:0] dados em [2:0] leds
 // Seguindo a seguinte especificação:
 // leds_rgb[0] = verde - green (G)
 // leds_rgb[1] = vermelho - red (R)
 // leds_rgb[2] = azul - blue (B)

module decodificador_rgb(
    input  wire       en,
    input  wire [3:0] dados,
    output reg  [2:0] leds_rgb
);
    always @(*) begin
        if (!en) begin
            leds_rgb = 3'b000;
        end else begin
            case (dados)
                4'b0001: leds_rgb = 3'b010; // vermelho (R)
                4'b0010: leds_rgb = 3'b100; // azul (B)
                4'b0100: leds_rgb = 3'b011; // amarelo (R+G)
                4'b1000: leds_rgb = 3'b001; // verde (G)
                default: leds_rgb = 3'b000; // inválido
            endcase
        end
    end
endmodule