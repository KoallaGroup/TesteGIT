#Include "Protheus.ch"

/*
+------------+----------+--------+---------------------------------------+-------+----------------+
| Programa:  | TKSU9FIL | Autor: | Jorge Henrique Alves - Anadi Soluções | Data: | Fevereiro/2015 |
+------------+----------+--------+---------------------------------------+-------+----------------+
| Descrição: | Ponto de entrada na consulta "OCO" do teleatendimento							  |
+------------+------------------------------------------------------------------------------------+
| Uso:       | Isapa												                      		  |
+------------+------------------------------------------------------------------------------------+
*/

User Function TKSU9FIL()
Local _aItem := {}, _aArea := GetArea()
Local _cSQL := _cTab := ""

If "ADE_CODSU9" $ ReadVar()
	_cTab := GetNextAlias()
	_cSQL += "Select Distinct U9_CODIGO,U9_DESC,U9_PRAZO From " + RetSqlName("SU9") + " U9 "
	_cSQL += "Where U9_FILIAL = '" + xFilial("SU9") + "' And U9__SEGISP In(' ','0','" + M->ADE__SEGISP + "') And U9.D_E_L_E_T_ = ' ' "
	_cSQL += "Order By U9_DESC "

	If Select(_cTab) > 0
	    DbSelectArea(_cTab)
	    DbCloseArea()
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
	
	DbSelectArea(_cTab)
	DbGoTop()
	
	While !Eof()
		Aadd(_aItem,{	(_cTab)->U9_CODIGO,;    //Codigo
						(_cTab)->U9_DESC,;      //Descricao
						(_cTab)->U9_PRAZO})     //Prazo
		DbSkip()
	EndDo
EndIf

RestArea(_aArea)
Return _aItem


/*
+------------+-----------+--------+---------------------------------------+-------+----------------+
| Programa:  | ITKVALSU9 | Autor: | Jorge Henrique Alves - Anadi Soluções | Data: | Fevereiro/2015 |
+------------+-----------+--------+---------------------------------------+-------+----------------+
| Descrição: | Valida a ocorrencia selecionada no TeleAtendimento								   |
+------------+-------------------------------------------------------------------------------------+
| Uso:       | Isapa												                      		   |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITKVALSU9()
Local _lRet := .t.

DbSelectArea("SU9")
DbSetOrder(2)
If DbSeek(xFilial("SU9") + M->ADE_CODSU9)
	If Val(SU9->U9__SEGISP) > 0 .And. Val(SU9->U9__SEGISP) != Val(M->ADE__SEGIS)
		Help(Nil, Nil,"OCOR x SEGTO", Nil, "A ocorrencia selecionada pertence a outro segmento", 1, 0 ) 
		_lRet := .f.
	EndIf
EndIf

Return _lRet