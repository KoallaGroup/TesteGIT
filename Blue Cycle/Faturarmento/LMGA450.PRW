#INCLUDE "MATA450.CH"
#include "protheus.ch"	
#include 'tbiconn.ch'
#include 'topconn.ch'     
#INCLUDE "XMLXFUN.CH"
#DEFINE DIRMASC "\MSXML\"
#DEFINE DIRXMLTMP "\MSXMLTMP\"
#DEFINE ITENSSC6 300
#xCommand CLOSETRANSACTION LOCKIN <aAlias,...>   => EndTran( \{ <aAlias> \}  ); End Sequence
Static __lHasWSSTART



#DEFINE _LIMCREDM 1,1
#DEFINE _LIMCRED  1,2
#DEFINE _SALDUPM  2,1
#DEFINE _SALDUP   2,2
#DEFINE _SALPEDLM 3,1
#DEFINE _SALPEDL  3,2                               
#DEFINE _MCOMPRAM 4,1
#DEFINE _MCOMPRA  4,2
#DEFINE _SALDOLCM 5,1
#DEFINE _SALDOLC  5,2
#DEFINE _MAIDUPLM 6,1
#DEFINE _MAIDUPL  6,2
#DEFINE _ITATUM   7,1
#DEFINE _ITATU    7,2
#DEFINE _PEDATUM  8,1
#DEFINE _PEDATU   8,2
#DEFINE _SALPEDM  9,1
#DEFINE _SALPED   9,2
#DEFINE _VALATRM  10,1
#DEFINE _VALATR   10,2
#DEFINE _LCFINM   11,1
#DEFINE _LCFIN    11,2
#DEFINE _SALFINM  12,1
#DEFINE _SALFIN   12,2
#DEFINE _STRASALDOS 12,2
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LMAG450 8     ºor  ³ CLEBER CONDE       º Data ³         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LMGA450()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lRet		:= .T.
	Local cFiltro	:= ''
	Local aIndexSC5 := {}
	Private aAC     := {"Abandona","Confirma"}
	Private aACRL   := {"Abandona","Confirma","Rejeita","Libera todo o Pedido"}
	Private aPos    := {8,4,11,74}
	Private cAlias  := "SC5"
	Private cGerBlq
	Private bFilBrw	:= ""
	Public nAutoAdt 
	Private aColsCCust	:= {}                
	Private aBkpAgg	  := {}       
	Private	aCores	:= {{"ALLTRIM(SC5->C5__STATUS)=='2'",'BR_VERMELHO_OCEAN'},; //Alcada
 						{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. EMPTY(C5_PARECER)",'BR_VERDE_OCEAN'   },; //Credito  
						{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. !EMPTY(C5_PARECER)",'BR_AZUL_CLARO'   },; //Credito  Rejeitado
						{"ALLTRIM(SC5->C5__STATUS)=='4'",'BR_VIOLETA'   },; //Envio Pendente
						{"ALLTRIM(SC5->C5__STATUS)=='5'",'BR_MARROM'   },;
						{"ALLTRIM(SC5->C5__STATUS)=='6'",'BR_LARANJA_OCEAN' },; //Separacao
						{"ALLTRIM(SC5->C5__STATUS)=='7'",'BR_CINZA_OCEAN'   },; //Conferencia
						{"ALLTRIM(SC5->C5__STATUS)=='8'",'BR_AMARELO_OCEAN' },; //Disponivel a Faturar						
						{"ALLTRIM(SC5->C5__STATUS)=='9'",'BR_PRETO_OCEAN'   },; //Faturado 
						{"ALLTRIM(SC5->C5__STATUS)=='10'",'BR_BRANCO_OCEAN'   },; //Em Expedição 
						{"AlLTRIM(SC5->C5__STATUS)=='11'",'BR_AZUL_OCEAN'    },;//Expedido
						{"AlLTRIM(SC5->C5__STATUS)=='13'",'BR_PINK'    },;//Devolvido
						{"AlLTRIM(SC5->C5__STATUS)=='12'",'BR_CANCEL'    },;//Cancelado
						{"ALLTRIM(SC5->C5__STATUS)=='14'",'BR_VERDE_ESCURO'}} 
	Private cCadastro := OemToAnsi("Libera‡„o de Cr‚dito")
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
	Private	aRotina := {{'Pesquisar' ,'AxPesqui'  ,0,1},; //PESQUISA
						{'Visualizar','U_P450Vis' ,0,2},; //VISUALIZAR
						{'Manual'    ,'U_P450Man' ,0,4},; //MANUAL LIBERACAO
						{'Posicao'   ,'U_P450POS' ,0,5},; //POSICAO CLIENTE
						{'Legenda'   ,'U_P450LEG' ,0,8},; //LEGENDA
						{'Rel Ped'   ,'U_FSPEDBTN',0,9},;  //RELATORIO DO PEDIDO
						{'Posição Pedido' ,"U_BCDCONPED('1')",0,3,0 }}  //"Posição Pedido"
	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGoTop())
	cFiltro := " AllTrim(SC5->C5__STATUS) = '3'   "                                     
	If !Empty(cFiltro)
		bFilBrw := {|| FilBrowse("SC5",@aIndexSC5,@cFiltro)}
		Eval(bFilBrw)
	EndIf
	dbSelectArea("SC5")
	dbSetOrder(10)
	mBrowse(6,1,22,75,'SC5',,,,,,aCores)
	EndFilBrw("SC5",aIndexSC5)
Return(.T.)

User Function P450MAN()
	Local cPedido := SC5->C5_NUM
	Public nVer	  := .T.
	If GetMV("MV_GERABLQ",.T.)
		cGerBlq := GetMV("MV_GERABLQ")
	Else
		cGerBlq := "N"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So Ped. Bloqueados   mv_par01          Sim Nao               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC9")
	dbSetOrder(1)
	If dbSeek(xFilial("SC9") + cPedido)
		If FSBOXLOGIN()
		    dbSelectArea("SC5")
   			dbSetOrder(1)
   			If dbSeek(xFilial("SC5") + cPedido)
				//16-10-17 Begin Transaction //<- COLEN 24082012
				U_A450LibLMP()
				//End Transaction
			Else
				MsgStop("Pedido nao encontrado!")
	   		EndIf
		EndIF
	Else
		MsgStop("Pedido nao encontrado!")
	EndIf
Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} FSBOXLOGIN()
Funcao que cria janela para analista logar e aprovar/negar pedido de venda

@author	Rodrigo Prates
@since	20101005
@return lRet	Variavel contendo .T. ou .F. apos validacao da senha
/*/
//-------------------------------------------------------------------
Static Function FSBOXLOGIN()
	Local oDlg1
	Local lRet		:= .T.
	Local cUsuario	:= Space(25)
	Local cSenha	:= Space(10)
    Local lSaiTela	:= .F.
    
    While ! lSaiTela
		Define MsDialog oDlg1 From 200,250 To 300,450 Title "Login do Analista" Pixel
		@ 0.5,01 Say OemToAnsi("Usuario") Size 78,17 Of oDlg1
//		TGet():New(015,008,{|u| If(PCount() > 0,cUsuario := u,cUsuario)},oDlg1,55,08,,,,CLR_LIGHTGRAY,,,,.T.,,,,,,,.T.,,,)
		TGet():New(015,008,{|u| If(PCount() > 0,cUsuario := u,cUsuario)},oDlg1,55,08,"@S15",,,,,,,.T.,,,,,,,,,,)
		@ 2.0,01 Say OemToAnsi("Senha") Of oDlg1
		TGet():New(035,008,{|u| If(PCount() > 0,cSenha   := u,cSenha  )},oDlg1,55,08,,,,,,,,.T.,,,,,,,,.T.,,)
		Define sButton From 15,65 Type 1 Action {||(IIF(FSVALSENHA(cUsuario,cSenha),(lRet := .T.,lSaiTela := .T.,oDlg1:End()),lRet := .F.))} Enable Of oDlg1
		Define sButton From 30,65 Type 2 Action {||(lRet := .F.,lSaiTela := .T.,oDlg1:End())} Enable Of oDlg1
		Activate MsDialog oDlg1
    EndDo
    
Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} FSVALSENHA()
Funcao de validacao da senha do analista de credito

@author	Rodrigo Prates
@since	20101005
@param	cSenha	Variavel contendo senha do usuario a ser validada
@return lRet	Variavel contendo .T. ou .F. apos validacao da senha
/*/
//-------------------------------------------------------------------
Static Function FSVALSENHA(cUsuario,cSenha)

