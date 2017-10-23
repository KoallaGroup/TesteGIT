#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | ITMKA09  | Autor |  Rogério Alves  - Anadi  | Data | Abril/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Preenche o campo de quantidade após fazer validação do saldo     |
|          | do Lote - Acionado por Gatilho                                   |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function ITMKA09(_cProd, _cLocal, _cItem, _nQtdDigit,_lHelp)

Local _aArea	:= GetArea(), _nQLoc01 := _nQLoc02 := 0 
Local _nSaldo	:= _nQatu := 0, _lErroDig := .f., _nx := n, _nQtdSol := 0
Local _cCposExc := "UB_REC_WT/UB_ALI_WT/", _cEstCli	:= ""
local _nPUM     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_UM"      })
local _nPVU     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
local _nPVL     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
local _nPD1     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
local _nPD2     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
local _nPTP     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__TPOPE"  })
local _nCKt     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__CODKIT" })
local _nAce     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__CODACE" })
local _nPai     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ITEPAI" })
Local _nFil 	:= aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ITFILH" })
local _nItm     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" 	  })
local _nPQt     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
local _nArm     := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL"   })

Default _lHelp	:= .T.

If FunName() == "TMKA271" .Or. AtIsRotina("U_ITMKCAL") .Or. (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
    
	//Verifica se será executada a validação default ou se será feita a validação para integração com Webline
	If (Type("lTk271Auto") <> "U" .AND. lTk271Auto) .And. _nCKt > 0 .And. Alltrim(M->UA_OPERADO) == Alltrim(GetMv("MV__WEBOPE")) //Webline
		If !Empty(aCols[n][_nCKt])
		
			//Valida o Kit Recebido
			If _nAce > 0 .And. Empty(aCols[n][_nAce])
				_nQatu := 0 
				_nQtdSol := 0
				_lErroDig := .t.
				
				DbSelectArea("SZN")
				While !RecLock("SZN",.T.)
				EndDo		
				SZN->ZN_FILIAL := M->UA__FILIAL
				SZN->ZN_NUM    := M->UA_NUM
				SZN->ZN_ITEM   := _cItem
				SZN->ZN_DTCAN  := date()
				SZN->ZN_MOTIVO := "00008"
				SZN->ZN_QUANT  := _nQtdDigit
				SZN->ZN_PRODUTO:= _cProd
				SZN->ZN_HRCAN  := substr(time(),1,5)
		        SZN->ZN_UM      := aCols[n][_nPUM]
		        SZN->ZN_VLRUNIT := aCols[n][_nPVU]
		        SZN->ZN_PRCLIST := aCols[n][_nPVL]
		        SZN->ZN_DESC1   := aCols[n][_nPD1]
		        SZN->ZN_DESC2   := aCols[n][_nPD2]
		        SZN->ZN_TPOPE   := aCols[n][_nPTP]
				msUnlock()								
			Else
				DbSelectArea("SU1")
				DbSetOrder(1)
				If !DbSeek(xFilial("SU1") + aCols[n][_nAce] + _cProd)
					//Kit Não localizado
					_nQatu := 0 
					_nQtdSol := 0
					_lErroDig := .t.
					
					DbSelectArea("SZN")
					While !RecLock("SZN",.T.)
					EndDo		
					SZN->ZN_FILIAL := M->UA__FILIAL
					SZN->ZN_NUM    := M->UA_NUM
					SZN->ZN_ITEM   := _cItem
					SZN->ZN_DTCAN  := date()
					SZN->ZN_MOTIVO := "00008"
					SZN->ZN_QUANT  := _nQtdDigit
					SZN->ZN_PRODUTO:= _cProd
					SZN->ZN_HRCAN  := substr(time(),1,5)
			        SZN->ZN_UM      := aCols[n][_nPUM]
			        SZN->ZN_VLRUNIT := aCols[n][_nPVU]
			        SZN->ZN_PRCLIST := aCols[n][_nPVL]
			        SZN->ZN_DESC1   := aCols[n][_nPD1]
			        SZN->ZN_DESC2   := aCols[n][_nPD2]
			        SZN->ZN_TPOPE   := aCols[n][_nPTP]
					msUnlock()						
				Else
					_nQatu := U_xSldKit(M->UA__FILIAL,aCols[n][_nCKt],_cLocal,M->UA_NUM,_cProd)
					_nQLoc01 := _nQatu
				EndIf
			EndIf		
		Else
			//_nQatu := U_xSldProd(M->UA__FILIAL,_cProd, _cLocal, M->UA_NUM )
			If _cLocal $ GetMv("MV__ARMVEN") .And. Alltrim(M->UA__SEGISP) $ GetMv("MV__ARMSEG")
				_nQLoc01 := U_xSldProd(M->UA__FILIAL,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),M->UA_NUM)
				_nQLoc02 := U_xSldProd(M->UA__FILIAL,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),M->UA_NUM)
				
				_nQatu := _nQLoc01 + _nQLoc02
			Else
				_nQatu := U_xSldProd(M->UA__FILIAL,_cProd,_cLocal,M->UA_NUM)
				_nQLoc01 := _nQatu 
			EndIf
		EndIf
	Else
		If _cLocal $ GetMv("MV__ARMVEN") .And. Alltrim(M->UA__SEGISP) $ GetMv("MV__ARMSEG")
			_nQLoc01 := U_xSldProd(M->UA__FILIAL,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),M->UA_NUM)
			_nQLoc02 := U_xSldProd(M->UA__FILIAL,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),M->UA_NUM)
			
			_nQatu := _nQLoc01 + _nQLoc02
		Else
			_nQatu := U_xSldProd(M->UA__FILIAL,_cProd,_cLocal,M->UA_NUM)
			_nQLoc01 := _nQatu 
		EndIf		
	EndIf

	If _nQatu <= 0 .And. !_lErroDig
		_nSaldo := _nQtdDigit
		If _lHelp .And. (Type("lTk271Auto") <> "U" .AND. !lTk271Auto)
			Help( Nil, Nil, "SLDPROD", Nil, "Produto nao possui saldo", 1, 0 ) 
		EndIf
		
		aCols[n][len(aHeader)+1] := .T.
		
		DbSelectArea("SZN")
		While !RecLock("SZN",.T.)
		EndDo		
		SZN->ZN_FILIAL := M->UA__FILIAL
		SZN->ZN_NUM    := M->UA_NUM
		SZN->ZN_ITEM   := _cItem
		SZN->ZN_DTCAN  := date()
		SZN->ZN_MOTIVO := "00001"
		SZN->ZN_QUANT  := _nSaldo
		SZN->ZN_PRODUTO:= _cProd
		SZN->ZN_HRCAN  := substr(time(),1,5)
        SZN->ZN_UM      := aCols[n][_nPUM]
        SZN->ZN_VLRUNIT := aCols[n][_nPVU]
        SZN->ZN_PRCLIST := aCols[n][_nPVL]
        SZN->ZN_DESC1   := aCols[n][_nPD1]
        SZN->ZN_DESC2   := aCols[n][_nPD2]
        SZN->ZN_TPOPE   := aCols[n][_nPTP]
		msUnlock()
		                                              
		_cEstCli := Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST")
		aSimilar := U_IESTA07A(_cProd,M->UA_TABELA,_cEstCli)
			
		If (Len(aSimilar) > 0) .And. (Type("lTk271Auto") <> "U" .AND. !lTk271Auto)
			If MsgYesNo("Deseja visualizar os produtos similares?","Confirme")
				U_IESTA07(_cProd,M->UA_TABELA,,,.F.)
			EndIf
		EndIf			

	ElseIf _nQatu >= _nQtdDigit .And. !_lErroDig
		
		If (Empty(aCols[n][_nPai]) .And. aCols[n][_nPQt] == 0) .And. Alltrim(M->UA__SEGISP) $ GetMv("MV__ARMSEG") .And. !(Type("lTk271Auto") <> "U" .AND. lTk271Auto)
		
			//Verifica se deve considerar os armazéns 01 e 02 ou se considera apenas o que está informado no aCols
			If _cLocal $ GetMv("MV__ARMVEN")
				If _nQLoc01 >= _nQtdDigit
					_nQtdSol := _nQtdDigit
					_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
					aCols[n][_nArm] := _cLocal					
				ElseIf _nQLoc01 <= 0 .And. _nQLoc02 >= _nQtdDigit
					_nQtdSol := _nQtdDigit
					_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
					aCols[n][_nArm] := _cLocal
				Else //Desmembra as quantidades de acordo com o disponivel em cada armazém
					ITMKA09D(_cProd, @_cLocal, _cItem, _nQtdDigit, _nQLoc01, _nQLoc02, @_nQtdSol)
				EndIf
			Else
				_nQtdSol := _nQtdDigit
			EndIf
		ElseIf Alltrim(M->UA__SEGISP) $ GetMv("MV__ARMSEG") .And. !(Type("lTk271Auto") <> "U" .AND. lTk271Auto)//Alteração do item
			//Verifica se deve considerar os armazéns 01 e 02 ou se considera apenas o que está informado no aCols
			If _cLocal $ GetMv("MV__ARMVEN")
				If _nQLoc01 >= _nQtdDigit
					_nQtdSol := _nQtdDigit
					_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
					aCols[n][_nArm] := _cLocal
					
					//Se durante a inclusão do item houve quebra de quantidade, deleta a linha que está vinculada
					ITMKA09K(_cProd, _cItem, _nItm, _nPai, _nFil)
				    aCols[n][_nFil] := " "
					aCols[n][_nPai] := " "
				ElseIf _nQLoc01 == 0 .And. _nQLoc02 >= _nQtdDigit
					_nQtdSol := _nQtdDigit
					_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
					aCols[n][_nArm] := _cLocal
				Else //Desmembra as quantidades de acordo com o disponivel em cada armazém
					ITMKA09D(_cProd, @_cLocal, _cItem, _nQtdDigit, _nQLoc01, _nQLoc02, @_nQtdSol)
				EndIf
			Else
				_nQtdSol := _nQtdDigit
			EndIf
		Else
			If !(Type("lTk271Auto") <> "U" .AND. lTk271Auto)
				_nQtdSol := _nQtdDigit
			Else
				If (!Empty(aCols[n][_nFil]))  //houve quebra em mais de um item
					_nQtdSol := _nQLoc01
				Else
					_nQtdSol := _nQtdDigit
				EndIf
			EndIf
		EndIf
	ElseIf !_lErroDig
		_nSaldo := _nQtdDigit - _nQatu
		
		If _nSaldo > 0		
			If _cLocal $ GetMv("MV__ARMVEN") .And. Alltrim(M->UA__SEGISP) $ GetMv("MV__ARMSEG") .And. !(Type("lTk271Auto") <> "U" .AND. lTk271Auto)
				If _nQLoc01 > 0
					_nQtdSol := _nQLoc01
					_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
					aCols[n][_nArm] := _cLocal
				EndIf					
				
				If _nQLoc01 == 0 .And. _nQLoc02 > 0
					_nQtdSol := _nQLoc02
					_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
					aCols[n][_nArm] := _cLocal
				Else //Desmembra as quantidades de acordo com o disponivel em cada armazém
					ITMKA09D(_cProd, @_cLocal, _cItem, _nQtdDigit, _nQLoc01, _nQLoc02, @_nQtdSol)
				EndIf
			Else				
				If !(Type("lTk271Auto") <> "U" .AND. lTk271Auto)
					_nQtdSol := _nQtdDigit - _nSaldo
				Else
					If !Empty(aCols[n][_nFil]) //houve quebra em mais de um item
						_nQtdSol := _nQLoc01
					Else
						_nQtdSol := _nQtdDigit - _nSaldo
					EndIf
				EndIf				
				
			EndIf		
			//_nSaldo  := _nQtdDigit - _nQatu			
		ElseIf _nSaldo == 0
			_nQtdSol := 0
			_nSaldo  := _nQtdDigit
			If _lHelp .And. (Type("lTk271Auto") <> "U" .AND. !lTk271Auto)
				Help( Nil, Nil, "SLDPROD", Nil, "Produto nao possui saldo", 1, 0 ) 
			EndIf
			aCols[n][Len(aHeader)+1] := .T.
		EndIf
		
		DbSelectArea("SZN")
		While !RecLock("SZN",.T.)
		EndDo		
		SZN->ZN_FILIAL := M->UA__FILIAL
		SZN->ZN_NUM    := M->UA_NUM
		SZN->ZN_ITEM   := _cItem
		SZN->ZN_DTCAN  := Date()
		SZN->ZN_MOTIVO := IIF(_nQtdSol == 0,"00001","00020")
		SZN->ZN_QUANT  := _nSaldo
		SZN->ZN_PRODUTO:= _cProd
		SZN->ZN_HRCAN  := substr(time(),1,5)
        SZN->ZN_UM      := aCols[n][_nPUM]
        SZN->ZN_VLRUNIT := aCols[n][_nPVU]
        SZN->ZN_PRCLIST := aCols[n][_nPVL]
        SZN->ZN_DESC1   := aCols[n][_nPD1]
        SZN->ZN_DESC2   := aCols[n][_nPD2]
        SZN->ZN_TPOPE   := aCols[n][_nPTP]
		msUnlock()
		
	EndIf

