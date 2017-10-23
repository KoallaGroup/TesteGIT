#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "MATA415.CH"                   

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
Programa: Importar Notas Fiscais de entrada de importaÁ„o
Desenvolvedor: Marcelo H. Sanches  //  Agosto/2014
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
/********************/
User Function teste2()
/********************/
Static nRec:={1,1}       
Local nMax 				:= {||LEN(aCols)}
Local aAlter       	:= {}
Local nSuperior    	:= C(076)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(004)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(173)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(285)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local cCampoOk     	:= "U_VALCPO1()"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "U_VALDEL1()"    // Funcao executada para validar a exclusao de uma linha do aCols        
Local aCores   := {{'ALLTRIM(C5_INTALT) == "" .AND. !(C5_INTALT == "S" .OR. C5_INTCANC == "S")', 'BR_VERDE'   },; //PEDIDOS ABERTOS
						 {'ALLTRIM(C5_NOTA) == "" .AND. (C5_INTALT == "S" .OR. C5_INTCANC == "S")', 'BR_LARANJA' },; //PEDIDOS EM ANALISE PELA COORDENADORA DE VDS
						 {'ALLTRIM(C5_NOTA) == "" .AND. C5_INTALT == "A"'         					  , 'BR_AZUL'    },; //ALTERA«√O AUTORIZADA 
						 {'ALLTRIM(C5_NOTA) == "" .AND. C5_INTALT == "N"'                         , 'BR_PRETO'   },;  //ALTERA«√O NEGADA
						 {'ALLTRIM(C5_ATENDEN) <> ALLTRIM(C5_ATENATU) ', 'BR_AMARELO'   },; //ENCAMINHADO PARA OUTRO COORDENADOR
						 {'ALLTRIM(C5_ATENDEN) <> ALLTRIM(C5_ATENATU) ', 'BR_BRANCO'   } } //RECEBIDO DE OUTRO COORDENADOR



Private Encaminha    := .f.
Private cAtenden		:= GetAtend()  
Private SacSar			:=(ASCAN( PSWRET()[1][10], {|z| z="000003"} )<>0) 
//ErrorBlock({|e|U_VerErro(e)})
Private nOpc        	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Private oDlgIMPNF
Private VISUAL 		:= .F.                        
Private INCLUI 		:= .F.                        
Private ALTERA 		:= .F.                        
Private DELETA 		:= .F.                        
//Private aHeader := {{},{},{},{}}
Private aCols 			:= {}
Private aCampos 		:= {{},{},{},{}}
Private nLastRec		:={0,0,0,0}
Private aFile			:={"","","",""}
Private cExpr1
Private cExpr2
Private cExpr3
Private cExpr4
Private _cAteN			:=""
Private _cAte			:=cAtenden          
Private 	cFilNRepr	:=Space(40)
Private	cFilCli		:=Space(6)
Private	cFilNCli		:=Space(40)    

Private	dApartir		:=dDataBase 
Private	cFilRepr		:=Space(6)

nSuperior    	:= C(016) // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
nEsquerda    	:= C(004) // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
nInferior    	:= C(200) // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
nDireita     	:= C(380) // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
cMarca:=Getmark()               

	DEFINE MSDIALOG oDlgIMPNF TITLE "INTEN«’ES do(a) Coordenador(a):"+_cAteN FROM C(178),C(181) TO C(665),C(1000) PIXEL
	// Cria as Folders do Sistema
		oFodlg := TFolder():New(C(015),C(005),{"Processos", "Parametros"},{},oDlgIMPNF,,,,.T.,.F.,C(400),C(230),)
	
	
	//BROWSE1 - Processos
		oBrows1:=TcBrowse():New( nSuperior+10, nEsquerda+10, nDireita-10, nInferior-50, , , , oFodlg:aDialogs[1] ,"FLAG",,,,,,oFodlg:aDialogs[1]:oFont,,,,, .F.,"WK1", .T.,, .F., , ,.f. )
		OBrows1:BlDblClick:={||Wk1->(MarcaReg(1))}
		
	
		oEnable  := LoadBitmap( GetResources(), "LBTIK" ) //"LBTIK"
		oDisable := LoadBitmap( GetResources(), "LBNO" ) //"DISABLE"
		oBrows1:AddColumn( TCColumn():New( "",{ || U_ChkCorBO(1) },,,, "LEFT", 10, .T., .F.,,,, .T., ))
		oBrows1:AddColumn( TCColumn():New( "",{ || IF(&(cExpr1),oEnable,oDisable)},,,, "LEFT", 10, .T., .F.,,,, .T., ))
		For nX:=1 To Len( aCampos[1] )
			oCol:=TCColumn():New( aCampos[1][nX][2],FieldWBlock(aCampos[1][nX][1], Select("WK1")),,,,,,.F.,.F.,,,,.F.,)
			oCol:cPicture:=aCampos[1][nX][3]
			oBrows1:ADDCOLUMN(oCol)
	
		Next
	
		oBrows1:nFreeze:=2
	   @ c(205), c(050) Button "&Legenda" 		Size c(37),c(12) Action(Leg_Int(1))			Pixel 	Of oFodlg:aDialogs[1]
	   @ c(205), c(100) Button "&Analisar" 	Size c(37),c(12) Action(Eval({||Posicione( "SC5", 1, xFilial( "SC5" )+Wk1->C5_Num, "" ), Detalhar()})) Pixel Of oFodlg:aDialogs[1]
	   @ c(205), c(150) Button "&APROVAR" 		Size c(37),c(12) Action(Aprovar(1)) 		Pixel 	Of oFodlg:aDialogs[1]
	   @ c(205), c(200) Button "&REPROVAR" 	Size c(37),c(12) Action(Reprovar(1)) 	   Pixel 	Of oFodlg:aDialogs[1]
	   @ c(205), c(250) Button "&ENCAMINHAR" 	Size c(37),c(12) Action(Encaminhar(1)) 	Pixel 	Of oFodlg:aDialogs[1]
	
	
	
	//BROWSE2 - Parametros (dados complementares de importaÁ„o)
		oBrows2:=TcBrowse():New( nSuperior+10, nEsquerda+10, nDireita-10, nInferior-50, , , , oFodlg:aDialogs[2] ,"Z0_FLAG",,,,,,oFodlg:aDialogs[2]:oFont,,,,, .F.,"WK2", .T.,, .F., , ,.f. )
		OBrows2:BlDblClick:={||Wk2->(MarcaReg(2))}
		oBrows2:AddColumn( TCColumn():New( "",{ || U_ChkCorBO(2) },,,, "LEFT", 10, .T., .F.,,,, .T., ))
		oBrows2:AddColumn( TCColumn():New( "",{ || IF(&(cExpr2),oEnable,oDisable)},,,, "LEFT", 10, .T., .F.,,,, .T., ))
		For nX:=1 To Len( aCampos[2] )
			oCol:=TCColumn():New( aCampos[2][nX][2],FieldWBlock(aCampos[2][nX][1], Select("WK2")),,,,,,.F.,.F.,,,,.F.,)
			oCol:cPicture:=aCampos[2][nX][3]
			oCol:bClrFore:={||U_ChCorLn(1)}
			oCol:bClrBack:={||u_ChCorLn(2)}
			oBrows2:ADDCOLUMN(oCol)
	//		oBrows2:aColumns[Len(oBrows2:aColumns)]:bClrFore:={||U_ChCorLn(1)}
	//		oBrows2:aColumns[Len(oBrows2:aColumns)]:bClrBack:={||u_ChCorLn(2)}
	
		Next
	
		Wk2->(DbGoTop())
		oBrows2:nFreeze:=2
		oBrows2:BSKIP:={ | N | oBrows2:NCLRBACKFOCUS:=U_CHCORLN(oBrows2),WK2->( _DBSKIPPER( N ) ) }
	
	   @ c(205), c(050) Button "&Legenda" 		Size c(37),c(12) Action(u_Leg_aLT())			Pixel 	Of oFodlg:aDialogs[2]
	   @ c(205), c(100) Button "&Analisar" 	Size c(37),c(12) Action(Eval({||Posicione( "SC5", 1, xFilial( "SC5" )+Wk2->C5_Num, "" ), Detalhar()})) Pixel Of oFodlg:aDialogs[2]
// ALTERADO AQUI, PORQUE ESTAVA TRAZENDO OS DADOS DO PEDIDO ANTIGO(SC5) E NAO OS DADOS DO PEDIDO ALTERADO (SZ0)
//      @ c(205), c(100) Button "&Analisar" 	Size c(37),c(12) Action(Eval({||Posicione( "SZ0", 1, xFilial( "SZ0" )+Wk2->Z0_Num, "" ), Detalhar()})) Pixel Of oFodlg:aDialogs[2]
	   @ c(205), c(150) Button "&APROVAR" 		Size c(37),c(12) Action(Aprovar(2)) 		Pixel 	Of oFodlg:aDialogs[2]
	   @ c(205), c(200) Button "&REPROVAR" 	Size c(37),c(12) Action(Reprovar(2))   	Pixel 	Of oFodlg:aDialogs[2]
	   @ c(205), c(250) Button "&ENCAMINHAR" 	Size c(37),c(12) Action(Encaminhar(2)) 	Pixel 	Of oFodlg:aDialogs[2]
	
	
	ACTIVATE MSDIALOG oDlgIMPNF CENTERED  ON INIT EnchoiceBar(oDlgIMPNF,{|| nOpca := 1, oDlgIMPNF:End()}, {|| nOpca := 2, oDlgIMPNF:End()},,{{"S4WB011N",{||HistEnc('P') },"Historico de Ocorrencias" }})
	
else
   RETURN

ENDIF   	
	
Return(.T.)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa   ≥   C()   ≥ Autores ≥ Norbert/Ernani/Mansano ≥ Data ≥10/05/2005≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao  ≥ Funcao responsavel por manter o Layout independente da       ≥±±
±±≥           ≥ resolucao horizontal do Monitor do Usuario.                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø                                               
	//≥Tratamento para tema "Flat"≥                                               
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            

		EndIf                                                                      

	EndIf                                                                         

Return Int(nTam)                                                                


/***************************/
Static Function MarcaReg(_P1)
/***************************/
Local nRecWk2
If _P1 = 1
	RecLock( "WK1", .f. )
		Wk1->Flag:=If( Wk1->Flag=cMarca, "  ", cMarca )

	MsUnLock()

ElseIf _P1 = 2
	nRecWk2:=Wk2->(RecNo())
	cPed:=Wk2->C5_Num  
	
	While !Wk2->(Bof()) .And. Wk2->C5_Num = cPed
		RecLock( "WK2", .f. )
			Wk2->Z0_Flag:=If( Wk2->Z0_Flag=cMarca, "  ", cMarca )

		MsUnLock()

		Wk2->(DbSkip(-1))

	Enddo
		
	Wk2->(DbGoTo( nRecWk2 ))
	Wk2->(DbSkip())
	While !Wk2->(Eof()) .And. Wk2->C5_Num = cPed
		RecLock( "WK2", .f. )
			Wk2->Z0_Flag:=If( Wk2->Z0_Flag=cMarca, "  ", cMarca )

		MsUnLock()

		Wk2->(DbSkip())

	EndDo

	Wk2->(DbGoTo( nRecWk2 ))
	oBrows2:ReFresh()

ElseIf _P1 = 3
	RecLock( "WK3", .f. )
		Wk3->Flag:=If( Wk3->Flag=cMarca, "  ", cMarca )

	MsUnLock()

ElseIf _P1 = 4
	RecLock( "WK4", .f. )
		Wk4->Flag:=If( Wk4->Flag=cMarca, "  ", cMarca )

	MsUnLock()

EndIf

Retur Nil


/************************/
Static Function Detalhar()
/************************/
Local aCabPV  := {}
Local aItemPV := {}
Local aItem   := {}
Local _nOpc   := 2  
Local aPedExp := {}, cQuery := "", aPedDraw := {}, aPedDefer := {},aNedDefer := {}
  
PRIVATE aRotina := { { OemToAnsi(STR0001),"AxPesqui"  ,0,1},;		//"Pesquisar"
							{ OemToAnsi(STR0002),"A410Visual",0,2},;		//"Visual"
							{ OemToAnsi(STR0003),"A410Inclui",0,3},;		//"Incluir"
							{ OemToAnsi(STR0004),"A410Altera",0,4,20},;  //"Alterar"
							{ OemToAnsi(STR0005),"A410Deleta",0,5,21},;	//"Excluir"
							{ OemToAnsi(STR0006),"A410Barra" ,0,3,0},;	//"Cod.barra"
							{ OemToAnsi(STR0032),"A410Legend" ,0,3,0} }  //"Legenda"


Private lMshelpAuto := .t.
Private lMsErroAuto := .f.
//Sc5->(DbSeek( xFilial( "SC5" )+Trb->C5_Num ))
m->C5_Num:=Sc5->C5_Num
A410Visual("SC5",Sc5->(RecNo()),2)
Return Nil

