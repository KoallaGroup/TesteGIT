#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"                          
#INCLUDE "TBICONN.CH"  
#include 'topconn.ch'
#DEFINE DIRMASC "\MSXML\"
#DEFINE DIRXMLTMP "\MSXMLTMP\"
#DEFINE ITENSSC6 300
#xCommand CLOSETRANSACTION LOCKIN <aAlias,...>   => EndTran( \{ <aAlias> \}  ); End Sequence
Static __lHasWSSTART

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддд©╠╠
╠╠ЁFun┤└o    Ё MATA480  Ё Rev.  Ё Eduardo Riera         Ё Data Ё 26.08.2001Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддд╢╠╠
╠╠ЁDescri┤└o Ё Programa de atualizacao de Pedidos de Venda                 Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё Void MATA410(void)                                          Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё Generico                                                    Ё╠╠
╠╠цддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      Ё╠╠
╠╠цддддддддддддддбддддддддбддддддбддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё PROGRAMADOR  Ё DATA   Ё BOPS Ё  MOTIVO DA ALTERACAO                    Ё╠╠
╠╠цддддддддддддддеддддддддеддддддеддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё              Ё        Ё      Ё                                         Ё╠╠
╠╠юддддддддддддддаддддддддаддддддаддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Array contendo as Rotinas a executar do programa      Ё
//Ё ----------- Elementos contidos por dimensao ------------     Ё
//Ё 1. Nome a aparecer no cabecalho                              Ё
//Ё 2. Nome da Rotina associada                                  Ё
//Ё 3. Usado pela rotina                                         Ё
//Ё 4. Tipo de Transa┤└o a ser efetuada                          Ё
//Ё    1 - Pesquisa e Posiciona em um Banco de Dados             Ё
//Ё    2 - Simplesmente Mostra os Campos                         Ё
//Ё    3 - Inclui registros no Bancos de Dados                   Ё
//Ё    4 - Altera o registro corrente                            Ё
//Ё    5 - Remove o registro corrente do Banco de Dados          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

