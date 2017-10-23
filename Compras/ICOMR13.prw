#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMR13				 	| 	Maio de 2015				     					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatorio em Excel de compras nacionais											|
|-----------------------------------------------------------------------------------------------|
*/

User Function ICOMR13()

Local oButton1
Local oButton2
Local oCheckBo1
Local lCheckBo1 := .F.
Local oCheckBo2
Local lCheckBo2 := .F.
Private oGet1
Private cGet1 := Space(2)
Private oGet2
Private cGet2 := Space(30)
Private oGet3
Private cGet3 := Space(TamSX3("B1_GRUPO")[1])
Private oGet4
Private cGet4 := Space(TamSX3("B1_GRUPO")[1])
Private oGet5
Private cGet5 := Space(TamSX3("B1__PROC")[1])
Private oGet6
Private cGet6 := Space(TamSX3("B1__PROC")[1])
Private oGet7
Private cGet7 := Space(TamSX3("B1_COD")[1])
Private oGet8
Private cGet8 := Space(TamSX3("B1_COD")[1])
Private oGet9
Private cGet9 := Space(15)
Private oGet10
Private cGet10 := Space(30)
Private oGet11
Private cGet11 := CTOD("  /  /    ")
Private oGet12
Private cGet12 := CTOD("  /  /    ")
Private oGet13
Private cGet13 := CTOD("  /  /    ")
Private oGet14
Private cGet14 := CTOD("  /  /    ")
Private oGet15
Private cGet15 := Space(2)
Private oGet16
Private cGet16 := Space(2)
Private oGroup1
Private oGroup2
Private oGroup3
Private oSay1
Private oSay10
Private oSay11
Private oSay12
Private oSay13
Private oSay14
Private oSay15
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Private aEmpresas   := {}
Private aEmpresas1  := {}
Private aBorderos   := {}
Private oOk      	:= LoadBitmap( GetResources(), "LBOK" )
Private oNo   	  	:= LoadBitmap( GetResources(), "LBNO" )
Private lTodos		:= .F.
Private lMarcados	:= .F.
Private _cUFs		:= ""
Private _oDlg, _oSay1, _oComboBo1
Private _nComboBo1 	:= 1
Private _cSegUsr	:= ""
Static oDlg


dbSelectArea("SZ1")
dbSetOrder(1)
if MsSeek(xFilial("SZ1")+__cUserId)
	
	_cSegUsr := SZ1->Z1_SEGISP
	
	If Val(_cSegUsr) == 0
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If MsSeek("C5__SEGISP")
			DEFINE MSDIALOG _oDlg TITLE "Relatório compras nacional" FROM 000, 000  TO 120, 195 COLORS 0, 16777215 PIXEL
			@ 005, 006 SAY _oSay1 PROMPT "Selecione o segmento a ser exibido" SIZE 088, 007 OF _oDlg COLORS 0, 16777215 PIXEL
			@ 021, 007 MSCOMBOBOX _oComboBo1 VAR _nComboBo1 ITEMS Separa(Alltrim(SX3->X3_CBOX),";") SIZE 083, 010 OF _oDlg COLORS 0, 16777215 PIXEL
			@ 039, 029 BUTTON _oButton1 PROMPT "Avançar" SIZE 037, 012 OF _oDlg PIXEL ACTION {|| _lOK := .t.,_oDlg:End()}
			ACTIVATE MSDIALOG _oDlg CENTERED
			
			If Type("_nComboBo1") == "C"
				_nComboBo1 := Val(_nComboBo1)
			EndIf
			
			If _lOK
				If _nComboBo1 == 1
					_cSegUsr := "1 "
				ElseIf _nComboBo1 == 2
					_cSegUsr := "2 "
				EndIf
			EndIf
			
		EndIf
		
	EndIf
	
else
	ApMsgAlert("Usuário não cadastrado na tabela de Segmento.","Atenção!!!")
endif


Aadd(aEmpresas,{.F.,'', ''})
Aadd(aEmpresas1,{.F.,'', ''})

DEFINE MSDIALOG oDlg TITLE "Relatório de Compras Nacional:" FROM 000, 000  TO 570, 700 COLORS 0, 16777215 PIXEL

@ 012, 031 SAY oSay1 PROMPT "Local:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 010, 047 MSGET oGet1 VAR cGet1 SIZE 017, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "DLB" VALID ValFil(cGet1)
@ 010, 070 MSGET oGet2 VAR cGet2 SIZE 111, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

