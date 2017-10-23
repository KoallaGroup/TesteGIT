#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ICOMC07 | Autor: | Henrique Martins   | Data: |Dezembro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Posicione na Tabela SF1 para Descrição Forn. Nota Entrada    |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ICOMC07()

LOCAL cRet

	IF (ALLTRIM(SF1->F1_TIPO) == "D")
   		cRet := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA1->A1_NOME")
	Else
   		cRet := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA2->A2_NOME")
	EndIf

return(cRet)