Local lRet := .T.

PSWOrder(2)
PswSeek(cUsuario) // exatamente igual ao cadastro do usuario

If ! PswName(cSenha)
   Aviso("Atenção", "Senha do gerente: está invalida!", {"Ok"})
	lRet := .F.
EndIf
        


//	PswOrder(3) //Seleciona a ordem de pesquisa de usuário/grupo - (3) - Senha do usuário
//	PswSeek(cSenha,.T.) //Pesquisa e posiciona o arquivo de senhas conforme a ordem informada na PswOrder() 
//	If !PswName(cSenha)
//		Help("",1,"INVSENHA")
//		lRet := .F.
//	EndIf
//	If lRet
//		ApMsgInfo("Seja Bem Vindo(a)  " + AllTrim(Upper(PswRet(1)[1][2]))) //Box de msg concatenando texto + posicao do vetor com o nome do usuario logado.
//	EndIf




Return(lRet)

User Function P450LEG()
//**************************************************************************************************************
//Criação da legenda e das cores dos status
//
//**********        

                                            
	Local aLegenda := {{'BR_VERMELHO_OCEAN','Alcada'	  },;
					   {'BR_VERDE_OCEAN'   ,'Credito'	  },; 
					   {'BR_AZUL_CLARO','Credito Rejeitado'},;
					   {'BR_MARROM', 'Aguard. Inicio Separação'},;
					   {'BR_LARANJA_OCEAN' ,'Separacao'	  },; 
					   {'BR_VIOLETA' ,'Aguardando Envio Sep'},; 
					   {'BR_CINZA_OCEAN'   ,'Conferencia' },;
					   {'BR_AMARELO_OCEAN' ,'Disp Faturar'},;
					   {'BR_PRETO'         ,'Faturado'	  },; 
					   {'BR_BRANCO'        ,'Em Expedição'	  },;
					   {'BR_AZUL_OCEAN'    ,'Expedido'  },;
					   {'BR_PINK'    ,'Devolvido'  },;
					   {'BR_CANCEL'    ,'Cancelado'  },;
					   {'BR_VERDE_ESCURO'    ,'Aguard. Pagamento'  }}
	BrwLegenda(cCadastro,'Legenda',aLegenda)
Return(.T.)

User Function P450POS()
	Local cCliente := SC5->C5_CLIENTE + SC5->C5_LOJACLI
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + cCliente)
		FC010CON()
	Else
		MsgStop("Cliente nao encontrado!")
	EndIF
Return(.T.)

User  Function P450VIS(cAlias,nReg,nOpc)
	Local cAlias :="SC5"
	Local nReg := Recno()
	Local nOpc :=2
	Local cPedido := SC5->C5_NUM
	dbSelectArea("SC9")
	dbSetOrder(1)
	IF dbSeek(xFilial("SC9")+cPedido)
		A410Visual(cAlias,nReg,nOpc)
	Else
		MsgStop("Pedido nao encontrado!")
	EndIf
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A450LibAut³ Autor ³ Rosane Luciane Chene  ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para gerar liberacoes automaticas de cred. e estoque³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA456                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                    
User Function P450LibAut()
	Local nOpca    := 0
	Local aSays    := {}
	Local aButtons := {}
	Local cPerg    := "LIBAT2"
	Local cAlias   := "SC9"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         
	//³ Utiliza arquivo de liberados para geracao na nota            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 Pedido de          ?                                 ³
	//³ mv_par02 Pedido ate         ?                                 ³
	//³ mv_par03 Cliente de         ?                                 ³
	//³ mv_par04 Cliente ate        ?                                 ³	
	//³ mv_par05 Dta Liberacao de   ?                                 ³
	//³ mv_par06 Dta Liberacao ate  ?                                 ³	
	//³ mv_par07 Quanto ao Estoque  ? Estoque/WMS  WMS                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Pergunte(cPerg,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nova forma de criar dialogos para processos Batch            ³
		//³ COMPATIVEL COM PROTHEUS (BOF)                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aSays,OemToAnsi(STR0006))
		AADD(aSays,OemToAnsi(STR0007))
		AADD(aButtons,{5,.T.,{||Pergunte(cPerg)}})
		AADD(aButtons,{1,.T.,{|o| nOpca:= 1,o:oWnd:End()}})
		AADD(aButtons,{2,.T.,{|o| o:oWnd:End()}})
		FormBatch(cCadastro,aSays,aButtons)
		IF nOpcA == 1
			Processa({|lEnd| Ma450Processa(cAlias,.T.,.T.,@lEnd,Nil,MV_PAR07 == 2)},,,.T.)
		EndIf
	EndIf
