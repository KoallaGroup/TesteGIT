#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+------------+
| Programa:  | ITMKGRON | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Março/2015 |
+------------+----------+--------+------------------------------------------+-------+------------+
| Descrição: | Gravação Online Call Center                                                       |
+------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                             |
+------------+-----------------------------------------------------------------------------------+
*/

User Function ITMKGRON(_cAlias,_cField,_nLin,_lDel,_nRecSUA,_nRecSUB,_lSync)
Local _nPItem := 0, _aArea := {}, _cNumPed := _cChaveSUB := "", _aSUB := {}, _aSUA := {}
Default _lDel := .f., _nLin := 0, _nRecSUA := 0, _nRecSUB := 0, _lSync := .f., _cAlias := "", _cField := ""

//No Execauto não faz o processo online
If (Type("lTk271Auto") <> "U" .AND. lTk271Auto) .Or. (Type("M->UA_CLIENTE") == "C" .And. Empty(M->UA_CLIENTE))
    Return 
EndIf  

If _nRecSUB == 0
	_nPItem := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" })
EndIf
_aArea  := GetArea()
_aSUB   := SUB->(GetArea())
_aSUA   := SUA->(GetArea())

If (Type("M->UA_NUM") == "C" .And. !Empty(M->UA_NUM)) .Or. _nRecSUA > 0
    
    If (Type("M->UA_NUM") == "C" .And. !Empty(M->UA_NUM))
        _cNumPed := M->UA_NUM
    Else
        _cNumPed := SUA->UA_NUM
    EndIf
    
    If _cAlias == "SUA"
        //Verifica se pedido já existe na tabela de log
        DbSelectArea("ZUA")
        DbSetOrder(1)
        If MsSeek(xFilial("ZUA") + _cNumPed) .And. !Empty(_cNumPed)
            While !Reclock("ZUA",.f.)
            EndDo
        Else
            While !Reclock("ZUA",.t.)
            EndDo
            ZUA->ZUA_FILIAL := cFilAnt
        EndIf
        
        ZUA->ZUA_SYNCOK := _lSync
        
        DbSelectArea("Z30")
        DbSetOrder(1)
        MsSeek(xFilial("Z30") + _cAlias)
        
        If _nRecSUA == 0 //Gravação pela variável de memória
            
            While !Eof() .And. Z30->Z30_ALIAS == _cAlias
                DbSelectArea("SX3")
                DbSetOrder(2)
                If MsSeek(Alltrim(Z30->Z30_CPOTMK)) .And. X3Uso(SX3->X3_USADO)
                    If Type(("M->" + Alltrim(Z30->Z30_CPOTMK))) <> "U"
                        &("ZUA->" + Alltrim(Z30->Z30_CPOGRV)) := &("M->" + Alltrim(Z30->Z30_CPOTMK)) 
                    EndIf
                EndIf
                
                DbSelectArea("Z30")
                DbSkip()
            EndDo
            
        Else //Gravação pela SUA
            
            While !Eof() .And. Z30->Z30_ALIAS == _cAlias
            
                DbSelectArea("SX3")
                DbSetOrder(2)
                If MsSeek(Alltrim(Z30->Z30_CPOTMK)) .And. X3Uso(SX3->X3_USADO)
                    If Type(("SUA->" + Alltrim(Z30->Z30_CPOTMK))) <> "U"
                        &("ZUA->" + Alltrim(Z30->Z30_CPOGRV)) := &("SUA->" + Alltrim(Z30->Z30_CPOTMK))
                    ElseIf !Empty(Z30->Z30_FORMUL)
                        &("ZUA->" + Alltrim(Z30->Z30_CPOGRV)) := &(Alltrim(Z30->Z30_FORMUL))
                    EndIf
                EndIf
                
                DbSelectArea("Z30")
                DbSkip()
            
            EndDo
            
        EndIf
        
        ZUA->(MsUnlock())
        
    ElseIf _cAlias == "SUB" .And. (_nLin > 0 .Or. _nRecSUB > 0)
    
        If _nRecSUB == 0
            _cChaveSUB := (_cNumPed + aCols[_nLin][_nPItem])
        Else
            _cChaveSUB := (_cNumPed + SUB->UB_ITEM)
        EndIf    
    
        //Verifica se pedido já existe na tabela de log
        DbSelectArea("ZUB")
        DbSetOrder(1)
        If MsSeek(xFilial("ZUB") + _cChaveSUB) .And. !Empty(_cNumPed)
            While !Reclock("ZUB",.f.)
            EndDo
        Else
            While !Reclock("ZUB",.t.)
            EndDo
            ZUB->ZUB_FILIAL := cFilAnt
            ZUB->ZUB_NUM    := _cNumPed
        EndIf
        
        ZUB->ZUB_SYNCOK := _lSync
        
        DbSelectArea("Z30")
        DbSetOrder(1)
        MsSeek(xFilial("Z30") + _cAlias)
        
        While !Eof() .And. Z30->Z30_ALIAS == _cAlias
           
            If _nRecSUB == 0 //Gravação pelo aCols
                
                DbSelectArea("SX3")
                DbSetOrder(2)
                If MsSeek(Alltrim(Z30->Z30_CPOTMK)) .And. X3Uso(SX3->X3_USADO) .And. (_nPos := ITMKGRPOS(Alltrim(Z30->Z30_CPOTMK))) > 0
                    
                    //Verifica se a informação virá da variável de memória (campo que está sendo editado) ou do aCols
                    If Alltrim(Z30->Z30_CPOTMK) $ ReadVar()
                        If Type(("M->" + Alltrim(Z30->Z30_CPOTMK))) <> "U"
                            &("ZUB->" + Alltrim(Z30->Z30_CPOGRV)) := &("M->" + Alltrim(Z30->Z30_CPOTMK))
                        EndIf                
                    Else 
                        If ValType("aCols[_nLin][_nPos]") <> Nil
                            &("ZUB->" + Alltrim(Z30->Z30_CPOGRV)) := aCols[_nLin][_nPos]
                        EndIf 
                    EndIf
                
                EndIf
                
                //Verifica se a linha está deletada
                If aCols[_nLin][Len(aHeader) + 1] .Or. _lDel
                    ZUB->ZUB_DELSUB := .t.
                EndIf
                
            Else //Gravação pela SUB
            
                DbSelectArea("SX3")
                DbSetOrder(2)
                If MsSeek(Alltrim(Z30->Z30_CPOTMK)) .And. X3Uso(SX3->X3_USADO)
                    If Type(("SUB->" + Alltrim(Z30->Z30_CPOTMK))) <> "U"
                        &("ZUB->" + Alltrim(Z30->Z30_CPOGRV)) := &("SUB->" + Alltrim(Z30->Z30_CPOTMK))
                    ElseIf !Empty(Z30->Z30_FORMUL)
                        &("ZUB->" + Alltrim(Z30->Z30_CPOGRV)) := &(Alltrim(Z30->Z30_FORMUL))
                    EndIf                
                EndIf
                ZUB->ZUB_DELSUB := .f.
            EndIf
            
            DbSelectArea("Z30")
            DbSkip()
        EndDo
        
        ZUB->(MsUnlock())    
    EndIf
    
