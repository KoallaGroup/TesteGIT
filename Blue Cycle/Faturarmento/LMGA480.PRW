#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LMAG480 8     ºAutor  ³ CLEBER CONDE       º Data ³         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LMGA480()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lRet:=.T.
	Local aFixe :={}
	aFixe := {{"Pedido"		,"C5_NUM"	 	},;
 			  {"Separador"	,"C5_YSEPARA"	},; //"Numero da NF"
              {"Dt.Inicio"	,"C5_YDTASEP"	},; //"Serie da NF "
              {"Hr.Inicio"	,"C5_YHORASEP"	},; //"Serie da NF "
              {"Dt.Final" 	,"C5_YDTFIMSE"	},; //"Serie da NF "
              {"Hr.Final" 	,"C5_YHOFIMSE"	}}  //"Serie da NF "

	Private cCondicao := "",cIndex := ""
	Private aIndSC9   := {}
	Private nIndSC9   := 0
	Private aAC		  := {"Abandona","Confirma"}
	Private aACRL	  := {"Abandona","Confirma","Rejeita","Libera todo o Pedido"}
	Private aPos	  := {8,4,11,74}
	Private lFiltra	  := .F.
	Private cAlias	  := "SC5"
	Private lEstoque,nIndex,nmv_par01 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private	aRotina := {{'Pesquisar'  ,'AxPesqui'	 ,0,1},;
						{'Visualizar' ,'AxVisual'	 ,0,2},; // VISUALIZAR
		                {'Sep.Inicio' ,'U_LMG480ALT' ,0,4},; // MANUAL LIBERACAO
		                {'Sep.Fin  '  ,'U_LMG480FIN' ,0,4},; // MANUAL LIBERACAO
		                {'Legenda'    ,'U_P450LEG'	 ,0,8}}  // LEGENDA

	Private lFiltra := .F.

	Private aAC     := {"Abandona","Confirma"}
	Private aACRL   := {"Abandona","Confirma","Rejeita","Libera todo o Pedido"}
	Private aPos    := {8,4,11,74}
	Private lFiltra := .F.

// I-BLOCK

	Private aLocal := {}
	Private cGeraBlq

	Private	_cEmpUso  	:= AllTrim(cEmpAnt) + "/",;
			_bFiltraBrw	:= ""
			_aIndexSC5 	:= {}
			_cFiltro  	:= ""

	Private	aCores := {{"SC5->C5_YSTATUS=='01'", 'BR_VERMELHO_OCEAN'},; // Alcada
					   {"SC5->C5_YSTATUS=='02'", 'BR_VERDE_OCEAN'   },; // Credito
					   {"SC5->C5_YSTATUS=='05'", 'BR_LARANJA_OCEAN' },; // Separacao
					   {"SC5->C5_YSTATUS=='06'", 'BR_CINZA_OCEAN'   },; // Conferencia
					   {"SC5->C5_YSTATUS=='03'", 'BR_AMARELO_OCEAN' },; // Disponivel a Faturar
					   {"SC5->C5_YSTATUS=='04'", 'BR_PRETO_OCEAN'   },; // Faturado
					   {"SC5->C5_YSTATUS=='07'", 'BR_AZUL_OCEAN'    }}  // Despachado

	Private aCampos	  := {}
	Private cCadastro := OemToAnsi("Separacao de Pedidos")

	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGoTop())

	_cFiltro := " AllTrim(SC5->C5_YSTATUS) = '05' "

	If !Empty(_cFiltro)
		_bFiltraBrw := {|| FilBrowse("SC5",@_aIndexSC5,@_cFiltro)}
		Eval(_bFiltraBrw)
	EndIf

	dbSelectArea("SC5")

	AADD(aCampos,"C5_YSEPARA")
	AADD(aCampos,"C5_YDTASEP")
	AADD(aCampos,"C5_YHORASEP")
	AADD(aCampos,"C5_YDTFIMSE")
	AADD(aCampos,"C5_YHOFIMSE")
 
	mBrowse(6,1,22,75,"SC5",aFixe,,,,,aCores)

	EndFilBrw("SC5",_aIndexSC5)
Return(.T.)

User Function A480IVLD()
	Local lRet := .T.

	IF Empty(M->C5_YSEPARA)
		lRet := .F.
		MsgStop("Informe separador!")
	EndIF

	IF Empty(M->C5_YDTASEP)
		lRet := .F.
		MsgStop("Informe data separacao!")
	EndIF

	IF Empty(M->C5_YHORASEP)
		lRet := .F.
		MsgStop("Informe hora separacao!")
	EndIF

	IF (M->C5_YDTASEP) < M->C5_EMISSAO
		lRet := .F.
		MsgStop("Data separacao nao pode ser anterior a data emissao pedido!")
	EndIF
