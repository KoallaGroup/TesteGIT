#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMR03				 	| 	Setembro de 2014                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de compras por Ítem                                                   |
|-----------------------------------------------------------------------------------------------|
*/

User Function ICOMR03()

Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Local nRet 			:= 0
Local oFont 		:= tFont():New("Tahoma",,12,,.t.)
Local _nLinha		:= 26 
Local _aStru		:= {015,;
						055,;
						070,;
						135,;
						150}

Static oDlg

Private oGet1
Private oGet2
Private cGrupoDe	:= space(TAMSX3("B1_GRUPO")[1])
Private cGrupoAte	:= "ZZZZ"
Private cSubGrpDe	:= space(TAMSX3("B1__SUBGRP")[1])
Private cSubGrpAte	:= "ZZZZ"
Private cProd		:= space(TAMSX3("B1_COD")[1])
Private cArrayProd	:= ""
Private cProd2		:= ""
Private _dEmiDe     := Date() - 365
Private _dEmiAte	:= Date() + 365
Private _dMesDe		:= FirstDay(Date()) 
Private _dMesAte	:= LastDay(Date())
Private _dAnoDe		:= CTOD("01/01/" + Alltrim(Str(Year(Date()))))
Private	_dAnoAte	:= CTOD("31/12/" + Alltrim(Str(Year(Date()))))

DEFINE MSDIALOG oDlg TITLE "Relatório de compras por Ítem" FROM 000, 000  TO 380, 600 COLORS 0, 16777215 PIXEL

@ 010,006 GROUP oGroup1 TO 160, 298 PROMPT "Filtro" OF oDlg COLOR 0, 16777215 PIXEL

@ _nLinha,_aStru[1] SAY "Grupo" SIZE 30, 10 OF oDlg PIXEL //FONT oFont

@ _nLinha,_aStru[2] SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[3] MsGet cGrupoDe when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SBM" valid ValidaGrupo(cGrupoDe)
@ _nLinha,_aStru[4] SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[5] MsGet cGrupoAte when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SBM" valid ValidaGrupo(cGrupoAte)
_nLinha += 20

@ _nLinha,_aStru[1] SAY "SubGrupo" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[2] SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[3] MsGet cSubGrpDe when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SZ4" valid ValidaSubGrp(cSubGrpDe)
@ _nLinha,_aStru[4] SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[5] MsGet cSubGrpAte when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SZ4" valid ValidaSubGrp(cSubGrpAte)
_nLinha += 20

@ _nLinha,_aStru[1] SAY "Emissão" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[2] SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[3] MsGet _dEmiDe when .T. Size 050,10 of oDlg PIXEL FONT oFont 
@ _nLinha,_aStru[4] SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[5] MsGet _dEmiAte when .T. Size 050,10 of oDlg PIXEL FONT oFont 
_nLinha += 20

@ _nLinha,_aStru[1] SAY "Mês" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[2] SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[3] MsGet _dMesDe when .T. Size 050,10 of oDlg PIXEL FONT oFont 
@ _nLinha,_aStru[4] SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[5] MsGet _dMesAte when .T. Size 050,10 of oDlg PIXEL FONT oFont 
_nLinha += 20

@ _nLinha,_aStru[1] SAY "Ano" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[2] SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[3] MsGet _dAnoDe when .T. Size 050,10 of oDlg PIXEL FONT oFont 
@ _nLinha,_aStru[4] SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[5] MsGet _dAnoAte when .T. Size 050,10 of oDlg PIXEL FONT oFont 
_nLinha += 20

@ _nLinha,_aStru[1] SAY "Item Interno" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLinha,_aStru[3] MsGet oGet2 VAR cProd when .T. Picture "@!" Size 060,10 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd)
_nLinha += 16

@ _nLinha,_aStru[1] MSGET oGet1 VAR cProd2	SIZE 240, 009 OF oDlg COLORS 0, 16777215 PIXEL	WHEN .F.
_nLinha += 25

@ _nLinha,170 BUTTON oButton1 PROMPT "Processar" SIZE 040, 012 OF oDlg PIXEL ACTION U_ICOMR03A(cArrayProd)
@ _nLinha,217 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

Return


User Function ICOMR03A(cArrayProd)

Local aArea   	:= GetArea()
Local aProd		:= strtokarr(cArrayProd, '/')
Local cQUERY	:= ""
Local aSM0 		:= FWLoadSM0()
Local aSM0aux	:= {}
Local xTEMP		:= {}
Local aFil		:= {}
Local aCGC		:= ""
Local _aStru1	:= {}
Local cArqTrab 	:= ""
Local xSD1		:= {}
Local cOptions 	:= ""
Local cUseId	:= __cUserId
Local cMoeda	:= "" 
Local cDescIn	:= ""
Local _cDepos	:= GetMV("MV__LOCPAD")

