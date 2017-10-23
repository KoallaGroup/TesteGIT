#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
#INCLUDE "FIVEWIN.CH"
#Include "TbiConn.ch"


User Function M460MARK()
//—————————————————————————

Local lRet := .T.
Local cQuery
Local cAlias := CriaTrab(Nil,.F.)
Local _cMark      := PARAMIXB[1]          // caracteres referentes aos itens selecionados para NF de saida
Local cMarca       := ParamIxb[1] 
Local lInverte       := ParamIxb[2] 
Local cPedido      := SC9->C9_PEDIDO 
Local cRelPed := ""


cAlias := GetNextAlias()                     

cQuery := "SELECT DISTINCT(C9_PEDIDO) C9_PEDIDO "
cQuery += "FROM "
cQuery += "SC9010 " 
cQuery += " WHERE "
cQuery += " C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery += " AND D_E_L_E_T_ = ' '"
cQuery += " AND C9_NFISCAL = ' '"
cQuery += " AND C9_OK = '"+ThisMark()+"' "

TCQuery cQuery NEW ALIAS (cAlias)
(cAlias)->(dbGoTop())


cRelPed := "O(s) pedido(s) abaixo foram marcados para faturar,"+chr(13)+chr(10)
cRelPed += " porém existem itens que não foram selecionados: "+chr(13)+chr(10)

While !(cAlias)->(Eof())

//**********************************************************
// Validação aqui a partir de (cAlias)->C9_PEDIDO
//
// lRet := .F.
// Break
//**********************************************************
	cAliasSc6 := GetNextAlias()                     
	
	cQuery := " SELECT C6_NUM, COUNT(DISTINCT(C6_PRODUTO))ITEM_SC6, COUNT(DISTINCT(C9_PRODUTO)) ITEM_SC9, "
	cQuery += " SUM(C6_QTDVEN) QTD_SC6, SUM(C9_QTDLIB) QTD_SC9 FROM SC6010 "
	cQuery += " LEFT JOIN SC9010 ON C9_FILIAL = C6_FILIAL AND C6_NUM = C9_PEDIDO AND C9_PRODUTO = C6_PRODUTO AND C6_ITEM = C9_ITEM " 
	cQuery += " AND SC9010.D_E_L_E_T_ = ' ' AND C9_BLEST = ' ' AND C9_BLCRED = ' ' "
	cQuery += " WHERE C6_NUM = '"+(cAlias)->C9_PEDIDO+"' AND C6_FILIAL = '"+xFilial("SC6")+"' AND SC6010.D_E_L_E_T_ = ' ' AND C6_QTDVEN >0 "
	cQuery += " GROUP BY C6_NUM"
	
	
	TCQuery cQuery NEW ALIAS (cAliasSC6)
	
	If (cAliasSC6)->ITEM_SC6 <> (cAliasSC6)->ITEM_SC9 .Or. (cAliasSC6)->QTD_SC6 <> (cAliasSC6)->QTD_SC9
		cRelPed := "Pedido "+(cAliasSC6)->C6_NUM+" com divergência entre quantidade vendidada e quantidade liberada."
		lRet := .F.
		Exit                              
	EndIf
	(cAliasSc6)->(dbCloseArea())

	 
    SC9->(DBSEEK(xFilial("SC9")+(cAlias)->C9_PEDIDO)) 
    While SC9->(!Eof()) .And. SC9->C9_Filial == xFilial("SC9") .And. SC9->C9_PEDIDO = (cAlias)->C9_PEDIDO
      
          If SC9->C9_OK <> ThisMark() // lInverte //se todos estiver marcado 
               //If validação 
                  lRet := .F. 
               //endIf    
               cRelPed += SC9->C9_PEDIDO+"| |"+SC9->C9_PRODUTO+chr(13)+chr(10)
               
          /*Else   //comparo só os q foram marcados. 
                If SC9->C9_Ok == cMarca .And. ... 
                 If validação 
                      lRet := .F. 
                 EndIf 
             EndIf */ 
         EndIf                                                
          
        SC9->(dbSkip()) 
    Enddo 



                                                                                              

(cAlias)->(dbSkip())

EndDo

If !lRet
	Alert(cRelPed)
EndIf

(cAlias)->(dbCloseArea())




Return(lRet)