#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/**
Alteracoes: Rodrigo Prates (DSM) - 11/01/11-->
-->Inserindo validacao de filial em todas as querys
-->Inserindo chamada do metodo generico "U_FCLOSEAREA" que apaga tabela e/ou arquivo aberto
**/
User Function M410BB(cPedido)

Private cPedido

cPedido	:= AllTrim(SC5->C5_NUM)
cCliente	:= AllTrim(SC5->C5_CLIENTE)
cLoja		:= AllTrim(SC5->C5_LOJACLI)

cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5__STATUS = '3' "
cQuery += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = '" + cPedido + "'"
TcSqlExec(cQuery)

cQuery14 := "UPDATE " + RetSqlName("SC9") + " SET D_E_L_E_T_ = '*' "
cQuery14 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "' AND D_E_L_E_T_ = ''"
TcSqlExec(cQuery14)

cQuery15 := "UPDATE " + RetSqlName("SC9") + " SET C9_NFISCAL = ' ' "
cQuery15 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery15)

cQuery16 := "UPDATE " + RetSqlName("SC9") + " SET C9_SERIENF = ' ' "
cQuery16 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery16)

cQuery17 := "UPDATE " + RetSqlName("SC9") + " SET C9_CLIENTE = '" + cCliente + "' "
cQuery17 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery17)

cQuery18 := "UPDATE " + RetSqlName("SC9") + " SET C9_LOJA = '" + cLoja + "' "
cQuery18 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery18)

FSESTSC6(cPedido)

dbSelectArea("SC9")
dbSetOrder(1)

cQuery1 := "UPDATE " + RetSqlName("SC9") + " SET C9_BLEST = ' ' "
cQuery1 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery1)

cQuery2 := "UPDATE " + RetSqlName("SC9") + " SET C9_BLCRED = '03' "
cQuery2 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery2)

cQuery8 := "UPDATE " + RetSqlName("SC9") + " SET C9_YCORTE = 0 "
cQuery8 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "'"
TcSqlExec(cQuery8)

dbSelectArea("SC6")
dbSetOrder(1)

cQuery3 := "UPDATE " + RetSqlName("SC6") + " SET C6_QTDEMP = C6_QTDVEN "
cQuery3 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + cPedido + "'"
TcSqlExec(cQuery3)

cQuery9 := "UPDATE " + RetSqlName("SC6") + " SET C6_YCORTE = 0, C6_QTDEAVU = 0.00 , C6_DTESAVU = ' ', C6_USRESAV = ' ' "
cQuery9 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + cPedido + "'"
TcSqlExec(cQuery9)

FSEST(cPedido)

Return(Nil)



Static Function FSEST(cPedido)

U_FCLOSEAREA("QSC6")

cQuery10 := "SELECT C6_PRODUTO, C6_QTDVEN, '01' FSLOCAL FROM " + RetSqlName("SC6") + " "
cQuery10 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND D_E_L_E_T_ = ' ' "
cQuery10 += "AND C6_NUM = '" + cPedido + "'"
TCQUERY cQuery10 ALIAS "QSC6" NEW

QSC6->(dbGoTop())

While !QSC6->(EoF())
	FSATUEST(QSC6->C6_PRODUTO,QSC6->C6_QTDVEN,QSC6->FSLOCAL)
	QSC6->(dbSkip())
EndDo

Return(Nil)


Static Function FSATUEST(cProd,nSald,cLocal)

dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial("SB2") + cProd + cLocal)
	If SB2->B2_RESERVA == nSald
		If RecLock("SB2",.F.)	
			Replace SB2->B2_QPEDVEN With 0  
			Replace SB2->B2_RESERVA With 0
			MsUnlock()
		EndIf
	EndIf
EndIf

Return(Nil)



Static Function FSESTSC6(cPedido)

U_FCLOSEAREA("QSC61")

cQuery11 := "SELECT * FROM " + RetSqlName("SC6") + " "
cQuery11 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND D_E_L_E_T_ = ' ' "
cQuery11 += "AND C6_NUM = '" + cPedido + "'"
TCQUERY cQuery11 ALIAS "QSC61" NEW
QSC61->(dbGoTop())

While !QSC61->(EoF())
	cQuery12 := "UPDATE " + RetSqlName("SC9") + " SET D_E_L_E_T_ = ' ', C9_QTDLIB = " + Str(QSC61->C6_QTDVEN) + ", "
	cQuery12 += "C9_PRCVEN = " + Str(QSC61->C6_PRCVEN) + ", C9_PRODUTO = '" + QSC61->C6_PRODUTO + "' "
	cQuery12 += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "' "
	cQuery12 += "AND R_E_C_N_O_ = " + Str(FSESTSC9(cPedido,QSC61->C6_ITEM)) + ""
	TcSqlExec(cQuery12)
	QSC61->(dbSkip())
EndDo

Return(Nil)



Static Function FSESTSC9(cPedido,cItem)

U_FCLOSEAREA("QSC9")
/*cQuery13 := " SELECT TOP 1 R_E_C_N_O_ FROM " + RetSqlName("SC9") + " "
cQuery13 += " WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "' "
cQuery13 += " AND C9_ITEM = '" + cItem + "' " 
cQuery13 += " ORDER BY R_E_C_N_O_ DESC " */       


cQuery13 := " SELECT R_E_C_N_O_ FROM " + RetSqlName("SC9") + " "
cQuery13 += " WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_PEDIDO = '" + cPedido + "' "
cQuery13 += " AND C9_ITEM = '" + cItem + "' AND ROWNUM < 2" 
cQuery13 += " ORDER BY R_E_C_N_O_ DESC " 
TCQUERY cQuery13 ALIAS "QSC9" NEW

Return(QSC9->R_E_C_N_O_)