User Function LMG490(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,cRotina,cCodCli,cLoja,xRatCTBPC,xAdtPC)

	Local aCores := {}
	Local cRoda	 := ""
	Local bRoda	 := {|| .T.}
	Local xRet	 := Nil
	Local cGrupo := ""
	Local cVend  := ""
	Local lAdm	 := .F.
	Public nAutoAdt
	Public aRatCTBPC  := IIF(xRatCTBPC <> Nil,xRatCTBPC,{})
	Public aAdtPC     := IIF(xAdtPC <> Nil,xAdtPC,{})
	Public cStatus	 := "2"
	Private cBcis	 	:= "" 
	Private lOnUpdate	:= .T.	
	Private l410Auto	:= xAutoCab <> Nil .And. xAutoItens <> Nil
	Private aAutoCab	:= {}
	Private aAutoItens	:= {}
	Private aRotina		:= {{OemToAnsi(STR0001)	   ,"AxPesqui"			,0,1   },; //"Pesquisar"
							{OemToAnsi(STR0002)	   ,"A410Visual"		,0,2   },; //"Visual"
							{OemToAnsi("Envia WMS"),"U_EnvWMS"			,0,3,0 },; //"Envia SeparaГЦo"    
							{OemToAnsi("Parecer")  ,"U_FSBOXPAREC('V')"	,0,3,0 },; //"Parecer" -->Rodrigo Prates (DSM)
							{OemToAnsi(STR0032)	   ,"U_P410Leg"			,0,3,0 },;  //"Legenda"   
							{OemToAnsi("PosiГЦo Pedido") ,"U_BCDCONPED('1')"		,0,3,0 }}  //"PosiГЦo Pedido"							
	Private cCadastro := OemToAnsi(STR0007) //"Atualiza┤└o de Pedidos de Venda"
	If (cPaisLoc != "BRA")
		Private aArrayAE := {}
		Private lImpMsg	 := .T.                            
	EndIf                                                                               
	Default nOpcAuto	:= 3
	Default lSimulacao	:= .F.
	Private	aCores	:= {{"ALlTRIM(SC5->C5__STATUS)=='2'",'BR_VERMELHO_OCEAN'},; //Alcada
 						{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. EMPTY(C5_PARECER)",'BR_VERDE_OCEAN'   },; //Credito  
						{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. !EMPTY(C5_PARECER)",'BR_AZUL_CLARO'   },; //Credito  Rejeitado
						{"ALLTRIM(SC5->C5__STATUS)=='4'",'BR_VIOLETA'   },; //Envio Pendente
						{"ALLTRIM(SC5->C5__STATUS)=='5'",'BR_MARROM'   },; //Aguardando SeparaГЦo
						{"ALlTRIM(SC5->C5__STATUS)=='6'",'BR_LARANJA_OCEAN' },; //Separacao
						{"AlLTRIM(SC5->C5__STATUS)=='7'",'BR_CINZA_OCEAN'   },; //Conferencia
						{"AlLTRIM(SC5->C5__STATUS)=='8'",'BR_AMARELO_OCEAN' },; //Disponivel a Faturar						
						{"AlLTRIM(SC5->C5__STATUS)=='9'",'BR_PRETO_OCEAN'   },; //Faturado 
						{"AlLTRIM(SC5->C5__STATUS)=='10'",'BR_BRANCO_OCEAN'   },; //Em ExpediГЦo 
						{"AlLTRIM(SC5->C5__STATUS)=='11'",'BR_AZUL_OCEAN'    },;//Expedido
						{"AlLTRIM(SC5->C5__STATUS)=='13'",'BR_PINK'    },;//Devolvido
						{"AlLTRIM(SC5->C5__STATUS)=='12'",'BR_CANCEL'    },;//Cancelado
						{"ALLTRIM(SC5->C5__STATUS)=='14'",'BR_VERDE_ESCURO'},;//Antecipado Aguard. CrИdito 
						{"ALLTRIM(SC5->C5__STATUS)=='15'",'PMSTASK1'}}
	//зддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAjuste no pergunte MTA410				  Ё
	//юддддддддддддддддддддддддддддддддддддддддддды
	U_FSAJX1()
	//зддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAjuste no SX3                              Ё
	//юддддддддддддддддддддддддддддддддддддддддддды
	U_FSAJX3()
	//зддддддддддддддддддддддддддддддддддддддддддд©
	//ЁTratamento de Rotina Automatica            Ё
	//юддддддддддддддддддддддддддддддддддддддддддды
	If ValType(cRotina) == "C"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Faz tratamento para chamada por outra rotina             Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Empty(nScan := AScan(aRotina,{|x| Upper(Alltrim(x[2])) == Upper(Alltrim(cRotina))}))
			bRoda := &("{ || " + cRotina + "( 'SC5', SC5->( Recno() ), " + Str(nScan,2) + IIF(ValType(cCodCli) == "C",",nil,nil,nil,nil,nil,cCodCli,cLoja","") + ") } ")
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
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Define variaveis de parametrizacao de lancamentos    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё MV_PAR01 Sugere Quantidade Liberada ? Sim/Nao        Ё
			//Ё MV_PAR02 Preco Venda Com Substituicao ? Sim?Nao      Ё
			//Ё MV_PAR03 Utiliz.Op.Triangular     ?   Sim/Nao        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Ativa tecla F-10 para parametros                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			SetKey(VK_F12,{|| a410Ativa()})
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Ponto de Entrada para alterar cores do Browse do Cadastro    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If ExistBlock("MA410COR")
				aCores := ExecBlock("MA410COR",.F.,.F.,aCores)
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©          
			//Ё Endereca a funcao de BROWSE                          Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If ExistBlock("MT410BRW")
				ExecBlock("MT410BRW",.F.,.F.)
			EndIf

	//		cBCIs := U_FGrpBCI()        Alterado por Valdemir do Carmo em 05/11/15

			dbSelectArea ("SC5")
			dbSetOrder(1)
			dbGoTop()
			
            cVend := POSICIONE("SA3",7,XFILIAL("SA3")+RetCodUsr(),"A3_COD") 
			
			If Empty(cVend)
				_cFiltro	 	:= ' SC5->C5__STATUS = "14 " '// .AND. SC5->C5_VEND2 = "'+cVend+'"' // Alterado por Valdemir do Carmo em 08/02/16
			Else
				_cFiltro	 	:= ' SC5->C5__STATUS = "14 " .AND. SC5->C5_VEND2 = "'+cVend+'"' // Alterado por Valdemir do Carmo em 08/02/16
			EndIf
		   
				_aIndexSC5	:= {}         													
	
	   	If	! Empty(_cFiltro)
	   		bFiltraBrw := {|| FilBrowse("SC5",@_aIndexSC5,@_cFiltro)}
				Eval(bFiltraBrw)
	   	EndIf

			mBrowse(6,1,22,75,"SC5",,,,,,aCores)

			EndFilBrw("SC5",_aIndexSC5)

		Endif
	Endif
	
	dbSelectArea("SC5")
	dbSetOrder(1)

	dbClearFilter()
	SetKey(VK_F12,Nil)

Return(.T.)
                         