Return(Nil)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A450LibMan³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de liberacao manual do credito                        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina libera o credito em qualquer circunstancia despre³±±
±±³          ³zando a analise de credito do sistema. A liberacao de estoque³±±
±±³          ³sera realiada caso o credito seja liberado.                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A450LibLMP()
	Local aArea		:= GetArea()
	Local aAreaSC9  := SC9->(GetArea())
	Local aRegSC6   := {}
	Local lContinua	:= .T.
	Local lQuery    := .F.
	Local nOpcA     := 0
	Local cPedido	:= ""
	Local cAliasSC5 := "SC5"
	Local cAliasSC6 := "SC6"
	Local cAliasSC9 := "SC9"
	Local dLimLib   := dDataBase
	Local lMt450Fim := Existblock("MT450FIM")
	Local lProcessa := .T.	
	Local cProduto  := "" 
	Local cTesPedV  := ""
	Local cLocPedV  := ""
	Local lTesta    := .T. 			
	Local nSldDispo :=  0
	Local aRecReg := {}  //<- COLEN 24082012
	Local lErroC5 := .F. //<- COLEN 24082012
	Local _aResult	:= {}, _lAlt	:= .F. 	
	#IFDEF TOP
		Local cQuery := ""
	#ENDIF
	_aRetUser := {}
	_NomeUser := substr(cUsuario,7,15)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So Ped. Bloqueados   mv_par01          Sim Nao               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTA451",.F.)
	If (Existblock("MT450MAN"))
		lContinua := ExecBlock("MT450MAN",.F.,.F.)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o registro posicionado eh valido                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SC9->C9_BLCRED == "10" .Or. SC9->C9_BLEST == "10" .Or. SC9->C9_BLCRED == "ZZ" .Or. SC9->C9_BLEST == "ZZ")
		Help(" ",1,"A450NFISCA")
		lContinua := .F.
	EndIf
	If (SC9->C9_BLCRED == "  " .And. SC9->C9_BLEST == "  ")
		Help(" ",1,"A450JALIB")
		lContinua := .F.
	EndIf
	If (Empty(SC9->C9_BLCRED) .And. !Empty(SC9->C9_BLEST))
		Help(" ",1,"A450ESTOQ")
	   	lContinua := .F.   
	EndIf  
	If (lContinua)
		nOpcA := U_a450Tela2(@lContinua , .T. , .F.,@dLimLib)		
		If (nOpcA == 4)
			//U_P450POS()  
			lTesta := .f.
			/*lProcessa := .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para validacao do usuario                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (Existblock("MTA450LIB"))
				lProcessa:=ExecBlock("MTA450LIB",.f.,.f.,{SC9->C9_PEDIDO,SC9->C9_ITEM,nOpcA})
			EndIf
			If lProcessa
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Libera de Credito para o item da liberacao do Pedido de Venda ( SC9 )   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				a450Grava(1,.T.,.F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pontos de Entrada 													   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				If (ExistTemplate("MTA450I"))
					ExecTemplate("MTA450I",.f.,.f.,{nOpca,dLimLib})						
				EndIf
				If (Existblock("MTA450I"))
					ExecBlock("MTA450I",.f.,.f.,{nOpca,dLimLib})						
				EndIf
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Rejeicao do Credito para o item da liberacao do Pedido de Venda ( SC9 ) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
		ElseIf nOpcA == 3
			/*a450Grava(2,.T.,.F.)
			IF (Existblock("MTA450R"))
				ExecBlock("MTA450R",.f.,.f.)
			EndIf */
			//U_FSPEDBTN() 
			lTesta := .F.
		ElseIf nOpcA == 1 //.or. nOpcA == 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Liberacao para todos os itens do SC9                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			cPedido    := SC9->C9_PEDIDO 
			cQtd       := SC9->C9_QTDLIB
			cItem      := SC9->C9_ITEM
			cProduto   := SC9->C9_PRODUTO
			cLocPedV   := SC9->C9_LOCAL
			cSequencia := SC9->C9_SEQUEN
			dbSelectArea("SC9")
			dbSetOrder(1)
			#IFDEF TOP
				lQuery := .T.
				cAliasSC9 := "A450LIBMAN"
				cAliasSC5 := "A450LIBMAN"
				cAliasSC6 := "A450LIBMAN"
				cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_PRODUTO,C9_BLCRED,C9_ITEM,SC9.R_E_C_N_O_ SC9RECNO,SC5.C5_TIPLIB,"
				cQuery += "SC5.R_E_C_N_O_ SC5RECNO,SC6.R_E_C_N_O_ SC6RECNO, C9_QTDLIB,C9_ITEM,C9_SEQUEN, SC9.C9_LOCAL, C6_TES  "
				cQuery += "FROM " + RetSqlName("SC9") + " SC9,"
				cQuery += RetSqlName("SC5") + " SC5,"
				cQuery += RetSqlName("SC6") + " SC6 "			
				cQuery += "WHERE SC9.C9_FILIAL = '" + xFilial("SC9") + "' AND "
				cQuery += "SC9.C9_PEDIDO = '" + cPedido + "' AND "
				cQuery += "SC9.C9_BLCRED <> '   ' AND "
				/**If mv_par01 == 1
					cQuery += "SC9.C9_BLCRED <> '09' AND "				
				Endif**/
				cQuery += "SC9.C9_BLCRED <> '10' AND "
				cQuery += "SC9.C9_BLCRED <> 'ZZ' AND "
				cQuery += "SC9.D_E_L_E_T_ = ' ' AND "
				cQuery += "SC5.C5_FILIAL='" + xFilial("SC5") + "' AND "
				cQuery += "SC5.C5_NUM = SC9.C9_PEDIDO AND "
				cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
				cQuery += "SC6.C6_FILIAL='" + xFilial("SC6") + "' AND "
				cQuery += "SC6.C6_NUM=SC5.C5_NUM AND "
				cQuery += "SC6.C6_ITEM=SC9.C9_ITEM AND "
				cQuery += "SC6.C6_PRODUTO=SC9.C9_PRODUTO AND "
				cQuery += "SC6.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
			#ELSE
				MsSeek(xFilial("SC9")+cPedido)
			#ENDIF 

			While (!Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
				(cAliasSC9)->C9_PEDIDO == cPedido )
				lProcessa := .T.				
				cProduto   := (cAliasSC9)->C9_PRODUTO
				cLocPedV   := (cAliasSC9)->C9_LOCAL
				cQtd       := (cAliasSC9)->C9_QTDLIB
				cItem      := (cAliasSC9)->C9_ITEM
				cSequencia := (cAliasSC9)->C9_SEQUEN
				cTesPedV   := (cAliasSC9)->C6_TES
				
				nSldDispo := U_SldA450(cProduto,cLocPedV)
				//MsgStop( nSldDispo ,"Estoque disponivel :" + cProduto)
				If nSldDispo <> 0
					lTesta := .F.
				EndIf
				If Posicione("SF4",1,xFilial("SF4")+cTesPedV,"F4_ESTOQUE") == "N"
					FSATUSC6(cQtd,cQtd,cPedido,cItem,cProduto) 
					FSATUSC9(cQtd,cQtd,cPedido,cItem,cProduto,cSequencia)
            Else
					IF nSldDispo < 0
						dbSelectArea(cAliasSC9)
						dbSkip()
						Loop
						//lProcessa := .F.
					ElseIf nSldDispo == 0  
						FSATUSC6(nSldDispo,cQtd,cPedido,cItem,cProduto) 
						FSATUSC9(nSldDispo,cQtd,cPedido,cItem,cProduto,cSequencia) 
						dbSelectArea(cAliasSC9)
						dbSkip()
						Loop     
						//lProcessa := .F. 
					EndIf
					If cQtd > nSldDispo
						FSATUSC6(nSldDispo,cQtd,cPedido,cItem,cProduto) 
						FSATUSC9(nSldDispo,cQtd,cPedido,cItem,cProduto,cSequencia)
					EndIf   
				EndIf
				If (!Empty((cAliasSC9)->C9_BLCRED) .And. (cAliasSC9)->C9_BLCRED <> "10" .And. (cAliasSC9)->C9_BLCRED <> "ZZ")
					/**If mv_par01 == 1
						If (cAliasSC9)->C9_BLCRED == "09"
							lProcessa := .F.
						Endif	
					Endif**/
					If lProcessa
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de Entrada para validacao do usuario                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (Existblock("MTA450LIB"))
							lProcessa:=ExecBlock("MTA450LIB",.F.,.F.,{(cAliasSC9)->C9_PEDIDO,(cAliasSC9)->C9_ITEM,nOpcA})
						EndIf
						If lProcessa
							If !lQuery
								dbSelectArea("SC5")
								dbSetOrder(1)
								MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)
							Else
								SC5->(MsGoto((cAliasSC5)->SC5RECNO))
							EndIf
                            If SC5->(Eof())  //<- COLEN 24082012
                               lErroC5 := .T.
                               EXIT
                            EndIf
//							If (cAliasSC5)->C5_TIPLIB == "2"
							If SC5->C5_TIPLIB == "2"
								If !lQuery
									dbSelectArea("SC6")
									dbSetOrder(1)
									MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
									aadd(aRegSC6,SC6->(RecNo()))
								Else
									aadd(aRegSC6,(cAliasSC6)->SC6RECNO)
								EndIf						
							Else
								If lQuery
									SC9->(MsGoto((cAliasSC9)->SC9RECNO))
								EndIf
//	                            aRecReg := {SC5->(Recno()),SC6->(Recno()),SC9->(Recno())} //<- COLEN 24082012
								a450Grava(1,.T.,.T.)
								If nVer
									//U_FSTRANSP(SC5->C5_NUM) //<- COLEN 24082012 ESTE FUNCAO ERA PARA ENVIAR EMAIL MAS ESTA COM COMENTARIO NO ENVIO ENTAO NAO FAZ NADA.. 
									nVer := .F.
								EndIf
/*
								SC5->(dbGoTo(aRecReg[01])) //<- COLEN 24082012
								SC6->(dbGoTo(aRecReg[02])) //<- COLEN 24082012
								SC9->(dbGoTo(aRecReg[03])) //<- COLEN 24082012
								If SC5->(! Eof()) //<- COLEN 24082012
									RecLock("SC5",.F.)
									SC5->C5_LIBEROK := "S"
									MsUnlock()
								Else
									Aviso("ATENCAO","1 - ERRO LIBERAÇÃO PEDIDO","OCORREU UM ERRO AO LIBERAR PEDIDO SERA CANCELADO O PROCESSO.",{"OK"},3)
									DisarmTransaction()
	                                lErroC5 := .T.
									EXIT
								EndIf
*/
							EndIf				
						EndIf
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pontos de Entrada 					                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
//COLEN 15102012 FOI RETIRADO POIS APENAS MUDA O STATUS DO PEDIDO. FOI INCLIDA NA VALIDACAO DO PEDIDO.
//					If (ExistTemplate("MTA450I"))
//						ExecTemplate("MTA450I",.F.,.F.,{nOpca,dLimLib})										
//					EndIf
//					If (Existblock("MTA450I"))
//						ExecBlock("MTA450I",.F.,.F.,{nOpca,dLimLib})										
//					EndIf
				Endif
				dbSelectArea(cAliasSC9)
				dbSkip()
			EndDo

			If lQuery
				dbSelectArea(cAliasSC9)
				dbCloseArea()
				dbSelectArea("SC9")
			EndIf

			If lErroC5
				Aviso("ATENCAO","2 - ERRO LIBERAÇÃO PEDIDO","OCORREU UM ERRO AO LIBERAR PEDIDO SERA CANCELADO O PROCESSO.",{"OK"},3)
				DisarmTransaction()
			Else
				If Len(aRegSC6) > 0
					dbSelectArea("SC9")
					dbClearFilter()
					dbSetOrder(1)
					Begin Transaction
						MaAvalSC5("SC5",3,.F.,.F.,,,,,,cPedido,aRegSC6,.T.,.F.)
						aRegSC6 := {}
					End Transaction
				EndIf
            EndIf

			If lMt450Fim
				Execblock("MT450FIM",.F.,.F.,{cPedido})
			Endif
		EndIf
	EndIf

	If nOpcA <> 0 .And. (! lErroC5)
		If RecLock("SC5",.F.)
			SC5->C5_USUCRED := _NomeUser 
			SC5->C5_DATCRED := dDataBase
			SC5->C5_HORCRED := time()
			msUnlock()
		EndIf   
		If lTesta
			Alert("Pedido sem Itens no Estoque")
		EndIf    
		                                                                         
		FVldPVLib(cPedido) // COLEN 15102012 VALIDA SE EXISTE ALGUM ITEM SEM LIBERACAO.
				
		         

	EndIf

	MsUnLockAll()
	RestArea(aAreaSC9)
	
	RestArea(aArea)
	dbSetOrder(10)

