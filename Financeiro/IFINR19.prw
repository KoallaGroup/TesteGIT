#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
+-----------+---------+-------+---------------------------------------+------+------------+
| Programa  | IFINR19 | Autor | Jose Augusto Alves - Anadi Soluções   | Data | Maio/2015  |
+-----------+---------+-------+---------------------------------------+------+------------+
| Descricao | Relatorio de Posicao Financeira de Clientes (Crystal)						  |
+-----------+-----------------------------------------------------------------------------+
| Uso       | ISAPA																		  |
+-----------+-----------------------------------------------------------------------------+
*/

User Function IFINR19()
Private oButton1
Private oButton2
Private oCheckBo1
Private lCheckBo1 := .T.
Private oCheckBo2
Private lCheckBo2 := .F.
Private oGet1
Private cGet1 := dDataBase
Private oGet10
Private cGet10 := Space(3)
Private oGet11
Private cGet11 := "Z   "
Private oGet12
Private cGet12 := CTOD("01/01/2000")
Private oGet13
Private cGet13 := CTOD("31/12/2050")
Private oGet14
Private cGet14 := CTOD("01/01/2000")
Private oGet15
Private cGet15 := CTOD("31/12/2050")
Private oGet16
Private cGet16 := Space(2)
Private oGet17
Private cGet17 := "Z "
Private oGet18
Private cGet18 := Space(3)
Private oGet19
Private cGet19 := "Z  "
Private oGet2
Private cGet2 := Space(12)
Private oGet20
Private cGet20 := " "
Private oGet21
Private cGet21 := "10 "
Private oGet22
Private cGet22 := "20 "
Private oGet23
Private cGet23 := "30 "
Private oGet24
Private cGet24 := "60 "
Private oGet25
Private cGet25 := "90 "
Private oGet26
Private cGet26 := " "
Private oGet3
Private cGet3 := "Z           "
Private oGet4
Private cGet4 := Space(5)
Private oGet5
Private cGet5 := "99999"
Private oGet6
Private cGet6 := Space(2)
Private oGet7
Private cGet7 := "Z "
Private oGet8
Private cGet8 := "NF "
Private oGet9
Private cGet9 := "NF "
Private oGroup1
Private oRadMenu1
Private nRadMenu1 := 1
Private oSay1
Private oSay10
Private oSay11
Private oSay12
Private oSay13
Private oSay14
Private oSay15
Private oSay16
Private oSay17
Private oSay18
Private oSay19
Private oSay2
Private oSay20
Private oSay21
Private oSay22
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Relacao da Posicao Financeira" FROM 000, 000  TO 560, 700 COLORS 0, 16053492 PIXEL
   
	@ 009, 036 SAY oSay1 PROMPT "Data de Referencia" SIZE 049, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 007, 088 MSGET oGet1 VAR cGet1 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//Data de Referencia
    
    @ 024, 040 SAY oSay2 PROMPT "A Partir do Cliente" SIZE 045, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 022, 088 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//A Partir do Cliente 
    
    @ 039, 052 SAY oSay3 PROMPT "Ate o Cliente" SIZE 033, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 037, 088 MSGET oGet3 VAR cGet3 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//Ate o Cliente
    
    @ 054, 043 SAY oSay4 PROMPT "A Partir da Zona" SIZE 041, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 052, 088 MSGET oGet4 VAR cGet4 SIZE 028, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//A Partir da Zona

    @ 069, 055 SAY oSay5 PROMPT "Ate a Zona" SIZE 029, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 067, 088 MSGET oGet5 VAR cGet5 Picture "@R99999" SIZE  028, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//Ate a Zona

    @ 083, 011 SAY oSay6 PROMPT "A Partir do Local de Cobranca" SIZE 074, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 082, 088 MSGET oGet6 VAR cGet6 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//A Partir do Local de Cobranca

    @ 099, 023 SAY oSay7 PROMPT "Ate o Local de Cobranca" SIZE 061, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 097, 088 MSGET oGet7 VAR cGet7 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL 	//Ate o Local de Cobranca
    
    @ 114, 024 SAY oSay8 PROMPT "A Partir do Tipo de Titulo" SIZE 061, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 112, 088 MSGET oGet8 VAR cGet8 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL     //A Partir do Tipo de Titulo

    @ 129, 036 SAY oSay9 PROMPT "Ate o Tipo de Titulo" SIZE 050, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 127, 088 MSGET oGet9 VAR cGet9 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL     //Ate o Tipo de Titulo

    @ 009, 234 SAY oSay10 PROMPT "A Partir do Banco" SIZE 044, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 007, 281 MSGET oGet10 VAR cGet10 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL   //A Partir do Banco

    @ 024, 247 SAY oSay11 PROMPT "Ate o Banco" SIZE 031, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 022, 281 MSGET oGet11 VAR cGet11 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL   //Ate o Banco

    @ 038, 201 SAY oSay12 PROMPT "A Partir da Data de Vencimento" SIZE 078, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 037, 281 MSGET oGet12 VAR cGet12 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL   //A Partir da Data de Vencimento

    @ 054, 213 SAY oSay13 PROMPT "Ate a Data de Vencimento" SIZE 065, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 052, 281 MSGET oGet13 VAR cGet13 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL   //Ate a Data de Vencimento
 
 	@ 069, 210 SAY oSay14 PROMPT "A Partir da Data de Emissao" SIZE 069, 007 OF oDlg COLORS 0, 16053492 PIXEL   
    @ 067, 281 MSGET oGet14 VAR cGet14 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL   //A Partir da Data de Emissao

    @ 084, 222 SAY oSay15 PROMPT "Ate a Data de Emissao" SIZE 057, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 082, 281 MSGET oGet15 VAR cGet15 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL   //Ate a Data de Emissao

    @ 098, 209 SAY oSay16 PROMPT "A Partir do Local de Emissao" SIZE 069, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 097, 281 MSGET oGet16 VAR cGet16 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL   //A Partir do Local de Emissao 
    
    @ 114, 221 SAY oSay17 PROMPT "Ate o Local de Emissao" SIZE 058, 007 OF oDlg COLORS 0, 16053492 PIXEL    
    @ 112, 281 MSGET oGet17 VAR cGet17 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL   //Ate o Local de Emissao
    
    @ 128, 208 SAY oSay18 PROMPT "A Partir do Tipo de Cobranca" SIZE 071, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 127, 281 MSGET oGet18 VAR cGet18 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL   //A partir do Tipo de Cobranca
    
    @ 144, 220 SAY oSay19 PROMPT "Ate o Tipo de Cobranca" SIZE 059, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 142, 281 MSGET oGet19 VAR cGet19 SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL   //Ate o Tipo de Cobranca

