#INCLUDE "PROTHEUS.CH"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : TMKVFIM 						| 	Maio de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada chamado após gravações da SC5 e SC6							 		|
|-------------------------------------------------------------------------------------------------------|	
*/


User Function TMKVFIM(cNumAtend,cNumPedido)     
Local _aArea 	:= GetArea()
Local _aAreaSC6	:= SC6->(GetArea())
Local _aAreaSC9	:= SC9->(GetArea())
Local _cFilial 	:= SUA->UA__FILIAL

/* desativado por Jorge H. - Setembro/2014
if(SUA->UA_OPER == '1' .AND. !Empty(cNumPedido) )
	if Reclock("SC5")
	  	SC5->C5__FILIAL := _cFilial
	   	msunlock()
	EndIf
    

	DbSelectArea("SC6")
	dbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	dbGoTop()
	DbSeek(xFilial("SC6")+cNumPedido)

    Do While(!eof()) .AND. xFilial("SC6")+cNumPedido == xFilial("SC6")+SC6->C6_NUM
	    if Reclock("SC6")
	    	SC6->C6__FILIAL := _cFilial
	    	msunlock()
	    EndIf          
	    DbSkip()
    EndDo       
    
/*    DbSelectArea("SC9")
	dbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	dbGoTop()
	DbSeek(xFilial("SC9")+cNumPedido)

    Do While(!eof()) .AND. xFilial("SC9")+cNumPedido == xFilial("SC9")+SC9->C9_PEDIDO
        if Reclock("SC9")
	    	SC9->C9__FILIAL := _cFilial
	    	msunlock()
	    EndIf          
	    DbSkip()
    EndDo       
*/    
//EndIf

RestArea(_aAreaSC9)	
RestArea(_aAreaSC6)
RestArea(_aArea)
Return