#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | IFINA13 | Autor | Rubens Cruz	- Anadi Soluções   	 | Data | Fevereiro/2015 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Tela de cadastro de parametros para remessa bancária						     |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
*/

User Function IFINA13()
Local _aStru 	:= {030,110,150,180}
Local _nLinha	:= _nLinAux := 117 
Local aEdit		:= {"A6__PRIORI","A6__PERC"}
Local aHeaderB	:= {}
Local aColsB	:= {}
Local nAlt		:= 0
Local nLarg		:= 0

Private oOcor, oCliP1, oCliP2, oCliNP1, oCliNP2, oProt, oDesOco, oDesP1, oDesP2

Private oDlgSA6
Private oGetTM1  
Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
Private cOcor		:= Space(TAMSX3("A6__OCORR")[1])
Private cCliP1 		:= Space(TAMSX3("A6__INSTPR")[1])
Private cCliP2		:= Space(TAMSX3("A6__INSTSE")[1])
Private cDesP1 		:= Space(80)
Private cDesP2		:= Space(80)
Private cCliNP1		:= ""
Private cCliNP2		:= ""
Private cDesOco		:= ""
Private nProt		:= 0
Private _nRecAtu	:= 0
                
aHeaderB := CriaHeader({"A6_COD","A6_NREDUZ","A6_AGENCIA","A6_NUMCON","A6__PRIORI","A6__PERC"})
aColsB	 := CriaCols(aHeaderB)

	DEFINE MSDIALOG oDlgSA6 TITLE "Parametros para Remessa Bancária" From 000,000 To 480,680 OF oMainWnd PIXEL
	nAlt  := (oDlgSA6:nClientHeight / 2) - 031
	nLarg := (oDlgSA6:nClientWidth  / 2) - 010

	oGetTM1 := MsNewGetDados():New(010,010,_nLinha-5,nLarg-3, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgSA6, aHeaderB, aColsB)
	oGetTM1:bChange  := {|| AtuBco() }

	_nLinha += 14

	@ _nLinha,_aStru[1] Say "Ocorrencia de Remessa"   	SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[3] MSGet oOcor   Var cOcor			SIZE 020,010 of oDlgSA6 PIXEL FONT oFont F3 "10E" VALID ValCpo("cOcor")
	@ _nLinha,_aStru[4] MSGet oDesOco Var cDesOco  		SIZE 080,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14
	
	@ _nLinha,_aStru[1] Say "Cliente Protestavel:"   	SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] Say "Instrução 1"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[3] MSGet oCliP1  Var cCliP1	  	SIZE 020,010 of oDlgSA6 PIXEL FONT oFont F3 "INST11" VALID ValCpo("cCliP1") PICTURE "@!"
	@ _nLinha,_aStru[4] MSGet oDesP1 Var cDesP1	  		SIZE 080,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14

	@ _nLinha,_aStru[2] Say "Instrução 2"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[3] MSGet oCliP2  Var cCliP2		SIZE 020,010 of oDlgSA6 PIXEL FONT oFont F3 "INST11" VALID ValCpo("cCliP2") PICTURE "@!"
	@ _nLinha,_aStru[4] MSGet oDesP2 Var cDesP2  		SIZE 080,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14
	
	@ _nLinha,_aStru[1] Say "Cliente Não Protestavel:"  SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] Say "Instrução 1"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[3] MSGet oCliNP1  Var cCliNP1	  	SIZE 025,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	@ _nLinha,_aStru[4] MSGet "  "	  					SIZE 080,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14

	@ _nLinha,_aStru[2] Say "Instrução 2"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[3] MSGet oCliNP2  Var cCliNP2	  	SIZE 025,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	@ _nLinha,_aStru[4] MSGet "  "	  					SIZE 080,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14

	@ _nLinha,_aStru[1] Say "Dias para Protesto"		SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[3] MSGet oProt  Var nProt	  		SIZE 025,010 of oDlgSA6 PIXEL FONT oFont PICTURE "@E 999"
	_nLinha += 16

    @ _nLinAux,006 TO _nLinha, nLarg PROMPT "Banco Selecionado" OF oDlgSA6 COLOR 0, 16777215 PIXEL

	@ nAlt,nLarg-050 Button oButton PROMPT "Confirmar" 	SIZE 040,012   OF oDlgSA6 PIXEL ACTION (AtuBco(),IFINA13A())
		
	ACTIVATE MSDIALOG oDlgSA6 CENTERED                                                                                
	