Return(lContinua)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DIAT005   ºAutor  ³Tiago Rossini       º Data ³  04/16/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica saldo em estoque ao efetuar a pesagem              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SldA450(cProduto,cLocPedV)
	Private nSldPedVen := 0 //Pedido de Venda em Aberto
	Private nSldQtdEmp := 0 //Quantidade empenhada
	Private nSldQtdPrv := 0 //Quantidade prevista para entrar
	Private nSldQtdRes := 0 //Quantidade reservada
	Private nSldAtu    := 0 //Saldo atual (físico)
	Private nSldDsp    := 0 //Disponível
    aArea := GetArea()
	dbSelectArea("SB2")
	dbSetOrder(1)
	If SB2->(dbSeek(xFilial("SB2") + cProduto + cLocPedV))
		nSldDsp := SB2->B2_QATU - SB2->B2_RESERVA
	EndIf
	If nSldDsp <= 0
		nSldDsp := 0
	EndIf
	RestArea(aArea)
Return(nSldDsp)

Static Function FSATUSC6(nSldDispo,cQtd,cPedido,cItem,cProduto)
//******************************************************************************************************************
// Atualiza quantidade de pedido de venda, caso o pedido contenha uma quantidade superior ao estoque.
//
//*************
	dbSelectArea("SC6")
	dbSetOrder(1)
	If DBSeek(xFilial("SC6") + AllTrim(cPedido)+AllTrim(cItem)+AllTrim(cProduto))
		If RecLock("SC6",.F.)
			If nSldDispo == 0
				Replace SC6->C6_YCORTE	with SC6->C6_QTDVEN
				Replace SC6->C6_QTDVEN	with nSldDispo
				Replace SC6->C6_QTDEMP	with 0
				Replace SC6->C6_VALOR	with SC6->C6_QTDVEN * SC6->C6_PRCVEN
				Replace SC6->C6_USRESAV	with "AUTOMATICA"
			Else
				Replace SC6->C6_YCORTE with SC6->C6_QTDVEN - nSldDispo
				Replace SC6->C6_QTDVEN with nSldDispo
				Replace SC6->C6_QTDEMP with 0
				Replace SC6->C6_VALOR  with SC6->C6_QTDVEN * SC6->C6_PRCVEN
				Replace SC6->C6_USRESAV	with "AUTOMATICA"
			EndIf
			MsUnlock()
    	EndIf
	EndIf
Return(Nil)
    	
Static Function FSATUSC9(nSldDispo,cQtd,cPedido,cItem,cProduto,cSequencia)
//******************************************************************************************************************
// Atualiza quantidade de pedido de venda, caso o pedido contenha uma quantidade superior ao estoque.
//
//*************
	dbSelectArea("SC9")
	dbSetOrder(1)
	If DBSeek(xFilial("SC9") + AllTrim(cPedido) + AllTrim(cItem) + AllTrim(cSequencia) + AllTrim(cProduto))
		If RecLock("SC9",.F.)
			If nSldDispo == 0
				Replace SC9->C9_YCORTE With SC9->C9_QTDLIB
				Replace SC9->C9_QTDLIB With nSldDispo
			Else
				Replace SC9->C9_YCORTE With SC9->C9_QTDLIB - nSldDispo
				Replace SC9->C9_QTDLIB With nSldDispo
			EndIf
			MsUnlock()
		EndIf
	EndIf
