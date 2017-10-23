#Include "Protheus.ch"   
#INCLUDE "TOPCONN.CH"


User Function M460FIL()    

                                                      
Local cPedido := ""
Local cFiltro := ""



cAlias := GetNextAlias()                     

cQuery := "SELECT C5_NUM FROM SC5010 WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND D_E_L_E_T_ = ' ' AND C5__STATUS = '8' "

TCQuery cQuery NEW ALIAS (cAlias)
(cAlias)->(dbGoTop())
                                                      

While !(cAlias)->(Eof())

//**********************************************************
// Validação aqui a partir de (cAlias)->C9_PEDIDO
//
// lRet := .F.
// Break
//**********************************************************
cPedido += "|"+(cAlias)->C5_NUM


(cAlias)->(dbSkip())

EndDo

(cAlias)->(dbCloseArea())

cFiltro := " C9_PEDIDO $ '"+cPedido+"'"

Return(cFiltro)