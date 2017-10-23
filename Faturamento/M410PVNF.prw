#Include "Protheus.ch"

/*
+----------+----------+-------+------------------------------------------+------+--------------+
|Programa  | M410PVNF | Autor | Luis Carlos - Anadi Consultoria 		 | Data | Março/2015   |
+----------+----------+-------+------------------------------------------+------+--------------+
|Descricao | Valida a geração da NF saida quando chamada pelo botão Pred doc no ped. venda	   |
+----------+-----------------------------------------------------------------------------------+
|Uso       | Isapa                                                                             |
+----------+-----------------------------------------------------------------------------------+
*/

User Function M410PVNF()
	Local _lRet := .F.

	aviso("Atenção!","Usuário sem permissão para acesso a Rotina !!",{"OK"})

Return _lRet