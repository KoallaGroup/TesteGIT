#include "protheus.ch"
#include "topconn.ch"


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMA03			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : VIRADA DE TES - Ação Relacionada na Nota de Entrada					  			|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA03(cAlias,nReg,nOpc)

	Local nX           := 0
	Local nUsado       := 0
	Local aButtons     := {}
	Local aCpoEnch     := { 'NOUSER' }
	Local cAliasE      := cAlias
	Local aAlterEnch   := {}
	Local aPos         := {000,000,080,1000}
	Local nModelo      := 3
	Local lF3          := .F.
	Local lMemoria     := .T.
	Local lColumn      := .F.
	Local caTela       := ""
	Local lNoFolder    := .F.
	Local lProperty    := .F.
	Local aCpoGDa      := {}, _dDataFec := CTOD("  /  /  ")
	Local cAliasGD     := "SD1"
	Local nSuperior    := 030
	Local nEsquerda    := 000
	Local nInferior    := 230
	Local nDireita     := 603
	Local cLinOk       := "AllwaysTrue"
	Local cTudoOk      := "AllwaysTrue"
	Local cIniCpos     := "D1_ITEM"
	Local nFreeze      := 000
	Local nMax         := 999
	Local cFieldOk     := "AllwaysTrue"
	Local cSuperDel    := ""
	Local cDelOk       := "AllwaysFalse"
	Local aHeader      := {}
	Local aCols        := {}  
	Local aColsD		:= {}
	Local aColsC		:= {}
	Local aAlterGDa    := {}, _aParam := {"","ZZZ"}, _lAtuB2 := .f.
	Local cAliasOrg	:= GetArea()
	Local _cFilAtu  := cFilAnt
	Private _oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	
    _dDataFec := If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))
    If _dDataFec >= Date()
        Help( " ", 1, "FECHTO" )
        Return
    EndIf

	if SF1->F1_FORMUL == "S"   
		if !(SF1->F1_TIPO) $ "N-D"
			msgAlert ("Somente Notas tipo Normal ou Devolução podem usar essa opção !!")	
			return
		else
			If SF1->F1_TIPO = "N" .AND. SF1->F1_EST <> "EX"	
				msgAlert ("Somente Notas de Importação e do tipo Normal podem usar essa opção !!")	
				return
			Endif			
		endif
		
		//Comentado por Rubens em 23/03/15
		/*
		if !empty(SF1->F1__DTVTES)
			msgAlert("Já houve virada de TES para essa Nota !!")	
			return
		else */
			if SF1->F1__WMSRET <> "1"
				msgAlert("Aguardar Retorno Processo WMS!!")	
				return			
			endif
		//endif
	Else
		msgAlert ("Rotina apenas para Formulário Próprio e NF Tipo Normal ou Devolução !!")	
		return		
	Endif	

	// Adiciona os Campos da SF1 no cabeçalho.

	AADD(aCpoEnch,"F1_DOC") 
	AADD(aCpoEnch,"F1_SERIE") 
	AADD(aCpoEnch,"F1_FORNECE") 
	
	// Adiciona os Campos da SD1 no GetDados
	
	AADD(aCpoGDa,"D1_ITEM")
	AADD(aCpoGDa,"D1_COD")
	AADD(aCpoGDa,"D1_XDESCR")
	AADD(aCpoGDa,"D1_TES")
	AADD(aCpoGDa,"D1_CF")
	AADD(aCpoGDa,"D1_CLASFIS")
	AADD(aCpoGDa,"D1_BASIMP5")
	AADD(aCpoGDa,"D1_BASIMP6")
	AADD(aCpoGDa,"D1_VALIMP5")
	AADD(aCpoGDa,"D1_VALIMP6")
	AADD(aCpoGDa,"D1_ALQIMP5")
	AADD(aCpoGDa,"D1_ALQIMP6")
	
	//Array com os campos que é permitida alteração.
	
	AADD(aAlterGDa,"D1_TES")
	
	Aadd( aButtons, {"EDIT", { || U_ICOMA03C(cAlias,nReg,nOpc,aCols) },"Alterar por Agrupamento" } )

	
	nUsado:=0
	dbSelectArea("SX3")
	DbSetOrder(2)
	dbSeek("SD1")
	aHeader:={} // Adiciona o nome dos Campos no Titulo da MsgetDados
	
	dbSeek("D1_ITEM")
	if Alltrim(x3_campo) ==   "D1_ITEM"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
	endif
	
	dbSeek("D1_COD")
	if Alltrim(x3_campo) ==   "D1_COD"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
	endif
	
	dbSeek("D1_XDESCR")
	if Alltrim(x3_campo) ==   "D1_XDESCR"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
	endif
	
	dbSeek("D1_TES")
	if Alltrim(x3_campo) ==   "D1_TES"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"U_ICOMA03A(M->D1_TES)",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_CF")
	if Alltrim(x3_campo) ==   "D1_CF"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_CLASFIS")
	if Alltrim(x3_campo) ==   "D1_CLASFIS"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_BASIMP5")
	if Alltrim(x3_campo) ==   "D1_BASIMP5"
		nUsado:=nUsado+1
		AADD(aHeader,{"Base de Calculo do COFINS", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_VALIMP5")
	if Alltrim(x3_campo) ==   "D1_VALIMP5"
		nUsado:=nUsado+1
		AADD(aHeader,{ "Valor do COFINS", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_ALQIMP5")
	if Alltrim(x3_campo) ==   "D1_ALQIMP5"
		nUsado:=nUsado+1
		AADD(aHeader,{ "Alíquota do COFINS", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_BASIMP6")
	if Alltrim(x3_campo) ==   "D1_BASIMP6"
		nUsado:=nUsado+1
		AADD(aHeader,{ "Base de Calculo do PIS", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_VALIMP6")
	if Alltrim(x3_campo) ==   "D1_VALIMP6"
		nUsado:=nUsado+1
		AADD(aHeader,{ "Valor do PIS", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	dbSeek("D1_ALQIMP6")
	if Alltrim(x3_campo) ==   "D1_ALQIMP6"
		nUsado:=nUsado+1
		AADD(aHeader,{ "Alíquota do PIS", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif
	
	// Posicionar na SD1
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	
	aCols:={}
	
	While !eof().and. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA .And. SD1->D1_FILIAL == SF1->F1_FILIAL
		if empty(SD1->D1_TES)
			alert ("Nota sem classificação não pode ter a Virada de TES. Favor verificar !!")
			RestArea(cAliasOrg)
			Return
		endif
		
		AADD(aCols,Array(nUsado+1))
		For nX:=1 to nUsado
			aCols[Len(aCols),nX]:=FieldGet(FieldPos(aHeader[nX,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		//Comentado Rubens em 23/03/15
		/*if Posicione("SF4",1,xFilial("SF4") + SD1->D1_TES,"F4_ESTOQUE") = "S"
			Alert("A TES Atual para o Item "  + SD1->D1_ITEM + " atualiza estoque." + CHR(10) + CHR(13) + ;
			      "Alteração Permitida Somente se Todas as TES Não atualizar Estoque." )
			return .F.
		endif*/                                                 
		dbSkip()
	End
	
	_oDlg := MSDIALOG():New(000,000,500,1200, "Virada de TES",,,,,,,,,.T.)
	RegToMemory("SF1", If(nOpc==3,.T.,.F.))
	
	oEnch:= MsMGet():New(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,;
	aCpoEnch,aPos,aAlterEnch, nModelo, /*nColMens*/, /*cMensagem*/,;
	/*cTudoOk*/, _oDlg,lF3, lMemoria,lColumn,caTela,lNoFolder,;
	lProperty)
	
	oGetD:= MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita,;
	GD_UPDATE,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, _oDLG, aHeader, aCols)
	
	_oDlg:bInit := {|| EnchoiceBar(_oDlg, {||aColsD:= oGetD:aCols, ICOMA03B(aColsD),_oDlg:End()},{||_oDlg:End()},,aButtons)}
	_oDlg:lCentered := .T.
	_oDlg:Activate()
	
	cFilAnt := _cFilAtu
	RestArea(cAliasOrg)
	
Return

                       
user function ICOMA03A(tesNova, tesAtual)
	local _aArea:= getArea()        
	local _nD1_TES:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_TES" })
	local _cMsg	:= ""

	posicione("SF4",1,xFilial("SF4")+tesNova,"")
	if SF4->F4_ESTOQUE == "N"	
		ALERT("TES " + SF4->F4_CODIGO + " não atualiza Estoque. Obrigatório Nova TES que atualiza estoque.")
		return .F.
	endif 
	                                                
//return .T.	

	cF4IPI	:= SF4->F4_IPI
	cF4ICM 	:= SF4->F4_ICM
	cF4Incide := SF4->F4_INCIDE
	
	posicione("SF4",1,xFilial("SF4")+aCols[n][_nD1_TES],"")
	
	if cF4IPI <> SF4->F4_IPI
		_cMsg += "A incidencia de IPI da TES nova tem que ter a mesma configuração que a TES atual"	
		_cMsg += +chr(13)+chr(10)
		_cMsg += +chr(13)+chr(10)
	endif

	if cF4ICM <> SF4->F4_ICM
		_cMsg += "A incidencia de ICMS da TES nova tem que ter a mesma configuração que a TES atual" 
		_cMsg += +chr(13)+chr(10)
		_cMsg += +chr(13)+chr(10)
	endif

	if cF4Incide <> SF4->F4_INCIDE
		_cMsg += "A incidencia de IPI na Composição de ICMS da TES nova tem que ter a mesma configuração que a TES atual" 
	endif

	if ! empty(_cMsg)	
		aviso("Erros encontrados", _cMsg, {"Ok"},3)
		return .F.	
	endif
	
	restarea(_aArea)
return .T.
                      


// Faz a alteração dos dados da nota

Static Function ICOMA03B(aColsD)
Local _lAtuB2 := .f.

	dbselectArea("SD1")
	dbSetOrder(1)
	
	//  Alterando os itens da nota de entrada
	for i = 1 to len(aColsD)
		
		If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA + aColsD[i][2] + aColsD[i][1])
			RecLock("SD1",.F.)      
			SD1->D1_TES  := aColsD[i][3]
			MsUnlock()
		else
			MsgAlert ("Não foi possível alterar um dos itens da nota de entrada." + CHR(13) + CHR(10) + " Favor entrar em contato com o suporte.")
		endif
		
	next
                          
	aPergA930 := {}	
	aadd(aPergA930, dtoc(SF1->F1_DTDIGIT))
	aadd(aPergA930, dtoc(SF1->F1_DTDIGIT))
	aadd(aPergA930, 1)
	aadd(aPergA930, SF1->F1_DOC)
	aadd(aPergA930, SF1->F1_DOC)
	aadd(aPergA930, SF1->F1_SERIE)
	aadd(aPergA930, SF1->F1_SERIE)
	aadd(aPergA930, SF1->F1_FORNECE)
	aadd(aPergA930, SF1->F1_FORNECE)
	aadd(aPergA930, SF1->F1_LOJA)
	aadd(aPergA930, SF1->F1_LOJA)
/*	
    aadd(aPergA930, SF1->F1_FILIAL)
    aadd(aPergA930, SF1->F1_FILIAL)
    aadd(aPergA930, 1)	
	aadd(aPergA930, 2)
*/	
	Pergunte("MTA930",.F.)
		
	mv_par01 := SF1->F1_DTDIGIT
	mv_par02 := SF1->F1_DTDIGIT
	mv_par03 := 1
	mv_par04 := SF1->F1_DOC
	mv_par05 := SF1->F1_DOC
	mv_par06 := SF1->F1_SERIE
	mv_par07 := SF1->F1_SERIE
	mv_par08 := SF1->F1_FORNECE
	mv_par09 := SF1->F1_FORNECE
	mv_par10 := SF1->F1_LOJA
	mv_par11 := SF1->F1_LOJA
	mv_par12 := SF1->F1_FILIAL
	mv_par13 := SF1->F1_FILIAL
	mv_par14 := 1
	mv_par15 := 2          

	dbSelectArea("SX1")
	dbSetOrder(1)
	if dbSeek("MTA930    ")
		do while alltrim(SX1->X1_GRUPO) == 'MTA930'
			reclock("SX1", .F.)
			if SX1->X1_ORDEM == "01"
				SX1->X1_CNT01 := DTOS(mv_par01)
			elseif SX1->X1_ORDEM == "02"
				SX1->X1_CNT01 := DTOS(mv_par02)
			elseif SX1->X1_ORDEM == "03"
				SX1->X1_PRESEL := mv_par03
			elseif SX1->X1_ORDEM == "04"
				SX1->X1_CNT01 := mv_par04
			elseif SX1->X1_ORDEM == "05"
				SX1->X1_CNT01 := mv_par05
			elseif SX1->X1_ORDEM == "06"
				SX1->X1_CNT01 := mv_par06
			elseif SX1->X1_ORDEM == "07"
				SX1->X1_CNT01 := mv_par07
			elseif SX1->X1_ORDEM == "08"
				SX1->X1_CNT01 := mv_par08
			elseif SX1->X1_ORDEM == "09"
				SX1->X1_CNT01 := mv_par09
			elseif SX1->X1_ORDEM == "10"
				SX1->X1_CNT01 := mv_par10
			elseif SX1->X1_ORDEM == "11"
				SX1->X1_CNT01 := mv_par11
			elseif SX1->X1_ORDEM == "12"
				SX1->X1_CNT01 := mv_par12
			elseif SX1->X1_ORDEM == "13"
				SX1->X1_CNT01 := mv_par13
			elseif SX1->X1_ORDEM == "14"
				SX1->X1_PRESEL := mv_par14			
			elseif SX1->X1_ORDEM == "15"
				SX1->X1_PRESEL := mv_par15			
			endif		
			MsUnlock()
			
			SX1->(dbSkip())
		enddo
	endif

	_aSF1A := SF1->(GetArea())

	MATA930(.F., aPergA930)

	RestArea(_aSF1A)
	cFilAnt := SF1->F1_FILIAL //Em algumas situações estava trocando a filial do cFilAnt

    dbSelectArea("SD1")
    dbSetOrder(1)
    DbGoTop()
    dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))

	//do while D1_DOC == F1_DOC .and. D1_SERIE == F1_SERIE .and. D1_FORNECE == F1_FORNECE .and. D1_LOJA = F1_LOJA
	While !Eof() .And. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA .And. SD1->D1_FILIAL == SF1->F1_FILIAL
		_cAreaSD1 := getArea()
		
		//Atualiza a quantidade disponivel porque a quantidade irá para o saldo em estoque (saldo real)
		//Jorge Alves
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2") + SD1->D1_COD + SD1->D1_LOCAL) .And. Empty(SF1->F1__DTVTES)
			While !Reclock("SB2",.f.)
			EndDo
			If SB2->B2__ENTPRC >= SD1->D1__WMSQTD
				SB2->B2__ENTPRC := SB2->B2__ENTPRC - SD1->D1__WMSQTD
			Else
				SB2->B2__ENTPRC := 0
			EndIf
			MsUnlock()
		EndIf
        
		//Atualiza o saldo atual, se o TES atualizar estoque
		DbSelectArea("SF4")
		DbSetOrder(1)
		If DbSeek(xFilial("SF4") + SD1->D1_TES) .And. SF4->F4_ESTOQUE == "S"
			_lAtuB2 := .t.
			/*
			dbSelectArea("SX1")
			dbSetOrder(1)
			If dbSeek(PADR("MTA300",Len(SX1->X1_GRUPO)))
				While alltrim(SX1->X1_GRUPO) == 'MTA300'
					While !reclock("SX1", .F.)
					EndDo
					if SX1->X1_ORDEM == "01"
						SX1->X1_CNT01 := SD1->D1_LOCAL
					elseif SX1->X1_ORDEM == "02"
						SX1->X1_CNT01 := SD1->D1_LOCAL
					elseif SX1->X1_ORDEM == "03"
						SX1->X1_CNT01 := SD1->D1_COD
					elseif SX1->X1_ORDEM == "04"
						SX1->X1_CNT01 := SD1->D1_COD
					elseif SX1->X1_ORDEM == "05"
						SX1->X1_PRESEL := 2
					elseif SX1->X1_ORDEM == "06"
						SX1->X1_PRESEL := 2
					elseif SX1->X1_ORDEM == "07"
						SX1->X1_PRESEL := 2
					elseif SX1->X1_ORDEM == "08"
						SX1->X1_PRESEL := 2
					endif		
				
					SX1->(dbSkip())
				EndDo
			EndIf
		
			pergunte("MTA300", .F.)
			mv_par01 := SD1->D1_LOCAL
			mv_par02 := SD1->D1_LOCAL
			mv_par03 := SD1->D1_COD
			mv_par04 := SD1->D1_COD
			mv_par05 := 2
			mv_par06 := 2
			mv_par07 := 2
			mv_par08 := 2
	        
			/*
			aFil := {}
			aadd(aFil, {.T., xFilial("SD1")})
			
			MATA300 (.T., aFil)
			*/		  
			//MsAguarde({|| MATA300 (.T.)}, "Processando...","Atualizando saldo do produto " + mv_par03)
			
		EndIf		
		RestArea(_cAreaSD1)

		DbSelectArea("SD1")
		DbSkip()
	enddo
	If _lAtuB2
		_aParam := ICOMA03PRD()

		dbSelectArea("SX1")
		dbSetOrder(1)
		If dbSeek(PADR("MTA300",Len(SX1->X1_GRUPO)))
			While alltrim(SX1->X1_GRUPO) == 'MTA300'
				While !reclock("SX1", .F.)
				EndDo
				if SX1->X1_ORDEM == "01"
					SX1->X1_CNT01 := "  "
				elseif SX1->X1_ORDEM == "02"
					SX1->X1_CNT01 := "ZZ"
				elseif SX1->X1_ORDEM == "03"
					SX1->X1_CNT01 := _aParam[1]
				elseif SX1->X1_ORDEM == "04"
					SX1->X1_CNT01 := _aParam[2]
				elseif SX1->X1_ORDEM == "05"
					SX1->X1_PRESEL := 2
				elseif SX1->X1_ORDEM == "06"
					SX1->X1_PRESEL := 2
				elseif SX1->X1_ORDEM == "07"
					SX1->X1_PRESEL := 2
				elseif SX1->X1_ORDEM == "08"
					SX1->X1_PRESEL := 2
				endif		
				MsUnlock()
				
				SX1->(dbSkip())
			EndDo
		EndIf
	
		pergunte("MTA300", .F.)
		mv_par01 := "  "
		mv_par02 := "ZZ"
		mv_par03 := _aParam[1]
		mv_par04 := _aParam[2]
		mv_par05 := 2
		mv_par06 := 2
		mv_par07 := 2
		mv_par08 := 2
		
		MsAguarde({|| MATA300 (.T.)}, "Processando...","Atualizando saldo dos produtos...")

	EndIf

	dbSelectArea("SF1")
	RecLock("SF1",.F.)      
	SF1->F1__DTVTES	:= date()
	msUnlock()
	
	MsgAlert ("Alteração efetuada com sucesso.")
	
Return
                                 


user Function ICOMA03C(cAlias,nReg,nOpc,AcolsOri)

	Local nX           := 0
	Local nUsado       := 0
	Local aButtons     := {}
	Local aCpoEnch     := { 'NOUSER' }
	Local cAliasE      := cAlias
	Local aAlterEnch   := {}
	Local aPos         := {000,000,080,180}
	Local nModelo      := 3
	Local lF3          := .F.
	Local lMemoria     := .T.
	Local lColumn      := .F.
	Local caTela       := ""
	Local lNoFolder    := .F.
	Local lProperty    := .F.
	Local aCpoGDa      := {}
	Local cAliasGD     := "SD1"
	Local nSuperior    := 030
	Local nEsquerda    := 000
	Local nInferior    := 180
	Local nDireita     := 180
	Local cLinOk       := "AllwaysTrue"
	Local cTudoOk      := "AllwaysTrue"
	Local cIniCpos     := "D1_ITEM"
	Local nFreeze      := 000
	Local nMax         := 999
	Local cFieldOk     := "AllwaysTrue"
	Local cSuperDel    := ""
	Local cDelOk       := "AllwaysFalse"
	Local aHeader      := {}
	Local aCols        := {}
	Local aAlterGDa    := {}
	Local cAliasOrg	   := GetArea()
	
	Private _oDlg1
	Private oGetC
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]

	// Adiciona os Campos da SF1 no cabeçalho.

	AADD(aCpoEnch,"F1_DOC") 
	AADD(aCpoEnch,"F1_SERIE") 
	
	// Adiciona os Campos da SD1 no GetDados
	
	AADD(aCpoGDa,"D1_TES")
	AADD(aCpoGDa,"NOVATES")
	
	//Array com os campos que é permitida alteração.
	
	AADD(aAlterGDa,"NOVATES")
	
	nUsado:=0
	dbSelectArea("SX3")
	DbSetOrder(2)
	dbSeek("SD1")
	aHeader:={} // Adiciona o nome dos Campos no Titulo da MsgetDados
	
	dbSeek("D1_TES")
	if Alltrim(x3_campo) == "D1_TES"
		nUsado:=nUsado+1
		AADD(aHeader,{"TES Atual", x3_campo, x3_picture,x3_tamanho,;
		x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
		
		nUsado:=nUsado+1
		AADD(aHeader,{ "Nova TES", "NOVATES", x3_picture,x3_tamanho,;
		x3_decimal,"U_ICOMA03A(M->NOVATES)",x3_usado, x3_tipo, x3_f3, x3_context } )
	endif

	// Posicionar na SD1
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	
	aCols:={}

	_cQuery := "SELECT DISTINCT D1_CLASFIS, D1_TES "
	_cQuery += "FROM " + retSqlName("SD1") + " SD1 "
	_cQuery += "WHERE D1_DOC = '" + SF1->F1_DOC + "' "
	_cQuery += "  AND D1_SERIE = '" + SF1->F1_SERIE + "' "
	_cQuery += "  AND D1_FORNECE = '" + SF1->F1_FORNECE + "' "
	_cQuery += "  AND D1_LOJA = '" + SF1->F1_LOJA + "' "
	_cQuery += "  AND D_E_L_E_T_ <> '*' "
	
	TcQuery _cQuery New Alias "TRB_TES"
	
	do while ! TRB_TES->(eof())
	
		AADD(aCols,Array(nUsado+1))

		aCols[Len(aCols),1]:= TRB_TES->D1_TES
		aCols[Len(aCols),2]:= TRB_TES->D1_TES
		
		aCols[Len(aCols),nUsado+1]:=.F.
		
		TRB_TES->(dbSkip())
	enddo      
	TRB_TES->(dbCloseArea())
	
	_oDlg1      := MSDIALOG():New(000,000,400,360, "Virada de TES",,,,,,,,,.T.)
	RegToMemory("SF1", If(nOpc==3,.T.,.F.))
	
	oEnch := MsMGet():New(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,;
	aCpoEnch,aPos,aAlterEnch, nModelo, /*nColMens*/, /*cMensagem*/,;
	/*cTudoOk*/, _oDlg1,lF3, lMemoria,lColumn,caTela,lNoFolder,;
	lProperty)
	
	oGetC:= MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita,;
	GD_UPDATE,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, _oDLG1, aHeader, aCols)
	
	_oDlg1:bInit := {|| EnchoiceBar(_oDlg1, {||aColsC:= oGetC:aCols, U_ICOMA03D(aColsC, AcolsOri),_oDlg1:End()},{||_oDlg1:End()},,aButtons)}
	_oDlg1:lCentered := .T.
	_oDlg1:Activate()
	
	RestArea(cAliasOrg)

return 



user function ICOMA03D(aColsC, AcolsOri)
	local _lRet 	:= .T.
	local _nD1_TES	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "D1_TES" })
                             
    for z:=1 to len(aColsC)                         
		                                       
		for x:=1 to len(AcolsOri)
			if AcolsOri[x][_nD1_TES] == aColsC[z][1]
				AcolsOri[x][_nD1_TES] := aColsC[z][2]
			endif			
		next x
	    
	next z
	   
   	oGetD:Acols := AcolsOri
return _lRet


Static Function ICOMA03PRD()
Local _aSF1 := SF1->(GetArea()), _cSQL := _cTbl := "", _aParam := {"",""}

_cTbl := GetNextAlias()
_cSQL := "Select Min(D1_COD) D1CODMIN, Max(D1_COD) D1CODMAX From " + RetSqlName("SD1") + " D1 "
_cSQL += "Where D1_FILIAL = '" + xFilial("SD1") + "' And D1_DOC = '" + SF1->F1_DOC + "' And D1_SERIE = '" + SF1->F1_SERIE + "' And "
_cSQL += 	"D1_FORNECE = '" + SF1->F1_FORNECE + "' And D1_LOJA = '" + SF1->F1_LOJA + "' And D1_TIPO = '" + SF1->F1_TIPO + "' And "
_cSQL +=	"D1.D_E_L_E_T_ = ' ' "  

If Select(_cTbl) > 0
	DbSelectArea(_cTbl)
	DbCloseArea()
EndIf

DbUseArea(.T., "TOPCONN", TCGenQry(Nil,Nil,_cSQL),_cTbl,.T.,.F.)

DbSelectArea(_cTbl)
DbGoTop()

If !Eof()
	_aParam[1] := (_cTbl)->D1CODMIN
	_aParam[2] := (_cTbl)->D1CODMAX
EndIf

If Select(_cTbl) > 0
	DbSelectArea(_cTbl)
	DbCloseArea()
EndIf

RestArea(_aSF1)
Return _aParam