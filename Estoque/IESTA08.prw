#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | IESTA08  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Desmenbra grupos cadastrados no parâmetro MV__SB1GPB para ser    |
|          | utilizado no filtro de produtos de Brinde                        |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function IESTA08()

Local cGrupo := ""
Local aGrupo := StrTokArr(GETMV("MV__SB1GPB"),'/')

For i:=1 to Len(aGrupo)
	cGrupo += PADR(Alltrim(aGrupo[i]),TAMSX3("B1_GRUPO")[1])
	If !(i == Len(aGrupo))
		cGrupo += "/"         
	EndIf
Next
	
Return(cGrupo)