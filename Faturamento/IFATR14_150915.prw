#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATR14				 	| 	Junho de 2015                                       |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi                                           |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Estatistica de Vendas de Representantes Acumulado                               |
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATR14()

Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Local nRet 			:= 0
Local oFont 		:= tFont():New("Tahoma",,12,,.t.)
Local _nLin			:= 0

Static oDlg

Private oGet1
Private oGet2
Private dDataRef	:= ddatabase
Private cLocalDe	:= space(2)
Private cLocalAte	:= Replicate('Z',TAMSX3("Z7_CODIGO")[1])
Private cRepresDe	:= PADR('0',TAMSX3("A3_COD")[1])//space(TAMSX3("A3_COD")[1])
Private cRepresAte	:= Replicate('9',TAMSX3("A3_COD")[1])
Private cSegDe		:= "1" //space(TAMSX3("Z7_CODIGO")[1])
Private cSegAte		:= "2" //Replicate('Z',TAMSX3("Z7_CODIGO")[1])
Private cOrigem		:= 1
Private cTipo		:= 1
Private _lOk		:= .T.
Private cEOL    	:= "CHR(13)+CHR(10)" //Final de Linha
Private oRadSub
Private oRadSub2

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

DEFINE MSDIALOG oDlg TITLE "Estatistica de Vendas de Representantes Acumulado" FROM 000, 000  TO 330, 400 COLORS 0, 16777215 PIXEL

//@ 010,006 GROUP oGroup1 TO 145, 298 PROMPT "Filtro" OF oDlg COLOR 0, 16777215 PIXEL
_nLin := 10

@ _nLin,015 SAY "Data de Referência" SIZE 60, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet dDataRef when .T. Picture "@D" Size 050,10 of oDlg PIXEL FONT oFont

_nLin := _nLin + 18

@ _nLin,015 SAY "Local" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin,065 SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet cLocalDe when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SM0" VALID(iif (empty(cLocalDe), .T., existCpo("SM0",cEmpAnt+cLocalDe)))
@ _nLin,130 SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,145 MsGet cLocalAte when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SM0" VALID(iif (empty(cLocalAte) .or. upper(cLocalAte) == "ZZ", .T., existCpo("SM0",cEmpAnt+cLocalAte)))

_nLin := _nLin + 18

@ _nLin,015 SAY "Segmento" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin,065 SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet cSegDe when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SZ72" VALID(iif (empty(cSegDe), .T., existCpo("SZ7",cSegDe)))
@ _nLin,130 SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,145 MsGet cSegAte when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SZ72" VALID(iif (empty(cSegAte) .or. upper(cSegAte) == "ZZ", .T., existCpo("SZ7",cSegAte)))

_nLin := _nLin + 18

@ _nLin,015 SAY "Origem" SIZE 20, 10 OF oDlg PIXEL //FONT oFont
//@ _nLin-1,080 MsGet cOrigem when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont
@ _nLin-1,080 RADIO	oRadSub 	  VAR cOrigem   Prompt OemToAnsi("CAC"), OemToAnsi("FAT") Size 090,008 of oDlg PIXEL

_nLin := _nLin + 18

@ _nLin,015 SAY "Tipo" SIZE 20, 10 OF oDlg PIXEL //FONT oFont
//@ _nLin-1,080 MsGet cOrigem when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont
@ _nLin-1,080 RADIO	oRadSub2 	  VAR cTipo   Prompt OemToAnsi("ANALITICO"), OemToAnsi("SINTETICO") Size 090,008 of oDlg PIXEL

_nLin := _nLin + 18

@ _nLin,015 SAY "Representante" SIZE 40, 10 OF oDlg PIXEL //FONT oFont
@ _nLin,065 SAY "De" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet cRepresDe when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SA3" //VALID(buscaRep(cRepresDe))
@ _nLin,130 SAY "Até" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,145 MsGet cRepresAte when .T. Picture "@!" Size 040,10 of oDlg PIXEL FONT oFont F3 "SA3" //VALID(buscaRep(cRepresAte))

_nLin := _nLin + 23

@ _nLin,080 BUTTON oButton1 PROMPT "Processar" SIZE 040, 012 OF oDlg PIXEL ACTION (MsAguarde({|| U_IFATR14A()},"Gerando Relatório..."))
@ _nLin,145 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

oRadSub:lHoriz 	:= .T.
oRadSub:bChange	:= {|| U_AtuOri2(cOrigem) }
oRadSub2:lHoriz 	:= .T.
oRadSub2:bChange	:= {|| U_AtuOri3(cTipo) }

ACTIVATE MSDIALOG oDlg CENTERED

Return


User Function IFATR14A()

If cTipo = 1
	U_IFATR14B()
ElseIf cTipo = 2
	U_IFATR14C()
EndIf

Return

//---------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------ANALITICO-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------

User Function IFATR14B()

Local aArea   	:= GetArea()
Local cQUERY	:= ""
Local xTEMP		:= {}
Local aFil		:= {}
Local _aStru1	:= {}
Local _cInd1	:= ""
Local cArqTrab 	:= ""
Local xSF2		:= {}
Local cOptions 	:= ""
Local cParams	:= ""
Local cUseId	:= __cUserId
Local dIniMes	:= Substr(dtos(dDataRef),1,6) + "01"
Local dRefMes   := dtos(dDataRef)
Local _lTem		:= .T.
Local cRepTran	:= ""
Local lDia		:= .F.

