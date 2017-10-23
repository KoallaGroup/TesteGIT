#INCLUDE "RWMAKE.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FSTABPRC
Cadastro da Tabela de Preco

@author	Breno Menezes
@since	
@param	
@return

Alteracoes Realizadas desde a Estruturacao Inicial
Data			Programador		Motivo
01/04/13		Ederson Colen	Reestruturaçã do Fonte e inclusão da tratativa
									do Fator 2 (Dentro e Fora)
/*/
//------------------------------------------------------------------- 
User Function FSTABPRC()
   
Private cCadastro := "Cadastro da Tabela de Preco"

Private aRotina	:= {{"Pesquisar" ,"AxPesqui"		,0,1},;
					  		 {"Visualizar","AxVisual"		,0,2},;
							 {"Incluir"   ,"U_FSTELAPRC()",0,6},;
							 {"Alterar"   ,"AxAltera"		,0,4},;
							 {"Excluir"   ,"U_FSEXC()"		,0,5}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

dbSelectArea("DA0")
dbSetOrder(1)

mBrowse(6,1,22,75,"DA0")
	
Return(Nil)



//-------------------------------------------------------------------
/*/{Protheus.doc} FSTABPR
Função para criação de tela para inclusão na tabela de preço

@protected
@author    
@since     
@obs       
@param     
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function FSTELAPRC()

Local aTip := {"01-Cust.Stand. X Fator Dentro","02-Cust.Stand. X Fator Fora","03-Cust.Stand. X Fator Transf."}

Private oDlg
Private nRecDA0 := DA0->(Recno())

Private cTipo := ""

@00,00 To 150,400 Dialog oDlg Title "Tabela de Preco"
@01,01 Say "Deseja gerar a Tabela por: " 
@01,09 ComboBox cTipo Items aTip Size 120,60
@05,03 Button "_Confirma" Size 35,15 Action FSTABPR(cTipo)
@05,15 Button "_Sair" Size 35,15 Action oDlg:End()

Activate Dialog oDlg Centered

dbSelectArea("DA0")
dbGoTo(nRecDA0)

Return(Nil)
           


