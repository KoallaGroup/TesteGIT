#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | IFATC01 | Autor: | Henrique Martins   | Data: | Novembro/2014|
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Posicione na Tabela SZM para Descrição Doc. Saída            |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function IFATC01()

LOCAL cRet
LOCAL cPos := POSICIONE("SC5",1,XFILIAL("SC5")+SC9->C9_PEDIDO,"C5__STATUS")

cRet := POSICIONE("SZM",1,XFILIAL("SZM")+cPos,"ZM_DESC")       

return(cRet)