EndIf

//Atualiza os totais
If aCols[n][Len(aHeader) + 1]
    If !MaFisFound("IT",n)
        MaFisAdd(   ""  , ""    , 0     , 0     ,;
                    0   , ""    , ""    , NIL   ,;
                    0   , 0     , 0     , 0     ,;
                    0   )
    Endif
    MaFisDel(n,aCols[n][Len(aCols[n])])
    
    Eval(bRefresh)
    Eval(bGDRefresh)
EndIf
RestArea(_aArea)
n := _nx

If _nQtdSol > 0 .And. M->UA__RESEST == "S" //Reserva o produto
	U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,_cItem,_cProd,_cLocal,_nQtdSol,"I")
Else
	_nQtdSol := 0
EndIf 

Return _nQtdSol


Static Function ITMKA09D(_cCodPrd, _cArmz, _cItSUB, _nQtDig, _nQtArm01, _nQtArm02, _nQtConf)
Local _nn := n, _nL := Len(aCols) + 1, _nSldConf := _ny := 0, _cNewArm := "", _nTam := Len(aHeader)
Local _nItm := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" 	  }), _cProxIt := aCols[Len(aCols)][_nItm]
Local _nPai	:= aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ITEPAI" })
Local _nFil	:= aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ITFILH" })
Local _nSol := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL" })
Local _nPQt := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
Local _nArm := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL"   })
Local _nTes := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_TES"	  })
Local _lEfetiva := (Type("_lITMKCAL") <> "U" .And. _lITMKCAL)

