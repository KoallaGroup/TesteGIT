#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06 | Autor: |    Rogério Alves     | Data: |    Julho/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Acionado pelo ponto de entrada MT103FIM para movimentação de       |
|            | valorização para os documentos de entrada                          |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA06(cNota,cSerie,cProd,cItem,cArm,cUm,cForn,cLoja,cTes,nQuant,nVlUnit,nCusto,nValIcm,nValIpi,nValPis,nValCof,nValFre,nIcmInter,cFilEnt,nConFrete)

Local aArea    		:= GetArea()
Local aAreaSM0		:= SM0->(GetArea())
Local cDoc	   		:= ""
Local lTransf		:= .F.
Local lNcm			:= .F.
Local lTes 			:= .F.
Local nMargem		:= 0
Local nAjCusto		:= 0
Local cNcm			:= ""
Local cGrTrib		:= ""
Local _cUF 			:= ""
Local cCgc			:= ""
Local cFilSai		:= ""
Local cObs			:= ""
Local cQUERY		:= ""
Local xTMP			:= {} 
Local lFret			:= .T.
Local lEstSP		:= .F.

//Private lRelIVA		:= .F.

dbSelectArea("SA2")
dbSetOrder(1)
If dbSeek(xFilial("SA2")+cForn+cLoja)

	_cUf	:= SA2->A2_EST
	cCgc	:= SA2->A2_CGC
	
	DbSelectArea("SM0")
	DbGoTop()
	
	While !EOf()
		IF Alltrim(cCgc) == Alltrim(SM0->M0_CGC)
			cFilSai	:= SM0->M0_CODFIL
			lTransf	:= .T.
			Exit
		ENDIF
		DbSkip()
	EndDo
	
	RestArea(aAreaSM0)
	
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cProd)
	cNcm	:= SB1->B1_POSIPI
	cGrTrib	:= SB1->B1_GRTRIB
EndIf

dbSelectArea("SF4")
dbSetOrder(1)
If dbSeek(xFilial("SF4")+cTes)
	IF SF4->F4_SITTRIB $ GETMV("MV__CSTST") //10-30-60-70-90
		lTes := .T.
	EndIf
ENDIF

/*dbSelectArea("SYD")
dbSetOrder(1)
If dbSeek(xFilial("SYD")+cNcm)
	IF SYD->YD__ICMSST == "1"
		lNcm := .T.
	EndIf
ENDIF*/

If !Empty(cGrTrib)
	
	cQUERY := "SELECT DISTINCT F7__MVA "
	cQUERY += "FROM " + RetSqlName("SF7") + " SF7 "
	cQUERY += "WHERE SF7.D_E_L_E_T_ = ' ' "
	cQUERY += "AND F7_FILIAL = '" +xFilial("SF7")+ "' "
	cQUERY += "AND F7_GRPCLI = 'IVA' "
	cQUERY += "AND F7_GRTRIB = '" +cGrTrib+ "' "
	cQUERY += "AND F7_EST = '" +_cUf+ "' "
	
	If Select("xTMP") > 0
		xTMP->(dbCloseArea())
	EndIf
	
	cQUERY := ChangeQuery(cQUERY)
	
	TcQuery cQUERY New Alias "xTMP"
	
	cQUERY	:= ""
	
	dbSelectArea("xTMP")
	dbGoTop()
	
	nMargem := xTMP->F7__MVA
	
	If nMargem > 0
		lNcm := .T.
	EndIf
	
	If Select("xTMP") > 0
		xTMP->(dbCloseArea())
	EndIf
	
EndIf   

If SM0->M0_ESTENT == "SP" 
	lEstSP := .T.
EndIf

If lTransf .And. lEstSP	//Operação de Transferência
	
	nAjCusto := U_ICOMA06C(cNota,cSerie,cProd,cItem,nCusto,nQuant,nValIcm,cFilSai,_cUf,cCgc)
	
	cObs	 := "REQUISIÇÃO REF. AJUSTE DE CUSTO"
	
	U_AcertaCusto(cProd,cUm,cArm,nAjCusto,cNota,cSerie,cForn,cLoja,cItem,cFilEnt,cObs)
	
	lFret := .F. 
	
EndIf

If lTransf .and. lNcm .And. lTes .And. lEstSP	 //Operação de Transferência com IVA
	
	nCusto 	:= U_ICOMA06A(cProd,nQuant,nMargem,nValFre,nVlUnit,lTransf,nIcmInter,cTes,nConFrete,cNota,cSerie,cForn,cLoja,cFilSai,cItem,nValIcm,nValIpi,.T.)
	
	cObs		:= "REQUISIÇÃO REF. SUBST. TRIBUTÁRIA"
	
	U_AcertaCusto(cProd,cUm,cArm,nCusto,cNota,cSerie,cForn,cLoja,cItem,cFilEnt,cObs)

	lFret := .F. 
	
