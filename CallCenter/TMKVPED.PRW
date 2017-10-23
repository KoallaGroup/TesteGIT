#Include "PROTHEUS.CH" 
#Include "TMKDEF.CH"

//-------------------------------------------------------------------
/*{Protheus.doc} TMKVPED
Ponto de entrada para substituir a gravação padrão do pedido de venda

@author Ivan Morelatto Toré
@since 25/07/2014
@version P11
*/
//-------------------------------------------------------------------
User Function TMKVPED

Local aAreaAtu 	:= GetArea()
Local aAreaSM0	:= SM0->( GetArea() )
Local aAreaSC5	:= SC5->( GetArea() )
Local aAreaSC6	:= SC6->( GetArea() )
Local aAreaSUA	:= SUA->( GetArea() )
Local aAreaSUB	:= SUB->( GetArea() )
Local aAreaSA1	:= SA1->( GetArea() )
Local aAreaSB1	:= SB1->( GetArea() )
Local aAreaSF4	:= SF4->( GetArea() )
Local aAreaSC9	:= SC9->( GetArea() )
Local cBkpFil 	:= cFilAnt

Local cMay		:= _cNumPed := "", nOperPed := 3
Local nCntFor	:= nx := 0

Local aCabecPed	:= {}, _cSQL    := _cTab := ""
Local aItensPed	:= {}, _lNovo   := .f., _lZ08 := .f.
Local aLinha	:= {}, _nValCom := 0
Local _aResult	:= {}, _lAlt	:= .F. 

Local _nUB_PRODU := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_PRODUTO"})
Local _nUB_DESCR := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_DESCRI"})
Local _nUB_SITPR := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_SITPROD"})
Local _nUB_QUANT := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_QUANT"})
Local _nUB_VRUNI := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_VRUNIT"})
Local _nUB_VLRIT := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_VLRITEM"})
Local _nUB_LOCAL := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_LOCAL"})
Local _nUB_UM    := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_UM"})
Local _nUB_DESC  := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_DESC"})
Local _nUB_VALDE := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_VALDESC"})
Local _nUB_TES   := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_TES"})
Local _nUB_CF    := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_CF"})
Local _nUB_ACRE  := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_ACRE"})
Local _nUB_VALAC := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_VALACRE"})
Local _nUB_PRCTA := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_PRCTAB"})
Local _nUB_DTENR := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_DTENTRE"})
Local _nUB_LOTE  := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_LOTE"})
Local _nUB_SUBLO := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_SUBLOTE"})
Local _nUB_DTVAL := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_DTVALID"})
Local _nUB_ITEM  := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_ITEM"})
Local _nUB_OPC   := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_OPC" } ) 
Local _nUB_NUMPC := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_NUMPCOM" } ) 
Local _nUB_ITEMP := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_ITEMPC" } ) 
Local _nUB_PICMR := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_PICMRET" } )
Local _nUB_FCICO := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_FCICOD" } )  
Local _nUB_VLIMP := aScan(aHeader, {|x|AllTrim(x[2]) == "UB_VLIMPOR" } )
Local _nUB_COMIS := aScan(aHeader, {|x|AllTrim(x[2]) == "UB__COMIS1" } )
Local _nUB_RECWT := aSCAN(aHeader, {|x|AllTrim(x[2]) == "UB_REC_WT" })
Local _lEfetiva  := (Type("_lITMKCAL") <> "U" .And. _lITMKCAL)

// Seta a filial correta para geração do pedido
cFilAnt := SUA->UA_FILIAL
SM0->( dbSetOrder( 1 ) )
SM0->( dbSeek( cEmpAnt + cFilAnt ) )

// Seta ordem que serão utilizadas
SC5->( dbSetOrder( 1 ) )
SA1->( dbSetOrder( 1 ) )
SB1->( dbSetOrder( 1 ) )
SF4->( dbSetOrder( 1 ) )
SA3->( dbSetOrder( 1 ) )

// Verifica se o pedido existe para fazer a alteração
If !Empty(SUA->UA_NUMSC5)
	If SC5->(dbSeek(xFilial("SC5") + SUA->UA_NUMSC5))
		_cNumPed  := SUA->UA_NUMSC5
	Endif
