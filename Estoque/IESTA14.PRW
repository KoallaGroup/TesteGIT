#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH" 

/*
+------------+---------+--------+-------------------------------------+-------+--------------+
| Programa:  | IESTA14 | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Novembro/2014|
+------------+---------+--------+-------------------------------------+-------+--------------+
| Descrição: | Ajuste de Estoque															 |
+------------+-------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa												                 |
+------------+-------------------------------------------------------------------------------+
*/

User Function IESTA14()    //  U_IESTA14()
Local aCores

Private _cFil := cFilAnt 
Private cCadastro := "Ajuste de Estoque", cString := "SZZ"
Private aRotina   := {	{"Pesquisar" 	,"AxPesqui"	   ,0,1},;    
						{"Visualizar" 	,"U_IESTA14A(2)",0,2},;
					 	{"Incluir"		,"U_IESTA14A(3)",0,3},;
					  	{"Alterar"		,"U_IESTA14A(4)",0,4},;
					  	{"Excluir"		,"U_IESTA14A(5)",0,5},;
					  	{"Efetivar"		,"U_IESTA14A(6)",0,6}}
DbSelectArea("SZZ")

	 aCores		:= {{	"Empty(ZZ_STATUS)"   , "BR_VERDE"	}, ;	    //  Não Efetivado
					{	"!Empty(ZZ_STATUS)"	 , "BR_VERMELHO"	} } 	//  Efetivado
DbSetOrder(1)
DbGoTop()

mBrowse(6,1,22,75,"SZZ"      ,       ,        ,,,,aCores)

Return                   


/*
+------------+----------+--------+------------------------------------+-------+---------------+
| Programa:  | IESTA14A | Autor: | Silverio Bastos - Anadi Soluções   | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------+-------+---------------+
| Descrição: | Getdados do Ajuste de Estoque						                          |
+------------+--------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa 			    												  |
+------------+--------------------------------------------------------------------------------+
*/

User Function IESTA14A(nOpcx)
Local aArea		:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}
Local _cDoc 	:= IIF(nOpcx == 3,Criavar("ZZ_DOC"),SZZ->ZZ_DOC), _dDtEmis := IIF(nOpcx == 3,dDataBase,SZZ->ZZ_EMISSAO)
Local nLinha 	:= nLin02 := nOpca := 0, oDlg
Local cSeek		:= IIF(nOpcx == 3,"",SZZ->ZZ_FILIAL + SZZ->ZZ_DOC + DTOS(SZZ->ZZ_EMISSAO)), cWhile := IIF(nOpcx == 3,"","SZZ->ZZ_FILIAL + SZZ->ZZ_DOC + dtos(SZZ->ZZ_EMISSAO)")
Private _cLocal := IIF(nOpcx == 3,Criavar("ZZ_LOCAL"),SZZ->ZZ_LOCAL), _cTM	 	:= IIF(nOpcx == 3,Criavar("ZZ_TM"),SZZ->ZZ_TM), _cTMEntrada	 	:= IIF(nOpcx == 3,Criavar("ZZ_TM"),SZZ->ZZ_TM)
Private _cLocalD  := IIF(nOpcx == 3,Criavar("ZZ_LOCDEST"),SZZ->ZZ_LOCDEST), _nOpcao := nOpcx

Private oGet
//Monta a entrada de dados do arquivo
Private aTela[0][0],aGets[0],aHeader[0]
Private   zFilial		:= zDoc	:= ""
               
//Validações ao efetivar um ajuste de estoque - Rubens Cruz - Março/2015
if nOpcx = 6 
	Do Case
		Case !EMPTY(SZZ->ZZ_STATUS)
			MSGALERT("Registro já Efetivado.")
			Return
		Case (SZZ->ZZ_EMISSAO < GetMV("MV_ULMES"))
			MSGALERT("Data do registro anterior ao último fechamento")
			Return
	EndCase
endif