Elseif !(lTransf) .and. lNcm .and. lTes .And. lEstSP //Operação de compra
	
	nCusto 	:= U_ICOMA06A(cProd,nQuant,nMargem,nValFre,nVlUnit,lTransf,nIcmInter,cTes,nConFrete,cNota,cSerie,cForn,cLoja,cFilSai,cItem,nValIcm,nValIpi,.F.)
	
	U_AcertaCusto(cProd,cUm,cArm,nCusto,cNota,cSerie,cForn,cLoja,cItem,cFilEnt,cObs)

	lFret := .F.
EndIf  

/*if lRelIva
	U_IFISR01( SF1->(RECNO()) )
EndIf
*/     

If lFret
	U_AcertaCusto(cProd,cUm,cArm,nConFrete,cNota,cSerie,cForn,cLoja,cItem,cFilEnt,cObs)
EndIf

RestArea(aArea)

Return


/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06A| Autor: |    Rogério Alves     | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Calcula o ICMS de Substituição Tributária                          |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA06A(cProd,nQuant,nMargem,nValFre,nVlUnit,lTransf,nIcmInter,cTes,nConFrete,cNota,cSerie,cForn,cLoja,cFilSai,cItem,nValIcm,nValIpi,lTransf)

Local aArea   		:= GetArea()
Local cQUERY		:= ""
Local aSM0 			:= FWLoadSM0()
Local xTEMP			:= {}
Local aCGC			:= ""
Local nCusto		:= 0
Local nImpostos		:= 0
Local nAInterna		:= GETMV("MV_ICMPAD")	// 18%
Local nAInteres		:= 0
Local nValFreTot	:= 0
Local nIvaAj 		:= 0
Local nBasIcms		:= 0
Local cFundap		:= IIf(Posicione("SF4",1,xFilial("SF4")+cTes,"F4__FUNDAP")=="1",.T.,.F.)
Local cOrig			:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_ORIGEM")
Local nInterna		:= 0
Local nInteres		:= 0
Local nValAgreg		:= 0
Local nValIvaAj		:= 0

For x:=1 to Len(aSM0)
	aCGC := aCGC + aSM0[x][18]
	If x != Len(aSM0)
		aCGC := aCGC + ","
	EndIf
Next

aCGC := FormatIn(aCGC,",")

cQUERY := "SELECT D1_COD COD, D1_QUANT QUANT, D1_VUNIT VLUNIT, D1_CUSTO/D1_QUANT CUSTO, D1_VALIPI/D1_QUANT IPI, D1_VALICM/D1_QUANT ICMS, "
cQUERY += "D1_VALIMP6/D1_QUANT PIS, D1_VALIMP5/D1_QUANT COFINS, D1_DOC DOC, D1_SERIE SERIE, D1_EMISSAO EMISSAO, SA2.A2_EST, D1_TOTAL, D1_ITEM, D1_FORNECE, D1_LOJA "
cQUERY += " FROM " + RetSqlName("SD1") + " SD1 "
cQuery += " INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '" + cFilSai + "' AND F4_CODIGO = D1_TES AND SF4.D_E_L_E_T_ = ' '  "
cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2.D_E_L_E_T_ = ' '  "
cQUERY += "WHERE D1_TIPO = 'N' "
cQUERY += "AND SD1.D_E_L_E_T_ = ' ' "
cQUERY += "AND D1_FILIAL = '" + cFilSai + "' "
cQUERY += "AND D1_COD = '" + cProd + "' "
If !lTransf
	cQUERY += "AND F4_DUPLIC = 'S' "
EndIf
cQUERY += "AND F4_ESTOQUE = 'S' "
cQUERY += "AND F4_ATUATF <> 'S' "
cQUERY += "AND F4_PODER3 = 'N' "
cQUERY += "AND A2_CGC NOT IN " + aCGC + " "
cQUERY += " AND SD1.D1_DTDIGIT >= '20150501' "
cQUERY += "ORDER BY D1_DTDIGIT DESC "

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cQUERY := ChangeQuery(cQUERY)

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

dbSelectArea("xTEMP")
dbGoTop()

nValFreTot 	:= nValFre + nConFrete	
If !Empty(xTEMP->COD)	
	nImpostos 	:= ((xTEMP->IPI) + (xTEMP->ICMS) + (xTEMP->PIS) + (xTEMP->COFINS))
	nValAgreg	:= nImpostos + nValFreTot  //SD1->D1__VLAGRE
	nBasIcms 	:= (nValFreTot + (nVlUnit * nQuant) + nImpostos) + nValIpi //SD1->D1__BICMST	
