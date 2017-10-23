/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : F050FIN			  		| 	Maio de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi						    				|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada apos a inclusao dos titulos a pagar        				  	|
|-----------------------------------------------------------------------------------------------|	
*/

User function FA050FIN()       
Local _aArea 	:= GetArea()
     	 
	
//E2__NOMUSE  - C - 30  - NOME USUARIO INCLUSAO
//E2__DTINCL  - D - 8  - DT INCLUSAO
//E2__HRINCL  - C - 5  - HR INCLUSAO
//E2__ROTINC  - C - 30 - ROTINA DA INCLUSAO     

If Reclock("SE2", .F.)
	SE2->E2__NOMUSE := UsrFullName(__cUserID)
	SE2->E2__DTINCL := Date()
    SE2->E2__HRINCL := Substr(Time(),1,5)  
    If FUNNAME() = "FINA050" 
    	SE2->E2__ROTINC := Alltrim(SE2->E2_ORIGEM) + " - " + "CONTAS A PAGAR" 
    ElseIf FUNNAME() = "MATA100"
    	SE2->E2__ROTINC := Alltrim(SE2->E2_ORIGEM) + " - " + "DOCTO ENTRADA" 	
    ElseIf FUNNAME() = "MATA103"
    	SE2->E2__ROTINC := Alltrim(SE2->E2_ORIGEM) + " - " + "DOCTO ENTRADA" 	     
    	SE2->(MsUnlock())    
    Else
    	SE2->E2__ROTINC := Alltrim(SE2->E2_ORIGEM)     
    	SE2->(MsUnlock()) 
    EndIf
EndIf                            

RestArea(_aArea)
Return

