// Criar campo UA__TEL ==>PARA INDICAR O FILTRO "TELEFONE" - c 1 NAO USADO - 1-SIM = 2-NAO - COLOCAR COMBO DE OPÇOES -- OK 22.09.2014
// UA__PEDMEX INDICA QUE VEIO DE OUTRO LOCAL QUANDO ESTIVER PREENCHIDO, INDICA OUTRO LOCAL -- OK 22.09.2014
// para o campo telefone ==> UA_TMK = 1, 2 VEIO POR TELEFONE  -- OK 22.09.2014

// PARA USUARIO ==> OPERADOR - CODIGO, NOME - VERIFICAR -- CADASTRO DE OPERADOR SU7 U7_COD=UA_OPERADO
// PARA OPERACAO ==>UA_TMK = PEGAR DESCRICAO DA TALEBA 1, 2 VEIO POR TELEFONE UA_OPERADO - 


#INCLUDE "PROTHEUS.CH"
#include "Rwmake.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ITMKC01   ³ Autor ³ Marcelo H. Sanches    ³ Data ³08/09/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ITMKC01()
// Variaveis Locais da Funcao
Local oclieNome
Local ocliente
Local ocDDDRep
Local ocDDDTra
Local ocFil
Local ocFilNome
Local ocFoneRep
Local ocFoneTra
Local ocGOL
Local ocOpeNome
Local ocOpera
Local ocOriNome
Local ocRepNome
Local ocRepr
Local ocSeg
Local ocSegNome
Local ocSit
Local ocSitNome
Local ocTpCno
Local ccTpCno
Local ocTraNome
Local ocTransp
Local ocUsuario
Local ocUsuNome
Local odDataAte
Local odDataDe
Local acTpCno	 := {	"Vendas ", "Brindes", "Ambos  "}
Local oTel
//Local cOrigem	 := Space(25)
//Local ocOrigem
//Local cOriNome		:= Space(25)

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
// Variaveis Private da Funcao
Private oDlgDPF				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        
Private cClieNome	:= Space(50)
Private cCliente		:= Space(9)
Private cDDDRep		:= Space(3)
Private cDDDTra		:= Space(3)
Private cFil			:= Space(2)
Private cFilNome		:= Space(25)
Private cFoneRep		:= Space(15)
Private cFoneTra		:= Space(15)
Private lGOL			:= Space(1)
Private oTRNome
Private oStatus
Private oCliPed

Private cOpeNome		:= Space(25)                                                                                                                  
Private cOpera			:= Space(25)

Private cRepNome		:= Space(50)
Private cRepr			:= Space(6)
Private cSeg			:= Space(2) //U_VALSEGTO(cSeg)
Private cSegNome		:= Space(20) 
Private cSit			:= Space(3)
Private cSitNome		:= Space(30)
Private cTpCno			:= Space(25)// VER REGRAS COM JORGE
Private cTraNome		:= Space(30)
Private cTransp			:= Space(6)
Private cUsuario		:= Space(6)
Private cUsuNome		:= Space(25)
Private cdDataAte		:= dDataBase
Private cdDataDe		:= dDataBase
Private aComboOP	 	:= {"1=Receptivo","2=Ativo","3=Fax","4=Representante","       "}
Private cComboOP

// Privates das NewGetDados
Private oGetDados1
Private aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
Private aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Private aAux 				:= {}                          
Private _SN				:=	.f.
Private _AcDc			:=	.f.
Private lTel			:=	.f.
DEFINE MSDIALOG oDlgDPF TITLE "Consulta de Transportadora por Pedido" FROM C(224),C(255) TO C(679),C(1041) PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1,@_aArea,@_aAlias,{"SA1","SA2"}) // GetArea

// Cria Componentes Padroes do Sistema
	@ C(002),C(025) Say "Filial:" Size C(012),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(002),C(040) MsGet ocFil Var cFil F3 "DLB" Size C(012),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocFil:bValid:={||Vazio() .OR. !Empty(posicione("SM0", 1, CEMPANT+CFIL, "M0_FILIAL")) }
	@ C(002),C(055) MsGet ocFilNome Var cFilNome Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocFilNome:bWhen:={||cFilNome:=If(Empty(cFil), "TODAS AS FILIAIS ", Sm0->M0_Filial), .f.}