@ 026, 001 SAY oSay2 PROMPT "A Partir do Grupo" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 047 MSGET oGet3 VAR cGet3 SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SBM"

@ 040, 015 SAY oSay3 PROMPT "Até o Grupo:" SIZE 032, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 038, 047 MSGET oGet4 VAR cGet4 SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SBM"

@ 025, 094 SAY oSay4 PROMPT "A Partir da Procedência:" SIZE 059, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 154 MSGET oGet5 VAR cGet5 SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 040, 106 SAY oSay5 PROMPT "Até a Procedência:" SIZE 048, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 038, 154 MSGET oGet6 VAR cGet6 SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 059, 008 SAY oSay6 PROMPT "A Partir do Ítem:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 058, 047 MSGET oGet7 VAR cGet7 SIZE 068, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SB1LIK"

@ 075, 020 SAY oSay7 PROMPT "Até o Ítem:" SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 073, 047 MSGET oGet8 VAR cGet8 SIZE 068, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SB1LIK"

@ 088, 029 SAY oSay8 PROMPT "Marca:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 087, 047 MSGET oGet9 VAR cGet9 SIZE 044, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SZ5" VALID ValMarca(cGet9)
@ 087, 094 MSGET oGet10 VAR cGet10 SIZE 087, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

@ 111, 047 GROUP oGroup1 TO 163, 180 PROMPT "  Período 1  " OF oDlg COLOR 0, 16777215 PIXEL

@ 127, 055 SAY oSay9 PROMPT "A Partir da Data:" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 126, 099 MSGET oGet11 VAR cGet11 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 142, 067 SAY oSay10 PROMPT "Até a Data:" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 141, 099 MSGET oGet12 VAR cGet12 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 168, 047 GROUP oGroup2 TO 220, 180 PROMPT "  Período 2  " OF oDlg COLOR 0, 16777215 PIXEL

@ 184, 055 SAY oSay11 PROMPT "A Partir da Data:" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 183, 100 MSGET oGet13 VAR cGet13 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 199, 067 SAY oSay12 PROMPT "Até a Data:" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 198, 100 MSGET oGet14 VAR cGet14 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

//@ 228, 030 SAY oSay13 PROMPT "Considerar o Total do Local" SIZE 068, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 228, 100 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "(Vendas)" SIZE 048, 008 OF oDlg COLORS 0, 16777215 PIXEL

//@ 246, 030 SAY oSay14 PROMPT "Meses p/ Media (Estoque)" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 244, 096 MSGET oGet15 VAR cGet15 SIZE 019, 010 OF oDlg COLORS 0, 16777215 PIXEL

//@ 260, 030 SAY oSay15 PROMPT "Meses p/ Media (Compras)" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 258, 096 MSGET oGet16 VAR cGet16 SIZE 019, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 007, 210 GROUP oGroup3 TO 237, 340 PROMPT "  Unidades de Federação  " OF oDlg COLOR 0, 16777215 PIXEL
@ 220, 284 CHECKBOX oChk VAR lTodos PROMPT "Selecionar Todos" SIZE 053, 008 OF oDlg PIXEL ON CLICK MarcarREGI(.T.,aEmpresas); oChk:oFont := oDlg:oFont
@ 018,214 LISTBOX oLbx1 FIELDS HEADER "","UF","Nome";
ColSizes 040,020,060 SIZE 123,195,900,300 OF oDlg PIXEL ON DBLCLICK (Marcar2(.F.,aEmpresas))
oLbx1:SetArray(aEmpresas)
oLbx1:bLine := { || {If(aEmpresas[oLbx1:nAt,1],oOk,oNo),;     				 	  				//""
Alltrim(aEmpresas[oLbx1:nAt,2]),;                                       	//UF
Alltrim(aEmpresas[oLbx1:nAt,3])} }                                       	//Nome
oLbx1:nFreeze  := 1
//oLbx1:bChange  := {|| _Instruc() }

@ 258, 302 BUTTON oButton1 PROMPT "Processar" SIZE 037, 012 OF oDlg PIXEL ACTION GeraExcel2()
@ 258, 259 BUTTON oButton2 PROMPT "Fechar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()


ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValFil				 	| 	Maio de 2015				     					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial 														  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValFil(_cEmpresa)
Local _aArea	:= GetArea()
Local _aAreaSZE	:= SZE->(GetArea())
Local lRet 		:= .T.

