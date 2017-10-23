#include "protheus.ch"
#include "Rwmake.ch"
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMA16			  		| 	Junho de 2015		   		  					    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto Ferraraz Pereira Alves - Anadi								|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Tela para informacao de redespacho na entrada								  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA16()      

Local _aArea	:= GetArea()
Private oButton1
Private oButton2
Private oComboBo1
Private oGet1
Private oGet2
Private cGet2 := Space(30)
Private oSay1
Private oSay2
Static oDlg 
Public cGetReds  := Space(6)
Public cRedspach := "C" 
//Public lRedEnt 	 := .F.  

If !Inclui
	
	cGetReds := 	SF1->F1__TRARED
	cRedspach := 	SF1->F1__TPFRED
   
	DbSelectArea("SA4")
	If(dbSeek(xFilial("SA4")+Alltrim(cGetReds)))
   		cGet2 := SA4->A4_NOME  
   	EndIf
  	   
EndIf

  DEFINE MSDIALOG oDlg TITLE "Transportadora do Redespacho" FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL

    @ 017, 008 SAY oSay1 PROMPT "Transportadora:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 036, 021 SAY oSay2 PROMPT "Tipo Frete:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    If !Inclui
    	@ 016, 048 MSGET oGet1 VAR cGetReds F3 "SA4" SIZE 036, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID ValTra(cGetReds) WHEN .F.  
    Else
   		@ 016, 048 MSGET oGet1 VAR cGetReds F3 "SA4" SIZE 036, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID ValTra(cGetReds) 
    EndIf
    	@ 016, 089 MSGET oGet2 VAR cGet2 SIZE 147, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    If !Inclui
    	@ 035, 048 MSCOMBOBOX oComboBo1 VAR cRedspach ITEMS {"C=CIF","F=FOB"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    Else
       	@ 035, 048 MSCOMBOBOX oComboBo1 VAR cRedspach ITEMS {"C=CIF","F=FOB"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    EndIf
    @ 055, 156 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION (oDlg:End())
    @ 055, 200 BUTTON oButton2 PROMPT "Gravar" SIZE 037, 012 OF oDlg PIXEL ACTION GravaRed()

  ACTIVATE MSDIALOG oDlg CENTERED
      
RestArea(_aArea)

Return      


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValTra				 	| 	Junho de 2015  					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Transportadora 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValTra(_cTransp)
Local _aArea	:= GetArea()
Local _aAreaSA4	:= SA4->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SA4")

If(dbSeek(xFilial("SA4")+Alltrim(_cTransp)))
	cGet2 := SA4->A4_NOME	
Else
	cGet2 := ""
	lRet := .F.
EndIf

RestArea(_aAreaSA4)
RestArea(_aArea)

Return lRet             

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GravaRed				 	| 	Junho de 2015  					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Grava Campos da Transportadora Redespacho										|
|-----------------------------------------------------------------------------------------------|
*/

Static Function GravaRed()  

If !Empty(Alltrim(cGetReds)) 
	If Inclui
		lRedEnt := .T. 
	EndIf
EndIf	   

oDlg:End()

Return            

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMA16B			  		| 	Junho de 2015		   		  					    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto Ferraraz Pereira Alves - Anadi								|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Grava informacao de redespacho na entrada		   							  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA16B()            
 
Local _cCdtPdc := ""
Local _cEmisDc := ""
Local _cSerDc  := ""
Local _cNumDc  := ""      
Local _cCdFilial := ""
  
DbSelectArea("GW1")
GW1->(DbSetOrder(11))   
If DbSeek(XFilial("GW1") + Padr(SF1->F1_SERIE,TamSX3("GW1_SERDC")[1]) + Padr(SF1->F1_DOC,TamSX3("F1_DOC")[1]) )                        
	Reclock("GW1", .F.)       
		If SF1->F1_TPFRETE == "C" .And. SF1->F1__TPFRED == "C"
	    	GW1->GW1_TPFRET := "2"   
	 	Else
	    	GW1->GW1_TPFRET := "4"   	 	
	 	EndIf
	    _cCdFilial := GW1->GW1_FILIAL
	    _cCdtPdc :=  GW1->GW1_CDTPDC
		_cEmisDc :=  GW1->GW1_EMISDC
		_cSerDc  :=  GW1->GW1_SERDC
		_cNumDc  :=  GW1->GW1_NRDC
	GW1->(MsUnlock())
EndIf 

DbSelectArea("SA4")
DbSeek(XFilial("SA4") + SF1->F1__TRARED)
_cCnpjTra1 := SA4->A4_CGC

DbSelectArea("GU3")
DbSeek(XFilial("GU3") + _cCnpjTra1)
_cCid1 := GU3->GU3_NRCID
             
DbSelectArea("GWU")
GWU->(DbSetOrder(1)) 
//GWU_FILIAL+GWU_CDTPDC+GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_SEQ 
If DbSeek(XFilial("GWU") + _cCdtPdc + _cEmisDc + _cSerDc + _cNumDc + "01")   
	Reclock("GWU", .F.)
		_cCid2 := GWU->GWU_NRCIDD   
		GWU->GWU_NRCIDD := _cCid1  
		GWU->GWU_PAGAR := IIf(SF1->F1_TPFRETE == "C", "2", "1") 
	GWU->(MsUnlock())
EndIf   

If Reclock("GWU", .T.) 
	GWU->GWU_FILIAL := _cCdFilial 
	GWU->GWU_CDTPDC := _cCdtPdc
	GWU->GWU_EMISDC := _cEmisDc
	GWU->GWU_SERDC  := _cSerDc
	GWU->GWU_NRDC   := _cNumDc
	GWU->GWU_SEQ    := "02"                                
	GWU->GWU_CDTRP  := Posicione("SA4",1, xFilial("SA4")+SF1->F1__TRARED, "A4_CGC") 
	GWU->GWU_NRCIDD := _cCid2
	GWU->GWU_PAGAR := IIf(SF1->F1__TPFRED == "C", "2", "1")  
	GWU->(MsUnlock())                                       
EndIf
	
Return          