/*
Sc5->(DbSetFilter({||Sc5->C5_Num=m->C5_Num},"Sc5->C5_Num=M->C5_Num"))
MATA410()
Sc5->(DbClearFilter())
RETURN Nil
*/
/*
 Cabecalho
*/
DbSelectArea("SX3")
DbSeek( "SC5" )
aCabPV:={}
While !Sx3->(Eof()) .And. Sx3->X3_Arquivo="SC5"
	Aadd( aCabPV, { Sx3->X3_Campo, SC5->(FieldGet(Val(Sx3->X3_Ordem))), Nil} ) 
	Sx3->(DbSkip())

EndDo

/*
 Items
*/
DbSelectarea("SC6")
Dbseek(xFilial("SC6")+M->C5_Num)
aItemPV:={}
nTotPed:=0
While  !Sc6->(Eof()) .And. SC6->C6_NUM == M->C5_Num
	DbSelectArea("SX3")
	DbSeek( "SC6" )
	While !Sx3->(Eof()) .And. Sx3->X3_Arquivo="SC6"
		Aadd( aItemPV, { Sx3->X3_Campo, SC6->(FieldGet(Val(Sx3->X3_Ordem))), Nil} ) 
		Sx3->(DbSkip())

	EndDo

	nTotPed	+= Sc6->C6_VALOR

	aadd(aitem,aitempv)
	Sc6->(DbSkip())

Enddo


//MATA410()
MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,2)   //Se houver mais de um item, passar no aItemPv entre virgulas; ex: {aItemPV,aItemPV1...}

Return Nil

/***************************/
Static Function BO_IntCanc()
/***************************/
// INTEN«√O DE CANCELAMENTO
//C5_INTCANC == "S"  

cUser := GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, " " )
cExpr1:="Wk1->Flag==cMarca"
If Select( "Wk1" )>0
	Wk1->(DbCloseArea())
	FErase( aFile[1] )

EndIf      

//AQUI SELECIONA OS CAMPOS 
aCampos[1]:={}
//Aadd(aCampos[ 1 ],{ "FLAG",			"FLAG",				"!!" })
Aadd(aCampos[ 1 ],{ "C5_EMISSAO",	"Data Emissao",	"@d" })
Aadd(aCampos[ 1 ],{ "C5_NUM",			"Num.Pedido",		"@!" })
Aadd(aCampos[ 1 ],{ "C5_CLIENTE",	"Cod.Cliente",		"@!" })
Aadd(aCampos[ 1 ],{ "C5_LOJACLI",	"Loja",				"@!" })
Aadd(aCampos[ 1 ],{ "C5_NGUERRA",	"Nome Guerra",		"@!" })
Aadd(aCampos[ 1 ],{ "C5_TIPOCLI",	"Tipo Cliente",	"@!" })
Aadd(aCampos[ 1 ],{ "C5_TP",			"Tipo Pedido",		"@!" })
Aadd(aCampos[ 1 ],{ "TOTPED",			"Total Pedido",	"@E 99,999,999.99" })
Aadd(aCampos[ 1 ],{ "C5_PRODUTO",	"Artigo",			"@d" })
Aadd(aCampos[ 1 ],{ "C5_ENTREGA",	"Dt. Entrega",		"@d" })
Aadd(aCampos[ 1 ],{ "C5_CONDPAG",	"Cond.Pgto",		"@!" })
Aadd(aCampos[ 1 ],{ "C5_CONDNOM",	"DescriÁ„o",		"@!" })
Aadd(aCampos[ 1 ],{ "C5_ZZDESC",		"LocalizaÁ„o",		"@!" })
Aadd(aCampos[ 1 ],{ "C5_OBSPED",		"ObservaÁıes",		"@!" })
cQryIC:= "SELECT "
cQryIC+= "	'  ' FLAG, "
cQryIC+= "	C5_EMISSAO, "
cQryIC+= "	C5_NUM, "
cQryIC+= "	C5_CLIENTE,"
cQryIC+= "	C5_LOJACLI,"
cQryIC+= "	C5_NGUERRA,"
cQryIC+= "	C5_TIPOCLI,"
cQryIC+= "	C5_NOTA,"
cQryIC+= "	C5_INTCANC,"
cQryIC+= "	C5_TP," 
cQryIC+= "	(SELECT SUM(C6_QTDVEN*C6_PRCVEN) 'TOTAL' FROM "+RetSqlName( "SC6" )+" C6 WHERE C6.D_E_L_E_T_=' ' AND C6.C6_FILIAL='"+xFilial("SC6")+"' AND C6.C6_NUM=C5.C5_NUM GROUP BY C6_NUM ) 'TOTPED', "
cQryIC+= "	C5_PRODUTO,"
cQryIC+= "	C5_ENTREGA,"
cQryIC+= "	C5_CONDPAG,"
cQryIC+= "	C5_CONDNOM,"
cQryIC+= "	C5_ZZDESC,"
cQryIC+= "	C5_ATENDEN,"
cQryIC+= "	C5_ATENATU,"
cQryIC+= "	C5_OBSPED," 
cQryIC+= "  C5_VEND1 "
cQryIC+= " "
cQryIC+= "FROM "
cQryIC+= "	"+RetSqlName( "SC5" )+" C5 "
cQryIC+= " "
cQryIC+= "WHERE "
cQryIC+= "	C5.D_E_L_E_T_=' ' "
cQryIC+= "	AND C5.C5_FILIAL='"+xFilial("SC5")+"' "
cQryIC+= "	AND C5.C5_INTCANC='S' "        
cQryIC+= "  AND (C5.C5_ATENATU='" + _cAte + "') "
//cQryIC+= "	AND ((C5.C5_ATENATU='"+_cAte+"' AND C5.C5_ATENDEN <> C5.C5_ATENATU) "
//cQryIC+= "	OR (C5.C5_ATENATU='' AND C5.C5_ATENDEN = '" +_cAte+ "' )) "

/*if lchkencdo
	cQryIC+= " AND C5.C5_ATENDEN = '" +_cAte +"' AND C5.C5_ATENDEN <> C5.C5_ATENATU " 
ENDIF

if DAPARTIR <> DDATABASE
	cQryIC+= " AND C5.C5_EMISSAO >='" +DTOS(DAPARTIR)+"' " 
ENDIF

if !EMPTY(CFILREPR)  
	cQryIC+= " AND C5.C5_VEND1 ='" + CFILREPR+"' " 
ENDIF

if !EMPTY(CFILcLI)  
	cQryIC+= " AND C5.C5_CLIENTE ='" + CFILCLI +"' " 
ENDIF
  */ 
aFile[1]:=CriaTrab(,.f.)
DbUseArea( .t., "TOPCONN", TcGenQry(,, cQryIC), "Wk1" )
TcSetField( "WK1", "C5_EMISSAO", "D", 8, 0 )
TcSetField( "WK1", "TOTPED", "N", 12, 2 )
TcSetField( "WK1", "C5_ENTREGA", "D", 8, 0 )
DbSelectArea( "Wk1" )
Copy To (aFile[1])
Wk1->(DbCloseArea())
DbUseArea( .t., "DBFCDX", aFile[1], "Wk1" )
DbSelectArea( "Wk1" )
DbGoTop()

Return Nil

/*************************/
Static Function BO_IntAlt()
/*************************/
cExpr2:="WK2->Z0_FLAG==cMarca"
// INTEN«√O DE ALTERA«√O
/*
// INTEN«√O DE ALTERA«√O
SZ0 // TODOS OS REGISTROS(ATE SER CRIADO UM FLAG)
*/

// Carrega aHead[ 2 ]
If Select( "Wk2" )>0
	Wk2->(DbCloseArea())
	FErase( aFile[2] )

EndIf


aCampos[2]:={}

Aadd(aCampos[ 2 ],{ "Z0_DTALT",		"Data AlteraÁ„o",	"@d" })
Aadd(aCampos[ 2 ],{ "Z0_NUM",			"Num.Pedido",		"!!!!!!" })
Aadd(aCampos[ 2 ],{ "Z0_USUARIO",	"Usuario",			"@!" })
Aadd(aCampos[ 2 ],{ "Z0_ITEM",		"Item",				"9999" })
Aadd(aCampos[ 2 ],{ "Z0_QTDVEN",		"Qtd. Vendida",	"@E 99,999,999" })
Aadd(aCampos[ 2 ],{ "Z0_QTDATU",		"Qtd. Para",		"@E 99,999,999" })
Aadd(aCampos[ 2 ],{ "Z0_PRCVEN",		"Preco Venda",		"@E 99,999,999.99" })
Aadd(aCampos[ 2 ],{ "Z0_PRCATU",		"PreÁo Para",		"@E 99,999,999.99" })
Aadd(aCampos[ 2 ],{ "Z0_ENTREGA",	"Dt. Entrega",		"@D" })
Aadd(aCampos[ 2 ],{ "Z0_ENTATU",		"Entrega Para",	"@D" })
Aadd(aCampos[ 2 ],{ "Z0_CONDPAG",	"Cond.Pagto.",		"!!!" })
Aadd(aCampos[ 2 ],{ "Z0_CONATU",		"Cond.Pg. Para",	"!!!" })
Aadd(aCampos[ 2 ],{ "Z0_TRANSP",		"Transportadora",	"!!!" })
Aadd(aCampos[ 2 ],{ "Z0_TRAATU",		"Transport.Para",	"!!!" })
Aadd(aCampos[ 2 ],{ "Z0_NOVITEM",	"Item Novo ?",		"!" })
Aadd(aCampos[ 2 ],{ "Z0_ATENATU",	"Aten Atual?",		"@!"}) 

nC:=0
cField:=""
aEval( aCampos[ 2 ], {|z| cField+=if((++nC)>1, ", ", "")+z[ 1 ] } )
  
cQrAl:="SELECT "
//cQrAl+="   * "
cQrAl+=" "+cField
cQrAl+=", Z0_FLAG "
cQrAl+=", Z0_FRT "
cQrAl+=", Z0_FRTATU "
cQrAl+=", Z0_STATUS "
cQrAl+=", Z0_HORA "
cQrAl+=", Z0_ATENATU "
cQrAl+=", Z0_ATENDEN "
cQrAl+=", C5_NOTA "
cQrAl+=", C5_INTCANC "
cQrAl+=", C5_INTALT "
//cQrAl+=", ROW_NUMBER() OVER(ORDER BY Z0_NUM,Z0_ITEM) AS 'R_E_C_N_O_'  "
cQrAl+="FROM "
cQrAl+="   "+RetSqlName("SZ0")+" Z0 INNER JOIN "
cQrAl+="   "+RetSqlName("SC5")+" C5 ON C5.C5_FILIAL='"+xFilial("SC5")+"' AND C5.C5_NUM=Z0.Z0_NUM AND C5.D_E_L_E_T_=' ' "
cQrAl+="WHERE "
cQrAl+="   Z0.D_E_L_E_T_=' ' "
cQrAl+="   AND Z0.Z0_FILIAL='"+xFilial( "SZ0" )+"' "
cQrAl+="   AND C5.C5_INTALT='S' "
cQrAl+="   AND Z0.Z0_DTALT>'20070601' "
cQrAl+="   AND Z0.Z0_STATUS=' ' "
//cQrAl+="   AND Z0.Z0_ALTWEB= 'S' "
cQrAl+="   AND C5.C5_NOTA=' ' "
cQrAl+="	  AND Z0.Z0_ATENATU='"+_cAte+"'  "

IF Encaminha
	cQrAl+="	  OR (Z0.Z0_ATENATU <> '" + _cAte + "' AND Z0.Z0_ATENDEN = '" +_cAte+ "' ) "   
ENDIF
	
cQrAl+="ORDER BY "
cQrAl+="   Z0_NUM "
cQrAl+="   ,Z0_ITEM "
cQrAl+="   ,Z0_DTALT "
cQrAl+="   ,Z0_HORA "
 
