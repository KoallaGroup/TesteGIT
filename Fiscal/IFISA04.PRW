#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH" 

/*
+------------+---------+--------+-------------------------------------+-------+--------------+
| Programa:  | IFISA04 | Autor: | Silverio Bastos - Anadi Soluções    | Data: | Novembro/2014|
+------------+---------+--------+-------------------------------------+-------+--------------+
| Descrição: |Tes Inteligente																 |
+------------+-------------------------------------------------------------------------------+
| Uso:       |Exclusivo Isapa												                 |
+------------+-------------------------------------------------------------------------------+
*/

User Function IFISA04(_cFilial,_cProd,_cCliente,_cLoja, _cTpCli, _cCliFor,_cTpSZF,_lAuto)

Local _aArea 	:= getArea()
Local _cGrpTrib := _cEst	:= _cGrpCli	:= ''
Local _cRetTes  := ''
Local _nPItem   := _nPUM := _nPVU := _nPVL := _nPD1 := _nPD2 := _nPTP := 0
Local __OPERAC 	:= ''

Default _cCliFor := "C", _lAuto := .f., _cTpSZF := ""

If !_lAuto
    _nPItem   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"    })
    _nPUM     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_UM"      })
    _nPVU     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
    _nPVL     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
    _nPD1     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
    _nPD2     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
    _nPTP     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__TPOPE"  })
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+_cProd,.f.)
	_cGrpTrib := B1_GRTRIB
Endif

If "C6_" $ ReadVar() .Or. AtIsRotina("U_CROSSDPED")
    _cCliFor := IIF(M->C5_TIPO $ "D/B","F","C")
EndIf

If _cCliFor == "F"
    dbSelectArea("SA2")
    dbSetOrder(1)
    If dbSeek(xFilial("SA2")+_cCliente+_cLoja,.f.)      
        _cEst    := A2_EST                              
        _cGrpCli := A2_GRPTRIB
    Endif
Else
    dbSelectArea("SA1")
    dbSetOrder(1)
    If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)      
        _cEst    := A1_EST                              
        _cGrpCli := A1_GRPTRIB
    Endif
EndIf

//Verificar e preencher a operação - Silverio Bastos - Anadi - 11/12/2014
If( "UB_" $ ReadVar() ) .Or. AtIsRotina("U_ITMKCAL")
	_TipedSUA := M->UA__TIPPED
			
	If posicione("SZF",1,xFilial("SZF")+_TipedSUA,"ZF_BRINDE") == '1'
		__OPERAC := 'B'
	Else
		__OPERAC := 'V'
	Endif					
ElseIf( "C6_" $ ReadVar() ) .Or. AtIsRotina("U_CROSSDPED")
	__OPERAC := 'O'
ElseIf _lAuto
    If posicione("SZF",1,xFilial("SZF")+_cTpSZF,"ZF_BRINDE") == '1'
        __OPERAC := 'B'
    Else
        __OPERAC := 'V'
    Endif
Endif		

dbSelectArea("SF7")
_cQrySF7 := "SELECT F7_FILIAL, F7_SEQUEN, F7_EST, F7_TIPOCLI, F7_GRPCLI, F7__TES " 
_cQrySF7 += "FROM " + RetSqlName("SF7") + " SF7 " 
_cQrySF7 += "INNER JOIN " + RetSqlName("SF4") + " SF4  ON F4_FILIAL = F7_FILIAL And F4_CODIGO = F7__TES AND "
_cQrySF7 +=     " F4__OPERAC = '" + __OPERAC + "' AND SF4.D_E_L_E_T_ = ' ' "
_cQrySF7 += "WHERE F7_FILIAL = '" + _cFilial +"' AND (F7_TIPOCLI = '" + _cTpCli + "' Or F7_TIPOCLI = '*') AND "
_cQrySF7 += "      (F7_EST = '" + _cEst +"' Or F7_EST = '**') AND "
_cQrySF7 += "      F7_GRPCLI = '" + _cGrpCli +"' AND F7_GRTRIB = '" + _cGrpTrib +"'  AND SF7.D_E_L_E_T_ = ' ' "
/*
If __OPERAC == 'V'
	_cQrySF7 += "And F4_ESTOQUE = 'S' And F4_DUPLIC = 'S' "
ElseIf __OPERAC == 'O'
	_cQrySF7 += "And F4_ESTOQUE = 'S' And F4_DUPLIC = 'N' "
EndIf
*/
_cQrySF7 += "ORDER BY F7_FILIAL,F7_GRTRIB,F7_GRPCLI,F7_SEQUEN "                                                                                                                         
                                                                       	
