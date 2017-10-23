/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : F340FLCP			  		| 	Maio de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi			   								|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada criado para filtrar o processo ISAPA na compensacao CP	    	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function F340FLCP 

Local _cFiltro := ""

If !Empty(Alltrim(mv_par13))
	_cFiltro := " And E2_PREFIXO || E2_NUM || E2_PARCELA || E2_TIPO || E2_FORNECE || E2_LOJA"
	_cFiltro += " IN (SELECT ZY_PREFIXO || ZY_NUM || ZY_PARCELA || ZY_TIPO || ZY_FORNECE || ZY_LOJA FROM "+	RetSqlName("SZY") "
	_cFiltro += " WHERE ZY_PROCISA = '"+mv_par13+"')" 
EndIf
	  
Return _cFiltro