Return                       

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | IFINA13A | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Gravacao dos dados da rotina acima				 						      |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function IFINA13A()                                               
Local nTotal	:= 0
Local nA6Prior 	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6__PRIORI" 	}) 
Local nA6Perc 	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6__PERC" 	}) 
Local nPRecno 	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6_REC_WT" 	}) 
    
//Verifica se o total das porcentagens não ultrapasse 100%
For nX := 1 To Len(oGetTM1:aCols)
	nTotal += oGetTM1:aCols[nX][nA6Perc]
Next nX

If nTotal > 100
	Alert("Percentual total maior que 100%")
	Return
EndIf                    

DbSelectArea("SA6")

For nX := 1 To Len(oGetTM1:aCols)
	DbGoTo(oGetTM1:aCols[nX][nPRecno])
	RecLock("SA6",.F.)
		SA6->A6__PRIORI := oGetTM1:aCols[nX][nA6Prior]
		SA6->A6__PERC	:= oGetTM1:aCols[nX][nA6Perc]	
	MsUnlock()
Next nX

oDlgSA6:End()

Return
        
/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | ValCpo	| Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Valida se a ocorrencia informada é valida									  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
| Parametros | _cOcor = Numero da ocorrencia												  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function ValCpo(_cCpo) 
Local lRet := .F.

Do Case
	Case _cCpo == "cOcor"
		DbSelectAreA("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+"10"+&(_cCpo)+"E")
			cDesOco := SX5->X5_DESCRI
			lRet := .T.
		ElseIf(Empty(&(_cCpo)))
			cDesOco := ""
			lRet := .T.
		EndIf
	Case _cCpo == "cCliP1" 
		DbSelectAreA("ZX5")
		DbSetOrder(1)
		If DbSeek(xFilial("ZX5")+"  "+"000011"+&(_cCpo))
			cDesP1 := ZX5->ZX5_DSCITE
			lRet := .T.
		ElseIf(Empty(&(_cCpo)))
			cDesP1 := ""
			lRet := .T.
		EndIf
	Case _cCpo == "cCliP2" 
		DbSelectAreA("ZX5")
		DbSetOrder(1)
		If DbSeek(xFilial("ZX5")+"  "+"000011"+&(_cCpo))
			cDesP2 := ZX5->ZX5_DSCITE
			lRet := .T.
		ElseIf(Empty(&(_cCpo)))
			cDesP2 := ""
			lRet := .T.
		EndIf
EndCase

Return lRet

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | AtuBco	| Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Grava dados na SA6 quando trocar de linha no aCols e carrega novas informações |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function AtuBco()
Local _aArea := GetArea()
Local _aAreaSA6 := SA6->(GetArea())
Local nPRecno 	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6_REC_WT" 	}) 


DbSelectArea("SA6")
DbGoTo(_nRecAtu)
RecLock("SA6",.F.)
	SA6->A6__OCORR  := cOcor
	SA6->A6__INSTPR := cCliP1
	SA6->A6__INSTSE := cCliP2            
	SA6->A6__DIAPRO := nProt
MsUnlock()	

DbSelectArea("SA6")
DbGoTo(oGetTM1:aCols[oGetTM1:nAt][nPRecno])
cOcor 		:= SA6->A6__OCORR
cCliP1 		:= SA6->A6__INSTPR
cCliP2 		:= SA6->A6__INSTSE 
nProt		:= SA6->A6__DIAPRO
_nRecAtu	:= oGetTM1:aCols[oGetTM1:nAt][nPRecno]

DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+"10"+cOcor+"E")
	cDesOco := SX5->X5_DESCRI
