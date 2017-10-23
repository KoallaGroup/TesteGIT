#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA10 | Autor: |    Rubens Cruz       | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descri��o: | Schedule para apontamento dos produtos com saldo zero no dia e que |
|            | n�o teve nenhuma movimenta��o no dia                               |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function MT13SI() 

Alert("MT13SI")

Return