/*
cQrAl:="SELECT "
cQrAl+=" "+cField
//cQrAl+=" , C5_FLAG "
cQrAl+=" C5_FLAG,C5_NUM,C5_CLIENTE,C5_NGUERRA,C5_PRODUTO,C5_ENTREGA ,C5_VEND1,C5_VENDN01,C5_ENTREGA,C5_DTINTE,C5_ZZCOD,C5_ZZDESC "
//cQrAl+=" * " 
cQrAl+="  FROM  SC5010 C5 " 
cQrAl+=" WHERE "
cQrAl+="   C5_NUM IN ( SELECT Z0_NUM FROM SZ0010 Z0 WHERE Z0_DTALT>'20070601' AND D_E_L_E_T_=' ' AND Z0_STATUS = ' ') "
cQrAl+="   AND C5.C5_INTALT='S' "
cQrAl+="   AND C5.C5_NOTA=' ' "
cQrAl+="	  AND (C5.C5_ATENATU='" + _cAte + "') " // AND C5.C5_ATENDEN <> C5.C5_ATENATU) "
//cQrAl+="	  OR (C5.C5_ATENDEN = '" + _cAte + "' ) )"
cQrAl+="   ORDER BY "
cQrAl+="   C5.C5_NUM "


aFile[2]:=CriaTrab(,.f.)
DbUseArea( .t., "TOPCONN", TcGenQry(,, cQrAl), "Wk2", .f., .f. )
//DbUseArea( .t., "TOPCONN", TcGenQry(,, cQrAl), "Wk2" )

TcSetField( "WK2", "C5_NUM"			, "C",06, 0 )
TcSetField( "WK2", "C5_EMISSAO"		, "D",08, 0 )
TcSetField( "WK2", "C5_CLIENTE"		, "C",06, 0 )
TcSetField( "WK2", "C5_OS"				, "C",06, 0 )
TcSetField( "WK2", "C5_NOTA"			, "C",06, 0 )
TcSetField( "WK2", "C5_CLIENTE"		, "C",06, 0 )
TcSetField( "WK2", "C5_VEND1"			, "C",06, 0 )
TcSetField( "WK2", "C5_TP"				, "C",20, 0 )
TcSetField( "WK2", "C5_NGUERRA"		, "C",30, 0 )
TcSetField( "WK2", "C5_CLIENTE"		, "C",06, 0 )
TcSetField( "WK2", "C5_ZZCOD"			, "C",03, 0 )
TcSetField( "WK2", "C5_OBSHENR"		, "C",60, 0 )
TcSetField( "WK2", "C5_CODPROD"		, "C",12, 0 )
TcSetField( "WK2", "C5_ENTREGA"		, "D",08, 0 )
TcSetField( "WK2", "C5_EXPENG"		, "C",01, 0 )
TcSetField( "WK2", "C5_ATENATU"		, "C",02, 0 )
TcSetField( "WK2", "C5_VEND1"			, "C",06, 0 )
TcSetField( "WK2", "C5_NUM"			, "C",06, 0 )
 
 
*/
aFile[2]:=CriaTrab(,.f.)
DbUseArea( .t., "TOPCONN", TcGenQry(,, cQrAl), "Wk2", .f., .f. )
TcSetField( "WK2", "Z0_DTALT", "D", 8, 0 )
TcSetField( "WK2", "Z0_ENTREGA", "D", 8, 0 )
TcSetField( "WK2", "Z0_ENTATU", "D", 8, 0 )
TcSetField( "WK2", "Z0_QTDVEN", "N", 8, 0 )
TcSetField( "WK2", "Z0_QTDATU", "N", 8, 0 )
TcSetField( "WK2", "Z0_PRCVEN", "N", 12, 2 )
TcSetField( "WK2", "Z0_PRCATU", "N", 12, 2 )


DbSelectArea( "Wk2" )

Copy To (aFile[2]) 
Wk2->(DbCloseArea())
DbUseArea( .t., "DBFCDX", aFile[2], "Wk2" )
DbSelectArea( "Wk2" )
DbGoTop()

Return Nil

/*************************/
Static Function BO_IntDev()
/*************************/
/*
  EXITEM 2 STATUS (Z6_STATUS=	02-DEV.CONFIRMADA ATENDENTE ; // UTILIZAR ESSE STATUS PARA GRAVAR STATUS DO Z6, APOS CONFIRMA«√O DA ATENDENTE.
  						Z6_DESCSTA=DEV.CONFIRMADA ATENDENTE.
*/

cExpr3:="WK3->Flag==cMarca"
// INTEN«√O DE DEVOLU«√O
//SZ6 //(CAPA)
//SZ8 //(ITEM)
If Select( "Wk3" )>0
	Wk3->(DbCloseArea())
	FErase( aFile[3] )

EndIf

aCampos[3]:={}
aadd(aCampos[3],{"Z6_NUMERO",		"Num.DevoluÁ„o",		"@!"              	})
aadd(aCampos[3],{"Z6_NPEDCLI",	"Num.Pedido",			"@!"              	})
aadd(aCampos[3],{"Z6_DATA",		"Data Intens.",		"@d"              	})
aadd(aCampos[3],{"Z6_TIPO",		"Tipo Ped.",			"@!"              	})
aadd(aCampos[3],{"Z6_NF",			"Nota Fiscal",			"@!"						})
aadd(aCampos[3],{"Z6_SERIE",		"Serie",					"@!"				    	})
aadd(aCampos[3],{"Z6_PREFIXO",	"Prefixo",				"@!"					 	})
aadd(aCampos[3],{"Z6_EMISSAO",	"Emissao",				"@D"					 	})
aadd(aCampos[3],{"Z6_NOMCLI",		"Nome Cliente",		"@!"						})
aadd(aCampos[3],{"Z6_ARTIGO",		"Artigo",				"@!"						})
aadd(aCampos[3],{"Z6_STATUS",		"Status",				"@!"						})
aadd(aCampos[3],{"Z6_DESCSTA",	"DescriÁ„o",			"@!"						})
aadd(aCampos[3],{"Z6_NOMEREP",	"Nome Representante","@!"						})
aadd(aCampos[3],{"Z6_TRANSP",		"Transportadora",		"@!"						})
aadd(aCampos[3],{"Z6_TPMOTIV",	"Tipo",					"@!"						})
aadd(aCampos[3],{"Z6_MOTIDEV",	"Motivo DevoluÁ„o",	"@!"						})
aadd(aCampos[3],{"Z6_HISTORI",	"Historico",			"@!"              	})
aadd(aCampos[3],{"TOTVLDEV",		"Total Pedido",		"@e 99,999,999.99"	})
aadd(aCampos[3],{"Z6_CODATEN",	"Atendente",			"@!"						})
aadd(aCampos[3],{"Z6_NOMATEN",	"Nome Atendente",		"@!"						})

cQryID:= "SELECT "
cQryID+= "	'  ' FLAG, "
//cQryID+= "	C5_ATENDEN, "
//cQryID+= "	C5_ATENATU, "
cQryID+= "	Z6_NUMERO, "
cQryID+= "	Z6_NPEDCLI, "
cQryID+= "	Z6_DATA, "
cQryID+= "	Z6_TIPO, "
cQryID+= "	Z6_NF, "
cQryID+= "	Z6_SERIE, "
cQryID+= "	Z6_PREFIXO, "
cQryID+= "	Z6_EMISSAO, "
cQryID+= "	Z6_NOMCLI, "
cQryID+= "	Z6_ARTIGO, "
cQryID+= "	Z6_STATUS, "
cQryID+= "	Z6_DESCSTA, "
cQryID+= "	Z6_NOMEREP, "
cQryID+= "	Z6_TRANSP, "
cQryID+= "	Z6_MOTIDEV, "
cQryID+= "	Z6_TPMOTIV, "
cQryID+= "	Z6_HISTORI, "
cQryID+= "	(SELECT SUM(Z8_QTDDEV*Z8_VLRUNIT) FROM SZ8010 Z8 WHERE Z8.D_E_L_E_T_=' ' AND Z8.Z8_FILIAL='  ' AND Z8.Z8_NUMERO=Z6.Z6_NUMERO GROUP BY Z8_NUMERO) 'TOTVLDEV', "
cQryID+= "	Z6_CODATEN, "
cQryID+= "	Z6_NOMATEN, "
cQryID+= "	Z6_ATENATU  "
cQryID+= " "
cQryID+= "FROM "
cQryID+= "	"+RetSqlName("SZ6")+" Z6 "
//cQryID+="   "+RetSqlName("SC5")+" C5 ON C5.C5_FILIAL='"+xFilial("SC5")+"' AND C5.C5_NUM=SUBSTRING(Z6.Z6_NPEDCLI,1,6) AND C5.D_E_L_E_T_=' ' "
cQryID+= " "
cQryID+= "WHERE "
cQryID+= "	D_E_L_E_T_=' ' "
cQryID+= "	AND Z6_FILIAL = '  '  "
cQryID+= "	AND Z6_DATA>'20070601'  "
cQryID+= "	AND Z6_STATUS='01'  "

// AQUI COLOCAR PRA PEGAR APENAS O ATENATU.
cQryID+="   AND (Z6_ATENATU='"+_cAte+"' OR Z6_CODATEN='"+_cAte+"') "
cQryID+= "	ORDER BY Z6_NUMERO "

DbUseArea( .t., "TOPCONN", TcGenQry(,, cQryID), "Wk3", .F., .F.)
TcSetField( "WK3", "Z6_DATA", "D", 8, 0 )
TcSetField( "WK3", "Z6_EMISSAO", "D", 8, 0 )
TcSetField( "WK3", "TOTVLDEV", "N", 10, 2 )
aFile[3]:=CriaTrab(,.f.)
DbSelectArea( "Wk3" )
Copy To (aFile[3])
Wk3->(DbCloseArea())
DbUseArea( .t., "DBFCDX", aFile[3], "Wk3" )

Return Nil




/*************************/
Static Function BO_IntDup()
/*************************/
cExpr4:="WK4->Flag==cMarca"
If Select( "Wk4" )>0
	Wk4->(DbCloseArea())
	FErase( aFile[4] )

EndIf

aCampos[4]:={}
aadd(aCampos[4],{"ZZT_PREF",		"Prefixo",			"!!!!!!!"	})
aadd(aCampos[4],{"ZZT_NUM",		"Documento",		"!!!!!!"		})
aadd(aCampos[4],{"ZZT_PARC",		"Parcela",			"!!!"			})
aadd(aCampos[4],{"ZZT_CLIENT",	"Cliente",			"@!"			})
aadd(aCampos[4],{"ZZT_VLORIG",	"Valor Orig",		"@!"			})
aadd(aCampos[4],{"ZZT_VLATU",		"Valor Atual",		"@!"			})
aadd(aCampos[4],{"ZZT_DTORI",		"Venc. Orig",		"@!"			})
aadd(aCampos[4],{"ZZT_DTATU",		"Venc. Atual",		"@D"			})
aadd(aCampos[4],{"ZZT_HORA",		"Nome Cliente",	"@!"			})
aadd(aCampos[4],{"ZZT_DTSOL",		"Artigo",			"@!"			})


cQryIF:= "SELECT "+chr(13)+chr(10)
cQryIF+= "	'  ' FLAG, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_PREF, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_NUM, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_PARC, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_CLIENT, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_VLORIG, "+chr(13)+chr(10)
cQryIF+= "	E1.E1_VALOR, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_VLATU, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_DTORI, "+chr(13)+chr(10)
cQryIF+= "	E1.E1_VENCREA, "+chr(13)+chr(10)
cQryIF+= "	E1.E1_PEDIDO, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_DTATU, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_STATUS, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_HORA, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_DTSOL, "+chr(13)+chr(10)
cQryIF+= "	C5.C5_ATENDEN, "+chr(13)+chr(10)
cQryIF+= "	C5.C5_ATENATU "+chr(13)+chr(10)
cQryIF+= " "+chr(13)+chr(10)
cQryIF+= "FROM  "+chr(13)+chr(10)
cQryIF+= "	"+RetSqlName("ZZT")+" ZZT INNER JOIN "+chr(13)+chr(10)
cQryIF+= "	"+RetSqlName("SE1")+" E1 ON E1.E1_FILIAL='"+xFilial("SE1")+"' AND E1.E1_PREFIXO=ZZT.ZZT_PREF AND E1.E1_NUM=ZZT.ZZT_NUM AND E1.E1_PARCELA=ZZT.ZZT_PARC AND E1.E1_CLIENTE=ZZT.ZZT_CLIENT AND E1.D_E_L_E_T_=' ' INNER JOIN "+chr(13)+chr(10)
cQryIF+= "	"+RetSqlName("SC5")+" C5 ON C5.C5_FILIAL='"+xFilial("SE1")+"' AND C5.C5_NUM=E1.E1_PEDIDO AND C5.D_E_L_E_T_=' '  "+chr(13)+chr(10)
cQryIF+= " "+chr(13)+chr(10)
cQryIF+= "WHERE  "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_FILIAL='"+xFilial("SE1")+"' "
cQryIF+= "	AND ZZT.ZZT_STATUS=' ' "
cQryIF+= "	AND ZZT.D_E_L_E_T_=' '  "+chr(13)+chr(10)
cQryIF+= "	AND (C5_ATENATU='"+_cAte+"' OR C5_ATENDEN='"+_cAte+"') "+chr(13)+chr(10)
cQryIF+= " "+chr(13)+chr(10)
cQryIF+= "ORDER BY "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_PREF, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_NUM , "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_PARC, "+chr(13)+chr(10)
cQryIF+= "	ZZT.ZZT_CLIENT "+chr(13)+chr(10)

DbUseArea( .t., "TOPCONN", TcGenQry(,, cQryIF), "Wk4", .F., .F.)
TcSetField( "WK4",	"ZZT_DTORI",	"D",	08,	0 )
TcSetField( "WK4",	"ZZT_DTATU",	"D",	08,	0 )
TcSetField( "WK4",	"ZZT_DTSOL",	"D",	08,	0 )
TcSetField( "WK4",	"ZZT.VLORIG",	"N",	12,	2 )
TcSetField( "WK4",	"ZZT.VLATU",	"N",	12,	2 )
aFile[4]:=CriaTrab(,.f.)
DbSelectArea( "Wk4" )
Copy To (aFile[4])
Wk4->(DbCloseArea())
DbUseArea( .t., "DBFCDX", aFile[4], "Wk4" )