//	@ C(002),C(150) Say "Origem:" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
//	@ C(002),C(170) MsGet ocOrigem Var cOrigem Size C(015),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
//	@ C(002),C(187) MsGet ocOriNome Var cOriNome Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	@ C(015),C(010) Say "Segmento:" Size C(027),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(015),C(040) MsGet ocSeg Var cSeg F3 "SZ7" Size C(015),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocSeg:bValid:={|| U_VALSEGTO(M->cSeg) }
	@ C(015),C(057) MsGet ocSegNome Var cSegNome Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocSegNome:bWhen:={||cSegNome:=Posicione("SZ7",1,xFilial("SZ7")+cSeg, "Z7_DESCRIC"), .f.}

	@ C(015),C(140) Say "Situacao:" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(015),C(160) MsGet ocSit Var cSit F3 "SZM" Size C(005),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocSit:bValid:={||Vazio() .Or. !Empty(Posicione("SZM", 1, xFilial("SZM")+cSit, "ZM_DESC"))}
	@ C(015),C(187) MsGet ocSitNome Var cSitNome Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocSitNome:bWhen:={||cSitNome:=If(!Empty(cSit), Szm->Zm_Desc, "TODAS AS SITUAÇÕES"),	 .f. }
	@ C(015),C(257) Say "Considerar:" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(015),C(280) ComboBox ccTpCno Items acTpCno Size C(072),C(010) PIXEL OF oDlgDPF

	@ C(027),C(012) Say "Cliente:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(027),C(040) MsGet ocliente Var cCliente F3 Posicione("SX3",2,"F2_CLIENTE", "X3_F3") Size C(025),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocliente:bValid:=&("{||("+StrTran((Posicione("SX3",2,"F2_CLIENTE", "X3_VALID")), "F2_CLIENTE", "CCLIENTE")+") }")
	@ C(027),C(080) MsGet oclieNome Var cClieNome Size C(180),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	oclieNome:bWhen:={||cClieNome:=If(Empty(cCliente), "TODOS OS CLIENTES", Posicione("SA1",1,xFilial("SA1")+cCliente, "A1_NOME")), .f.}

	@ C(027),C(270) CheckBox ocGOL Var lGOL Prompt "Gerado por outro Local?" Size C(060),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
//	@ C(027),C(332) MsGet ocGOL Var cGOL Size C(007),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
//	@ C(027),C(330) CheckBox ocGOL Var lGOL Prompt "cGOL" Size C(005),C(008) PIXEL OF oDlgDPF


	@ C(040),C(001) Say "Transportadora:" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(040),C(040) MsGet ocTransp Var cTransp F3 Posicione("SX3",2,"F1_TRANSP", "X3_F3") Size C(025),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocTransp:bValid:=&("{||("+StrTran((Posicione("SX3",2,"F2_TRANSP", "X3_VALID")), "F2_TRANSP", "CTRANSP")+") }")
	@ C(040),C(067) MsGet ocTraNome Var cTraNome Size C(150),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocTraNome:bWhen:={||cTraNome:=If(Empty(cTransp), "TODAS AS TRANSPORTADORAS", Posicione("SA4",1,xFilial("SA4")+cTransp, "A4_NOME")), .f.}
	@ C(040),C(245) Say "Telefone:" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(040),C(270) MsGet ocDDDTra Var cDDDTra Size C(010),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocDDDTra:bWhen:={||cDDDTra:=Posicione("SA4",1,xFilial("SA4")+cTransp, "A4_DDD"), .f.}
	@ C(040),C(282) MsGet ocFoneTra Var cFoneTra Size C(070),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocFoneTra:bWhen:={||cFoneTra:=Posicione("SA4",1,xFilial("SA4")+cTransp, "A4_TEL"), .f.}

	@ C(052),C(001) Say "Representante:" Size C(037),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(052),C(040) MsGet ocRepr Var cRepr F3 Posicione("SX3",2,"F2_VEND1", "X3_F3") Size C(025),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocRepr:bValid:=&("{||("+StrTran((Posicione("SX3",2,"F2_VEND1", "X3_VALID")), "F2_VEND1", "CREPR")+") }")
	@ C(052),C(067) MsGet ocRepNome Var cRepNome Size C(150),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocRepNome:bWhen:={||cRepNome:=If(Empty(cRepr), "TODOS OS REPRESENTANTES", Posicione("SA3",1,xFilial("SA3")+cRepr, "A3_NOME")), .f.}

	@ C(052),C(245) Say "Telefone:" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(052),C(270) MsGet ocDDDRep Var cDDDRep Size C(010),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocDDDRep:bWhen:={||cDDDRep:=Posicione("SA3",1,xFilial("SA3")+cRepr, "A3_DDDTEL"), .f.}
	@ C(052),C(282) MsGet ocFoneRep Var cFoneRep Size C(070),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocFoneRep:bWhen:={||cFoneRep:=Posicione("SA3",1,xFilial("SA3")+cRepr, "A3_TEL"), .f.}


	@ C(065),C(002) Say "A Partir Data:" Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(065),C(040) MsGet odDataDe Var cdDataDe Size C(030),C(009) COLOR CLR_BLACK Picture "@d" PIXEL OF oDlgDPF
	@ C(065),C(075) Say "Ate Data:" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(065),C(100) MsGet odDataAte Var cdDataAte Size C(030),C(009) COLOR CLR_BLACK Picture "@d" PIXEL OF oDlgDPF
	@ C(065),C(142) Say "Operação:" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(065),C(167) ComboBox cOpera Items aComboOP Size C(072),C(010) PIXEL OF oDlgDPF