/* Jorge H - Anadi - Controle de numeração feito pelo GETSXENUM
if nOpcx = 3
	_cDoc := STRZERO(VAL(GETMV("MV_IESTA14")) + 1, 9, 0)
	MSGALERT("Preencher [Local Destino] ou [TM Saida]. Não Preencher ambos simultaneamente." + CHR(10) + CHR(13) + ;
	      "TRANSFERÊNCIA - Preencher Local Origem e Local Destino. Não Preencher TM Saída. " + CHR(10) + CHR(13) + ;
	      "REQUISIÇÃO / DEVOLUÇÃO - Preencher Local Origem e TM - Tipo de Movimentação"  )
	PutMv("MV_IESTA14",_cDoc )
endif
*/

//Cria aHeader e aCols
FillGetDados(nOpcx,;
				"SZZ",;
				1,;
				cSeek,;
				{|| &cWhile },;
				{||.T.},;
				{ "ZZ_FILIAL", "ZZ_DOC", "ZZ_TM", "ZZ_LOCAL", "ZZ_LOCDEST", "ZZ_EMISSAO", "ZZ_TMENTRA" },;
				{ "ZZ_ITEM", "ZZ_COD", "ZZ_DSCCOD", "ZZ_UM", "ZZ_QUANT" },;
				/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.)				
				                                               
If(nOpcx = 3)
	zFilial := cFilAnt
	zDoc	:= GetSxENum("SZZ","ZZ_DOC",1)
Else
	zFilial := SZZ->ZZ_FILIAL
	zDoc	:= SZZ->ZZ_DOC
EndIf


aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,015,.t.,.f.})
AAdd(aObjects,{100,100,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aPosObj := MsObjSize(aInfo, aObjects)

nLinha  := aPosObj[1,1] + 4
nLin02  := aPosObj[1,1] + 2               //    1   2   3   4   5   6   7   8   9   10  11  12  13  14
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,015,035,045,075,090,133,160,190,210,240,260,300,340} } )

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

@nLinha, aPosGet[1,01] Say "Filial" 		SIZE 20, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,02] MSGET zFilial		PICTURE PesqPict("SZZ","ZZ_FILIAL",TamSX3("ZZ_FILIAL")[1])  When .f. SIZE 30,10 OF oDlg PIXEL
@nLinha, aPosGet[1,03] Say "Doc"			SIZE 10, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,04] MSGET _cDoc			PICTURE PesqPict("SZZ","ZZ_DOC",TamSX3("ZZ_DOC")[1])  When (nOpcx == 3 .And. Empty(aCols[n][2])) Valid ExistChav("SZZ",_cDoc) SIZE 30,10 OF oDlg PIXEL
@nLinha, aPosGet[1,05] SAY "Emissao"		SIZE 45, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,06] MSGET _dDtEmis 		PICTURE PesqPict("SZZ","ZZ_EMISSAO",TamSX3("ZZ_EMISSAO")[1])  When (nOpcx == 3 .And. Empty(aCols[n][2])) SIZE 45,10 OF oDlg PIXEL

@nLinha, aPosGet[1,07] Say "Local Origem" 	SIZE 45, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,08] MSGET _cLocal		PICTURE PesqPict("SZZ","ZZ_LOCAL",TamSX3("ZZ_LOCAL")[1]) F3 "NNR" When (nOpcx == 3 .And. Empty(aCols[n][2])) Valid IESTA14VLO(_cLocal,_cLocalD) SIZE 30,10 OF oDlg PIXEL

@nLinha, aPosGet[1,09] Say "Local Destino"	SIZE 45, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,10] MSGET _cLocalD		PICTURE PesqPict("SZZ","ZZ_LOCDEST",TamSX3("ZZ_LOCDEST")[1]) F3 "NNR" When (nOpcx == 3 .And. Empty(aCols[n][2]) .And. Empty(_cTM)) Valid IESTA14VLD(_cLocal,_cLocalD) SIZE 30,10 OF oDlg PIXEL