//Quando necessário desmembrar em 2 itens, será consumida primeiro a quantidade do Armazém 01
If _cArmz == Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
	
	_nQtConf := _nQtArm01 //Quantidade que será gravada na linha atual do aCols	
	_nSldConf := _nQtDig - _nQtArm01 //Quantidade a ser gravada na nova linha
	If _nQtArm02 < _nSldConf .And. _nQtArm02 > 0
		_nSldConf := _nQtArm02 
	ElseIf _nQtArm02 <= 0
		_nSldConf := 0
	EndIf
	_cNewArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
	
ElseIf _cArmz == Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])

	_nQtConf := _nQtDig - _nQtArm01 //Quantidade que será gravada na linha atual do aCols
	_nSldConf := _nQtDig - _nQtConf //Quantidade a ser gravada na nova linha
	If _nQtArm02 < _nQtConf .And. _nQtArm02 > 0
		_nQtConf := _nQtArm02 
	ElseIf _nQtArm02 <= 0
		_nSldConf := 0
	EndIf
	_cNewArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])

EndIf

If _nSldConf > 0

	If Empty(aCols[n][_nPai]) .And. Empty(aCols[n][_nFil]) 
		_cProxIt := Soma1(_cProxIt,Len(_cProxIt))//Próximo item do acols
		AAdd(aCols, Array(_nTam+1))

		n := _nL
		
		//Atualizo a nova linha com os mesmos dados da linha original
		For _ny := 1 To Len(aHeader)
			aCols[_nL][_ny] := aCols[_nn][_ny]
		Next _ny
		aCols[_nL][Len(aHeader) + 1] := .f.
		aCols[_nL][_nItm] := _cProxIt
		
		M->UB_PRODUTO   := _cCodPrd
		
	    n := _nL    
	    MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO)
	
	    n := _nL
	    MaColsToFis(aHeader, aCols,  _nL, "TK273",    .F. )	
		
		aCols[_nn][_nFil] := _cProxIt
		aCols[_nn][_nPai] := " "

	Else
		If !Empty(aCols[n][_nFil])
			_nL := aScan(aCols, { |x| AllTrim(x[_nItm]) == Alltrim(aCols[n][_nFil]) })
		ElseIf !Empty(aCols[n][_nPai])
			_nL := aScan(aCols, { |x| AllTrim(x[_nItm]) == Alltrim(aCols[n][_nPai]) })
		EndIf
	EndIf
	
	//Atualizo item, quantidade, quantidade solicitada, item pai e Armazém
	aCols[_nL][_nSol] := _nQtDig //M->UB__QTDSOL
	aCols[_nL][_nPQt] := _nSldConf
	aCols[_nL][_nPai] := aCols[_nn][_nItm]
	aCols[_nL][_nArm] := _cNewArm
	aCols[_nL][_nFil] := " "
    Eval(bGDRefresh)
    Eval(bRefresh)
	
	//U_ITMKGRON("SUB",M->UB__QTDSOL,n)
	U_ITMKGRON("SUB",_nQtDig,n)

	If _nSldConf > 0 .And. M->UA__RESEST == "S" //Reserva o produto
		U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,aCols[_nL][_nItm],_cCodPrd,aCols[_nL][_nArm],_nSldConf,"I")
	EndIf
    
    If Type("oGetTlv") == "O"
	    oGetTlv:oBrowse:NAT := _nn
    EndIf 
    Eval(bGDRefresh)
    Eval(bRefresh)

	n := _nn	
	If _lEfetiva
		U_ITMKREPL(_nQtDig)
		n := _nn
	EndIf	
    	
