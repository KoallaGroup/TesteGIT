#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TKVLDTRN			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi									 		|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada apos a transferencia de chamados - Call Center	 				|
|-----------------------------------------------------------------------------------------------|
|	Parametros: ParamIXB[1] = Assunto                                                           |
|				ParamIXB[2] = Grupo                                                             |
|				ParamIXB[3] = Operador que recebera o chamado                                   |
|				ParamIXB[4] = Produto                                                           |
|				ParamIXB[5] = Categoria                                                         |
|				ParamIXB[6] = Causa                                                             |
|				ParamIXB[7] = Efeito                                                            |
|				ParamIXB[8] = Campanha                                                          |
|-----------------------------------------------------------------------------------------------|
*/

USER FUNCTION TKVLDTRN()  
Local _aArea	:= GetArea()
Local _cSac		:= GetMV("MV__CODSAC")
Local _cLog		:= GetMV("MV__CODLOG")
Local _cItem	:= ""
Local _lRet		:= .T.
Local _cDepto	:= Posicione("SU7",1,xFilial("SU7")+TkOperador(),"U7_POSTO")

cProduto := Space(TamSx3("B1_COD")[1])

/*If(Alltrim(_cDepto) != ADE->ADE_GRUPO)
	_lRet := .F.
	MsgInfo("Chamado não pertence ao grupo do operador")
EndIf*/

//Em alguns casos o sistema está limpado o código do operador, no momento da transferencia
If Empty(ADE->ADE_OPERAD) .And. !Empty(ADE->ADE__SU7OP)
	DbSelectArea("ADE")
	While !Reclock("ADE",.F.)
	EndDo
	ADE->ADE_OPERAD := ADE->ADE__SU7OP
	MsUnlock()
EndIf

If(_lRet .AND. Alltrim(_cDepto) == Alltrim(_cLog) .AND. !(Alltrim(ParamIXB[2]) $ Alltrim(GetMV("MV__CODCOM"))))
	_lRet := .F.
	MsgInfo("Grupo logística pode transferir apenas para o grupo Comercial Auto/Bike")
EndIf

If _lret
	If(Alltrim(ParamIXB[2]) != Alltrim(_cSac) .And. ADE->ADE__STAT == 'R')
		Reclock("ADE",.F.)
			ADE->ADE__STAT := "P" 
		MsUnlock()
	ElseIf(ADE->ADE__STAT == "P" .And. Alltrim(_cDepto) == Alltrim(_cLog))
		Reclock("ADE",.F.)
			ADE->ADE__STAT := "Q"
		MsUnlock()
	ElseIf ((Alltrim(ADE->ADE__STAT) $ "P/Q" .And. ParamIXB[2] == Alltrim(_cSac)) .OR.;
			(Alltrim(ParamIXB[2]) == Alltrim(_cSac) .And. ADE->ADE__STAT == 'R'))
        Reclock("ADE",.F.)
            ADE->ADE__STAT := "S"
        MsUnlock()
	EndIf  
	
	If !(Alltrim(ParamIXB[2]) $ ADE->ADE__CVGRP)
		Reclock("ADE",.F.)
	    	ADE->ADE__CVGRP := Alltrim(ADE->ADE__CVGRP) + Alltrim(ParamIXB[2]) + ";"
	 	MsUnlock()
	EndIf
EndIf 

RestArea(_aArea)

Return _lRet