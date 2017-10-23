#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ITMKP03 | Autor: |    Rubens Cuz        | Data: |   Janeiro/2015   |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Rotina criada para permitir que o usuario altere apenas itens do   |
|			 | teleatendimento criado pelo próprio usuario					      |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ITMKP03()                                                            
Local lRet 		:= .T.
Local _nPosUsr 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ADF_CODSU7" })          
Local _cUser	:= Posicione("SU7",1,xFilial("SU7")+aCols[n][_nPosUsr],"U7_CODUSU")

If(__cUserID != _cUser)
	lRet := .F.
EndIf

Return lRet                 