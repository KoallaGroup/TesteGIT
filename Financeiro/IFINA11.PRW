#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IFINA11			  		| 	Fevereiro de 2015						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto Ferraraz Pereira Alves - Anadi										|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Programa de Indicacao de Titulos para geracao do CNAB							 		|
|-------------------------------------------------------------------------------------------------------|
*/

User Function IFINA11()

Local oButton1                                                                                              
Local oButton2
Local oButton3
Local oButton4
Local oGet1
Local dGet1 := CTOD("  /  /    ")
Local oGet2
Local cGet2 := "1"
Local oGet3
Local cGet3 := "Isapa Imp.Com. Ltda"
Local oGet4
Local cGet4 := "Gerado"
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4, oGroupVl, oSayQt, oSayVl
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9

Private aEmpresas   := {}
Private aBorderos   := {}
Private oOk      	:= LoadBitmap( GetResources(), "LBOK" )
Private oNo   	  	:= LoadBitmap( GetResources(), "LBNO" )
Private lTodos		:= .F.
Private lMarcados	:= .F.
Private oGet10
Private dGet10 := CTOD("  /  /    ")
Private oGet11
Private dGet11 := CTOD("  /  /    ")
Private cGet12 := "3"
Private oGet12
Private cGet13 := Space(20)
Private oGet13
Private cGet14 := Space(2)
Private oGet14
Private cGet15 := Space(2)
Private oGet15
Private nGet16 := nTotQt := nTotVl := 0, oTotQt, oTotVl
Private oGet16
Private oGet17
Private cGet17 := Space(15)
Private oGet18
Private cGet18 := Space(15)
Private cGet19 := Posicione("SX5",1,xFilial("SX5")+"07"+"3","X5_DESCRI")
Private oGet19
Private cGet20 := Space(2)
Private oGet20
Private oGet5
Private cGet5 := Space(TAMSX3("A6_COD")[1])
Private oGet6
Private cGet6 := Space(TAMSX3("A6_AGENCIA")[1])
Private oGet7
Private cGet7 := ""
Private oGet8
Private cGet8 := "Tesouraria"
Private oGet9
Private cGet9 := Space(TAMSX3("A6_NUMCON")[1])


Private oDlg

dGet10	:= DataValida(dDataBase+7)
dGet11	:= CtoD("31/12/"+Alltrim(Str(Year(dDataBase)+5)))

dGet1   := dDataBase

BuscaDados(1)

dbSelectArea("TRB")
TRB->(DbGoTop())
If TRB->(Eof())
	Aadd(aEmpresas,{.F.,'', '', '', 0,  0 })
Else
	While ! TRB->(Eof())
		Aadd(aEmpresas,{.F.,TRB->A1_BCO1, TRB->A1__AGCLIE, TRB->A1__CCCLIE, TRB->QUANTIDADE,  TRB->TOTAL })
		TRB->(DbSkip())
	End
Endif
DEFINE MSDIALOG oDlg TITLE "Indicacao de Titulos" FROM 000, 000  TO 550, 700 COLORS 0, 16777215 PIXEL

@ 003, 004 GROUP oGroup1 TO 033, 344 PROMPT "Indicacao" OF oDlg COLOR 0, 16777215 PIXEL
@ 037, 004 GROUP oGroup2 TO 066, 344 PROMPT "Portador Atual" OF oDlg COLOR 0, 16777215 PIXEL
@ 070, 004 GROUP oGroup3 TO 100, 344 PROMPT "Vencimento" OF oDlg COLOR 0, 16777215 PIXEL
@ 104, 004 GROUP oGroup4 TO 148, 344 PROMPT "Indicacao" OF oDlg COLOR 0, 16777215 PIXEL

@ 016, 010 SAY oSay1 PROMPT "Data:" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 031 MSGET oGet1 VAR dGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

@ 016, 101 SAY oSay2 PROMPT "Empresa:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 131 MSGET oGet2 VAR cGet2 SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 015, 160 MSGET oGet3 VAR cGet3 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
//@ 034, 213 SAY oSay3 PROMPT "Situacao:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 032, 241 MSGET oGet4 VAR cGet4 SIZE 079, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

@ 047, 010 SAY oSay4 PROMPT "Banco:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 046, 035 MSGET oGet5 VAR cGet5 SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SA6REM" VALID ValCpo("cGet5")
@ 047, 068 SAY oSay5 PROMPT "Agencia:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 046, 093 MSGET oGet6 VAR cGet6 SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID ValCpo("cGet6")
@ 047, 126 SAY oSay6 PROMPT "Conta Corrente:" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 046, 166 MSGET oGet9 VAR cGet9 SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL 
@ 046, 220 MSGET oGet7 VAR cGet7 SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
//@ 072, 127 MSGET oGet8 VAR cGet8 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

@ 081, 037 SAY oSay7 PROMPT "Inicial:" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 079, 053 MSGET oGet10 VAR dGet10 SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 081, 131 SAY oSay8 PROMPT "Final:" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 079, 147 MSGET oGet11 VAR dGet11 SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 079, 244 BUTTON oButton1 PROMPT "Filtrar" SIZE 037, 012 OF oDlg PIXEL ACTION Processa({|| FiltDad()}, "Processando","Filtrando informações")

@ 115, 008 SAY oSay9 PROMPT "Tp.Cobr.:" SIZE 052, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 114, 045 MSGET oGet12 VAR cGet12 SIZE 010, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "07D" VALID ValCpo("cGet12") 
@ 114, 067 MSGET oGet19 VAR cGet19 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. 
@ 116, 130 SAY oSay11 PROMPT "1 Instrucao:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL 
@ 114, 163 MSGET oGet14 VAR cGet14 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. //F3 "INST11" VALID ValCpo("cGet14") 
@ 114, 188 MSGET oGet17 VAR cGet17 SIZE 090, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 116, 280 SAY oSay13 PROMPT "Prazo:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 114, 300 MSGET oGet16 VAR nGet16 SIZE 036, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. //PICTURE "@E 99"