aTam := TamSX3("PAC_USER")
AADD(_aStru1,{"USUARIO"     ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VEND")
AADD(_aStru1,{"CODVEN"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_TIPO")
AADD(_aStru1,{"TIPO"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG02")
AADD(_aStru1,{"VLG02"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG03")
AADD(_aStru1,{"VLG03"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG04")
AADD(_aStru1,{"VLG04"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG14")
AADD(_aStru1,{"VLG14"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG05")
AADD(_aStru1,{"VLG05"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG06")
AADD(_aStru1,{"VLG06"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG08")
AADD(_aStru1,{"VLG08"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG18")
AADD(_aStru1,{"VLG18"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG01")
AADD(_aStru1,{"VLG01"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG07")
AADD(_aStru1,{"VLG07"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PAC_VLG17")
AADD(_aStru1,{"VLG17"     	,aTam[3],aTam[1],aTam[2]})

cArqTrab := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,cArqTrab,"xSF2",.t.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("xSF2",_cInd1,"USUARIO+CODVEN",,,"Selecionando Registros...")//PA5_FILIAL+PA5_USER+PA5_FIL+PA5_SEGISP

DbSelectArea("xSF2")

cRepTran := cRepresDe

If SUBSTR(cRepresDe,1,1) > SUBSTR(cRepresAte,1,1)
	cRepresDe 	:= cRepresAte
	cRepresAte	:= cRepTran
EndIf

If cOrigem == 1
	
	cQUERY := "SELECT TO_NUMBER(SF2.F2_VEND1) AS VENDEDOR,									" + Chr(13)
	cQUERY += "'D' AS TIPO,																	" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '2' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO2,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '3' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO3,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '4' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO4,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '14' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO14,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '5' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO5,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '6' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO6,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '8' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO8,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '18' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO18,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '1' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO1,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '7' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO7,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '17' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO17   												" + Chr(13)
	cQUERY += "FROM " + RetSqlName("SD2") + " SD2                                              " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL       " + Chr(13)
	cQUERY += "                         AND SF2.F2_DOC = SD2.D2_DOC                            " + Chr(13)
	cQUERY += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                        " + Chr(13)
	cQUERY += "                         AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                    " + Chr(13)
	cQUERY += "                         AND SF2.F2_LOJA = SD2.D2_LOJA                          " + Chr(13)
	cQUERY += "                         AND SF2.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_FILIAL = SD2.D2_FILIAL       " + Chr(13)
	cQUERY += "                         AND SC6.C6_NUM = SD2.D2_PEDIDO                         " + Chr(13)
	cQUERY += "                         AND SC6.C6_ITEM = SD2.D2_ITEMPV                        " + Chr(13)
	cQUERY += "                         AND SC6.C6_CLI = SD2.D2_CLIENTE                        " + Chr(13)
	cQUERY += "                         AND SC6.C6_LOJA = SD2.D2_LOJA                          " + Chr(13)
	cQUERY += "                         AND SC6.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SUB") + " SUB ON SUB.UB_FILIAL = SC6.C6_FILIAL       " + Chr(13)
	cQUERY += "                         AND SUB.UB_NUM = SC6.C6__TMKNUM                        " + Chr(13)
	cQUERY += "                         AND SUB.UB_ITEM = SC6.C6__TMKITE                       " + Chr(13)
	cQUERY += "                         AND SUB.UB_PRODUTO = SC6.C6_PRODUTO                    " + Chr(13)
	cQUERY += "                         AND SUB.UB_NUMPV = SC6.C6_NUM                          " + Chr(13)
	cQUERY += "                         AND SUB.UB_ITEMPV = SC6.C6_ITEM                        " + Chr(13)
	cQUERY += "                         AND SUB.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = SUB.UB_FILIAL       " + Chr(13)
	cQUERY += "                         AND SUA.UA_NUM = SUB.UB_NUM                            " + Chr(13)
	cQUERY += "                         AND SUA.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL       " + Chr(13)
	cQUERY += "                         AND SD2.D2_TES = SF4.F4_CODIGO                         " + Chr(13)
	cQUERY += "                         AND SF4.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '				   " + Chr(13)
	cQUERY += "							AND SB1.B1_COD = SC6.C6_PRODUTO      				   " + Chr(13)
	cQUERY += "							AND SB1.B1_GRUPO IN ('2','3','4','14','5','6','8','18', '1','7','17') " + Chr(13)	
	cQUERY += "                         AND SB1.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "WHERE SF2.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "'          " + Chr(13)
	cQUERY += "      AND SF2.F2_EMISSAO = '" + dRefMes + "'        							   " + Chr(13)
	cQUERY += "      AND TO_NUMBER(NVL(TRIM(SF2.F2_VEND1),'0')) BETWEEN TO_NUMBER(NVL(TRIM('" + Alltrim(cRepresDe) + "'),'0')) AND TO_NUMBER('" + cRepresAte + "')     " + Chr(13)
	cQUERY += "      AND SD2.D_E_L_E_T_ = ' '                                                  " + Chr(13)
	cQUERY += "      AND SF4.F4_DUPLIC = 'S'                                                   " + Chr(13)
	cQUERY += "      AND SB1.B1_TIPO IN ('CA','PN','PC')  								   	   " + Chr(13)
	cQUERY += "      AND SUA.UA__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "'         " + Chr(13)
	cQUERY += "GROUP BY       																   " + Chr(13)
	cQUERY += "      SF2.F2_VEND1 														  	   " + Chr(13)
	
	cQUERY += "UNION																		   " + Chr(13)
	
	cQUERY += "SELECT TO_NUMBER(SF2.F2_VEND1) AS VENDEDOR,									" + Chr(13)
	cQUERY += "'M' AS TIPO,																	" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '2' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO2,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '3' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO3,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '4' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO4,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '14' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO14,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '5' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO5,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '6' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO6,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '8' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO8,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '18' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO18,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '1' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO1,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '7' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO7,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '17' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO17   												" + Chr(13)
	cQUERY += "FROM " + RetSqlName("SD2") + " SD2                                              " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL       " + Chr(13)
	cQUERY += "                         AND SF2.F2_DOC = SD2.D2_DOC                            " + Chr(13)
	cQUERY += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                        " + Chr(13)
	cQUERY += "                         AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                    " + Chr(13)
	cQUERY += "                         AND SF2.F2_LOJA = SD2.D2_LOJA                          " + Chr(13)
	cQUERY += "                         AND SF2.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_FILIAL = SD2.D2_FILIAL       " + Chr(13)
	cQUERY += "                         AND SC6.C6_NUM = SD2.D2_PEDIDO                         " + Chr(13)
	cQUERY += "                         AND SC6.C6_ITEM = SD2.D2_ITEMPV                        " + Chr(13)
	cQUERY += "                         AND SC6.C6_CLI = SD2.D2_CLIENTE                        " + Chr(13)
	cQUERY += "                         AND SC6.C6_LOJA = SD2.D2_LOJA                          " + Chr(13)
	cQUERY += "                         AND SC6.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SUB") + " SUB ON SUB.UB_FILIAL = SC6.C6_FILIAL       " + Chr(13)
	cQUERY += "                         AND SUB.UB_NUM = SC6.C6__TMKNUM                        " + Chr(13)
	cQUERY += "                         AND SUB.UB_ITEM = SC6.C6__TMKITE                       " + Chr(13)
	cQUERY += "                         AND SUB.UB_PRODUTO = SC6.C6_PRODUTO                    " + Chr(13)
	cQUERY += "                         AND SUB.UB_NUMPV = SC6.C6_NUM                          " + Chr(13)
	cQUERY += "                         AND SUB.UB_ITEMPV = SC6.C6_ITEM                        " + Chr(13)
	cQUERY += "                         AND SUB.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = SUB.UB_FILIAL       " + Chr(13)
	cQUERY += "                         AND SUA.UA_NUM = SUB.UB_NUM                            " + Chr(13)
	cQUERY += "                         AND SUA.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL       " + Chr(13)
	cQUERY += "                         AND SD2.D2_TES = SF4.F4_CODIGO                         " + Chr(13)
	cQUERY += "                         AND SF4.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '				   " + Chr(13)
	cQUERY += "							AND SB1.B1_COD = SC6.C6_PRODUTO      				   " + Chr(13)
	cQUERY += "							AND SB1.B1_GRUPO IN ('2','3','4','14','5','6','8','18', '1','7','17') " + Chr(13)	
	cQUERY += "                         AND SB1.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "WHERE SF2.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "'          " + Chr(13)
	cQUERY += "      AND SF2.F2_EMISSAO BETWEEN '" + dIniMes + "' AND '" + dRefMes + "'        " + Chr(13)
	cQUERY += "      AND TO_NUMBER(NVL(TRIM(SF2.F2_VEND1),'0')) BETWEEN TO_NUMBER(NVL(TRIM('" + Alltrim(cRepresDe) + "'),'0')) AND TO_NUMBER('" + cRepresAte + "')     " + Chr(13)
	cQUERY += "      AND SD2.D_E_L_E_T_ = ' '                                                  " + Chr(13)
	cQUERY += "      AND SF4.F4_DUPLIC = 'S'                                                   " + Chr(13)
	cQUERY += "      AND SB1.B1_TIPO IN ('CA','PN','PC')  								   	   " + Chr(13)
	cQUERY += "      AND SUA.UA__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "'         " + Chr(13)
	cQUERY += "GROUP BY       																   " + Chr(13)
	cQUERY += "      SF2.F2_VEND1 														  	   " + Chr(13)
	cQUERY += "ORDER BY VENDEDOR, TIPO									      				   " + Chr(13)
	
Else
	
	cQUERY := "SELECT TO_NUMBER(SF2.F2_VEND1) AS VENDEDOR,									" + Chr(13)
	cQUERY += "'D' AS TIPO,																	" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '2' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO2,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '3' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO3,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '4' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO4,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '14' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO14,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '5' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO5,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '6' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO6,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '8' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO8,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '18' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO18,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '1' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO1,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '7' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO7,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '17' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO17   												" + Chr(13)
	cQUERY += "FROM " + RetSqlName("SD2") + " SD2                                              " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL       " + Chr(13)
	cQUERY += "                         AND SF2.F2_DOC = SD2.D2_DOC                            " + Chr(13)
	cQUERY += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                        " + Chr(13)
	cQUERY += "                         AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                    " + Chr(13)
	cQUERY += "                         AND SF2.F2_LOJA = SD2.D2_LOJA                          " + Chr(13)
	cQUERY += "                         AND SF2.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_FILIAL = SF2.F2_FILIAL 	   " + Chr(13)
	cQUERY += "                         AND SC5.C5_NUM = SD2.D2_PEDIDO 						   " + Chr(13)
	cQUERY += "                         AND SC5.C5_CLIENTE = SD2.D2_CLIENTE 				   " + Chr(13)
	cQUERY += "                         AND SC5.D_E_L_E_T_ = ' '             				   " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL       " + Chr(13)
	cQUERY += "                         AND SD2.D2_TES = SF4.F4_CODIGO                         " + Chr(13)
	cQUERY += "                         AND SF4.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '				   " + Chr(13)
	cQUERY += "							AND SB1.B1_COD = SD2.D2_COD 	     				   " + Chr(13)
	cQUERY += "							AND SB1.B1_GRUPO IN ('2','3','4','14','5','6','8','18', '1','7','17') " + Chr(13)	
	cQUERY += "                         AND SB1.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "WHERE SF2.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "' 		   " + Chr(13)
	cQUERY += "	     AND SF2.F2_EMISSAO BETWEEN '" + dIniMes + "' AND '" + dRefMes + "' 	   " + Chr(13)
	cQUERY += "      AND TO_NUMBER(TRIM(SF2.F2_VEND1)) BETWEEN TO_NUMBER(NVL('" + Alltrim(cRepresDe) + "','0')) AND TO_NUMBER('" + cRepresAte + "')     " + Chr(13)
	cQUERY += "	     AND F4_DUPLIC = 'S' 													   " + Chr(13)
	cQUERY += "      AND SB1.B1__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "' 		   " + Chr(13)
	cQUERY += "      AND SB1.B1_TIPO IN ('CA','PN','PC') 		   							   " + Chr(13)
	cQUERY += "		 AND SC5.C5__NUMSUA = '        ' 										   " + Chr(13)
	cQUERY += "		 AND (SF2.F2_TIPO <> 'B' AND SF2.F2_TIPO <> 'D') 						   " + Chr(13)
	cQUERY += "GROUP BY       																   " + Chr(13)
	cQUERY += "      SF2.F2_VEND1 														  	   " + Chr(13)
	
	cQUERY += "UNION																		   " + Chr(13)
	
	cQUERY += "SELECT TO_NUMBER(SF2.F2_VEND1) AS VENDEDOR,									" + Chr(13)
	cQUERY += "'M' AS TIPO,																	" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '2' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO2,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '3' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += "		ELSE 0 END) AS GRUPO3,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '4' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO4,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '14' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO14,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '5' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO5,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '6' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO6,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '8' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO8,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '18' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO18,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '1' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO1,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '7' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI)			" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO7,													" + Chr(13)
	cQUERY += "SUM(CASE WHEN SB1.B1_GRUPO = '17' THEN (SD2.D2_TOTAL + SD2.D2_VALIPI) 		" + Chr(13)
	cQUERY += " 	ELSE 0 END) AS GRUPO17   												" + Chr(13)
	cQUERY += "FROM " + RetSqlName("SD2") + " SD2                                              " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL       " + Chr(13)
	cQUERY += "                         AND SF2.F2_DOC = SD2.D2_DOC                            " + Chr(13)
	cQUERY += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                        " + Chr(13)
	cQUERY += "                         AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                    " + Chr(13)
	cQUERY += "                         AND SF2.F2_LOJA = SD2.D2_LOJA                          " + Chr(13)
	cQUERY += "                         AND SF2.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_FILIAL = SF2.F2_FILIAL 	   " + Chr(13)
	cQUERY += "                         AND SC5.C5_NUM = SD2.D2_PEDIDO 						   " + Chr(13)
	cQUERY += "                         AND SC5.C5_CLIENTE = SD2.D2_CLIENTE 				   " + Chr(13)
	cQUERY += "                         AND SC5.D_E_L_E_T_ = ' '             				   " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL       " + Chr(13)
	cQUERY += "                         AND SD2.D2_TES = SF4.F4_CODIGO                         " + Chr(13)
	cQUERY += "                         AND SF4.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '				   " + Chr(13)
	cQUERY += "							AND SB1.B1_COD = SD2.D2_COD      				   	   " + Chr(13)
	cQUERY += "							AND SB1.B1_GRUPO IN ('2','3','4','14','5','6','8','18', '1','7','17') " + Chr(13)	
	cQUERY += "                         AND SB1.D_E_L_E_T_ = ' '                               " + Chr(13)
	cQUERY += "WHERE SF2.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "' 		   " + Chr(13)
	cQUERY += "	     AND SF2.F2_EMISSAO =  '" + dRefMes + "' 	   							   " + Chr(13)
	cQUERY += "      AND TO_NUMBER(TRIM(SF2.F2_VEND1)) BETWEEN TO_NUMBER(NVL('" + Alltrim(cRepresDe) + "','0')) AND TO_NUMBER('" + cRepresAte + "')     " + Chr(13)
	cQUERY += "	     AND F4_DUPLIC = 'S' 													   " + Chr(13)
	cQUERY += "      AND SB1.B1__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "' 		   " + Chr(13)
	cQUERY += "      AND SB1.B1_TIPO IN ('CA','PN','PC') 		   							   " + Chr(13)
	cQUERY += "		 AND SC5.C5__NUMSUA = '        ' 										   " + Chr(13)
	cQUERY += "		 AND (SF2.F2_TIPO <> 'B' AND SF2.F2_TIPO <> 'D') 						   " + Chr(13)
	cQUERY += "GROUP BY       																   " + Chr(13)
	cQUERY += "      SF2.F2_VEND1 														  	   " + Chr(13)
	cQUERY += "ORDER BY VENDEDOR, TIPO									      				   " + Chr(13)
	
EndIf

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

dbSelectArea("xTEMP")
dbGoTop()

While !Eof()
	
	DbSelectArea("xSF2")
	
	If  xTEMP->TIPO == "D"
		
		While !RecLock("xSF2",.T.)
		Enddo
		xSF2->USUARIO	:= cUseId
		xSF2->TIPO		:= xTEMP->TIPO
		xSF2->CODVEN    := Alltrim(Str(xTEMP->VENDEDOR))
		xSF2->VLG02		:= xTEMP->GRUPO2
		xSF2->VLG03		:= xTEMP->GRUPO3
		xSF2->VLG04		:= xTEMP->GRUPO4
		xSF2->VLG14		:= xTEMP->GRUPO14
		xSF2->VLG05		:= xTEMP->GRUPO5
		xSF2->VLG06		:= xTEMP->GRUPO6
		xSF2->VLG08		:= xTEMP->GRUPO8
		xSF2->VLG18		:= xTEMP->GRUPO18
		xSF2->VLG01 	:= xTEMP->GRUPO1
		xSF2->VLG07		:= xTEMP->GRUPO7
		xSF2->VLG17 	:= xTEMP->GRUPO17
		lDia := .T.
		xSF2->(MsUnLock())
		
	ElseIf xTEMP->TIPO == "M" .And. lDia
		
		While !RecLock("xSF2",.T.)
		Enddo
		xSF2->USUARIO	:= cUseId
		xSF2->TIPO		:= xTEMP->TIPO
		xSF2->CODVEN    := Alltrim(Str(xTEMP->VENDEDOR))
		xSF2->VLG02		:= xTEMP->GRUPO2
		xSF2->VLG03		:= xTEMP->GRUPO3
		xSF2->VLG04		:= xTEMP->GRUPO4
		xSF2->VLG14		:= xTEMP->GRUPO14
		xSF2->VLG05		:= xTEMP->GRUPO5
		xSF2->VLG06		:= xTEMP->GRUPO6
		xSF2->VLG08		:= xTEMP->GRUPO8
		xSF2->VLG18		:= xTEMP->GRUPO18
		xSF2->VLG01 	:= xTEMP->GRUPO1
		xSF2->VLG07		:= xTEMP->GRUPO7
		xSF2->VLG17 	:= xTEMP->GRUPO17
		lDia := .F.
		xSF2->(MsUnLock())
		
	ElseIf xTEMP->TIPO == "M" .And. !lDia
		
		While !RecLock("xSF2",.T.)
		Enddo
		xSF2->USUARIO	:= cUseId
		xSF2->TIPO		:= "D"
		xSF2->CODVEN    := Alltrim(Str(xTEMP->VENDEDOR))
		xSF2->VLG02		:= 0
		xSF2->VLG03		:= 0
		xSF2->VLG04		:= 0
		xSF2->VLG14		:= 0
		xSF2->VLG05		:= 0
		xSF2->VLG06		:= 0
		xSF2->VLG08		:= 0
		xSF2->VLG18		:= 0
		xSF2->VLG01 	:= 0
		xSF2->VLG07		:= 0
		xSF2->VLG17 	:= 0
		xSF2->(MsUnLock())
		
		While !RecLock("xSF2",.T.)
		Enddo
		xSF2->USUARIO	:= cUseId
		xSF2->TIPO		:= xTEMP->TIPO
		xSF2->CODVEN    := Alltrim(Str(xTEMP->VENDEDOR))
		xSF2->VLG02		:= xTEMP->GRUPO2
		xSF2->VLG03		:= xTEMP->GRUPO3
		xSF2->VLG04		:= xTEMP->GRUPO4
		xSF2->VLG14		:= xTEMP->GRUPO14
		xSF2->VLG05		:= xTEMP->GRUPO5
		xSF2->VLG06		:= xTEMP->GRUPO6
		xSF2->VLG08		:= xTEMP->GRUPO8
		xSF2->VLG18		:= xTEMP->GRUPO18
		xSF2->VLG01 	:= xTEMP->GRUPO1
		xSF2->VLG07		:= xTEMP->GRUPO7
		xSF2->VLG17 	:= xTEMP->GRUPO17
		lDia := .F.
		xSF2->(MsUnLock())
		
	EndIf
	
	DbSelectArea("xTEMP")
	DbSkip()
	
EndDo

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

IF TcCanOpen(RetSqlName("PAC"))
	cQuery := " DELETE "+RetSqlName("PAC")
	cQuery += " WHERE PAC_USER = '"+cUseId+"' "
	TCSqlExec(cQuery)
ENDIF

DbSelectArea("xSF2")
DbGoTop()

If Empty(xSF2->CODVEN)
	_lOk := .F.
EndIf

While !EOf()
	
	While !RecLock("PAC",.t.)
	Enddo
	
	PAC_USER	:= xSF2->USUARIO
	PAC_VEND	:= xSF2->CODVEN
	PAC_TIPO	:= xSF2->TIPO
	PAC_VLG02	:= xSF2->VLG02
	PAC_VLG03	:= xSF2->VLG03
	PAC_VLG04 	:= xSF2->VLG04
	PAC_VLG14 	:= xSF2->VLG14
	PAC_VLG05 	:= xSF2->VLG05
	PAC_VLG06	:= xSF2->VLG06
	PAC_VLG08	:= xSF2->VLG08
	PAC_VLG18 	:= xSF2->VLG18
	PAC_VLG01 	:= xSF2->VLG01
	PAC_VLG07 	:= xSF2->VLG07
	PAC_VLG17	:= xSF2->VLG17
	MsUnLock()
	
	DbSelectArea("xSF2")
	DbSkip()
	
EndDo

If Select("xSF2") > 0
	xSF2->(dbCloseArea())
EndIf

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

If _lOk
	
	cOptions 	:= "1;0;1;Estatistica de Vendas de Representantes Acumulado" // 1(visualiza tela) 2 (direto impressora) 6(pdf) ; 0 (atualiza dados) ; 1 (número de cópias)
	
	cParams := cUseId 		   		+ ";"		//Usuário
	cParams += DTOS(dDataRef)  		+ ";"		//Data Referência
	cParams += DtoS(StoD(dIniMes))  + ";"		//Data dIniMes
	cParams += cLocalDe 	   		+ ";" 		//Local De?
	cParams += cLocalAte 	   		+ ";" 		//Local Ate
	cParams += Alltrim(cRepresDe) 	+ ";"		//Representante De
	cParams += cRepresAte 	   		+ ";"	    //Representante Ate
	cParams += Alltrim(cSegDe) 		+ ";"		//Segmento De
	cParams += Alltrim(cSegAte) 			    //Segmento Ate
	
	CallCrys("IFATCR14",cParams,cOptions)
	
	//oDlg:End()
	
Else
	
	msgAlert (	"Nenhuma Informação de acordo com " + cEOL +;
	"os parâmetros informados !!")
	
EndIf

RestArea(aArea)


Return Nil

////////////////////////////////////////////////
//Representante
////////////////////////////////////////////////

static function buscaRep(cRepres)

Local aArea 	:= getArea()

dbSelectArea("SA3")
dbSetOrder(1)

If !dbSeek(xFilial("SA3")+cRepres) .and. !empty(cRepres) .and. !(upper(cRepres) $ "ZZZZZZ") .and. !(cRepres $ '99999999')
	msgAlert ("Representante não encontrado !!")
	return .F.
endif

restarea(aArea)


return .T.


User Function AtuOri2()

oRadSub:Refresh()
oDlg:Refresh()

Return(.t.)

User Function AtuOri3()

oRadSub2:Refresh()
oDlg:Refresh()

Return(.t.)

//---------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------SINTETICO-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------

User Function IFATR14C()

Local aArea   	:= GetArea()
Local cQUERY	:= ""
Local xTEMP		:= {}
Local aFil		:= {}
Local _aStru1	:= {}
Local _cInd1	:= ""
Local cArqTrab 	:= ""
Local xSF2		:= {}
Local cOptions 	:= ""
Local cParams	:= ""
Local cUseId	:= __cUserId
Local dIniMes	:= Substr(dtos(dDataRef),1,6) + "01"
Local dRefMes   := dtos(dDataRef)
Local _lTem		:= .T.
Local cRepTran	:= ""

aTam := TamSX3("PA5_USER")
AADD(_aStru1,{"USUARIO"     ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_FIL")
AADD(_aStru1,{"FILIAL"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_NOMFIL")
AADD(_aStru1,{"NOMFIL"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_SEGISP")
AADD(_aStru1,{"CODSEG"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_DESCSE")
AADD(_aStru1,{"DESCSEG"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_VALMER")
AADD(_aStru1,{"VALMER"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_VALIPI")
AADD(_aStru1,{"VALIPI"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_FRETE")
AADD(_aStru1,{"FRETE"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_DESCON")
AADD(_aStru1,{"DESCONTO"   	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_VALBRU")
AADD(_aStru1,{"VALBRU"     ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_ICMSRE")
AADD(_aStru1,{"ICMSRE"	    ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_BRINDE")
AADD(_aStru1,{"BRINDE"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_PARTIC")
AADD(_aStru1,{"PARTIC"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_VLMEME")
AADD(_aStru1,{"VLMEME"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_VIPIME")
AADD(_aStru1,{"VIPIME"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_DESCME")
AADD(_aStru1,{"DESCME"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_FRETME")
AADD(_aStru1,{"FRETME"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_VLBUME")
AADD(_aStru1,{"VLBUME"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_ICREME")
AADD(_aStru1,{"ICREME"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("PA5_BRINME")
AADD(_aStru1,{"BRINME"     	,aTam[3],aTam[1],aTam[2]})

cArqTrab := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,cArqTrab,"xSF2",.t.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("xSF2",_cInd1,"USUARIO+FILIAL+CODSEG",,,"Selecionando Registros...")//PA5_FILIAL+PA5_USER+PA5_FIL+PA5_SEGISP

DbSelectArea("xSF2")

cRepTran := cRepresDe

If SUBSTR(cRepresDe,1,1) > SUBSTR(cRepresAte,1,1)
	cRepresDe 	:= cRepresAte
	cRepresAte	:= cRepTran
EndIf

For i := 1 to 2
	
	If cOrigem == 1
		
		cQUERY := "SELECT SF2.F2_FILIAL FILIAL,                                                    " + Chr(13)
		cQUERY += "       SF2.F2_DOC,                                                              " + Chr(13)
		cQUERY += "       SF2.F2_SERIE,                                                            " + Chr(13)
		cQUERY += "       SUA.UA__SEGISP SEGISP,                                                   " + Chr(13)
		cQUERY += "       (SF2.F2_VALBRUT - SF2.F2_DESCONT) AS TOTSEG,                             " + Chr(13)
		cQUERY += "       SF2.F2_FRETE FRETE,                                                      " + Chr(13)
		cQUERY += "       SF2.F2_DESCONT DESCONTO,                                                 " + Chr(13)
		cQUERY += "       SF2.F2_VALIPI VALIPI,                                                    " + Chr(13)
		cQUERY += "       SUM(SD2.D2_ICMSRET) ICMSST,                                              " + Chr(13)
		cQUERY += "       SUM(SD2.D2_TOTAL + SD2.D2_VALIPI) AS PRODIPI                             " + Chr(13)
		cQUERY += "FROM " + RetSqlName("SF2") + " SF2                                              " + Chr(13)
		cQUERY += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON SF2.F2_FILIAL = SD2.D2_FILIAL       " + Chr(13)
		cQUERY += "                         AND SF2.F2_DOC = SD2.D2_DOC                            " + Chr(13)
		cQUERY += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                        " + Chr(13)
		cQUERY += "                         AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                    " + Chr(13)
		cQUERY += "                         AND SF2.F2_LOJA = SD2.D2_LOJA                          " + Chr(13)
		cQUERY += "                         AND SD2.D_E_L_E_T_ = ' '                               " + Chr(13)
		cQUERY += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_FILIAL = SD2.D2_FILIAL       " + Chr(13)
		cQUERY += "                         AND SC6.C6_NUM = SD2.D2_PEDIDO                         " + Chr(13)
		cQUERY += "                         AND SC6.C6_ITEM = SD2.D2_ITEMPV                        " + Chr(13)
		cQUERY += "                         AND SC6.C6_CLI = SD2.D2_CLIENTE                        " + Chr(13)
		cQUERY += "                         AND SC6.C6_LOJA = SD2.D2_LOJA                          " + Chr(13)
		cQUERY += "                         AND SC6.D_E_L_E_T_ = ' '                               " + Chr(13)
		cQUERY += "INNER JOIN " + RetSqlName("SUB") + " SUB ON SUB.UB_FILIAL = SC6.C6_FILIAL       " + Chr(13)
		cQUERY += "                         AND SUB.UB_NUM = SC6.C6__TMKNUM                        " + Chr(13)
		cQUERY += "                         AND SUB.UB_ITEM = SC6.C6__TMKITE                       " + Chr(13)
		cQUERY += "                         AND SUB.UB_PRODUTO = SC6.C6_PRODUTO                    " + Chr(13)
		cQUERY += "                         AND SUB.UB_NUMPV = SC6.C6_NUM                          " + Chr(13)
		cQUERY += "                         AND SUB.UB_ITEMPV = SC6.C6_ITEM                        " + Chr(13)
		cQUERY += "                         AND SUB.D_E_L_E_T_ = ' '                               " + Chr(13)
		cQUERY += "INNER JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = SUB.UB_FILIAL       " + Chr(13)
		cQUERY += "                         AND SUA.UA_NUM = SUB.UB_NUM                            " + Chr(13)
		cQUERY += "                         AND SUA.D_E_L_E_T_ = ' '                               " + Chr(13)
		cQUERY += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL       " + Chr(13)
		cQUERY += "                         AND SD2.D2_TES = SF4.F4_CODIGO                         " + Chr(13)
		cQUERY += "                         AND SF4.D_E_L_E_T_ = ' '                               " + Chr(13)
		cQUERY += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '				   " + Chr(13)
		cQUERY += "							AND SB1.B1_COD = SC6.C6_PRODUTO      				   " + Chr(13)
		cQUERY += "                         AND SB1.D_E_L_E_T_ = ' '                               " + Chr(13)
		cQUERY += "							AND SB1.B1_GRUPO IN ('2','3','4','14','5','6','8','18', '1','7','17') " + Chr(13) // FILTRA GRUPO CONFORME SOLICITADO PELO MARCELO
		cQUERY += "WHERE SF2.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "'          " + Chr(13)
		cQUERY += "      AND SF2.F2_EMISSAO BETWEEN '" + dIniMes + "' AND '" + dRefMes + "'        " + Chr(13)
		//		cQUERY += "      AND TO_NUMBER(TRIM(SF2.F2_VEND1)) BETWEEN TO_NUMBER(NVL('" + Alltrim(cRepresDe) + "','0')) AND TO_NUMBER('" + cRepresAte + "')     " + Chr(13)
		cQUERY += "      AND TO_NUMBER(NVL(TRIM(SF2.F2_VEND1),'0')) BETWEEN TO_NUMBER(NVL(TRIM('" + Alltrim(cRepresDe) + "'),'0')) AND TO_NUMBER('" + cRepresAte + "')     " + Chr(13)
		cQUERY += "      AND SF2.D_E_L_E_T_ = ' '                                                  " + Chr(13)
		cQUERY += "      AND SF4.F4_DUPLIC = 'S'                                                   " + Chr(13)
		cQUERY += "      AND SB1.B1_TIPO IN ('CA','PN','PC')  								   	   " + Chr(13)
		cQUERY += "      AND SUA.UA__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "'         " + Chr(13)
		cQUERY += "GROUP BY SF2.F2_FILIAL,                                                         " + Chr(13)
		cQUERY += "       SF2.F2_DOC,                                                              " + Chr(13)
		cQUERY += "       SF2.F2_SERIE,                                                            " + Chr(13)
		cQUERY += "       SUA.UA__SEGISP,                                                          " + Chr(13)
		cQUERY += "       SF2.F2_VALBRUT,                                                          " + Chr(13)
		cQUERY += "       SF2.F2_DESCONT,                                                          " + Chr(13)
		cQUERY += "       SF2.F2_FRETE,                                                            " + Chr(13)
		cQUERY += "       SF2.F2_DESCONT,                                                          " + Chr(13)
		cQUERY += "       SF2.F2_VALIPI                                                            "
		
	Else
		
		cQUERY := "SELECT DISTINCT SF2.F2_FILIAL FILIAL,SF2.F2_DOC, SF2.F2_SERIE, B1__SEGISP SEGISP, (SF2.F2_VALBRUT - B.F2DESCONT) TOTSEG, B.F2FRETE FRETE, "
		cQUERY += "B.F2DESCONT DESCONTO, B.F2VALIPI VALIPI ,SUM(D2_ICMSRET) ICMSST, SUM(D2_TOTAL + D2_VALIPI) PRODIPI "
		cQUERY += "FROM " + RetSqlName("SF2") + " SF2 "
		cQUERY += "INNER JOIN ( "
		cQUERY += "SELECT DISTINCT X.F2_FILIAL, X.F2_DOC ,X.F2_SERIE ,SUM(SD2a.D2_TOTAL + SD2a.D2_VALIPI) F2VALBRUT, X.F2_FRETE F2FRETE, X.F2_DESCONT F2DESCONT, SUM(SD2a.D2_VALIPI) F2VALIPI  "
		cQUERY += "FROM " + RetSqlName("SF2") + " X "
		cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2a ON X.F2_FILIAL = SD2a.D2_FILIAL AND X.F2_DOC = SD2a.D2_DOC AND X.F2_SERIE = SD2a.D2_SERIE AND SD2a.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4a ON SD2a.D2_FILIAL = SF4a.F4_FILIAL AND SD2a.D2_TES = SF4a.F4_CODIGO AND SF4a.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5a ON SC5a.C5_FILIAL = X.F2_FILIAL AND SC5a.C5_NUM = SD2a.D2_PEDIDO AND SC5a.C5_CLIENTE = SD2a.D2_CLIENTE AND SC5a.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1a ON SD2a.D2_COD = SB1a.B1_COD AND SB1a.D_E_L_E_T_ = ' ' "
		cQUERY += "WHERE X.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "' "
		cQUERY +=       "AND X.F2_EMISSAO BETWEEN '" + dIniMes + "' AND '" + dRefMes + "' "
		cQUERY +=       "AND X.F2_VEND1 BETWEEN '" + cRepresDe + "' AND '" + cRepresAte + "' And X.D_E_L_E_T_ = ' ' "
		cQUERY +=       "AND SF4a.F4_DUPLIC = 'S' "
		//		cQUERY +=       "AND SB1a.B1__SEGISP <> ' ' "
		cQUERY +=       "AND SB1a.B1__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "' "
		cQUERY +=       "AND SC5a.C5__NUMSUA = '        ' "
		cQUERY +=       "AND (X.F2_TIPO <> 'B' AND X.F2_TIPO <> 'D') "
		cQUERY += "GROUP BY X.F2_FILIAL, X.F2_DOC, X.F2_SERIE, F2_FRETE, F2_DESCONT "
		cQUERY += ") B ON B.F2_FILIAL = SF2.F2_FILIAL And B.F2_DOC = SF2.F2_DOC And B.F2_SERIE = SF2.F2_SERIE "
		cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_FILIAL = SF2.F2_FILIAL AND SC5.C5_NUM = SD2.D2_PEDIDO AND SC5.C5_CLIENTE = SD2.D2_CLIENTE AND SC5.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
		cQUERY += "WHERE SF2.F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "' "
		cQUERY +=       "AND SF2.F2_EMISSAO BETWEEN '" + dIniMes + "' AND '" + dRefMes + "' "
		//		cQUERY +=       "AND SF2.F2_VEND1 BETWEEN '" + cRepresDe + "' AND '" + cRepresAte + "' "
		cQUERY += 		"And SF2.D_E_L_E_T_ = ' ' "
		cQUERY += "      AND TO_NUMBER(NVL(TRIM(SF2.F2_VEND1),'0')) BETWEEN TO_NUMBER(NVL(TRIM('" + Alltrim(cRepresDe) + "'),'0')) AND TO_NUMBER('" + cRepresAte + "')     "
		cQUERY +=       "AND F4_DUPLIC = 'S' "
		cQUERY +=       "AND SB1.B1__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "' "
		cQUERY +=       "AND SC5.C5__NUMSUA = '        ' "
		cQUERY +=       "AND (SF2.F2_TIPO <> 'B' AND SF2.F2_TIPO <> 'D') "
		cQUERY += "GROUP BY SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, B1__SEGISP, SF2.F2_VALBRUT, B.F2FRETE, B.F2DESCONT, B.F2VALIPI "
		cQUERY += "ORDER BY SF2.F2_FILIAL, B1__SEGISP "
		
	EndIf
	
	If Select("xTEMP") > 0
		xTEMP->(dbCloseArea())
	EndIf
	
	//	cQUERY := ChangeQuery(cQUERY)
	
	TcQuery cQUERY New Alias "xTEMP"
	
	cQUERY	:= ""
	
	dbSelectArea("xTEMP")
	dbGoTop()
	
	If i == 1
		
		While !Eof()
			
			DbSelectArea("xSF2")
			dbSetOrder(1)
			If !(DbSeek(cUseId+xTEMP->FILIAL+xTEMP->SEGISP))
				
				While !RecLock("xSF2",.T.)
				Enddo
				xSF2->USUARIO	:= cUseId
				xSF2->FILIAL	:= xTEMP->FILIAL
				xSF2->NOMFIL	:= Posicione("SZE",1,cEmpAnt+xTEMP->FILIAL,"ZE_FILIAL")
				xSF2->CODSEG 	:= xTEMP->SEGISP
				xSF2->DESCSEG	:= Posicione("SZ7",1,xFilial("SZ7")+xTEMP->SEGISP,"Z7_DESCRIC")
				xSF2->VLMEME	:= xTEMP->PRODIPI
				xSF2->VIPIME	:= xTEMP->VALIPI
				xSF2->FRETME	:= xTEMP->FRETE
				xSF2->DESCME	:= xTEMP->DESCONTO
				xSF2->VLBUME	:= xTEMP->PRODIPI + xTEMP->FRETE + xTEMP->ICMSST - xTEMP->DESCONTO//xTEMP->TOTSEG
				xSF2->ICREME	:= xTEMP->ICMSST
				MsUnLock()
			Else
				While !RecLock("xSF2",.F.)
				Enddo
				xSF2->VLMEME	+= xTEMP->PRODIPI
				xSF2->VIPIME	+= xTEMP->VALIPI
				xSF2->FRETME	+= xTEMP->FRETE
				xSF2->DESCME	+= xTEMP->DESCONTO
				xSF2->VLBUME	+= xTEMP->PRODIPI + xTEMP->FRETE + xTEMP->ICMSST - xTEMP->DESCONTO//xTEMP->TOTSEG
				xSF2->ICREME	+= xTEMP->ICMSST
				MsUnLock()
				
			EndIf
			
			DbSelectArea("xTEMP")
			DbSkip()
			
		EndDo
		
	Else
		
		While !Eof()
			
			DbSelectArea("xSF2")
			dbSetOrder(1)
			If DbSeek(cUseId+xTEMP->FILIAL+xTEMP->SEGISP)
				
				While !RecLock("xSF2",.f.)
				Enddo
				
				xSF2->VALMER	+= xTEMP->PRODIPI
				xSF2->VALIPI	+= xTEMP->VALIPI
				xSF2->FRETE		+= xTEMP->FRETE
				xSF2->DESCONTO	+= xTEMP->DESCONTO
				xSF2->VALBRU	+= xTEMP->PRODIPI + xTEMP->FRETE + xTEMP->ICMSST - xTEMP->DESCONTO//xTEMP->TOTSEG
				xSF2->ICMSRE	+= xTEMP->ICMSST
				
				MsUnLock()
				
			EndIf
			
			DbSelectArea("xTEMP")
			DbSkip()
			
		EndDo
		
	EndIf
	
	If Select("xTEMP") > 0
		xTEMP->(dbCloseArea())
	EndIf
	
	//Localiza o valor do brinde
	
	If cOrigem == 1
		
		cQUERY := "SELECT DISTINCT F2_FILIAL FILIAL, F2_DOC,F2_SERIE, F2_CLIENTE, F2_LOJA, UA__SEGISP SEGISP, SUM(F2_VALMERC) BRINDE "
		cQUERY += "FROM " + RetSqlName("SF2") + " SF2 "
		cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON C5_FILIAL = F2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE AND SC5.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SUA") + " SUA ON C5_FILIAL = UA_FILIAL AND C5_NUM = UA_NUMSC5 AND SUA.D_E_L_E_T_ = ' ' "
		cQuery += "INNER JOIN " + RetSqlName("SZF") + " SZF On ZF_FILIAL = '" + xFilial("SZF") + "' And ZF_COD = UA__TIPPED And SZF.D_E_L_E_T_ = ' ' "
		cQUERY += "WHERE F2_FILIAL BETWEEN '" + cLocalDe + "' AND '" + cLocalAte + "' "
		cQUERY += "AND F2_EMISSAO BETWEEN '" + dIniMes + "' AND '" + dRefMes + "' "
		cQUERY += "AND UA__SEGISP BETWEEN '" + cSegDe + "' AND '" + cSegAte + "' "
		cQUERY += "AND F2_VEND1 BETWEEN '" + cRepresDe + "' AND '" + cRepresAte + "' "
		cQUERY += "And SF2.D_E_L_E_T_ = ' ' And ZF_BRINDE = '6' "
		cQUERY += "AND TO_NUMBER(NVL(TRIM(SF2.F2_VEND1),'0')) BETWEEN TO_NUMBER(NVL(TRIM('" + Alltrim(cRepresDe) + "'),'0')) AND TO_NUMBER('" + cRepresAte + "')     "
		cQUERY += "GROUP BY F2_FILIAL, F2_DOC,F2_SERIE, F2_CLIENTE, F2_LOJA, UA__SEGISP "
		
		If Select("xTEMP") > 0
			xTEMP->(dbCloseArea())
		EndIf
		
		cQUERY := ChangeQuery(cQUERY)
		
		TcQuery cQUERY New Alias "xTEMP"
		
		cQUERY	:= ""
		
		dbSelectArea("xTEMP")
		dbGoTop()
		
		If i == 1
			
			While !Eof()
				
				DbSelectArea("xSF2")
				dbSetOrder(1)
				If DbSeek(cUseId+xTEMP->FILIAL+xTEMP->SEGISP)
					
					While !RecLock("xSF2",.F.)
					Enddo
					xSF2->BRINME	+= xTEMP->BRINDE
					MsUnLock()
					
				EndIf
				
				DbSelectArea("xTEMP")
				DbSkip()
				
			EndDo
			
		Else
			
			While !Eof()
				
				DbSelectArea("xSF2")
				dbSetOrder(1)
				If DbSeek(cUseId+xTEMP->FILIAL+xTEMP->SEGISP)
					
					While !RecLock("xSF2",.F.)
					Enddo
					xSF2->BRINDE	+= xTEMP->BRINDE
					MsUnLock()
					
				EndIf
				
				DbSelectArea("xTEMP")
				DbSkip()
				
			EndDo
			
		EndIf
		
	EndIf
	
	dIniMes := DTOS(dDataRef)
	dRefMes := DTOS(dDataRef)
	
Next

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

IF TcCanOpen(RetSqlName("PA5"))
	cQuery := " DELETE "+RetSqlName("PA5")
	cQuery += " WHERE PA5_FILIAL = '"+xFilial("PA5")+"' "
	cQuery += " AND PA5_USER = '"+cUseId+"' "
	TCSqlExec(cQuery)
ENDIF

DbSelectArea("xSF2")
DbGoTop()

If Empty(xSF2->FILIAL)
	_lOk := .F.
EndIf

While !EOf()
	
	While !RecLock("PA5",.t.)
	Enddo
	
	PA5_USER	:= xSF2->USUARIO
	PA5_FIL		:= xSF2->FILIAL
	PA5_NOMFIL	:= xSF2->NOMFIL
	PA5_SEGISP	:= xSF2->CODSEG
	PA5_VALMER	:= xSF2->VALMER
	PA5_VALIPI 	:= xSF2->VALIPI
	PA5_FRETE 	:= xSF2->FRETE
	PA5_DESCON 	:= xSF2->DESCONTO
	PA5_VALBRU	:= xSF2->VALBRU //- xSF2->DESCONTO - xSF2->BRINDE
	PA5_ICMSRE	:= xSF2->ICMSRE
	PA5_BRINDE 	:= xSF2->BRINDE
	PA5_PARTIC 	:= 0
	PA5_DESCSE 	:= xSF2->DESCSEG
	PA5_VLMEME	:= xSF2->VLMEME
	PA5_VIPIME	:= xSF2->VIPIME
	PA5_FRETME	:= xSF2->FRETME
	PA5_DESCME	:= xSF2->DESCME
	PA5_VLBUME	:= xSF2->VLBUME
	PA5_ICREME	:= xSF2->ICREME
	PA5_BRINME	:= xSF2->BRINME
	
	MsUnLock()
	
	DbSelectArea("xSF2")
	DbSkip()
	
EndDo

If Select("xSF2") > 0
	xSF2->(dbCloseArea())
EndIf

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

If _lOk
	
	cOptions 	:= "1;0;1;Resumo de Vendas de Representantes Acumulado" // 1(visualiza tela) 2 (direto impressora) 6(pdf) ; 0 (atualiza dados) ; 1 (número de cópias)
	
	cParams := cUseId 			+ ";"		//Usuário
	cParams += DTOC(dDataRef) 	+ ";" 		//Data Referência
	cParams += cLocalDe 		+ ";" 		//Local De?
	cParams += cLocalAte 		+ ";" 		//Local Ate
	cParams += cRepresDe 		+ ";"		//Representante De
	cParams += cRepresAte 					//Representante Ate
	
	CallCrys("IFATCR06",cParams,cOptions)
	
	//oDlg:End()
	
Else
	
	msgAlert (	"Nenhuma Informação de acordo com " + cEOL +;
	"os parâmetros informados !!")
	
EndIf

RestArea(aArea)

Return Nil