Return Nil





/************************/
User Function ChkCorBO(_P) 
/************************/
Local cCor
If _P=1
	If &cExpr1
		cCor:=LoadBitmap( GetResources(), "BR_VERDE" )
	
	Else
		cCor:=LoadBitmap( GetResources(), "BR_VERMELHO" )
	
	EndIf
	           
	If ALLTRIM(Wk1->C5_NOTA) == "" .AND. ALLTRIM(Wk1->C5_INTCANC) == ""
		cCor:=LoadBitmap( GetResources(), 'BR_VERDE' )
	
	ElseIf ALLTRIM(Wk1->C5_NOTA) == "" .AND. Wk1->C5_INTCANC == "S"
	   If Wk1->C5_Atenden<>Wk1->C5_AtenAtu
	   	If Wk1->C5_Atenden=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
				cCor:=LoadBitmap( GetResources(), 'BR_AMARELO' )
	
	   	ElseIf Wk1->C5_AtenAtu=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
				cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )
	
	   	EndIf
	   
	   Else
			cCor:=LoadBitmap( GetResources(), 'BR_LARANJA' )
	
		EndIf
	
	ElseIf ALLTRIM(Wk1->C5_NOTA) == "" .AND. Wk1->C5_INTCANC == "A"
		cCor:=LoadBitmap( GetResources(), 'BR_AZUL' )
	
	ElseIf ALLTRIM(Wk1->C5_NOTA) == "" .AND. Wk1->C5_INTCANC == "N"
		cCor:=LoadBitmap( GetResources(), 'BR_PRETO'  )
	
	ElseIf ALLTRIM(Wk1->C5_NOTA) <> ""
		cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )
	                
	EndIf

ElseIf _P=2
	If &cExpr2
		cCor:=LoadBitmap( GetResources(), "BR_VERDE" )
	
	Else
		cCor:=LoadBitmap( GetResources(), "BR_VERMELHO" )
	
	EndIf
	           
/*	If ALLTRIM(Wk2->C5_NOTA) == "" .AND. ALLTRIM(Wk2->C5_INTALT) == ""
		cCor:=LoadBitmap( GetResources(), 'BR_VERDE' )
	
	Else*/
	If ALLTRIM(Wk2->C5_NOTA) == "" .AND. Wk2->C5_INTALT == " "
	   If Wk2->Z0_ATENDEN<>Wk2->Z0_ATENATU
	   	If Wk2->Z0_ATENDEN=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
				cCor:=LoadBitmap( GetResources(), 'BR_AMARELO' )

	   	ElseIf Wk2->Z0_ATENATU=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
				cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )

	   	EndIf

	   Else
			cCor:=LoadBitmap( GetResources(), 'BR_LARANJA' )

		EndIf

	ElseIf ALLTRIM(Wk2->C5_NOTA) == "" .AND. Wk2->C5_INTCANC == "A"
		cCor:=LoadBitmap( GetResources(), 'BR_AZUL' )

	ElseIf ALLTRIM(Wk2->C5_NOTA) == "" .AND. Wk2->C5_INTCANC == "N"
		cCor:=LoadBitmap( GetResources(), 'BR_PRETO'  )

	ElseIf ALLTRIM(Wk2->C5_NOTA) <> ""
		cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )

	EndIf

ElseIf _P=3
   If Wk3->Z6_CODATEN<>Wk3->Z6_AtenAtu
   	If Wk3->Z6_CODATEN=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
			cCor:=LoadBitmap( GetResources(), 'BR_AMARELO' )
	
   	ElseIf Wk3->Z6_AtenAtu=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
			cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )
	
   	EndIf
	   
   Else //If Wk3->Z6_Status=
		cCor:=LoadBitmap( GetResources(), 'BR_VERDE' )
	
	EndIf

ElseIf _P=4
   If Wk4->C5_Atenden<>Wk4->C5_AtenAtu
   	If Wk4->C5_Atenden=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
			cCor:=LoadBitmap( GetResources(), 'BR_AMARELO' )
	
   	ElseIf Wk4->C5_AtenAtu=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, "  " )
			cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )
	
   	EndIf
	   
   Else //If Wk3->Z6_Status=
		cCor:=LoadBitmap( GetResources(), 'BR_VERDE' )
	
	EndIf

EndIf

Return cCor

/*************************/
Static Function Aprovar(_P)
/*************************/
Local nCont   := 0      
Local cUpd    := ""    
Local cObsPed := ""  
Local _cQuery := ""

cData   := DTOS(DDATABASE)
cHora   := Time()
	
//If _P=1 		// IntenÁ„o de Cancelamento 
// AQUI
/*DbSelectarea("SZV")
DBSETORDER(2)
Dbseek(xFilial("SZV")+ PSWRET()[1,1])
  */
  
ChkEnc()

If _P=1 
	Wk1->(DbGoTop())
	Wk1->(DbEval( {||++nCont},{||Wk1->Flag=cMarca} ))
	If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para AprovaÁ„o.", "SEM DADOS" )
		Return .f.

	EndIf

  	If MsgYesNo( "Confirma a AprovaÁ„o de Cancelamento do(s) Pedido(s) Marcado(s) ?" ) .And.  !Szv->(Eof())   
		Wk1->(DbGoTop())
		While !Wk1->(Eof())
			If Wk1->Flag=cMarca    
			 IF (!EMPTY(WK1->C5_ATENATU) .AND. WK1->C5_ATENATU == _cAte) .OR. (EMPTY(WK1->C5_ATENATU) .AND. WK1->C5_ATENDEN == _cAte)  
    			Sc5->(DbSeek( xFilial( "SC5" )+Wk1->C5_Num ))  
            cMotCod := SC5->C5_CODMOT
            cMotDes := SC5->C5_DESMOT
            cSubst  := SC5->C5_SUBST

				RecLock( "SC5", .f. )
					If U_GrvOcoOR( Wk1->C5_Num, , , "A", "", , "C" )  // GRAVA NA TABELA ZZR
						Sc5->C5_IntCanc	:="A"
//						Sc5->C5_Status:="C"   
                  SC5->C5_ZZCOD 		:= '130'
                  SC5->C5_ZZDESC 	:= 'CANCELADO'
						Sc5->(DbDelete())
					EndIf
	
				MsUnLock()
				Sc5->(DbCommit()) 
				
				cUpd:= "UPDATE "+RetSqlName("SC5")+" SET C5_INTCANC = 'A', D_E_L_E_T_ = '*' " //, C5_Status = 'C'"
				cUpd+= " WHERE C5_NUM = '"+ALLTRIM(Wk1->C5_Num) + "' "
				If TcSqlExec( cUpd )<0
	  				MsgStop( "Ocorreu problema na atualizaÁ„o da tabela de pedido para o cancelamento total do Pedido de Venda !!!"+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)+"ENTRE EM CONTATO COM O SUPORTE !!!", "Erro Grave !!!" )
	  			Quit
           ENDIF          
           
  				SCJ->(DbSeek( xFilial( "SCJ" )+Wk1->C5_Num ))    
  				cOBSPED := SCJ->CJ_OBSPED 
				RecLock( "SCJ", .f. )
				   SCJ->CJ_STATUS:="C"
//		   SCJ->CJ_OBSICAN := ALLTRIM(CMOTCOD) + " - " + ALLTRIM(CMOTDES)  
		         SCJ->CJ_CANCORC := "CANC:" + ALLTRIM(CMOTCOD) + " - " + ALLTRIM(CMOTDES)
//				   SCJ->CJ_CODIGOM := cMotCod
//				   SCJ->CJ_CANCORC := cMotDes                                 
				MsUnLock()
				SCJ->(DbCommit()) 

/*				cUpd:= "UPDATE "+RetSqlName("SCK")+" SET D_E_L_E_T_ = '*' " //, C5_Status = 'C'"
				cUpd+= " WHERE CK_NUM = '"+ALLTRIM(Wk1->C5_Num) + "' "
				If TcSqlExec( cUpd )<0
	  				MsgStop( "Ocorreu problema na atualizaÁ„o da tabela de orÁamento para o cancelamento total do Pedido de Venda !!!"+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)+"ENTRE EM CONTATO COM O SUPORTE !!!", "Erro Grave !!!" )
	  			Quit
           ENDIF                */

              	_cKey03 := ALLTRIM(Wk1->C5_Num) + ;
					StrZero(99999999 - Val(cData),8) + ;
					StrZero(999999 - Val(Substr(cHora,1,2) + Substr(cHora,4,2) + Substr(cHora,7,2)),6)
					
					_cKey04 := "130" + ALLTRIM(Wk1->C5_Num) + ;
					StrZero(99999999 - Val(cData),8) + ;
					StrZero(999999 - Val(Substr(cHora,1,2) + Substr(cHora,4,2) + Substr(cHora,7,2)),6)
					
					_cKey05 := ALLTRIM(Wk1->C5_Num) + ;
					StrZero(999 - 130)
					
					_cKey06 := "130" + ;
					StrZero(99999999 - Val(cData),8) + ;
					StrZero(999999 - Val(Substr(cHora,1,2) + Substr(cHora,4,2) + Substr(cHora,7,2)),6)
				
           // GRAVA TABELA DE HISTORICO DAS LOCALIZA«’ES - SZL  
          				RecLock( "SZL", .T. )
							SZL->ZL_COD     := "130"
  							SZL->ZL_HIST    :="CANCELADO"
  							SZL->ZL_NUM     := WK1->C5_NUM
  							SZL->ZL_DATA    := DDATABASE
  							SZL->ZL_HORA    := cHora
							SZL->ZL_USUAR   := SubSTR(cUsuario,7,15)  							
  							SZL->ZL_EMPRE   := cEmpant+"-"+SM0->M0_NOME
							SZL->ZL_KPEDDH  := _cKey03
				  			SZL->ZL_KLOCPED := _cKey04
							SZL->ZL_KPEDLOC := _cKey05
							SZL->ZL_KLOCDH  := _cKey06
							MsUnLock()
							SZL->(DbCommit()) 
			 ELSE
			    MSGALERT("ESTE PEDIDO FOI ENCAMINHADO PARA OUTRO COORDENADOR!!!")
			    RETURN .F.
			 EndIf
			ENDIF  
   		Wk1->(DbSkip())
		EndDo
	
		BO_IntCanc()

	EndIF

	SysRefresh()
	oBrows1:ReFresh()

ElseIf _P=2	// IntenÁ„o de AlteraÁ„o  
	
	Wk2->(DbGoTop())
	Wk2->(DbEval( {||++nCont},{||Wk2->Z0_Flag=cMarca} ))
	If nCont=0                   
		MsgStop( "N„o existe IntenÁıes marcadas para AprovaÁ„o.", "SEM DADOS" )
		Return .f.

	EndIf
 // BLOCO DE DESENVOLVIMENTO DA ROTINA DE APROVACAO.
	If MsgYesNo( "Confirma a AprovaÁ„o de AlteraÁ„o do(s) Pedido(s) Marcado(s) ?" ) .and. !Szv->(Eof()) 
		Wk2->(DbGoTop())
		While !Wk2->(Eof())
			If Wk2->Z0_Flag=cMarca   
			 IF (!EMPTY(WK2->C5_ATENATU) .AND. WK2->C5_ATENATU == _cAte) .OR. (EMPTY(WK2->C5_ATENATU) .AND. WK2->C5_ATENDEN == _cAte)  

				Sc5->(DbSeek( xFilial( "SC5" )+Wk2->C5_Num ))
				
				//AQUI ALTERACAO PARA COLOCAR A MENSAGEM E APENAS ALTERAR O STATUS DO SC5.
				
				Sz0->(DbSeek( xFilial( "SZ0" )+Wk2->(C5_Num+Dtos(Z0_DtAlt)+Z0_Hora) ))
				RecLock( "SZ0", .f. )
					Sz0->Z0_Status:="A"

				MsUnLock()

				Sz0->(DbCommit())

				RecLock( "SC5", .f. )
					If U_GrvOcoOR( Wk2->C5_Num, , , "A", "", , "A" )
						Sc5->C5_IntAlt:="A"
		
					EndIf
	
				MsUnLock()
				Sc5->(DbCommit())
            
				Wk2->(DbSkip())
	
				
//	         MsgStop( "FAVOR IMPRMIR A INTENCAO PELO BI, E LEVAR PARA APROVA«√O E ALTERACAO DO LOURIVAL...... OP«√O EM DESENVOLVIMENTO !!!", "AGUARDE LIBERA«√O !!!" )
//	
				BO_IntAlt()   
				
				SysRefresh()
				oBrows2:ReFresh()

            
            Return .T.
 // FIM DA ALTERA«√O.
			// COLOQUEI O IF AQUI, MAS DEPOIS COLOCAR NO FIM DO BLOCO DA ALTERACAO
			 ELSE
			    MSGALERT("ESTE PEDIDO FOI ENCAMINHADO PARA OUTRO COORDENADOR!!!")
			    RETURN .F.
			 EndIf
				
				If Wk2->Z0_CondPag<>Wk2->Z0_ConAtu
					RecLock( "SC5", .f. )
						Sc5->C5_CondPag:=Wk2->Z0_ConAtu
					MsUnLock()
				EndIf      

