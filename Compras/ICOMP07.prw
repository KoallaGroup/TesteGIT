#Include "Rwmake.ch"
#Include "Protheus.ch"

//Atualiza quantidade desembarcada
//Jorge H - Anadi


User Function ICOMP07()
Local _cSQL := _cTab := ""

msginfo("AO TERMINO DO PROCESSAMENTO SERA EXIBIDO UM ALERT INFORMATIVO")

_cTab := GetNextAlias()
_cSQL := "Select D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_TIPO,D1__CODPRO,C7_FORNECE,C7_LOJA, D1_PEDIDO, D1_ITEMPC, D1_QUANT, D1_TOTAL  from " + RetSqlName("SD1") + " D1 "
_cSQL += "Inner Join " + RetSqlName("SC7") + " C7 On C7_FILIAL = D1_FILIAL And C7_NUM = D1_PEDIDO And C7_ITEM = D1_ITEMPC And C7.D_E_L_E_T_ = ' ' "
_cSQL += "Inner Join " + RetSqlName("SZ3") + " Z3 On Z3_FILIAL = D1_FILIAL And Z3_CODIGO = D1__CODPRO And Z3_PEDIDO = D1_PEDIDO And "
_cSQL +=			 "Z3_ITPEDCO = D1_ITEMPC And Z3_CODFORN = C7_FORNECE And Z3_LOJAFOR = C7_LOJA And Z3.D_E_L_E_T_ = ' ' "
_cSQL += "Inner Join " + RetSqlName("SF4") + " F4 On F4_FILIAL = D1_FILIAL And F4_CODIGO = D1_TES And F4.D_E_L_E_T_ = ' ' "
_cSQL += "Inner Join " + RetSqlName("SA2") + " A2 On A2_COD = C7_FORNECE And A2_LOJA = C7_LOJA And A2.D_E_L_E_T_ = ' ' "
_cSQL += "Where D1_DTDIGIT >= '20150501' And D1__CODPRO <> ' ' And F4_ESTOQUE  = 'S' And Z3_QTDESEM = 0 And D1.D_E_L_E_T_ = ' ' "
_cSQL += "Order By D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_ITEM "

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.F.,.T.)

DbSelectArea(_cTab)
DbGoTop()

While !Eof()
	DbSelectArea("SZ3")
	DbSetOrder(5)
 	If DbSeek((_cTab)->D1_FILIAL + (_cTab)->D1__CODPRO + (_cTab)->D1_PEDIDO + (_cTab)->D1_ITEMPC + (_cTab)->C7_FORNECE + (_cTab)->C7_LOJA)
		While !Reclock("SZ3", .F.)
		EndDo
  		SZ3->Z3_QTDESEM := SZ3->Z3_QTDESEM + (_cTab)->D1_QUANT
    	SZ3->Z3_VLDESEM := SZ3->Z3_VLDESEM + (_cTab)->D1_TOTAL
     	MsUnlock()
     EndIf
     
     DbSelectArea(_cTab)
     DbSkip()
EndDo
msginfo("FIM DO PROCESSAMENTO")
DbSelectArea(_cTab)
DbCloseArea()

Return