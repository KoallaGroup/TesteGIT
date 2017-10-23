#Include "Protheus.ch"

/*
+------------+-----------+--------+------------------------------------------+-------+--------------+
| Programa:  | FT080RDES | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+-----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de entrada utilizado para determinar a regra de desconto						|
+------------+--------------------------------------------------------------------------------------+
| Uso:       | Isapa                                                                				|
+------------+--------------------------------------------------------------------------------------+
*/

User Function FT080RDES

//A regra de desconto padrão não deve ser utilizada. Pois só terá funcionalidade no call center.
//Para isso, está sendo utilizada uma rotina customizada - ITMKC06

Return 0