EndIf

RestArea(_aSUB)
RestArea(_aSUA)
RestArea(_aArea)

Return _cField


/*
+------------+-----------+--------+------------------------------------------+-------+------------+
| Programa:  | ITMKGRPOS | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Março/2015 |
+------------+-----------+--------+------------------------------------------+-------+------------+
| Descrição: | Retorna a posição do campo no aCols                                                |
+-------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

Static Function ITMKGRPOS(_cCampo)
Local _nPos := aScan(aHeader, { |x| AllTrim(x[2]) == _cCampo })

Return _nPos


/*
+------------+----------+--------+------------------------------------------+-------+------------+
| Programa:  | ITMKGRDL | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Abril/2015 |
+------------+----------+--------+------------------------------------------+-------+------------+
| Descrição: | Deleta os registros da ZUA/ZUB                                                    |
+------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                             |
+------------+-----------------------------------------------------------------------------------+
*/

User Function ITMKGRDL(_cTabela,_cNumSUA)
Local _cSQL := "", _nOK := 0
Default _cTabela := "", _cNumSUA := ""

If _cTabela == "SUA"

    DbSelectArea("ZUA")
    DbSetOrder(1)
    If MsSeek(xFilial("ZUA") + _cNumSUA)
        _cSQL := "Update " + RetSqlName("ZUA")
        _cSQL += " Set D_E_L_E_T_ = '*' "
        _cSQL += "Where ZUA_FILIAL = '" + xFilial("ZUA") + "' And ZUA_NUM = '" + _cNumSUA + "' And D_E_L_E_T_ = ' ' "
        _nOK  := TCSQLExec(_cSQL)
    
        If _nOK < 0
            DbSelectArea("ZUA")
            DbSetOrder(1)
            If MsSeek(xFilial("ZUA") + _cNumSUA)
                While !Eof() .And. (ZUA->ZUA_FILIAL + ZUA->ZUA_NUM) == (xFilial("ZUA") + _cNumSUA) 
                    
                    Reclock("ZUA",.F.)
                    DbDelete()
                    MsUnlock()
                    
                    DbSkip()
                EndDo
            EndIf
        Else
            TCRefresh("ZUA")
        EndIf
    EndIf

