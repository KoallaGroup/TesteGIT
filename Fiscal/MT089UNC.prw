#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+------------------------------------------+-------+------------+
| Programa:  | MT089UNC | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Junho/2014 |
+------------+----------+--------+------------------------------------------+-------+------------+
| Descrição: | Ponto de entrada para modificar a chave única no cadastro de TES inteligente      |
+------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 |
+------------+-----------------------------------------------------------------------------------+
*/

User Function MT089UNC()       
Local _cChave := "FM_FILIAL+FM_TIPO+FM_TS+FM_TE+FM_GRPROD+FM_EST+FM_POSIPI+FM_GRTRIB+FM_PRODUTO+FM_CLIENTE+FM_LOJACLI+FM_FORNECE+FM_LOJAFOR"

Return _cChave