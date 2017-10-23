#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE DIRMASC "\MSXML\"
#DEFINE DIRXMLTMP "\MSXMLTMP\"
#DEFINE ITENSSC6 300
#xCommand CLOSETRANSACTION LOCKIN <aAlias,...>   => EndTran( \{ <aAlias> \}  ); End Sequence
Static __lHasWSSTART

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATA410  ³ Rev.  ³ Eduardo Riera         ³ Data ³ 26.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de atualizacao de Pedidos de Venda                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void MATA410(void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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

/**
Alteracoes: Rodrigo Prates (DSM) - 11/01/11-->
-->Inserindo validacao de filial no metodo "FSLIBORC()"
**/
//User Function LMG415(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,cRotina,cCodCli,cLoja)
User Function LMG415(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,cRotina,cCodCli,cLoja,xRatCTBPC,xAdtPC)
	Local aCores := {}
	Local cRoda  := ""
	Local bRoda  := {|| .T.}
	Local xRet   := Nil
	Local aArea	 := GetArea()
	Local cGrupo := ""
	Local lAdm	 := .F.
	Public nAutoAdt
	Public aRatCTBPC	:= If(xRatCTBPC<>NIL,xRatCTBPC,{})
	Public aAdtPC		:= If(xAdtPC <> NIL,xAdtPC,{})
	Private cBcis	 	:= ""
	Private lOnUpdate	:= .T.	
	Private l410Auto	:= xAutoCab <> Nil  .And. xAutoItens <> Nil
	Private aAutoCab	:= {}
	Private aAutoItens	:= {}  
	Private aColsCCust	:= {}                
	Private aBkpAgg	  := {} 
	Private aRotina		:= {{OemToAnsi(STR0001)	 ,"AxPesqui"   ,0,1,00},; //"Pesquisar"
							{OemToAnsi(STR0002)  ,"A410Visual" ,0,2,00},; //"Visual"
							{OemToAnsi(STR0003)  ,"U_P415INC"  ,0,3,00},; //"Incluir"
							{OemToAnsi(STR0004)  ,"U_P415Alt"  ,0,4,20},; //"Alterar"
							{OemToAnsi(STR0005)  ,"U_P415Del"  ,0,5,21},; //"Excluir"
							{OemToAnsi(STR0006)  ,"A410Barra"  ,0,3,00},; //"Cod.barra"
							{OemToAnsi("Efetiva"),"U_FSLIBORC" ,0,3,00},; //"Efetiva"
							{OemToAnsi(STR0032)  ,"U_P415Leg"  ,0,3,00},; //"Legenda"                 
							{OemToAnsi("Posição Pedido")	 ,"U_BCDCONPED('1')",0,3,0 },;  //"Legenda"   
							{OemToAnsi("Enviar Email")	 ,"U_PEDVENDASEMAIL",0,3,0 },;  //"Legenda"   
							{OemToAnsi("Rel Ped"),"U_FSPEDBTN" ,0,3,00}}  //"Rel Ped"
	Private cCadastro	:= OemToAnsi(STR0007) //"Atualiza‡„o de Pedidos de Venda"
	If (cPaisLoc != "BRA")
		Private aArrayAE := {}
		Private lImpMsg	 := .T.
	EndIf
	Private	aCores    	:= {{"ALLTRIM(SC5->C5__STATUS)=='1'",'BR_VERMELHO_OCEAN'}} //Orcamento
	Default nOpcAuto	:= 3
	Default lSimulacao	:= .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste no pergunte MTA410				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_FSAJX1()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste no SX3                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_FSAJX3()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento de Rotina Automatica            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(cRotina) == "C"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz tratamento para chamada por outra rotina             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(nScan := AScan(aRotina,{|x| Upper(Alltrim(x[2])) == Upper(Alltrim(cRotina))}))
			bRoda := &("{ || " + cRotina + "( 'SC5', SC5->( Recno() ), " + Str(nScan,2) + IIF(ValType(cCodCli)=="C",",nil,nil,nil,nil,nil,cCodCli,cLoja", "") + ") } ")
			xRet  := Eval(bRoda)
		EndIf
	Else
		If (Type("l410Auto") <> "U" .And. l410Auto)
			lOnUpdate  := !lSimulacao
			aAutoCab   := xAutoCab
			aAutoItens := xAutoItens
			MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"SC5")
			xAutoCab   := aAutoCab
			xAutoItens := aAutoItens
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define variaveis de parametrizacao de lancamentos    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ MV_PAR01 Sugere Quantidade Liberada ? Sim/Nao        ³
			//³ MV_PAR02 Preco Venda Com Substituicao ? Sim?Nao      ³
			//³ MV_PAR03 Utiliz.Op.Triangular     ?   Sim/Nao        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ativa tecla F-10 para parametros                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SetKey(VK_F12,{|| a410Ativa()})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para alterar cores do Browse do Cadastro    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MA410COR")
				aCores := ExecBlock("MA410COR",.F.,.F.,aCores)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Endereca a funcao de BROWSE                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MT410BRW")
				ExecBlock("MT410BRW",.F.,.F.)
			EndIf

			//cBCIs := U_FGrpBCI() 
					
			dbSelectArea ("SC5")
			dbSetOrder(1)
			dbGoTop()
			_cFiltro		:= ' ALLTRIM(SC5->C5__STATUS) = "1" ' //.AND. SC5->C5_YBCI $ "'+cBCIs+'"' Alterado por Valdemir do Carmo em 05/11/15
			_aIndexSC5	:= {}
	   	If	! Empty(_cFiltro)
	   		bFiltraBrw := {|| FilBrowse("SC5",@_aIndexSC5,@_cFiltro)}
				Eval(bFiltraBrw)
	   	EndIf

			mBrowse(6,1,22,75,"SC5",,,,,,aCores)

			EndFilBrw("SC5",_aIndexSC5)

		EndIf

	EndIf

	dbSelectArea("SC5")
	dbSetOrder(1)

	dbClearFilter()
	SetKey(VK_F12,Nil)
	Restarea(aArea)

