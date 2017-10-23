#Include "Protheus.ch"

/*
+----------+----------+-------+------------------------------------------+------+---------------+
|Programa  | MA920BUT | Autor | Rubens Cruz - Anadi Consultoria 		 | Data | Dezembro/2014 |
+----------+----------+-------+------------------------------------------+------+---------------+
|Descricao | Inclui botões nas ações relacionadas da visualizacao da NF					 	    |
+----------+------------------------------------------------------------------------------------+
|Uso       | Isapa                                                                              |
+----------+------------------------------------------------------------------------------------+
*/

User Function MA920BUT()
Local _aButton := {}

If !Inclui .OR. FunName() = "TMKA503A"
	AAdd(_aButton,{'PRODUTO',{|| U_IFATP01() },"Imp. DANFE" })
EndIf  

If !Inclui .And. !Altera
	AAdd(_aButton,{'PRODUTO',{|| U_IFATA32() },"Inf.Transp." })  
	SetKey( VK_F9 , { || U_IFATA32() } )
EndIf

Return _aButton