// DADOS DE CABE«ALHO (CAPA)
				If Wk2->Z0_Entrega<>Wk2->Z0_EntAtu
					RecLock( "SC5", .f. )
						Sc5->C5_Entrega:=Wk2->Z0_EntAtu
/*
						Sc6->(DbSeek( xFilial( "SC6" )+Sc5->C5_Num ))
						While !Sc6->(Eof()) .And. Sc6->C6_Num=Sc5->C5_Num
							RecLock( "SC6", .f. )
								Sc6->C6_Entrega:=Wk2->Z0_EntAtu

							MsUnLock()

							Sc6->(DbCommit())
							Sc6->(DbSkip())

						EndDo
*/					MsUnLock()
					Sc5->(DbCommit())
				EndIf

				If Wk2->Z0_Transp<>Wk2->Z0_TraAtu
					RecLock( "SC5", .f. )
						Sc5->C5_Transp:=Wk2->Z0_TraAtu
					MsUnLock()
					Sc5->(DbCommit())     
				EndIf

				If Wk2->Z0_Frt<>Wk2->Z0_FrtAtu
					RecLock( "SC5", .f. )
						Sc5->C5_TPFRETE:=SUBSTR(Wk2->Z0_FrtAtu,1,1)
					MsUnLock()
					Sc5->(DbCommit())
				EndIf

// DADOS DOS ITENS (DETALHE)
				If Wk2->Z0_QtdVen<>Wk2->Z0_QtdAtu
					If Wk2->Z0_QtdAtu=0 //Exclus„o do Item
						Sc6->(DbSeek( xFilial( "SC6" )+Wk2->(Z0_Num+Z0_Item) ))
						While !Sc6->(Eof()) .And. Sc6->(C6_Num+C6_Item)=Wk2->(Z0_Num+Z0_Item)
							RecLock( "SC6", .f. )
								Sc6->(DbDelete())
	
							MsUnLock()
	
							Sc6->(DbCommit())
							Sc6->(DbSkip())
	
						EndDo
					
					Else
						Sc6->(DbSeek( xFilial( "SC6" )+Wk2->(Z0_Num+Z0_Item) ))
						While !Sc6->(Eof()) .And. Sc6->(C6_Num+C6_Item)=Wk2->(Z0_Num+Z0_Item)
							RecLock( "SC6", .f. )
								Sc6->C6_QtdVen:=Wk2->Z0_QtdAtu
								Sc6->C6_Valor:=Sc6->(C6_PrcVen*C6_QtdVen)
	
							MsUnLock()
	
							Sc6->(DbCommit())
							Sc6->(DbSkip())
	
						EndDo

					EndIf
	
				EndIf

				If Wk2->Z0_PrcVen<>Wk2->Z0_PrcAtu
					Sc6->(DbSeek( xFilial( "SC6" )+Wk2->(Z0_Num+Z0_Item) ))
					While !Sc6->(Eof()) .And. Sc6->(C6_Num+C6_Item)=Wk2->(Z0_Num+Z0_Item)
						RecLock( "SC6", .f. )
							Sc6->C6_PrcVen:=Wk2->Z0_PrcAtu
							Sc6->C6_Valor:=Sc6->(C6_PrcVen*C6_QtdVen)

						MsUnLock()

						Sc6->(DbCommit())
						Sc6->(DbSkip())

					EndDo

				EndIf

				If Wk2->Z0_NovItem="S"
					Sc6->(DbSeek( xFilial( "SC6" )+Wk2->Z0_Num ))
					aFSc6:={}
					For nX:=1 To Sc6->(FCount())
						Aadd( aFSc6, Sc6->(FieldGet( nX )) )

					Next

					RecLock( "SC6", .t. )
						For nX:=1 To Sc6->(FCount())
							Sc6->(FieldPut( nX, aFSc6[nX] ))

						Next
						
						Sc6->C6_Item:=Wk2->Z0_Item
						Sc6->C6_Produto:=Wk2->Z0_NovProd
						Sc6->C6_QtdVen:=Wk2->Z0_QtdAtu
						Sc6->C6_PrcVen:=Wk2->Z0_PrcAtu
						Sc6->C6_Valor:=Sc6->(C6_PrcVen*C6_QtdVen)

					MsUnLock()

					Sc6->(DbCommit())

            EndIf
            
				Sz0->(DbSeek( xFilial( "SZ0" )+Wk2->(Z0_Num+Dtos(Z0_DtAlt)+Z0_Hora) ))
				RecLock( "SZ0", .f. )
					Sz0->Z0_Status:="A"

				MsUnLock()

				Sz0->(DbCommit())

				RecLock( "SC5", .f. )
					If U_GrvOcoOR( Wk2->Z0_Num, , , "A", "", , "A" )
						Sc5->C5_IntAlt:="A"
		
					EndIf
	
				MsUnLock()
				Sc5->(DbCommit())
	
			EndIf
	
			Wk2->(DbSkip())
	
		EndDo
	
		BO_IntAlt()

	EndIF

	SysRefresh()
	oBrows2:ReFresh()

ElseIf _P=3	// IntenÁ„o de DevoluÁ„o
/*
  EXITEM 2 STATUS (Z6_STATUS=	02-DEV.CONFIRMADA ATENDENTE ; // UTILIZAR ESSE STATUS PARA GRAVAR STATUS DO Z6, APOS CONFIRMA«√O DA ATENDENTE.
  						Z6_DESCSTA=DEV.CONFIRMADA ATENDENTE.
*/

	Wk3->(DbGoTop())
	Wk3->(DbEval( {||++nCont},{||Wk3->Flag=cMarca} ))
	If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para AprovaÁ„o da DevoluÁ„o.", "SEM DADOS" )
		Return .f.

	EndIf

//	If MsgYesNo( "Confirma a AprovaÁ„o da DevoluÁ„o da(s) Notas Fiscais ref. ao(s) Pedido(s) Marcado(s) ?" ) .and. !Szv->(Eof())
  // ALTERADO FLAVIA, NAO ESTAVA ENTRANDO PARA MUDAR O STATUS. SZV ESTAVA EM EOF.
	If MsgYesNo( "Confirma a AprovaÁ„o da DevoluÁ„o da(s) Notas Fiscais ref. ao(s) Pedido(s) Marcado(s) ?" ) .and. !Szv->(Eof())
		Wk3->(DbGoTop())
		While !Wk3->(Eof())
			If Wk3->Flag=cMarca       
			// COORDENADOR NAO PODE APROVAR ITENS QUE ELE ENCAMINHOU PARA OUTRO COORD.
			 IF (!EMPTY(WK3->Z6_ATENATU) .AND. WK3->Z6_ATENATU == _cAte) .OR. (EMPTY(WK3->Z6_ATENATU) .AND. WK3->Z6_CODATEN == _cAte)  
//				SZ6->(DbSeek( xFilial( "SZ6" )+Wk3->Z6_NF + Wk3->Z6_SERIE ))
				// erro Posicione( "SZ6", 2, xFilial( "SZ6" )+Wk3->Z6_Numero, "Z6_NUMERO" )   ////"Z6_NPEDCLI" )
				If !Empty(POSICIONE( "SZ6", 2, XFILIAL("SZ6")+WK3->Z6_NUMERO, "Z6_NUMERO"))      
					RecLock( "SZ6", .f. )
						SZ6->Z6_STATUS		:="03"
						SZ6->Z6_DESCSTA	:="DEVOLUCAO AUTORIZADA"  
						SZ6->Z6_DTAPROV   := DDATABASE

					MsUnLock()

					Sz6->(DbCommit())   
					
			      _cQuery := " UPDATE SZ6010 SET Z6_STATUS = '03' , Z6_DESCSTA = 'DEVOLUCAO AUTORIZADA' " 
				   _cQuery += " , Z6_DTAPROV = '"    + CDATA      + "' " 
               _cQuery += " WHERE Z6_NUMERO = '" + WK3->Z6_NUMERO + "' "		
			      TCSQLEXEC(_cQuery)
				   
				   dbselectarea("SF2")
				   DBSETORDER(1)
				   IF DBSEEK (xFilial( "SF2" )+Wk3->(Z6_NUMERO + Z6_NF) )
				      RECLOCK("SF2", .F.)
				        SF2->F2_INTDEV := "A"
						MsUnLock()
						SF2->(DbCommit())   
					 ENDIF

				Else 
					MsgStop("Ocorreu Erro durante tentantiva de AÁ„o com DevoluÁ„o...  Entre em contato com o CPD...")
					Exit

				EndIf

			 ELSE
				MSGALERT("ESTE PEDIDO FOI ENCAMINHADO PARA OUTRO COORDENADOR!!!")
			//	RETURN .F.
			 EndIf
			EndIf
				
			Wk3->(DbSkip())
	
		EndDo
	
		BO_IntDev()

	EndIF

	SysRefresh()
	oBrows3:ReFresh()

ElseIf _P=4	// IntenÁ„o de Financeiro (Duplicatas)
	MsgStop( "OP«√O EM DESENVOLVIMENTO !!!", "AGUARDE LIBERA«√O !!!" )
	Return .f.
	Wk4->(DbGoTop())
	Wk4->(DbEval( {||++nCont},{||Wk4->Flag=cMarca} ))
	If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para AprovaÁ„o de alteraÁ„o de Duplicatas.", "SEM DADOS" )
		Return .f.

	EndIf

	If !Szv->(Eof()) .And. MsgYesNo( "Confirma a AprovaÁ„o da AlteraÁ„o de Duplicata(s) Marcada(s) ?" )
		Wk4->(DbGoTop())
		While !Wk4->(Eof())
			If Wk4->Flag=cMarca
				Posicione( "ZZT", 1, xFilial( "ZZT" )+Wk4->ZZT_Numero, "ZZT_NUM" )
				Posicione( "SE1", 1, xFilial( "SE1" )+Wk4->(Zzt_Pref+Zzt_Num+Zzt_Parc), "E1_NUM" )
				RecLock( "SE1", .f. )
					If Zzt->Zzt_VlOrig<>Zzt->Zzt_VlAtu
						Se1->E1_Valor:=Zzt->Zzt_VlAtu

					EndIf

					If Zzt->Zzt_DtOrig<>Zzt->Zzt_DtAtu
						Se1->E1_VencRea:=Zzt->Zzt_DtAtu

					EndIf

				MsUnLock()


				RecLock( "ZZT", .f. )
					Zzt->Zzt_Status:="A"

				MsUnLock()

				ZZT->(DbCommit())

	
			EndIf
	
			Wk4->(DbSkip())
	
		EndDo
	
		BO_IntDup()

	EndIF

	SysRefresh()
	oBrows4:ReFresh()

Else
	SysRefresh()

EndIf

Return Nil

/***************************/
Static Function Reprovar(_P)
/***************************/
Local nCont:=0
//If _P=1 		// IntenÁ„o de Cancelamento
If _P=1 
	Wk1->(DbGoTop()) 
	//// ALTERADO PELA FLAVIA, NAO ESTAVA CONTANDO OS REGISTROS MARCADOS - 14/11/07
	//Wk1->(DbEval( {||++nCont},,{||Wk1->Flag=cMarca} ))
	Wk1->(DbEval( {||++nCont},{||Wk1->Flag=cMarca} ))
	If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para ReprovaÁ„o de intenÁ„o de Cancelamento.", "SEM DADOS" )
		Return .f.

	EndIf

	If  MsgYesNo( "Confirma a ReprovaÁ„o de Cancelamento do(s) Pedido(s) Marcado(s) ?" )  .AND. !Szv->(Eof())
		Wk1->(DbGoTop())
		While !Wk1->(Eof())
			If Wk1->Flag=cMarca
				Sc5->(DbSeek( xFilial( "SC5" )+Wk1->C5_Num ))
				RecLock( "SC5", .f. )
					If U_GrvOcoOR( Wk1->C5_Num, , , "R", "", , "C" )
						Sc5->C5_IntCanc:="R"
		
					EndIf
	
				MsUnLock()
				Sc5->(DbCommit())    
				
				cUpd:= "UPDATE "+RetSqlName("SC5")+" SET C5_INTCANC = 'R' " //, C5_Status = 'C'"
				cUpd+= " WHERE C5_NUM = '"+ALLTRIM(Wk1->C5_Num) + "' "
				If TcSqlExec( cUpd )<0
	  				MsgStop( "Ocorreu problema na REPROVACAO do cancelamento total do Pedido de Venda !!!"+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)+"ENTRE EM CONTATO COM O SUPORTE !!!", "Erro Grave !!!" )
	  			Quit
           ENDIF

	
			EndIf
	
			Wk1->(DbSkip())
	
		EndDo
	
		BO_IntCanc()

	EndIF

	SysRefresh()
	oBrows1:ReFresh()

ElseIf _P=2	// IntenÁ„o de AlteraÁ„o 
	Wk2->(DbGoTop())