Else
	cDesOco := " "
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5")+"  "+"000011"+cCliP1)
	cDesP1 := ZX5->ZX5_DSCITE
Else
	cDesP1 := " "
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5")+"  "+"000011"+cCliP2)
	cDesP2 := ZX5->ZX5_DSCITE
Else
	cDesP2 := " "
EndIf

oOcor:Refresh()
oCliP1:Refresh()
oCliP2:Refresh()
oCliNP1:Refresh()
oCliNP2:Refresh()
oProt:Refresh()  
oDesOco:Refresh()
oDesP1:Refresh()
oDesP2:Refresh()
oDlgSA6:Refresh()

RestArea(_aArea)
RestArea(_aAreaSA6)

Return .T.

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Fevereiro de 2015				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader(aCpoHeader)
Local aHeaderB      := {}

For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_F3		    ,;
		SX3->X3_Context})
	Endif
Next _nElemHead
dbSelectArea("SX3")
dbSetOrder(1)

AADD( aHeaderB, { "Recno WT", "A6_REC_WT", "", 09, 0,,, "N", "SA6", "V"} )


Return aHeaderB 

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | CriaCols | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Tela de cadastro de parametros para remessa bancária						      |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function CriaCols(aHeaderB)  
Local   n			:= 0                 
Local	nA6Cod 		:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_COD"		}) 
Local	nA6Nreduz 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_NREDUZ" 	}) 
Local	nA6Agenc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_AGENCIA" 	}) 
Local	nA6Conta 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_NUMCON" 	}) 
Local	nA6Prior 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6__PRIORI" 	}) 
Local	nA6Perc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6__PERC" 	}) 
Local	nPRecno 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_REC_WT" 	}) 
Local	nQtdCpo 	:= Len(aHeaderB)
Local	aColsB		:= {}
             
	If(select("TRB_TMP") > 0)
		TRB_TMP->(DbCloseArea())
	EndIf     
	
		aColsB := {}

	    _cQuery := "SELECT SA6.A6_COD,                                                         				" + Chr(13)
	    _cQuery += "       SA6.A6_NREDUZ,                                                      				" + Chr(13)
	    _cQuery += "       SA6.A6_AGENCIA,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6_NUMCON,                                                      				" + Chr(13)
	    _cQuery += "       SA6.A6__PRIORI,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6__PERC,	                                                   				" + Chr(13)
	    _cQuery += "       SA6.A6__OCORR,	                                                   				" + Chr(13)
	    _cQuery += "       SA6.A6__INSTPR,	                                                   				" + Chr(13)
	    _cQuery += "       SA6.A6__INSTSE,	                                                   				" + Chr(13)
	    _cQuery += "       SA6.A6__DIAPRO,	                                                   				" + Chr(13)
	    _cQuery += "       NVL(ZX5A.ZX5_DSCITE,' ') AS DESCPR,                                           	" + Chr(13)
	    _cQuery += "       NVL(ZX5B.ZX5_DSCITE,' ') AS DESCSE,                                           	" + Chr(13)
	    _cQuery += "       NVL(SX5C.X5_DESCRI,' ') AS DESCOCO,                                           	" + Chr(13)
	    _cQuery += "       SA6.R_E_C_N_O_ AS RECSA6                                            				" + Chr(13)
	    _cQuery += "FROM " + RetSqlName("SA6") + " SA6                                         				" + Chr(13)
	    _cQuery += "LEFT JOIN " + RetSqlName("ZX5") + " ZX5A ON ZX5A.ZX5_FILIAL = '" + xFilial("ZX5") + "'	" + Chr(13)
	    _cQuery += "                         AND ZX5A.ZX5_GRUPO = '000011'                  	            " + Chr(13)
	    _cQuery += "                         AND ZX5A.ZX5_CODIGO = SA6.A6__INSTPR         	    	        " + Chr(13)
	    _cQuery += "                         AND ZX5A.D_E_L_E_T_ = ' '                              	    " + Chr(13)
	    _cQuery += "LEFT JOIN " + RetSqlName("ZX5") + " ZX5B ON ZX5B.ZX5_FILIAL = '" + xFilial("ZX5") + "' 	" + Chr(13)
	    _cQuery += "                         AND ZX5B.ZX5_GRUPO = '000011'                                 	" + Chr(13)
	    _cQuery += "                         AND ZX5B.ZX5_CODIGO = SA6.A6__INSTSE                         	" + Chr(13)
	    _cQuery += "                         AND ZX5B.D_E_L_E_T_ = ' '                                  	" + Chr(13)
	    _cQuery += "LEFT JOIN " + RetSqlName("SX5") + " SX5C ON SX5C.X5_FILIAL = '" + xFilial("SX5") + "'  	" + Chr(13)
	    _cQuery += "                         AND SX5C.X5_TABELA = '10'                                  	" + Chr(13)
	    _cQuery += "                         AND SX5C.X5_CHAVE = SA6.A6__OCORR || 'E'                      	" + Chr(13)
	    _cQuery += "                         AND SX5C.D_E_L_E_T_ = ' '                                  	" + Chr(13)
	    _cQuery += "WHERE SA6.D_E_L_E_T_ = ' '                                                 				" + Chr(13)
	    _cQuery += "      AND A6__REMESS = '1'   															" + Chr(13)
	    _cQuery += "ORDER BY A6_COD ASC																		"
		TcQuery _cQuery New Alias "TRB_TMP"                                                          
		
		If(Empty(TRB_TMP->A6_COD))                        
			n++
	      	AAdd(aColsB, Array(nQtdCpo+1))
	
			aColsB[n][nA6Cod] 	 		:= " "
			aColsB[n][nA6Nreduz] 	 	:= " "
			aColsB[n][nA6Agenc] 	 	:= " "
			aColsB[n][nA6Conta] 	 	:= " "
			aColsB[n][nA6Prior] 	 	:= 0
			aColsB[n][nA6Perc]	 	 	:= 0
			aColsB[n][nPRecno]	 	 	:= 0
			aColsB[n][nQtdCpo+1]		:= .F.
		Else		

			cOcor		:= TRB_TMP->A6__OCORR
			cDesOco		:= TRB_TMP->DESCOCO
			cCliP1		:= TRB_TMP->A6__INSTPR
			cDesP1		:= TRB_TMP->DESCPR
			cCliP2		:= TRB_TMP->A6__INSTSE
			cDesP2		:= TRB_TMP->DESCSE
			nProt		:= TRB_TMP->A6__DIAPRO
			_nRecAtu 	:= TRB_TMP->RECSA6

			DbSelectArea("TRB_TMP")
			While !(eof())
				n++    
		      	AAdd(AcolsB, Array(nQtdCpo+1))
		
				aColsB[n][nA6Cod] 	 		:= TRB_TMP->A6_COD
				aColsB[n][nA6Nreduz] 	 	:= TRB_TMP->A6_NREDUZ
				aColsB[n][nA6Agenc] 	 	:= TRB_TMP->A6_AGENCIA
				aColsB[n][nA6Conta] 	 	:= TRB_TMP->A6_NUMCON
				aColsB[n][nA6Prior] 	 	:= TRB_TMP->A6__PRIORI
				aColsB[n][nA6Perc]	 	 	:= TRB_TMP->A6__PERC
				aColsB[n][nPRecno]	 	 	:= TRB_TMP->RECSA6
				aColsB[n][nQtdCpo+1]		:= .F.
						   	  	     
				DbSkip()
			EndDo
		EndIf
	
	 	TRB_TMP->(dbCloseArea())

Return aColsB