Else	
	nValAgreg	:= nValFreTot	
	nBasIcms 	:= (nValFreTot + (nVlUnit * nQuant)) + nValIpi	
EndIf
nIvaAj 		:= (nBasIcms * nMargem)/100 + nBasIcms  //SD1->D1__AJIVA
nValIvaAj 	:= (nIvaAj * nAInterna)/100  

If nValIcm == 0  
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	If(DbSeek(xFilial("SA2")+cForn+cLoja)) 
		DbSelectArea("Z29")
 		Z29->(DbSetOrder(1))
  		If(DbSeek(xFilial("Z29")+SA2->A2_EST))
  	 		nAInteres := Z29->Z29_ALIQ
    		nValIcm := nVlUnit * nQuant
    		nValIcm := nValIcm * (nAInteres/100) 		
  		EndiF
  	EndIf 	
EndIf 

nCusto		:= nValIvaAj - nValIcm  //SD1->D1__CUSST
	
If cFundap .and. (cFilAnt $ getmv("MV__FILFUN")) .and. (cOrig $ getmv("MV__ORIFUN"))
	nCusto := nCusto + nValIcm
EndIf

While !Reclock("SD1",.f.)
EndDo
SD1->D1__CUSST  := IIF(nCusto<0,(-1 * nCusto),nCusto)
SD1->D1__BICMST := nBasIcms
SD1->D1__AJIVA  := nIvaAj
SD1->D1__ALQPAD := nAInterna
SD1->D1__VLAGRE := nValAgreg
If !Empty(xTEMP->COD)
	SD1->D1__NFIVA	:= xTEMP->DOC
	SD1->D1__SERIVA	:= xTEMP->SERIE
	SD1->D1__DTNOTA	:= STOD(xTEMP->EMISSAO)
	SD1->D1__FORIVA	:= xTEMP->D1_FORNECE
	SD1->D1__LOJIVA	:= xTEMP->D1_LOJA
	SD1->D1__ITEIVA	:= xTEMP->D1_ITEM
EndIf
MsUnlock()

If(nIvaAj > 0)
	lRelIva := .T.
EndIf

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

RestArea(aArea)

Return(nCusto)


/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06C| Autor: |    Rogério Alves     | Data: |  Setembro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Ajuste do custo na transferência                                   |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA06C(cNota,cSerie,cProd,cItem,nCusto,nQuant,nValIcm,cFilSai,cUfDest,cCgc)

Local cQUERY	:= ""
Local xTEMP		:= {}
Local cCgcAt	:= ""
Local cCliente	:= ""
Local cLoja		:= ""
Local cUfOri	:= ""
Local nAjCusto	:= 0
Local aSM0 		:= FWLoadSM0()

ASORT(aSM0, , , { | x,y | x[1] > y[1] } )

For nX := 1 To Len(aSM0)
	If aSM0[nX][2] == cFilAnt
		cCgcAt := aSM0[nX][18]
	EndIF
Next nX

cQUERY := "SELECT DISTINCT D2_CUSTO1/D2_QUANT CUNIT, D2_EST EST "
cQUERY += "FROM " + RetSqlName("SD2") + " SD2 "
cQUERY += "INNER JOIN " + RetSqlName("SA1") + " SA1 " + "ON A1_CGC = '" + cCgcAt + "' AND SA1.D_E_L_E_T_ = ' ' "
cQUERY += "WHERE SD2.D_E_L_E_T_ = ' ' "
cQUERY += "AND D2_FILIAL = '" +cFilSai+ "' "
cQUERY += "AND D2_ITEMPV = '" +cItem+ "' "
cQUERY += "AND D2_COD = '" +cProd+ "' "
cQUERY += "AND D2_DOC = '" +cNota+ "' "
cQUERY += "AND D2_SERIE = '" +cSerie+ "' "

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cQUERY := ChangeQuery(cQUERY)

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

dbSelectArea("xTEMP")
dbGoTop()

If !Empty(xTEMP->CUNIT)
	
	nAjCusto := (xTEMP->CUNIT - (nCusto/nQuant)) * nQuant
	
	//If cUfDest == xTEMP->EST
	//nAjCusto := nAjCusto + nValIcm
	//EndIf
	
Else
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	If !DbSeek(cFilSai + cProd)
		nAjCusto := SB2->B2_CM1
	EndIf
	
EndIf

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

Return(nAjCusto)