Return(.T.)

User Function P415LEG()
	Local aLegenda := {{'BR_VERMELHO_OCEAN','Orcamento'}}
	BrwLegenda(cCadastro,'Legenda',aLegenda)
Return(.T.)

User Function P415INC(nIDAte,cCodCli,cLoja)
	Local cAlias   := "SC5"
	Local nReg     := Recno()
	Local nOpc     := 3
	Public cStatus := "1"
	nAutoAdt := nOpc                    


	SetKey( K_CTRL_A, 		{ || U_PEBCDFT()  } )	
	SetKey( K_CTRL_B, 		{ || U_BCDCONPED('2')  } )	
	
	Private nIDAtende := ""
	
	If Empty(nIDAte) .Or. nIDAte == "SC5"
		A410Inclui(cAlias,nReg,nOpc,cStatus)
	Else   
		Public cStatus	 := "1"
		
		nIDAtende := nIDAte
		A410Inclui(cAlias,nReg,nOpc,cStatus,,,,,cCodCli,cLoja)
	Endif
		
	dbSelectArea ("SC5")
	dbSetOrder(1)
	Eval(bFiltraBrw)
	SetKey( K_CTRL_A, 		{ || Nil } )
	SetKey( K_CTRL_B, 		{ || Nil } )		
		
Return(.T.)

/* User Function P415INC() // 29-09-17
	Local cAlias   := "SC5"
	Local nReg     := Recno()
	Local nOpc     := 3
	Public cStatus := "1"
	nAutoAdt := nOpc                    


	SetKey( K_CTRL_A, 		{ || U_PEBCDFT()  } )	
	SetKey( K_CTRL_B, 		{ || U_BCDCONPED('2')  } )	
	A410Inclui(cAlias,nReg,nOpc,cStatus)
	dbSelectArea ("SC5")
	dbSetOrder(1)
	Eval(bFiltraBrw)
	SetKey( K_CTRL_A, 		{ || Nil } )
	SetKey( K_CTRL_B, 		{ || Nil } )		
	
	
	
Return(.T.) */