//	@ C(065),C(167) MsGet ocOpera Var cOpera Size C(015),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
//	@ C(065),C(185) MsGet ocOpeNome Var cOpeNome Size C(090),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	@ C(065),C(245) Say "Usuário:" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(065),C(270) MsGet ocUsuario Var cUsuario F3 "SU7" Valid Vazio() .Or. ExistCpo("SU7")   Size C(030),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	@ C(065),C(300) MsGet ocUsuNome Var cUsuNome When .f. Size C(090),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgDPF
	ocUsuNome:bWhen:={||cUsuNome:=If(Empty(cUsuario), "TODOS OS USUARIOS", Posicione("SU7", 1, xFilial("SU7")+cUsuario, "U7_NOME")), .F.}
	
	@ C(080),C(252) CheckBox oTel Var lTel	Prompt "Por Telefone" Size C(048),C(008) PIXEL OF oDlgDPF

	@ C(078),C(005) Button "Pedidos" Action(SelecITs())					Size C(030),C(012) PIXEL OF oDlgDPF 
	@ C(078),C(045) Button "Pedido " Action(If(!Empty(ogetdados1:acols) .And. !Empty(ogetdados1:acols[ogetdados1:nat][2]),ShowPV(),MsgInfo("Nao ha pedido para exibir !", "escolha outro atendimento")))	Size C(030),C(012) PIXEL OF oDlgDPF 
	@ C(078),C(085) Button "Cancela" Action(Eval({||Close(oDlgDPF)}))	Size C(030),C(012) PIXEL OF oDlgDPF 

	@ C(192),C(010) Say "Cliente:" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(192),C(030) MsGet oCliPed Var Sa1->A1_Nome When .f. Size C(150),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF

	@ C(192),C(200) Say "Status Pedido:" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(192),C(235) MsGet oStatus Var Szm->Zm_Desc When .f. Size C(150),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF

	@ C(205),C(010) Say "Usuário:" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(205),C(030) MsGet oUsNome Var Su7->U7_Nome When .f. Size C(150),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF

	@ C(205),C(200) Say "Transportadora:" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF
	@ C(205),C(235) MsGet oTRNome Var Sa4->A4_Nome When .f. Size C(150),C(008) COLOR CLR_BLACK PIXEL OF oDlgDPF


	fGetDados1()

CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG oDlgDPF CENTERED 

Return(.T.)

/***************************/
Static Function fGetDados1()
/***************************/
Local nX			:= 0                                                                                                              
Local aGetAux1	:= {};                                       
// Vetor responsavel pela montagem da aHeader
Local aCpoGDa       	:= aGetAux1        
// Vetor com os campos que poderao ser alterados                                                                                
Local aAlter       	:= aGetAux1        
Local nSuperior    	:= C(090)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(005)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(190)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(385)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinOk       	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                         // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                         // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cFieldOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperDel     	:= ""              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cDelOk        	:= "AllwaysTrue"   // Funcao executada para validar a exclusao de uma linha do aCols                   
// Objeto no qual a MsNewGetDados sera criada                                      
Local oWnd          	:= oDlgDPF                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
                                                                                                                                