ElseIf _cTabela == "SUB"

    DbSelectArea("ZUB")
    DbSetOrder(1)
    If MsSeek(xFilial("ZUB") + _cNumSUA)
        
        _cSQL := "Update " + RetSqlName("ZUB")
        _cSQL += " Set D_E_L_E_T_ = '*' "
        _cSQL += "Where ZUB_FILIAL = '" + xFilial("ZUB") + "' And ZUB_NUM = '" + _cNumSUA + "' And D_E_L_E_T_ = ' ' "        
        _nOK  := TCSQLExec(_cSQL)
    
        If _nOK < 0
            DbSelectArea("ZUB")
            DbSetOrder(1)
            If MsSeek(xFilial("ZUB") + _cNumSUA)
                While !Eof() .And. (ZUB->ZUB_FILIAL + ZUB->ZUB_NUM) == (xFilial("ZUB") + _cNumSUA) 
                    
                    Reclock("ZUB",.F.)
                    DbDelete()
                    MsUnlock()
                    
                    DbSkip()
                EndDo
            EndIf
        Else
            TCRefresh("ZUB")
        EndIf
        
    EndIf
    
EndIf

Return

/*
+------------+-----------+--------+------------------------------------------+-------+------------+
| Programa:  | ITMKRECON | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Abril/2015 |
+------------+-----------+--------+------------------------------------------+-------+------------+
| Descrição: | Recupera as informações da gravação online para o pedido do call center            |
+-------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

User Function ITMKRECON(_cAlias,_cFilSUA,_cNumSUA,_lGrvTab)
Local _lRet := .f., _nx := _nPos := 0

If _cAlias == "SUA"
    DbSelectArea("ZUA")
    DbSetOrder(1)
    If MsSeek(_cFilSUA + _cNumSUA)
        
        //Atualiza a SUA
        If _lGrvTab
            DbSelectArea("SUA")
            DbSetOrder(1)
            If MsSeek(_cFilSUA + _cNumSUA)
                If !Reclock("SUA",.f.)
                    MsgStop("Registro em uso por outra usuario")
                    Return .f.
                EndIf
            Else
                While !Reclock("SUA",.t.)
                EndDo
                //SUA->UA_FILIAL := _cFilSUA
            EndIf
        EndIf
        _lRet := .t.
                  
        DbSelectArea("Z30")
        DbSetOrder(1)
        MsSeek(xFilial("Z30") + _cAlias)
        
        While !Eof() .And. Z30->Z30_ALIAS == _cAlias
            DbSelectArea("SX3")
            DbSetOrder(2)
            If MsSeek(Alltrim(Z30->Z30_CPOTMK)) 
                If _lGrvTab .And. SX3->X3_CONTEXT != "V"                
                    &("SUA->" + Alltrim(Z30->Z30_CPOTMK)) := &("ZUA->" + Alltrim(Z30->Z30_CPOGRV))
                ElseIf !_lGrvTab .And. X3Uso(SX3->X3_USADO) .And. Type(("M->" + Alltrim(Z30->Z30_CPOTMK))) <> "U"
                    &("M->" + Alltrim(Z30->Z30_CPOTMK)) := &("ZUA->" + Alltrim(Z30->Z30_CPOGRV))
                EndIf
            EndIf
            
            DbSelectArea("Z30")
            DbSkip() 
        EndDo
    
        DbSelectArea("SUA")
        MsUnlock()
    EndIf

ElseIf _cAlias == "SUB"
    
    DbSelectArea("ZUB")
    DbSetOrder(1)
    If MsSeek(_cFilSUA + _cNumSUA)

        If !_lGrvTab
            //Remonta o aCols
            aCols := {}
        EndIf

        While !Eof() .And. (ZUB->ZUB_FILIAL + ZUB->ZUB_NUM) == (_cFilSUA + _cNumSUA)
            
            //Verifica existencia do item na SUB
            If _lGrvTab
                DbSelectArea("SUB")
                DbSetOrder(1)
                If MsSeek(ZUB->ZUB_FILIAL + ZUB->ZUB_NUM + ZUB->ZUB_ITEM)
                    If !Reclock("SUB",.f.)
                        MsgStop("Registro em uso por outra usuario")
                        Return .f.
                    ElseIf ZUB->ZUB_DELSUB
                        SUB->(DbDelete())
                        SUB->(MsUnlock())
                    EndIf
                ElseIf !ZUB->ZUB_DELSUB //Só inclui na SUB registros sem flag de Deletado
                    While !Reclock("SUB",.t.)
                    EndDo
                    SUB->UB_FILIAL := _cFilSUA
                EndIf
            Else
                //Adiciona nova linha no aCols
                AAdd(aCols, Array(Len(aHeader) + 1))
                _nx := Len(aCols)
            EndIf
            
            _lRet := .t.
                      
            DbSelectArea("Z30")
            DbSetOrder(1)
            MsSeek(xFilial("Z30") + _cAlias)
            
            While !Eof() .And. Z30->Z30_ALIAS == _cAlias
                DbSelectArea("SX3")
                DbSetOrder(2)
                If MsSeek(Alltrim(Z30->Z30_CPOTMK)) 
                    If _lGrvTab .And. SX3->X3_CONTEXT != "V"                
                        &("SUB->" + Alltrim(Z30->Z30_CPOTMK)) := &("ZUB->" + Alltrim(Z30->Z30_CPOGRV))
                    ElseIf !_lGrvTab .And. X3Uso(SX3->X3_USADO) .And. (_nPos := ITMKGRPOS(Alltrim(Z30->Z30_CPOTMK))) > 0
                        aCols[_nx][_nPos] := &("ZUB->" + Alltrim(Z30->Z30_CPOGRV))
                    EndIf
                EndIf
                
                DbSelectArea("Z30")
                DbSkip() 
            EndDo
            
            If !_lGrvTab //Refresh dos objetos do call center
                aCols[_nx][Len(aHeader) + 1] := ZUB->ZUB_DELSUB
                
                M->UB_ITEM    := ZUB->ZUB_ITEM
                M->UB_PRODUTO := ZUB->ZUB_PROD
                n := _nx 
                TK273Calcula("UB_PRODUTO")
                
                oGetTlv:oBrowse:NAT := _nx
                Eval(bGDRefresh)
                Eval(bRefresh)

                If !ZUB->ZUB_DELSUB .And. !Empty(ZUB->ZUB_PROD)
                    M->UB_ITEM    := ZUB->ZUB_ITEM
                    M->UB_PRODUTO := ZUB->ZUB_PROD
                    n := _nx
                    TK273Calcula("UB_PRODUTO")
                    n := _nx                    
                    If !Empty(ZUB->ZUB_TES)
                        M->UB_TES := ZUB->ZUB_TES
                        MaFisAlt("IT_TES",ZUB->ZUB_TES,n)
                        MaFisRef("IT_TES","TK273",ZUB->ZUB_TES)
                    EndIf                                        
                    
                    oGetTlv:oBrowse:NAT := _nx
                    Eval(bGDRefresh)
                    Eval(bRefresh)
                    
                    n := _nx
                    MaColsToFis(aHeader,    aCols,  _nx, "TK273",    .F. )
                    n := _nx
                    MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO )
        
                    n := _nx
                    U_ITMKC05P("")
                    n := _nx
                    U_ITMKC07I("")
                    
                    oGetTlv:oBrowse:NAT := _nx
                    Eval(bGDRefresh)
                    Eval(bRefresh)
                                        
                ElseIf ZUB->ZUB_DELSUB
                
                    n := _nx
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
            EndIf
            
            DbSelectArea("ZUB")
            DbSkip()
        EndDo
    Else
        _lRet := .t.
    EndIf
    
EndIf 

Return _lRet