Return(lRet)

User Function A480SETVAL()
	M->C5_YDTASEP	:= dDatabase
	M->C5_YHORASEP	:= Time()
Return(Nil)

User Function LMG480ALT(cAlias,nReg,nOpc)
	Local aCampos2	:= {}
	Local nOpca		:= 0
	Local nRec		:= Recno()
	Local aAlter	:= {"C5_YSEPARA","C5_YDTASEP","C5_YHORASEP"}
	Local cTudoOk	:= "EXECBLOCK('A480IVLD')"
	Local cSetVal	:= "U_A480SETVAL()"

	IF !Empty(SC5->C5_YSEPARA)
		lRet := .F.
		MsgStop(" Separação inicial já informada!")
    	Return(.F.)
	EndIF

	IF !Empty(SC5->C5_YDTASEP)
		lRet := .F.
		MsgStop("Ja Informado  data separacao!")
		Return(.F.)
	EndIF

	Aadd(aCampos2,"C5_NUM")
	Aadd(aCampos2,"C5_YSEPARA")
	Aadd(aCampos2,"C5_YDATCONF")

	Begin Transaction
		nOpcA:=AxAltera(cAlias,nReg,nOpc,aAlter,aCampos2,,,cTudoOk,,cSetVal)
	End Transaction    
	U_LMG410Status()
	
Return(.T.)

User Function A480FVLD()
	Local lRet := (.T.)

	IF Empty(M->C5_YSEPARA)
		lRet := .F.
		MsgStop("Informe separador!")
	EndIF

	IF Empty(M->C5_YDTASEP)
		lRet := .F.
		MsgStop("Informe data separacao!")
	EndIF

	IF Empty(M->C5_YHORASEP)
		lRet := .F.
		MsgStop("Informe hora separacao!")
	EndIF

	IF (M->C5_YDTASEP) < M->C5_EMISSAO
		lRet := .F.
		MsgStop("Data separacao nao pode ser anterior a data emissao pedido!")
	EndIF

	IF Empty(M->C5_YDTFIMSE)
		lRet := .F.
		MsgStop("Informe data final separacao!")
	EndIF

	IF Empty(M->C5_YHOFIMSE)
		lRet := .F.
		MsgStop("Informe hora final separacao!")
	EndIF

	IF (M->C5_YDTFIMSE) < M->C5_YDTASEP
		lRet := .F.
		MsgStop("Data final separacao nao pode ser anterior a data inicio separacao!")
	EndIF
Return(lRet)

User Function LMG480FIN(cAlias,nReg,nOpc)
	Local lRet	:= .F.
	Local cData := DtoC(dDatabase)
	Local cTime := Time()

	/*Local nOpca := 0
	Local nRec := Recno()
	LOCAL aAlter:={"C5_YDTFIMSE","C5_YHOFIMSE"}
	Local cTudoOk :="EXECBLOCK('A480FVLD') "
	Local cSetVal := "U_A480SETVAL('F')"

	IF Empty(SC5->C5_YDTASEP)
		lRet := .F.
		MsgStop("Informe data separacao inicial!")
		Return(.F.)
	EndIF

	IF Empty(SC5->C5_YSEPARA)
		lRet := .F.
		MsgStop("Informe separador!")
		Return(.F.)
	EndIF

	IF Empty(SC5->C5_YHORASEP)
		lRet := .F.
		MsgStop("Informe hora  inicio separacao!")
		Return(.F.)
	EndIF

	Begin Transaction
		nOpcA:=AxAltera(cAlias,nReg,nOpc,aAlter,,,,cTudoOk,,cSetVal)
	End Transaction

	IF nOpca == 1
		RecLock("SC5",.F.)
		SC5->C5_YSTATUS := "06"
		msUnlock()
	EndIF*/

	If Empty(SC5->C5_YDTASEP) .Or. Empty(SC5->C5_YSEPARA) .Or. Empty(SC5->C5_YHORASEP)
		lRet := .F.
		MsgStop("Separacao inicial não executada!")
		Return(.F.)
	EndIf

	lRet := MsgBox("Deseja confirmar o final da separação para o dia: " + cData + " as " + cTime + " horas?","Atenção","YESNO")

	If lRet
		RecLock("SC5",.F.)
		SC5->C5_YSTATUS := "06"
		SC5->C5_YDTFIMSE := cTod(cData)
		SC5->C5_YHOFIMSE := cTime
		msUnlock()                      
		
		U_LMG410Status()

	EndIf
Return(Nil)