#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATR11				 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Relat�rio de Vendas de Promo��es                                                |
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATR11()

Local _aArea := GetArea()

Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8

Local aPergs			:= {}

Private nTipo 			:= 1
Private nRel			:= 1
Private lConsol      	:= 1

Private dDt1Ini := dDt1Fim := dDt2Ini := dDt2Fim	:= CtoD(Space(8))
Private lQuebra := .f.

Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}

Private cEmpr		:= Space( avSx3("ZE_CODFIL" ,3) ) //SM0->M0_CODIGO
Private cEmprDesc 	:= Space( avSx3("ZE_NOMECOM",3) ) //SM0->M0_FILIAL
Private cIdenIni	:= Space( avSx3("Z9_COD"    ,3) )
Private cIdenFim 	:= Space( avSx3("Z9_COD"    ,3) )
Private cMarcaIni	:= Space( avSx3("Z5_CODIGO" ,3) )
Private cMarcaFim 	:= Space( avSx3("Z5_CODIGO" ,3) )
Private cProdIni	:= Space( avSx3("B1_COD"    ,3) )
Private cProdFim 	:= Space( avSx3("B1_COD"    ,3) )
Private cSegmento	:= Space( avSx3("B1__SEGISP",3) )
Private cSegDesc	:= Space( avSx3("Z7_DESCRIC",3) )

Private oEmpr, oEmprDesc, oProdIni, oProdFim, oSegmento, oSegDesc, oProd1Desc, oProd2Desc, oRadSub, oIdenIni, oIdenFim, oRadSub2, oMarcaIni, oMarcaFim
Private oDt1Ini, oDt1Fim, oDt2Ini, Dt2Fim, oChkQuebra, oChkConsol, oButProc

Private cPerg		:= PADR("IFATR11",Len(SX1->X1_GRUPO))
Private aSx1		:= {}

Private oButSub
Private cTitButSub	:= "Identifica��o"

aSize 				:= MsAdvSize()

