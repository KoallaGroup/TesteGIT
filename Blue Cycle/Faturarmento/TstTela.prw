#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 25/06/04

User Function TstTela()        // incluido pelo assistente de conversao do AP6 IDE em 25/06/04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALI_ANT,NRECNO,CCOD,NVALORD2,NQATU,NQATU98,NRESERVA")
SetPrvt("NQPEDVEN,NQEMPENHO,NQPREVIS,NMOSTRA,NPROP,ESTREST")
SetPrvt("ESTRRES,ESTREMP,ESTRPED,ESTRPRV,ESTRSAL,CCODIGO")
SetPrvt("CDESC,CORIGEM,CTOP,N_PRCVEN,DDATAINI,NSALDO")
SetPrvt("CCADASTRO,AFIELDS,AHEADER,ACOLS,CTRBARQ,CCOMP")
SetPrvt("AC,ACGD,CLINOK,CTUDOK,LRETMOD2,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BROC020E ³ Autor ³ Fabricio Carlos David ³ Data ³ 25/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta tela de consulta com dados do estoque.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BROC020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cAli_Ant		:= Alias()
nRecno          := Recno()
cCod			:= SB1->B1_COD
nValorD2		:= 0
nQAtu			:= 0
nQAtu98			:= 0
nReserva		:= 0
nQPedVen		:= 0
nQEmpenho       := 0
nQPrevis        := 0
nMostra         := 0
nProp           := 0
EstrEst         := 0
EstrRes         := 0
EstrEmp         := 0
EstrPed         := 0
EstrPrv         := 0
EstrSal         := 0
PERGUNTE("BRC020",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma a quantidade no estoque de todos os almoxarifados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*dbSelectArea("SB2")
dbSetOrder(1)
dbSeek( xFilial()+cCod )
  
While !EOF() .And. B2_COD == SB1->B1_COD
	IF SB2->B2_LOCAL $ ALLTRIM('01')
		nQAtu     := nQAtu     + B2_QATU
		nReserva  := nReserva  + B2_RESERVA
		nQPedVen  := nQPedVen  + B2_QPEDVEN
		nQPrevis  := nQPrevis  + B2_SALPEDI
		nQEmpenho := nQEmpenho + B2_QEMP
	ENDIF

	IF SB2->B2_LOCAL == "98"
		nQAtu98   := nQAtu98   + B2_QATU
	ENDIF
	
	dbSkip()
End*/

cCodigo  := 'Teste tela'
cDesc    := 'Teste tela'
cOrigem  := 'Brasil'
cTOP     := "Sku BCD"
n_PrcVen := 9999999
dDataIni := cTod("")

nSaldo:= nQAtu - nReserva - nQPedVen - nQEmpenho

#IFDEF WINDOWS
	cCadastro:="Consulta de Estoque"
	@ 116,75 TO 455,600 DIALOG oDlg TITLE OemToAnsi(cCadastro)
	@ 07,14 SAY OemToAnsi("C¢digo:")
	@ 07,70 GET cCodigo SIZE 146,10 When .F.
	@ 17,14 SAY "Produto:"
	@ 17,70 GET cDesc SIZE 146,10 When .F.
	@ 27,14 SAY "Qtd.Total.Est:"
	@ 27,70 GET nQAtu SIZE 146,10 When .F. 
	
	@ 37,14 SAY "Qtd.Total.Est Qualid: "
	@ 37,70 GET nQAtu98 SIZE 146,10 When .F.
		
	@ 47,14 SAY "Qtd.Total.Res:"
	@ 47,70 GET nReserva SIZE 146,10 When .F.
	@ 57,14 SAY "Qtd.Total.Ped:"
	@ 57,70 GET nQPedVen SIZE 146,10 When .F.
	@ 67,14 SAY "Saldo:"
	@ 67,70 GET nSaldo SIZE 146,10 When .F.
	@ 77,14 SAY "Origem:"
	@ 77,70 GET cOrigem SIZE 146,10 When .F.
	@ 87,14 SAY OemToAnsi("Med.de Consumo:")
	@ 87,70 GET nMostra SIZE 146,10 When .F.
	@ 97,14 SAY OemToAnsi("Prc.Venda:")
	@ 97,70 GET n_PrcVen Picture "@E999,999,999.99" SIZE 146,10 When .F.
	@ 107,14 SAY OemToAnsi("Qtde.Prevista")
	@ 107,70 GET nQPrevis Picture "@E999,999,999.99" SIZE 146,10 When .F.
	@ 117,14 SAY OemToAnsi("Top:")
	@ 117,70 GET cTOP SIZE 146,10 When .F.
	@ 134,1 TO 124,450
	@ 140,155 BUTTON "_Estoque da Estrutura" Size 60,12 Action Estrut()// Substituido pelo assistente de conversao do AP6 IDE em 25/06/04 ==>         @ 130,155 BUTTON "_Estoque da Estrutura" Size 60,12 Action Execute(Estrut)
	@ 140,220 BUTTON "_Ok" Size 30,12 Action Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
#ENDIF


Return()        // incluido pelo assistente de conversao do AP6 IDE em 25/06/04