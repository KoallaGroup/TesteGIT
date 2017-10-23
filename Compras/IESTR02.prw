#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IESTR02				 	| 	Abril de 2015	                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi                                                        |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela de chamada do relatório de Compras Por Exportador                          |
|-----------------------------------------------------------------------------------------------|
*/

User Function IESTR02()
Local aStru 	:= {{010,060,100},;
					{130,170},;
					{230,280}}
Local aStru2	:= {{040,070,130},;
					{200,230,290}} 
Local _nLinha	:= 010 
Local _nLin2	:= 010
Local nAlt		:= 0
Local nLarg		:= 0                                                                                                   


Private oDlgTMP
Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
Private oFont24		:= tFont():New("Tahoma",,-24,,.t.)
Private _cFornDe	:= Space(TamSX3("A2_COD")[1])                                                                          
Private _cFornAte	:= Space(TamSX3("A2_COD")[1])
Private _dPedDe		:= CTOD("  /  /    ")
Private _dPedAte	:= CTOD("  /  /    ")
Private _cSubDe		:= Space(TamSX3("Z4_CODIGO")[1])
Private _cSubAte	:= Space(TamSX3("Z4_CODIGO")[1])
Private _cSeg		:= U_SETSEGTO() //Space(TamSX3("Z7_CODIGO")[1])
Private _cNmSeg		:= Posicione("SZ7",1,xFilial("SZ7")+_cSeg,"Z7_DESCRIC")
Private _cKit		:= Space(TamSX3("U1_CODACE")[1])
Private _cNmKit		:= ""
Private _dMesDe		:= CTOD("  /  /    ")
Private _dMesAte	:= CTOD("  /  /    ")
Private _dAnoDe		:= CTOD("  /  /    ")
Private _dAnoAte	:= CTOD("  /  /    ")
Private lChk1		:= .F.


DEFINE MSDIALOG oDlgTMP TITLE "Compras por Exportador" From 000,000 To 370,650 OF oMainWnd PIXEL
nAlt  := (oDlgTMP:nClientHeight / 2) - 35
nLarg := (oDlgTMP:nClientWidth  / 2) - 10

@ _nLinha,aStru[1][1] Say "Fornecedor De"   	SIZE 060,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[1][2] MsGet _cFornDe 			SIZE 060,10 of oDlgTMP PIXEL FONT oFont F3 "SA2"
@ _nLinha,aStru[2][1] Say "Emissão De"   		SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[2][2] MsGet _dPedDe 			SIZE 055,10 of oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[3][1] Say "SubGrupo De"   		SIZE 060,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[3][2] MsGet _cSubDe 			SIZE 030,10 of oDlgTMP PIXEL FONT oFont F3 "SZ4"
_nLinha += 16
	
@ _nLinha,aStru[1][1] Say "Fornecedor Até"		SIZE 060,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[1][2] MsGet _cFornAte 			SIZE 060,10 of oDlgTMP PIXEL FONT oFont F3 "SA2"
@ _nLinha,aStru[2][1] Say "Emissão Até"			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[2][2] MsGet _dPedAte 			SIZE 055,10 of oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[3][1] Say "SubGrupo Até"		SIZE 060,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[3][2] MsGet _cSubAte 			SIZE 030,10 of oDlgTMP PIXEL FONT oFont F3 "SZ4" 
_nLin2 := _nLinha += 32    

@ _nLinha,aStru2[1][1] Say "Mes De"				SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru2[1][2] MsGet _dMesDe 			SIZE 055,10 of oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru2[2][1] Say "Ano De"				SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru2[2][2] MsGet _dAnoDe 			SIZE 055,10 of oDlgTMP PIXEL FONT oFont 
_nLinha += 16    
	
@ _nLinha,aStru2[1][1] Say "Mes Ate"			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru2[1][2] MsGet _dMesAte 			SIZE 055,10 of oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru2[2][1] Say "Ano Ate"			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru2[2][2] MsGet _dAnoAte 			SIZE 055,10 of oDlgTMP PIXEL FONT oFont 
_nLinha += 16    

@ _nLin2-10,aStru2[1][1]-5 TO _nLinha,aStru2[1][3] PROMPT "Período Mês" OF oDlgTMP COLOR CLR_RED PIXEL
@ _nLin2-10,aStru2[2][1]-5 TO _nLinha,aStru2[2][3] PROMPT "Período Ano" OF oDlgTMP COLOR CLR_RED PIXEL
_nLinha += 16    

@ _nLinha,aStru[1][1] Say "Segmento"			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[1][2] MsGet _cSeg	 			SIZE 030,10 of oDlgTMP PIXEL FONT oFont F3 "SZ71" VALID (ValSeg(_cSeg))
@ _nLinha,aStru[1][3] MsGet _cNmSeg				SIZE 055,10 of oDlgTMP PIXEL FONT oFont WHEN .F.
_nLinha += 16    