//	Wk2->(DbEval( {||++nCont},,{||Wk2->Z0_Flag=cMarca} ))
    // ALTERADO PELA FLAVIA, NAO ESTAVA CONTANDO OS REGISTROS MARCADOS - 14/11/07
   Wk2->(DbEval( {||++nCont},{||Wk2->Z0_Flag=cMarca}))
		If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para ReprovaÁ„o de alteraÁ„o de Pedidos.", "SEM DADOS" )
		Return .f.

	EndIf

//	If !Szv->(Eof()) .And. MsgYesNo( "Confirma a ReprovaÁ„o de Alteracao do(s) Pedido(s) Marcado(s) ?" )

	If MsgYesNo( "Confirma a ReprovaÁ„o de Alteracao do(s) Pedido(s) Marcado(s) ?" ).And. !Szv->(Eof()) 
		Wk2->(DbGoTop())
		While !Wk2->(Eof())
			If Wk2->Z0_Flag=cMarca
				Sc5->(DbSeek( xFilial( "SC5" )+Wk2->Z0_Num ))
				RecLock( "SC5", .f. )
					If U_GrvOcoOR( Wk2->Z0_Num, , , "R", "", , "A" )
						Sc5->C5_IntAlt:="R"
		
					EndIf
	
				MsUnLock()
				Sc5->(DbCommit())
	
			EndIf
	
			Wk2->(DbSkip())
	
		EndDo
	
		BO_IntAlt()

	EndIF

	oBrows2:ReFresh()

ElseIf _P=3	// IntenÁ„o de DevoluÁ„o
	Wk3->(DbGoTop()) 
	 // ALTERADO FLAVIA - 14/11/08 - NAO ESTAVA CONTANDO OS REGISTROS
    //	Wk3->(DbEval( {||++nCont},{||Wk3->Flag=cMarca} ))              
	Wk3->(DbEval( {||++nCont},{||Wk3->Flag=cMarca} ))

	If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para ReprovaÁ„o de DevoluÁ„o.", "SEM DADOS" )
		Return .f.

	EndIf

	If MsgYesNo( "Confirma a ReprovaÁ„o de DevoluÁ„o do(s) Pedido(s) Marcado(s) ?" ) //.and. !Szv->(Eof())  
		Wk3->(DbGoTop())
		While !Wk3->(Eof())
			If Wk3->Flag=cMarca
				If !Empty(POSICIONE( "SZ6", 2, XFILIAL("SZ6")+WK3->Z6_NUMERO, "Z6_NUMERO"))
					RecLock( "SZ6", .f. )
						Sz6->Z6_Status:="10"
						Sz6->Z6_DescSta="DEV.CANCELADA ATENDENTE."

					MsUnLock()
					Sz6->(DbCommit())
					
				   dbselectarea("SF2")
				   DBSETORDER(1)
				   IF DBSEEK (xFilial( "SF2" )+WK3->(Z6_NUMERO + Z6_NF) )
				      RECLOCK("SF2", .F.)
				        SF2->F2_INTDEV := "R"
						MsUnLock()
						SF2->(DbCommit())   
					 ENDIF


				Else 
					MsgStop("Ocorreu Erro durante tentantiva de AÁ„o com DevoluÁ„o...  Entre em contato com o CPD...")
					Exit

				EndIf

             /*
				Posicione( "SZ6", 2, xFilial( "SZ6" )+Wk3->Z6_Numero, "Z6_NUMERO" )
//				SZ6->(DbSeek( xFilial( "SZ6" )+Wk3->Z6_Numero ))
 				RecLock( "SZ6", .f. )
					Sz6->Z6_Status:="10"
					Sz6->Z6_DescSta="DEV.CANCELADA ATENDENTE."

				MsUnLock()

				Sz6->(DbCommit())
               */
	
			EndIf
	
			Wk3->(DbSkip())
	
		EndDo
	
		BO_IntDev()

	EndIF

	SysRefresh()
	oBrows3:ReFresh()

ElseIf _P=4	// IntenÁ„o de Financeiro
	Wk4->(DbGoTop())                           
     // ALTERADO FLAVIA - 14/11/08 - NAO ESTAVA CONTANDO OS REGISTROS
    //		Wk4->(DbEval( {||++nCont},{||Wk4->Flag=cMarca} ))
   Wk4->(DbEval( {||++nCont},{||Wk4->Flag=cMarca}))

	If nCont=0 
		MsgStop( "N„o existe IntenÁıes marcadas para ReprovaÁ„o de AlteraÁ„o de Duplicatas.", "SEM DADOS" )
		Return .f.

	EndIf

	If MsgYesNo( "Confirma a ReprovaÁ„o da AlteraÁ„o de Duplicata(s) Marcada(s) ?" ) .AND. !Szv->(Eof())
		Wk4->(DbGoTop())
		While !Wk4->(Eof())
			If Wk4->Flag=cMarca
				Posicione( "ZZT", 1, xFilial( "ZZT" )+Wk4->ZZT_Numero, "ZZT_NUM" )
/*
				Posicione( "SE1", 1, xFilial( "SE1" )+Wk4->(Zzt_Pref+Zzt_Num+Zzt_Parc), "E1_NUM" )
				RecLock( "SE1", .f. )
					If Zzt->Zzt_VlOrig<>Zzt->Zzt_VlAtu
						Se1->E1_Valor:=Zzt->Zzt_VlAtu

					EndIf

					If Zzt->Zzt_DtOrig<>Zzt->Zzt_DtAtu
						Se1->E1_VencRea:=Zzt->Zzt_DtAtu

					EndIf

				MsUnLock()

*/
				RecLock( "ZZT", .f. )
					Zzt->Zzt_Status:="R"

				MsUnLock()

				ZZT->(DbCommit())

	
			EndIf
	
			Wk4->(DbSkip())
	
		EndDo
	
		BO_IntDup()

	EndIF

	SysRefresh()
	oBrows4:ReFresh()

Else
	SysRefresh()

EndIf

Return Nil

/*****************************/
Static Function Encaminhar(_P)
/*****************************/
Local cAtenAtu:=Space(6)   
Local nOpc:=0
Local _oDlg				// Dialog Principal
Local cTitu
// Variaveis Locais da Funcao
Private cAtenden	 := Space(25)
Private cNome	 := Space(25)
Private mObs	 := ""
Private ocAtenden
Private ocNome
Private omObs
Private bOk:={||nOpc:=1,_oDlg:End()}
Private bCancel:={||nOpc:=2,_oDlg:End()}
// Variaveis Private da Funcao
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

If _P=1
	cTitu:="Cancelamento"

ElseIf _P=2
	cTitu:="AlteraÁ„o"

ElseIf _P=3
	cTitu:="DevoluÁ„o"

ElseIf _P=4
	cTitu:="Financeiro"

EndIf

DEFINE MSDIALOG _oDlg TITLE "Encaminhamento de IntenÁ„o de "+ cTitu FROM C(443),C(375) TO C(637),C(853) PIXEL
	// Cria Componentes Padroes do Sistema
	@ C(010),C(027) Say "Encaminhar para atendente:" Size C(069),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(010),C(100) MsGet ocAtenden Var cAtenden F3 "SZV" Valid ChkEnc(cAtenden) Size C(030),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(010),C(130) MsGet ocNome Var cNome When .f. Size C(095),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(025),C(011) Say "Motivo:" Size C(019),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(030) GET omObs Var mObs MEMO Valid !Empty( mObs ) Size C(195),C(045) PIXEL OF _oDlg
	@ C(077),C(032) Button "OK" Size C(037),C(012) Action Eval(bOK) PIXEL OF _oDlg
	@ C(077),C(187) Button "Cancel" Size C(037),C(012) Action Eval(bCancel) PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED 

If _P=1 .And. nOpc=1 .And. !Empty(cAtenden) .And. !Szv->(Eof()) .And. MsgYesNo( "Confirma o Encaminhamento da IntenÁ„o de "+cTitu+" para "+AllTrim(cNome)+" ?" )
	Sc5->(DbSeek( xFilial( "SC5" )+Wk1->C5_Num ))
	RecLock( "SC5", .f. )
		If U_GrvOcoOR( Wk1->C5_Num, , , "E", mObs, cAtenden, "P" )
			Sc5->C5_AtenAtu:=cAtenden

		EndIf

	MsUnLock()
	Sc5->(DbCommit())
	BO_IntCanc()
	SysRefresh()
	oBrows1:ReFresh()

ElseIf _P=2 .And. nOpc=1 .And. !Empty(cAtenden) .And. !Szv->(Eof()) .And. MsgYesNo( "Confirma o Encaminhamento da IntenÁ„o de "+cTitu+" para "+AllTrim(cNome)+" ?" )
	Sc5->(DbSeek( xFilial( "SC5" )+Wk2->Z0_Num ))
	RecLock( "SC5", .f. )
		If U_GrvOcoOR( Wk2->Z0_Num, , , "E", mObs, cAtenden, "P" )
			Sc5->C5_AtenAtu:=cAtenden

		EndIf

	MsUnLock()
	Sc5->(DbCommit())
	BO_IntAlt()
	SysRefresh()
	oBrows2:ReFresh()

ElseIf _P=3 .And. nOpc=1 .And. !Empty(cAtenden) .And. !Szv->(Eof()) .And. MsgYesNo( "Confirma o Encaminhamento da IntenÁ„o de "+cTitu+" para "+AllTrim(cNome)+" ?" )
	Sc5->(DbSeek( xFilial( "SC5" )+Wk3->Z6_NPEDCLI ))
	RecLock( "SC5", .f. )
		If U_GrvOcoOR( Wk3->Z6_NPedCli, , , "E", mObs, cAtenden, "P" )
			Sc5->C5_AtenAtu:=cAtenden

		EndIf

	MsUnLock()
	Sc5->(DbCommit())
	BO_IntDev()
	SysRefresh()
	oBrows3:ReFresh()

ElseIf _P=4 .And. nOpc=1 .And. !Empty(cAtenden) .And. !Szv->(Eof()) .And. MsgYesNo( "Confirma o Encaminhamento da IntenÁ„o de "+cTitu+" para "+AllTrim(cNome)+" ?" )
	Sc5->(DbSeek( xFilial( "SC5" )+Wk4->E1_PEDIDO ))
	RecLock( "SC5", .f. )
		If U_GrvOcoOR( Wk4->E1_PediDO, , , "E", mObs, cAtenden, "P" )
			Sc5->C5_AtenAtu:=cAtenden

		EndIf

	MsUnLock()
	Sc5->(DbCommit())
	BO_IntDup()
	SysRefresh()
	oBrows4:ReFresh()

ElseIf nOpc=2
	SysRefresh()

EndIf

Return Nil


/**********************/
Static Function ChkEnc()
/**********************/
cNome:=Posicione( "SZV", 1, xFilial("SZV")+cAtenden, "ZV_NOME" )
//cNome:=GetAdvFVal( "SZV", "ZV_NOME", xFilial("SZV")+cAtenden, 1, Space(25)  )
//cNome:ReFresh()
Return .t.


/************************/
User Function VerErro(_P1)
/************************/
lRet:=.f.
Return lRet



//////////////////////////////////////////////////
//Legenda do browse de intenÁıes - MHS 10/07/07
//////////////////////////////////////////////////
/**************************/
Static Function Leg_Int(_P)
/**************************/
cCadastro := "Legenda"

If _P=1 .Or. _P=2

	aCores2 := { { 'BR_VERDE'   , "Pedido Original Aberto"              },;  //"Pedido Original Aberto"    
			       { 'BR_LARANJA' , "Pedido em Analise pelo Coord. Vendas"},;  //"Pedido em Analise pelo Coord. Vendas"
   	          { 'BR_AZUL'    , "AlteraÁ„o APROVADA"                  },;  //"AlteraÁ„o APROVADA"  
      	       { 'BR_PRETO'   , "AlteraÁ„o NEGADA"                    },;  //"AlteraÁ„o NEGADA"  
         	    { 'BR_AMARELO' , "Encaminhado PARA OUTRO COORDENADOR"  },;  //"Encaminhado PARA OUTRO COORDENADOR"
					 { 'BR_BRANCO'  , "Recebido DE OUTRO COORDENADOR"       } }  //"Recebido DE OUTRO COORDENADOR"    
            
/*aCores2 := {{ 'BR_PRETO'   , "Registro no. 1" },;
              { 'BR_AMARELO' , "Registro no. 2" },;
              { 'BR_AZUL'    , "Registro no. 3" },;
              { 'BR_CINZA'   , "Registro no. 4" },;
              { 'BR_PINK'    , "Registro no. 5" },;
              { 'BR_LARANJA' , "Registro no. 6" } }
*/             


ElseIf _P=3
	aCores2 := { { 'BR_VERDE'   , "DevoluÁ„o em Aberto"              },;
			       { 'BR_LARANJA' , "DevoluÁ„o em Analise pelo Coord. Vendas"},;
   	          { 'BR_AZUL'    , "DevoluÁ„o Parcial"                   },;
   	          { 'BR_CINZA'   , "DevoluÁ„o Integral"                  },;
      	       { 'BR_PRETO'   , "DevoluÁ„o Negada"                    },;
         	    { 'BR_AMARELO' , "Encaminhado PARA OUTRO COORDENADOR"  },;
					 { 'BR_VERMELHO', "Recebido DE OUTRO COORDENADOR"       } }
            
