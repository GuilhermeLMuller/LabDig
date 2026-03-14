/*------------------------------------------------------------------------
 * Arquivo   : decodificador_rgb.v
 * Projeto   : Fábula TEA
 *------------------------------------------------------------------------
 * Descricao : Decodificador de dados para leds rgb
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     20/02/2026  1.0     Fernando Ivanov   Criacao
 *     20/02/2026  1.1     Fernando Ivanov   Adição do enable
 *     14/02/2026  2.0     Fernando Ivanov   Dados de 6 bits
 *------------------------------------------------------------------------
 */

 // Converte [5:0] dados em [2:0] leds
 // Seguindo a seguinte especificação:
 // leds_rgb[0] = verde - green (G)
 // leds_rgb[1] = vermelho - red (R)
 // leds_rgb[2] = azul - blue (B)

module decodificador_rgb(
    input  wire       en,
    input  wire [5:0] dados,
    output reg  [2:0] leds_rgb
);
    always @(*) begin
        if (!en) begin
            leds_rgb = 3'b000;
        end else begin
            case (dados)
                6'b000001: leds_rgb = 3'b010; // vermelho
                6'b000010: leds_rgb = 3'b100; // azul
                6'b000100: leds_rgb = 3'b001; // verde
                6'b001000: leds_rgb = 3'b011; // amarelo (R+G)
                6'b010000: leds_rgb = 3'b110; // magenta (R+B)
                6'b100000: leds_rgb = 3'b101; // ciano (G+B)
                default:   leds_rgb = 3'b000;
            endcase
        end
    end
endmodule