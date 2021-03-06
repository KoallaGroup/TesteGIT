#Include "Protheus.ch"

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MTA010MNU | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descri��o: | Tela de atendimento do Call Center                                                  |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function MTA010MNU()
Local nx := _nPos := 0 	
	
AAdd( aRotina, { "C�digo de barras" ,"U_ICOMC02", 0 , 4} )
AAdd( aRotina, { "Peso/Embal." ,"U_IESTA13()", 0 , 4} ) 	
AAdd( aRotina, { "Marca" ,"U_ICOMC04()", 0 , 4} )

//Inclus�o de produtos alternativos para os demais m�dulos
For nx := 1 To Len(aRotina)
    _nPos := aScan(aRotina,{|nx| Upper(AllTrim(nx[2])) == Upper("A010ProdAl")})
    If _nPos > 0
        Exit
    EndIf
Next

If _nPos == 0
    aAdd(aRotina, { "Alternativos" ,"A010ProdAl", 0 , 4, 0, .F.} )
EndIf
//--------------------------------------------------------------------------------

Return(.t.)