ElseIf _P=4
	aCores2 := { { 'BR_VERDE'   , "DevoluÁ„o em Aberto"              },;
			       { 'BR_LARANJA' , "DevoluÁ„o em Analise pelo Coord. Vendas"},;
   	          { 'BR_AZUL'    , "DevoluÁ„o Parcial"                   },;
   	          { 'BR_CINZA'   , "DevoluÁ„o Integral"                  },;
      	       { 'BR_PRETO'   , "DevoluÁ„o Negada"                    },;
         	    { 'BR_AMARELO' , "Encaminhado PARA OUTRO COORDENADOR"  },;
					 { 'BR_VERMELHO', "Recebido DE OUTRO COORDENADOR"       } }
            

EndIf

BrwLegenda(cCadastro,"Legenda",aCores2)

Return 


///////////////////////////////////////////////////////////////
//TELA DE PESQUISA DE NOTAS FISCAIS (FILTRO INICIAL REPRESENTANTE)
///////////////////////////////////////////////////////////////

Static FUNCTION FIL_NFIS()           

Local nOpc := 2    // caso tecle ESC executa o else do exit.

// Variaveis Locais da Funcao
Private cedtClient	 := Space(25)
Private cedtEmDE		 := CTOD("  /  /  ")//Space(25)
Private cedtEmATE	    := CTOD("  /  /  ")//Space(25)
Private cedtNClien	 := Space(25)
Private oedtClient
Private oedtEmDE
Private oedtEmATE
Private oedtNClien
Private oDlg30
Private oBrows30
Private aCampos := {}
Private aHeader := {}

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

DEFINE MSDIALOG _oDlg TITLE "NOTAS FISCAIS" FROM C(178),C(181) TO C(341),C(559) PIXEL

	// Cria a Group do Filtro
	@ C(004),C(005) TO C(045),C(185) LABEL " Filtro de Notas Fiscais " PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(016),C(011) Say "Cliente:" 										Size C(019),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(016),C(035) MsGet oedtClient Var cedtClient F3 "SA1" 	Size C(028),C(007) COLOR CLR_BLACK PIXEL OF _oDlg VALID U_VAL_CLI()
	@ C(016),C(067) MsGet oedtNClien Var cedtNClien  				Size C(107),C(007) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.
	@ C(032),C(011) Say "Emiss„o das NF¥s:" 							Size C(048),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(032),C(068) Say "De:" 												Size C(010),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(031),C(083) MsGet oedtEmDE 	Var cedtEmDE Picture "@R 99/99/9999"	Size C(032),C(007) COLOR CLR_BLACK PIXEL OF _oDlg VALID DataValida(cedtEmDE,.T.)
	@ C(032),C(127) Say "AtÈ:" 											Size C(010),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(031),C(142) MsGet oedtEmATE 	Var cedtEmATE Picture "@R 99/99/9999"	Size C(032),C(007) COLOR CLR_BLACK PIXEL OF _oDlg VALID DataValida(cedtEmATE,.T.)

	// Cria a Group da Mensagem
	@ C(050),C(005) TO C(075),C(152) LABEL " Mensagem " PIXEL OF _oDlg
	@ C(050),C(160) BMPBUTTON TYPE 1 									ACTION EVAL({||nOpc:=1,_oDlg:End()})
	@ C(055),C(008) Say "* Preencha os campos corretamente para agilizar na consulta, caso algum" /*Size C(010),C(008)*/ COLOR CLR_HRED PIXEL OF _oDlg
	@ C(060),C(008) Say "  campo n„o seja preenchido o filtro retornar· todas as ocorrÍncias, " /*Size C(010),C(008)*/ COLOR CLR_HRED PIXEL OF _oDlg
	@ C(065),C(008) Say "  desconsiderando o filtro e deixando a pesquisa mais lenta. " /*Size C(010),C(008)*/ COLOR CLR_HRED PIXEL OF _oDlg
	@ C(065),C(160) BMPBUTTON TYPE 2 									ACTION EVAL({||nOpc:=2,_oDlg:End()})

ACTIVATE MSDIALOG _oDlg CENTERED 

	If nOpc == 1 // botao confirma
		_cQuery := "SELECT ' ' FLAG, F2_EMISSAO, F2_DOC, F2_MPEDIDO, F2_SERIE, F2_TIPO, F2_CLIENTE, A1_NOME, F2_VALMERC, F2_TRANSP, A4_NOME, "
		_cQuery += "F2_VEND1, A3_NOME, F2_STATUS FROM SF2010 SF2, SA1010 SA1, SA3010 SA3, SA4010 SA4 WHERE F2_CLIENTE = A1_COD AND F2_VEND1 = A3_COD "
		_cQuery += "AND F2_TRANSP = A4_COD "
		_cQuery += "AND LTRIM(RTRIM(F2_VEND1)) = '" + ALLTRIM(_cRepr) + "' "

      If !empty(cedtEmDE) .and. !empty(cedtEmATE)
			_cQuery += "AND F2_EMISSAO BETWEEN '" + DTOS(cedtEmDE) + "' AND '"+DTOS(cedtEmATE)+"' "

		EndIf
   
		_cQuery += "AND RTRIM(LTRIM(F2_CLIENTE)) = '" + RTRIM(LTRIM(cedtClient)) + "' "
		_cQuery += "AND SF2.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' AND SA4.D_E_L_E_T_ = ' '"
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TRB", .F., .T.)
		IF TRB->(EOF())   //se nao retornar nada na query
			ALERT("N„o foram encontradas as Notas Fiscais do cliente no periodo selecionado. Verifique.")
			TRB->(DbCloseArea())
			Return			

		ENDIF

		TcSetField("TRB","F2_EMISSAO"	,"D",08)		
		
		_cArq    := Criatrab({},.F.)
		COPY TO (_cArq)
		TRB->(DbCloseArea())
		dbUseArea( .T., "DBFCDX", _cArq, "TRB", .F., .T.)

		DBSELECTAREA("TRB")
		INDEX ON F2_DOC + F2_SERIE + DTOS(F2_EMISSAO) TO (_cArq) 

		Aadd(aHeader,{"Emissao NF"   ,"F2_EMISSAO","@D",8,0})
		Aadd(aHeader,{"Nota Fiscal"  ,"F2_DOC"    ,"@!",6,0})
		Aadd(aHeader,{"Pedido"       ,"F2_MPEDIDO","@!",6,0})
		Aadd(aHeader,{"Serie"        ,"F2_SERIE"  ,"@!",3,0})		
		Aadd(aHeader,{"Tipo"         ,"F2_TIPO"   ,"@!",3,0})
		Aadd(aHeader,{"Cod.Cli."     ,"F2_CLIENTE","@!",6,0})				
		Aadd(aHeader,{"Nome Cliente" ,"A1_NOME"   ,"@!",25,0})				
		Aadd(aHeader,{"Valor NF"     ,"F2_VALMERC","@E 9,999,999.99",12,2})						
		Aadd(aHeader,{"Cod. Transp." ,"F2_TRANSP" ,"@!",6,0})
		Aadd(aHeader,{"Nome Transp." ,"A4_NOME"   ,"@!",20,0})												
		Aadd(aHeader,{"Cod.Vendedor" ,"F2_VEND1"  ,"@!",6,0})												
		Aadd(aHeader,{"Nome Vendedor","A3_NOME"   ,"@!",20,0})														
    
		Aadd(aCampos,{"F2_EMISSAO" ,"Emissao NF"   ,"@D"})
		Aadd(aCampos,{"F2_DOC"		,"Nota Fiscal"  ,"@!"})
		AAdd(aCampos,{"F2_MPEDIDO" ,"Pedido"       ,"@!"})
		Aadd(aCampos,{"F2_SERIE"   ,"Serie"        ,"@!"})
		Aadd(aCampos,{"F2_TIPO"    ,"Tipo"         ,"@!"})
		Aadd(aCampos,{"F2_CLIENTE" ,"Cod.Cli."     ,"@!"})
		Aadd(aCampos,{"A1_NOME"		,"Nome Cliente" ,"@!"})
		Aadd(aCampos,{"F2_VALMERC" ,"Valor NF"     ,"@E 9,999,999.99"})
		Aadd(aCampos,{"F2_TRANSP"  ,"Cod. Transp." ,"@!"})
		Aadd(aCampos,{"A4_NOME"    ,"Nome Transp." ,"@!"})
		Aadd(aCampos,{"F2_VEND1"	,"Cod.Vendedor" ,"@!"})
		Aadd(aCampos,{"A3_NOME"		,"Nome Vendedor","@!"})

		@ 010,005 TO 467,935 DIALOG oDlg30 TITLE "Notas Fiscais do Cliente: " + ALLTRIM(cedtClient) + " - " + GetAdvFVal("SA1","A1_NREDUZ",xFilial("SA1") + RTRIM(LTRIM(cedtClient)),1," ")

		oBrows30:=TcBrowse():New( 005,010 , 450,170, , , , oDlg30 ,"FLAG",,,,,,oDlg30:oFont,,,,, .F.,"TRB", .T.,, .F., , ,.f. )

		oBrows30:AddColumn( TCColumn():New( "",{ || U_ChkCorDev() },,,, "LEFT", 10, .T., .F.,,,, .T., ))

		For nX:=1 To Len( aCampos )
			oCol:=TCColumn():New( aCampos[nX][2],FieldWBlock(aCampos[nX][1], Select("TRB")),,,,,,.F.,.F.,,,,.F.,)
			oBrows30:ADDCOLUMN(oCol)

		Next
		
		@ 185,010 TO 225,380 LABEL " DEVOLU«’ES " COLOR CLR_HRED PIXEL OF oDlg30
		@ 185,385 TO 225,460 LABEL " Sair "      COLOR CLR_BLACK PIXEL OF oDlg30
      //BOT’ES
		@ 199,030 BUTTON "&DevoluÁ„o"           SIZE 66,15 PIXEL OF oDlg30 ACTION U_TELADEV()
		@ 199,150 BUTTON "&Historico DevoluÁ„o" SIZE 66,15 PIXEL OF oDlg30 ACTION U_HISDEV()
		@ 199,270 BUTTON "&Legenda"             SIZE 66,15 PIXEL OF oDlg30 ACTION U_LEG_DEV()

		@ 199,409 BMPBUTTON TYPE 2	ACTION EVAL({||oDlg30:End()})
				
		Activate Dialog oDlg30 CENTERED //ON INIT EnchoiceBar(oDlg30,{|| nOpc := 2,oDlg30:End()},{|| nOpc := 1,oDlg30:End()})
	
	   TRB->(DBCLOSEAREA())

	ElseIf nOpc == 2 // botao cancelar            

		Return     

	EndIf

RETURN ( .T. )


/*****************************/
STATIC Function HistEnc(_P1, _P2)
/*****************************/
Private oDlg, oMULTI
Private _lRet:=.T., _lRetorno:=.T., _cAlias:="", _nOrder:=0, _nLinAtu:= 0, _nLinha:=0  
_P1:=If( _P1 = Nil, "O", _P1 )
_cAlias    := Alias()
_nOrder    := IndexOrd()
aHeader    := {}
nUsado     := 0
Aadd(aHeader, { "DATA",			"ZZR_DATA",		"99/99/9999",	10,	0,	"1==1",	"ÄÄÄÄÄ0",	"C",	"",, } )
Aadd(aHeader, { "HORA",			"ZZR_HORA",		"!!!!!",			10,	0,	"1==1",	"ÄÄÄÄÄÄ",	"C",	"",, } )
Aadd(aHeader, { "ORIGEM",		"ZZR_ORIGEM",	"@!",				10,	0,	"1==1",	"ÄÄÄÄÄ0",	"C",	"",, } )
Aadd(aHeader, { "DESTINO",		"ZZR_DEST",		"@!",				10,	0,	"1==1",	"ÄÄÄÄÄ0",	"C",	"",, } )
Aadd(aHeader, { "OCORRENCIA", "ZZR_TIPO",		"@!",				20,	0,	"1==1",	"ÄÄÄÄÄÄ",	"C",	"",, } )

cQry:="SELECT "
cQry+=" * "
cQry+="FROM "
cQry+="	"+RetSqlName( "ZZR" )+" "
cQry+="WHERE "
cQry+="	ZZR_FILIAL='  ' "
cQry+="	AND ZZR_FASES='"+_P1+"' "
If _P1="O"
	cQry+="	AND ZZR_NUM='"+Scj->Cj_Num+"' "