aObjects 			:= {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo				:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj 			:= MsObjSize(aInfo, aObjects)

nLinSay 			:= aPosObj[1,1] + 6
nLinGet 			:= aPosObj[1,1] + 4

aPosGet 			:= MsObjGetPos(aSize[3]-aSize[1],315,{{008,025,060,73,137}})


//                  1             	  2  3    4      5   6 						 7 8  9  10     11     12 13 14 15 16 17 18 19 20 21 22 23 24 25        						 36
Aadd(aPergs,{"Local				"	,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Produto de    	"	,"","","mv_ch2","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Produto at�   	"	,"","","mv_ch3","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Segmento      	"  	,"","","mv_ch4","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data de       	"	,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data at�      	"	,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data de       	"	,"","","mv_ch7","D",08						,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data at�      	"	,"","","mv_ch8","D",08						,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Identifica��o de	"	,"","","mv_ch9","C",TamSx3("Z9_COD")[1]		,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Identifica��o at� "	,"","","mv_chA","C",TamSx3("Z9_COD")[1]		,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Marca de    		"	,"","","mv_chB","C",TamSx3("Z5_CODIGO")[1]	,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Marca at�   		"	,"","","mv_chC","C",TamSx3("Z5_CODIGO")[1]	,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)

cEmpr		:= MV_PAR01
cProdIni	:= MV_PAR02
cProdFim 	:= MV_PAR03
cSegmento	:= MV_PAR04
dDt1Ini		:= MV_PAR05
dDt1Fim		:= MV_PAR06
dDt2Ini		:= MV_PAR07
dDt2Fim		:= MV_PAR08
cIdenIni	:= MV_PAR09
cIdenFim 	:= MV_PAR10
cMarcaIni	:= MV_PAR11
cMarcaFim 	:= MV_PAR12


AtuFil(cEmpr,.f.)
AtuSeg(cSegmento,.f.)

if Empty(dDt1Ini)
	dDt1ini 	:= FirstDay( dDataBase )
Endif

dDt1Fim   := LastDay( dDataBase )

if Empty(dDt2Ini)
	dDt2ini 	:= CtoD( "01/01" + "/" + Str(Year(dDataBase),4) )
Endif

if Empty(dDt2Fim)
	dDt2Fim		:= CtoD( "31/12" + "/" + Str(Year(dDataBase),4) )
Endif

DEFINE MSDIALOG oDlg TITLE "Relat�rio de Vendas de Promo��es" FROM 000, 000  TO 420, 700 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay, aPosGet[1,01] 	SAY      oSay1       PROMPT "Local    "           						SIZE 030, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10	MSGET    oEmpr       VAR cEmpr       	When .t.   						SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"DLB"		Valid AtuFil(cEmpr)
@ nLinGet, aPosGet[1,02]+50 MSGET    oEmprDesc   VAR cEmprDesc   	When .f.   				 		SIZE 100, 008   OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay5       PROMPT "Identifica��o de  "                       	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10 MSGET    oIdenIni    VAR cIdenIni	Picture PesqPict("SZ9","Z9_COD")		SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ8001" 	Valid ValIdent(cIdenIni,1)

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay6       PROMPT "Identifica��o at� "                       	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10 MSGET    oIdenFim    VAR cIdenFim	Picture PesqPict("SZ9","Z9_COD")		SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ8001" 	Valid ValIdent(cIdenFim,2)

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay7       PROMPT "Marca de  "                         			SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10 MSGET    oMarcaIni    VAR cMarcaIni	Picture PesqPict("SZ5","Z5_CODIGO")	SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ5" 	Valid ValMarca(cMarcaIni,1)

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay8       PROMPT "Marca at� "                         			SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10 MSGET    oMarcaFim    VAR cMarcaFim	Picture "@!" 						SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ5" 	Valid ValMarca(cMarcaFim,2)

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay2       PROMPT "Item de  "                         			SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10 MSGET    oProdIni    VAR cProdIni	Picture PesqPict("SB1","B1_COD")		SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SB1" 	Valid ValProd(cProdIni,1)

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay3       PROMPT "Item at� "                         			SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10 MSGET    oProdFim    VAR cProdFim	Picture PesqPict("SB1","B1_COD")		SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SB1" 	Valid ValProd(cProdFim,2)

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] 	SAY      oSay4       PROMPT "Segmento "                          		SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+10	MSGET    oSegmento   VAR cSegmento	Picture PesqPict("SB1","B1__SEGISP")SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ7" 	Valid AtuSeg(cSegmento)
@ nLinGet, aPosGet[1,02]+50 MSGET    oSegDesc    VAR cSegDesc		When .f.    			 		SIZE 100, 008   OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay,aPosGet[1,01]    GROUP   	oGroup1 TO nLinSay+30,aPosGet[1,04] PROMPT "Per�odo 1"   						OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12,aPosGet[1,01]+09 MSGET	oDt1Ini 	  VAR dDt1Ini										SIZE 050, 008	OF oDlg COLORS 	0, 16777215 PIXEL
@ nLinSay+12,aPosGet[1,01]+74 MSGET	oDt1Fim 	  VAR dDt1Fim										SIZE 050, 008	OF oDlg COLORS 	0, 16777215 PIXEL

@ nLinSay,aPosGet[1,04]+1  GROUP	oGroup1 TO nLinSay+30,aPosGet[1,05] PROMPT "Per�odo 2"   						OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12,aPosGet[1,04]+10 MSGET  oDt2Ini 	  VAR dDt2Ini										SIZE 050, 008	OF oDlg COLORS 	0, 16777215 PIXEL
@ nLinSay+12,aPosGet[1,04]+74 MSGET  oDt2Fim 	  VAR dDt2Fim										SIZE 050, 008	OF oDlg COLORS 	0, 16777215 PIXEL

nLinSay += 33
nLinGet += 33

@ nLinSay,   aPosGet[1,01]   GROUP	oGroup1 TO nLinSay+30,aPosGet[1,04] PROMPT "Tipo de Relat�rio"			  		OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+8, aPosGet[1,01]+4 RADIO	oRadSub 	  VAR nTipo   Prompt OemToAnsi("Identifica��o"), OemToAnsi("Marca") SIZE 080, 008 OF oDlg Pixel

@ nLinSay,   aPosGet[1,04]+1   GROUP	oGroup1 TO nLinSay+30,aPosGet[1,05] PROMPT "Relat�rio Por"			  		OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+8, aPosGet[1,04]+4 RADIO	oRadSub2 	  VAR lConsol   Prompt OemToAnsi("Local"), OemToAnsi("Empresa") 	SIZE 080, 008 OF oDlg Pixel

oRadSub:bChange := {|| U_AtuTipo( nTipo ) }

nLinSay += 36
nLinGet += 36

@ nLinSay, aPosGet[1,04]+51  BUTTON   oButProc     PROMPT "Processar"	Action GeraRel()   			   		SIZE 040, 016 OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+93  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  			   		SIZE 040, 016 OF oDlg Pixel

U_AtuTipo( nTipo )

ACTIVATE MSDIALOG oDlg CENTERED

RestArea (_aArea)

Return(.t.)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValProd			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Rotina para preenchimento da tabela PA7 e gera��o do relat�rio em crystal       |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GeraRel()

Local cFilIni	:= ""
Local cFilFim	:= ""
Local cParms	:= ""
Local cQUERY	:= ""
Local xTEMP		:= {}
Local cUseId	:= __cUserId
Local cDescFil	:= ""
Local lRet		:= .T.
Local cLocais	:= formatIN(getMV("MV__ARMVEN"),';')

If Empty(cEmpr) .and. lConsol == 1
	
	MsgAlert("Para o tipo de relat�rio 'LOCAL', favor preencher o campo Local ")
	lRet := .F.

	oEmpr:Setfocus()
	oDlg:Refresh()
	
Else
	
	GravaSx1()
	
	if lConsol == 2
		cFilini		:= "  "
		cFilfim		:= "ZZ"
	Else
		cFilini		:= Alltrim(cEmpr)
		cFilfim		:= Alltrim(cEmpr)
		cDescFil	:= Posicione("SZE",1,cEmpAnt+cFilini,"ZE_FILIAL")
	Endif
	
	IF TcCanOpen(RetSqlName("PA7"))
		cQuery := " DELETE "+RetSqlName("PA7")
		cQuery += " WHERE PA7_USER = '"+cUseId+"' "
		TCSqlExec(cQuery)
	ENDIF
	
	For i:= 1 to 2
		
		//i=1 ano
		//i=2 mes
		
		cQUERY	:= ""
		
		If nTipo == 1 //Identifica��o
			
			cQUERY := "SELECT DISTINCT Z9_COD IDENT, Z8_DESCRI DESCIDEN, Z9_PRODUTO CODPRO, B1_DESC DESCPRO , SUM(D2_QUANT) QTDVEN, SUM(D2_CUSTO1) CUSTOVEN,   SUM(SD2.D2_TOTAL -  SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6) AS PRCVEN "
			cQUERY += "FROM " + RetSqlName("SZ9") + " SZ9 "
			cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = Z9_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
			If i == 1
				cQuery += "LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_COD = Z9_PRODUTO AND D2_FILIAL BETWEEN '" + cFilini + "' AND  '" + cFilfim + "' "
				cQuery += "AND D2_EMISSAO BETWEEN '" + dtos(dDt2ini) + "' AND '" + dtos(dDt2Fim) + "'  AND SD2.D_E_L_E_T_ = ' ' "
			Else
				cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON D2_COD = Z9_PRODUTO AND D2_FILIAL BETWEEN '" + cFilini + "' AND  '" + cFilfim + "' "
				cQuery += "AND D2_EMISSAO BETWEEN '" + dtos(dDt1ini) + "' AND '" + dtos(dDt1Fim) + "'  AND SD2.D_E_L_E_T_ = ' ' "
			EndIf
			cQuery += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON Z8_COD = Z9_COD AND SZ8.D_E_L_E_T_ = ' ' "
			cQUERY += "WHERE Z9_PRODUTO <> '      ' "
			cQUERY += "AND SZ9.D_E_L_E_T_ = ' ' "
			cQUERY += "AND Z9_COD BETWEEN '" + cIdenIni + "' AND '" + cIdenFim + "' "
			cQUERY += "AND Z9_PRODUTO BETWEEN '" + cProdIni + "' AND '" + cProdFim + "' "
			cQUERY += "AND B1__SEGISP = '" + cSegmento + "' "
			cQUERY += "GROUP BY Z9_COD, Z8_DESCRI, Z9_PRODUTO, B1_DESC "
			cQUERY += "ORDER BY Z9_COD, Z9_PRODUTO "
			
		ElseIf nTipo == 2	//Marca
			
			cQUERY := "SELECT DISTINCT Z5_CODIGO MARCA, Z5_DESC DESCMARCA, ACP_CODPRO CODPRO, B1_DESC DESCPRO, SUM(D2_QUANT) QTDVEN, SUM(D2_CUSTO1) CUSTOVEN, SUM(SD2.D2_TOTAL -  SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6) PRCVEN "
			cQUERY += "FROM " + RetSqlName("ACP") + " ACP "
			cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = ACP_CODPRO AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += "INNER JOIN " + RetSqlName("SZ5") + " SZ5 ON Z5_CODIGO = B1__MARCA AND SZ5.D_E_L_E_T_ = ' ' "
			If i == 1
				cQuery += "LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_COD = ACP_CODPRO AND D2_FILIAL BETWEEN '" + cFilini + "' AND  '" + cFilfim + "' "
				cQuery += "AND D2_EMISSAO BETWEEN '" + dtos(dDt2ini) + "' AND '" + dtos(dDt2Fim) + "' AND SD2.D_E_L_E_T_ = ' ' "
			Else
				cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON D2_COD = ACP_CODPRO AND D2_FILIAL BETWEEN '" + cFilini + "' AND  '" + cFilfim + "' "
				cQuery += "AND D2_EMISSAO BETWEEN '" + dtos(dDt1ini) + "' AND '" + dtos(dDt1Fim) + "' AND SD2.D_E_L_E_T_ = ' ' "
			EndIf
			cQuery += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON Z8_COD = Z9_COD AND SZ8.D_E_L_E_T_ = ' ' "
			cQUERY += "WHERE ACP.D_E_L_E_T_ = ' ' "
			cQUERY += "AND Z5_CODIGO BETWEEN '" + cMarcaIni + "' AND '" + cMarcaFim + "' "
			cQUERY += "AND B1__SEGISP = '" + cSegmento + "' "
			cQUERY += "GROUP BY Z5_CODIGO, Z5_DESC, ACP_CODPRO, B1_DESC "
			cQUERY += "ORDER BY Z5_CODIGO, ACP_CODPRO "
			
		EndIf
		
		If Select("xTEMP") > 0
			xTEMP->(dbCloseArea())
		EndIf
		
		cQUERY := ChangeQuery(cQUERY)
		
		TcQuery cQUERY New Alias "xTEMP"
		
		cQUERY	:= ""
		
		dbSelectArea("xTEMP")
		dbGoTop()
		
		While !Eof()
			
			If i == 1
				
				While !RecLock("PA7",.t.)
				Enddo
				PA7->PA7_USER	:= cUseId
				PA7->PA7_LOCAL	:= cFilini
				If lConsol == 1
					PA7->PA7_DECLOC	:= cDescFil
				EndIf
				PA7->PA7_SEGISP	:= cSegmento
				PA7->PA7_DESCSE	:= Posicione("SZ7",1,xFilial("SZ7")+cSegmento,"Z7_DESCRIC")
				PA7->PA7_CODPRO	:= xTEMP->CODPRO
				PA7->PA7_DESCR	:= xTEMP->DESCPRO
				If nTipo == 1 //Identifica��o
					PA7->PA7_IDENT	:= xTEMP->IDENT
					PA7->PA7_VAR		:= xTEMP->IDENT
					PA7->PA7_DESCVAR	:= xTEMP->DESCIDEN
				ElseIf nTipo == 2 //Marca
					PA7->PA7_MARCA	:= xTEMP->MARCA
					PA7->PA7_VAR		:= xTEMP->MARCA
					PA7->PA7_DESCVAR	:= xTEMP->DESCMARCA
				EndIf
				PA7->PA7_VENMES := 0
				PA7->PA7_VENANO	:= xTEMP->QTDVEN
				
				MsUnLock()
				
			Else
				
				If nTipo == 1 //Identifica��o
					
					dbSelectArea("PA7")
					dbSetOrder(1)//FILIAL + USER + LOCAL + IDENT + PRODUTO
					if dbSeek(xFilial("PA7")+cUseId+cFilini+xTEMP->IDENT+xTEMP->CODPRO)
						While !RecLock("PA7",.f.)
						Enddo
						PA7->PA7_VENMES  := xTEMP->QTDVEN
						PA7->PA7_CUSVEN := xTEMP->CUSTOVEN
						PA7->PA7_VALVEN := xTEMP->PRCVEN
						PA7->PA7_LB	 	:= IIf(!Empty(xTEMP->CUSTOVEN), ( 100 - (xTEMP->CUSTOVEN / xTEMP->PRCVEN * 100) ),0)				
						MsUnLock()
					EndIf
					
				ElseIf nTipo == 2 	//Marca
					
					dbSelectArea("PA7")
					dbSetOrder(2)//FILIAL + USER + LOCAL + MARCA + PRODUTO
					if dbSeek(xFilial("PA7")+cUseId+cFilini+xTEMP->MARCA+xTEMP->CODPRO)
						While !RecLock("PA7",.f.)
						Enddo
						PA7->PA7_VENMES  := xTEMP->QTDVEN
						PA7->PA7_CUSVEN := xTEMP->CUSTOVEN
						PA7->PA7_VALVEN := xTEMP->PRCVEN
						PA7->PA7_LB	 	:= IIf(!Empty(xTEMP->CUSTOVEN), ( 100 - (xTEMP->CUSTOVEN / xTEMP->PRCVEN * 100) ),0)				
						MsUnLock()
					EndIf
					
				EndIf
				
			EndIf
			
			DbSelectArea("xTEMP")
			DbSkip()
			
		EndDo
		
	Next
	
	dbSelectArea("PA7")
	dbSetOrder(1)
	if dbSeek(xFilial("PA7")+cUseId)
		
		While !Eof() .and. PA7->PA7_USER == cUseId
			
			cQry := "SELECT SUM(B2_QATU) QATU, SUM(B2_CM1 * B2_QATU) CM1  "
			cQry += "FROM " + retSqlName("SB2") + " SB2 "
			cQry += "WHERE B2_FILIAL BETWEEN '" + cFilini + "' AND  '" + cFilfim + "' "
			cQry += "AND B2_COD = '" + PA7->PA7_CODPRO + "' "
			cQry += "AND B2_LOCAL IN " + cLocais + " "
			cQry += "AND SB2.D_E_L_E_T_ = ' ' "
			
			cQry := ChangeQuery(cQry)
			
			If Select("xTRB") > 0
				xTRB->(dbCloseArea())
			EndIf
			
			TcQuery cQry New Alias "xTRB"
			
			dbSelectArea("xTRB")
			dbGoTop()
			
			If !(Empty(xTRB->QATU))
				While !RecLock("PA7",.f.)
				Enddo
				PA7->PA7_QTDEST	:= xTRB->QATU
				PA7->PA7_VALEST := xTRB->CM1
				MsUnLock()
			EndIf
			
			DbSelectArea("PA7")
			DbSkip()
			
		EndDo
		
	EndIf
	
	cParms := cUseId	 			+ ";"
	cParms += Alltrim(Str(nTipo)) 	+ ";"
	cParms += DtoS(dDt1Ini)			+ ";"
	cParms += DtoS(dDt1Fim)			+ ";"
	cParms += DtoS(dDt2Ini)			+ ";"
	cParms += DtoS(dDt2Fim)
	
	x:="1;0;1;IFATCR11"
	
	CallCrys("IFATCR11",cParms, x)
	
	If Select("xTEMP") > 0
		xTEMP->(dbCloseArea())
	EndIf
	
	If Select("xTRB") > 0
		xTRB->(dbCloseArea())
	EndIf
	
EndIf

Return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GravaSX1			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Grava valores na SX1                                                            |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GravaSx1()

Local nX := 1

aAdd( aSx1, {cEmpr, cProdIni, cProdFim, cSegmento, DtoS(dDt1Ini), DtoS(dDt1Fim), DtoS(dDt2Ini), DtoS(dDt2Fim), cIdenIni, cIdenFim, cMarcaIni, cMarcaFim} )

Dbselectarea("SX1")
DbsetOrder(1)
If Dbseek(cPerg+"01")
	Do While ( !(Eof()) .AND. SX1->X1_GRUPO == cPerg )
		Reclock("SX1",.F.)
		SX1->X1_CNT01:= aSX1[1][nX]
		SX1->(MsUnlock())
		nX++
		DbSkip()
	EndDo
EndIf

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValProd			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Valida exist�ncia do produto                                                    |
|-----------------------------------------------------------------------------------------------|
*/


static function ValProd(_cItem,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cItem) .and. _nSt == 2
	
	cProdFim := "ZZZZZZZZZZZZZZZ"
	oProdFim:Refresh()
	
Else
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SB1")+_cItem) .and. !empty(_cItem)
		msgAlert ("�tem n�o encontrado no cadastro de Produtos !!")
		lRet := .F.
	endif
	
EndIf

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValIdent			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Valida exist�ncia da identifica��o                                              |
|-----------------------------------------------------------------------------------------------|
*/


static function ValIdent(_cIdent,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cIdent) .and. _nSt == 2
	
	cIdenFim := "ZZZZZZ"
	oIdenFim:Refresh()
	
Else
	
	dbSelectArea("SZ8")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ8")+_cIdent) .and. !empty(_cIdent)
		msgAlert ("Identifica��o Inv�lida !!")
		lRet := .F.
	endif
	
EndIf

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValMarca			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Valida exist�ncia da Marca                                                      |
|-----------------------------------------------------------------------------------------------|
*/


static function ValMarca(_cMarca, _nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cMarca) .and. _nSt == 2
	
	cMarcaFim := "ZZZZ"
	oMarcaFim:Refresh()
		
Else
	
	dbSelectArea("SZ5")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ5")+_cMarca) .and. !empty(_cMarca)
		msgAlert ("Marca Inv�lida !!")
		lRet	:= .F.
	endif
	
EndIf

return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuTipo			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Bloqueio dos campos de marca ou identifica��o                                   |
|-----------------------------------------------------------------------------------------------|
*/

User Function AtuTipo(PTipo)

if PTipo == 1 //Identifica��o
	
	oIdenIni:lActive	:= .t.
	oIdenFim:lActive	:= .t.
	
	oMarcaIni:lActive	:= .f.
	oMarcaFim:lActive	:= .f.
	
	cMarcaIni	:= Space( avSx3("Z5_CODIGO" ,3) )
	cMarcaFim 	:= Space( avSx3("Z5_CODIGO" ,3) )
	
	oMarcaIni:Refresh()
	oMarcaFim:Refresh()
	
Elseif PTipo == 2 //Marca
	
	oIdenIni:lActive	:= .f.
	oIdenFim:lActive	:= .f.
	
	oMarcaIni:lActive	:= .t.
	oMarcaFim:lActive	:= .t.
	
	cIdenIni	:= Space( avSx3("Z9_COD"    ,3) )
	cIdenFim	:= Space( avSx3("Z9_COD"    ,3) )
	
	oIdenIni:Refresh()
	oIdenFim:Refresh()
	
Endif

oEmpr:Setfocus()
oDlg:Refresh()

Return(.t.)

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuFil			 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Atualiza descri��o da Filial                                                |
|-----------------------------------------------------------------------------------------------|
*/


Static Function AtuFil(PFilial, PlAtuTela)

Local lRet	:= .T.

if SM0->( dbSeek( cEmpAnt + PFilial ) )
	cEmprDesc := SM0->M0_FILIAL
Else
	If !(Empty(PFilial))
		MsgAlert("Filial inv�lida","PARAMETROS INVALIDOS")
		lRet	:= .F.
	Else
		cEmprDesc := Space( avSx3("ZE_NOMECOM",3) )
	EndIf
Endif

if PlAtuTela
	oEmprDesc:cCaption 	:= cEmprDesc
	oEmprDesc:Refresh()
Endif

Return(lRet)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Atualiza descri��o do Segmento                                                |
|-----------------------------------------------------------------------------------------------|
*/


Static Function AtuSeg(PSeg, PlAtuTela)

Local lRet	:= .T.

SZ7->(dbSetOrder(1))

IF SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) )
	If !(Empty(PSeg))
		cSegDesc := SZ7->Z7_DESCRIC
	Else
		cSegDesc := Space( avSx3("B1__SEGISP",3) )	
	EndIf
Else
	MsgAlert("Segmento inv�lido","PARAMETROS INVALIDOS")
	lRet	:= .F.
EndIf

if PlAtuTela
	oSegDesc:cCaption := cSegDesc
	oSegDesc:Refresh()
Endif

Return(lRet)