//-------------------------------------------------------------------
/*/{Protheus.doc} FSTABPR
Rotina de processamento da Inclusao dos Novos Itens da Tabela de Preco.

@protected
@author    
@since     
@obs       
@param     
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function FSTABPR(cTipo)

Processa({|| FGrvTPrc(cTipo)},cCadastro)

oDlg:End()

Return 

    

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTPrc
Rotina de Inclusao dos Novos Itens da Tabela de Preco.

@protected
@author    
@since     
@obs       
@param     
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function FGrvTPrc(cTipo)

Local aMsgPrd := {}

Private cTip	:= SubStr(cTipo,1,2)
Private cPerg	:= "FSNECC"
Private aProd	:= {} 
Private cQuery := ""
	
nInclui := AxInclui("DA0",0,3)
nRecDA0 := DA0->(Recno())

If nInclui  == 1

	U_FCLOSEAREA("QDA1")

	cQuery := "SELECT B1.B1_COD, B1.B1_DESC, "+IIf(cTip == "01","(B1.B1_CUSTD * B1.B1_YFATOR)",IIf(cTip == "02","(B1.B1_CUSTD * B1.B1_YFATOR2)","(B1.B1_CUSTD * B1.B1_YFATOR3)"))+" AS B1_CUSTD, B1.B1_GRUPO "
	cQuery += "FROM " + RetSqlName("SB1") + " B1 "
//	cQuery += "INNER JOIN " + RetSqlName("SZE") + " ZE ON(ZE.D_E_L_E_T_ <> '*' AND ZE.ZE_FILIAL = '" + xFilial("SZE") + "' AND ZE.ZE_CODPROD = B1.B1_COD AND ZE.ZE_BCI = '"+DA0->DA0_BCI+"') "
	cQuery += "WHERE B1.D_E_L_E_T_ <> '*' "
	cQuery += "AND B1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += "AND B1_CUSTD <> 0 "
	cQuery += "AND B1_MSBLQL <> '1' "
	cQuery += "GROUP BY B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO, B1.B1_CUSTD,"+IIf(cTip == "01"," B1.B1_YFATOR ",IIf(cTip == "02"," B1.B1_YFATOR2 "," B1.B1_YFATOR3 "))
	cQuery += "ORDER BY B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO "

	If TcSqlExec(cQuery) <> 0
		Aviso(OemToAnsi("Atenção"),"ERRO SQL "+TCSqlError(),{"Ok"},2)
		If DA0->(! Eof())
			If (RecLock("DA0",.F.))
				dbDelete()
				MsUnLock()
			EndIf
		EndIf
		Return
	Else
		//Cria o arquivo de trabalho da query posicionada
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"QDA1",.F.,.T.)
		QDA1->(dbGoTop())
		//Valida se exitem informacoes no arquivo gerado.
		If QDA1->(Eof())
			Aviso("ATENCAO","Não foram criados os Itens da Tabela.",{"Ok"})
			If DA0->(! Eof())
				If (RecLock("DA0",.F.))
					dbDelete()
					MsUnLock()
				EndIf
			EndIf
			Return
		EndIf
	EndIf
	
	QDA1->(dbGoTop())
	cContIt := 	StrZero(1,(TamSX3("DA1_ITEM")[01]))

	ProcRegua((SB1->(RecCount())/10))

	While QDA1->(! EoF())

		//Incrementa regua
		IncProc("Processando, Aguarde..")

		DA1->(dbSetOrder(2)) //DA1_FILIAL+DA1_CODPRO+DA1_CODTAB+DA1_ITEM
		If ! DA1->(dbSeek(xFilial("DA1")+QDA1->B1_COD+DA0->DA0_CODTAB+cContIt))
			RecLock("DA1",.T.)
			DA1->DA1_ITEM		:= cContIt
			DA1->DA1_CODTAB	:= DA0->DA0_CODTAB
	 		DA1->DA1_CODPRO	:= QDA1->B1_COD
//	 		DA1->DA1_DESC		:= QDA1->B1_DESC
		 	DA1->DA1_PRCVEN	:= QDA1->B1_CUSTD
	 		DA1->DA1_ATIVO		:= "1"
		 	DA1->DA1_TPOPER	:= "4"
		 	DA1->DA1_MOEDA  := 1
		 	DA1->DA1_QTDLOT	:= &(Replicate("9",(TAMSX3("DA1_QTDLOT")[01]-TAMSX3("DA1_QTDLOT")[02]-1))+"."+Replicate("9",TAMSX3("DA1_QTDLOT")[02]))
	 		DA1->DA1_DATVIG	:= DA0->DA0_DATDE
		 //	DA1->DA1_REFGRD	:= QDA1->B1_YREF
		 	DA1->DA1_GRUPO		:= QDA1->B1_GRUPO
		   //	DA1->DA1_DESCGR	:= QDA1->B1_DESCGRU
		 //	DA1->DA1_YDESCA	:= QDA1->
		  //	DA1->DA1_BCI  		:= DA0->DA0_BCI
			DA1->(MsUnlock())
			If QDA1->B1_CUSTD <= 0.00
				AADD(aMsgPrd,{QDA1->B1_COD+" - "+AllTrim(QDA1->B1_DESC)})
			EndIf
			cContIt := 	StrZero((Val(cContIt)+1),(TamSX3("DA1_ITEM")[01]))
		Else
			Aviso("ATENCAO","A Tabela "+DA0->DA0_CODTAB+" Produto"+QDA1->B1_COD+" - "+QDA1->B1_DESC+" e Item "+cContIt+". Já foi cadastrado ATENCAO verificar o Preco Gravado.",{"Ok"})
		EndIf

		QDA1->(dbSkip())

	EndDo

EndIf

If Len(aMsgPrd) >= 1
	FPrdProb(aMsgPrd)
EndIf

Return(Nil) 



//-------------------------------------------------------------------
/*/{Protheus.doc} FSEXC
Rotina de Exclusao dos Itens da Tabela de Preco.

@protected
@author    
@since     
@obs       
@param     
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function FSEXC()

Local cCodTab := DA0->DA0_CODTAB
	
nExclui := AxDeleta("DA0",DA0->(Recno()),5)

If nExclui == 2
	cQuery2 := "UPDATE " + RetSqlName("DA1") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery2 += "WHERE D_E_L_E_T_ <> '*' AND DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1_CODTAB = '" + cCodTab + "'"
	TcSqlExec(cQuery2)
EndIf

Return(Nil)



//-------------------------------------------------------------------
/*/{Protheus.doc} FPrdProb
Tela dos Produtos com Valor Zerado para Correção.

@protected
@author    Ederson Colen
@since     01/04/2013
@obs       Referente atendimento Pontual
@param     
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function FPrdProb(aMsgPrd)

Local aButtons	:= {}
Local cLbx		:= ''
Local oDlgEsp
Local oLbxEsp
Local nOpcao    := 0

Local cMsg    := "Produtos"

DEFINE MSDIALOG oDlgEsp TITLE "Produtos com Preco de Venda Zerado" FROM 00,00 TO 350,769 PIXEL
	@ 005,01 LISTBOX oLbxEsp VAR cLbx FIELDS HEADER cMsg SIZE 383,142 OF oDlgEsp PIXEL
	oLbxEsp:SetArray(aMsgPrd)
	oLbxEsp:bLine	:= {|| {aMsgPrd[oLbxEsp:nAT,1]}}
ACTIVATE MSDIALOG oDlgEsp CENTERED ON INIT EnchoiceBar( oDlgEsp, {|| oDlgEsp:End()},{|| oDlgEsp:End() },,aButtons)

Return Nil