/*
+------------+-------------+--------+----------------------+-------+------------------+
| Programa:  | AcertaCusto | Autor: |    Rogério Alves     | Data: |   Setembro/2014  |
+------------+-------------+--------+----------------------+-------+------------------+
| Descrição: | Faz a movimentação interna de acerto do Custo                          |
+------------+------------------------------------------------------------------------+
| Uso:       | ISAPA                                                                  |
+------------+------------------------------------------------------------------------+
*/


User Function AcertaCusto(cProd,cUm,cArm,nCusto,cNota,cSerie,cForn,cLoja,cItem,cFilEnt,cObs)

Local aArea    := GetArea()
Local aItem		:= aCab := {}
Local nOpcAuto	:= 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
Local cTmEnt	:= GetMv("MV__TMVAL")	//004
Local cTmSai	:= GetMv("MV__TMVSAI")	//504
Local cTm		:= ""

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

If nCusto != 0
	
	If nCusto < 0
		nCusto 	:= nCusto * -1
		cTm		:= cTmSai
	Else
		cTm		:= cTmEnt
	EndIf
	
	Begin Transaction
	
	DbSelectArea("NNR")
	DbSetOrder(1)
	If !DbSeek(xFilial("NNR")+cFilEnt)
		If reclock("NNR", .T.)
			NNR->NNR_CODIGO := cFilEnt
			NNR->NNR_DESCRI := "ARMAZEM " + cFilEnt
			MsUnlock()
		EndIf
	EndIf
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	If !DbSeek(cFilEnt+cProd+cArm,.F.)
		MsUnlockAll()
		CriaSB2(cProd,cArm)
		MsUnlock()
	EndIf
	
	cDoc	:= GetSxENum("SD3","D3_DOC",1)
	aCab 	:= {}
	aItem := {}
	
	lMsErroAuto := .F.
	
	aCab := {		{"D3_DOC"    	, cDoc    	,  	Nil},;
					{"D3_TM"     	, cTm	    ,  	Nil},;
					{"D3_EMISSAO"	, SF1->F1_DTDIGIT	,  	Nil}}
	
	aadd(aItem,{	{"D3_TM"      	, cTm	    ,  	Nil},;
					{"D3_COD"     	, cProd     ,  	Nil},;
					{"D3_UM"      	, cUm       ,  	Nil},;
					{"D3_QUANT"   	, 0		   	,  	Nil},;
					{"D3_LOCAL"   	, cArm		,  	Nil},;
					{"D3_EMISSAO"	, dDataBase	,  	NIL},;
					{"D3_CUSTO1"	, nCusto	,  	NIL},;
					{"D3__DOC"     	, cNota	   	,  	Nil},;
					{"D3__SERIE"   	, cSerie	,  	Nil},;
					{"D3__FORNEC"  	, cForn	   	,  	Nil},;
					{"D3__LOJA"	   	, cLoja		,  	Nil},;
					{"D3__OBS"	   	, cObs		,  	Nil},;
					{"D3__ITEM"		, cItem		,  	NIL}})
	
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem,nOpcAuto)
	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		Break
	EndIf
	
	End Transaction
	
EndIf

RestArea(aArea)

Return




/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06B| Autor: |    Rogério Alves     | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Busca o valor do Frete do Conhecimento                             |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

/*
User Function ICOMA06B(cNota,cSerie,cForn,cItem)

Local cQuery 	:= ""
Local TMPSD1	:= {}
Local cValFre	:= 0

If(select("TMPSD1") > 0)
TMPSD1->(dbCloseArea())
endif

cQuery := "SELECT SUM(D1_TOTAL) VALFRETE, SUM(D1_VALICM) ICMFRETE "
cQuery += "FROM " + retSqlname("SD1") + " SD1 "
cQuery += "WHERE D1__NFORIG = '" + cNota  + "' "
cQuery += "AND D1__SERORI = '" + cSerie  + "' "
cQuery += "AND D1__FORORI = '" + cForn  + "' "
cQuery += "AND D1__ITEMOR = '" + cItem + "' "
cQuery += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery += "AND D1_TIPO = 'C' "
cQuery += "AND SD1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "TMPSD1"

dbSelectArea("TMPSD1")
dbGoTop()

cValFre := TMPSD1->VALFRETE

If(select("TMPSD1") > 0)
TMPSD1->(dbCloseArea())
endif

Return(cValFre)

*/


//	nBasIcms 	:= nQuant * nVlUnit
//	nIvaAj 		:= ((nQuant * nVlUnit) * (nMargem/100))

//nCusto		:= nIvaAj

//nInterna 	:= nCusto * (nAInterna/100)

//nInteres 	:= (nQuant * nVlUnit) * (nIcmInter/100)
//nCusto		:= nInteres - nInterna

//	nCusto := nCusto + nInterna   ::: FUNDAP