@ 131, 009 SAY oSay10 PROMPT "Ocorrencia:" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 131, 045 MSGET oGet13 VAR cGet20 SIZE 010, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. //F3 "10E" PICTURE "@! 99" VALID ValCpo("cGet20") 
@ 131, 067 MSGET oGet13 VAR cGet13 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 131, 130 SAY oSay12 PROMPT "2 Instrucao:" SIZE 031, 007 OF oDlg COLORS 0, 16777215 PIXEL 
@ 130, 163 MSGET oGet15 VAR cGet15 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. //F3 "INST11" VALID ValCpo("cGet15") 
@ 130, 188 MSGET oGet18 VAR cGet18 SIZE 090, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

@ 152,004 LISTBOX oLbx1 FIELDS HEADER "","Banco","Agencia", "Conta Corrente", "Quantidade", "Valor";
ColSizes 040,060,060,060,060,060 SIZE 344,90,900,200 OF oDlg PIXEL ON DBLCLICK (Marcar2(.F.,aEmpresas))
oLbx1:SetArray(aEmpresas)
oLbx1:bLine := { || {If(aEmpresas[oLbx1:nAt,1],oOk,oNo),;     				 	  				//""
Alltrim(aEmpresas[oLbx1:nAt,2]),;                                       	//Banco
Alltrim(aEmpresas[oLbx1:nAt,3]),;                                       	//Agencia
Alltrim(aEmpresas[oLbx1:nAt,4]),;                                       	//Conta Corrente
aEmpresas[oLbx1:nAt,5],;                	   	        	            	//Quantidade
Transform(aEmpresas[oLbx1:nAt,6],"@E 999,999,999.99") } }	 			  	//Valor
oLbx1:nFreeze  := 1
oLbx1:bChange  := {|| _Instruc() }

@ 255, 004 CHECKBOX oChk VAR lTodos PROMPT "Marca/Desmarca Todos" SIZE 70, 10 OF oDlg PIXEL ON CLICK MarcarREGI(.T.,aEmpresas); oChk:oFont := oDlg:oFont

@ 246, 075 GROUP oGroupVl TO 269, 258 PROMPT "Totais" OF oDlg COLOR 0, 16777215 PIXEL

@ 255, 080 SAY oSayQt PROMPT "Quant" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL 
@ 253, 095 MSGET oTotQt VAR nTotQt SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. Picture "@E 999,999,999,999"

@ 255, 165 SAY oSayVl PROMPT "Valor" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL 
@ 253, 180 MSGET oTotVl VAR nTotVl SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. Picture PesqPict("SE2","E2_VALOR")

@ 253, 265 BUTTON oButton2 PROMPT "Gerar Titulos" SIZE 037, 012 OF oDlg PIXEL ACTION MsAguarde({|| U_IFINA11A()}, "Processando","Gerando o(s) borderô(s)")
@ 253, 310 BUTTON oButton3 PROMPT "Fechar" SIZE 037, 012 OF oDlg PIXEL ACTION Close(oDlg)

ACTIVATE MSDIALOG oDlg CENTERED

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

*-----------------------------
Static Function BuscaDados(_nTipo)
*-----------------------------

Local cQry := ""
Local cSepNeg   := If("|"$MV_CRNEG,"|",","), cSepProv  := If("|"$MVPROVIS,"|",","), cSepRec := If("|"$MVRECANT,"|",",")

If(select("TRB") > 0)
	TRB->(DbCloseArea())
EndIf

If _nTipo == 1//Query exibida na inicialização da tela
    cQry := "Select A1_BCO1, A1__AGCLIE, A1__DGAGCL, A1__CCCLIE, A1__DGCCCL, 0 AS QUANTIDADE,  0 AS TOTAL From " + RetSqlName("SA1") + " A1 "
    cQry += "Inner Join " + RetSqlName("SA6") + " A6 On A6_FILIAL = '" + xFilial("SA6") + "' And "
    cQry +=     "A6_COD = A1_BCO1 And A6_AGENCIA = A1__AGCLIE And A6_NUMCON = A1__CCCLIE And A6.D_E_L_E_T_ = ' ' "
    cQry += "Inner Join " + RetSqlName("SE1") + " E1 On E1_CLIENTE = A1_COD And E1_LOJA = A1_LOJA And E1_SALDO > 0 And "
    cQry +=     "E1_NUMBOR = ' ' And E1_NUMBCO = ' ' And E1_IDCNAB = ' ' And "
    cQry +=     "E1_SITUACA IN ('0','F','G') And E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " And "
    cQry +=     "E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " And E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " And "
    cQry +=     "E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " And E1.D_E_L_E_T_ = ' ' "
    cQry += "Where A1.D_E_L_E_T_ = ' ' "
    cQry +=     "AND A1__REMESS = 'S' "
    cQry += " GROUP BY A1_BCO1, A1__AGCLIE, A1__DGAGCL, A1__CCCLIE, A1__DGCCCL  "