PRIVATE nVenMes		:= 0
PRIVATE nVenAno		:= 0
Private nSaiTotMes 	:= 0
Private nSaiTotAno 	:= 0
Private nLucBruto	:= 0

AADD(_aStru1,{"FILIAL"      ,"C",02,0})
AADD(_aStru1,{"NOMFIL"      ,"C",15,0})
AADD(_aStru1,{"MOEDA"      	,"C",10,0})
aTam := TamSX3("Z1_CODUSR")
AADD(_aStru1,{"USUARIO"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_COD")
AADD(_aStru1,{"COD"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_LOCAL")
AADD(_aStru1,{"LOCALP"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B1_DESC")
AADD(_aStru1,{"DESCRI"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B1_UCOM")
AADD(_aStru1,{"UCOM"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B1__DESCI")
AADD(_aStru1,{"DESCI"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B1__EMBMAS")
AADD(_aStru1,{"EMBMAS"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B2_QATU")
AADD(_aStru1,{"QATU"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B2_RESERVA")
AADD(_aStru1,{"RESERVA"     ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("B2_QNPT")
AADD(_aStru1,{"QNPT"	    ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_QUANT")
AADD(_aStru1,{"QUANT"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_UM")
AADD(_aStru1,{"UM"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_VUNIT")
AADD(_aStru1,{"VUNIT"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_CUSTO")
AADD(_aStru1,{"CUSTO"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_VALIPI")
AADD(_aStru1,{"IPI"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_VALICM")
AADD(_aStru1,{"ICMS"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_VALIMP6")
AADD(_aStru1,{"PIS"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_VALIMP5")
AADD(_aStru1,{"COFINS"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_DTDIGIT")
AADD(_aStru1,{"DTDIGIT"     ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_QUANT")
AADD(_aStru1,{"TOTAL"      	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_QUANT")
AADD(_aStru1,{"VENMES"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D1_QUANT")
AADD(_aStru1,{"VENANO"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("DA1_PRCVEN")
AADD(_aStru1,{"PRCVEN"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("C7_QUANT")
AADD(_aStru1,{"EMBARCAR"    ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("C7__QTEMBA")
AADD(_aStru1,{"QTEMBA"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("D2_PICM")
AADD(_aStru1,{"LBRUTO"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("A5_FORNECE")
AADD(_aStru1,{"FORNECE"      ,aTam[3],aTam[1],aTam[2]})

cArqTrab := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,cArqTrab,"xSD1",.t.)

DbSelectArea("xSD1")

//Remove filiais 01 e 05 do Array - Rubens Cruz (Fevereiro/2015)
For x:=1 to Len(aSM0)
	If !(aSM0[x][2] $ "01/05")
		aadd(aSM0aux,aSM0[x])
	EndIf
Next x
aSM0 := aSM0Aux

For x:=1 to Len(aSM0)
	aCGC := aCGC + aSM0[x][18]
	If x != Len(aSM0)
		aCGC := aCGC + ","
	EndIf

Next

aCGC := FormatIn(aCGC,",")

For x:=1 to Len(aProd)
	
	cQUERY := "select SA5.* " 
	cQUERY += "from SB1010 SB1 "
	cQUERY += "inner join SA5010 SA5 ON A5_PRODUTO = B1_COD "
	cQUERY += "                     and SA5.D_E_L_E_T_ = ' ' "
	cQUERY += "where B1_COD = '" + aProd[x] + "' "
	cQUERY += "	 and SB1.D_E_L_E_T_ = ' '"
			
	If Select("A5TEMP") > 0
		A5TEMP->(dbCloseArea())
	EndIf
	TcQuery cQUERY New Alias "A5TEMP"
	
	do while ! A5TEMP->(eof())

		For y:=1 to Len(aSM0)

			cQUERY := "SELECT SB1.B1_COD,"
			cQUERY += "       NVL(SB2.SALDOREAL,0) ESTOQUE, "
			cQUERY += "       NVL(SB2.B2_QNPT,0) ARMAZEM,  "
			cQUERY += "       NVL(SB2.B2_RESERVA,0) + NVL(Z10.Z10_QTD,0) AS B2_RESERVA,    " + Chr(13)
			cQUERY += "       NVL(SZ3.DESEMB,0) DESEMBARQUE,"
			cQUERY += "       NVL(SC7B.EMBARCAR,0) EMBARCADO,"
			cQUERY += "       (NVL(SB2.SALDOREAL,0) + NVL(SB2.B2_QNPT,0) + NVL(SZ3.DESEMB,0) + NVL(SC7B.EMBARCAR,0)) AS TOTAL,  "
			cQUERY += "       NVL(SD2M.QUANTIDADE,0) VENDAMES,"
			cQUERY += "       NVL(SD2A.QUANTIDADE,0) VENDAANO,"
			cQUERY += "       NVL(ROUND(100 - (SD2A.CUSTO / SD2A.TOTAL * 100),2),0) LBRUT,   "
			cQUERY += "       SC7.C7_EMISSAO ULTCOM,"
			cQUERY += "       SC7.C7_PRECO,"
			cQUERY += "       SD1.D1_DTDIGIT ULTENTR, "
			cQUERY += "       SD1.D1_QUANT QTULTENTR, "
			cQUERY += "       SA5.A5_FORNECE "
			cQUERY += "FROM " + RetSqlName("SB1") + " SB1 "
			
			cQUERY += "inner join " + RetSqlName("SA5") + " SA5 ON A5_PRODUTO = B1_COD "
            cQUERY += "			      and A5_FORNECE = '" + A5TEMP->A5_FORNECE + "' "
            cQUERY += "			      and SA5.D_E_L_E_T_ = ' ' "
            
			cQUERY += "LEFT JOIN  (SELECT SB2.B2_COD, "
			cQUERY += "                   SUM(SB2.B2_QNPT) B2_QNPT,"
			cQUERY += "                   SUM(SB2.B2__QTDTRA) B2__QTDTRA, "
			cQUERY += "                   SUM(SB2.B2_RESERVA) B2_RESERVA, "
			cQUERY += "                   SUM(CASE WHEN SB2.B2_LOCAL = '01' "
			cQUERY += "                            THEN SB2.B2_QATU "
			cQUERY += "                        ELSE 0 END) AS SALDOREAL "
			cQUERY += "            FROM " + RetSqlName("SB2") + " SB2 "
			cQUERY += "            WHERE SB2.D_E_L_E_T_ = ' ' "
			cQUERY += "                  AND SB2.B2_COD = '" + aProd[x]+ "' "
			cQUERY += "                  AND SB2.B2_FILIAL = '" + aSM0[y][5] + "' "
			cQUERY += "             GROUP BY  SB2.B2_COD) SB2 ON SB2.B2_COD = SB1.B1_COD "
			cQUERY += "LEFT JOIN (SELECT SC7.C7_PRODUTO,   "
			cQUERY += "                  SUM(SC7.C7_QUANT) AS EMBARCAR "
			cQUERY += "              FROM " + RetSqlName("SC7") + " SC7 "
			cQUERY += "              LEFT JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = SC7.C7_FILIAL "
			cQUERY += "                                      AND SZ3.Z3_PEDIDO = SC7.C7_NUM  "
			cQUERY += "                                      AND SZ3.Z3_ITPEDCO = SC7.C7_ITEM "
			cQUERY += "                                      AND SZ3.Z3_PRODUTO = SC7.C7_PRODUTO "
			cQUERY += "                                      AND SZ3.D_E_L_E_T_ = ' ' "
			cQUERY += "              INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_FILIAL = '  ' "
			cQUERY += "                                       AND SA2.A2_COD = SC7.C7_FORNECE"
			cQUERY += "                                       AND SA2.A2_LOJA = SC7.C7_LOJA  "
			cQUERY += "                                       AND SA2.D_E_L_E_T_ = ' ' "
			cQUERY += "              WHERE SC7.D_E_L_E_T_ = ' ' "
			cQUERY += "                    AND SC7.C7_EMISSAO BETWEEN '" + DTOS(_dEmiDe) + "' AND '" + DTOS(_dEmiAte) + "' "
			cQUERY += "                    AND SC7.C7_PRODUTO = '" + aProd[x]+ "' "
			cQUERY += "                    AND SA2.A2_EST = 'EX' "
			cQUERY += "                    AND SC7.C7_FORNECE = '" + A5TEMP->A5_FORNECE + "' "
			cQUERY += "                    AND SC7.C7_FILIAL = '" + aSM0[y][5] + "' "
			cQUERY += "                    AND SZ3.Z3_CODIGO IS NULL "
			cQUERY += "              GROUP BY SC7.C7_PRODUTO, C7_FORNECE) SC7B ON SC7B.C7_PRODUTO = SB1.B1_COD  "
			cQUERY += "LEFT JOIN  (SELECT Z3_PRODUTO, "
			cQUERY += "                   SUM(Z3_QTDEMBA  - Z3_QTDESEM) AS DESEMB "
			cQUERY += "            FROM " + RetSqlName("SZ3") + " SZ3 "
			cQUERY += "            WHERE SZ3.D_E_L_E_T_ = ' ' "
			cQUERY += "                    AND SZ3.Z3_CODFORN = '" + A5TEMP->A5_FORNECE + "' "
			cQUERY += "                  AND SZ3.Z3_PRODUTO = '" + aProd[x]+ "'"
			cQUERY += "                    AND SZ3.Z3_FILIAL = '" + aSM0[y][5] + "'"
			cQUERY += "            GROUP BY Z3_FILIAL, "
			cQUERY += "                     Z3_PRODUTO) SZ3 ON SB1.B1_COD = SZ3.Z3_PRODUTO "
			cQUERY += "LEFT JOIN  (SELECT SD2.D2_COD, "
			cQUERY += "                   SUM(SD2.D2_QUANT) QUANTIDADE,"
			cQUERY += "                   SUM(SD2.D2_CUSTO1) AS CUSTO "
			cQUERY += "            FROM " + RetSqlName("SD2") + " SD2 "
			cQUERY += "            INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_FILIAL = SD2.D2_FILIAL "
			cQUERY += "                                     AND SF4.F4_CODIGO = SD2.D2_TES "
			cQUERY += "                                     AND SF4.D_E_L_E_T_ = ' ' "
			cQUERY += "            WHERE SD2.D2_EMISSAO BETWEEN '" + DTOS(_dMesDe) + "' AND '" + DTOS(_dMesAte) + "'"
			cQUERY += "                  AND SD2.D2_PEDIDO != ' ' "
			cQUERY += "                  AND SD2.D_E_L_E_T_ = ' ' "
			cQUERY += "                  AND SD2.D2_COD = '" + aProd[x]+ "' "
			cQUERY += "                  AND SF4.F4_DUPLIC = 'S' "
			cQUERY += "                  AND SF4.F4_FILIAL = '" + aSM0[y][5] + "' "
			cQUERY += "            GROUP BY SD2.D2_FILIAL, "
			cQUERY += "                     SD2.D2_COD) SD2M ON SD2M.D2_COD = SB1.B1_COD     "
			cQUERY += "LEFT JOIN  (SELECT SD2.D2_COD, "
			cQUERY += "                   SUM(SD2.D2_QUANT) QUANTIDADE,        "
			cQUERY += "                   SUM(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6) TOTAL,"
			cQUERY += "                   SUM(SD2.D2_CUSTO1) AS CUSTO          "
			cQUERY += "            FROM " + RetSqlName("SD2") + " SD2          "
			cQUERY += "            INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_FILIAL = SD2.D2_FILIAL        "
			cQUERY += "                                     AND SF4.F4_CODIGO = SD2.D2_TES   "
			cQUERY += "                                     AND SF4.D_E_L_E_T_ = ' '         "
			cQUERY += "           WHERE SD2.D2_EMISSAO BETWEEN '" + DTOS(_dAnoDe) + "' AND '" + DTOS(_dAnoAte) + "' "
			cQUERY += "                  AND SD2.D2_PEDIDO != ' ' "
			cQUERY += "                  AND SD2.D_E_L_E_T_ = ' ' "
			cQUERY += "                  AND SD2.D2_COD = '" + aProd[x]+ "'    "
			cQUERY += "                  AND SF4.F4_DUPLIC = 'S'               "
			cQUERY += "                  AND SD2.D2_FILIAL = '" + aSM0[y][5] + "'            "
			cQUERY += "            GROUP BY SD2.D2_FILIAL, "
			cQUERY += "                     SD2.D2_COD) SD2A ON SD2A.D2_COD = SB1.B1_COD     "
			cQUERY += "LEFT JOIN ( SELECT SC7.C7_PRODUTO,  "
			cQUERY += "                   SC7.C7_EMISSAO,  "
			cQUERY += "                   SC7.C7_PRECO     "
			cQUERY += "            FROM " + RetSqlName("SC7") + " SC7          "
			cQUERY += "            INNER JOIN (SELECT MAX(SC7.R_E_C_N_O_) C7_RECNO           "
			cQUERY += "                        FROM " + RetSqlName("SC7") + " SC7            "
			cQUERY += "                        WHERE C7_PRODUTO = '" + aProd[x]+ "'          "
			cQUERY += "                              AND SC7.C7_RESIDUO <> 'S' "
			cQUERY += "                              AND SC7.C7_DATPRF BETWEEN '" + DTOS(_dEmiDe) + "' AND '" + DTOS(_dEmiAte) + "' "
			cQUERY += "                              AND SC7.D_E_L_E_T_ = ' '  "
			cQUERY += "                              AND SC7.C7_FILIAL = '" + aSM0[y][5] + "'"
			cQUERY += "                        GROUP BY SC7.C7_PRODUTO) SC7A ON SC7A.C7_RECNO = SC7.R_E_C_N_O_) SC7 ON SC7.C7_PRODUTO = SB1.B1_COD " + Chr(13)
			cQUERY += "LEFT JOIN  (SELECT SD1.D1_COD,      "
			cQUERY += "                   SD1.D1_DTDIGIT,  "
			cQUERY += "                   SD1.D1_QUANT,    "
			cQUERY += "                   SD1.D1_VUNIT     "
			cQUERY += "            FROM " + RetSqlName("SD1") + " SD1          "
			cQUERY += "            INNER JOIN (SELECT SD1.D1_COD,              "
			cQUERY += "                               SD1.D1_DTDIGIT,          "
			cQUERY += "                               MAX(SD1.R_E_C_N_O_) RECNO"
			cQUERY += "    				       FROM " + RetSqlName("SD1") + " SD1            "
			cQUERY += "                        INNER JOIN (SELECT SD1.D1_COD,  "
			cQUERY += "                                           MAX(SD1.D1_DTDIGIT) ULTENT "
			cQUERY += "                                    FROM " + RetSqlName("SD1") + " SD1"
			cQUERY += "                                    WHERE SD1.D_E_L_E_T_ = ' '        "
			cQUERY += "                                          AND SD1.D1_COD = '" + aProd[x]+ "' "
			cQUERY += "                                          AND SD1.D1_DTDIGIT >=  '20150501'  "
			cQUERY += "                                          AND SD1.D1_PEDIDO != ' '    "
			cQUERY += "                                          AND SD1.D1_ITEMPC != ' '    "
			cQUERY += "                                          AND SD1.D1_FILIAL = '" + aSM0[y][5] + "'           "
			cQUERY += "                                    GROUP BY SD1.D1_COD) TMP ON TMP.D1_COD = SD1.D1_COD      "
			cQUERY += "                                                                AND TMP.D1_COD = SD1.D1_COD  "
			cQUERY += "                                                                AND TMP.D1_COD = SD1.D1_COD  "
			cQUERY += "                                                                AND TMP.ULTENT = SD1.D1_DTDIGIT "
			cQUERY += "                        GROUP BY SD1.D1_COD,            "
			cQUERY += "                                 SD1.D1_DTDIGIT) TMP ON TMP.RECNO = SD1.R_E_C_N_O_) SD1 ON SD1.D1_COD = SB1.B1_COD          " + Chr(13)
	
			cQUERY += " left join (	select  Z10_PROD, SUM(Z10_QTD) AS Z10_QTD          "
			cQUERY += "			 	from Z10010 Z10                                      "
			cQUERY += " 			inner join SUA010 SUA on UA_NUM = Z10_CODSUA    "
			cQUERY += " 	                 and SUA.D_E_L_E_T_ = ' ' 				          "
			cQUERY += "                      and UA_FILIAL = Z10_FILIAL   			          "
			cQUERY += " 			inner join SUB010 SUA on UB_NUM = UA_NUM         "
			cQUERY += "                      and SUA.D_E_L_E_T_ = ' '                  "
			cQUERY += "                      and UB_FILIAL = UA_FILIAL                  "
			cQUERY += "                      and UB_ITEM = Z10_ITEM                "
			cQUERY += " 			left join SC9010 SC9 on C9_FILIAL = UB_FILIAL "
			cQUERY += "                     and C9_PEDIDO = UB_NUMPV                "
			cQUERY += "                     and C9_ITEM = UB_ITEMPV                "
			cQUERY += "                     and SC9.D_E_L_E_T_ = ' '                "
			cQUERY += " 			where Z10.D_E_L_E_T_ = ' '                       "
			cQUERY += "   			  and C9_ITEM is null                            "
			cQUERY += "   			  AND Z10_PROD = '" + aProd[x]+ "'               	      "
			cQUERY += "   			  and Z10_FILIAL = '" + aSM0[y][5] + "'
			cQUERY += " 			group by Z10_PROD ) Z10 ON Z10.Z10_PROD = SB1.B1_COD "
				
			cQUERY += "WHERE SB1.D_E_L_E_T_ = ' '          "
			cQUERY += "		 AND B1_GRUPO BETWEEN '" + cGrupoDe + "' AND '" + cGrupoAte + "'  "
			cQUERY += "		 AND B1__SUBGRP BETWEEN '" + cSubGrpDe + "' AND '" + cSubGrpAte + "' 				    "
			cQUERY += "      AND B1_COD = '" + aProd[x]+ "' "
	
			If Select("xTEMP") > 0
				xTEMP->(dbCloseArea())
			EndIf
			
	//		cQUERY := ChangeQuery(cQUERY)
			
			TcQuery cQUERY New Alias "xTEMP"
			
			cQUERY	:= ""
			
			dbSelectArea("xTEMP")
			dbGoTop()
			
			//		If !Empty(xTEMP->COD)
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+aProd[x])
	
			DbSelectArea("SA5")
			DbSetOrder(2)
			If (DbSeek(xFilial("SA5")+aProd[x]))
				cDescIn := SA5->A5__DESCIN
			Else
				cDescIn := SB1->B1__DESCI
			EndIf    

			cDescIn := A5TEMP->A5_CODPRF + A5TEMP->A5__DESCIN
		
			While !RecLock("xSD1",.t.)
			Enddo
			//Usuário
			xSD1->USUARIO	:= cUseId
			//Filial
			xSD1->FILIAL	:= aSM0[y][5]
			//Descrição Filial
			xSD1->NOMFIL	:= Alltrim(aSM0[y][7])
			//Código Produto
			xSD1->COD 		:= aProd[x]
			//Qt.Master
			xSD1->EMBMAS	:= SB1->B1__EMBMAS //xTEMP->EMBMAS
			//Descrição Protugues
			xSD1->DESCRI	:= SB1->B1_DESC //Alltrim(xTEMP->DESCRI)
			//Descrição Ingles
			xSD1->DESCI		:= cDescIn //Alltrim(xTEMP->DESCI)
			//Un
			xSD1->UM		:= SB1->B1_UM //xTEMP->UM
			xSD1->LOCALP	:= _cDepos //xTEMP->LOCALP
			//Estoque
			xSD1->QATU		:= xTemp->ESTOQUE //Posicione("SB2",1,xTEMP->FILIAL+xTEMP->COD+xTEMP->LOCALP,"B2_QATU")
			//Armazem
			xSD1->QNPT		:= xTemp->ARMAZEM //Posicione("SB2",1,xTEMP->FILIAL+xTEMP->COD+xTEMP->LOCALP,"B2_QNPT")
			//Reserva
			xSD1->RESERVA	:= 0 //Posicione("SB2",1,xTEMP->FILIAL+xTEMP->COD+_cDepos,"B2_RESERVA")
			//Preço
			xSD1->VUNIT 	:= xTEMP->C7_PRECO 
			//Moeda
			cMoeda			:= '1'//Posicione("SF1",1,aSM0[y][5]+xTEMP->DOC+xTEMP->SERIE+xTEMP->FORNECE+xTEMP->LOJA,"F1_MOEDA")		
			If Alltrim(cMoeda) == "2"
				xSD1->MOEDA		:= "Dollar"
			ElseIf Empty(cMoeda)
				xSD1->MOEDA		:= ""
			Else
				xSD1->MOEDA		:= "Real"
			EndIf
			//Data Última Compra
			xSD1->UCOM 		:= stod(xTEMP->ULTCOM)
	//		If !(xTEMP->CGC $ aCGC)//Só Preencher se for compra de Fornecedor
				//Data da última entrada
				xSD1->DTDIGIT	:= stod(xTEMP->ULTENTR)
				//Quantidade da última Entrada
				xSD1->QUANT 	:= xTEMP->QTULTENTR
	//		EndIf
			//Total
			xSD1->TOTAL 	:= xTEMP->TOTAL//xSD1->QATU + xSD1->QNPT
	//		QtdVenda(xTEMP->COD, xTEMP->FILIAL, "M")
			//%L.Br.
			xSD1->LBRUTO	:= xTEMP->LBRUT
			//Quantidade de Vendas no Mês
			xSD1->VENMES	:= xTEMP->VENDAMES
			//Quantidade de Vendas no Ano
	//		QtdVenda(xTEMP->COD, xTEMP->FILIAL, "A")
			xSD1->VENANO	:= xTEMP->VENDAANO//nSaiTotAno
			//Preço Unit.
			xSD1->PRCVEN	:= xTEMP->C7_PRECO //Prcven(xTEMP->COD)
			//Embdo.
			xSD1->QTEMBA	:= xTEMP->DESEMBARQUE //Embdo(xTEMP->COD, xTEMP->FILIAL)
			//Embarcar
			xSD1->EMBARCAR	:= xTEMP->EMBARCADO//Embarcar(xTEMP->COD, xTEMP->FILIAL)
	//		xSD1->CUSTO 	:= xTEMP->CUSTO
	//		xSD1->IPI 		:= xTEMP->IPI
	//		xSD1->ICMS 		:= xTEMP->ICMS
	//		xSD1->PIS 		:= xTEMP->PIS
	//		xSD1->COFINS	:= xTEMP->COFINS
			xSD1->FORNECE	:= xTEMP->A5_FORNECE//Embarcar(xTEMP->COD, xTEMP->FILIAL)
			MsUnLock()
			//		EndIf
			
			If Select("xTEMP") > 0
				xTEMP->(dbCloseArea())
			EndIf
			 
		Next

		A5TEMP->(dbSkip())
	enddo
	
Next

IF TcCanOpen(RetSqlName("PA1"))
	cQuery := " DELETE "+RetSqlName("PA1")
	cQuery += " WHERE PA1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " AND PA1_USER = '"+cUseId+"' "
	TCSqlExec(cQuery)
ENDIF

DbSelectArea("xSD1")
DbGoTop()

While !EOf()
	
	While !RecLock("PA1",.t.)
	Enddo
	PA1_USER	:= xSD1->USUARIO
	PA1_FIL		:= xSD1->FILIAL
	PA1_NOMFIL	:= xSD1->NOMFIL
	PA1_COD		:= xSD1->COD
	PA1_EMBMAS	:= xSD1->EMBMAS
	PA1_DESC  	:= xSD1->DESCRI
	PA1_DESCI 	:= xSD1->DESCI
	PA1_UM    	:= xSD1->UM
	PA1_LOCPAD	:= xSD1->LOCALP
	PA1_RESERV	:= xSD1->RESERVA
	PA1_QATU  	:= xSD1->QATU
	PA1_QNPT  	:= xSD1->QNPT
	PA1_VUNIT 	:= xSD1->VUNIT
	PA1_MOEDA 	:= xSD1->MOEDA
	PA1_UCOM  	:= xSD1->UCOM
	PA1_UENT  	:= xSD1->DTDIGIT
	PA1_QTDUE 	:= xSD1->QUANT
	PA1_TOTAL 	:= xSD1->TOTAL
	PA1_LBRUTO	:= xSD1->LBRUTO
	PA1_VENMES	:= xSD1->VENMES
	PA1_VENANO	:= xSD1->VENANO
	PA1_PRCVEN	:= xSD1->PRCVEN
	PA1_QTEMBA	:= xSD1->QTEMBA
	PA1_EMBARC	:= xSD1->EMBARCAR
	PA1_FORNEC	:= xSD1->FORNECE
	
	MsUnLock()
	
	DbSelectArea("xSD1")
	DbSkip()
	
EndDo

If Select("xSD1") > 0
	xSD1->(dbCloseArea())
EndIf

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cOptions 	:= "1;0;1;Relatorio de Compras por Item" // 1(visualiza tela) 2 (direto impressora) 6(pdf) ; 0 (atualiza dados) ; 1 (número de cópias)

CallCrys("ICOMCR03",cUseId,cOptions)

RestArea(aArea)

Return Nil


////////////////////////////////////////////////
//VALIDA GRUPO
////////////////////////////////////////////////

Static Function ValidaGrupo(cGrupo)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cGrupo)
	dbSelectArea("SBM")
	dbSetOrder(1)
	if !dbSeek(xFilial("SBM")+cGrupo)
		If !(UPPER(Alltrim(cGrupo)) $ "ZZZZZZ")
			msgAlert("Grupo não cadastrado !!")
			_lRet := .F.
		EndIf
	endif
EndIf

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA GRUPO
////////////////////////////////////////////////

Static Function ValidaSubGrp(cSubGrp)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cSubGrp)
	dbSelectArea("SZ4")
	dbSetOrder(1)
	if !dbSeek(xFilial("SZ4")+cSubGrp)
		If !(UPPER(Alltrim(cSubGrp)) $ "ZZZZZZ")
			msgAlert("SubGrupo não cadastrado !!")
			_lRet := .F.
		EndIf
	endif
EndIf

restarea(_aArea)

return _lRet


////////////////////////////////////////////////
//VALIDA PRODUTO
////////////////////////////////////////////////

Static Function ValidaItem(cProdVal)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cProdVal)
	dbSelectArea("SB1")
	dbSetOrder(1)
	if !dbSeek(xFilial("SB1")+cProdVal)
		msgAlert("Produto não cadastrado !!")
		_lRet := .F.		
	Else
		If !(cProdVal $ cArrayProd)
			cArrayProd 	:= cArrayProd  + IIf(!Empty(cArrayProd),"/","") + cProdVal
			cProd2 		:= cProd2 + IIf(!Empty(cProd2),"/","") + Alltrim(cProdVal)
		Else
			msgAlert("Produto já selecionado !!")
			_lRet := .F.
		EndIf
	EndIf
		
	oGet2:SetFocus()
	cProd := space(TAMSX3("B1_COD")[1])	
	
EndIf

restarea(_aArea)

return _lRet


////////////////////////////////////////////////
//QUANTIDADE DE VENDAS MENSAL E ANUAL
////////////////////////////////////////////////

Static Function QtdVenda(cProduto,cFilAtu,cTempo)

Local aArea 	:= getArea()
Local cQuery	:= ""
Local TRBSD2	:= {}
Local dIni		:= ""
Local dFim		:= ""

If cTempo == "M"
	dIni	:= Strzero(Year(dDataBase),4)+Strzero(Month(dDataBase),2)+"01"
	dFim	:= Strzero(Year(dDataBase),4)+Strzero(Month(dDataBase),2)+"31"
ElseIf cTempo == "A"
	dIni	:= Strzero(Year(dDataBase),4)+"0101"
	dFim	:= Strzero(Year(dDataBase),4)+"1231"
EndIf

cQuery := "SELECT SUM(D2_QUANT) AS TOTAL, SUM(D2_CUSTO1) CUSTO, SUM(D2_TOTAL) VLTOTAL, SUM(D2_VALICM) VALICM, SUM(D2_VALIPI) VALIPI, SUM(D2_VALIMP5) VALIMP5, SUM(D2_VALIMP6) VALIMP6 "
cQuery += "FROM " + retSqlName("SD2") + " SD2 "
cQuery += "INNER JOIN " + retSqlName("SF4") + " SF4 ON F4_FILIAL = '" + cFilAtu + "' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
cQuery += "WHERE D2_FILIAL = '" + cFilAtu + "' "
cQuery += "AND F4_DUPLIC = 'S' "
cQuery += "AND D2_COD = '" + cProduto + "' "
cQuery += "AND D2_EMISSAO BETWEEN '" + dIni + "' and '" + dFim + "' "
cQuery += "AND SD2.D_E_L_E_T_ = ' ' "

cQUERY := ChangeQuery(cQUERY)

If Select("TRBSD2") > 0
	TRBSD2->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBSD2"

dbSelectArea("TRBSD2")
dbGoTop()

If cTempo == "M"
	nSaiTotMes 	:= TRBSD2->TOTAL
	nLucBruto	:= (TRBSD2->CUSTO/(TRBSD2->VLTOTAL - TRBSD2->VALICM - TRBSD2->VALIPI - TRBSD2->VALIMP5 - TRBSD2->VALIMP6))
ElseIf cTempo == "A"
	nSaiTotAno 	:= TRBSD2->TOTAL
EndIf

If Select("TRBSD2") > 0
	TRBSD2->(dbCloseArea())
EndIf

restarea(aArea)

return


////////////////////////////////////////////////
//PREÇO DE VENDA
////////////////////////////////////////////////

Static Function Prcven(cProduto)

Local aArea 	:= getArea()
Local cQuery	:= ""
Local TRBDA1	:= {}
Local nPrcVen	:= 0

cQuery := "SELECT DA1_PRCVEN PRCVEN "
cQuery += "FROM " + retSqlName("DA1") + " DA1 "
cQuery += "WHERE DA1_CODPRO = '" + cProduto + "' "
cQuery += "AND DA1_ESTADO = '  ' "
cQuery += "AND DA1_DATVIG < '" + dtos(ddatabase) + "' "
cQuery += "AND DA1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY DA1_DATVIG DESC, DA1.R_E_C_N_O_ DESC "

cQUERY := ChangeQuery(cQUERY)

If Select("TRBDA1") > 0
	TRBDA1->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBDA1"

dbSelectArea("TRBDA1")
dbGoTop()

nPrcVen := TRBDA1->PRCVEN

If Select("TRBDA1") > 0
	TRBDA1->(dbCloseArea())
EndIf

restarea(aArea)

return(nPrcVen)


////////////////////////////////////////////////
//EMBARCADO
////////////////////////////////////////////////

Static Function Embdo(cProduto,cFilAtu)

Local aArea 	:= getArea()
Local cQuery	:= ""
Local TRBSC7	:= {}
Local nQtdEmbdo	:= 0

cQuery := "SELECT SUM(C7__QTEMBA) QTEMBA "
cQuery += "FROM " + retSqlName("SC7") + " SC7 "
cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = C7_FORNECE AND A1_LOJA = C7_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE C7_FILIAL = '" + cFilAtu + "' "
cQuery += "AND C7_PRODUTO = '" + cProduto + "' "
cQuery += "AND C7_RESIDUO <> 'S' "
cQuery += "AND C7_QUJE <> 0 "
cQuery += "AND C7_ENCER <> 'E' "
cQuery += "AND C7_QUANT <> C7_QUJE "
cQuery += "AND SC7.D_E_L_E_T_ = ' ' "
cQuery += "AND A1_EST = 'EX' "

cQUERY := ChangeQuery(cQUERY)

If Select("TRBSC7") > 0
	TRBSC7->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBSC7"

dbSelectArea("TRBSC7")
dbGoTop()

nQtdEmbdo := TRBSC7->QTEMBA

If Select("TRBSC7") > 0
	TRBSC7->(dbCloseArea())
EndIf

restarea(aArea)

return(nQtdEmbdo)


////////////////////////////////////////////////
//EMBARCAR
////////////////////////////////////////////////

Static Function Embarcar(cProduto,cFilAtu)

Local aArea 	:= getArea()
Local cQuery	:= ""
Local TRBSC7	:= {}
Local nEmbarcar	:= 0

cQuery := "SELECT (SUM(C7_QUANT) - SUM(C7_QUJE) - SUM(C7_QTDACLA) - SUM(C7__QTEMBA)) EMBARCAR "
cQuery += "FROM " + retSqlName("SC7") + " SC7 "
cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = C7_FORNECE AND A1_LOJA = C7_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE C7_FILIAL = '" + cFilAtu + "' "
cQuery += "AND C7_PRODUTO = '" + cProduto + "' "
cQuery += "AND C7_RESIDUO <> 'S' "
cQuery += "AND C7_QUJE <> 0 "
cQuery += "AND C7_ENCER <> 'E' "
cQuery += "AND C7_QUANT <> C7_QUJE "
cQuery += "AND SC7.D_E_L_E_T_ = ' ' "
cQuery += "AND A1_EST = 'EX' "

cQUERY := ChangeQuery(cQUERY)

If Select("TRBSC7") > 0
	TRBSC7->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBSC7"

dbSelectArea("TRBSC7")
dbGoTop()

nEmbarcar := TRBSC7->EMBARCAR

If Select("TRBSC7") > 0
	TRBSC7->(dbCloseArea())
EndIf

restarea(aArea)

return(nEmbarcar)