// Carrega aHead
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
DbSeek( "UA__FILIAL" )
Aadd( aHead, {"Local  ",			"Local",		SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UA_NUM" )
Aadd( aHead, {"Pedido  ",			"Pedido",	SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UA_EMISSAO" )
Aadd( aHead, {"Data  ",			"Data", 		SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UA_CLIENTE" )
Aadd( aHead, {"Cliente  ",		"Cliente",	SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UA_ESTE" )
Aadd( aHead, {"UF  ",				"Est",		SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

//DbSeek( )
Aadd( aHead, {"T  ",				"T",			SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

//DbSeek( )
Aadd( aHead, {"ST  ",				"STATUS",			SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

//DbSeek( )
Aadd( aHead, {"RP  ",				"RP",			SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

//DbSeek( )
Aadd( aHead, {"OP  ",				"OP",			SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

//DbSeek( )
Aadd( aHead, {"EST  ",				"EST",		SX3->X3_PICTURE,		SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UB_VLRITEM" )
Aadd( aHead, {"Vlr. Peça",		"PECA",		"@E 999,999,999.99",	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

//DbSeek( )
Aadd( aHead, {"Vlr. Pneu",		"PNEU",		"@E 999,999,999.99",	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UA_FRETE" )
Aadd( aHead, {"Frete",			"FRETE",		"@E 999,999,999.99",	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

DbSeek( "UB_VLRITEM" )
Aadd( aHead, {"Valor Itens",	"ITENS",		"@E 999,999,999.99",	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd(aAux,CriaVar(SX3->X3_CAMPO))

Aadd(aAux,.F.)                      
Aadd(aCol,aAux)                     

oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)                                   

oGetDados1:OBROWSE:BCHANGE:=;
{||Sa4->(DbSeek(xFilial("SA4")+Posicione("SC5", 1, xFilial("SC5")+oGetDados1:aCols[oGetDados1:nAt][2], "C5_TRANSP") ) ),oTRNome:ReFresh(), ;
Posicione("SZM",1, xFilial("SZM")+oGetDados1:aCols[oGetDados1:nAt][7], "ZM_DESC"),oStatus:ReFresh(),;
Posicione("SU7",1, xFilial("SU7")+oGetDados1:aCols[oGetDados1:nAt][10], "U7_NOME"),oUsNome:ReFresh(),;
Posicione("SA1",1, xFilial("SA1")+oGetDados1:aCols[oGetDados1:nAt][4], "A1_NOME"),oCliPed:ReFresh(), .t. }
//oGetDados1:OBROWSE:BCHANGE:={||Sa4->(DbSeek(xFilial("SA4")+Posicione("SC5", 1, xFilial("SC5")+oGetDados1:aCols[oGetDados1:nAt][2], "C5_TRANSP") ) ),oTRNome:ReFresh(),oStatus:ReFresh(), .t. }
oGetDados1:obrowse:BHEADERCLICK:={|ncol, n1,n2|IndexCol(n1, ncol, n2),}
oGetDados1:LINSERT:=.f.

Return Nil                                                                                                                      

/*************************/
Static Function IndexCol(_P1,_P2,_P3)
/*************************/
_SN:=!_SN
If _SN .And. _P1<>0
	If _AcDc
		oGetDados1:aCols:=ASORT(oGetDados1:aCols, , , { | x,y | x[_P1] <= y[_P1] } )

	ElseIf !_AcDc
		oGetDados1:aCols:=ASORT(oGetDados1:aCols, , , { | x,y | x[_P1] >= y[_P1] } )

	EndIf

	_AcDc:=!_AcDc
	oGetDados1:ReFresh()
	oGetDados1:oBrowse:ReFresh()

EndIf

Return Nil
/***********************/
Static Function ShowPV()
/***********************/
Local lRet:=.t.
If Empty(ogetdados1:acols) .or. Empty(ogetdados1:acols[ogetdados1:nat][2])
	MsgInfo("Nao ha pedido para exibir !", "escolha outro atendimento")

Else
	PRIVATE aRotina     := {{"","",0,1},{"Visualizar"   , "TK271CallCenter" , 0, 2 }}
	ChkFile("SUA")
	ChkFile("SUB")
	ChkFile("SB1")
	Sua->(DbSetOrder(8))
	Sua->(DbSeek( xFilial("SUA")+ogetdados1:acols[ogetdados1:nat][2] ))
	Sub->(dbseek(xfilial("SUB")+Sua->Ua_Num))
	TK271CallCenter("SUA",0,2)

Endif

Return lRet
/*****************************/
Static Function SelecITs()
/*****************************/
Local lRet:=.t.
Local cQry:=""
aCol:={}
Aadd( aHead, {"Local",			" Local ",		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Pedido",			" Pedido ",	SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Data ",			" Data ", 		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Cliente",		" Cliente ",	SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"UF",				" UF ",			SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"T",				" T ",			SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"ST",				" ST ",			SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"RP",				" RP ",			SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"OP",				" OP ",			SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"EST",			" EST ",		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Vlr. Peça",		" PECA ",		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Vlr. Pneu",		" PNEU ",		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Frete",			" FRETE ",		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
Aadd( aHead, {"Valor Itens",	" ITENS ",		SX3->X3_PICTURE,	SX3->X3_TAMANHO,	SX3->X3_DECIMAL, "", Sx3->X3_usado, Sx3->X3_Tipo, "", Sx3->X3_Context, Sx3->X3_CBox, Sx3->X3_Relacao} )
cQry+="SELECT "
cQry+="   UA__FILIAL	Local,"
cQry+="   UA_NUM	Pedido," 
cQry+="   UA_EMISSAO	Data, " 
cQry+="   UA_CLIENTE	Cliente,	 " 
cQry+="   UA_ESTE	UF, " 
cQry+="   CASE WHEN UA_TMK = '1' OR  UA_TMK = '2' THEN 'T' ELSE ' ' END T, " 
cQry+="   UA__STATUS	ST,			 " 
cQry+="   UA_VEND	RP,			 " 
cQry+="   UA_OPER	OP,			 " 
cQry+="   UA_OPERADO,			 " 
cQry+="   CASE WHEN SUM (SC6.C6_QTDRESE)<>0 THEN 'S' ELSE 'N' END	EST,		 " 
cQry+="   SUM(CASE WHEN (SB1.B1_TIPO<>'PA' AND SB1.B1_TIPO<>'PN') THEN UB_VLRITEM ELSE 0 END) PECA,  " 
cQry+="   SUM(CASE WHEN (SB1.B1_TIPO='CA' OR SB1.B1_TIPO='PN') THEN UB_VLRITEM ELSE 0 END) PNEU,  " 
cQry+="   SUM(UA_FRETE) FRETE,  " 
cQry+="   SUM(CASE WHEN (SB1.B1_TIPO='CA' OR SB1.B1_TIPO='PN') THEN UB_VLRITEM ELSE 0 END) + SUM(CASE WHEN (SB1.B1_TIPO<>'PA' AND SB1.B1_TIPO<>'PN') THEN UB_VLRITEM ELSE 0 END) + SUM(UA_FRETE) VLRITEM, " 
cQry+="   UA_NUM, " 
cQry+="   B1_TIPO " 
cQry+="FROM  " 
cQry+="   "+RetSqlName("SUA")+" SUA LEFT OUTER JOIN  " 
cQry+="   "+RetSqlName("SUB")+" SUB ON SUB.UB_NUM=SUA.UA_NUM AND SUB.D_E_L_E_T_=' ' LEFT OUTER JOIN " 
cQry+="   "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD=SUB.UB_PRODUTO AND SB1.D_E_L_E_T_=' ' LEFT OUTER JOIN " 
cQry+="   "+RetSqlName("SC6")+" SC6 ON SC6.C6_NUM=SUB.UB_NUMPCOM AND SC6.C6_ITEM=SUB.UB_ITEMPV AND SC6.D_E_L_E_T_=' ' " 
cQry+="WHERE " 
cQry+="   SUA.D_E_L_E_T_=' ' " 
If !Empty(cCliente)
	cQry+="	AND SUA.UA_CLIENTE='"+cCliente+"' " 

EndIf

If !Empty(cFil)
	cQry+="	AND SUA.UA__FILIAL='"+cFil+"' " 
	
EndIf

If lGOL
	cQry+="	AND UA__PEDMEX<>' ' "

EndIf

If !Empty(cOpera)
	cQry+="	AND SUA.UA_OPER='"+cOpera+"' " 

EndIf

If !Empty(cRepr)
	cQry+="	AND SUA.UA_VEND='"+cRepr+"' " 

EndIf

If !Empty(cSeg) .And. cSeg<>'0'
	cQry+="	AND SUA.UA__SEGISP='"+cSeg+"' " 

EndIf

If !Empty(cSit)
	cQry+="	AND SUA.UA__STATUS='"+cSit+"' " 

EndIf
If !Empty(ctpcno)
//	cQry+="	AND SUA.UA__TIPPED='"+cTpCno+"' " // VER REGRAS COM JORGE 

EndIf
	
If !Empty(cTransp)
	cQry+="	AND SUA.UA_TRANSP='"+cTransp+"' " 

EndIf

If lTel
	cQry+="	AND (SUA.UA__TEL='1' OR SUA.UA_TMK IN ('1','2')) " 

EndIf

If !Empty(cUsuario)
	cQry+="	AND SUA.UA_OPERADO='"+AllTrim(cUsuario)+"' " // VER REGRAS COM JORGE " 

EndIf

cQry+="	AND SUA.UA_EMISSAO>='"+Dtos(cdDataDe)+"' " 
cQry+="	AND SUA.UA_EMISSAO<='"+Dtos(cdDataAte)+"' " 
cQry+="GROUP BY  " 
cQry+="   UA__FILIAL " 
cQry+="	, UA_NUM " 
cQry+="	, UA_EMISSAO " 
cQry+="	, UA_CLIENTE " 
cQry+="	, UA_ESTE " 
cQry+="  , CASE WHEN UA_TMK = '1' OR  UA_TMK = '2' THEN 'T' ELSE ' ' END " 
cQry+="  , UA__STATUS	 " 
cQry+="	, UA_VEND " 
cQry+="	, UA_OPER " 
cQry+="	, UA_OPERADO " 
cQry+="	, 'EST' " 
cQry+="	, UA_NUM " 
cQry+="	, UB_NUM " 
cQry+="	, B1_TIPO " 
cQry+="ORDER BY " 
cQry+="   CLIENTE " 
cQry+="   , UA_EMISSAO DESC,UA_NUM DESC " 
If Select( "Consulta" )<>0;Consulta->(DbCloseArea());EndIf
DbUseArea( .t., "TOPCONN", TcGenQry(,,cQry), "Consulta" )
TcSetField("Consulta", "DATA", "D", 8,0)
While !Consulta->(Eof())
	aAux:={}
	For nXX:=1 To Consulta->(FCount())
		Aadd(aAux,Consulta->(FieldGet(nXX)))

	Next nXX

	Aadd(aAux,.F.)
	Aadd(aCol,aAux)
	Consulta->(DbSkip())

EndDo

ogetdados1:acols:={}
aEval(acol, {|z| aadd(ogetdados1:acols, z)})
oGetDados1:ReFresh()

Return lRet

/*********************/
Static Function C(nTam)                                                         
/*********************/
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                

/*****************************************************/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)                       
/*****************************************************/
Local _nN                                                                    
	// Tipo 1 = GetArea()                                                      
	If _nTipo == 1                                                             
		_aArea   := GetArea()                                                    
		For _nN  := 1 To Len(_aArqs)                                             
			DbSelectArea(_aArqs[_nN])                                              
			AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})                          
		Next                                                                     
	// Tipo 2 = RestArea()                                                     
	Else                                                                       
		For _nN := 1 To Len(_aAlias)                                             
			DbSelectArea(_aAlias[_nN,1])                                           
			DbSetOrder(_aAlias[_nN,2])                                             
			DbGoto(_aAlias[_nN,3])                                                 
		Next                                                                     
		RestArea(_aArea)                                                         
	Endif                                                                      
Return Nil                                                                   

/*****************************************/
Static Function NwFieldPos(oObjeto,cCampo)                                      
/*****************************************/
Local nCol := aScan(oObjeto:aHeader,{|x| AllTrim(x[2]) == Upper(cCampo)})       
Return(nCol)                                                                    
                                                                                
/************************************************/
Static Function NwFieldGet(oObjeto,cCampo,nLinha)                               
/************************************************/
Local nCol := aScan(oObjeto:aHeader,{|x| AllTrim(x[2]) == Upper(cCampo)})       
Local xRet                                                                      
// Se nLinha nao for preenchida Retorna a Posicao de nAt do Objeto              
Default nLinha := oObjeto:nAt                                                   
	xRet := oObjeto:aCols[nLinha,nCol]                                             
Return(xRet)                                                                    
                                                                                
/*********************************************************/
Static Function NwFieldPut(oObjeto,cCampo,nLinha,xNewValue)                     
/*********************************************************/
Local nCol := aScan(oObjeto:aHeader,{|x| AllTrim(x[2]) == Upper(cCampo)})       
// Se nLinha nao for preenchida Retorna a Posicao de nAt do Objeto              
Default nLinha := oObjeto:nAt                                                   
	// Alimenta Celula com novo Valor se este foi preenchido                       
	If !Empty(xNewValue)                                                           
		oObjeto:aCols[nLinha,nCol] := xNewValue                                      
	Endif                                                                          
Return Nil                                                                      
                                                                                
/****************************************/
Static Function NwDeleted(oObjeto,nLinha)                                       
/****************************************/
Local nCol := Len(oObjeto:aCols[1])                                             
Local lRet := .T.                                                               
// Se nLinha nao for preenchida Retorna a Posicao de nAt do Objeto              
Default nLinha := oObjeto:nAt                                                   
	// Alimenta Celula com novo Valor                                              
	lRet := oObjeto:aCols[nLinha,nCol]                                             
Return(lRet)                                                                    




// Consulta de Pedidos por Transportadora - MHSS - 08/09/2014 - Tela de detalhes
// tabelas basicas SUA e SUB
// itmka25.prw - fonte para pesquisar - outro consulta para verificar as regras.
// local = filial
// estado = uf do cliente
// Frete = frete da query
// vlr peça = PECA da query
// vlr Pneu = PENU da query
// Valor Itens = soma dos tres itens anteriores

// O CAMPO ORIGEM FOI RETIRADO A PEDIDO DO JORGE

_cQuery := " SELECT"
_cQuery += " CASE WHEN SZM.ZM_DESC IS NULL THEN 'COMERCIAL' ELSE SZM.ZM_DESC END AS SITUACAO,"
_cQuery += " COUNT(*) as NUM,"
_cQuery += " sum(case when SB1.B1_TIPO = 'PC' then SUA.UA_VLRLIQ end) as PECA,"
_cQuery += " sum(case when SB1.B1_TIPO = 'PN' OR SB1.B1_TIPO = 'CA' then SUA.UA_VLRLIQ end) as PNEU,"
_cQuery += " sum(SUA.UA_FRETE) as FRETE"
_cQuery += " FROM " + RetSqlName("SZM") + " SZM,"
_cQuery += " " + RetSqlName("SUA") + " SUA,"
_cQuery += " " + RetSqlName("SUB") + " SUB,"
_cQuery += " " + RetSqlName("SB1") + " SB1,"
_cQuery += " " + RetSqlName("SZF") + " SZF"
_cQuery += " WHERE SUA.UA_NUM = SUB.UB_NUM"
_cQuery += " AND SUA.UA__PRVFAT BETWEEN '" + dDataIni + "' AND '" + dDataFim + "'"
_cQuery += " AND SUB.UB_PRODUTO = SB1.B1_COD"
_cQuery += " AND SUA.UA_OPER = '1'"
_cQuery += " AND SZM.ZM_COD = SUA.UA__STATUS"
_cQuery += " AND SZF.ZF_COD = SUA.UA__TIPPED"
_cQuery += " AND SZM.D_E_L_E_T_ = ' '"
_cQuery += " AND SZF.D_E_L_E_T_ = ' '"
_cQuery += " AND SUA.D_E_L_E_T_ = ' '"
_cQuery += " AND SUB.D_E_L_E_T_ = ' '"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '"