Return(Nil)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A450Tela  ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de interface das liberacaoes de credito e credito/esto³±±
±±³          ³que.                                                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1: Flag de controle. Indica se havera interface com o    ³±±
±±³          ³       usuario                                               ³±±
±±³          ³ExpL2: Indica se havera avaliacao de credito                 ³±±
±±³          ³ExpL3: Indica se havera avaliacao de estoque                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
±±³          ³venda com base na tabela SC9.                                ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function a450Tela2(lContinua,lAvCred,lAvEst,dLimLib)
	Local aArea       := GetArea()
	Local aAreaSC9    := SC9->(GetArea())
	Local nSaldoLC    := 0
	Local nValItem    := 0
	Local nValPed     := 0
	Local nLimCred    := 0
	Local nMoeda      := 0
	Local nQtdVen     := 0
	Local nSalPedL    := 0
	Local nSalPed     := 0
	Local nSalDup     := 0
	Local nSalDupM    := 0
	Local nValAtraso  := 0
	Local nOpca       := 0
	Local nSalvEmp    := 0
	Local nCntFor     := 0
	Local cDescBloq   := ""
	Local cDescri     := ""
	Local cCondSC9    := ""
	Local cProduto    := SC9->C9_PRODUTO
	Local cLocal      := SC9->C9_LOCAL
	Local oBtn
	Local bWhile      := Nil
	Local nMCusto     := 0
	Local nMCustoCli  := 0
	Local nDecs       := 0
	Local aSaldos
	Local lLiberado   := .F.
	Local nSalFin     := 0
	Local nSalFinM    := 0
	Local nLcFin      := 0
	Local nLcFinM     := 0
	Local aCols       := {}
	Local aHeader     := {}
	Local cMoeda      := ""
	Local lMT450COLS  := ExistBlock('MT450COLS')
	Local cEstCli		:= "" //SA1->A1_EST
	Local oObs
	Private cCadastro := OemToAnsi(STR0006) //"Consulta Posi‡„o Clientes"
	Static oDlg
	Default dLimLib	  := dDataBase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SC5                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (lContinua)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial() + SC9->C9_PEDIDO)
			If !SoftLock("SC5")
				lContinua := .F.
			EndIf
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o Tipo de Analize                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SC5->C5_TIPLIB == "2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Quando for por PV deve-se somar todos os SC9 gerados para o item        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC9")
		dbSetOrder(1)
		dbSeek(xFilial("SC9") + SC9->C9_PEDIDO)
		cCondSC9 := SC9->C9_PEDIDO
		bWhile	 := {|| xFilial("SC9") == SC9->C9_FILIAL .And. cCondSC9 == SC9->C9_PEDIDO}
	Else
		cCondSC9 := SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_SEQUEN
		bWhile   := {|| xFilial("SC9") == SC9->C9_FILIAL .And. cCondSC9 == SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_SEQUEN}
	EndIf
	dbSelectArea("SA1") //Posiciona cliente
	dbSetOrder(1)
	dbSeek(cFilial + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
	cEstCli	:= SA1->A1_EST
	nMCusto	:= IIF(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,Val(SuperGetMv("MV_MCUSTO")))
	cMoeda	:= " " + Pad(SuperGetMv("MV_SIMB" + AllTrim(STR(nMCusto))),4)
	nDecs	:= MsDecimais(nMcusto)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o tipo de analise a ser efetuado ( Filial ou Matriz )    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SuperGetMv("MV_CREDCLI") == "L")
		nLimCred := SA1->A1_LC
		nSalPed  := SA1->A1_SALPED + SA1->A1_SALPEDB
		nSalPedL := SA1->A1_SALPEDL
		nSalDup  := SA1->A1_SALDUP
		nSalDupM := SA1->A1_SALDUPM
		nSalFin  := SA1->A1_SALFIN
		nLcFin   := SA1->A1_LCFIN
		nLcFinM  := SA1->A1_SALFINM
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma-se Todos os Limites de Credito do Cliente          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1") + SC5->C5_CLIENTE)
		While (!EoF() .And. xFilial("SA1") == SA1->A1_FILIAL .And. SC5->C5_CLIENTE == SA1->A1_COD)
			nMCustoCli := IIF(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,val(SuperGetMv("MV_MCUSTO")))
			nLimCred += xMoeda(SA1->A1_LC,nMCustoCli,nMCusto,dDataBase)
			nSalPed  += xMoeda(SA1->A1_SALPED + SA1->A1_SALPEDB,nMCustoCli,nMCusto,dDataBase)
			nSalPedL += xMoeda(SA1->A1_SALPEDL,nMCustoCli,nMCusto,dDataBase)
			nSalDup  += SA1->A1_SALDUP
			nSalDupM += xMoeda(SA1->A1_SALDUPM,nMCustoCli,nMCusto,dDataBase)
			nSalFin  += SA1->A1_SALFIN
			nLcFin   += xMoeda(SA1->A1_LCFIN,nMCustoCli,nMCusto,dDataBase)
			nSalFinM += xMoeda(SA1->A1_SALFINM,nMCustoCli,nMCusto,dDataBase)
			dbSelectArea("SA1")
			dbSkip()
		EndDo
	EndIf
	nSalvEmp := SM0->(Recno())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisar o atraso de Todas as Filiais do Sistema                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SM0")
	dbSeek(cEmpAnt + IIf(!Empty(xFilial("SA1")),xFilial("SA1"),""))
	While !Eof() .And. M0_CODIGO == cEmpAnt
		If (SuperGetMv("MV_CREDCLI") == "L")
			nValAtraso += FtSomaAtr(SM0->M0_CODFIL)
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1") + SC5->C5_CLIENTE)
			While (!EoF() .And. xFilial("SA1")  == SA1->A1_FILIAL .And. SC5->C5_CLIENTE == SA1->A1_COD)
				nValAtraso += FtSomaAtr(SM0->M0_CODFIL)
				dbSelectArea("SA1")
				dbSkip()
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Forca a saida quando o SE1 estiver compartilhado               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (xFilial("SE1") == Space(2) .Or. !Empty(xFilial("SA1")))
			Exit
		EndIf
		dbSelectArea("SM0")
		dbSkip()
	EndDo
	dbSelectArea("SM0")
	dbGoto(nSalvEmp)
	dbSelectArea("SA1") //Posiciona cliente
	dbSetOrder(1)
	dbSeek(cFilial + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
	dbSelectArea("SC9")
	While (!EoF() .And. Eval(bWhile) .And. lContinua)
		If (SC9->C9_BLCRED != "10" .And. SC9->C9_BLEST != "10" .And. SC9->C9_BLCRED != "ZZ" .And. SC9->C9_BLEST != "ZZ" .And. (If(lAvCred,!Empty(SC9->C9_BLCRED),.F.) .Or. If(lAvEst,!Empty(SC9->C9_BLEST),.F.)))
			lLiberado := .T.
			If !SoftLock("SC9")
				lContinua := .F.
			EndIf
			If (lContinua)
				dbSelectArea("SC9")
				/**If (SC5->C5_TIPO $ "DB")
					Help(" ",1,"A450NCRED")
					lContinua := .F.
				EndIf**/
			EndIf
			If (lContinua)
				dbSelectArea("SC6") //Posiciona item do pedido
				dbSetOrder(1)
				dbSeek(cFilial + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO)
				dbSelectArea("SM2") //Posiciona moeda da data base
				dbSetOrder(1)
				dbSeek(dDataBase,.T.)
				dbSelectArea("SC9")
				nMoeda   := IIF(SC5->C5_MOEDA < 2,1,SC5->C5_MOEDA)
				nValItem := xMoeda((SC6->C6_PRCVEN * SC9->C9_QTDLIB),nMoeda,nMcusto,dDataBase)
				nValPed  += nValItem
				nSalPed  -= nValItem
				nSalPed  := IIF(nSalped < 0,0,nSalPed)
			EndIf
		EndIf
		dbSelectArea("SC9")
		dbSkip()
	EndDo
	dbSelectArea("SC9")
	dbGoto(aAreaSC9[3])
	If (!lLiberado)
		Help(" ",1,"A450JALIB")
	Endif
	If (lContinua .And. lLiberado)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona o SA1                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(cFilial + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
		If (SC9->C9_BLCRED == "01")
			cDescBloq := OemToAnsi(STR0007) //"Cr‚dito"
		ElseIf SC9->C9_BLCRED == "04"
			cDescBloq := OemToAnsi(STR0008) //"Limite de Cr‚dito Vencido"
		ElseIf SC9->C9_BLCRED == "09"
			cDescBloq := OemToAnsi(STR0009) //"Rejeitado"
		ElseIf !Empty(SC9->C9_BLEST)
			cDescBloq := "Estoque" //"Estoque"
		EndIf
		cDescri := Substr(SA1->A1_NOME,1,35)
		aSaldos := Array(_STRASALDOS)
		aSaldos[_LIMCREDM] := nLimCred
		aSaldos[_LIMCRED ] := xMoeda(nLimCred,nMCusto,1)
		aSaldos[_SALDUPM ] := nSalDupM
		aSaldos[_SALDUP  ] := nSalDup
		aSaldos[_SALPEDLM] := nSalPedL
		aSaldos[_SALPEDL ] := xMoeda(nSalPedL,nMCusto,1)
		aSaldos[_MCOMPRAM] := SA1->A1_MCOMPRA
		aSaldos[_MCOMPRA ] := xMoeda(SA1->A1_MCOMPRA,nMCusto,1)
		aSaldos[_SALDOLCM] := nLimCred - nSaldupM - nSalPedL
		aSaldos[_SALDOLC ] := xMoeda(nLimCred - nSaldupM - nSalPedL,nMCusto,1)
		aSaldos[_MAIDUPLM] := SA1->A1_MAIDUPL
		aSaldos[_MAIDUPL ] := xMoeda(SA1->A1_MAIDUPL,nMCusto,1)
		aSaldos[_ITATUM  ] := xMoeda((SC9->C9_PRCVEN * SC9->C9_QTDLIB),nMoeda,nMcusto)
		aSaldos[_ITATU   ] := xMoeda((SC9->C9_PRCVEN * SC9->C9_QTDLIB),nMoeda,1)
		aSaldos[_PEDATUM ] := nValPed
		aSaldos[_PEDATU  ] := xMoeda(nValPed,nMCusto,1)
		aSaldos[_SALPEDM ] := nSalPed
		aSaldos[_SALPED  ] := xMoeda(nSalPed,nMCusto,1)
		aSaldos[_VALATRM ] := xMoeda(nValAtraso,1,nMCusto)
		aSaldos[_VALATR  ] := nValAtraso
		aSaldos[_LCFINM  ] := nLcFin
		aSaldos[_LCFIN   ] := xMoeda(nLCFin,nMcusto,1)
		aSaldos[_SALFINM ] := nSalFinM
		aSaldos[_SALFIN  ] := nSalFin
		aHeader := {"Descricao","Valores","Valores em " + AllTrim(cMoeda)," ","Descricao","Posicao do Cliente"}
		//Limite de Credito/Tit.Protestados/DT.ULT TIT
		Aadd(aCols,{OemToAnsi(STR0018),Transform(aSaldos[_LIMCRED],PesqPict("SA1","A1_LC"	  ,17,1)),Transform(aSaldos[_LIMCREDM],PesqPict("SA1","A1_LC",17,nMcusto))," ",OemToAnsi(STR0019),Space(02) + Str(SA1->A1_TITPROT,3) + Space(05) + OemToAnsi(STR0020) + Space(03) + DtoC(SA1->A1_DTULTIT)}) //Limite de Credito/Tit.Protestados/DT.ULT TIT
		//Saldo Titulos / Cheques Devolvidos/DT.ULT.CHQ
		Aadd(aCols,{OemToAnsi(STR0021),Transform(aSaldos[_SALDUP] ,PesqPict("SA1","A1_SALDUP" ,17,1)),Transform(aSaldos[_SALDUPM],PesqPict("SA1","A1_SALDUPM",17,nMcusto))," ",OemToAnsi(STR0022),Space(02) + Str(SA1->A1_CHQDEVO,3) + Space(05) + OemToAnsi(STR0020) + Space(03) + DtoC(SA1->A1_DTULCHQ)}) //Saldo Titulos / Cheques Devolvidos/DT.ULT.CHQ
		//Pedidos Aprovados/Maior Compra
		Aadd(aCols,{OemToAnsi(STR0023),Transform(aSaldos[_SALPEDL],PesqPict("SA1","A1_SALPEDL",17,1)),Transform(aSaldos[_SALPEDLM],PesqPict("SA1","A1_SALPEDL",17,nMcusto))," ",OemToAnsi(STR0024),Transform(aSaldos[_MCOMPRAM],PesqPict("SA1","A1_MCOMPRA",17,nMCusto))}) //Pedidos Aprovados/Maior Compra
		//Saldo Lim Credito/Maior Duplicata     
		Aadd(aCols,{OemToAnsi(STR0025),Transform(aSaldos[_SALDOLC],PesqPict("SA1","A1_SALDUP" ,17,1)),Transform(aSaldos[_SALDOLCM],PesqPict("SA1","A1_SALDUPM",17,nMcusto))," ", OemToAnsi(STR0026),Transform(aSaldos[_MAIDUPLM],PesqPict("SA1","A1_MAIDUPL",17,nMCusto))}) //Saldo Lim Credito/Maior Duplicata
		//Item Pedido Atual/Media de Atraso
		Aadd(aCols,{OemToAnsi(STR0027),Transform(aSaldos[_ITATU]  ,PesqPict("SA1","A1_SALDUP" ,17,1)),Transform(aSaldos[_ITATUM],PesqPict("SA1","A1_SALDUP",17,nMcusto))," ",OemToAnsi(STR0029),Space(14)+Transform(SA1->A1_METR,PesqPict("SA1","A1_METR",7)) + Space(04) + OemToAnsi(STR0028)}) //Item Pedido Atual/Media de Atraso
		If SC5->C5_TIPLIB == "2"
			Aadd(aCols,{"Pedido Atual",Transform(aSaldos[_PEDATU] ,PesqPict("SA1","A1_SALDUP" ,17,1)),Transform(aSaldos[_PEDATUM],PesqPict("SA1","A1_SALDUP",17,nMcusto))," ",OemToAnsi(STR0031),Space(10)+DtoC(SA1->A1_VENCLC)}) //Pedido Atual/ Vencto.Lim.Credito
		Else
			Aadd(aCols,{"","","","",OemToAnsi(STR0031),Space(10) + DtoC(SA1->A1_VENCLC)}) //Pedido Atual/ Vencto.Lim.Credito
		EndIf
		//Saldo de Pedidos / Data Limite Liberação       
		Aadd(aCols,{OemToAnsi(STR0030),Transform(aSaldos[_SALPED],PesqPict("SA1","A1_SALPED",17,1)),Transform(aSaldos[_SALPEDM],PesqPict("SA1","A1_SALPED",17,nMcusto))," ",OemToAnsi(STR0033),Space(10)+DtoC(dLimLib)}) //Saldo de Pedidos / Data Limite Liberação
		//Lim. de Cred. Secundario/Atraso Atual             
		Aadd(aCols,{"Lim.Cred.Sec.",Transform(aSaldos[_LCFIN] ,PesqPict("SA1","A1_LC"	 ,17,1)),Transform(aSaldos[_LCFINM] ,PesqPict("SA1","A1_LC"	   ,17,nMcusto))," ",OemToAnsi(STR0032),Transform(aSaldos[_VALATR],PesqPict("SA1","A1_SALDUP",17,1))}) //Lim. de Cred. em Cheque/Atraso Atual
		Aadd(aCols,{"Saldo LC Sec" ,Transform(aSaldos[_SALFIN],PesqPict("SA1","A1_SALDUP",17,1)),Transform(aSaldos[_SALFINM],PesqPict("SA1","A1_SALDUP",17,nMcusto))," ",,,}) // Saldo em Cheques
		//Define MsDialog oDlg from 125,3 to 430,608 Title OemToAnsi(STR0005) Pixel //"Libera‡„o de Cr‚dito"
		Define MsDialog oDlg from 125,3 to 670,676 Title OemToAnsi("Liberacao de credito") Pixel
		//--Ponto de Entrada permite alterar o conteudo dos campos do aCols                          
		If lMT450COLS
			ExecBlock('MT450COLS',.F.,.F.,{aHeader,aCols})              
		EndIf
		@003,004 to 033,331 Label "" of oDlg Pixel
		@253,004 to 272,155 Label "" of oDlg Pixel
		@253,160 to 272,274 Label "" of oDlg Pixel
		Define sButton from 257,277 Type 1 Action (nOpca := 1,oDlg:End()) Enable of oDlg
		Define sButton from 257,307 Type 2 Action oDlg:End() Enable of oDlg  
		fWBrowse1()                                                        
		
	    cAlFin := GetNextAlias()
		cQuery := " SELECT E1_CLIENTE, E1_LOJA, SUM(CASE WHEN E1_TIPO = 'NCC' AND E1_SALDO > 0 THEN E1_VALOR ELSE 0 END) CREDITO, "  
		cQuery += "  NVL(SUM(CASE WHEN E1_BAIXA >= to_char(ADD_MONTHS(SYSDATE,-12), 'YYYYMMDD')AND E1_TIPO = 'NF' THEN E1_VALOR-E1_SALDO ELSE 0 END),0) TOTREC , "		
		cQuery += "                 NVL(SUM(CASE WHEN E1_VENCREA < to_char(SYSDATE, 'yyyymmdd')AND E1_TIPO = 'NF' AND E1_SALDO > 0 THEN E1_SALDO ELSE 0 END),0) ATRASO "
		cQuery += "                 FROM SE1010 WHERE SE1010.D_E_L_E_T_ = ' ' " 
		cQuery += " AND E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+"' " 
		cQuery += "                 GROUP BY E1_CLIENTE, E1_LOJA"
		
		               
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlFin,.T.,.T.)		
		
		iF (cAlFin)->ATRASO >0 
			_nAtraso := (cAlFin)->ATRASO
		Else
			_nAtraso := 0
		EndIf    
		
		If (cAlFin)->TOTREC >0 
			_nTotal := (cAlFin)->TOTREC
		Else
			_nTotal := 0
		EndIf		
		
		
		@ 186, 003 SAY oSay11 PROMPT "Obs. Financeira" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 194, 003 MSGET oObs VAR SA1->A1__OBSCRE Picture "@!" SIZE 328, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.

		@ 207, 003 SAY oSay11 PROMPT "CNPJ" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 215, 003 MSGET oObs VAR SA1->A1_CGC Picture "@R 99.999.999/9999-99" SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
	
		@ 207, 107 SAY oSay11 PROMPT "Vl. Tit. Aberto" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 215, 107 MSGET oObs VAR SA1->A1_SALDUP Picture "@E 999,999,999.99" SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
		
		@ 207, 183 SAY oSay11 PROMPT "Vl. Tit. Vencidos" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 215, 183 MSGET oObs VAR _nAtraso Picture "@E 999,999,999.99" SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.       

		@ 207, 259 SAY oSay11 PROMPT "Valor Tot. Pedido" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 215, 259 MSGET oObs VAR U_FTOTPED(SC5->C5_NUM) Picture "@E 999,999,999.99" SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.		

		
		@ 228, 003 SAY oSay11 PROMPT "Incr. Estadual" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 236, 003 MSGET oObs VAR SA1->A1_INSCR Picture "@E " SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.    
		
		@ 228, 057 SAY oSay11 PROMPT "E-mail" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 236, 057 MSGET oObs VAR SA1->A1_EMAIL Picture "@E " SIZE 122, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.		 
		
		@ 228, 183 SAY oSay11 PROMPT "Maior Saldo" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 236, 183 MSGET oObs VAR SA1->A1_MSALDO Picture "@E 999,999,999.99" SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.				

		@ 228, 259 SAY oSay11 PROMPT "Total Pago (Ult. Ano)" SIZE 060, 012 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 236, 259 MSGET oObs VAR _nTotal Picture "@E 999,999,999.99" SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.		


		
		DbCloseArea(cAlFin)

				
		
		@258,010 Button OemToAnsi(STR0010)   Size 34,11 Font oDlg:oFont Action (a450F4con(),cCadastro := OemToAnsi(STR0005)) of oDlg Pixel //"Consulta"
		@258,045 Button "Cliente"		Size 34,11 Font oDlg:oFont Action (cCadastro := "Cliente",A030Visual("SA1",SA1->(RecNo()),1),cCadastro := OemToAnsi(STR0005)) of oDlg Pixel  //"Cliente"
		@258,080 Button "Pedido"		Size 34,11 Font oDlg:oFont Action (cCadastro :="Pedido",a410Visual("SC5",SC5->(RecNo()),1),cCadastro := OemToAnsi(STR0005)) of oDlg Pixel //"Pedido"
		@258,115 Button "Estoque"		Size 34,11 Font oDlg:oFont Action (a450ConEst(cProduto,cLocal)) of oDlg Pixel //"Estoque"
		@258,165 Button "Pos Cliente"	Size 34,11 Font oDlg:oFont Action (U_P450POS()) of oDlg Pixel
		@258,200 Button "Rel Ped"		Size 34,11 Font oDlg:oFont Action (U_FSPEDBTN()) of oDlg Pixel
		@258,235 Button "Parecer"		Size 34,11 Font oDlg:oFont Action (U_FSBOXPAREC()) of oDlg Pixel //Tela para analista descrever o motivo pelo qual o Pedido de Venda nao teve o credito liberado
		@010,008 Say OemToAnsi(STR0013)	Size 23,7 of oDlg Pixel	//"Pedido :"
		@010,032 Say SC9->C9_PEDIDO		Size 26,7 of oDlg Pixel
		@010,063 Say OemToAnsi(STR0014)	Size 35,7 of oDlg Pixel	//"Cond.Pagto. :"
		@010,100 Say SC5->C5_CONDPAG	Size 09,7 of oDlg Pixel
		@010,122 Say OemToAnsi(STR0017)	Size 21,7 of oDlg Pixel	//"Risco :"
		@010,145 Say SA1->A1_RISCO		Size 11,7 of oDlg Pixel
		@010,160 Say OemToAnsi("Valores em " + SuperGetMv("MV_SIMB" + Alltrim(str(nMCusto)))) Size 50,7 of oDlg Pixel //"Valores em "
		@010,207 Say OemToAnsi(STR0015)	Size 27,7 of oDlg Pixel	//"Bloqueio :"
		@010,237 Say cDescBloq			Size 63,7 of oDlg Pixel
		@010,300 Say "EST: "+cEstCli	Size 20,7 of oDlg Pixel
		@021,008 Say OemToAnsi(STR0016)	Size 23,7 of oDlg Pixel	//"Cliente :"
		@021,032 Say cDescri			Size 96,7 of oDlg Pixel
		@021,163 Say OemToAnsi(STR0033)	Size 64,7 of oDlg Pixel	//"Data Limite Libera‡Æo :"
		@020.4,240 MsGet dLimLib		Size 52,7 of oDlg Pixel HASBUTTON
		oLbx := RDListBox(2.48,.5,327,95,aCols,aHeader,{57,52,52,14,57,71})
		Activate MsDialog oDlg
	EndIf
	RestArea(aAreaSC9)
	RestArea(aArea)
	dbSetOrder(10)
Return(nOpcA)

//-------------------------------------------------------------------
/*/{Protheus.doc} FSBOXPAREC()
Funcao que cria janela de parecer na rotina de Liberacao de Credito e de Tomada de Pedido

@author	Rodrigo Prates
@since	20101004
@param	cUsu	Variavel que recebe "V" se funcao for chamada pela rotina de Pedido de Venda e bloqueia alteracao no tMultiGet
/*/
//-------------------------------------------------------------------
User Function FSBOXPAREC(cUsu)
	Local oDlg
	Local oMemo
	Local cMemo	  := ""
	Local oGet
	Local cGet1	  := ""
	Local cGet2
	Local oCombo
	Local cCombo  := ""
	Local aResumo := {"Cobranca/Mesmo","Cadastro","Cobranca","Falta Analise","Limite","Sem Item no Estoque","Serasa","Sintegra","Somente Antecipado","Outros"}
	Define MsDialog oDlg From 125,3 To 380,400 Title OemToAnsi("Parecer de nao aprovacao de credito - Pedido: " + AllTrim(SC5->C5_NUM)) Pixel
	@003,004 To 075,197 Label "Parecer" Of oDlg Pixel
	If AllTrim(SC5->C5_PARECER) <> "" //Se o parecer nao estiver vazio, as informacoes serao puxadas do banco e a tela vira preenchida
		cGet1	:= AllTrim(Upper(SC5->C5_USUPAR)) //Nome do usuario que gravou o parecer no pedido
		cGet2	:= SC5->C5_DTPAREC //Data em que o parecer foi gravado
		cMemo	:= SC5->C5_PARECER //Parecer do analista                                                   
		// --> Luciano Emilio 30/09/11
//		cCombo	:= AllTrim(aResumo[aScan(aResumo,AllTrim(SC5->C5_RESUMO))]) //Resumo do parecer para facilitar consulta   // -- Luciano Emilio - Alterado pela linha de baixo
		cCombo	:= IIF(aScan(aResumo,AllTrim(SC5->C5_RESUMO))== 0,1,aScan(aResumo,AllTrim(SC5->C5_RESUMO))) //Resumo do parecer para facilitar consulta   
		// <-- Luciano Emilio 30/09/11
	ElseIf AllTrim(SC5->C5_PARECER) == "" .And. cUsu <> "V" //Se parecer estiver vazio e o usuario que esta fazendo o acesso nao for vendedor...
		cGet1 := AllTrim(Upper(PswRet(1)[1][2])) //... o campo de "Analista" busca o nome do usuario logado...
		cGet2 := (dDataBase) //... e o campo "Data Parecer" busca a data atual.
	Else 
		cGet1 := ""
		cGet2 := ""
	EndIf
	If cUsu <> "V"
		oMemo := tMultiget():New(012,010,{|u|If(Pcount() > 0,cMemo := u,cMemo)},oDlg,180,058,,,,,,.T.,,,,,,,,,,,.T.)
		oMemo:lWordWrap := .T.
	Else
		oMemo := tMultiget():New(010,010,{|u|If(Pcount() > 0,cMemo := u,cMemo)},oDlg,180,055,,,,,,.T.,,,,,,.T.,,,,,.T.)
	EndIf
	@080,004 To 100,197 Label "" Of oDlg Pixel
	@086,013 Say "Analista:" Size 026,007 Of oDlg Pixel
	TGet():New(084,036,{|u| If(PCount() > 0,cGet1 := u,cGet1)},oDlg,070,010,,,,CLR_LIGHTGRAY,,,,.T.,,,,,,,.T.,,,)
	@086,110 Say "Data Parecer:" Size 035,7 Of oDlg Pixel
	TGet():New(084,145,{|u| If(PCount() > 0,cGet2 := u,cGet2)},oDlg,045,010,,,,CLR_LIGHTGRAY,,,,.T.,,,,,,,.T.,,,)
	@105,004 To 124,197 Label "" Of oDlg Pixel
	@111,013 Say "Resumo:" Size 026,7 Of oDlg Pixel
	oCombo := tComboBox():New(109,036,{|u|If(PCount() > 0,cCombo := u,cCombo)},aResumo,080,025,oDlg,,,,,,.T.,,,,{||IIF(cUsu <> "V",.T.,.F.)},,,,,"cCombo")
	Define sButton From 109,130 Type 1 Action IIF(cUsu <> "V",(U_FSINCPAREC(cMemo,(PswRet(1)[1][2]),(dDataBase),cCombo),oDlg:End()),oDlg:End()) Enable Of oDlg
	Define sButton From 109,163 Type 2 Action oDlg:End() Enable Of oDlg
	Activate MsDialog oDlg center
Return(Nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} FSINCPAREC()
Funcao grava na SC5, as informacoes inseridas na tela de parecer (Nome do analista, data da analise e parecer)

@author	Rodrigo Prates
@since	20101004
@param	cMemo	Recebe o conteudo que foi digitado no campo de parecer.
@param	cGet1	Recebe o nome do analista que inseriu o parecer no Pedido de Venda
@param	cGet2	Recebe a data em que o parecer foi digitado
/*/
//-------------------------------------------------------------------
User Function FSINCPAREC(cMemo,cGet1,cGet2,cCombo)
	If RecLock("SC5",.F.)
		Replace SC5->C5_PARECER With AllTrim(cMemo),;
				SC5->C5_USUPAR	With AllTrim(cGet1),;
				SC5->C5_DTPAREC	With cGet2,;
				SC5->C5_RESUMO	With AllTrim(cCombo),;
				SC5->C5_RETPAR	With "S"
		MsUnlock()
	EndIf
Return(Nil)




//-------------------------------------------------------------------
/*/{Protheus.doc} FImpRodLiv
Funcao para montar o Rodape do Relatório Listagem do Inventário de Bens

@protected
@author		Ederson Colen
@since		20/06/2012
@obs			Referente atendimento pontual
@param		oPrint - objeto do TMS Report	
				cAlias - Alias do Arquivo de Trabalho
				nPagina - Numero da Pagina
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function FVldPVLib(cPedido)

Local nContIt := 0
Local nConLEs := 0
Local nConLCr := 0
Local nContZer := 0
Local lRet 	  := .T.
Local _lAlt := .F. 
Local cAlias                      



cAlias := GetNextAlias()
cQuery := " SELECT COUNT(CASE WHEN F4_ESTOQUE = 'S' THEN C6_ITEM END) QMOVEST, "
cQuery += " COUNT(CASE WHEN C9_PRODUTO IS NULL THEN C6_ITEM END) QNLIB "
cQuery += " FROM "+    RetSqlName("SC6") + " SC6  "
cQuery += " INNER JOIN "+    RetSqlName("SF4") + " SF4 "
cQuery += " ON F4_CODIGO = C6_TES "
cQuery += " LEFT JOIN "+    RetSqlName("SC9") + " SC9 "
cQuery += " ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9_PRODUTO = C6_PRODUTO AND SC9.D_E_L_E_T_ = ' ' "
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_TES = F4_CODIGO AND SC6.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND C6_QTDVEN > 0 "
cQuery += " AND C6_NUM = '"+cPedido+"' "      

TcQuery cQuery NEW ALIAS (cAlias)  

If (cAlias)->QNLIB > 0
	Aviso("ATENCAO","Foram encontrados itens sem Liberação. Favor entrar em contato com a TI informando o numero do Pedido: "+cPedido,{"OK"},3)

   SC5->(dbSetOrder(1))
   SC5->(dbSeek(xFilial("SC5")+cPedido))
   If SC5->(! Eof())
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := "S"
		SC5->C5__STATUS := "4" 
		MsUnlock()    
		U_AlertPed(cPedido)
	EndIf
	Return(.F.)

Else
	

	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+cPedido))
	
	While SC9->(! Eof()) .And. SC9->C9_PEDIDO == cPedido
	
		If SC9->C9_QTDLIB > 0.00
			If Empty(SC9->C9_BLEST)
				nConLEs += 1
		   EndIf
		   If Empty(SC9->C9_BLCRED)
				nConLCr += 1
		   EndIf
	   	Else
			nConLEs += 1
			nConLCr += 1
			nContZer += 1
	   	EndIf
	  	nContIt += 1
		SC9->(dbSkip())
	
	EndDo
	
	If nConLEs <> nContIt .Or. nConLCr <> nContIt
		Aviso("ATENCAO","Foram encontrados itens sem Liberação. Favor entrar em contato com a TI informando o numero do Pedido: "+cPedido,{"OK"},3)
		//DisarmTransaction()
		lRet := .F.        
	ElseIf nContZer = nContIt
		Aviso("ATENCAO","Pedido sem quantidades liberadas no estoque: "+cPedido,{"OK"},3)
		//DisarmTransaction()
		lRet := .F.	                                                 	
	Else
	/* VALIDAÇÃO PARA INTEGRAÇÃO DO PEDIDO DE VENDA COM MHA--------------------  
	   SC5->(dbSetOrder(1))
	   SC5->(dbSeek(xFilial("SC5")+cPedido))
	   If SC5->(! Eof())
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->C5__STATUS := "06" 
			MsUnlock()
		EndIf      */ 
	   SC5->(dbSetOrder(1))
	   SC5->(dbSeek(xFilial("SC5")+cPedido))
	   If SC5->(! Eof())
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->C5__STATUS := "4" 
			MsUnlock()
			    
			
			//If u_VldEnv(SC5->C5_NUM) 
	  		
			If (cAlias)->QMOVEST = 0  
				SC5->(dbSetOrder(1))
	   			SC5->(dbSeek(xFilial("SC5")+cPedido))
				If SC5->(! Eof())
					RecLock("SC5",.F.)
					SC5->C5_LIBEROK := "S"
					SC5->C5__STATUS := "8" 
					MsUnlock()
					U_EmailApv(cPedido)
				EndIf
			ElseIf SC5->C5_CONDPAG = '001' .and. (SC5->C5_VLPGANT+SC5->C5_CREDNCC) < ROUND(u_fTotPed(SC5->C5_NUM),2)
				
				RecLock("SC5",.F.)
				SC5->C5_LIBEROK := "S"
				SC5->C5__STATUS := "14" 
				MsUnlock()
				
				Aviso("ATENCAO","O valor pago antecipadamente pelo cliente é menor que o valor do pedido: "+cPedido+". Pedido retido, aguardando pagamento.",{"OK"},3)
				//U_AlertPed(cPedido)
			Else	
						
						If SC5->C5_YTPED = "02" 
							_lAlt	:= .T. 
						EndIf	
			                                                                                                                           
						_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,"1",SC5->C5_NUM,"NAO TEM NUMERO ORC","",IIF(_lAlt,"ALT","INC"),"","")
	
				        If !Empty(_aResult)
				            If _aResult[1] == "S"
				                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
				                U_AlertPed(cPedido)
				        
				            Else 
							   SC5->(dbSetOrder(1))
							   SC5->(dbSeek(xFilial("SC5")+cPedido))
							   If SC5->(! Eof())
									RecLock("SC5",.F.)
									SC5->C5_LIBEROK := "S"
									SC5->C5__STATUS := "5" 
									MsUnlock()
								EndIf  
								
								Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido enviada com sucesso. - " + _aResult[2], 1, 0 ) 
	
				                U_EmailApv(cPedido)
				            EndIf		
	
	                    Else
	                    	Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar pedido para arMHAzena", 1, 0 )
	                    	U_AlertPed(cPedido)
	                        
	        
			            EndIf
	
			EndIf
			//EndIf 		
			
			
			                    
		EndIf      	
		lRet := .T.
	EndIf