User Function P415ALT()
	Local cAlias   := "SC5"
	Local nReg	   := Recno()
	Local nOpc     := 4
	Public cStatus := "1"
	nAutoAdt := nOpc
	
	
	SetKey( K_CTRL_A, 		{ || U_PEBCDFT()  } )	
	A410Altera(cAlias,nReg,nOpc,cStatus)
	Eval(bFiltraBrw)
	SetKey( K_CTRL_A, 		{ || Nil } )
Return(.T.)

User Function P415Del()
	Local cAlias   := "SC5"
	Local nReg     := Recno()
	Local nOpc     := 5
	Public cStatus := "1"
	nAutoAdt := nOpc
	A410Deleta(cAlias,nReg,nOpc,cStatus)
	Eval(bFiltraBrw)
Return(.T.)

User Function FSLIBORC()                    
	If ApMsgNoYes("Esta função irá executar a efetivação do orçamento em pedido de venda. Deseja continuar?","Atenção")                  
		cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5__STATUS = '2',C5_EMISSAO = '"+Dtos(Date())+"', C5_HISSTAT = RTRIM(C5_HISSTAT)||'#LMG415',   "   
		//cQuery += " WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = '" + SC5->C5_NUM + "' "    
		cQuery += "C5_USEREFE = '"+SubStr(cUsuario,7,15)+"', C5_DTEFETI = '"+Dtos(Date())+"', C5_HREFETI = '"+(Time())+"' WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = '" + SC5->C5_NUM + "' "    
		//SC5->C5_USEREFE := SubStr(cUsuario,7,15)
		//SC5->C5_DTEFETI 	:= (dDataBase)
		//SC5->C5_HREFETI 	:= (Time())		
		
		
		Begin Transaction
			TcSqlExec(cQuery)
		End Transaction
        
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+SC5->C5_NUM)
		iF SC5->C5_TIPO = "N" .And. SC5->C5__STATUS = "2"
			//Alert('Chamar a função de confirmação de pedido aqui')
			U_EmailPed(SC5->C5_NUM)
		EndIf		
		
		Eval(bFiltraBrw)
	End  
	

	
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Marcelo Alexandre   º Data ³ 08/05/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA410		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*
Rodrigo Bastos (DSM) - 19/01/11
Funcao inserida, pois o MATA410 foi atualizado
*/
User Function FSAJX1()
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	AADD(aHelpPor,"Informe Saldo para considerar o saldo 	")
	AADD(aHelpPor,"restante do pedido de vendas o que foi	") 
	AADD(aHelpPor,"faturado e eliminado resíduo ou Total.	")
	AADD(aHelpSpa,"Informe Saldo para considerar el saldo 	")
	AADD(aHelpSpa,"restante del pedido de ventas, el que se ")
	AADD(aHelpSpa,"facturó y eliminó por residuo ou total.	")
	AADD(aHelpEng,"Inform the balance to consider the remai-")
	AADD(aHelpEng,"ning balance of the request of sales that") 
	AADD(aHelpEng,"was invoiced and removed residue or Total")
	PutSX1Help("P.MTA41004.",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1("MTA410","01","Sugere Qtd Liber. ?"		,""							,""						,"mv_ch1","C",1,0,1,"C","","","","","mv_par01","Sim"  ,"Si"   ,"Yes"	,"0000" ,"Nao"  ,"No"   ,"No"   ,"","","","","","","","","")
	PutSx1("MTA410","02","Prc.Venda c/Substir?"		,""							,""						,"mv_ch2","N",1,0,2,"C","","","","","mv_par02","Sim"  ,"Si"   ,"Yes"	,""		,"Nao"  ,"No"   ,"No"   ,"","","","","","","","","")
	PutSx1("MTA410","03","Op. Triangular ?"			,""							,""						,"mv_ch3","N",1,0,2,"C","","","","","mv_par03","Sim"  ,"Si"   ,"Yes"	,""		,"Nao"  ,"No"   ,"No"   ,"","","","","","","","","")
	PutSx1("MTA410","04","Planilha Financeira?"		,"Planilla financiera?"		,"Financial Worksheet?"	,"mv_ch4","N",1,0,2,"C","","","","","mv_par04","Saldo","Saldo","Balance",""		,"Total","Total","Total","","","","","","","","","")
	PutSx1("MTA410","05","Contabiliza On-Line?"		,"¿Contabiliza en linea?"	,"Record Online?"		,"mv_ch5","N",1,0,2,"C","","","","","mv_par05","Sim"  ,"Si"   ,"Yes"	,""		,"Nao"  ,"No"   ,"No"   ,"","","","","","","","","")
	PutSx1("MTA410","06","Aglutina Lanc. Contabil?"	,"¿Agrupa Asto. Contable?"	,"Group Accnt.Entry?"	,"mv_ch6","N",1,0,2,"C","","","","","mv_par06","Sim"  ,"Si"   ,"Yes"	,""		,"Nao"  ,"No"   ,"No"   ,"","","","","","","","","")
	PutSx1("MTA410","07","Mostra lancamento?"		,"¿Muestra asiento?"		,"Display Entry ?"		,"mv_ch7","N",1,0,2,"C","","","","","mv_par07","Sim"  ,"Si"   ,"Yes"	,""		,"Nao"  ,"No"   ,"No"   ,"","","","","","","","","")
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |A410AjuSX3ºAutor  ³Marcelo Alexandre   º Data ³ 11/07/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA410		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*
Rodrigo Bastos (DSM) - 19/01/11
Funcao inserida, pois o MATA410 foi atualizado
*/
User Function FSAJX3()
	Local aAreaSX3 := SX3->(GetArea())
	Local aAreaAnt := GetArea()
	Local nCntfor  := 0
	Local nNrVend  := Fa440CntVen()
	Local aPHelpPor := {"Indica se a ordem de separação (SIGAWMS)",;
						"deve ser gerada na liberação do pedido,",;
						"na montagem ou na unitização da carga." }
	Local aPHelpEng := {"Indica si el O.S. (SIGAWMS)",;
						"debe ser generada en el pedido,",;
						"en el montaje o en la unitization."}
	Local aPHelpSpa := {"It indicates if generates S.O.(SIGAWMS)",;
						"in Sales Order, in Assemble Load",;
						"or in unitizacion."}
	SX3->(dbSetOrder(2))
	//-- SIGAWMS: Ajuste do ComboBox
	If	SX3->(dbSeek("C5_GERAWMS"))
		If	SX3->(Empty(X3_CBOX) .Or. Empty(X3_CBOXSPA) .Or. Empty(X3_CBOXENG))
			RecLock("SX3",.F.)
			SX3->X3_CBOX    := "1=no Pedido;2=na Montagem da Carga;3=na Unitizacao da Carga"
			SX3->X3_CBOXSPA := "1=en el Pedido;2=en el Montaje de Carga;3=en la Unitizacion"
			SX3->X3_CBOXENG := "1=in Sales Order;2=in Assemble Load;3=in Unitization"
			MsUnLock()
		EndIf
		PutHelp("PC5_GERAWMS",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	EndIf
	SX3->(dbSetOrder(2))
	For nCntfor := 1 To nNrVend
		SX3->(dbSeek("C5_VEND"+Str(nCntfor,1)))
		If '.OR. EXISTCPO("SA3")' $ Upper(SX3->X3_VALID)
			RecLock("SX3",.F.)
			Replace SX3->X3_VALID With StrTran(AllTrim(Upper(SX3->X3_VALID)),'.OR. EXISTCPO("SA3")','')
			Replace SX3->X3_VALID With StrTran(AllTrim(Upper(SX3->X3_VALID)),'.AND. VAZIO()','.OR. VAZIO()')
			MsUnLock()
		Else
			Exit
		EndIf
	Next nCntfor
	If cPaisLoc == "ANG"
		If	SX3->(dbSeek("C5_DOCGER")) 
			If AllTrim(SX3->X3_CBOX) <> '1=Factura;2=Guia de Transporte;3=Entrega Futura'
				RecLock("SX3",.F.)
				SX3->X3_CBOX := '1=Factura;2=Guia de Transporte;3=Entrega Futura'
				MsUnLock()
			EndIf
		EndIf
	EndIf
	RestArea(aAreaSX3)
	RestArea(aAreaAnt)
Return(Nil)