EndIf

Return


Static Function ITMKA09K(_cProd, _cItem, _nPItm, _nPPai, _nPFil)
Local _nLinha := 0 , _nn := n

If Empty(aCols[n][_nPPai]) .And. !Empty(aCols[n][_nPFil]) //Deleta o item filho
	_nLinha := aScan(aCols, { |x| AllTrim(x[_nPItm]) == Alltrim(aCols[n][_nPFil]) })
ElseIf !Empty(aCols[n][_nPPai])
	_nLinha := aScan(aCols, { |x| AllTrim(x[_nPItm]) == aCols[n][_nPPai] })
EndIf

If _nLinha > 0
    aCols[_nLinha][len(aHeader)+1] := .T.
    aCols[_nLinha][_nPFil] := " "
	aCols[_nLinha][_nPPai] := " "  
    U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,aCols[_nLinha][_nPItm],"","",0,"E")

    If !MaFisFound("IT",_nLinha)
        MaFisAdd(   ""  , ""    , 0     , 0     ,;
                    0   , ""    , ""    , NIL   ,;
                    0   , 0     , 0     , 0     ,;
                    0   )
    Endif
    MaFisDel(_nLinha,aCols[_nLinha][Len(aCols[_nLinha])])
    
    Eval(bRefresh)
    Eval(bGDRefresh)

    //Atualiza a gravação online
    U_ITMKGRON("SUB","",_nLinha,.t.)    
EndIf

Return