Else
    If (_nTipo = 2 .AND. (Val(cGet5) = 0 .AND. Val(cGet6) = 0 .AND. Val(cGet9) = 0) )
        cQry := " SELECT SA1.A1_BCO1, SA1.A1__AGCLIE, SA1.A1__DGAGCL, SA1.A1__CCCLIE, SA1.A1__DGCCCL, COUNT(*) AS QUANTIDADE,  SUM(SE1.E1_SALDO) AS TOTAL "
        cQry += " FROM " + RetSqlName("SA1") + " SA1,"
        cQry += " " + RetSqlName("SE1") + " SE1"
        cQry += " WHERE SE1.D_E_L_E_T_ = ' ' "
        cQry += " AND SA1.D_E_L_E_T_ = ' ' "
        cQry += " AND SE1.E1_VENCREA BETWEEN '"+DtoS(dGet10)+"' AND '"+DtoS(dGet11)+"'"
        cQry += " AND SE1.E1_EMISSAO < '" + DTOS(Date()) + "' "
        cQry += " AND SE1.E1_SALDO > 0"
        cQry += " AND SE1.E1_NUMBOR = ' ' And SE1.E1_NUMBCO = ' ' And SE1.E1_IDCNAB = ' ' "
        cQry += " AND SE1.E1_BAIXA = ' '"
        cQry += " AND SE1.E1_CLIENTE = SA1.A1_COD"
        cQry += " AND SE1.E1_LOJA = SA1.A1_LOJA"
        cQry += " AND SA1.A1_BCO1 = ' ' "
        cQry += " AND SE1.E1_SITUACA IN ('0','F','G') "
        cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " "
        cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " "
        cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " "
        cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " "
        cQry += " AND SE1.E1_TIPO NOT IN ('NP','CH') "
    	cQry += " AND A1__REMESS = 'S' "
        //cQry += " AND SE1.E1_TIPO = 'NF' "
        cQry += " GROUP BY SA1.A1_BCO1, SA1.A1__AGCLIE, SA1.A1__DGAGCL, SA1.A1__CCCLIE, SA1.A1__DGCCCL  "        
        cQry += "Union All "
    EndIf

    cQry += " SELECT SA1.A1_BCO1, SA1.A1__AGCLIE, SA1.A1__DGAGCL, SA1.A1__CCCLIE, SA1.A1__DGCCCL, COUNT(*) AS QUANTIDADE,  SUM(SE1.E1_SALDO) AS TOTAL "
    cQry += " FROM " + RetSqlName("SA1") + " SA1,"
    cQry += " " + RetSqlName("SE1") + " SE1,"
    cQry += " " + RetSqlName("SA6") + " SA6"
    cQry += " WHERE SE1.D_E_L_E_T_ = ' ' "
    cQry += " AND SA1.D_E_L_E_T_ = ' ' "
    cQry += " AND SA6.D_E_L_E_T_ = ' ' "
    cQry += " AND SE1.E1_VENCREA BETWEEN '"+DtoS(dGet10)+"' AND '"+DtoS(dGet11)+"'"
    cQry += " AND SE1.E1_EMISSAO < '" + DTOS(Date()) + "' "
    cQry += " AND SE1.E1_SALDO > 0"
    cQry += " AND SE1.E1_NUMBOR = ' ' And SE1.E1_NUMBCO = ' ' And SE1.E1_IDCNAB = ' ' "
    cQry += " AND SE1.E1_BAIXA = ' '"
    cQry += " AND SE1.E1_CLIENTE = SA1.A1_COD"
    cQry += " AND SE1.E1_LOJA = SA1.A1_LOJA"
    If (_nTipo = 2 .AND. (Val(cGet5) > 0 .AND. Val(cGet6) > 0 .AND. Val(cGet9) > 0) )
        cQry += " AND SA1.A1_BCO1 = '" + cGet5 + "' AND SA1.A1__AGCLIE = '" + cGet6 + "' AND SA1.A1__CCCLIE = '" + cGet9 + "' "
    EndIf
    cQry += " AND SA6.A6_COD = SA1.A1_BCO1 AND SA6.A6_AGENCIA = SA1.A1__AGCLIE AND SA6.A6_NUMCON = SA1.A1__CCCLIE "
    cQry += " AND SE1.E1_SITUACA IN ('0','F','G') "
    cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " "
   	cQry += " AND A1__REMESS = 'S' "
    cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " "
    cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " "
    cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " "
    cQry += " AND SE1.E1_TIPO NOT IN ('NP','CH') "
    cQry += " GROUP BY SA1.A1_BCO1, SA1.A1__AGCLIE, SA1.A1__DGAGCL, SA1.A1__CCCLIE, SA1.A1__DGCCCL  "    
EndIf
cQry += " ORDER BY A1_BCO1 "
TcQuery cQry New Alias "TRB"

Return

*-----------------------------
User Function IFINA11A()
*-----------------------------

Local oButton2
Local oButton3
Private oDlg1

Private aEmpresas1   := {}
Private oOk1      	:= LoadBitmap( GetResources(), "LBOK" )
Private oNo1   	  	:= LoadBitmap( GetResources(), "LBNO" )
Private lTodos1		:= .F.

Do Case
	Case Empty(cGet12) 
		Alert("Tipo de cobrança em branco")
		Return
	Case Empty(cGet20)
		Alert("Ocorrencia em branco" + Chr(13) + "Favor checar os parametros do banco")
		Return
	Case Empty(cGet14)
		Alert("Primeira Instrução em branco" + Chr(13) + "Favor checar os parametros do banco")
		Return
	Case Empty(cGet15)
		Alert("Segunda Instrução em branco" + Chr(13) + "Favor checar os parametros do banco")
		Return
EndCase

For I:=1 To Len(aEmpresas)
	If aEmpresas[I][1]
		If Empty(Alltrim(aEmpresas[I][2]))
			Alert("Nao e possivel gerar bordero para banco em branco!")
			Return
		ElseIf(aEmpresas[I][5] = 0)
			Alert("Nenhum titulo disponível")
			Return
		Else
			If GeraBordero(aEmpresas[I][2],aEmpresas[I][3],aEmpresas[I][4])
				MsgInfo("Gerado Bordero para banco: " + aEmpresas[I][2])
			EndIf
		EndiF
	EndIf
Next                   

// Criacao do array com Borderos Nao Enviados
If(select("TRB2") > 0)
	TRB2->(DbCloseArea())
EndIf