@nLinha, aPosGet[1,11] Say "TM Saída" 		SIZE 25, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,12] MSGET _cTM			PICTURE PesqPict("SZZ","ZZ_TM",TamSX3("ZZ_TM")[1])  F3 "SF5A" When (nOpcx == 3 .And. Empty(aCols[n][2]) .And. Empty(_cLocalD)) Valid IESTA14VTM(_cTM) SIZE 30,10 OF oDlg PIXEL

// @nLinha, aPosGet[1,13] Say "TM Entrada"		SIZE 30, 10 OF oDlg PIXEL
// @nLin02, aPosGet[1,14] MSGET _cTMEntrada	PICTURE PesqPict("SZZ","ZZ_TM",TamSX3("ZZ_TM")[1])  F3 "SF5" When (nOpcx == 3) SIZE 30,10 OF oDlg PIXEL

//oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,,,"+ZZ_ITEM",,,,,,"U_IESTA14H") - Jorge - Anadi
oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,,,"+ZZ_ITEM",nOpcx == 3 .Or. nOpcx == 4)     
//oGetDados := MsGetDados():New(05, 05, 145, 195, 4, "U_LINHAOK", "U_TUDOOK", "+A1_COD", .T., {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)

If nOpcx == 3
	aCols[1][aScan(aHeader,{|x| Trim(x[2]) == "ZZ_ITEM"})] := StrZero(1,TamSX3("ZZ_ITEM")[1])
EndIf

ACTIVATE MSDIALOG oDlg On Init IESTA14B(oDlg,{||nOpca:=1, if(oGet:TudoOk() .And. ValidaT(),oDlg:End(),nOpca := 0)}, {||oDlg:End()},nOpcx)


	If nOpca == 1 .And. nOpcx > 2  
	
	    DbSelectArea("SZZ")
	    Set Filter To
	    
		If nOpcx == 6  // Efetivaçao -- Gravar a Movimentação SD3
	//		set filter to ZZ_DOC = zDoc 
	//		DbGoTop()
	//		While !eof()
	//			aAreaSZZ   := GetArea()
				IESTA14I(zFilial,zDoc)
	//			IESTA14I(ZZ_FILIAL ,ZZ_DOC, ZZ_EMISSAO, ZZ_COD ,ZZ_TM ,ZZ_LOCAL ,ZZ_LOCDEST ,ZZ_QUANT )				    	
	//			RESTAREA(aAreaSZZ)
	//			DbSkip()
	//		Enddo
	//		set filter to
		Else
			If !IESTA14G(nOpcx,zFilial,_cDoc,_dDtEmis,_cTM,_cLocal,_cLocalD)
				MsgStop("Falha na gravação dos dados","ATENCAO")
			EndIf
		Endif	
	    DbSelectArea("SZZ")
	    Set Filter To &_cFil
	
	EndIf
	
//Restaura a integridade da janela               
RestArea(aArea)

Return

/*
+------------+----------+--------+-------------------------------------+-------+---------------+
| Programa:  | ValidaT  | Autor: | Jose Augusto F. P. Alves - Anadi    | Data: | Novembro/2014 |
+------------+----------+--------+-------------------------------------+-------+---------------+
| Descrição: | Valida campos preenchidos														   |
+----------------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa          			                                           |
+------------+---------------------------------------------------------------------------------+
*/

Static Function ValidaT() 
_lRt := .F.     

If Empty(Alltrim(_cLocalD)) .Or. Empty(Alltrim(_cTM)) 
	If  Empty(Alltrim(_cLocal))
		MsgStop("Favor preencher LOCAL ORIGEM!","ATENCAO")
	Else
 		_lRt := .T.
 	EndIf
Else
	MsgStop("Selecionar apenas uma opcao (LOCAL DESTINO OU TM SAIDA)","ATENCAO")
EndIf

Return _lRt

