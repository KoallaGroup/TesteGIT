#INCLUDE "MATA460.CH"
#include "PROTHEUS.ch"	
#include 'tbiconn.ch'
#include 'topconn.ch'    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LMAG460 8 ºAutor  ³ CLEBER CONDE       º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ LIBERACAO DE ALCADA                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LMGA460(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,cRotina,cCodCli,cLoja,xRatCTBPC,xAdtPC)

Local lRet		  := .T.
Private cCondicao := ""
Private cIndex	  := ""
Private aIndSC9	  := {}
Private nIndSC9   := 0
Private nmv_par01 := 0
Private aAC		  := {"Abandona","Confirma"}
Private aACRL	  := {"Abandona","Confirma","Rejeita","Libera todo o Pedido"}
Private aPos	  := {8,4,11,74 }
Private lFiltra	  := .F.
Private cAlias	  := "SC5"
Private lEstoque
Private nAutoAdt
Private nIndex   
Public cStatus	 := "2"
Public aAdtPC     := IIF(xAdtPC <> Nil,xAdtPC,{}) 
Public aRatCTBPC  := IIF(xRatCTBPC <> Nil,xRatCTBPC,{})	
Private aColsCCust	:= {}                
Private aBkpAgg	  := {} 
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

Private aRotina := {{'Pesquisar' ,'AxPesqui'  ,0,1},; //Pesquisar
							{'Visualizar','U_P460Vis' ,0,2},; //Visualizar
							{'Manual'    ,'U_P460Man' ,0,4},; //Manual Liberacao 
							{'Alterar'	 ,"U_P460Alt" ,0,4},; //"Alterar"
							{'Posicao'   ,'U_P460POS' ,0,5},; //Posicao Cliente
							{'Legenda'   ,'U_P460LEG' ,0,8},; //Legenda
							{'Rel Ped'   ,'U_FSPEDBTN',0,9},;  //Relatorio do Pedido
							{'Posição Pedido' ,"U_BCDCONPED('1')",0,3,0 }}  //"Posição Pedido"

