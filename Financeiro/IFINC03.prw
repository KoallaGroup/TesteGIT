#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IFINC03  ³ Autor ³ Rafael Domingues - ANADI ³ Data ³ 10/04/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de Compras Mensais - Botao na tela Posicao de Clientes   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_IFINC03(Cliente,Loja)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Isapa                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFINC03(cCli,cLoja)

Local oDlgMain     := Nil
Local oListBox     := Nil
Local oCheck       := Nil
Local aCoordenadas := MsAdvSize(.T.)
Local nOpcClick    := 0
Local lEdicao      := .F.
Local aPedidos     := {}
Private cCliente   := ""
Private cLoja      := ""
Private cNome      := ""

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+cCli+cLoja)

cCliente := SA1->A1_COD
cLoja    := SA1->A1_LOJA
cNome    := SA1->A1_NOME

//Desenha a Tela
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5]/2,OemToAnsi("Análise de Crédito"),,,,,,,,oMainWnd,.T.)
	TGroup():New(014,003,70,oDlgMain:nClientWidth/2-5,"Dados do Cliente",oDlgMain,,,.T.)
		TSay():New(024,008,{||"Cliente"},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 024,040 MsGet cCliente Of oDlgMain PIXEL SIZE 060,009 When lEdicao
		@ 024,110 MsGet cNome Of oDlgMain PIXEL SIZE 200,009 When lEdicao

	TGroup():New(75,003,oDlgMain:nClientHeight/2-15,oDlgMain:nClientWidth/2-5,"Lista de Compras Mensais",oDlgMain,,,.T.)
		oListBox := TWBrowse():New(085,008,oDlgMain:nClientWidth/2-17,oDlgMain:nClientHeight/2-115,,{"Mes/Ano","Valor"},,oDlgMain,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aPedidos)
		oListBox:bLine := {||{ aPedidos[oListBox:nAt][1],aPedidos[oListBox:nAt][2]}}

		EnchoiceBar(oDlgMain,{|| nOpcClick := 1, oDlgMain:End() },{|| nOpcClick := 0, oDlgMain:End()})

cQuery := " SELECT C5_CLIENTE, C5_LOJACLI, SUBSTRING(C5_EMISSAO,1,6) MES, SUM(C6_VALOR) TOTAL FROM "
cQuery += RetSQLName("SC5")+" C5, "+RetSQLName("SC6")+" C6 "
cQuery += " WHERE C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' "
cQuery += " AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
cQuery += " AND C5_CLIENTE = '"+SA1->A1_COD+"' "
//cQuery += " AND C5_LOJACLI = '"+SA1->A1_LOJA+"' "
cQuery += " GROUP BY C5_CLIENTE, C5_LOJACLI, SUBSTRING(C5_EMISSAO,1,6) "
cQuery += " ORDER BY C5_CLIENTE, C5_LOJACLI "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","TOTAL","N",12,2)

DbSelectArea("TMP")
DbGoTop()

While !Eof()
	
	AAdd(aPedidos,{Substr(TMP->MES,1,4)+"/"+Substr(TMP->MES,5,2),TMP->TOTAL})
	DbSkip()
End

DbSelectArea("TMP")
DbCloseArea()

//Atualiza o list de produtos
oListBox:SetArray(aPedidos)
oListBox:bLine := {||{ 	aPedidos[oListBox:nAt][1],aPedidos[oListBox:nAt][2]}}
oListBox:Refresh()
lEdicao := .F.

oDlgMain:Activate(,,,.T.)

Return(Nil)
