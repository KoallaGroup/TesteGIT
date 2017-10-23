#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LMAG450 8     ºAutor  ³ CLEBER CONDE       º Data ³            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



USER FUNCTION LMGA470
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lRet:=.T.
Local aFixe :={}
   aFixe  := {{"Pedido","C5_NUM"} ,;
              {"Conferencia" ,"C5_YCONFER" },;       //"Numero da NF"
              {"Dt.Inicio" ,"C5_YDTACONF" },;       //"Serie da NF "
              {"Hr.Inicio" ,"C5_YHORACON" },;       //"Serie da NF "
              {"Dt.Final"  ,"C5_YDTFIMC"},;       //"Serie da NF "
              {"Hr.Final"  ,"C5_YHOFIMC"}}        //"Serie da NF "


PRIVATE cCondicao:="",cIndex:=""

PRIVATE aIndSC9   := {} 
Private nIndSC9   := 0
PRIVATE lEstoque,nIndex,nmv_par01:=0
PRIVATE aAC     := { "Abandona","Confirma" }
PRIVATE aACRL   := { "Abandona","Confirma","Rejeita","Libera todo o Pedido" }
PRIVATE aPos    := {  8,  4, 11, 74 }
PRIVATE lFiltra := .f.
PRIVATE cAlias  := "SC5"


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


PRIVATE		aRotina   	:= {{ 'Pesquisar'  ,'AxPesqui'    ,0,1   },;
		                 	{ 'Visualizar' ,'AxVisual'    ,0,2   },;    // VISUALIZAR
		                	{ 'Inicio Conf','U_LMG470ALT' ,0,4   },;    // MANUAL LIBERACAO
		                	{ 'Fin Conf.'  ,'U_LMG470FIN' ,0,4   },;    // MANUAL LIBERACAO
		                	{ 'Legenda'    ,'U_P450LEG'   ,0,8   }}     // LEGENDA



PRIVATE lFiltra := .f.

PRIVATE aAC     := { "Abandona","Confirma" }
PRIVATE aACRL   := { "Abandona","Confirma","Rejeita","Libera todo o Pedido" }
PRIVATE aPos    := {  8,  4, 11, 74 }
PRIVATE lFiltra := .f.

// I-BLOCK

PRIVATE aLocal := {}
PRIVATE cGeraBlq

PRIVATE	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
		_bFiltraBrw	:= ''
		_aIndexSC5 	:= {}
		_cFiltro  	:= ''

	Private	aCores	:= {{"ALLTRIM(SC5->C5__STATUS)=='2'",'BR_VERMELHO_OCEAN'},; //Alcada
						{"ALLTRIM(SC5->C5__STATUS)=='3'",'BR_VERDE_OCEAN'   },; //Credito         
						{"ALLTRIM(SC5->C5__STATUS)=='4'",'BR_VIOLETA'   },; //Envio Pendente						
						{"ALLTRIM(SC5->C5__STATUS)=='6'",'BR_LARANJA_OCEAN' },; //Separacao
						{"ALLTRIM(SC5->C5__STATUS)=='7'",'BR_CINZA_OCEAN'   },; //Conferencia
						{"ALLTRIM(SC5->C5__STATUS)=='8'",'BR_AMARELO_OCEAN' },; //Disponivel a Faturar						
						{"ALLTRIM(SC5->C5__STATUS)=='9'",'BR_PRETO_OCEAN'   },; //Faturado 
						{"ALLTRIM(SC5->C5__STATUS)=='10'",'BR_BRANCO_OCEAN'   },; //Em Expedição 
						{"ALLTRIM(SC5->C5__STATUS)=='11'",'BR_AZUL_OCEAN'    }} //Expedido

PRIVATE  aCampos :={}

 AADD(aCampos ,"C5_YCONFER")
 AADD(aCampos ,"C5_YDTACONF")
 AADD(aCampos ,"C5_YHORACON")
 AADD(aCampos ,"C5_YHOFIMCO")
 AADD(aCampos ,"C5_YDTFIMCO")

 

	PRIVATE cCadastro:= OemToAnsi("Conferencia de Pedidos")

		DbSelectArea(cAlias)
		(cAlias)->(DbSetOrder(1))
		(cAlias)->(DbGoTop())

		_cFiltro := " AllTrim(SC5->C5__STATUS) = '7'   "

		If	! Empty(_cFiltro)
			_bFiltraBrw := {|| FilBrowse("SC5",@_aIndexSC5,@_cFiltro) }
			Eval(_bFiltraBrw)
		EndIf


		dbSelectArea("SC5")
 
		mBrowse(6,1,22,75,'SC5',aFixe,,,,,aCores)

	EndFilBrw("SC5",_aIndexSC5)

Return .t.

User Function A470SETVAL()
	M->C5_YDTACONF := DDatabase
	M->C5_YHORACON := Time()
Return                                  

USER Function LMG470ALT(cAlias, nReg, nOpc)
Local nOpca := 0,lRet := .T.
Local nRec := Recno()
Local aAlter :={ "C5_YCONFER" , "C5_YDTACONF" , "C5_YHORACON"  }
Local cTudoOk :="EXECBLOCK('A470IVLD') "
Local cSetVal := "U_A470SETVAL()"

IF Empty(SC5->C5_YSEPARA)
   lRet := .F.  
   
    MsgStop("Informe separador!")
    Return lRet
EndIF

