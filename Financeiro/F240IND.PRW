/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : F240IND			  		| 	Janeiro de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de entrada criado para alterar ordem de indice na cria��o de border�s  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function F240IND()

	SE2->(DbSetOrder(17))
	aIndTemp := {CriaTrab(,.F.)}
	IndRegua(cAliasSE2,aIndTemp[1],	SE2->(IndexKey()),,,"") 
	
Return aIndTemp