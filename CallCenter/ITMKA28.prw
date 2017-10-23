#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ITMKA28 | Autor: |    Rubens Cruz       | Data: |   Outubro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Função para gerar numero de protocolo do Call Center			      |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ITMKA28()                                                      

Local cProt		:= M->ADE__PROTO                       
Local _cQuery	:= "" 
local _aArea := getArea()    

If Empty(Alltrim(M->ADE__PROTO)) .AND. !Empty(M->ADE__CLI) .AND. !Empty(M->ADE__LOJA)

	_cQuery := "SELECT TO_CHAR(SYSTIMESTAMP, 'RRMMDDHH24MISSFF') AS PROTOCOLO FROM DUAL"
	TcQuery _cQuery New Alias "TRB_PROT"
	
	DbSelectArea("TRB_PROT")
	
	cProt := TRB_PROT->PROTOCOLO
	
	TRB_PROT->(DbCloseArea()) 
	
	restarea(_aArea)
	
EndIf

Return cProt

