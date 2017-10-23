#include "protheus.ch"


User Function M460CUST()
Local _aArea := GetArea(), _cSQL := _cTab := ""
Local _aCST := ParamIxb

_cTab := GetNextAlias()
_cSQL := "Select Count(D2_ITEM) D2_ITEM From " + RetSqlName("SD2") + " D2 "
_cSQL += "Where D2_FILIAL = '" + SD2->D2_FILIAL + "' And D2_DOC = '" + SD2->D2_DOC + "' And D2_SERIE = '" + SD2->D2_SERIE + "' And "
_cSQL +=		"D2_CLIENTE = '" + SD2->D2_CLIENTE + "' And D2_LOJA = '" + SD2->D2_LOJA + "' And D2.D_E_L_E_T_ = ' ' "

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
	//Reclock("SD2",.f.)
	SD2->D2_ITEM := StrZero((_cTab)->D2_ITEM + 1,TamSX3("D2_ITEM")[1])
	//MsUnlock()
EndIf

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

RestArea(_aArea)
Return _aCST