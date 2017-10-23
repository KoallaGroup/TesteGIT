#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATR15				 	| 	Junho de 2015                                       |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi                                           |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatorio de Novos Clientes						                                |
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATR15() 
                      
Private oButton1
Private oButton2
Private oCheckBo1
Private lCheckBo1 := .F.
Private oCheckBo2
Private lCheckBo2 := .F.
Private oGet1
Private cGet1 := CTOD("  /  /    ")
Private oGet2
Private cGet2 := CTOD("  /  /    ")
Private oSay1
Private oSay2
Private oSay3     
Private _cSeg := " " 
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Relacao de Clientes Novos" FROM 000, 000  TO 300, 450 COLORS 0, 16777215 PIXEL

    @ 033, 035 SAY oSay1 PROMPT "Da Data:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 049, 030 SAY oSay2 PROMPT "Ate a Data:" SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 061 MSGET oGet1 VAR cGet1 SIZE 053, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 049, 061 MSGET oGet2 VAR cGet2 SIZE 053, 010 OF oDlg COLORS 0, 16777215 PIXEL                                            
    
    @ 064,035 Say "Segmento: " 		SIZE 040,10 OF oDlg COLORS 0, 16777215 PIXEL
	@ 064,061 MsGet _cSeg 			F3 "SZ7" Size 010,10 of oDlg COLORS 0, 16777215 PIXEL VALID ExistCPO("SZ7")
    
    @ 085, 055 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Somente Clientes Com Vendas" SIZE 089, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 101, 055 CHECKBOX oCheckBo2 VAR lCheckBo2 PROMPT "Somente Clientes Ativos" SIZE 069, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 123, 173 BUTTON oButton1 PROMPT "Processar" SIZE 037, 012 OF oDlg PIXEL ACTION ChamaRel()
    @ 123, 120 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL Action oDlg:End()
    @ 012, 010 SAY oSay3 PROMPT "Relacao de Clientes Novos:" SIZE 099, 007 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return                      

*-------------------------
Static Function ChamaRel()
*-------------------------

cParams := ""                               

cOptions := "1;0;1;Relatório de Clientes Novos"

If !lCheckBo1 

	cParams := DtoS(cGet1) 		+ ";"  		//01 - Da Data:  
	cParams += DtoS(cGet2) 		+ ";"  		//02 - Ate a Data:  
	cParams += IIf(lCheckBo2, "S", "N") + ";" //03 - Clientes Ativos
	If Empty(_cSeg) .Or. (_cSeg = "0")  
		cParams += "'1','2'"    
	Else
		cParams += "'"+_cSeg+"'"
	EndIf
	CallCrys('IFATCR15A',cParams,cOptions)	

Else   

	cParams := DtoS(cGet1) 		+ ";"	//01 - Da Data:  
	cParams += DtoS(cGet2) 		+ ";"	//02 - Ate a Data: 
	cParams += IIf(lCheckBo2, "S", "N") + ";" //03 - Clientes Ativos
	If Empty(_cSeg) .Or. (_cSeg = "0")  
		cParams += "'1','2'"    
	Else
		cParams += "'"+_cSeg+"'"
	EndIf
	CallCrys('IFATCR15B',cParams,cOptions)	
	
EndIf                        

Return