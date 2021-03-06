#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IGENM03			  		| 	Agosto de 2014                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                       |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Consulta padr�o para filtro de acordo com o segmento e a opera��o do usu�rio  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IGENM03() //  #Execblock("IGENM03",.F.,.F.)

Local cSegto 	:= ""
Local cComVen 	:= ""
Local cFiltro	:= ""

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	cSegto := SZ1->Z1_SEGISP
Else
	cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])	
Endif

Do Case
	//Opera��es de Compra
	Case 	Alltrim(Upper(funname())) $ Alltrim(Upper(GETMV("MV__OPECOM")))
			cComVen := "2"
	//Opera��es de Venda
	Case 	Alltrim(Upper(funname())) $ Alltrim(Upper(GETMV("MV__OPEVEN")))
			cComVen := "1"
EndCase

dbSelectArea("SE4")
If !Empty(cComVen)
    If Val(cSegto) > 0
	   cFiltro := "(SE4->E4__SEGISP == '" + cSegto + "' .Or. SE4->E4__SEGISP == '" + PADR('0',TamSX3("Z1_SEGISP")[1]) + "') .and. SE4->E4__COMVEN == '" + cComVen + "' "
	Else
	   cFiltro := "SE4->E4__COMVEN == '" + cComVen + "' "
	EndIf
ElseIf Val(cSegto) > 0
	cFiltro := "SE4->E4__SEGISP == '" + cSegto + "' .Or. SE4->E4__SEGISP == '" + PADR('0',TamSX3("Z1_SEGISP")[1]) + "' "
EndIf		

Return(cFiltro)