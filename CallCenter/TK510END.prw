#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TK510END			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi									 		|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada apos a gravacao do teleatendimento - Call Center				|
|-----------------------------------------------------------------------------------------------|
*/

User Function TK510END                            
Local _aArea 	:= getArea() 
Local cSU7 		:= posicione("ADF",1,xFilial("ADF")+ADE->ADE_CODIGO,"ADF_CODSU7")
Local cGrpADE   := posicione("ADF",1,xFilial("ADF")+ADE->ADE_CODIGO,"ADF_CODSU0")
Local cFilOrie	:= posicione("ADF",1,xFilial("ADF")+ADE->ADE_CODIGO,"ADF_FILORI")
Local _cQuery	:= ""
Local _cEncer	:= ""

//Em alguns casos o sistema está limpado o código do operador, no momento da transferencia
If Empty(ADE->ADE_OPERAD) .And. !Empty(ADE->ADE__SU7OP)
	DbSelectArea("ADE")
	While !Reclock("ADE",.F.)
	EndDo
	ADE->ADE_OPERAD := ADE->ADE__SU7OP
	MsUnlock()
EndIf

                     
	If INCLUI
		IF lValTMK
			DbSelectArea("ADF")
			If Reclock("ADF", .T.)
				ADF_FILIAL := xFilial("ADF")	
				ADF_CODIGO := ADE->ADE_CODIGO
				ADF_ITEM   := "002"
				ADF_CODSU9 := "TMK001"   
				ADF_CODSU7 := cSU7
				ADF_CODSU0 := cGrpADE
				ADF_CODOBS := cNumYY
				ADF_DATA   := dDataBase
				ADF_HORAF  := Time()
				ADF_HORA   := Time() 
				ADF_FILORI := cFilOrie  
//				ADF__STATU := "A"
				ADF->(MsUnLock())	  
			EndiF 
		EndIF
	EndiF 
	
//Altera o Status customizado para Encerrado quando é inserida uma ocorrencia do tipo "Encerrado"
//Rubens Cruz - 01/2015
If !INCLUI
	If(select("TMPADE") > 0)
		TMPADF->(DbCloseArea())
	EndIf     
	
	_cQuery	:= "SELECT ADF_ITEM,                                  " + Chr(13)
	_cQuery	+= "       ADF_CODSUQ                                 " + Chr(13)
	_cQuery	+= "FROM " + RetSqlname("ADF") + " ADF                " + Chr(13)
	_cQuery	+= "WHERE ADF.D_E_L_E_T_ = ' '                        " + Chr(13)
	_cQuery	+= "      AND ADF_CODIGO = '" + ADE->ADE_CODIGO + "'  " + Chr(13)
	_cQuery	+= "ORDER BY R_E_C_N_O_ DESC                          "
	TCQUERY _cQuery NEW ALIAS "TMPADE"
	
	If(!(eof()))
		_cEncer := Posicione("SUQ",1,xFilial("SUQ")+TMPADE->ADF_CODSUQ,"UQ_STATCH")
		If(Alltrim(_cEncer) == "3")
			Reclock("ADE",.F.)
				ADE->ADE__STAT := "C"
			MsUnlock()
		EndIf           
		
		If(select("TMPADF") > 0)
			TMPADF->(DbCloseArea())
		EndIf     

		_cQuery := "SELECT ADF.ADF_CODIGO,                       						" + Chr(13)
		_cQuery += "       ADF.ADF_ITEM,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_CODSU7,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_CODSU0,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_FILORI,                         						" + Chr(13)
		_cQuery += "       ADF.ADF__STATU,                       						" + Chr(13)
		_cQuery += "       ADF.R_E_C_N_O_ AS RECADF              						" + Chr(13)
		_cQuery += "FROM " + RetSqlName("ADF") + " ADF           						" + Chr(13)
		_cQuery += "WHERE ADF.D_E_L_E_T_ = ' '                   						" + Chr(13)
		_cQuery += "      AND ADF.ADF__STATU = ' ' 										" + Chr(13)
		_cQuery += "      AND ADF.ADF_CODIGO = '" + ADE->ADE_CODIGO + "' 				" + Chr(13)
		_cQuery += "ORDER BY ADF.ADF_ITEM DESC											"
		TCQUERY _cQuery NEW ALIAS "TMPADF"

		If(!eof())
			DbSelectArea("ADF")
			DbGoTo(TMPADF->RECADF)
			Reclock("ADF")
				ADF->ADF__STATU := ADE->ADE__STAT
			MsUnlock()		
		EndIf 

	    TMPADF->(DbCloseArea())                   

	EndIf

	DbSelectArea("TMPADE")
    DbCloseArea()                   
    
    
EndIf		

lValTMK := .F.
cNumYP  := ""
restarea(_aArea) 
return               