/*
+------------+----------+--------+-------------------------------------+-------+---------------+
| Programa:  | IESTA14B | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Novembro/2014 |
+------------+----------+--------+-------------------------------------+-------+---------------+
| Descrição: | Montagem da EnchoiceBar														   |
+----------------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa          			                                           |
+------------+---------------------------------------------------------------------------------+
*/

Static Function IESTA14B(oDlg,bOk,bCancel,nOpc)
Local aButtons   := {}
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))    


/*
+------------+----------+--------+-------------------------------------+-------+---------------+
| Programa:  | IESTA14E | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Novembro/2014 |
+------------+----------+--------+-------------------------------------+-------+---------------+
| Descrição: | Validacao do saldo em estoque														   |
+----------------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa          			                                           |
+------------+---------------------------------------------------------------------------------+
*/
//User Function IESTA14E(__cFilial, __cCod, __cLoc, __nQtde) Jorge - Anadi
User Function IESTA14E()
Local _nProd := aScan(aHeader,{|x| Trim(x[2]) == "ZZ_COD"})
Local _xcFil := zFilial //cFilAnt
Local _xcCod := aCols[n][_nProd]
Local _xcLoc := _cLocal
Local _xnQtde:= M->ZZ_QUANT
Local _xQtSld:= 0
Local __lRet := .T.
Local _nPRec := aScan(aHeader, { |x| AllTrim(x[2]) == "ZZ_REC_WT" }) 

If _xnQtde <= 0
    MsgAlert("Quantidade invalida")
    Return .f.
EndIf

If _cTM > "500"  .Or. !Empty(_cLocalD)
    _xQtSld	:= U_xSldProd(_xcFil,_xcCod,_xcLoc)
    
    //Se for alteração, a quantidade anterior do registro deve compor o saldo disponível (para não debitar 2 vezes)
    If _nOpcao == 4
    	If aCols[n][_nPRec] > 0
    		DbSelectArea("SZZ")
    		DbGoTo(aCols[n][_nPRec])
    		_xQtSld += SZZ->ZZ_QUANT
    	EndIf
    EndIf
    
    If _xQtSld < _xnQtde .and. _xnQtde > 0 
    	MsgAlert("Quantidade maior que a disponivel  (" + AllTrim(Str(_xQtSld)) + ") ","SALDO!!!")
    	__lRet := .F.
    Endif
EndIf

Return(__lRet)               

/*
+------------+----------+--------+-------------------------------------+-------+---------------+
| Programa:  | IESTA14G | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Novembro/2014 |
+------------+----------+--------+-------------------------------------+-------+---------------+
| Descrição: | Rotina auxiliar para gravar a inclusão, alteração ou exclusão                   |
+------------+---------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa       			                                               |
+------------+---------------------------------------------------------------------------------+
*/

Static Function IESTA14G(nOpcx,_cFil,_cDoc,_dDtEmis,_cTM,_cLocal,_cLocalD)
Local _lRet := .f., _aArea := GetArea(), nx := ny := 0, _cMay := "", _lChange := .f., _cDocOld := _cDoc
Local _nPRec := aScan(aHeader, { |x| AllTrim(x[2]) == "ZZ_REC_WT" }) 