Endif

If Val(SUA->UA_OPER) == 1        

	//Atualiza o controle de visitas - Jorge H. - Junho/2015
	If SUA->UA__RESEST == "S" .And. Val(SUA->UA__TIPPED) <> 6 .And. !(Alltrim(SUA->UA_OPERADO) $ Alltrim(GetMv("MV__WEBOPE")))
		DbSelectArea("AD7")
		DbOrderNickName("AD7NUMPED")
		If !DbSeek(SUA->UA_FILIAL + SUA->UA_NUM)           
	 		If Reclock("AD7", .T.)
	   			AD7->AD7_FILIAL := xFilial("AD7")
	    		AD7->AD7_TOPICO	:= "VISITOU E COMPROU"
	    		AD7->AD7_DATA  	:= SUA->UA_EMISSAO
	    		AD7->AD7_HORA1  := SUA->UA_INICIO
	    		AD7->AD7_HORA2  := SUA->UA_FIM
	   			AD7->AD7_NROPOR := "" 
	   			AD7->AD7_CODCLI := SUA->UA_CLIENTE
	   			AD7->AD7_LOJA   := SUA->UA_LOJA
	   			AD7->AD7_VEND   := SUA->UA_VEND
	   			AD7->AD7_ORIGEM := "2"
	   			AD7->AD7_PROSPE := ""
	   			AD7->AD7_CONTAT := SUA->UA_CODCONT
	   			AD7->AD7__NUM   := GetSXENum("AD7","AD7__NUM")
	   			AD7->AD7__DTPRE := SUA->UA_PROXLIG
	   			AD7->AD7__DTVIS := SUA->UA_EMISSAO
	   			AD7->AD7__DTPRX := SUA->UA_PROXLIG
	   			AD7->AD7__STAT  := Alltrim(GETMV("MV__MOTVIS"))
	   			AD7->AD7__PREP  := ""
	   			AD7->AD7__TPOPE := SUA->UA_TMK
	   			AD7->AD7__PED   := SUA->UA_NUM
	   			AD7->AD7__OPERA := SUA->UA_OPERADO
	   			AD7->(MsUnlock()) 
		 		
		 		ConfirmSX8()
	 		endif		
	    EndIf
    EndIf
    
    //Busca numeracao do SC5 para novos pedidos
    If Empty(_cNumPed)
        DbSelectArea("SC5")
        DbSetOrder(1)
        _cNumPed := GetSxeNum("SC5","C5_NUM")
        cMay := "SC5" + ALLTRIM(xFilial("SC5")) + _cNumPed
        
        While (DbSeek(xFilial("SC5") + _cNumPed) .OR. !MayIUseCode(cMay))
            If __lSX8
               ConfirmSX8()
            EndIf
            _cNumPed := GetSXENum("SC5", "C5_NUM")
            cMay    := "SC5" + Alltrim(xFilial("SC5")) + _cNumPed
            DbSelectArea("SC5")
        EndDo
        
        If __lSX8
            ConfirmSX8()
        Endif

        _lNovo := .T.
    Endif   
    
	SA3->(DbSeek(xFilial("SA3") + SUA->UA_VEND))

    DbSelectArea("SC5")
    While !RecLock("SC5",_lNovo)
    EndDo
    SC5->C5_FILIAL  := xFilial("SC5")
    SC5->C5_NUM     := _cNumPed
    SC5->C5_TIPO    := "N"
    SC5->C5_CLIENTE := SUA->UA_CLIENTE
    SC5->C5_LOJACLI := SUA->UA_LOJA
    SC5->C5_CLIENT  := SUA->UA_CLIENTE
    SC5->C5_LOJAENT := SUA->UA_LOJA
    SC5->C5_TRANSP  := SUA->UA_TRANSP
    SC5->C5_TIPOCLI := SUA->UA_TIPOCLI
    SC5->C5_CONDPAG := SUA->UA_CONDPG
    SC5->C5_TABELA  := SUA->UA_TABELA
    SC5->C5_VEND1   := SUA->UA_VEND
    //SC5->C5_COMIS1  := 0
    SC5->C5_ACRSFIN := SUA->UA_JUROS
    If _lNovo
        SC5->C5_EMISSAO := Date()
    Endif   
    SC5->C5_MOEDA   := SUA->UA_MOEDA
    SC5->C5_TXMOEDA := RecMoeda(SUA->UA_EMISSAO,SUA->UA_MOEDA)
    SC5->C5_LIBEROK := ""
    SC5->C5_FRETE   := aValores[FRETE]
    SC5->C5_DESPESA := aValores[DESPESA]
    SC5->C5_DESCONT := IF(Empty(SUA->UA_PDESCAB),aValores[DESCONTO],0) // O desconto no rodape e valido somente se o Operador nao usa a INDENIZACAO (Cabecalho)
    SC5->C5_TIPLIB  := "2" //Liberacao por pedido                         
    SC5->C5_PDESCAB := SUA->UA_PDESCAB
    SC5->C5_TPFRETE := SUA->UA_TPFRETE 
    SC5->C5_TPCARGA := SUA->UA_TPCARGA 
    SC5->C5_DESC1   := SUA->UA_DESC1
    SC5->C5_DESC2   := SUA->UA_DESC2
    SC5->C5_DESC3   := SUA->UA_DESC3
    SC5->C5_DESC4   := SUA->UA_DESC4
    SC5->C5_INCISS  := SA1->A1_INCISS
    If cPaisLoc <> "BRA" .AND. Type(SUA->UA_DOCGER) <> "U"
        SC5->C5_DOCGER  := SUA->UA_DOCGER
        SC5->C5_TIPOREM := "0"
    Endif
    SC5->C5__NUMSUA := SUA->UA_NUM
    SC5->C5__SEGISP := SUA->UA__SEGISP
    SC5->C5_REDESP  := SUA->UA__REDESP
    SC5->C5__PRVFAT := SUA->UA__PRVFAT
    SC5->C5__PRIORI := SUA->UA__PRIORI
    SC5->C5__STATUS := SUA->UA__STATUS        
    FkCommit() // Commit para integridade referencial do SC5

    //Atualizo o numero do pedido no SUA 
    DbSelectArea("SUA")
    RecLock("SUA",.F.)
    SUA->UA_NUMSC5 := _cNumPed
    SUA->UA__DTALT := Date()
    SUA->UA__HRALT := Time()
    MsUnlock()
    
    For nx := 1 To Len(aCols)
    
        If aCols[nx][Len(aHeader)+1]
            SB1->(DbSeek(xFilial("SB1") + aCols[nX][_nUB_PRODU]))
            SF4->(DbSeek(xFilial("SF4") + aCols[nX][_nUB_TES]))
            
            //Destrava o resgitro da tabela SB2 - Saldos em Estoque.
            If SF4->F4_ESTOQUE == "S" .And. SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + aCols[nx][_nUB_LOCAL]))
                SB2->(MsUnlock())
            EndIf
            
            DbSelectArea( "SC6" )
            DbSetOrder(1)
            If DbSeek(xFilial("SC6") + _cNumPed + aCols[nX][_nUB_ITEM])
                Reclock("SC6" ,.F.,.T.)
                DbDelete()
                MaAvalSC6("SC6",2,"SC5")
            Endif
            Loop
        ElseIf !Empty(aCols[nX][_nUB_PRODU])

            SB1->(DbSeek(xFilial("SB1") + aCols[nX][_nUB_PRODU]))
            SF4->(DbSeek(xFilial("SF4") + aCols[nX][_nUB_TES]))
            
            //Destrava o resgitro da tabela SB2 - Saldos em Estoque.
            If SF4->F4_ESTOQUE == "S" .And. SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + aCols[nX][_nUB_ITEM]))
                SB2->(MsUnlock())
            EndIf
        
            DbSelectArea("SC6")
            DbSetOrder(1)
            If DbSeek(xFilial("SC6") + _cNumPed + aCols[nX][_nUB_ITEM])
                _lNovo := .F.
                RecLock("SC6")
                MaAvalSC6("SC6",2,"SC5")
                SC6->(FkCommit())
            Else
                _lNovo := .T.
            Endif
            
            If !_lNovo .And. SC6->C6_COMIS1 > 0
            	_nValCom := SC6->C6_COMIS1
            ElseIf _nUB_COMIS > 0 .And. aCols[nX][_nUB_COMIS] > 0
                _nValCom := aCols[nX][_nUB_COMIS]
            ElseIf _nUB_RECWT > 0 .And. !_lNovo
            	DbSelectArea("SUB")
            	DbGoTo(aCols[nX][_nUB_RECWT])
            	_nValCom := SUB->UB__COMIS1
            ElseIf SA3->A3_COMIS > 0
                _nValCom := SA3->A3_COMIS
            Else
                _nValCom := SB1->B1_COMIS
            EndIf

			DbSelectArea("SC6")
            Reclock("SC6",_lNovo)
            SC6->C6_FILIAL  := xFilial("SC6")
            SC6->C6_NUM     := _cNumPed
            SC6->C6_ITEM    := aCols[nX][_nUB_ITEM]
            SC6->C6_CLI     := SUA->UA_CLIENTE
            SC6->C6_LOJA    := SUA->UA_LOJA
            SC6->C6_PRODUTO := aCols[nX][_nUB_PRODU]
            SC6->C6_COMIS1  := _nValCom
            If  _nUB_DESCR > 0 
                SC6->C6_DESCRI  := aCols[nX][_nUB_DESCR]
            Else
                SC6->C6_DESCRI  := SB1->B1_DESC
            Endif   
            SC6->C6_UM      := aCols[nX][_nUB_UM]
            SC6->C6_QTDVEN  := aCols[nX][_nUB_QUANT]
            SC6->C6_SEGUM   := SB1->B1_SEGUM
            SC6->C6_UNSVEN  := ConvUm(aCols[nX][_nUB_PRODU],aCols[nX][_nUB_QUANT],0,2)
            SC6->C6_PRUNIT  := aCols[nX][_nUB_VRUNI]
            SC6->C6_PRCVEN   := aCols[nX][_nUB_VRUNI]    // O valor do item ja esta com desconto
            SC6->C6_VALDESC  := aCols[nX][_nUB_VALDE]
            SC6->C6_DESCONT  := aCols[nX][_nUB_DESC]
            SC6->C6_VALOR   := aCols[nX][_nUB_VLRIT]
            SC6->C6_TES     := aCols[nX][_nUB_TES]
            SC6->C6_CF      := aCols[nX][_nUB_CF]
            SC6->C6_LOCAL   := aCols[nX][_nUB_LOCAL]
            SC6->C6_ENTREG  := SUA->UA__PRVFAT
            SC6->C6_TPOP    := "F"
            SC6->C6_QTDLIB  := 0 //IF(lOpFat .OR. lOpRem,aCols[nX][_nUB_QUANT],0)

			_lZ08 := .f.
            If Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG")

		        DbselectArea("Z08")
		        DbSetOrder(1)
		        If DbSeek(xFilial("Z08") + SB1->B1_COD)
		            _lZ08 := .t.
		        Else
		            DbSetOrder(2)
		            If DbSeek(xFilial("Z08") + SB1->B1_GRUPO)
		                _lZ08 := .t.
		            EndIf
		        EndIf
                                
            EndIf
            
            If _lZ08
            	If cFilAnt $ Alltrim(GetMv("MV__ARMSAI"))
            		SC6->C6_CLASFIS := Alltrim(GetMv("MV__ARMCST")) + SF4->F4_SITTRIB
            	Else
            		SC6->C6_CLASFIS := SubStr(Alltrim(Str(Val(aCols[nX][_nUB_LOCAL]))),1,1) + SF4->F4_SITTRIB
            	EndIf
            Else
            	SC6->C6_CLASFIS := SubStr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
            EndIf
            
            If _nUB_OPC > 0 
                SC6->C6_OPC  := aCols[nX][_nUB_OPC]
            Endif   
            SC6->C6_CODISS  := SB1->B1_CODISS
            If _nUB_LOTE > 0
                SC6->C6_LOTECTL := aCols[nX][_nUB_LOTE]
            EndIf
            If _nUB_SUBLO > 0
                SC6->C6_NUMLOTE := aCols[nX][_nUB_SUBLO]
            EndIf
            If _nUB_DTVAL > 0
                SC6->C6_DTVALID := aCols[nX][_nUB_DTVAL]
            EndIf
            If _nUB_ITEMP > 0 .And. _nUB_NUMPC >0
                SC6->C6_ITEMPC  := aCols[nX][_nUB_ITEMP]
                SC6->C6_NUMPCOM := aCols[nX][_nUB_NUMPC]
            EndIf
            If _nUB_PICMR > 0 .And. SC6->(FieldPos("C6_PICMRET")) >0
                SC6->C6_PICMRET  := aCols[nX][_nUB_PICMR]                           
            EndIf
            
            If cPaisLoc == "BRA" .And. _nUB_FCICO > 0 .And. _nUB_VLIMP > 0 .And. SC6->(FieldPos("C6_FCICOD")) > 0 .And. SC6->(FieldPos("C6_VLIMPOR")) > 0
                SC6->C6_FCICOD  := aCols[nX][_nUB_FCICO]
                SC6->C6_VLIMPOR := aCols[nX][_nUB_VLIMP]
            EndIf            
            SC6->C6__TMKNUM := SUA->UA_NUM
            SC6->C6__TMKITE := aCols[nX][_nUB_ITEM]
            SC6->(FkCommit()) // Commit para integridade referencial do SC6

		    /*          
		    ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    ³Parametros³ExpC1: Alias da tabela dos itens do Pedido de Venda         ³
		    ³          ³ExpN2: Codigo do Evento                                     ³
		    ³          ³       [1] Implantacao do Pedido de Venda                   ³
		    ³          ³       [2] Estorno  do Pedido de Venda                      ³
		    ³          ³       [3] Liberacao do Pedido de Venda                     ³
		    ³          ³       [4] Estorno da Liberacao do Pedido de Venda          ³
		    ³          ³       [5] Preparacao da Nota Fiscal de Saida               ³
		    ³          ³       [6] Estorno da Nota Fiscal de Saida                  ³
		    ³          ³ExpC3: Alias do SC5                                         ³
		    ³          ³ExpL4: Liberacao Parcial                                    ³
		    ³          ³ExpL5: Transfere Locais                                     ³
		    ³          ³ExpL6: Verifica se todos os itens foram liberados           ³
		    ³          ³ExpL7: Verifica os residuos do pedido de venda              ³
		    ³          ³ExpL8: Verifica se todos os itens foram faturados           ³
		    ³          ³ExpL9: Atualiza somente os acumulados                       ³
		    ³          ³ExpNA: Valor a ser adicionado ao limite de credito          ³
		    ³          ³ExpCB: Alias do SD2 ( Uso Interno para otimizacao )         ³
		    ³          ³ExpLC: Indica se esta o SC6 esta sendo baixado por un REMITO³
		    ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    */
		    //MaAvalSC6("SC6",1,"SC5",lLiber,lTransf,@lLiberOk,@lResidOk,@lFaturOk,,,,,,lTLVReg)
		    MaAvalSC6("SC6",1,"SC5",.f.,.f.,.f.,.f.,.f.,,,,,,.f.)
			/*
            If _nUB_RECWT > 0 .And. ValType(aCols[nX][_nUB_RECWT]) == "N"
				DbSelectArea("SUB")
				DbGoTo(aCols[nX][_nUB_RECWT])
			Else
				DbSelectArea("SUB")
				DbSetOrder(1)
				DbSeek(xFilial("SUB") + SUA->UA_NUM + aCols[nx][_nUB_ITEM])
			EndIf
			If SUB->UB_FILIAL == SUA->UA_FILIAL .And. SUB->UB_NUM == SUA->UA_NUM .And. Alltrim(SUB->UB_ITEM) == Alltrim(aCols[nx][_nUB_ITEM])
			*/

			DbSelectArea("SUB")
			DbSetOrder(1)
			If DbSeek(xFilial("SUB") + SUA->UA_NUM + aCols[nx][_nUB_ITEM])
                RecLock( "SUB", .F. )
                SUB->UB_NUMPV  := _cNumPed
                SUB->UB_ITEMPV := aCols[nx][_nUB_ITEM]
                SUB->UB__COMIS1 := _nValCom
                SUB->( MsUnLock() )
   			EndIf
        EndIf
    Next
    
    If lTk271Auto .And. !_lEfetiva
    	//Verifica se existe pendencia para o cliente
    	U_ITMKC09(SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_NUM,.t.)
        U_IFATA14(SUA->UA_NUM,.T.)
    EndIf
    
    //Estorna os itens da grav online, para posterior atualização de acordo com a SUB
    U_ITMKGRDL("SUB",SUA->UA_NUM)
    
    //Mata a reserva dos itens na Z10
    U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,"","","",0,"E")
        
    SUB->( dbSetOrder( 1 ) )    
    For nx := 1 To Len(aCols)
        If !aCols[nx][Len(aHeader)+1]
            If SUB->( dbSeek( SUA->UA_FILIAL + SUA->UA_NUM + aCols[nx][_nUB_ITEM] ) )
                
                //Atualiza a gravação online                
                U_ITMKGRON("SUB","",0,.f.,SUA->(Recno()),SUB->(Recno()),.t.)

                If SUA->UA__RESEST == "S"     
                    U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,SUB->UB_ITEM,SUB->UB_PRODUTO,SUB->UB_LOCAL,SUB->UB_QUANT,"I")
                EndIf

            Endif
        Endif
    Next nx
    
    //Atualiza o cabeçalho gravação online
    U_ITMKGRON("SUA","",0,.f.,SUA->(Recno()),0,.t.)

    //Alterado por Rubens Cruz para liberar pedido após reativar o mesmo
    //If(M->UA__TPREAB == "2" .AND. alltrim(M->UA__SITFIN) == "A" .AND. alltrim(M->UA__SITCOM) == "A") 
    If (alltrim(SUA->UA__SITFIN) == "A" .AND. alltrim(SUA->UA__SITCOM) == "A")
        _lAlt := (!Empty(SUA->UA__TPREAB) .And. !Empty(SUA->UA__ENVWMS)) 
        _aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SUA->UA_FILIAL,SUA->UA__SEGISP,SUA->UA_NUMSC5,SUA->UA_NUM,"",IIF(_lAlt,"ALT","INC"),"","")
        If !Empty(_aResult)
            If _aResult[1] == "S"
                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 

                Reclock("SUA",.F.)
                    SUA->UA__STATUS := '1'
                SUA->(MsUnlock())
                Alert("Pedido permanece em Atendimento")

                DbSelectArea("SC9")
                DbSetOrder(1)
                If(DbSeek(SUA->UA_FILIAL+_cNumPed))
                    While(SUA->UA_FILIAL+_cNumPed = SC9->C9_FILIAL+SC9->C9_PEDIDO)
                        A460Estorna()
                        DbSkip()
                    EndDo
                EndIf           

            Else 
                Reclock("SUA",.F.)
                    SUA->UA__STATUS := '5'
                    SUA->UA__ENVWMS := "S"
                SUA->(MsUnlock())

                For nX := 1 To Len(aCols)
                    DbSelectArea("SC6")
                    If DbSeek(SUA->UA_FILIAL+_cNumPed+aCols[nX][_nUB_ITEM]+aCols[nX][_nUB_PRODU]) .And. !aCols[nx][Len(aHeader)+1]

                        dbSelectArea("SB2")
                        dbSetOrder(1)
                        MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
                        Msunlock()
                    
                        Reclock("SC6",.f.)
                        Begin Transaction
                            //MaLibDoFat(0, SC6->C6_QTDVEN, /*@lBlqCrd*/, /*@lBlqEst*/, .F., .F. )
                            MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,/*@lBlqCrd*/, /*@lBlqEst*/, .F., .f.,.f.)
                        End Transaction
                        SC6->(MsUnlock())
                    EndIf
                Next nX
                
                //Mata a reserva dos itens na Z10
			    U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,"","","",0,"E")
                
            EndIf

        EndIf
    EndIf
Endif                              

cFilAnt := cBkpFil
RestArea( aAreaSC9 )
RestArea( aAreaSF4 )
RestArea( aAreaSB1 )
RestArea( aAreaSA1 )
RestArea( aAreaSC5 )
RestArea( aAreaSC6 )
RestArea( aAreaSUA )
RestArea( aAreaSUB )
RestArea( aAreaSM0 )
RestArea( aAreaAtu )

Return