Else
	If oDlgIMPNF:OCTLFOCUS:CALIAS='WK1'
		cQry+="	AND ZZR_NUM='"+Wk1->C5_Num+"' "

	ElseIf oDlgIMPNFoDlgIMPNF:OCTLFOCUS:CALIAS='WK2'
		cQry+="	AND ZZR_NUM='"+Wk2->Z0_Num+"' "

	ElseIf oDlgIMPNF:OCTLFOCUS:CALIAS='WK3'
		cQry+="	AND ZZR_NUM='"+Wk3->Z6_NPedCli+"' "

	ElseIf oDlgIMPNF:OCTLFOCUS:CALIAS='WK4'
		cQry+="	AND ZZR_NUM='"+Wk4->E1_Pedido+"' "

	EndIf

EndIf

cQry+="	AND D_E_L_E_T_=' ' "
cQry+="ORDER BY "
cQry+="	ZZR_DATA DESC, "
cQry+="	ZZR_HORA DESC "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQry),"WK5", .F., .T.)
TCSETFIELD( "WK5", "ZZR_DATA", "D", 8 )
DbSelectArea( "WK5" )
aCols:={}
While !WK5->(Eof())
   AAdd(aCols, { WK5->Zzr_Data, WK5->Zzr_Hora, WK5->Zzr_Origem, Wk5->Zzr_Dest, WK5->Zzr_Tipo, Wk5->Zzr_Obs, Wk5->Zzr_Num} )
   WK5->(DbSkip())

EndDo

WK5->(DbCloseArea())
If Len( aCols )=0
	MsgStop( "N„o ha nenhuma ocorrÍncia para esse OrÁamento...", "SEM MOVIMENTO " )
   Return .F.

EndIf

mMemo:=Msmm( aCols[1][6], 48 )

nUsado     := 1
nOpc:=0
cTitulo:="Ocorrencias do OrÁamento:"+aCols[1][7]
bOk:={||nOpc:=1, oDlg:End()}
bCancel:={||nOpc:=2, oDlg:End()}
While .t.
   @ 200,001 TO 450,1000 DIALOG oDlg TITLE cTitulo

   DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg

   DEFINE BUTTON RESOURCE "S4WB008N" OF oBar ;
              ACTION Calculadora() ;
              TOOLTIP "Calculadora"

   DEFINE BUTTON RESOURCE "S4WB010N" OF oBar ;
              ACTION OurSpool() ;
              TOOLTIP OemToAnsi("Gerenciador de Impressao")

   DEFINE BUTTON oBtnOk RESOURCE "OK" OF oBar GROUP ;
              ACTION (EVAL(bOk)) ;
              TOOLTIP "Ok - <Ctrl-O>"

   DEFINE BUTTON oBtnCan RESOURCE "CANCEL" OF oBar ;
       ACTION (EVAL(bCancel));
       TOOLTIP "Cancelar - <Ctrl-X>"

      @ 020,005 TO 125,240 MULTILINE Object oMULTI
      @ 12, 250 SAY "ObservaÁ„o" SIZE 32, 7 PIXEL
      @ 20, 245 Get mMemo  READONLY Size 210,105 MEMO COLOR CLR_WHITE,CLR_BLUE PIXEL
      oMulti:oBrowse:BSKIP:={ | NSKIP, NOLD | NOLD := OMULTI:OBROWSE:NAT, OMULTI:OBROWSE:NAT += NSKIP, OMULTI:OBROWSE:NAT := MIN( MAX( OMULTI:OBROWSE:NAT, 1 ), EVAL( OMULTI:OBROWSE:BLOGICLEN ) ), N := OMULTI:OBROWSE:NAT,U_TPOrc(OMULTI:OBROWSE:NAT-NOLD),OMULTI:OBROWSE:NAT-NOLD}

   ACTIVATE DIALOG oDlg CENTERED //VALID ValPosi(LASTKEY())

   If nOpc=1
      Exit

   ElseIf nOpc=2
      Exit

   EndIf

EndDo

Return .T.

/***********************/
Static Function VisuDev()
/***********************/
Posicione( "SZ6", 2, xFilial( "SZ6" )+Wk3->Z6_Numero, "" )

cCadastro := "Cadastro Devolucoes"
_cUsuario:=Substr(Upper(CUSUARIO),7,15)
_cInicio:=.F.
aRotina   := { { "Pesquisar"    ,"AxPesqui" 							  , 0, 1},;
	       		{ "Visualizar"   ,'ExecBlock("MILL_VIS",.F.,.F.)' , 0, 2},;  
	       		{ "Incluir"      ,'ExecBlock("MILL_INC",.F.,.F.)' , 0, 3},;                   
	       		{ "Alterar"      ,'ExecBlock("MILL_ALT",.F.,.F.)' , 0, 4},;
	       		{ "Imprimir"     ,'U_MILL_IMP()'                  , 0, 5},;                 
	       		{ "Confirma Dev.",'U_MILL_CON()' 					  , 0, 6},;
	       		{ "Cancela Dev." ,'U_MILL_CAN()' 					  , 0, 7},;
		   		{ "Autorizar"    ,'U_MILL_APR()' 					  , 0, 8},;                 
	       		{ "Excluir"      ,'ExecBlock("MILL_EXC",.F.,.F.)' , 0, 9},;
	       		{ "Cad. Observ." ,'U_MILL_OBS()' 					  , 0,10},;
	       		{ "Legenda"      ,'U_LEG_BRWD()' 					  , 0,11}}

ExecBlock("MILL_VIS",.F.,.F.)
Return .t.


/************************/
Static Function GetAtend()
/************************/ 
Local _cAte			:=""                           
Local lChkEncdo   := .F.

lGerente:=( AllTrim((_cAte:=GetAdvFVal( "SZV", "ZV_CODIGO", xFilial( "SZV" )+PswRet()[1][1], 2, " " )))==AllTrim(GetAdvFVal( "SZV", "ZV_CODGER", xFilial( "SZV" )+PswRet()[1][1], 2, " " )) )

aComboAt:={}

Szv->(DbGoTop())
Szv->(DbEval( {||Aadd( aComboAt, Szv->Zv_Codigo+"-"+Szv->Zv_Nome )}, {||if(!lGerente, AllTrim(Szv->Zv_Codigo)<>AllTrim(Szv->Zv_CodGer), .t.)} ))

cAt:=aComboAt[Ascan( aComboAt, {|z|SubStr(z,1,2)=_cAte} )]

nOpcAt:=0

DEFINE MSDIALOG oDlgAt TITLE "SeleÁ„o de Coordenador(a) para Filtro de IntenÁıes" FROM C(269),C(264) TO C(436),C(673) PIXEL
	@ C(029),C(027) Say "Coordenador(a):" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlgAt
	@ C(029),C(073) ComboBox cAt Items aComboAt Size C(100),C(010) PIXEL OF oDlgAt
	@ C(039),C(083) CheckBox oChkEncdo Var lChkEncdo Prompt "Mostra Encaminhados" Size C(050),C(008) COLOR CLR_HBLUE PIXEL  OF oDlgAt

	@ C(054),C(130) BMPBUTTON TYPE 1	ACTION EVAL({||nOpcAt:=1,oDlgAt:End()})

ACTIVATE MSDIALOG oDlgAt CENTERED 

If nOpcAt=1
	_cAte:=SubStr( cAt, 1, At("-", cAt)-1 )
	_cAteN:=SubStr( cAt, At("-", cAt)+1 )
	Encaminha := lChkEncdo
else //alterado por flavia, para nao abrir a tela de backoffice caso nao seja escolhido nenhum coordenador
    _cAte:=""
	_cAteN:=""

EndIf

Return _cAte

/**********************/
Static Function Consulta()
/**********************/
Local cNomeCli	 := Space(25)
Local oNomeCli
Local oBrwCli
Local _oDlg	
Local aAlter       	:= {""}
Local nSuperior    	:= C(009)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(030)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(095)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(306)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
Local nOpcC:=0

//GerTrb1()
While .t. 
	
	DEFINE MSDIALOG _oDlg TITLE "Consulta Clientes" FROM C(183),C(193) TO C(442),C(925) PIXEL
		oBrwCli:=TcBrowse():New( nSuperior, nEsquerda, nDireita, nInferior, , , , _oDlg ,"FLAG",,,,,,_oDlg:oFont,,,,, .F.,"TRB1", .T.,, .F., , ,.f. )
		oCol:=TCColumn():New( "A1_COD",FieldWBlock("A1_COD", Select("TRB1")),,,,,,.F.,.F.,,,,.F.,)
		oBrwCli:ADDCOLUMN(oCol)
		oCol:=TCColumn():New( "A1_NOME",FieldWBlock("A1_NOME", Select("TRB1")),,,,,,.F.,.F.,,,,.F.,)
		oBrwCli:ADDCOLUMN(oCol)
		OBrwCli:BlDblClick:={||nOpcC:=1, _oDlg:End()}
		// Cria Componentes Padroes do Sistema
		@ C(025),C(340) Button "Ok" Action Eval({||nOpcC:=1, _oDlg:End()}) Size C(025),C(012) PIXEL OF _oDlg
		@ C(045),C(340) Button "Cancelar" Action Eval({||nOpcC:=2, _oDlg:End()}) Size C(025),C(012) PIXEL OF _oDlg
		@ C(065),C(340) Button "Visualizar" Action Eval({||nOpcC:=3, _oDlg:End()}) Size C(025),C(012) PIXEL OF _oDlg
		@ C(110),C(030) Say "Nome:" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(110),C(055) MsGet oNomeCli Var cNomeCli Valid U_ChkPCli(cNomeCli) Size C(251),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	
	ACTIVATE MSDIALOG _oDlg CENTERED 
	
	If nOpcC=1
		Posicione( "SA1", 1, xFilial( "SA1" )+Trb1->A1_Cod, "A1_NOME" )
		m->Cj_Cliente:=Trb1->A1_Cod
	   RUNTRIGGER(1,,"",,"CJ_CLIENTE")
		Exit
	
	ElseIf nOpcC=2
		Exit
	
	ElseIf nOpcC=3
		Posicione( "SA1", 1, xFilial( "SA1" )+Trb1->A1_Cod, "A1_NOME" )
		Sa1->(U_Prospect("V"))

	EndIf

EndDo	

Trb1->(DbCloseArea())
Return(.T.)


/************************/
User Function ChkPCli(_P)
/************************/
Local lRet:=.t.

If _P<>Nil .And. !Empty( _P )
	lRet:=GerTrb1(_P)

EndIf

Return lRet

/**************************/
Static Function GerTrb1(_P)
/**************************/
Local cFile
Local cQry
cQry:= "SELECT "+chr(13)+chr(10)
cQry+= "	A1.A1_COD, "+chr(13)+chr(10)
cQry+= "	A1.A1_NOME "+chr(13)+chr(10)
cQry+= " "+chr(13)+chr(10)
cQry+= "FROM  "+chr(13)+chr(10)
cQry+= "	"+RetSqlName("SA1")+" A1 "+chr(13)+chr(10)
cQry+= " "+chr(13)+chr(10)
cQry+= "WHERE  "+chr(13)+chr(10)
cQry+= "	A1.A1_FILIAL='"+xFilial("SA1")+"' "
cQry+= "	AND A1.D_E_L_E_T_=' '  "+chr(13)+chr(10)
If _P<>Nil .And. !Empty( _P )
	cQry+= "	AND A1.A1_NOME LIKE '%"+AllTrim(StrTran(_P, "'", ""))+"%'  "+chr(13)+chr(10)

EndIf

If _lRepr 
	cQry+= "	AND A1.A1_VEND='"+_cVen+"' "

EndIf

cQry+= " "+chr(13)+chr(10)
cQry+= "ORDER BY "+chr(13)+chr(10)
cQry+= "	A1.A1_NOME "+chr(13)+chr(10)

If Select( "TRB1" )>0
	Trb1->(DbCloseArea())

EndIf

DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "TRB1", .F., .F.)
cFile:=CriaTrab(,.f.)
DbSelectArea( "TRB1" )
Copy To (cFile)
Trb1->(DbCloseArea())
DbUseArea( .t., "DBFCDX", cFile, "Trb1" )

If Trb1->(RecCount())=0
	MsgStop( "N„o existe cliente com esse conteudo no nome ...", "Pesquisa vazia" )
	Return .f.

ElseIf Trb1->(RecCount())=1
	Posicione( "SA1", 1, xFilial( "SA1" )+Trb1->A1_Cod, "A1_NOME" )
	m->Cj_Cliente:=Trb1->A1_Cod
   RUNTRIGGER(1,,"",,"CJ_CLIENTE")
	Return .t.

ElseIf Trb1->(RecCount())>1
	Consulta()

EndIf

Return Nil

/***********************/
User Function ChCorLn(_P)
/***********************/
nCor:=CLR_WHITE
If Wk2->Z0_QtdAtu>Wk2->Z0_QtdVen
	nCor:=CLR_BLUE

ElseIf Wk2->Z0_QtdAtu<Wk2->Z0_QtdVen
	nCor:=CLR_YELLOW

ElseIf Wk2->Z0_QtdAtu=0 .And. Wk2->Z0_QtdVen<>0
	nCor:=CLR_RED

ElseIf Wk2->Z0_QtdAtu<>0 .And. Wk2->Z0_QtdVen=0
	nCor:=CLR_GREEN

EndIf

Retur nCor

