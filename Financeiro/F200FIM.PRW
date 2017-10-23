#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
+-----------+---------+-------+-------------------------------------+------+----------------+
| Programa  | F200fim | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Fevereiro/2014 |
+-----------+---------+-------+-------------------------------------+------+----------------+
| Descricao | Rotina para executara a rotina que copia numero bancario CNAB para o título   |
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA													 					    |
+-----------+-------------------------------------------------------------------------------+
*/

User function F200FIM()

/*
dbSelectArea("FI0")
Reclock( "FI0" , .F. , .T.)
FI0->(dbDelete( ))
MsUnlock()
*/

StartJob("U_IFINA03",GetEnvServer(),.F.)

Return