If Select("SF7Q") > 0
	DbSelectArea("SF7Q")
	DbCloseArea()
	DbSelectArea("SF7")
EndIf

TcQuery _cQrySF7 New Alias "SF7Q"

DbSelectArea("SF7Q")
DbGoTop()
    
If !Eof()
	_cRetTes := SF7Q->F7__TES
EndIf

//Grava como venda perdida
If Empty(_cRetTes) .And. !_lAuto
    If ("UB_" $ ReadVar() ) .And. !(aCols[n][Len(aHeader)+1])
        Help( Nil, Nil, "CADTES", Nil, "Nao localizada regra fiscal para o produto", 1, 0 ) 
        aCols[n][Len(aHeader)+1] := .t.
        
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := xFilial("SZN")
        SZN->ZN_NUM     := M->UA_NUM
        SZN->ZN_ITEM    := aCols[n][_nPItem]
        SZN->ZN_DTCAN   := date()
        SZN->ZN_MOTIVO  := GetMV("MV__SZNTES")
        SZN->ZN_PRODUTO := _cProd
        SZN->ZN_HRCAN   := substr(time(),1,5)
        SZN->ZN_UM      := aCols[n][_nPUM]
        SZN->ZN_VLRUNIT := aCols[n][_nPVU]
        SZN->ZN_PRCLIST := aCols[n][_nPVL]
        SZN->ZN_DESC1   := aCols[n][_nPD1]
        SZN->ZN_DESC2   := aCols[n][_nPD2]
        SZN->ZN_TPOPE   := aCols[n][_nPTP]        
        MsUnlock()
    Else
        Help( Nil, Nil, "CADTES", Nil, "Nao localizada regra fiscal para o produto " + _cProd, 1, 0 )
    EndIf
EndIf

RestArea(_aArea)
Return(_cRetTes)

/*
+------------+----------+--------+----------------------------------------+-------+---------------+
| Programa:  | IFISA04B | Autor: | Jorge Henrique Alves - Anadi Soluções  | Data: | Dezembro/2014 |
+------------+----------+--------+----------------------------------------+-------+---------------+
| Descrição: | Gatilho para confirmar a mudança do TES                                            |
+------------+------------------------------------------------------------------------------------+
| Uso:       | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

User Function IFISA04B(_cConteudo,_cTes,_cTabela)
Local _nPosCfo := _nPVL := _nPVD := 0, _aDadosCfo := {}, _cTipo := ""  
Default _cConteudo := "", _cTes := "", _cTabela := ""

If !Empty(_cTes) .And. _cTabela == "SUB"
    M->UB_TES := _cTes
    MaFisAlt("IT_TES",_cTes,n)
    MaFisRef("IT_TES","TK273",_cTes)
    
    //MaFisRef("IT_VALMERC","TK273",aCols[n][_nPTot])
    Eval(bGDRefresh)
    Eval(bRefresh)
ElseIf !Empty(_cTes) .And. _cTabela == "SC6"

    _cTipo := IIf(M->C5_TIPO $ "D/B","SA2","SA1")
    dbSelectArea(IIf(M->C5_TIPO $ "D/B","SA2","SA1"))
    dbSetOrder(1)
    MsSeek(xFilial(_cTipo) + M->C5_CLIENTE + M->C5_LOJACLI)
    If _cTipo == "SA2"
        cGrupo  := SA2->A2_GRPTRIB
        cEstado := SA2->A2_EST
    Else
        cGrupo  := SA1->A1_GRPTRIB
        cEstado := SA1->A1_EST
    EndIf

    DbSelectArea("SF4")
    DbSetOrder(1)
    _nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF") })
    If _nPosCfo > 0 .And. MsSeek(xFilial("SF4") + _cTes)
        _aDadosCfo := {} 
        AAdd(_aDadosCfo,{"OPERNF","S"})
        AAdd(_aDadosCfo,{"TPCLIFOR",If(_cTipo == "SA1", SA1->A1_TIPO   , SA2->A2_TIPO )})
        AAdd(_aDadosCfo,{"UFDEST"  ,If(_cTipo == "SA1", SA1->A1_EST    , SA2->A2_EST  )})
        AAdd(_aDadosCfo,{"INSCR"   ,If(_cTipo == "SA1", SA1->A1_INSCR  , SA2->A2_INSCR)})
        AAdd(_aDadosCfo,{"CONTR"   ,If(_cTipo == "SA1", SA1->A1_CONTRIB, "")})
        aCols[n][_nPosCfo] := MaFisCfo( ,SF4->F4_CF,_aDadosCfo ) 
    EndIf    
EndIf

Return _cConteudo