Private	aCores	:= {{"ALlTRIM(SC5->C5__STATUS)=='2' .AND. ALLTRIM(SC5->C5_INTERAC)<>'S'",'BR_VERMELHO_OCEAN'},; //Alcada
					{"ALlTRIM(SC5->C5__STATUS)=='2' .AND. ALLTRIM(SC5->C5_INTERAC)=='S'",'BR_AMARELO_OCEAN'},; //Alcada JA ANALISADO
					{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. EMPTY(C5_PARECER)",'BR_VERDE_OCEAN'   },; //Credito  
					{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. !EMPTY(C5_PARECER)",'BR_AZUL_CLARO'   },; //Credito  Rejeitado
					{"ALLTRIM(SC5->C5__STATUS)=='4'",'BR_VIOLETA'   },; //Envio Pendente
					{"ALLTRIM(SC5->C5__STATUS)=='5'",'BR_MARROM'   },; //Aguardando Separação
					{"ALlTRIM(SC5->C5__STATUS)=='6'",'BR_LARANJA_OCEAN' },; //Separacao
					{"AlLTRIM(SC5->C5__STATUS)=='7'",'BR_CINZA_OCEAN'   },; //Conferencia	 
					{"AlLTRIM(SC5->C5__STATUS)=='8'",'BR_AMARELO_OCEAN' },; //Disponivel a Faturar	
					{"AlLTRIM(SC5->C5__STATUS)=='9'",'BR_PRETO_OCEAN'   },; //Faturado 
					{"AlLTRIM(SC5->C5__STATUS)=='10'",'BR_BRANCO_OCEAN'   },; //Em Expedição 
					{"AlLTRIM(SC5->C5__STATUS)=='11'",'BR_AZUL_OCEAN'    },;//Expedido
					{"AlLTRIM(SC5->C5__STATUS)=='13'",'BR_PINK'    },;//Devolvido
					{"AlLTRIM(SC5->C5__STATUS)=='12'",'BR_CANCEL'    },;//Cancelado
					{"ALLTRIM(SC5->C5__STATUS)=='14'",'BR_VERDE_ESCURO'}} 

Private lFiltra := .F.
Private aAC		:= {"Abandona","Confirma"}
Private aACRL	:= {"Abandona","Confirma","Rejeita","Libera todo o Pedido"}
Private aPos	:= {8,4,11,74 }
Private lFiltra := .F.
Private aLocal	:= {}
Private cGeraBlq
Private	_cEmpUso	:= AllTrim(cEmpAnt) + "/"
Private _bFiltraBrw	:= ''
Private bFiltraBrw	:= ''
Private _aIndexSC5 	:= {}
Private _cFiltro  	:= ''
Private cCadastro	:= OemToAnsi("Libera‡„o de Alçada")

dbSelectArea(cAlias)
(cAlias)->(DbSetOrder(1))
(cAlias)->(DbGoTop())
_cFiltro := " AllTrim(SC5->C5__STATUS)='2' "
	
If !Empty(_cFiltro)
	bFiltraBrw := {|| FilBrowse("SC5",@_aIndexSC5,@_cFiltro)}
	Eval(bFiltraBrw)
EndIf

dbSelectArea("SC5")
mBrowse(6,1,22,75,'SC5',,,,,,aCores)

EndFilBrw("SC5",_aIndexSC5)

Return(.T.)



User Function P460LEG()

Local aLegenda	:= {{'BR_VERMELHO_OCEAN','Alcada'      },;
					{'BR_VERDE_OCEAN'   ,'Credito'     },;   
					{'BR_AZUL_CLARO','Credito Rejeitado'},;
					{'BR_VIOLETA' ,'Aguardando Envio Sep'},; //Envio Pendente
					{'BR_MARROM', 'Aguard. Inicio Separação'},;
					{'BR_LARANJA_OCEAN' ,'Separacao'   },;
					{'BR_CINZA_OCEAN'   ,'Conferencia' },;
					{'BR_AMARELO_OCEAN' ,'Disp Faturar'},;
					{'BR_PRETO'         ,'Faturado'    },; 
					{'BR_BRANCO'        ,'Em Expedição'},;                                    
					{'BR_AZUL_OCEAN'    ,'Expedido'  },;
					{'BR_PINK'    ,'Devolvido'  },;
					{'BR_CANCEL'    ,'Cancelado'  },;
					{'BR_VERDE_ESCURO'    ,'Pagamento'  }}
					BrwLegenda(cCadastro,'Legenda',aLegenda)

//BrwLegenda(cCadastro,'Legenda',aLegenda)

Return(.T.)

        

User Function P460POS()

Local cCliente := SC5->C5_CLIENTE

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1") + cCliente)
	FC010CON()
Else
	MsgStop("Cliente nao encontrado!")
EndIf

Return(.T.)



User Function P460VIS()

Local cAlias := "SC5"
Local nReg	 := SC5->(Recno())
Local nOpc	 := 2

A410Visual(cAlias,nReg,nOpc)

Return(.T.)


                      
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³K410VerAlc³ Autor ³ CLEBER                ³ Data ³ 20.06.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz as verif. de acordo com a alcada, no fechamento do Ped.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpA1 == Array com todos os produtos selecionados.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TMKA410                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function P460MAN()

Local oBtn
Local oDlg,oListBox
Local nDescont := 0
Local nOpcLib                  := 0
Local nFrete := 0
Local nSegFret := 0
Local nTotLiqPed := 0
Local cPedido                  := SC5->C5_NUM
Local nTotalList               := 0
Local nOpca					   := 0
Local aTotal	:= {0,0}
Local aTamGrpC := {200,420,255,635}
Local aPosTMem := {210,425,205,040}
Local oMemo
Local cObsComp := SC5->C5_OBSPED
Local cCodOper := Iif(SC5->C5_TIPO=="N","NORMAL",Iif(SC5->C5_TIPO=="D","DEVOL. COMPRAS","COMPLEMENTAR IMPOSTOS"))
Local oFntUFCl1
Local oFntUFCl2

Private nTotPagar :=0
Private nSeguro := 0
Private nTotalPrec  := 0
Private aString := {}





aTotal := L410Junta()


If SC5->C5__STATUS <> '2'
	MsgInfo("Este pedido não esta bloqueado por alçada comercial.","Alçada Comercial")
	Return()
//Else
//	Alert('Estou no parametro')
//	Return()
EndIf     
dbSelectArea("SC6")

nSeguro		:=	SC5->C5_SEGURO
nFrete		:=	SC5->C5_FRETE
nDespesa		:=	SC5->C5_DESPESA
nSegFret		:=	nSeguro + nFrete
nTotalList	:=	aTotal[01] //FSTOTLIS(SC5->C5_NUM,SC5->C5_YTABELA)
nTotalPrec	:=	aTotal[02] //FSTOTYPRC(SC5->C5_NUM) 
nDescont		:=	Round((( nTotalList - nTotalPrec ) / nTotalList ) * 100,2 ) // FSMEDESC(SC5->C5_NUM) 
If nDescont ==	100
	nDescont	:=	0
EndIf
nTotPagar	:=	nTotalPrec + nSegFret + nDespesa

/* NAO E PARA EXCLUIR ESTE DESENVOLVIMENTO SERA IMPLEMENTADO APOS TESTES
If ! FVldLibPV()
	Return(nOpcLib)
EndIf
*/

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SC5->C5_CLIENTE)

dbSelectArea("CC2")
dbSetOrder(1)
dbSeek(xFilial("CC2")+SA1->A1_EST+SA1->A1_COD_MUN)

While .T.

//	Define Dialog oDlg Title OemToAnsi("Libera‡„o por Al‡adas: Pedido: ") + SC5->C5_NUM + "  " + AllTrim(SA1->A1_NOME) + "  " + AllTrim(POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_COND")) + " DIAS" From 31,2 To 580,830 Pixel
	cCondPag := AllTrim(POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_COND")) 
	If Empty(SC5->C5__PEDMEX)
		cOrigem := "VDI"
	Else
		cOrigem := "VDE"
	EndIf 

	Define FONT oFntUFCl1 NAME "Arial" Size 000,018 BOLD
	Define FONT oFntUFCl2 NAME "Arial" Size 000,025 BOLD

	DEFINE MSDIALOG oDlg FROM 031,002 To 585,1270 PIXEL TITLE OemToAnsi("Libera‡„o por Al‡adas: Pedido: ") + SC5->C5_NUM 
    
	@2,1 ListBox oListBox Fields;
			Header "Produto","Descricao",;
			"Quant.",;
			"Prc.Venda",;
			"% Desc","Prc Lista",;
			"Sld Estoque:","Promocao?","Marca", "Grupo","Serie","Categoria";//MARCA-GRUPO-SERIE-CATEGORIA
			Size 635,195 Of oDlg Pixel;
			Sizes 40,130,30,40,30,40,40,40,40,40,80
			oListBox:nAT := 1
			oListBox:SetArray(aString)
			oListBox:bLine:= {|nAt| nAt:= oListbox:nAt,;
			If(Len(aString)<1 .Or. nAt>Len(aString),;
				Array(8),;
				{aString[nAt,1],;
				 aString[nAt,2],;
				 aString[nAt,3],;
				 aString[nAt,4],;
				 aString[nAt,5],;
				 aString[nAt,6],;
				 aString[nAt,7],; 
				 aString[nAt,8],;
				 aString[nAt,9],;
				 aString[nAt,10],;
				 aString[nAt,11],;
				 aString[nAt,12]})}
      
	@ 200,001 Say "Total sem Desconto:"		Size 55, 7 Of oDlg Pixel Right
   @ 200,061 Say "Desconto Total:"			Size 55, 7 Of oDlg Pixel Right
   @ 200,121 Say "Total Com Desconto:"		Size 55, 7 Of oDlg Pixel Right
   @ 225,121 Say "Despesas Acessorias:"	Size 55, 7 Of oDlg Pixel Right
   @ 250,121 Say "Total Liqui Pedido:"		Size 55, 7 Of oDlg Pixel Right
   

	@ 210,001 Get nTotalList	Picture "@E 999,999,999.99" Size 55,9 Of oDlg Pixel Right When .F.
 	@ 210,061 Get nDescont		Picture "@E 999,999,999.99" Size 55,9 Of oDlg Pixel Right When .F.
   @ 210,121 Get nTotalPrec	Picture "@E 999,999,999.99" Size 55,9 Of oDlg Pixel Right When .F.
   @ 235,121 Get nDespesa		Picture "@E 999,999,999.99"  Size 55,9 Of oDlg Pixel Right When .F.
	@ 260,121 Get nTotPagar		Picture "@E 999,999,999.99"  Size 55,9 Of oDlg Pixel Right When .F.

   @ 200,181 Say "Total Bruto Pedido:"	Size 55, 7 Of oDlg Pixel Right
   @ 225,181 Say "Condição Pagto:"	Size 55, 7 Of oDlg Pixel Right
   @ 225,241 Say "Razão Social:"	Size 55, 7 Of oDlg Pixel 
   @ 250,181 Say "Origem:"		Size 55, 7 Of oDlg Pixel Right     
   

   @ 210,181 Get U_FTotPed(SC5->C5_NUM)	Picture "@E 999,999,999.99" Size 55,9 Of oDlg Pixel Right When .F.
   @ 235,181 Get cCondPag		Picture "@!"  Size 55,9 Of oDlg Pixel Right When .F.
	@ 235,241 Get SA1->A1_NOME	Picture "@!" Size 150,9 Of oDlg Pixel Right When .F.	
	@ 260,181 Get cOrigem		Picture "@!"  Size 55,9 Of oDlg Pixel Right When .F. 
	
  @ 250,241 Say "Descto Permitido:"		Size 55, 7 Of oDlg Pixel 	
  @ 260,241 Get U_FCalcDesc(SC5->C5_CLIENTE,SC5->C5_LOJACLI)	Picture "@!"  Size 55,9 Of oDlg Pixel Right When .F.	
   
	@ 200,241 Say "Prazo Médio:"	Size 55, 7 Of oDlg Pixel Right
  @ 210,241 Get U_CalcMed(cCondPag)	Picture "@!" Size 55,9 Of oDlg Pixel Right When .F.	

	
   @225,001 Say "UF/Mun: "+SA1->A1_EST+"/"+SA1->A1_MUN FONT oFntUFCl1 Size 150, 10 Of oDlg Pixel Color CLR_BLACK
   If CC2->CC2_ESTRAT == "1"
      @235,001 Say "Cidade Estratégica"	FONT oFntUFCl2 Size 150, 15 Of oDlg Pixel Color CLR_RED   
//   @235,001 Get Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_COND") Picture "@!"  Size 100,9 Of oDlg Pixel Right When .F.
   EndIf
        
   @245,001 Say "Operacao"	FONT oFntUFCl2 Size 150, 15 Of oDlg Pixel Color CLR_RED
   @260,001 Get cCodOper	Picture "@!"  Size 100,9 Of oDlg Pixel Right When .F.
	
     /*
     cCodOper
     cCodEasy
     Alterar aqui milton
    */
	oGrpMen := TGroup():New(aTamGrpC[01],aTamGrpC[02],aTamGrpC[03],aTamGrpC[04],"OBSERVACAO",oDlg,,,.T.,.T.)
	oMemo   := tMultiget():New(aPosTMem[01],aPosTMem[02],{|u|if(Pcount()>0,cObsComp:=u,cObsComp)},oDlg  ,aPosTMem[03],aPosTMem[04],,,,,,.T.,,,{|| .F.})
	tButton():New(260,420,OemToAnsi("Frete" ),oDlg,{|| nOpca := 4,InfFrete()  },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
	oBtn := tButton():New(260,465,OemToAnsi("Liberar" ),oDlg,{|| nOpca := 1,nOpcLib := 1,oDlg:End()  },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
	oBtn := tButton():New(260,510,OemToAnsi("Cancelar"),oDlg,{|| nOpca := 0,nOpcLib := 0,oDlg:End()  },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
	oBtn := tButton():New(260,555,OemToAnsi("Posicao" ),oDlg,{|| nOpca := 2,nOpcLib := 0,U_P460POS() },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
	oBtn := tButton():New(260,600,OemToAnsi("Analisado" ),oDlg,{|| nOpca := 3,nOpcLib := 0,oDlg:End()},35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)

	Activate MsDialog oDlg Center

	If nOpca == 1

		_aRetUser := {}
		_NomeUser := SubStr(cUsuario,7,15)

		If nDescont < 0
			nDes := 0
		Else
			nDes := nDescont
		EndIf

		If L460Senha(nDes)
			dbSelectArea("SC5")
			dbSetOrder(1)

			If dbSeek(xFilial("SC5") + cPedido)

				RecLock("SC5",.F.) 
				If SC5->C5_CLIENTE >= '900001' .And. SC5->C5_CLIENTE <= '900501'
					SC5->C5__STATUS := "8" 
				Else
					SC5->C5__STATUS := "3"  
				EndIf
				SC5->C5_USUALCA := _NomeUser
				SC5->C5_DTALCAD := (dDataBase)
				SC5->C5_HRALCAD := (Time())
				MsUnlock()

			   	//	U_LMG410Status() // GERA O ARQUIVO DE REMESSA PARA O PALM.

				//Apos TESTE COM O DESENVOLVIMENTO DA VALIDACAO DO PEDIDO COMENTAR ESTA LINHA.
				U_BLibPed(cPedido)           


			EndIf

			dbSelectArea("SC9")
			dbSetOrder(1)
			If dbSeek(xFilial("SC9") + cPedido)

				dbSelectArea("SC5")
				dbClearFilter()
				dbSetOrder(1)
				If dbSeek(xFilial("SC5")+cPedido) //Precisa posicionar novamente no pedido antes de chamar a função
					MsAguarde({|| U_fLibC(nTotPagar)},"Aguarde...",OemToAnsi("Verificando liberação de crédito"),.T.)
				EndIf
				Eval(bFiltraBrw)
			EndIf

			Exit

		EndIf

	ElseIf nOpca == 2
		U_P460POS()
	ElseIf nOpca == 3
			//U_FSPEDBTN()
			
		dbSelectArea("SC5")
		dbSetOrder(1)			
		If dbSeek(xFilial("SC5") + cPedido)

			RecLock("SC5",.F.)
			SC5->C5_INTERAC := "S"
			MsUnlock()
   		EndIf
   		Exit

	Else
		Exit
	EndIF

EndDo

Return(nOpcLib)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³K410Junta ³ Autor ³ CLEBER                ³ Data ³ 08.12.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Junta os itens do pedido                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function L410Junta()

Local nQtdEst := 0
Local aTotal := {0,0}

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+SC5->C5_NUM)

While !Eof() .And. SC6->C6_NUM == SC5->C5_NUM

	If SC6->C6_QTDENT  >= SC6->C6_QTDVEN
		dbSkip()
		Loop
	EndIf
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
	SBM->(dbSetOrder(1))
	SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
	SB2->(dbSetOrder(1))
//	SB2->(dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SB1->B1_LOCPAD))
	SB2->(dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL))

	nQtdEst := (SB2->B2_QATU - SB2->B2_RESERVA)
               
	AADD(aString,{SB1->B1_COD,; //1
						SB1->B1_DESC												,; //2
						Transform(SC6->C6_QTDVEN		,"@E 999,999.99")	,; //3
						Transform(SC6->C6_PRCVEN		,"@E 999,999.99")	,; //4      
						Transform(round((( C6_PRUNIT - C6_PRCVEN ) / C6_PRUNIT ) * 100,2 )		,"@E 999.99"    )		,; //5					  
						Transform(SC6->C6_PRUNIT		,"@E 999,999.99")	,; //6
						Transform(Round(nQtdEst,2)		,"@E 999,999"),; //7 
						IF(SB1->B1_PROMOCA = "1","Sim","Nao"),;
						POSICIONE("SX5",1,xFilial("SX5")+"ZW"+SB1->B1_MARCA,"X5_DESCRI"),;//9 
						SBM->BM_DESC, ;
						POSICIONE("SX5",1,xFilial("SX5")+"ZX"+SB1->B1_SERPROD,"X5_DESCRI"),;//10
						POSICIONE("SX5",1,xFilial("SX5")+"ZY"+SB1->B1_CATEG,"X5_DESCRI")                                    })     //11

	aTotal[01] += (SC6->C6_PRUNIT*SC6->C6_QTDVEN)
	aTotal[02] += (SC6->C6_VALOR)

	SC6->(dbSkip())

EndDo

Return(aTotal)


               


User Function BLibPed(cPedido)
Local _lLibera := .F.       

dbSelectArea("SC6")
DBSetOrder(1)
MsSeek( xFilial("SC6") + cPedido )

nValTot := 0
While !EOF() .And. SC6->C6_NUM == cPedido .And. SC6->C6_FILIAL == xFilial("SC6")
     nValTot += SC6->C6_VALOR   
     
     DbSelectArea("SC9")
     DbSetOrder(1)
     If !DbSeek(xFilial("SC9")+cPedido+SC6->C6_ITEM)
     
     
	     dbSelectArea("SF4")
	     dBSetOrder(1)
	     MsSeek( xFilial("SF4") + SC6->C6_TES )
	     
	     
	     If RecLock("SC5")
	          nQtdLib := SC6->C6_QTDVEN
	          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	          //³Recalcula a Quantidade Liberada                                         ³
	          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	          RecLock("SC6") //Forca a atualizacao do Buffer no Top
	          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	          //³Libera por Item de Pedido                                               ³
	          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	          //Begin Transaction -----Alterado por Valdemir do Carmo em 12/05/16
	          /*
	          ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	          ±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99 ³±±
	          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	          ±±³Descri+.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
	          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	          ±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
	          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	          ±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
	          ±±³          ³controlar a Transacao e os Locks                            ³±±
	          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	          ±±³Parametros³ExpN1: Registro do SC6                                      ³±±
	          ±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
	          ±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
	          ±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
	          ±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
	          ±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
	          ±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
	          ±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
	          ±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
	          ±±³          ³       apenas avalia ).                                    ³±±
	          ±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
	          ±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
	          ±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
	          ±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
	          ±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
	          ±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
	          */    
	          If SC6->C6_CLI >= '900001' .And. SC6->C6_CLI <= '900501'
	          	_lLibera := .T.
	          Else
	          	_lLibera := .F.
	          EndIf
	          MaLibDoFat(SC6->(RecNo()),@nQtdLib,_lLibera,.T.,.F.,.T.,.F.,.F.)
	          
	          //End Transaction -----Alterado por Valdemir do Carmo em 12/05/16
	     EndIf
	     SC6->(MsUnLock())

	     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	     //³Atualiza o Flag do Pedido de Venda                                      ³
	     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	     Begin Transaction
	     SC6->(MaLiberOk({cPedido},.F.))
	     End Transaction
     
     EndIf


dbSelectArea("SC6")
dbSkip()

End
SC6->(dbCloseArea())







Return()






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³L460SenhaºAutor  ³CLEBER              º Data ³  19/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Permite as operacoes de inclusao, baixa e estorno da baixa  º±±
±±º          ³de acordo com senha de usuario                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA810                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function L460Senha(nValor)

Local oDlg1
Local oUser
Local oPass
Local lRet 	 := .T.
Local cUser	 := Space(25)
Local cSenha := Space(25)
Local lSaiTela := .F.
   
While ! lSaiTela

	Define MsDialog oDlg1 From 200,250 To 300,450 Title "Senha" Pixel //"Senha"
	@0.5,01 Say OemToAnsi("Usuario") Size 78,17 Of oDlg1 //"Usuario"
	@1.2,01 MsGet oUser Var cUser Of oDlg1 Size 55,08 Picture "@S15"
	@2.0,01 Say OemToAnsi("Senha") Of oDlg1 //"Senha"
	@2.7,01 MsGet oPass Var cSenha PASSWORD Of oDlg1  Size 55,08 //Picture "@!S15"
	Define sButton From 15,65 Type 1 Action {||(IIF(l460VldSenha(cUser,cSenha,nValor),(lRet:=.T.,lSaiTela := .T.,oDlg1:End()),lRet:=.F.))} Enable Of oDlg1
	Define sButton From 30,65 Type 2 Action {||(lRet := .F.,lSaiTela := .T.,oDlg1:End())} Enable Of oDlg1
	Activate MsDialog oDlg1

EndDo
                     
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³L460VldSe ºAutor  ³CLEBER              º Data ³  19/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Valida a senha digitada para as operacoes na resolucao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA810                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function L460VldSenha(cUser,cSenha,nValor)

Local lRet	:= .T.

// Pesquisa no arquivo de senhas o usuario e valida a senha digitada
If lRet
	PswOrder(2)
	PswSeek(cUser,.T.)
	If !PswName(cSenha)
		HELP("",1,"INVSENHA")
		lRet := .F.
	EndIf
EndIf

If lRet
	cCodUser := L460Usuario(cUser)
	lRet	 := L460AlcLim(cCodUser,nValor,1,0)
	If lRet == .F.
		Help("",1,"L460LIBER")
	EndIf
EndIf

Return(lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MaAlcLim  ³ Autor ³ Aline Correa do Vale ³ Data ³ 24.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica os limites minimos e maximos do aprovador.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Aprovador.                               ³±±
±±³          ³ ExpN1 = Valor a ser verificado na moeda do Documento       ³±±
±±³          ³ ExpN2 = Moeda do documento                                 ³±±
±±³          ³ ExpN3 = Taxa da moeda do documento original                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function L460AlcLim(cCodUser,nValor,nMoeda,nTaxa)

Local nSavOrd
Local nSavRec
Local lRet		:= .F.
Local cSavArea	:= Alias()
Default nMoeda	:= 1
Default nTaxa	:= 0
dbSelectArea("SAK")
nSavOrd := IndexOrd()
nSavRec := Recno()
dbSetOrder(2)
If dbSeek(xFilial() + cCodUser)
	If nTaxa > 0
		If nValor >= xMoeda(SAK->AK_LIMMIN,SAK->AK_MOEDA,IIF(nMoeda > 1,nMoeda,1),dDataBase,,,nTaxa) .And.;
			nValor <= xMoeda(SAK->AK_LIMMAX,SAK->AK_MOEDA,IIF(nMoeda > 1,nMoeda,1),dDataBase,,,nTaxa)
			lRet := .T.
		EndIf
	Else
		If nValor >= xMoeda(SAK->AK_LIMMIN,SAK->AK_MOEDA,1,dDataBase) .And.;
			nValor <= xMoeda(SAK->AK_LIMMAX,SAK->AK_MOEDA,1,dDataBase)
			lRet := .T.
		EndIf
	EndIf
EndIf

dbSetOrder(nSavOrd)
dbGoto(nSavRec)
dbSelectArea(cSavArea)

Return(lRet)

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetCodUsr ³ Autor ³ Cleber                ³ Data ³27.01.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o codigo do Usuario Corrente.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void RetCodUsr()                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ RetC1  - Codigo do usuario corrente.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function L460Usuario(cUser)
	//Local cAlias   := Alias()
	Local cSavOrd  := IndexOrd()
	Local cCodUser := CriaVar("AN_USER")
	PswOrder(2)
	If PswSeek(cUser)
		cCodUser := PswRet(1)[1][1]
	EndIf
	//dbSelectArea(cAlias)
	dbSetOrder(cSavOrd)
Return(cCodUser)



User Function fLibC(nVrTotal)
/***************************************************************************************************************
* Funcao para tratar a liberacao de credito automatica.
* Esta funcao tambem e executada por outra rotina
**/

Local nLimCred	:= 0
Local nSalAbert	:= 0
Local nSalPed	:= 0
Local lCred		:= .F.
Local lBol		:= .F.
Local lUltCom	:= .F.
Local lSint		:= .F.
Local lMon		:= .F.
Local cQuery

//valida o credito do cliente, a data da ultima compra e os campos YSINTHA e YAVMONI
dbSelectArea("SA1")
dbSetorder(1)          

If dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
	nLimCred  := SA1->A1_LC
	nSalAbert := SA1->A1_SALDUP //-->Rodrigo Prates (DSM) 22/10/10 - saldo em aberto do cliente
	nSalPed	  := FSPEDLIB(SC5->C5_CLIENTE,SC5->C5_LOJACLI) //-->Rodrigo Prates (DSM) 22/10/10 - Chama a funcao que valida os pedidos com credito aprovado

	If ((nLimCred - (nSalAbert + nSalPed)) >= nVrTotal) //Limite de credito precisa ser maior que o valor total da venda
		lCred := .T.
	EndIf

	//If ((dDataBase - SA1->A1_ULTCOM) <= 180)
	If (MonthSub(dDataBase,6) <= SA1->A1_ULTCOM) //A ultima compra do cliente precisa ser inferior a 6 meses
		lUltCom := .T.
	EndIf

	If (AllTrim(SA1->A1_YSINTHA) == "1")
		lSint := .T.
	EndIf

	If (AllTrim(SA1->A1_YAVMONI) == "2")
		lMon := .T.
	EndIf

EndIf

//FIM - valida o credito do cliente, a data da ultima compra e os campos YSINTHA e YAVMONI
//valida boleto vencido

U_FCLOSEAREA("QE1")
cQuery := "SELECT E1_NUM FROM " + RetSqlName("SE1") + " SE1 "  
cQuery += "WHERE SE1.D_E_L_E_T_ <> '*' "
cQuery += "AND E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery += "AND E1_CLIENTE = '" + SC5->C5_CLIENTE + "' "
cQuery += "AND E1_LOJA = '" + SC5->C5_LOJACLI + "' " 
cQuery += "AND E1_TIPO IN ('NF','NDC') "  
cQuery += "AND E1_SALDO > 0 AND E1_VENCREA < '" + DtoS(dDataBase) + "' "

cQuery := ChangeQuery(cQuery)	     
//memowrite("C:\cquery.sql",cquery) 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QE1",.F.,.T.)
dbSelectArea("QE1")
dbGoTop()	 

If (AllTrim(QE1->E1_NUM) == "") //nao pode ter nenhum boleto vencido
	lBol := .T.
EndIf

dbSelectArea("QE1")
dbCloseArea()	
//FIM - valida boleto vencido
If lCred .And. lBol .And. lUltCom .And. lSint .And. lMon
	//U_fLibOK()
	If RecLock("SC5",.F.)
		Replace SC5->C5_CREDAUT With "S"
		MsUnlock()
	EndIf
EndIf	

Return(Nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} FSPEDLIB()
Funcao que verifica os pedidos de um determinado cliente que ja tiveram o credito aprovado mas nao foram faturados

@author	Rodrigo Prates
@since	20101023
@param	cCliente	Variavel que recebe o codigo do cliente referente ao pedido de venda.
@param	cLoja		Variavel que recebe o codigo da loja em que o cliente esta cadastrado
@return	QTDVAL->TOTAL	Valor total dos pedidos de venda que cliente tem, que ja tiveram o credito aprovado mas nao foram faturados
/*/
//-------------------------------------------------------------------
Static Function FSPEDLIB(cCliente,cLoja)

U_FCLOSEAREA("QTDVAL")
cQuery := "SELECT ISNULL(SUM(C6_QTDVEN * C6_PRCVEN),0) TOTAL FROM " + RetSqlName("SC6") + " C6 "
cQuery += "INNER JOIN " + RetSqlName("SC5") + " C5 ON C5_FILIAL = C6_FILIAL AND  C5_NUM =  C6_NUM "
cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' "
cQuery += "AND C5_CLIENTE = '" + AllTrim(cCliente) + "' AND C5_LOJACLI = '" + AllTrim(cLoja) + "' "
cQuery += "AND LTRIM(RTRIM(C5__STATUS)) IN ('6','7','8')"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QTDVAL",.T.,.T.)

Return(QTDVAL->TOTAL)
























//-------------------------------------------------------------------
/*/{Protheus.doc} FVldLibPV()
Valida se Existe todos os itens no arquivo de Liberacao do Pedido SC9

@author	Ederson Colen
@since	06/09/2013
@param	

@return	

/*/
//-------------------------------------------------------------------
/*
Static Function FVldLibPV()

Local aAreTela := {SC9->(GetArea()),SC6->(GetArea()),SC5->(GetArea()),GetArea()}
Local lRetVld	:= .T.


//Local lCredito := .F.
//Local lEstoque := .F.
//Local nQtdLib  := 0
//Local nQtdLib2 := 0
//Local lLiberOk := .T.
//Local lLiber := MV_PAR02 == 1
//Local lTransf:= MV_PAR01 == 1


SC6->(dbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

While SC6->(! Eof()) .And. ;
	SC6->C6_NUM == SC5->C5_NUM

	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
	
	If SC9->(Eof())
		//Function A440Grava(lLiber,lTransf)


//		If (SC5->C5_TIPLIB<>"2" )
//			nQtdLib := SC6->C6_QTDLIB
//			nQtdLib2:= If( Empty( SC6->C6_QTDLIB2 ), NIL, SC6->C6_QTDLIB2)
//			nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,.T.,.T.,lLiber,lTransf,NIL,NIL,NIL,NIL,NIL,NIL,nQtdLib2)
//		EndIf
//		SC9->(dbSetOrder(1))
//		SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))     
//		If SC9->(Eof())
//		EndIf

     	Aviso("ATENCAO","O ITEM "+SC6->C6_ITEM+" DO PEDIDO "+SC5->C5_NUM+" NAO FOI LIBERADO. ENTRAR EM CONTATO COM A TI.",{"Ok"}) 
		lRetVld := .F.
		EXIT

	EndIf
	
	SC6->(dbSkip())

EndDo

aEval(aAreTela, {|xAux| RestArea(xAux)})

Return(lRetVld)
*/
Static Function InfFrete()

Local oDlgFrete
Local nOpcX     := 0
Local nVlrFrete := SC5->C5_FRETE        
Local cNomeUser :=SubStr(cUsuario,7,15)

oDlgFrete:=MSDialog():New(000,000,100,300,OemToAnsi(""),,,,,,,,,.t.)
oDlgFrete:lEscClose:=.T. //permite sair ao se pressionar a tecla ESC.
oDlgFrete:lMaximized:=.F. //inicia com tela maximizada

TGroup():New(005,005,030,145,OemToAnsi(""),oDlgFrete,,,.T.,.T.)

TSay():New(013,10,{|| OemToAnsi("Valor do frete:")  },oDlgFrete,,,,,,.T.,,,280,050)
TGet():New(012,060,{|u| if(PCount()>0,nVlrFrete :=u,nVlrFrete) }, oDlgFrete,060,12 ,"@E 999,999,999.99",{|| nVlrFrete >= 0  },,,,,,.T.,,,{||.T.},,,,,.F.,,"nVlrFrete") 
tButton():New(035,055,OemToAnsi("Confirmar" ),oDlgFrete,{|| nOpcX := 1,oDlgFrete:End()  },40,12,,,.F.,.T.,.F.,,.F.,,)
tButton():New(035,105,OemToAnsi("Fechar" ),oDlgFrete,{|| nOpcX := 0,oDlgFrete:End()  },40,12,,,.F.,.T.,.F.,,.F.,,)
	
oDlgFrete:Activate(,,, .T.,{||  },,)  
If nOpcX == 1
   If RecLock("SC5",.F.) 
//      Replace C5_ With nVlrFrete
//      Replace C5_ALTFRET With cNomeUser
      Replace C5_FRETE With nVlrFrete
      SC5->(MsUnLock())
   EndIf     
   nTotPagar	:=	nTotalPrec + nSeguro + nDespesa + nVlrFrete 
EndIf   

Return




User Function P460ALT()
	Local cAlias	:= "SC5"
	Local nReg		:= Recno()
	Local nOpc		:= 4   
 	Local cStatus   := "2"

	nAutoAdt := nOpc 
	
	
	If ALLTRIM(SC5->C5__STATUS) = "5" .or. ALLTRIM(SC5->C5__STATUS) = "6" .or. ALLTRIM(SC5->C5__STATUS) = "7" .or. ALLTRIM(SC5->C5__STATUS) = "8" .or. ALLTRIM(SC5->C5__STATUS) = "9";
		.or. ALLTRIM(SC5->C5__STATUS) = "10" .or. ALLTRIM(SC5->C5__STATUS) = "11"
		MsgStop("Pedido nao pode ser alterado!!")
		Return(.T.)
	EndIF            
	If SC5->C5__STATUS = "12" 
		cStatus := "12"
	EndIf            
	SetKey( K_CTRL_A, 		{ || U_PEBCDFT()  } )
	A410Altera(cAlias,nReg,nOpc,cStatus)
	Eval(bFiltraBrw) 
	SetKey( K_CTRL_A, 		{ || Nil } )
Return(.T.)    


User Function CalcMed(cString)
Local nDivide := 0 
Local _Result := ""
Local nRec := 0


FOR nX := 1 TO Len(cString)
 IF !(SUBSTR(cString,nX,1) $ ",") 
  
  //If !Empty(SUBSTR(_Teste,nX,1)) 
   _Result += SUBSTR(cString,nX,1)
  //EndIf
  
 Else            
  nDivide := nDivide +1
  nRec += Val(_Result)
  _Result := ""
  //_Result +="','"
 EndIf           
 If nX = Len(cString) 
 	  nRec += Val(_Result)
 EndIf
NEXT nX                  

nRec := nRec / (nDivide+1)





Return(nRec)                             


User Function FCalcDesc(cCliente,cLoja)
Local dDataIni := FirstDate(MonthSub(Date(),2))
Local dDataFim := LastDate(MonthSub(Date(),1))
Local cDesc := ""     



cAlDesc := GetNextAlias()
cQrDesc := " SELECT SUM(D2_VALBRUT)TTVenda FROM SD2010 SD2"
cQrDesc += " INNER JOIN SF4010 SF4 ON F4_CODIGO = D2_TES " 
cQrDesc += " WHERE D2_FILIAL = '"+xFilial("SD2")+"'  AND SF4.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' AND F4_DUPLIC = 'S' " 
cQrDesc += " AND D2_CLIENTE = '"+cCliente+"' "
cQrDesc += " AND D2_EMISSAO BETWEEN "+dTos(dDataIni)+" AND "+dTos(dDataFim)+" "

cQrDesc := ChangeQuery(cQrDesc)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrDesc),cAlDesc,.T.,.T.)  


If (cAlDesc)->TTVenda/2 <= 5000
	cDesc := "10%"
ElseIf (cAlDesc)->TTVenda/2 > 5000 .and. (cAlDesc)->TTVenda/2 <= 10000
	cDesc := "14%"
ElseIf (cAlDesc)->TTVenda/2 > 10000 .and. (cAlDesc)->TTVenda/2 <= 20000
	cDesc := "16%"
ElseIf (cAlDesc)->TTVenda/2 > 20000 .and. (cAlDesc)->TTVenda/2 <= 30000
	cDesc := "18%"
Else
	cDesc := "20%"
EndIf            
         
//Alert(cValtoChar((cAlDesc)->TTVenda/2))
DbCloseArea(cAlDesc)

Return(cDesc)