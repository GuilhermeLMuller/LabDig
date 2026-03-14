/* -----------------------------------------------------------------
 *  Arquivo   : comparador_85.v
 *  Projeto   : Semana1 1
 * -----------------------------------------------------------------
 * Descricao : comparador de magnitude de 6 bits 
 *             similar ao CI 7485
 *             baseado em descricao comportamental disponivel em	
 * https://web.eecs.umich.edu/~jhayes/iscas.restore/74L85b.v
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     21/12/2023  1.0     Edson Midorikawa  criacao
 *     20/01/2026  1.1     Thiago Martins    Revisão
 *     21/01/2026  1.2     Fernando Ivanov   Revisão
 *     24/01/2026  1.3     Guilherme Muller  Revisão
 *     14/03/2026  2.0     Fernando Ivanov   Adaptação 6 bits
 * -----------------------------------------------------------------
 */

module comparador_85 (ALBi, AGBi, AEBi, A, B, ALBo, AGBo, AEBo);

    input[5:0] A, B;
    input      ALBi, AGBi, AEBi;
    output     ALBo, AGBo, AEBo;
    wire[6:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[6];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[6];
    assign AEBo = ((A == B) && AEBi);

endmodule /* comparador_85 */