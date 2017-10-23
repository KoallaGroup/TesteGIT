#Include "Protheus.ch"

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | TMKACTIVE | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada executado na ativação do Objeto (tela de atendimento call center)    |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function TMKACTIVE() 
Local _aArea := GetArea(), _aSUA := SUA->(GetArea()), _aSUB := SUB->(GetArea())
Local nx := _nPItem := _nDisp := _nProd := _nArmz := _nQSol := _nQVen := 0
Local _lEfetiva := (Type("_lITMKCAL") <> "U" .And. _lITMKCAL)
Local _lSZN := (Type("_lNoSaldo") <> "U" .And. _lNoSaldo)
Local _lZUA := (Type("_lGrOn") <> "U" .And. _lGrOn)
Local _oButton1, _oButton2, _oGroup1, _oSay1, _oSay2, __oGrvOn, _lRecZUA := .f.

//Inicializa a contagem de item com a quantidade correta de ZEROS à esquerda
If Inclui
    _nPItm  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"})
    aCols[n][_nPItm] := StrZero(1,TamSX3("UB_ITEM")[1])
ElseIf Altera
    If Len(aCols) == 1 .And. Empty(aCols[n][ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO"})])
        _nPItm  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"})
        aCols[n][_nPItm] := StrZero(1,TamSX3("UB_ITEM")[1])    
    EndIf
EndIf

If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
    Return 
EndIf  

If(INCLUI .OR. ALTERA) .And. AtIsRotina("U_ITMKCAL")
    If !Empty(M->PA3_TPOPER)
        M->UA_TMK := M->PA3_TPOPER
    EndIf
    
    If Inclui
        M->UA__FILIAL := M->PA3_FILATE
        M->UA_CODCONT := _oGetPA3:aCols[_oGetPA3:nat][1]
        M->UA_DESCNT  := Posicione("SU5",1,xFilial("SU5") + M->UA_CODCONT,"U5_CONTAT")
        M->UA__TPOPE  := M->PA3_TPOPER
        If M->PA3_RESTRI == "S"
            M->UA__TIPPED := PADR("4",TamSX3("UA__TIPPED")[1])
            M->UA__DSCTIP := Posicione("SZF",1,xFilial("SZF") + M->UA__TIPPED,"ZF_DESC")
            M->UA__RESEST := "N"
            M->UA_OPER    := "2"   
            Eval(bFolderRefresh)
            If ExistTrigger("UA__TIPPED")
                RunTrigger(1,Nil,Nil,,"UA__TIPPED")
            EndIf
        EndIf
        
        If _lEfetiva .And. _lSZN
            aCols[1][Len(aHeader) + 1] := .t.
        EndIf
        
    EndIf

	If Empty(M->UA_TRANSP)
		M->UA_TRANSP := Alltrim(GetMv("MV__TRPTMK"))
	EndIf    
    
    If (Altera .Or. _lEfetiva) .And. !_lZUA 
        _nPItm  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"   })
        _nDisp  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ESTDSP"})
        _nQSol  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL"})
        _nQVen  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"  })
        _nProd  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO"})
        _nArmz  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL"  })

        DbSelectArea("ZUA")
        DbSetOrder(1)
        If DbSeek(SUA->UA_FILIAL + SUA->UA_NUM)
            If !ZUA->ZUA_SYNCOK
            	_lRecZUA := .f.
                
                DEFINE MSDIALOG _oGrvOn TITLE "GRAVACAO ONLINE" FROM 000, 000  TO 120, 500 PIXEL
                    @ 002, 003 GROUP _oGroup1 TO 042, 246 OF _oGrvOn PIXEL
                    @ 005, 006 SAY _oSay1 PROMPT "As informações deste pedido estão diferentes da última alteração realizada nele." SIZE 214, 007 OF _oGrvOn PIXEL
                    @ 013, 006 SAY _oSay2 PROMPT "Selecione a ação desejada" SIZE 071, 007 OF _oGrvOn PIXEL
                    @ 025, 006 SAY _oSay3 PROMPT "OBS.: Se optar por restaurar as informações e não CONFIRMAR a gravação das alterações, serão" SIZE 238, 007 OF _oGrvOn PIXEL
                    @ 032, 022 SAY _oSay4 PROMPT "mantidas as informações atuais do pedido." SIZE 178, 007 OF _oGrvOn PIXEL
                    @ 045, 104 BUTTON _oButton1 PROMPT "Manter Como Está" SIZE 058, 012 OF _oGrvOn PIXEL ACTION _oGrvOn:End()
                    @ 045, 172 BUTTON _oButton2 PROMPT "Restaurar Última Digitação" SIZE 073, 012 OF _oGrvOn PIXEL ACTION {|| _lRecZUA := .t.,_oGrvOn:End()}
                ACTIVATE MSDIALOG _oGrvOn CENTERED
                
                If _lRecZUA
                    MsAguarde({|| _lRecZUA := U_ITMKRECON("SUA",cFilAnt,SUA->UA_NUM,.f.)}, "Processando..","Recuperando informações do Cabeçalho...")
                    
                    If _lRecZUA
                        MsAguarde({|| _lRecZUA := U_ITMKRECON("SUB",cFilAnt,SUA->UA_NUM,.f.)}, "Processando..","Recuperando informações dos Itens...")
                    EndIf
                    
                    If !_lRecZUA
                        MsgAlert("Não foi possível recuperar as informações","ATENCAO")
                    Else
				        n := 1 //Len(aCols)
				        oGetTlv:oBrowse:NAT := n        
				        Eval(bGDRefresh)
				        Eval(bRefresh)
                    EndIf
                    
                EndIf
            Else    
                U_ITMKGRON("SUA","")                                                                           
            EndIf
        Else
            U_ITMKGRON("SUA","")                                                                       
        EndIf
        
        If _lEfetiva .And. Altera
	        For nx := 1 To Len(aCols)
	            If !Empty(aCols[nx][_nProd])
	                n := nx
                    aCols[nx][_nQVen] := U_ITMKA09(aCols[nx][_nProd],aCols[nx][_nArmz],aCols[nx][_nPItm],aCols[nx][_nQSol],.f.)
                    
                    n := nx
                    U_ITMKC05P("")
                    
                    n := nx
                    U_ITMKC07I("")
	                
	                Eval(bGDRefresh)
	                Eval(bRefresh)
	            EndIf
	        Next nx
	        n := 1 //Len(aCols)
	        oGetTlv:oBrowse:NAT := n        
	        Eval(bGDRefresh)
	        Eval(bRefresh)
        EndIf 
    
    ElseIf _lZUA .And. Altera
        //Restaura o aCols com as informações da gravação online
        MsAguarde({|| _lRecZUA := U_ITMKRECON("SUB",cFilAnt,SUA->UA_NUM,.f.)}, "Processando..","Recuperando informações...")
        
        If !_lRecZUA
            MsgAlert("Não foi possível recuperar as informações deste pedido","ATENCAO")
        Else
	        n := 1 //Len(aCols)
	        oGetTlv:oBrowse:NAT := n        
	        Eval(bGDRefresh)
	        Eval(bRefresh)
        EndIf
        
    EndIf
EndIf

RestArea(_aSUB)
RestArea(_aSUA) 
RestArea(_aArea)

Return