#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | ITMKA10  | Autor |  Rubens Cruz  - Anadi  	 | Data | Abril/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Valida quantidade solicitada no pedido do call center		      |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function ITMKA10()
Local lRet   := .T.
Local _nPQmt := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDMTP" }) 

/*
IF(GDFIELDGET("UB__QTDMTP") > 0)
	IF(M->UB__QTDSOL % GDFIELDGET("UB__QTDMTP") <> 0)
		Help( Nil, Nil, "QTDMULTP", Nil, "Produto divergente de Quantidade Multipla " + Alltrim(Str(GDFIELDGET("UB__QTDMTP"))), 1, 0 ) 
		lRet := .F.
	EndIf                              
EndIf
*/
If _nPQmt > 0
    If aCols[n][_nPQmt] > 0
        IF(M->UB__QTDSOL % aCols[n][_nPQmt] <> 0)
            Help( Nil, Nil, "QTDMULTP", Nil, "Produto divergente de Quantidade Multipla " + Alltrim(Str(aCols[n][_nPQmt])), 1, 0 ) 
            lRet := .F.
        EndIf
    EndIf
EndIf

Return lRet