IF Empty(SC5->C5_YDTASEP)
   lRet := .F.  
    MsgStop("Informe data separacao!")
    Return lRet
EndIF

IF Empty(SC5->C5_YHORASEP)
   lRet := .F.  
    MsgStop("Informe hora separacao!")
    Return lRet
EndIF

IF (SC5->C5_YDTASEP) < SC5->C5_EMISSAO
   lRet := .F.  
    MsgStop("Data separacao nao pode ser anterior a data emissao pedido!")
    Return lRet
EndIF

IF Empty(SC5->C5_YDTFIMSE)
   lRet := .F.  
    MsgStop("Informe data final separacao!")
    Return lRet
EndIF

IF Empty(SC5->C5_YHOFIMSE)
   lRet := .F.  
    MsgStop("Informe hora final separacao!")
    Return lRet
EndIF

IF (SC5->C5_YDTFIMSE) < SC5->C5_YDTASEP
   lRet := .F.  
    MsgStop("Data final separacao nao pode ser anterior a data inicio separacao!")
    Return lRet
EndIF

if lRet == .T.

	Begin Transaction
	nOpcA:=AxAltera( cAlias, nReg, nOpc,aAlter,     ,        ,         , cTudoOk, , cSetVal )
	End Transaction
	
	U_LMG410Status()
EndIF


Return lRet

USER Function A470FVLD()
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
                 

// CONFERENCIA

IF Empty(M->C5_YCONFER)
   lRet := .F.  
    MsgStop("Informe conferente!")
EndIF

IF Empty(M->C5_YDTACONF)
   lRet := .F.  
    MsgStop("Informe data conferencia!")
EndIF

IF Empty(M->C5_YHORACON)
   lRet := .F.  
    MsgStop("Informe hora conferencia!")
EndIF

IF (M->C5_YDTACONF) < M->C5_YDTASEP
   lRet := .F.  
    MsgStop("Data conferencia nao pode ser anterior a data separacao do pedido!")
EndIF

IF Empty(M->C5_YDTFIMCO)
   lRet := .F.  
    MsgStop("Informe data final conferencia!")
EndIF

IF Empty(M->C5_YHOFIMCO)
   lRet := .F.  
    MsgStop("Informe hora final conferencia!")
EndIF

IF (M->C5_YDTFIMCO) < M->C5_YDTACONF
   lRet := .F.  
    MsgStop("Data final conferencia nao pode ser anterior a data inicio conferencia!")
EndIF


Return lRet


USER Function LMG470FIN(cAlias, nReg, nOpc)
Local lRet := .F.
Local cData := dToc(dDatabase)
Local cTime := Time()

/*Local nOpca := 0
Local nRec := Recno()
Local aAlter :={  "C5_YHOFIMCO", "C5_YDTFIMCO"}
Local cTudoOk :="EXECBLOCK('A470FVLD') "



IF Empty(SC5->C5_YSEPARA)
   lRet := .F.    
    MsgStop("Informe separador!")
    Return lRet
EndIF

IF Empty(SC5->C5_YDTASEP)
   lRet := .F.  
    MsgStop("Informe data separacao!")
    Return lRet
EndIF

IF Empty(SC5->C5_YHORASEP)
   lRet := .F.  
    MsgStop("Informe hora separacao!")
    Return lRet
EndIF

IF (SC5->C5_YDTASEP) < SC5->C5_EMISSAO
   lRet := .F.  
    MsgStop("Data separacao nao pode ser anterior a data emissao pedido!")
    Return lRet
EndIF

IF Empty(SC5->C5_YDTFIMSE)
   lRet := .F.  
    MsgStop("Informe data final separacao!")
    Return lRet
EndIF

IF Empty(SC5->C5_YDTACONF)
   lRet := .F.  
    MsgStop("Informe data inicio conferencia!")
    Return lRet
EndIF

	Begin Transaction
	nOpcA:=AxAltera( cAlias, nReg, nOpc,aAlter,     ,        ,         ,cTudoOk )

	End Transaction

IF nOpca == 1
		RecLock("SC5",.F.)
		SC5->C5__STATUS := "07"           
		msUnlock()
EndIF
*/
         
If Empty(SC5->C5_YCONFER) .OR. Empty(SC5->C5_YDTACON) .OR. Empty(SC5->C5_YHORACO)
	lRet := .F.  
	MsgStop("Conferência inicial não executada!")
 	Return .F.    
EndIF


lRet := MsgBox("Deseja confirmar o final da conferência para o dia: " + cData + " as " + cTime + " horas?","Atenção","YESNO")

If lRet
	RecLock("SC5",.F.)
	ALLTRIM(SC5->C5__STATUS) := "8"
	SC5->C5_YDTFIMCO := cTod(cData)
	SC5->C5_YHOFIMCO := cTime
	msUnlock()         
	
	U_LMG410Status()

EndIf

Return





USER Function A470IVLD()
Local lRet := .T.

IF Empty(M->C5_YCONFER)
   lRet := .F.  
    MsgStop("Informe conferente!")
EndIF

IF Empty(M->C5_YDTACONF)
   lRet := .F.  
    MsgStop("Informe data conferencia!")
EndIF

IF Empty(M->C5_YHORACON)
   lRet := .F.  
    MsgStop("Informe hora conferencia!")
EndIF

IF (M->C5_YDTACONF) < M->C5_YDTASEP
   lRet := .F.  
    MsgStop("Data conferencia nao pode ser anterior a data separacao do pedido!")
EndIF

Return lRet
