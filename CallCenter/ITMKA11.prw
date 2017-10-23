#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
+------------+----------+--------+---------------+-------+--------------+
| Programa:  | ITMKA11  | Autor: | Rog�rio Alves | Data: | Abril/2014   |
+------------+----------+--------+---------------+-------+--------------+
| Descri��o: | Gatilho para alertar usu�rios do call center sobre a     |
|            | posi��o dos t�tulos dos clientes                         |
+------------+----------------------------------------------------------+
| Uso:       | Isapa                                                    |
+------------+----------------------------------------------------------+
*/

User Function ITMKA11()

Local aArea 	:= GetArea()
Local cQuery 	:= ""
Local QSE1		:= {}

If Inclui
	
	cQuery := " SELECT * "
	cQuery += " FROM " + RetSqlName("SE1")	+ " SE1 "
	cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
	cQuery += " AND E1_CLIENTE = '" + M->UA_CLIENTE + "' "
	cQuery += " AND E1_LOJA = '" + M->UA_LOJA + "' "
	cQuery += " AND E1_SALDO <> 0 "
	cQuery += " AND (E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " or E1_TIPO NOT IN " + FormatIn(MVPROVIS,"|") + ")"
	cQuery += " AND E1_VENCREA < " + DTOS(ddatabase)
	cQuery += " AND SE1.D_E_L_E_T_ = '' "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("QSE1") <> 0
		QSE1->(dbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "QSE1"
	
	dbSelectArea("QSE1")
	QSE1->(dbGoTop())
	
	If !Empty(QSE1->E1_CLIENTE)
		
		ALERT("CLIENTE POSSUI DUPLICATAS EM ABERTO")
		
	EndIf
	
EndIf

RestArea(aArea)

Return M->UA_LOJA