//Acerta as quantidades em processamento
If nOpcx == 3 .Or. nOpcx == 4 //Incluir
                         
	For ix:= 1 to Len(aCols)       
        
        If !(aCols[ix][Len(aHeader) + 1])
    		__cProd := aCols[ix][2]	// Produto
    		__nQtde	:= aCols[ix][5]	// Qtde
    		
    		If aCols[ix][_nPRec] > 0
                DbSelectArea("SZZ")
                DbGoTo(aCols[ix][_nPRec])
            EndIf
    				  
    		If Empty(_cLocalD)
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If !dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)
    				CriaSB2(__cProd,_cLocal)
    			EndIf
    			
    			While !Reclock("SB2",.f.)
    			EndDo
    			If _cTM >= '501' // Saida	
    				If nOpcx == 3      // Incluir
    					SB2->B2__SAIPRC := SB2->B2__SAIPRC + __nQtde
    				Else               // Alterar
    					If aCols[ix][_nPRec] > 0
    						SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
    					EndIf
    					SB2->B2__SAIPRC := SB2->B2__SAIPRC + __nQtde					
    				EndIf
    			Else
    				if nOpcx == 3      // Incluir					
    					SB2->B2__ENTPRC := SB2->B2__ENTPRC + __nQtde
    				else               // Alterar
        				If aCols[ix][_nPRec] > 0
            				SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
                		EndIf    						
    					SB2->B2__ENTPRC := SB2->B2__ENTPRC + __nQtde
    				endif
    			Endif
    			SB2->(MsUnlock())
    		Else
    		
    			// Transferencia
    			// Local Destino
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If !dbSeek(xFilial("SB2") + __cProd + _cLocalD,.f.)
    				CriaSB2(__cProd,_cLocalD)
    			EndIf
    			
    			While !Reclock("SB2",.f.)
    			EndDo
    			if nOpcx == 3      // Incluir					
    				SB2->B2__ENTPRC := SB2->B2__ENTPRC + __nQtde
    			else               // Alterar
    				If aCols[ix][_nPRec] > 0
    					SB2->B2__ENTPRC := SB2->B2__ENTPRC - SZZ->ZZ_QUANT
    				EndIf
    				SB2->B2__ENTPRC := SB2->B2__ENTPRC + __nQtde
    			endif
    			SB2->(MsUnlock())
    			
    			// Local Origem				
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)
    				CriaSB2(__cProd,_cLocal)
    			EndIf
    			
    			While !Reclock("SB2",.f.)
    			EndDo
    			if nOpcx == 3      // Incluir					
    				SB2->B2__SAIPRC := SB2->B2__SAIPRC + __nQtde
    			else               // Alterar
    				If aCols[ix][_nPRec] > 0
    					SB2->B2__SAIPRC := SB2->B2__SAIPRC - SZZ->ZZ_QUANT
    				EndIf
    				SB2->B2__SAIPRC := SB2->B2__SAIPRC + __nQtde
    			endif
    			SB2->(MsUnlock())
    		Endif
    		                           
		ElseIf aCols[ix][Len(aHeader) + 1] .And. aCols[ix][_nPRec] > 0
		
    		__cProd := aCols[ix][2]	// Produto
    		__nQtde	:= aCols[ix][5]	// Qtde
    		
    		If aCols[ix][_nPRec] > 0
                DbSelectArea("SZZ")
                DbGoTo(aCols[ix][_nPRec])
            EndIf
		
    		If Empty(_cLocalD)
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)    			
    				While !Reclock("SB2",.f.)
    				EndDo
    				If _cTM >= '501' // Saida	
    					SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
    				Else
        				SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
    				Endif
    				MsUnlock()
    			EndIf
    			
		    Else
    			
    			//Local destino
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + __cProd + _cLocalD,.f.)
    				While !Reclock("SB2",.f.)
    				EndDo
					SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
    				SB2->(MsUnlock())
    			EndIf
    			
    			//Local Origem
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)
    				While !Reclock("SB2",.f.)
    				EndDo
					SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
    				SB2->(MsUnlock())
    			EndIf
    			
			EndIf
		EndIf	
		dbSelectArea("SZZ")
		
	Next ix	
	
    If nOpcx == 3
	    ConfirmSX8()
	EndIf
    
