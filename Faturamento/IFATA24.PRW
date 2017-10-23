#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKC10			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		   									|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta Ultimo Preco														  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function ITMKC10()
                      
Local oButton1
Local oGet1
Local cGet1 := ""
Local oGet10
Local cGet10 := ""
Local oGet11
Local cGet11 := ""
Local oGet12
Local cGet12 := ""
Local oGet13
Local cGet13 := ""
Local oGet14
Local cGet14 := ""
Local oGet15
Local cGet15 := ""
Local oGet16
Local cGet16 := ""
Local oGet17
Local cGet17 := ""
Local oGet18
Local cGet18 := ""
Local oGet19
Local cGet19 := ""
Local oGet2
Local cGet2 := ""
Local oGet20
Local cGet20 := ""
Local oGet21
Local cGet21 := ""
Local oGet22
Local cGet22 := ""
Local oGet23
Local cGet23 := ""
Local oGet3
Local cGet3 := ""
Local oGet4
Local cGet4 := ""
Local oGet5
Local cGet5 := ""
Local oGet6
Local cGet6 := ""
Local oGet7
Local cGet7 := ""
Local oGet8
Local cGet8 := ""
Local oGet9
Local cGet9 := ""
Local oGroup1
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay17
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Consulta Ultima Compra" FROM 000, 000  TO 500, 655 COLORS 0, 16777215 PIXEL

    @ 009, 004 SAY oSay1 PROMPT "Local: " SIZE 017, 006 OF oDlg COLORS 0, 16777215 PIXEL
    @ 007, 024 MSGET oGet1 VAR cGet1 SIZE 021, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 007, 048 MSGET oGet2 VAR cGet2 SIZE 156, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 026, 004 SAY oSay2 PROMPT "Data:" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 025, 024 MSGET oGet4 VAR cGet4 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 009, 211 SAY oSay3 PROMPT "Pedido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 007, 242 MSGET oGet3 VAR cGet3 SIZE 079, 010 OF oDlg COLORS 0, 16777215 PIXEL      
    
    @ 025, 093 SAY oSay4 PROMPT "Data Faturamento:" SIZE 046, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 024, 142 MSGET oGet7 VAR cGet7 SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL         
    
    @ 025, 211 SAY oSay5 PROMPT "Tipo Pedido:" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 025, 243 MSGET oGet5 VAR cGet5 SIZE 013, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 025, 258 MSGET oGet6 VAR cGet6 SIZE 063, 010 OF oDlg COLORS 0, 16777215 PIXEL
   
    @ 045, 005 SAY oSay6 PROMPT "Cliente:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 042, 024 MSGET oGet8 VAR cGet8 SIZE 031, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 042, 058 MSGET oGet9 VAR cGet9 SIZE 145, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    
    @ 045, 213 SAY oSay7 PROMPT "Contato" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 042, 243 MSGET oGet10 VAR cGet10 SIZE 078, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 061, 005 SAY oSay8 PROMPT "End. Faturamento:" SIZE 045, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 059, 055 MSGET oGet11 VAR cGet11 SIZE 017, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 059, 075 MSGET oGet12 VAR cGet12 SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 089, 028 GROUP oGroup1 TO 223, 294 PROMPT "   Ultima Compra do Produto Pelo Cliente   " OF oDlg COLOR 0, 16777215 PIXEL     
    
    @ 106, 049 SAY oSay9 PROMPT "Data:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 105, 086 MSGET oGet13 VAR cGet13 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL   
    
    @ 123, 049 SAY oSay10 PROMPT "Cond. Pagto:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 121, 086 MSGET oGet14 VAR cGet14 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 121, 113 MSGET oGet15 VAR cGet15 SIZE 091, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 139, 050 SAY oSay11 PROMPT "Valor Base:" SIZE 031, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 137, 086 MSGET oGet16 VAR cGet16 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 156, 050 SAY oSay12 PROMPT "Preco Unitario:" SIZE 039, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 153, 086 MSGET oGet17 VAR cGet17 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    
    @ 171, 050 SAY oSay13 PROMPT "Quantidade:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 170, 086 MSGET oGet18 VAR cGet18 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 192, 051 SAY oSay14 PROMPT "Desconto 1:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 203, 051 MSGET oGet19 VAR cGet19 SIZE 049, 010 OF oDlg COLORS 0, 16777215 PIXEL   
    
    @ 193, 104 SAY oSay15 PROMPT "Desconto 2:" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 203, 104 MSGET oGet20 VAR cGet20 SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    
    @ 193, 160 SAY oSay16 PROMPT "Desconto Pedido:" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 203, 160 MSGET oGet22 VAR cGet22 SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL    
    
    @ 193, 216 SAY oSay17 PROMPT "Desconto Promocional:" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 203, 216 MSGET oGet23 VAR cGet23 SIZE 055, 010 OF oDlg COLORS 0, 16777215 PIXEL     
    
    @ 230, 254 BUTTON oButton1 PROMPT "Retorna" SIZE 040, 012 OF oDlg ACTION Close PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return