#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT103PN			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de Entrada para verificar se o documento pode ser classificado			|   
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT103PN()
	
	if l103Class             
        If SF1->F1__WMSBLQ == '1' .And. SF1->F1__WMSRET == "1"
        	msgAlert ("O Documento est� Bloqueado por ter divergencia com o pedido de compra!!")
        	return .F.
        ElseIf SF1->F1__WMSRET <> "1"
            msgAlert ("O documento ainda n�o retornou do WMS e n�o pode ser classificado")
            return .F.
        EndIf		
	endif
                                                 	
return .T.