DbSelectArea("SZE")

If(dbSeek(cEmpAnt+_cEmpresa))
	cGet2 :=  SZE->ZE_NOMECOM
Else
	cGet2 := ""
	lRet := .F.
EndIf

RestArea(_aAreaSZE)
RestArea(_aArea)

If !Empty(_cEmpresa)
	BuscaUF()
	oLbx1:Refresh(.T.)
	oDlg:Refresh(.T.)
Else
	lRet := .T.	
EndIf


Return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValMarca				 	| 	Maio de 2015     				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Marca															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValMarca(_cMarca)
Local _aArea	:= GetArea()
Local _aAreaSZ5	:= SZ5->(GetArea())
Local lRet 		:= .T.

DbSelectArea("SZ5")

If(dbSeek(xFilial("SZ5")+_cMarca))
	cGet10 :=  SZ5->Z5_DESC
Else
	cGet10 := "Todas"
EndIf

RestArea(_aAreaSZ5)
RestArea(_aArea)

Return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : BuscaUF				 	| 	Maio de 2015     				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Busca de UF de acordo com a Filial Selecionada									|
|-----------------------------------------------------------------------------------------------|
*/

Static Function BuscaUF()
Local cQry := ""

If(select("TRB1") > 0)
	TRB1->(DbCloseArea())
EndIf

cQry := " SELECT ZK_UF, ZK_LOCFAT "
cQry += " FROM " + RetSqlName("SZK") + " SZK"
cQry += " WHERE SZK.D_E_L_E_T_ = ' ' "
cQry += " AND SZK.ZK_SEGISP = '" + _cSegUsr + "' "
cQry += " GROUP BY ZK_UF, ZK_LOCFAT "
cQry += " ORDER BY ZK_UF "

TcQuery cQry New Alias "TRB1"

DbSelectArea("TRB1")
TRB1->(DbGoTop())
If Len(aEmpresas) > 1
	aEmpresas   := {}
	Aadd(aEmpresas,{.F.,'', ''})
EndIf
While ! TRB1->(Eof())
	If TRB1->ZK_LOCFAT == cGet1
		Aadd(aEmpresas,{.T.,TRB1->ZK_UF, "" })
	Else
		Aadd(aEmpresas,{.F.,TRB1->ZK_UF, "" })
	EndIf
	TRB1->(DbSkip())
End

Return

*----------------------------------------
Static Function Marcar2(lTodos,aDados)
*----------------------------------------

If lTodos
	lMarcados := ! lMarcados
	For nI := 1 to Len(aDados)
		aDados[nI,1] := lMarcados
	Next
Else
	aDados[oLbx1:nAt,1] := ! aDados[oLbx1:nAt,1]
Endif
oLbx1:Refresh(.T.)
oDlg:Refresh(.T.)

Return Nil

*----------------------------------------
Static Function MarcarREGI(lTodos,aDados)
*----------------------------------------

If lTodos
	lMarcados := ! lMarcados
	For nI := 1 to Len(aDados)
		aDados[nI,1] := lMarcados
	Next
Else
	aDados[oLbx1:nAt,1] := ! aDados[oLbx1:nAt,1]
Endif
oLbx1:Refresh(.T.)
oDlg:Refresh(.T.)

Return Nil


*------------------------------------------
Static Function GeraExcel2()
*------------------------------------------
Local _cQuery := ""
Local _nPrcVen	:= 0
Local _cTabBra 	:= getMV("MV__TABBRA")
Private aHeader := {}
Private aDetail := {}
Private aCampos := {}
Private aCabec  := {}
Private _nReserva := 0