EndIf

Return (lRet)                  

Static Function fWBrowse1(cTpCh)
//------------------------------------------------
Local oWBrowse1
Local aWBrowse1 := {}
Local nAtras := 0
    

	cAlias := GetNextAlias()
    cQuery := " SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO FROM SE1010 WHERE E1_TIPO = 'NF' AND E1_SALDO > 0  AND D_E_L_E_T_ = ' ' AND 
   // If cTpCh = '1'
    	cQuery += " E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+"' "
   // Else
    //	cQuery += " E1_CLIENTE = '"+M->C5_CLIENTE+"' AND E1_LOJA = '"+M->C5_LOJACLI+"' "
    //EndIf
    cQuery += " ORDER BY E1_NUM, E1_PARCELA"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  

    If Eof(cAlias)
    	Aadd(aWBrowse1,{"","","","","","","",""})
    EndIf   

	DbSelectArea(cAlias)
	DbGoTop()  		
	Do While !Eof(cAlias)  
		
		If (cAlias)->E1_VENCREA > dToc(Date())
			nAtras := nAtras + 1
		EndIf
			
		
		Aadd(aWBrowse1,{(cAlias)->E1_PREFIXO,(cAlias)->E1_NUM,(cAlias)->E1_PARCELA,(cAlias)->E1_TIPO,sTod((cAlias)->E1_EMISSAO),sTod((cAlias)->E1_VENCREA),Transform((cAlias)->E1_VALOR,"@e 999,999,999.99"),Transform((cAlias)->E1_SALDO,"@e 999,999,999.99")})
		
		DbSelectArea(cAlias)
		DbSkip() 
  
				
	End Do
		//125,3 to 550,676

    @ 130, 003 LISTBOX oWBrowse1 Fields HEADER "Prefixo","Titulo","Parcela","Tipo","Emissao","Vencimento","Valor","Saldo" SIZE 328, 053 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],;
      aWBrowse1[oWBrowse1:nAt,5],;
      aWBrowse1[oWBrowse1:nAt,6],;
      aWBrowse1[oWBrowse1:nAt,7],;
      aWBrowse1[oWBrowse1:nAt,8];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}
  //DbCloseArea("TRB1")
Return(nAtras)