cQry := " SELECT DISTINCT A1_BCO1, A1__AGCLIE, A1__CCCLIE, E1_NUMBOR "
cQry += " FROM " + RetSqlName("SA1") + " SA1,"
cQry += " " + RetSqlName("SE1") + " SE1,"
cQry += " " + RetSqlName("SEA") + " SEA"
cQry += " WHERE SE1.D_E_L_E_T_ = ' ' "
cQry += " AND SA1.D_E_L_E_T_ = ' ' "
cQry += " AND SEA.D_E_L_E_T_ = ' ' "
cQry += " AND SE1.E1_VENCREA BETWEEN '"+DtoS(dGet10)+"' AND '"+DtoS(dGet11)+"' "
cQry += " AND SE1.E1_EMISSAO < '" + DTOS(Date()) + "' "
cQry += " AND SE1.E1_SALDO > 0"
cQry += " AND SE1.E1_BAIXA = ' ' And E1_NUMBCO = ' ' "
cQry += " AND SE1.E1_CLIENTE = SA1.A1_COD"
cQry += " AND SE1.E1_LOJA = SA1.A1_LOJA"
cQry += " AND SE1.E1_NUMBOR = SEA.EA_NUMBOR AND SEA.EA__TIPGER = '1' AND SEA.EA__CNAB <> 'S' "
cQry += " AND SE1.E1_SITUACA NOT IN ('0','F','G')  "  
cQry += " AND SEA.EA_NUM = SE1.E1_NUM "
cQry += " AND SEA.EA_PREFIXO = SE1.E1_PREFIXO "
cQry += " AND SEA.EA_PARCELA = SE1.E1_PARCELA "
cQry += " AND SEA.EA_FILORIG = SE1.E1_FILIAL  "
cQry += " AND SEA.EA_TIPO = SE1.E1_TIPO       "
cQry += " AND SE1.E1_IDCNAB = ' '             "
cQry += " AND A1__REMESS = 'S' "

TcQuery cQry New Alias "TRB2"

aBorderos := {}

dbSelectArea("TRB2")
TRB2->(DbGoTop())
If TRB2->(Eof())
	Aadd(aBorderos,{.F.,'', '', '', '', '', '', '', '' })
Else
	While ! TRB2->(Eof())

		__cBCO		:= subst(TRB2->A1_BCO1,1,TAMSX3("A6_COD")[1])
		__cAGE		:= subst(TRB2->A1__AGCLIE,1,TAMSX3("A6_AGENCIA")[1])
		__cCTA		:= subst(TRB2->A1__CCCLIE,1,TAMSX3("A6_NUMCON")[1])

		cNomeBanco 	:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6_NOME")   
		cArqBor		:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6__NOMBOR")
		cCamBor		:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6__CAMBOR")
		cModArq		:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6__CNFCNA")        
		cNumBor 	:= TRB2->E1_NUMBOR
		Aadd(aBorderos,{.F.,__cBCO,__cAGE,__cCTA, cNomeBanco, cNumBor, cArqBor, cCamBor, cModArq })

		TRB2->(DbSkip())
	End
Endif

DEFINE MSDIALOG oDlg1 TITLE "Borderos Gerados" FROM 000, 000  TO 550, 700 COLORS 0, 16777215 PIXEL

@ 003,004 LISTBOX oLbx2 FIELDS HEADER "","Banco","Agencia", "Conta Corrente", "Nome Banco", "Num Bordero";
ColSizes 040,060,060,060,060,060 SIZE 344,250,900,200 OF oDlg1 PIXEL ON DBLCLICK (Marcar3(.F.,aBorderos))
oLbx2:SetArray(aBorderos)
oLbx2:bLine 	:= { || {If(aBorderos[oLbx2:nAt,1],oOk1,oNo1),;     				 	  			//""
Alltrim(aBorderos[oLbx2:nAt,2]),;                                       	//Banco
Alltrim(aBorderos[oLbx2:nAt,3]),;                                       	//Agencia
Alltrim(aBorderos[oLbx2:nAt,4]),;                                       	//Conta Corrente
Alltrim(aBorderos[oLbx2:nAt,5]),;                	   	        	   		//Nome Banco
aBorderos[oLbx2:nAt,6] } }	 			 									//Numero Bordero
oLbx2:nFreeze  	:= 1
@ 256, 150 BUTTON oButton2 PROMPT "Gerar CNAB" SIZE 037, 012 OF oDlg1 PIXEL ACTION (Close(oDlg1),Close(oDlg),U_IFINA11B())
@ 256, 200 BUTTON oButton3 PROMPT "Imprimir" SIZE 037, 012 OF oDlg1 PIXEL ACTION U_IFINR13(aBorderos)
@ 256, 250 BUTTON oButton4 PROMPT "Cancelar" SIZE 037, 012 OF oDlg1 PIXEL ACTION (MsAguarde({|| U_IFINA11D()}, "Processando","Cancelando o(s) borderô(s)"),RefMark(1),Close(oDlg1))
@ 256, 300 BUTTON oButton4 PROMPT "Fechar" SIZE 037, 012 OF oDlg1 PIXEL ACTION (RefMark(1),Close(oDlg1))

ACTIVATE MSDIALOG oDlg1 CENTERED

Return


*----------------------------------------
Static Function Marcar3(lTodos1,aDados)
*----------------------------------------

If lTodos1
	lMarcados := ! lMarcados
	For nI := 1 to Len(aDados)
		aDados[nI,1] := lMarcados
	Next
Else
	aDados[oLbx2:nAt,1] := ! aDados[oLbx2:nAt,1]
Endif
oLbx2:Refresh(.T.)
oDlg1:Refresh(.T.)

Return Nil

*-------------------------------------------------------
Static Function GeraBordero(_cBanco, _cAgencia, _cConta)
*-------------------------------------------------------

Local cQry 		:= ""
Local cNumBor 	:= ""
Local cNomeBanco:= ""
Local cSepNeg   := If("|"$MV_CRNEG,"|",","), cSepProv  := If("|"$MVPROVIS,"|",","), cSepRec := If("|"$MVRECANT,"|",",")
Local aArea 	:= GetArea()
Local _lRet		:= .F.

If(select("TRB1") > 0)
	TRB1->(DbCloseArea())
EndIf