/* Foi comentado linhas abaixo, pois conforme o Sr. Luis, esses campos não são mais utilizados
    @ 146, 088 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Titulos em Aberto?" SIZE 055, 009 OF oDlg COLORS 0, 16053492 PIXEL  
    
    @ 162, 088 CHECKBOX oCheckBo2 VAR lCheckBo2 PROMPT "Pagos?" SIZE 048, 008 OF oDlg COLORS 0, 16053492 PIXEL
    
    @ 164, 148 SAY oSay20 PROMPT "Apos" SIZE 020, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 162, 166 MSGET oGet20 VAR cGet20 SIZE 041, 010 OF oDlg COLORS 0, 16777215 PIXEL
*/    

    @ 181, 052 SAY oSay21 PROMPT "Faixa de Dias" SIZE 035, 007 OF oDlg COLORS 0, 16053492 PIXEL
    @ 180, 089 MSGET oGet21 VAR cGet21 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 180, 120 MSGET oGet22 VAR cGet22 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 180, 151 MSGET oGet23 VAR cGet23 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 180, 182 MSGET oGet24 VAR cGet24 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 180, 213 MSGET oGet25 VAR cGet25 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL   
    
    //@ 197, 067 SAY oSay22 PROMPT "Moeda" SIZE 020, 007 OF oDlg COLORS 0, 16053492 PIXEL
    //@ 195, 089 MSGET oGet25 VAR cGet25 SIZE 014, 010 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 195, 106 MSGET oGet26 VAR cGet26 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 213, 089 GROUP oGroup1 TO 262, 212 PROMPT "Modelo" OF oDlg COLOR 0, 16053492 PIXEL
    @ 223, 103 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "Por Cliente ","Por Banco ","Por Zona ","Resumo" SIZE 053, 033 OF oDlg COLOR 0, 16777215 PIXEL 
    
    //@ 257, 302 BUTTON oButton1 PROMPT "Processar" SIZE 037, 012 OF oDlg PIXEL ACTION ChamaRel()
    //@ 257, 259 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()
    
    @ 257, 302 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()
    @ 257, 259 BUTTON oButton1 PROMPT "Processar" SIZE 037, 012 OF oDlg PIXEL ACTION ChamaRel()

  ACTIVATE MSDIALOG oDlg CENTERED

Return                       


*-------------------------
Static Function ChamaRel()
*-------------------------

cParams := ""                               

cParams := cGet2 			+ ";"	//04 - A Partir do Cliante 
cParams += cGet3 			+ ";"	//03 - Ate o Cliente  

cParams += DtoS(cGet1) 		+ ";"	//07 - Data de Referencia   

cParams += cGet21 			+ ";"	//12 - Periodo1
cParams += cGet22 			+ ";"	//13 - Periodo2
cParams += cGet23 			+ ";"	//14 - Periodo3
cParams += cGet24 			+ ";"	//15 - Periodo4
cParams += cGet25 			+ ";"	//16 - Periodo5              

cParams += cGet5 			+ ";"	//21 - Ate a Zona 
cParams += cGet4 			+ ";"	//22 - A Partir da Zona  
                                                                    
cParams += cGet9 			+ ";"	//17 - Ate o Tipo de Titulo  
cParams += cGet8 			+ ";"	//20 - A Partir do Tipo de Titulo       
                                                               
cParams += cGet17 			+ ";"	//10 - Ate Local da Emissao (Filial Ate)
cParams += cGet16 			+ ";"	//11 - A Partir do Local da Emissao (Filial De) 

cParams += cGet19 			+ ";"	//18 - Ate o Tipo de Cobranca   
cParams += cGet18 			+ ";"	//19 - A partir do Tipo de Cobranca  

cParams += cGet11 			+ ";"	//01 - Ate o Banco 
cParams += cGet10 			+ ";"	//02 - A Partir do Banco

cParams += DtoS(cGet15) 	+ ";"	//05 - Ate a Data de Emissao
cParams += DtoS(cGet14) 	+ ";"	//06 - A Partir da Data de Emissao 

cParams += DtoS(cGet13) 	+ ";"	//08 - Ate a Data de Vencimento
cParams += DtoS(cGet12) 	+ ";"	//09 - A Partir da Data de Vencimento    

cOptions := "1;0;1;Relatório de Posicao Financeira"

If nRadMenu1 = 1
	CallCrys('IFINCR19A',cParams,cOptions)	 
ElseIf nRadMenu1 = 2
	CallCrys('IFINCR19B',cParams,cOptions)
ElseIf nRadMenu1 = 3
	CallCrys('IFINCR19C',cParams,cOptions) 
ElseIf nRadMenu1 = 4
	CallCrys('IFINCR19D',cParams,cOptions)
Else
	MsgAlert("Tipo Relatório nao disponivel.")	
EndIf                            

Return