ElseIf nOpcx == 5 //Exclusão

	For ix:= 1 to Len(aCols)       
	
		If aCols[ix][_nPRec] > 0
			DbSelectArea("SZZ")
			DbGoTo(aCols[ix][_nPRec])

    		__cProd := aCols[ix][2]	// Produto
    		__nQtde	:= aCols[ix][5]	// Qtde
		
			If Empty(_cLocalD)
	  			dbSelectArea("SB2")
	    		dbSetOrder(1)
	    		If dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)    			
					While !Reclock("SB2",.f.)
	    			EndDo
	    			If _cTM >= '501' // Saida	
	    				SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
	    			Else
	       				SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
	    			Endif
	    			MsUnlock()
	    		EndIf
		    Else
	    			
				//Local destino
	   			dbSelectArea("SB2")
	    		dbSetOrder(1)
	    		If dbSeek(xFilial("SB2") + __cProd + _cLocalD,.f.)
	    			While !Reclock("SB2",.f.)
	    			EndDo
					SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
	    			SB2->(MsUnlock())
	    		EndIf
	    			
	    		//Local Origem
	    		dbSelectArea("SB2")
	    		dbSetOrder(1)
	    		If dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)
	    			While !Reclock("SB2",.f.)
	    			EndDo
					SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
	    			SB2->(MsUnlock())
	    		EndIf
	    			
			EndIf
		
		EndIf
    Next ix 
EndIf

//Faz a Gravação dos dados
For nx := 1 To Len(aCols)

	If (aCols[nx][Len(aHeader) + 1] .Or. nOpcx == 5) .And. nOpcx > 3 .And. aCols[nx][_nPRec] > 0
		DbSelectArea("SZZ")
		DbGoTo(aCols[nx][_nPRec])
		While !Reclock("SZZ",.f.)
		EndDo
		DbDelete()
		MsUnlock()
		_lRet := .t.		
	Else
		If aCols[nx][_nPRec] > 0
			DbSelectArea("SZZ")
			DbGoTo(aCols[nx][_nPRec])		
			While !Reclock("SZZ",.f.)
			EndDo
		Else			
			While !Reclock("SZZ",.t.)
			EndDo				
			SZZ->ZZ_FILIAL	:= _cFil
			SZZ->ZZ_DOC		:= _cDoc
			SZZ->ZZ_EMISSAO := _dDtEmis
			SZZ->ZZ_TM		:= _cTM
			SZZ->ZZ_LOCAL   := _cLocal
			SZZ->ZZ_LOCDEST := _cLocalD
		EndIf
		For ny := 1 To Len(aHeader)
			FieldPut(FieldPos(aHeader[ny][2]), aCols[nx][ny])
		Next ny			
		MsUnlock()
		_lRet := .t.

	EndIf
Next

RestArea(_aArea)
Return _lRet

/*
+------------+----------+--------+-------------------------------------+-------+---------------+
| Programa:  | IESTA14H | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Dezembro/2014 |
+------------+----------+--------+-------------------------------------+-------+---------------+
| Descrição: | Validacao do Campos no GETDADOS												   |
+----------------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa          			                                           |
+------------+---------------------------------------------------------------------------------+
*/
User Function IESTA14H()
Local __cFilial := _cFil        // aCols[n][1]
Local __cProdut := aCols[n][2]
Local __cLocal  := _cLocal
Local __nQtde	:= 0
Local __lRetx	:= .T.

If oGet:OBROWSE:COLPOS == 5 // Qtde

	__nQtde := M->ZZ_QUANT
	
	If __nQtde > 0 .and. _cTM >= '500'
		__lRetx := U_IESTA14E(__cFilial, __cProdut, __cLocal, __nQtde)
	Endif

Endif
Return(__lRetx)
                                      

/*
+------------+----------+--------+-------------------------------------+-------+---------------+
| Programa:  | IESTA14I | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Dezembro/2014 |
+------------+----------+--------+-------------------------------------+-------+---------------+
| Descrição: | Grava Movimentacao Interna ou Transferencia entre armazens							   |
+----------------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa          			                                           |
+------------+---------------------------------------------------------------------------------+
*/

Static Function IESTA14I(_cFilial,_cDoc) //_cFilial,_cDoc,_dData,_cProd,_cTM,_cLocOr,_cLocDe,_nQtde)