cQry := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA,  E1_TIPO, A1_BCO1, A1__AGCLIE, A1__CCCLIE "
cQry += " FROM " + RetSqlName("SA1") + " SA1,"
cQry += " " + RetSqlName("SE1") + " SE1"
cQry += " WHERE SE1.D_E_L_E_T_ = ' ' "
cQry += " AND SA1.D_E_L_E_T_ = ' ' "
cQry += " AND SE1.E1_VENCREA BETWEEN '"+DtoS(dGet10)+"' AND '"+DtoS(dGet11)+"'"
cQry += " AND SE1.E1_EMISSAO < '" + DTOS(Date()) + "' "
cQry += " AND SE1.E1_SALDO > 0"
cQry += " AND SE1.E1_NUMBOR = ' ' And E1_NUMBCO = ' ' "
cQry += " AND SE1.E1_BAIXA = ' ' "
cQry += " AND SE1.E1_CLIENTE = SA1.A1_COD"
cQry += " AND SE1.E1_LOJA = SA1.A1_LOJA"
cQry += " AND SA1.A1_BCO1 = '"+_cBanco+"'"
cQry += " AND SA1.A1__AGCLIE = '"+_cAgencia+"'"
cQry += " AND SA1.A1__CCCLIE = '"+_cConta+"'"
cQry += " AND SE1.E1_SITUACA IN ('0','F','G') "
cQry += " AND A1__REMESS = 'S' "
cQry += " AND SE1.E1_IDCNAB = ' '            "
cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " "
cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " "
cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " "
cQry += " AND SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " "
cQry += " AND SE1.E1_TIPO NOT IN ('NP','CH') "
TcQuery cQry New Alias "TRB1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vai pegar o ultimo N£mero de bordero utilizado 				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
cNumBor := Replicate("0",6-Len(Alltrim(cNumBor)))+Alltrim(cNumBor)
__lNumB	:= .T.
While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
	// busca o proximo numero disponivel
	cNumBor := Soma1(cNumBor)
EndDo

dbSelectArea("TRB1")
TRB1->(DbGoTop())
While ! TRB1->(Eof())
	
	_xcBCO		:= subst(TRB1->A1_BCO1,1,TAMSX3("A6_COD")[1])
	_xcAGE		:= subst(TRB1->A1__AGCLIE,1,TAMSX3("A6_AGENCIA")[1])
	_xcCTA		:= subst(TRB1->A1__CCCLIE,1,TAMSX3("A6_NUMCON")[1])

	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+ _XcBCO + _XcAGE + _XcCTA,.F.) 

	DbSelectArea("Z27")
	DbSetOrder(2)
	If DbSeek(xFilial("Z27")+SA6->A6_COD+SA6->A6__INSTPR)
		_cInstr1 := Z27->Z27_INSBCO
    Else
       	alert("Instrucao bancária 1 não localizada para o banco " + SA6->A6_NREDUZ + Chr(10) + Chr(13) + "Processo cancelado")
       	Return
    EndIf

	DbSelectArea("Z27")
	DbSetOrder(2)
	If DbSeek(xFilial("Z27")+SA6->A6_COD+SA6->A6__INSTSE)
		_cInstr2 := Z27->Z27_INSBCO
	Else
	   	alert("Instrucao bancária não 2 localizada para o banco " + SA6->A6_NREDUZ + Chr(10) + Chr(13) + "Processo cancelado")
	  	Return
	EndIf

	RecLock("SEA",.T.)
	SEA->EA_FILIAL  := xFilial("SEA")
	SEA->EA_NUMBOR  := cNumBor
	SEA->EA_DATABOR := dDataBase
	SEA->EA_PORTADO := TRB1->A1_BCO1
	SEA->EA_AGEDEP  := TRB1->A1__AGCLIE
	SEA->EA_NUMCON  := TRB1->A1__CCCLIE
	SEA->EA_NUM 	:= TRB1->E1_NUM
	SEA->EA_PARCELA := TRB1->E1_PARCELA
	SEA->EA_PREFIXO := TRB1->E1_PREFIXO
	SEA->EA_TIPO	:= TRB1->E1_TIPO
	SEA->EA_CART	:= "R"
	SEA->EA_SITUACA := ALLTRIM(cGet12) 
	SEA->EA_SITUANT := "0"
	SEA->EA_FILORIG := TRB1->E1_FILIAL
	SEA->EA__TIPGER := "1"          
	SEA->(MsUnlock())
	_lRet := .T.
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek(  TRB1->E1_FILIAL + TRB1->E1_PREFIXO + TRB1->E1_NUM + TRB1->E1_PARCELA + TRB1->E1_TIPO )
		
		_xcBCO		:= subst(TRB1->A1_BCO1,1,TAMSX3("A6_COD")[1])
		_xcAGE		:= subst(TRB1->A1__AGCLIE,1,TAMSX3("A6_AGENCIA")[1])
		_xcCTA		:= subst(TRB1->A1__CCCLIE,1,TAMSX3("A6_NUMCON")[1])

		RecLock("SE1",.F.)
		SE1->E1_PORTADO := TRB1->A1_BCO1
		SE1->E1_AGEDEP  := TRB1->A1__AGCLIE
		SE1->E1_SITUACA := ALLTRIM(cGet12) 
		SE1->E1_NUMBOR  := cNumBor
		SE1->E1_DATABOR := dDataBase
		SE1->E1_MOVIMEN := dDataBase
		SE1->E1_CONTA	:= TRB1->A1__CCCLIE
		SE1->E1_INSTR1	:= _cInstr1
		SE1->E1_INSTR2	:= _cInstr2
		SE1->(MsUnlock())
		
	Endif

	DbSelectArea("TRB1")
	TRB1->(DbSkip())

End


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o mesmo numero de bordero gravado, quando ³
//³ ocorrer geracao de bordero em usuarios simultaneos.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cProxNum := cNumBor
Do While !FA060Num( cProxNum, .F. )
	cNumBor  := cProxNum
	cProxNum := Soma1( cNumBor )
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o N£mero do bordero atualizado					     ³
//³ Posicionar no sx6 sempre usando GetMv. N„o utilize Seek !!!  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX6")
PutMv("MV_NUMBORR",cNumBor)

RestArea( aArea )

Return _lRet

*------------------------------------------------------------
User Function IFINA11B(_cNumbor, _cBanco, _cAgencia, _cConta)
*------------------------------------------------------------

