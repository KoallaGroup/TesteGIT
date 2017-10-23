#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TK271BOK 		  		| 	Outubro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada no OK do call center (Atendimento)                             |
|-----------------------------------------------------------------------------------------------|
*/

User Function TK271BOK()
Local _aArea := GetArea()                                                                        
Local lRet 	 := .T., _lItemOk := .f., _cCodRet := ""
Local _nPCod := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
Local _nPQtd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })

For nx := 1 To Len(aCols)
    If !aCols[nx][Len(aHeader) + 1]
        If !Empty(aCols[nx][_nPCod]) .And. !Empty(aCols[nx][_nPQtd])
            _lItemOk := .t.
        EndIf
    EndIf
Next

//Se não existem itens válidos, troca o tipo de atendimento para permitir gravação do pedido sem itens
If !_lItemOk
    M->UA_OPER := "3"
    M->UA__STATUS := "1" 
    If Empty(M->UA_TRANSP)
    	M->UA_TRANSP := Alltrim(GetMv("MV__TRPTMK"))
    EndIf
/*
    DbSelectArea("SZD")
    DbGoTop()   
    lRet := ConPad1(,,,"SZD_PE",_cCodRet,, .F.)

    _cCodRet := SZD->ZD_COD            
    
    If lRet     
        M->UA__MOTCAN := _cCodRet
        M->UA__STATUS := "12"
        M->UA__USRCLD := __cUserId
        M->UA__DTCLD  := Date()
        M->UA__HRCLD  := Time()
    Else
        MsgAlert("Opção do motivo de Cancelamento não informado")
        lRet := .F.
    EndIf
*/    
ElseIf M->UA__RESEST == "S" .And. M->UA_OPER != "1"
    M->UA_OPER := "1" 
EndIf
          
/*
Chamadas migradas para o ponto de entrada TMKVPA
Jorge H - Anadi - Dezembro/2014
//Tela para informar transportadora
If M->UA_OPER == "1" .Or. M->UA__RESEST == "S"
    lRet := U_ITMKVLTRP()
    If !lRet 
        Return lRet
    EndIf
EndIf    
//--------------------------------------------------------

If(M->UA_OPER == "1")
	U_ITMKC09(M->UA_CLIENTE,M->UA_LOJA)
EndIf

If( M->UA_OPER == "1" .AND. !(M->UA__TPREAB == "2" .AND. alltrim(M->UA__SITFIN) == "A" .AND. alltrim(M->UA__SITCOM) == "A") )
	lRet := U_IFATA14(M->UA_NUM)
EndIf   

RestArea(_aArea)
*/

Return lRet