Local aCab			:= {}
Local aItem 		:= {}
//Local cTM 			:= _cTM
Local nOpcAuto		:= 3
//Local cDoc			:= ""
//Local cArm			:= _cLocOr       
//Local nQtd			:= _nQtde
//Local cArmDe		:= _cLocDe 
Local cFilAux		:= cFilAnt

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

dbSelectArea("SD3")
cDoc	:= GetSxENum("SD3","D3_DOC",1)

dbSelectArea("SZZ")
dbSetOrder(1)
DbSeek(_cFilial + _cDoc)
                 
cFilAnt := SZZ->ZZ_FILIAL 

Begin Transaction

	If Empty(SZZ->ZZ_LOCDEST)

		aCab 	:= {}
		aItem 	:= {}

		aCab := {	{"D3_DOC"    	, cDoc					,  	Nil},;
					{"D3_TM"     	, SZZ->ZZ_TM  			,  	Nil},;
					{"D3_CC"     	, " "       			,  	Nil},;
					{"D3_EMISSAO"	, Date()	 		 	,  	Nil}}

		Do While(_cFilial+_cDoc == SZZ->ZZ_FILIAL+SZZ->ZZ_DOC)
			aadd(aItem,{{"D3_TM"      	, SZZ->ZZ_TM		,  	Nil},;
						{"D3_COD"      	, SZZ->ZZ_COD   	,  	Nil},;
						{"D3_UM"        , SZZ->ZZ_UM		,  	Nil},;
						{"D3_QUANT"     , SZZ->ZZ_QUANT   	,  	Nil},;
						{"D3_LOCAL"     , SZZ->ZZ_LOCAL 	,  	Nil},;
						{"D3_EMISSAO"	, Date()	 		,  	NIL}})
			DbSkip()
		EndDo
		
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem,nOpcAuto)

	Else
     
		_aLinha 	:= {{ cDoc, Date() }}

		Do While(_cFilial+_cDoc == SZZ->ZZ_FILIAL+SZZ->ZZ_DOC)
			DbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(xFIlial("SB1")+SZZ->ZZ_COD)
				aadd(_aLinha, {SB1->B1_COD 											,;
								SB1->B1_DESC										,;
								SB1->B1_UM										  	,;
								SZZ->ZZ_LOCAL				                      	,;
								CriaVar("D3_LOCALIZ",.F.) 							,;
								SB1->B1_COD						              		,;
								SB1->B1_DESC										,;
								SB1->B1_UM										  	,;
								SZZ->ZZ_LOCDEST				                      	,;
								CriaVar("D3_LOCALIZ",.F.) 							,;
								CriaVar("D3_NUMSERI",.F.) 							,;
								""                         							,;
								CriaVar("D3_NUMLOTE",.F.) 							,;
								CriaVar("D3_DTVALID",.F.) 							,;
								CriaVar("D3_POTENCI",.F.) 							,;
								SZZ->ZZ_QUANT										,;
								CriaVar("D3_QTSEGUM",.F.) 							,;
								CriaVar("D3_ESTORNO",.F.) 							,;
								CriaVar("D3_NUMSEQ",.F.)  							,;
								""                        							,;
								CriaVar("D3_DTVALID",.F.) 							,;
								CriaVar("D3_ITEMGRD",.F.) })
			Else
				Alert("Produto " + SZZ->ZZ_COD + " não encontrado")
				Return
			EndIf
		                    	
			SZZ->(DbSkip())
		EndDo

		msExecAuto({|x,Y| Mata261(x,Y)},_aLinha,3)
	Endif	

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		RollBackSX8()
	else
		dbSelectArea("SZZ")
		dbSetOrder(1)
		DbGoTop()
		DbSeek(_cFilial + _cDoc)
		While !Eof() .And. (_cFilial+_cDoc == SZZ->ZZ_FILIAL+SZZ->ZZ_DOC)
			Reclock("SZZ",.F.)	
				SZZ->ZZ_STATUS := "1"				
				SZZ->ZZ_CODSD3 := cDoc
			SZZ->(MsUnlock())
			
			//Atualiza as quantidades em proessamento
    		If Empty(SZZ->ZZ_LOCDEST)
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + SZZ->ZZ_COD + SZZ->ZZ_LOCAL)    			
    				While !Reclock("SB2",.f.)
    				EndDo
    				If SZZ->ZZ_TM >= '501' // Saida	
    					SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
    				Else
        				SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
    				Endif
    				MsUnlock()
    			EndIf
    			
		    Else
    			
    			//Local destino
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + SZZ->ZZ_COD + SZZ->ZZ_LOCDEST,.f.)
    				While !Reclock("SB2",.f.)
    				EndDo
					SB2->B2__ENTPRC := (SB2->B2__ENTPRC - SZZ->ZZ_QUANT)
    				SB2->(MsUnlock())
    			EndIf
    			
    			//Local Origem
    			dbSelectArea("SB2")
    			dbSetOrder(1)
    			If dbSeek(xFilial("SB2") + SZZ->ZZ_COD + SZZ->ZZ_LOCAL,.f.)
    				While !Reclock("SB2",.f.)
    				EndDo
					SB2->B2__SAIPRC := (SB2->B2__SAIPRC - SZZ->ZZ_QUANT)
    				SB2->(MsUnlock())
    			EndIf
    			
			EndIf

			
			DbSelectArea("SZZ")
			DbSkip()
		EndDo
		//ConfirmSX8()
	EndIf