/*	
MV_PAR01 := Bordero De
MV_PAR02 := Bordero Ate
MV_PAR03 := Arquivo de Configuracao
MV_PAR04 := Arquivo de Saida
MV_PAR05 := Codigo do Banco
MV_PAR06 := Codigo Agencia
MV_PAR07 := Codigo Conta
MV_PAR08 := Codigo d SubConta
MV_PAR09 := Modelo
MV_PAR10 := Condidera Filiais
MV_PAR11 := Da Filial
MV_PAR12 := Ate Filial
MV_PAR13 := Quebra Por
MV_PAR14 := Seleciona Filiais
*/

For I:=1 To Len(aBorderos)
	
	__cBCO		:= subst(aBorderos[I][2],1,TAMSX3("A6_COD")[1])
	__cAGE		:= subst(aBorderos[I][3],1,TAMSX3("A6_AGENCIA")[1])
	__cCTA		:= subst(aBorderos[I][4],1,TAMSX3("A6_NUMCON")[1])

	cNomeBanco 	:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6_NOME")   
	cArqBor		:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6__NOMBOR")
	cCamBor		:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6__CAMBOR")
	cModArq		:= posicione("SA6",1,xFilial("SA6")+__cBCO+__cAGE+__cCTA,"A6__CNFCNA")        

	If aBorderos[I][1] .and. !Empty(__cBCO)
		_cPerg := PADR('AFI150',Len(SX1->X1_GRUPO))
		Pergunte('AFI150',.F.)
		
		DbSelectArea("SX1")
		DbSetOrder(1)
		
		If SX1->(DbSeek(_cPerg + "01"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With aBorderos[I][6]
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "02"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With aBorderos[I][6]
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "03"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With  Alltrim(cArqBor)
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "04"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With  Alltrim(cCamBor)
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "05"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With __cBCO
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "06"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With __cAGE
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "07"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With __cCTA
			SX1->(MsUnLock())
		Endif
		If SX1->(DbSeek(_cPerg + "09"))
			RecLock("SX1",.F.)
			Replace SX1->X1_CNT01 	With  Alltrim(cModArq)
			SX1->(MsUnLock())
		Endif
		
		//Chama Rotina para geracao do bordero
		FinA150(2)
		
		// Grava o campo EA__CNAB quando o IDCNAB do Bordero for Gerado
		__cNumBor := aBorderos[I][6]
		
		// Consulta titulos gerados CNAB
		If(select("TRB21") > 0)
			TRB21->(DbCloseArea())
		EndIf

		cQry := " SELECT DISTINCT E1_FILIAL, E1_NUMBOR "
		cQry += " FROM " + RetSqlName("SA1") + " SA1,"
		cQry += " " + RetSqlName("SE1") + " SE1,"
		cQry += " " + RetSqlName("SEA") + " SEA"
		cQry += " WHERE SE1.D_E_L_E_T_ = ' ' "
		cQry += " AND SA1.D_E_L_E_T_ = ' ' "
		cQry += " AND SEA.D_E_L_E_T_ = ' ' "
		cQry += " AND SE1.E1_VENCREA BETWEEN '"+DtoS(dGet10)+"' AND '"+DtoS(dGet11)+"'"
		cQry += " AND SE1.E1_EMISSAO < '" + DTOS(Date()) + "' "
		cQry += " AND SE1.E1_SALDO > 0"
		cQry += " AND SE1.E1_BAIXA = '        '"
		cQry += " AND SE1.E1_CLIENTE = SA1.A1_COD"
		cQry += " AND SE1.E1_LOJA = SA1.A1_LOJA"
		cQry += " AND SE1.E1_NUMBOR = SEA.EA_NUMBOR AND SEA.EA__TIPGER = '1' AND SEA.EA__CNAB <> 'S' "
		cQry += " AND SE1.E1_SITUACA NOT IN ('0','F','G')  "
		cQry += " AND SE1.E1_IDCNAB <> ' ' "  
		cQry += " AND SEA.EA_NUM = SE1.E1_NUM "
		cQry += " AND SEA.EA_PREFIXO = SE1.E1_PREFIXO "
		cQry += " AND SEA.EA_PARCELA = SE1.E1_PARCELA " 
		cQry += " AND SEA.EA_FILORIG = SE1.E1_FILIAL  "
		cQry += " AND SEA.EA_TIPO = SE1.E1_TIPO       "

		TcQuery cQry New Alias "TRB21"

		dbSelectArea("TRB21")
		TRB21->(DbGoTop())
		If ! TRB21->(Eof())       
		
			__cNumBor 	:= TRB21->E1_NUMBOR

			__cQrySEA	:= "UPDATE " + RetSQLName( "SEA" ) + " "
			__cQrySEA	+= "SET EA__CNAB = 'S' "
			__cQrySEA	+= "WHERE EA_FILORIG  = '" + TRB21->E1_FILIAL + "' " 
			__cQrySEA	+= "AND EA_NUMBOR  = '" + __cNumBor  + "' "
			__cQrySEA	+= "AND D_E_L_E_T_ = ' ' "
				
			nStatus 	:= TCSQLExec( __cQrySEA )
				
			If nStatus < 0
				MsgStop( "Ocorreu problemas. Erro: " + TCSQLError() )
			Else
				TCRefresh( "SEA" )
			Endif
				
		Endif
			
	Endif

Next I       

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IFINR13   ºAutor  ³Silverio Bastos     º Data ³  13/Fev/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa relatório em Crystal Report - 			          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IFINR13(aBorderos)
Local _aArea := GetArea()
Local cParms := ""

For xI := 1 To Len(aBorderos)

	If !Empty(ALLTRIM(aBorderos[xI][6]))
   		cParms += "'" + ALLTRIM(aBorderos[xI][6]) + "',"   
	Endif
	   	
Next xI

cParms:= left(cParms,len(cParms)-1)                    

If !Empty(cParms)
	x:="1;0;1;CES40011"              
	CallCrys("CES40011", cParms, x)   
Endif
restArea (_aArea)

Return(.t.)

*------------------------------------------------------------
User Function IFINA11D(_cNumbor, _cBanco, _cAgencia, _cConta)
*------------------------------------------------------------

Local __lCanc := .F.

//Confirma o cancelamento?
If(!MsgYesNo("Confirma cancelamento do Borderô ? ","ATENCAO"))
	Return
EndIf


For I:=1 To Len(aBorderos)
	
	If aBorderos[I][1] .and. !Empty(aBorderos[I][2])
		
		__cNumBor := aBorderos[I][6]
		
		// Consulta titulos nao gerados CNAB para exclusao
		If(select("TRB21") > 0)
			TRB21->(DbCloseArea())
		EndIf

		cQry := " SELECT DISTINCT E1_FILIAL, E1_NUMBOR "
		cQry += " FROM " + RetSqlName("SA1") + " SA1,"
		cQry += " " + RetSqlName("SE1") + " SE1,"
		cQry += " " + RetSqlName("SEA") + " SEA"
		cQry += " WHERE SE1.D_E_L_E_T_ = ' ' And SEA.D_E_L_E_T_ = ' ' "
		cQry += " AND SA1.D_E_L_E_T_ = ' ' "
		cQry += " AND SE1.E1_VENCREA BETWEEN '"+DtoS(dGet10)+"' AND '"+DtoS(dGet11)+"'"
		cQry += " AND SE1.E1_EMISSAO < '" + DTOS(Date()) + "' "
		cQry += " AND SE1.E1_SALDO > 0"
		cQry += " AND SE1.E1_BAIXA = '        '"
		cQry += " AND SE1.E1_CLIENTE = SA1.A1_COD"
		cQry += " AND SE1.E1_LOJA = SA1.A1_LOJA"
		cQry += " AND SE1.E1_NUMBOR = '" + __cNumBor +"' AND SEA.EA__TIPGER = '1' AND SEA.EA__CNAB <> 'S' "
		cQry += " AND SE1.E1_SITUACA NOT IN ('0','F','G')  "
		cQry += " AND SE1.E1_IDCNAB = ' ' " 
		cQry += " AND SEA.EA_NUM = SE1.E1_NUM "
		cQry += " AND SEA.EA_PREFIXO = SE1.E1_PREFIXO "
		cQry += " AND SEA.EA_PARCELA = SE1.E1_PARCELA " 
		cQry += " AND SEA.EA_FILORIG = SE1.E1_FILIAL  "
		cQry += " AND SEA.EA_TIPO = SE1.E1_TIPO       "

		TcQuery cQry New Alias "TRB21"

		dbSelectArea("TRB21")
		TRB21->(DbGoTop())                           
		
		While ! TRB21->(Eof())       
		
			__cNumBor := TRB21->E1_NUMBOR	
		
			// Apagar o Bordero
			__cQrySEA	:= "UPDATE " + RetSQLName( "SEA" ) + " "
			__cQrySEA	+= "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_  "
			__cQrySEA	+= "WHERE EA_FILORIG  = '" + TRB21->E1_FILIAL + "' " 
			__cQrySEA	+= "AND EA_NUMBOR  = '" + __cNumBor  + "' "
			__cQrySEA	+= "AND D_E_L_E_T_ = ' ' "
				
			nStatus 	:= TCSQLExec( __cQrySEA )
			
			If nStatus < 0
				MsgStop( "Ocorreu problemas. Erro: " + TCSQLError() )
			Else
				TCRefresh( "SEA" )
			Endif
				
			// Limpar o Bordero / Banco / Data Bordero e Movimento
			__cQrySE1	:= "UPDATE " + RetSQLName( "SE1" ) + " "
			__cQrySE1	+= "SET E1_NUMBOR = ' ', E1_SITUACA = '0', E1_PORTADO = ' ', E1_AGEDEP = ' ', E1_DATABOR = ' ', E1_MOVIMEN = ' ', E1_CONTA = ' ', "
			__cQrySE1	+= "E1_INSTR1 = ' ', E1_INSTR2 = ' ' "
			__cQrySE1	+= "WHERE E1_FILORIG  = '" + TRB21->E1_FILIAL + "' "
			__cQrySE1	+= "AND E1_NUMBOR  = '" + __cNumBor  + "' "
			__cQrySE1	+= "AND D_E_L_E_T_ = ' ' "
				
			nStatus 	:= TCSQLExec( __cQrySE1 )
				
			If nStatus < 0
				MsgStop( "Ocorreu problemas. Erro: " + TCSQLError() )
			Else
				TCRefresh( "SE1" ) 
				__lCanc := .T.
			Endif

			TRB21->(DbSkip())

		Enddo  
			
	Endif	
			
	If __lCanc 

		MsgInfo("Cancelado Bordero : " + __cNumBor)

		__lCanc := .F.
	
	Endif
                    
Next I                     

Return

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | _Instruc	| Autor | Silverio Bastos - Anadi Soluções    | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Carrega novas informacoes													  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function _Instruc()
Local _aArea := GetArea()
Local _aAreaSA6 := SA6->(GetArea())

_XcBCO		:= subst(aEmpresas[oLbx1:nAt,2],1,TAMSX3("A6_COD")[1])
_XcAGE		:= subst(aEmpresas[oLbx1:nAt,3],1,TAMSX3("A6_AGENCIA")[1])
_XcCTA		:= subst(aEmpresas[oLbx1:nAt,4],1,TAMSX3("A6_NUMCON")[1])
                                                                              	
DbSelectArea("SA6") 
dbSetOrder(1)
If dbSeek(xFilial("SA6")+ _XcBCO + _XcAGE + _XcCTA,.F.) 

	cGet20 		:= SA6->A6__OCORR
	cGet14 		:= SA6->A6__INSTPR
	cGet15 		:= SA6->A6__INSTSE 
	nGet16		:= SA6->A6__DIAPRO

Endif

DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+"10"+cGet20+"E")
	cGet13 := alltrim(SX5->X5_DESCRI)
Else
	cGet13 := ""
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5")+xFilial("ZX5")+"000011"+cGet14)
	cGet17 := alltrim(ZX5->ZX5_DSCITE)
Else
	cGet17 := ''
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5")+xFilial("ZX5")+"000011"+cGet15)
	cGet18 := alltrim(ZX5->ZX5_DSCITE)
Else
	cGet18 := ''
EndIf

oGet13:Refresh()
oGet14:Refresh()
oGet15:Refresh()
oGet16:Refresh()
oGet17:Refresh()
oGet18:Refresh()
oTotQt:Refresh()
oTotVl:Refresh()

RestArea(_aArea)
RestArea(_aAreaSA6)

Return .T.               

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | ValCpo	| Autor | Rubens Cruz - Anadi Soluções    	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Valida campos digitados														  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function ValCpo(_cCampo)     
Local _lRet := .F.

Do Case
	Case (UPPER(_cCampo) == 'CGET5') //Valida banco 
		DbSelectArea("SA6")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			cGet7 := ""
			_lRet := .T. 
		ElseIf Alltrim(&(_cCampo)) == "0"
			cGet6 := Padr("0",TAMSX3("A6_AGENCIA")[1])
			cGet9 := Padr("0",TAMSX3("A6_NUMCON")[1])
			cGet7 := "Tesouraria"
			_lRet := .T. 
		ElseIf DbSeek(xFilial("SA6")+cGet5)
			_lRet := .T. 
			cGet7 := SA6->A6_NREDUZ		
		EndIf
	Case (UPPER(_cCampo) == 'CGET6') //Valida Agencia 
		DbSelectArea("SA6")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			_lRet := .T. 
		ElseIf Alltrim(cGet5) == "0" .AND. Alltrim(&(_cCampo)) == "0"
			cGet7 := "Tesouraria"
			_lRet := .T. 
		ElseIf DbSeek(xFilial("SA6")+cGet5+cGet6)
			_lRet := .T. 
			cGet7 := SA6->A6_NREDUZ		
		EndIf
	Case (UPPER(_cCampo) == 'CGET9') //Valida Conta 
		DbSelectArea("SA6")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			_lRet := .T. 
		ElseIf Alltrim(cGet5) == "0" .AND. Alltrim(&(_cCampo)) == "0"
			cGet7 := "Tesouraria"
			_lRet := .T. 
		ElseIf DbSeek(xFilial("SA6")+cGet5+cGet6+&(_cCampo))
			_lRet := .T. 
			cGet7 := SA6->A6_NREDUZ		
		EndIf
	Case (UPPER(_cCampo) == 'CGET12') //Valida Tipo de Cobrança 
		DbSelectArea("SX5")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			_lRet := .T. 
			cGet19 := ""
		ElseIf Dbseek(xFilial("SX5")+"07"+&(_cCampo))
			_lRet := .T. 
			cGet19 := SX5->X5_DESCRI
		EndIf
	Case (UPPER(_cCampo) == 'CGET20') //Valida Ocorrencia 
		DbSelectArea("SX5")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			_lRet := .T. 
			cGet13 := ""
		ElseIf Dbseek(xFilial("SX5")+"10"+&(_cCampo)+"E")
			_lRet := .T. 
			cGet13 := SX5->X5_DESCRI
		EndIf
	Case (UPPER(_cCampo) == 'CGET14') //Valida Primeira Instrucao 
		DbSelectArea("ZX5")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			_lRet := .T. 
			cGet17 := ""
		ElseIf Dbseek(xFilial("ZX5")+"  "+"000011"+&(_cCampo))
			_lRet := .T. 
			cGet17 := ZX5->ZX5_DSCITE
		EndIf
	Case (UPPER(_cCampo) == 'CGET15') //Valida Segunda Instrucao 
		DbSelectArea("ZX5")
		DbSetOrder(1)
		If Empty(&(_cCampo))
			_lRet := .T. 
			cGet18 := ""
		ElseIf Dbseek(xFilial("ZX5")+"  "+"000011"+&(_cCampo))
			_lRet := .T. 
			cGet18 := ZX5->ZX5_DSCITE
		EndIf
EndCase

Return _lRet                

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | FiltDad	| Autor | Rubens Cruz - Anadi Soluções    	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Filtra dados para preencher acols dos titulos marcados						  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function FiltDad()       
     
//Valida campos antes de rodar a query 
If(Empty(cGet5) .OR. Empty(cGet6) .OR. Empty(cGet9) )
	Alert("Dados do banco não preenchidos")
	Return
EndIf

If(Empty(dGet10) .OR. Empty(dGet11) )
	Alert("Data não preenchida")
	Return
EndIf

BuscaDados(2)

nTotVl := 0
nTotQt := 0

aEmpresas := {}

dbSelectArea("TRB")
TRB->(DbGoTop())
If TRB->(Eof())
	Aadd(aEmpresas,{.F.,'', '', '', 0,  0 })
Else
	While ! TRB->(Eof())
        nTotVl += TRB->TOTAL
        nTotQt += TRB->QUANTIDADE
        
		Aadd(aEmpresas,{.F.,TRB->A1_BCO1, TRB->A1__AGCLIE, TRB->A1__CCCLIE, TRB->QUANTIDADE,  TRB->TOTAL })
		TRB->(DbSkip())
	End
Endif

oLbx1:aArray := aEmpresas
oLbx1:Refresh()

oLbx1:nAt := (Len(oLbx1:aArray))
_Instruc()
oLbx1:nAt := 1

Return  

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | RefMark	| Autor | Rubens Cruz - Anadi Soluções    	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Da Refresh na janela principal depois de fazer os processos					  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function RefMark(_nTipo)  

BuscaDados(_nTipo)

aEmpresas := {}

dbSelectArea("TRB")
TRB->(DbGoTop())
If TRB->(Eof())
	Aadd(aEmpresas,{.F.,'', '', '', 0,  0 })
Else
	While ! TRB->(Eof())
		Aadd(aEmpresas,{.F.,TRB->A1_BCO1, TRB->A1__AGCLIE, TRB->A1__CCCLIE, TRB->QUANTIDADE,  TRB->TOTAL })
		TRB->(DbSkip())
	End
Endif

oLbx1:aArray := aEmpresas
oLbx1:Refresh()
                 
Return