Private _cDest 	:= cGetFile("Arquivos xls|*.XLS","Selecione o Diretorio onde o arquivo ICOMR13 sera salvo",0,"C:\",.F.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)

If Empty(cGet1)
	MsgStop("Campo de Filial deve ser preenchido")
	Return .F. 
EndIf

//======================

If Empty(_cDest)
	_cDest  := "C:\ICOMR13_" + Substr(DTOS(Date()),7,2) + "_" + Substr(DTOS(Date()),5,2) + "_" + Substr(DTOS(Date()),1,4) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xls"
	_cDrive := "C:\"
Else
	_cDrive := _cDest
	_cDest  += Substr(DTOS(Date()),7,2) + "_" + Substr(DTOS(Date()),5,2) + "_" + Substr(DTOS(Date()),1,4) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xls"
	//	_cDest  += "ICOMR04_" + DTOS(Date()) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xls"
EndIf

nhdl1 := fCreate( _cDest,0)

If nHdl1 == -1
	ApMsgAlert("O arquivo não pode ser executado! Verifique os parâmetros.","Atenção!")
	Return NIL
Endif

AbreHtml()

PutHtml({"Periodo 1",Subst(dtos(cGet11),7,2)+"/"+Subst(dtos(cGet11),5,2)+"/"+Subst(dtos(cGet11),1,4),Subst(dtos(cGet12),7,2)+"/"+Subst(dtos(cGet12),5,2)+"/"+Subst(dtos(cGet12),1,4)},1,1)
PutHtml({"Periodo 2",Subst(dtos(cGet13),7,2)+"/"+Subst(dtos(cGet13),5,2)+"/"+Subst(dtos(cGet13),1,4),Subst(dtos(cGet14),7,2)+"/"+Subst(dtos(cGet14),5,2)+"/"+Subst(dtos(cGet14),1,4)},1,1)
//PutHtml({"Previsão de Estoque","","","","Dias","","2 Ano",Subst(dtos(_dt2ANO),7,2)+"/"+Subst(dtos(_dt2ANO),5,2)+"/"+Subst(dtos(_dt2ANO),1,4)},1,1)
PutHtml({""},2,1)
PutHtml({""},2,1)

PutHtml({"Proc","Codigo","Descrição","Un.","Venda P1","Venda P2","Estoque","Compras","Pre-Faturado","Embal","Descrição Completa","Preço de Venda" },1,1)

//======================

_cUFs := ""

For I:=1 To Len(aEmpresas)
	If aEmpresas[I][1]
		_cUFs += "'"+Alltrim(aEmpresas[I][2])+"',"
	EndIf
Next

If !Empty(Alltrim(_cUFs))
	_cUFs := Substr(_cUFs,1,Len(_cUFs)-1)
EndIf

If(select("TRB2") > 0)
	TRB2->(DbCloseArea())
EndIf

_cQuery := " SELECT B1__PROC, B1_COD, B1_DESC, B1__DESCP, B1_UM, B1__MARCA, B1__EMBMAS,	"  + Chr(13)
_cQuery += " (SELECT  SUM(SD2.D2_QUANT)  										"  + Chr(13)
_cQuery += "	FROM "+RetSqlName("SD2")+" SD2   								"  + Chr(13)
_cQuery += "	WHERE  SD2.D_E_L_E_T_ = ' '  									"  + Chr(13)
_cQuery += "	AND  SD2.D2_FILIAL ='"+cGet1+"' 								"  + Chr(13)
_cQuery += "	AND  SD2.D2_EMISSAO BETWEEN '"+DtoS(cGet11)+"' AND '"+DtoS(cGet12)+"' 		"  + Chr(13)
_cQuery += "	AND  SD2.D2_COD >= SB1.B1_COD  									"  + Chr(13)
_cQuery += "	AND  SD2.D2_COD <= SB1.B1_COD  									"  + Chr(13)
_cQuery += "	AND  SD2.D2_TIPO = 'N' 											"  + Chr(13)
If !Empty(Alltrim(_cUFs))
	_cQuery += "	AND  SD2.D2_EST IN ("+_cUFs+") 								"  + Chr(13)
EndIf
_cQuery += "	AND  EXISTS (SELECT SF4.F4_CODIGO 								"  + Chr(13)
_cQuery += "				FROM "+RetSqlName("SF4")+" SF4 						"  + Chr(13)
_cQuery += "				WHERE  SF4.F4_CODIGO = SD2.D2_TES  					"  + Chr(13)
_cQuery += "				AND   SF4.F4_ESTOQUE = 'S'  						"  + Chr(13)
_cQuery += "				AND  SF4.D_E_L_E_T_ = ' '  )) AS QTDVENP1, 		"  + Chr(13)

_cQuery += " (SELECT  SUM(SD2.D2_QUANT)  							  			"  + Chr(13)
_cQuery += "	FROM "+RetSqlName("SD2")+" SD2   								"  + Chr(13)
_cQuery += "	WHERE  SD2.D_E_L_E_T_ = ' ' 								 	"  + Chr(13)
_cQuery += "	AND   SD2.D2_FILIAL ='"+cGet1+"' 								"  + Chr(13)
_cQuery += "	AND  SD2.D2_EMISSAO BETWEEN '"+DtoS(cGet13)+"' AND '"+DtoS(cGet14)+"' 		"  + Chr(13)
_cQuery += "	AND  SD2.D2_COD >= SB1.B1_COD  									"  + Chr(13)
_cQuery += "	AND  SD2.D2_COD <= SB1.B1_COD  									"  + Chr(13)
_cQuery += "	AND  SD2.D2_TIPO = 'N' 											"  + Chr(13)
If !Empty(Alltrim(_cUFs))
	_cQuery += "	AND  SD2.D2_EST IN ("+_cUFs+") 								"  + Chr(13)
EndIf
_cQuery += "	AND  EXISTS (SELECT SF4.F4_CODIGO 								"  + Chr(13)
_cQuery += "					FROM "+RetSqlName("SF4")+" SF4				 	"  + Chr(13)
_cQuery += "					WHERE SF4.F4_CODIGO = SD2.D2_TES  				"  + Chr(13)
_cQuery += "					AND   SF4.F4_ESTOQUE = 'S'  					"  + Chr(13)
_cQuery += "					AND  SF4.D_E_L_E_T_ = ' '  )) AS QTDVENP2,		"  + Chr(13)

/*_cQuery += " (SELECT SUM(SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA) 				"  + Chr(13)
_cQuery += "   		FROM "+RetSqlName("SC7")+" SC7  							"  + Chr(13)
_cQuery += "		WHERE  SC7.C7_FILIAL = '"+cGet1+"'  						"  + Chr(13)
_cQuery += "		AND  SC7.C7_RESIDUO <> 'S' 									"  + Chr(13)
_cQuery += "		AND  SC7.C7_PRODUTO >= SB1.B1_COD							"  + Chr(13)
_cQuery += "		AND  SC7.C7_PRODUTO <= SB1.B1_COD 							"  + Chr(13)
_cQuery += "		AND  (SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA)>0 			"  + Chr(13)
_cQuery += "		AND  SC7.D_E_L_E_T_ <> '*'  								"  + Chr(13)
_cQuery += "		GROUP BY C7_PRODUTO) AS COMPRAS,							"  + Chr(13) */
_cQuery += " (SELECT SUM(B2_SALPEDI)											"  + Chr(13)
_cQuery += "   		FROM " + RetSQLName("SB2") + " SB2 							"  + Chr(13)
_cQuery += "   		WHERE SB2.D_E_L_E_T_ = ' ' 									"  + Chr(13)
_cQuery += "   		AND   B2_LOCAL = '01'    									"  + Chr(13)
_cQuery += "   		AND   B2_FILIAL <> '01'  									"  + Chr(13)
_cQuery += "   		AND   B2_FILIAL = '"+cGet1+"'								"  + Chr(13)
_cQuery += "   		AND   B2_COD = SB1.B1_COD 		                            "  + Chr(13)
_cQuery += "   		GROUP BY B2_COD) AS COMPRAS,       							"  + Chr(13)

/*_cQuery += " (SELECT SUM(UB_QUANT) 												"  + Chr(13)
_cQuery += "   		FROM "+RetSqlName("SUB")+" SUB, "+RetSqlName("SUA")+" SUA	"  + Chr(13)
_cQuery += "   		WHERE SUA.UA_FILIAL = SUB.UB_FILIAL							"  + Chr(13)
_cQuery += "   		AND SUA.UA_NUM = SUB.UB_NUM 								"  + Chr(13)
_cQuery += "   		AND SUA.D_E_L_E_T_ = ' '									"  + Chr(13)
_cQuery += "   		AND SUA.UA_FILIAL = '"+cGet1+"'								"  + Chr(13)
_cQuery += "   		AND SUA.UA_DOC = ' '										"  + Chr(13)
_cQuery += "   		AND SUB.UB_PRODUTO = SB1.B1_COD                             "  + Chr(13)
_cQuery += "   		AND SUA.UA__RESEST = 'S'									"  + Chr(13)
_cQuery += "   		GROUP BY UB_PRODUTO) AS PRE_FATURADO,						"  + Chr(13)*/

_cQuery += " (SELECT  SUM(Z10_QTD) 												"  + Chr(13)
_cQuery += "   		FROM " + RetSQLName("Z10") + " Z10                     		"  + Chr(13)
_cQuery += "   		WHERE Z10.D_E_L_E_T_ = ' '                                 	"  + Chr(13)
_cQuery += "   		AND Z10_PROD = SB1.B1_COD                         	   		"  + Chr(13)
_cQuery += "   		AND Z10_FILIAL <> '01'							   			"  + Chr(13)
_cQuery += "   		AND Z10.Z10_FILIAL = '"+cGet1+"'							"  + Chr(13)
_cQuery += "   		GROUP BY Z10_PROD) AS RESERVA_Z10,                        	"  + Chr(13)

_cQuery += " (SELECT SUM(B2_RESERVA)											"  + Chr(13)
_cQuery += "   		FROM " + RetSQLName("SB2") + " SB2 							"  + Chr(13)
_cQuery += "   		WHERE SB2.D_E_L_E_T_ = ' ' 									"  + Chr(13)
_cQuery += "   		AND   B2_LOCAL = '01'    									"  + Chr(13)
_cQuery += "   		AND   B2_FILIAL <> '01'  									"  + Chr(13)
_cQuery += "   		AND   B2_FILIAL = '"+cGet1+"'								"  + Chr(13)
_cQuery += "   		AND   B2_COD = SB1.B1_COD 		                            "  + Chr(13)
_cQuery += "   		GROUP BY B2_COD) AS RESERVA_B2,       						"  + Chr(13)

//_cQuery += " FCSLDPRD('"+cGet1+"',SB1.B1_COD) AS SALDO							"  + Chr(13)
_cQuery += " (SELECT SUM(B2_QATU)												"  + Chr(13)
_cQuery += "   		FROM " + RetSQLName("SB2") + " SB2 							"  + Chr(13)
_cQuery += "   		WHERE SB2.D_E_L_E_T_ = ' ' 									"  + Chr(13)
_cQuery += "   		AND   B2_LOCAL = '01'    									"  + Chr(13)
_cQuery += "   		AND   B2_FILIAL <> '01'  									"  + Chr(13)
_cQuery += "   		AND   B2_FILIAL = '"+cGet1+"'								"  + Chr(13)
_cQuery += "   		AND   B2_COD = SB1.B1_COD 		                            "  + Chr(13)
_cQuery += "   		GROUP BY B2_COD) AS SALDO       							"  + Chr(13)

_cQuery += " FROM "+RetSqlName("SB1")+" SB1										"  + Chr(13)

_cQuery += " WHERE D_E_L_E_T_ = ' ' AND B1__SEGISP = '" + _cSegUsr +         "' "  + Chr(13)

If !Empty(Alltrim(cGet3))
	_cQuery += " AND B1_GRUPO BETWEEN '"+cGet3+"' AND '"+cGet4+"'				"  + Chr(13)
EndIf

If !Empty(Alltrim(cGet5))
	_cQuery += " AND B1__PROC BETWEEN '"+cGet5+"' AND '"+cGet6+"'				"  + Chr(13)
EndIf

If !Empty(Alltrim(cGet7))
	_cQuery += " AND B1_COD BETWEEN '"+cGet7+"' AND '"+cGet8+"'				"  + Chr(13)
EndIf

If !Empty(Alltrim(cGet9))
	_cQuery += " AND B1__MARCA = '"+cGet9+"' 									"  + Chr(13)
EndIf

_cQuery += "   	ORDER BY B1__PROC, B1_DESC 									"  + Chr(13)

TcQuery _cQuery New Alias "TRB2"

DbSelectArea("TRB2")
TRB2->(DbGoTop())

ProcRegua(RecCount())

cForn := ""

While ! TRB2->(eof())
	
	IncProc()
	
	_nReserv := TRB2->RESERVA_B2 + TRB2->RESERVA_Z10

	//Foi adicionado rotina abaixo para buscar o último preço vigente da tabela de preço, quando o estado estiver em branco.
	//Rotina solicitada pelo usuário Vladimir e verificado com o Sérgio sobre as alterações.
	
	_nPrcVen	:= PrcVen(TRB2->B1_COD,_cTabBra)
	
	If cForn ==  TRB2->B1__PROC
		
		PutHtml({"   ",;
		TRB2->B1_COD,;
		TRB2->B1_DESC,;
		TRB2->B1_UM,;
		Transform(TRB2->QTDVENP1,"@E 999999"),;
		Transform(TRB2->QTDVENP2,"@E 999999"),;
		Transform(TRB2->SALDO,"@E 999999"),;
		Transform(TRB2->COMPRAS,"@E 999999"),;
		Transform(_nReserv,"@E 999999"),;
		Transform(TRB2->B1__EMBMAS,"@E 999999"),;
		TRB2->B1__DESCP,;
		Transform(_nPrcVen,"@E 999,999.999999")})
		
	Else
		
		PutHtml({TRB2->B1__PROC,;
		TRB2->B1_COD,;
		TRB2->B1_DESC,;
		TRB2->B1_UM,;
		Transform(TRB2->QTDVENP1,"@E 999999"),;
		Transform(TRB2->QTDVENP2,"@E 999999"),;
		Transform(TRB2->SALDO,"@E 999999"),;
		Transform(TRB2->COMPRAS,"@E 999999"),;
		Transform(_nReserv,"@E 999999"),;
		Transform(TRB2->B1__EMBMAS,"@E 999999"),;
		TRB2->B1__DESCP,;
		Transform(_nPrcVen,"@E 999,999.999999")})
		
	EndIf
	
	cForn := TRB2->B1__PROC
	
	TRB2->(DbSkip())
	
EndDo

TRB2->(dbCloseArea()) //fecha o SD2Q da query
//PutHtml({" ", " ", " "," ", " "," "," "," ", " "," ", " "," ", " "," "," "," "," "," " },3,0)
FecHtml()
fClose(nHdl1)

If File(_cDest)
	MsgInfo("Arquivo de COMPRAS ISAPA gerado com sucesso em " + _cDest)
	shellExecute("Open", _cDest, "", "C:\", 1 )
Else
	MsgStop("Não foi possível gravar o arquivo ESTOQUE ISAPA.")
EndIf

Close(oDlg)

Return

*-------------------------
Static Function AbreHtml()
*-------------------------

Local cCabHtml 		:= ""
Local cFileCont 	:= ""
//monta cabeçalho de pagina HTML para posterior utilização
cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>teste</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF
cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
cCabHtml += "" + CRLF
cFileCont := cCabHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
Endif
Return nil

Static Function fecHtml()
Local cRodHtml 	:= ""
Local cFileCont	:= ""
// Monta Rodape Html para posterior utilizaçao
cRodHtml := "</body>" + CRLF
cRodHtml += "</html>" + CRLF
cFileCont := cRodHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
Endif

Return nil

*-----------------------------------------------
Static Function PutHtml(aConteudo, nTipo, nBold)
*-----------------------------------------------

Local cLinFile 	:= ""
Local cFileCont := ""
Local nXb 		:= 0
Default nBold 	:= 0
Default nTipo	:= 2

//Aqui começa a montagem da pagina html propriamente dita
// acrescenta o cabeçalho
If nTipo == 1
	cLinFile += "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"
EndIf

cLinFile += "<TR>"

For nXb := 1 to Len(aConteudo)
	cLinFile += "<TD style='Background: #FFFFFF; font-style: Bold;'>"
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += Alltrim(aConteudo[nXb])
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += "</TD>"
next nXb
cLinFile += "</TR>" + CRLF

If nTipo == 3
	cLinFile += "</Table>"
EndIf

cFileCont := cLinFile

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
Endif

Return nil


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : PrcVen				 	| 	Agosto de 2015				     					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi		            									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Busca último preço da tabela de preço										  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function PrcVen(_cItem,_cTabBra)

Local _cQuery	:= ""
Local TDA1		:= {}
Local _nPreco	:= 0

IF SELECT("TDA1") > 0
	dbSelectArea("TDA1")
	TDA1->(dbCloseArea())
Endif

_cQuery := "SELECT MAX(DA1.DA1_DATVIG), DA1.DA1_PRCVEN as PRECO "
_cQuery += "FROM " + retSqlName("DA1") + " DA1 "
_cQuery += "WHERE DA1_CODTAB = '" + _cTabBra + "' "
_cQuery += "AND DA1.DA1_CODPRO = '" + _cItem + "' "
_cQuery += "AND DA1.DA1_ESTADO = ' ' "
_cQuery += "AND DA1.D_E_L_E_T_ = ' ' "
_cQuery += "GROUP BY DA1_PRCVEN "

TcQuery _cQuery New Alias "TDA1"

DbSelectArea("TDA1")
TDA1->(DbGoTop())

_nPreco := TDA1->PRECO

IF SELECT("TDA1") > 0
	dbSelectArea("TDA1")
	TDA1->(dbCloseArea())
Endif

Return _nPreco
			