End Transaction

cFilAnt := cFilAux 

Return


user function IESTA14V()
    local _lRet := .T.
   
	if Inclui .and. M->ZZ_QUANT > 0
		__cProd := aCols[n][2]	// Produto
		__nQtde	:= M->ZZ_QUANT	// Qtde		  
	
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2") + __cProd + _cLocal,.f.)
			
			nSaldo := SaldoSb2() 
			
			if nSaldo < M->ZZ_QUANT		
				nSaldo := Transform(SaldoSb2(),"@E 9,999,999.99")			
				alert ("O Saldo disponivel desse produto, no armazem selecionado, é de : " + nSaldo)
				_lRet := .F.
			endif
	
		endif
	endif
return _lRet


//valida o armazem de origem
Static Function IESTA14VLO(_cLocOri,_cLocDest)

If !ExistCpo("NNR",_cLocOri)
	Return .f.
EndIf

If !Empty(_cLocDest) .And. _cLocOri == _cLocDest
	MsgAlert("Os Locais de origem e destino devem ser diferentes","ATENCAO")
	Return .f.
EndIf

If Empty(_cLocOri)
	MsgAlert("O Local de origem não pode ficar em branco","ATENCAO")
	Return .f.
EndIf

If _cLocOri $ Alltrim(GetMv("MV__ARMVEN")) .And. _cLocDest $ Alltrim(GetMv("MV__ARMVEN"))
	MsgAlert("Não permitida transferência entre os locais " + _cLocOri + " e " + _cLocDest,"TRANSFERENCIA NAO PERMITIDA")
	Return .f.
EndIf

Return .t.

//Valida o armazem destino
Static Function IESTA14VLD(_cLocOri,_cLocDest)

If !Empty(_cLocDest)
	If _cLocOri == _cLocDest
		MsgAlert("Os Locais de origem e destino devem ser diferentes","ATENCAO")
		Return .f.
	EndIf
	
	If !ExistCpo("NNR",_cLocDest)
		Return .f.
	EndIf
EndIf

If _cLocOri $ Alltrim(GetMv("MV__ARMVEN")) .And. _cLocDest $ Alltrim(GetMv("MV__ARMVEN"))
	MsgAlert("Não permitida transferência entre os locais " + _cLocOri + " e " + _cLocDest,"TRANSFERENCIA NAO PERMITIDA")
	Return .f.
EndIf

Return .t.


//Valida ao tipo de movimentação
Static Function IESTA14VTM(_cTpMov)

If !ExistCpo("SF5",_cTpMov)
	Return .f.
EndIf

Return .t.