@ _nLinha,aStru[1][1] Say "Kit"					SIZE 040,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[1][2] MsGet _cKit	 			SIZE 020,10 of oDlgTMP PIXEL FONT oFont F3 "SUG_AC" VALID (Valkit(_cKit))
@ _nLinha,aStru[1][3] MsGet _cNmKit				SIZE 155,10 of oDlgTMP PIXEL FONT oFont WHEN .F.
_nLinha += 16    

@ nAlt,(nLarg-090) Button oButton PROMPT "Confirmar"  	SIZE 40,15   OF oDlgTMP PIXEL ACTION GeraCrys()
@ nAlt,(nLarg-040) Button oButton PROMPT "Fechar"  		SIZE 40,15   OF oDlgTMP PIXEL ACTION oDlgTMP:End()
_nLinha += 10    

@ _nLinha,aStru[1][1] CheckBox oChkMar1 Var lChk1  Prompt "Ordenar Curva ABC" Size 075,007 Of oDlgTMP PIXEL 

		
ACTIVATE MSDIALOG oDlgTMP CENTERED                                                                                

Return  

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValSeg				 	| 	Abril de 2015	                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi                                                        |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida segmento digitado e preenche descrição			                        |
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValSeg(_cSeg)
Local _aArea 	:= getArea()
Local _aAreaSZ7 := SZ7->(getArea())
Local _lRet  	:= .T.

If !Empty(_cSeg)
	dbSelectArea("SZ7")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ7")+_cSeg)
		_cNmSeg := SZ7->Z7_DESCRIC
	Else
		msgAlert("Segmento não cadastrado")
		_lRet := .F.
	endif  
Else
	_cNmSeg := ""
EndIf

restarea(_aAreaSZ7)
restarea(_aArea)

oDlgTMP:Refresh()

return _lRet
                  

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValKit				 	| 	Abril de 2015	                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi                                                        |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida Kit digitado e preenche descrição			                        	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValKit(_cKit)
Local _aArea 	:= getArea()
Local _aAreaSUG := SUG->(getArea())
Local _aAreaSB1 := SB1->(getArea())
Local _lRet  	:= .T.

If !Empty(_cKit)
	dbSelectArea("SUG")
	dbSetOrder(2)
	if dbSeek(xFilial("SUG")+_cKit)
		dbSelectArea("SB1")
		dbSetOrder(1)
		if dbSeek(xFilial("SB1")+SUG->UG_PRODUTO)
			_cNmKit := SB1->B1_DESC
		Else
			msgAlert("Produto não cadastrado")
		EndIf
	Else
		msgAlert("Kit não cadastrado")
		_lRet := .F.
	endif  
Else
	_cNmKit := ""
EndIf

restarea(_aAreaSB1)
restarea(_aAreaSUG)
restarea(_aArea)

oDlgTMP:Refresh()

return _lRet                                                                          

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GeraCrys				 	| 	Abril de 2015	                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi                                                        |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Faz a chamada 			                        	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function GeraCrys()
Local cOptions 	:= "1;0;1;Resumo de Vendas de Representantes Acumulado"
Local cParams	:= ""	
Local _cCurva	:= IIF(lChk1,'ORDER BY TOTAL DESC','')
Local lSubGrp	:= !( Empty(_cSubDe) .AND. Empty(_cSubAte) )   
Local lKit		:= !(Empty(_cKit))

cParams := _cFornDe 		+ ";"		//Fornecedor De
cParams += _cFornAte 		+ ";" 		//Fornecedor Ate
cParams += DTOS(_dPedDe)	+ ";" 		//Emissao De
cParams += DTOS(_dPedAte)	+ ";" 		//Emissao Ate
cParams += DTOS(_dMesDe)	+ ";"		//Mes De
cParams += DTOS(_dMesAte)	+ ";"		//Mes Ate
cParams += DTOS(_dAnoDe)	+ ";"		//Ano De
cParams += DTOS(_dAnoAte)	+ ";"		//Ano Ate
cParams += _cSeg 			+ ";"		//Segmento 
If lKit
	cParams += _cKit          	+ ";"		//Codigo Kit
ElseIf lSubGrp
	cParams += _cSubDe          + ";"		//Subgrupo De
	cParams += _cSubAte         + ";"		//Subgrupo Ate
EndIf
cParams += _cCurva			+ ";"		//Curva ABC

If lKit
	CallCrys("IESTCR02B",cParams,cOptions)
ElseIf lSubGrp
	CallCrys("IESTCR02A",cParams,cOptions)
Else
	CallCrys("IESTCR02",cParams,cOptions)
EndIf


Return

