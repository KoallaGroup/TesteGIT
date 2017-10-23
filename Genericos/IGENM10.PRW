#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM10			  		| 	Outubro de 2014				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para transportadoras através de uma expressao				  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IGENM10(_cTpFrete,_lCall,_lRedesp,_cTransp)
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "A4_COD"
	Local nFreeze      	:= 000
	Local nMax         	:= 9999
	Local cFieldOk     	:= "AllwaysTrue"
	Local cSuperDel    	:= ""
	Local cDelOk       	:= "AllwaysFalse"
	Local aAlterGDa    	:= {}
	Local cAliasOrg		:= GetArea()
	Local aFieldTit 	:= {}
	Local aAlterFields  := {}
	Local _aFields 		:= {}
	Local _cFilter		:= Space(30)
	Static cCodigo		:= ""
	
	Private nUsado     	:= 0
	Private _aHeader   	:= {}
	Private _aCols     	:= {}
	Private oDlgPgt1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	
	Default _cTpFrete := "",_lCall := .f., _lRedesp := .f., _cTransp := ""

	aFieldTit 		:= 				{"Código" 	,"Transportadora",	"Nome Fantasia",	"Estado"}
	aAlterFields  	:= _aFields := 	{"A4_COD" 	,"A4_NOME",			"A4_NREDUZ",		"A4_EST"}
	
	//Array com os campos que é permitida alteração.
	//aAlterGDa := aAlterFields
	
	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100,  15, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	
	aPosObj := MsObjSize(aInfo, aObjects)	
	
	nUsado:=0
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aFields)
		If SX3->(DbSeek(_aFields[nX]))
			Aadd(_aHeader, {aFieldTit[nx],aAlterFields[nx],SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,"R" /*SX3->X3_CONTEXT*/})
			nUsado:=nUsado+1
		Endif
	Next nX
	
	AADD( _aHeader, { "Recno WT", "A4_REC_WT", "", 09, 0,,, "N", "SA4", "V"} )
	
	//Insere clientes caso exista
	AADD(_aCols,{space(TamSX3("A4_COD")[1]) 		,;
				space(TamSX3("A4_NOME")[1])			,;
				space(TamSX3("A4_NREDUZ")[1])		,;
				space(TamSX3("A4_EST")[1])			,;
				""									,;
				.F.									})
	
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Transportadoras" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,ODlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)),_cTpFrete,_lCall,_lRedesp,_cTransp)},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	CriaCols(" ",_cTpFrete,_lCall,_lRedesp,_cTransp)
	oGetD:Refresh()

    @ 188,140 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM10B()
    @ 188,210 Button oButton PROMPT "Visualizar" SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM10A()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	
	oDlg:lCentered := .T.
	oDlg:Activate()

    DbSelectArea("SA4")
    DbSetOrder(1)
    DbSeek(xFilial("SA4") + cCodigo)	
	
	RestArea(cAliasOrg)
	
Return cCodigo

                                     
user function IGENM10A()
	CCADASTRO := "Transportadoras"
	posicione("SA4",1,xFilial("SA4")+_acols[oGetD:nAt][1]+_acols[oGetD:nAt][3],"A4_COD")
	AxVisual("SA4",_acols[oGetD:nAt][6],2)
return


user function IGENM10B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo


Static Function CriaCols(_cFilter,_cTpFrete,_lCall,_lRedesp,_cTransp)

    _cSegto := u_setsegto()
    
	If !_lCall .Or. _cTpFrete != "3"
    	_cQuery := "SELECT Distinct SA4.A4_COD, "
    	_cQuery += "		SA4.A4_NOME, " 
    	_cQuery += "		SA4.A4_NREDUZ, " 
    	_cQuery += "		SA4.A4_EST, " 
    	_cQuery += "		SA4.R_E_C_N_O_ RECNO "  
    	_cQuery += "FROM " + retSqlName("SA4") + "  SA4 "
    
    	If _lCall .And. !_lRedesp .And. _cTpFrete == "C" 
    		_cQuery += "INNER JOIN " + retSqlName("SZI") + "  SZI ON ZI_FILIAL = A4_FILIAL "
    		_cQuery += "  										 AND ZI_TRANSP = A4_COD "
    		_cQuery += "  										 AND ZI_VEND = '" +  M->UA_VEND + "' "
    		_cQuery += "  										 AND ZI_TIPO = 'T' "
    		_cQuery += "                                         AND SZI.D_E_L_E_T_ = ' ' "     
        ElseIf _lCall .And. _lRedesp .And. _cTpFrete == "C"
            _cQuery += "INNER JOIN " + retSqlName("SZI") + "  SZI ON ZI_FILIAL = A4_FILIAL "
            _cQuery += "                                         AND ZI_TRANSP = '" + _cTransp + "' "
            _cQuery += "                                         AND ZI_VEND = '" +  M->UA_VEND + "' "
            _cQuery += "                                         AND ZI_REDESP = A4_COD "
            _cQuery += "                                         AND ZI_TIPO = 'R' "
            _cQuery += "                                         AND SZI.D_E_L_E_T_ = ' ' "
    	EndIf
    	
    	_cQuery += "WHERE SA4.D_E_L_E_T_ = ' ' And SA4.A4_MSBLQL <> '1' "
    	If !Empty(_cFilter)
    	   _cQuery += "  AND (upper(SA4.A4_NOME) LIKE '%" + _cFilter + "%' OR upper(SA4.A4_COD) LIKE '%" + _cFilter + "%') "
        EndIf
        
        If _cTpFrete == "F" .And. SA4->(FieldPos("A4__TPFRET") > 0) //FOB
            _cQuery += " And SA4.A4__TPFRET = 'F' "
        EndIf       
    	
    ElseIf _lCall .And. _cTpFrete == "3"
        _cQuery := "SELECT  SA4.A4_COD, SA4.A4_NOME, SA4.A4_NREDUZ, SA4.A4_EST, SA4.R_E_C_N_O_ RECNO FROM " + retSqlName("SA4") + "  SA4 "
        _cQuery += "Inner Join " + RetSqlName("SZJ") + " ZJ On ZJ_FILIAL = '" + xFilial("SZJ") + "' And ZJ_TRANSP = A4_COD And ZJ.D_E_L_E_T_ = ' ' "
        _cQuery += "Inner Join " + RetSqlName("SA1") + " A1 On A1_FILIAL = '" + xFilial("SA1") + "' And A1__REGTRP = ZJ_REGIAO And A1.D_E_L_E_T_ = ' ' "
        _cQuery += "Where A4_FILIAL = '" + xFilial("SA4") + "' And SA4.D_E_L_E_T_ = ' ' And A4_MSBLQL <> '1' And "
        _cQuery +=      "A1_COD = '" + M->UA_CLIENTE + "' And A1_LOJA = '" + M->UA_LOJA + "' And ZJ_PERCFRT > 0 And ZJ_BASEMIN > 0 "
        _cQuery += "ORDER BY SA4.A4_NOME "
    EndIf
    
    If Select("TRB_SA4") > 0
        DbSelectArea("TRB_SA4")
        DbCloseArea()
    EndIf    
    
    If !Empty(_cQuery)
	   TCQUERY _cQuery NEW ALIAS "TRB_SA4"
	   
        _aCols :={}
    
    	dbSelectArea("TRB_SA4")
    	dbGoTop()
    	If Eof()
            If _lRedesp
    	       MsgAlert("Redespacho nao cadastrado para a transportadorea informada")
    	       cCodigo := ""
    	       oDlg:End()
    	       Return
            EndIf
            
            AADD(_aCols,{space(TamSX3("A4_COD")[1])         ,;
                        space(TamSX3("A4_NOME")[1])         ,;
                        space(TamSX3("A4_NREDUZ")[1])       ,;
                        space(TamSX3("A4_EST")[1])          ,;
                        0                                  ,;
                        .F.                                 })
    	Else
            While (!EOF())
                AADD(_aCols,{TRB_SA4->A4_COD,;
                            TRB_SA4->A4_NOME,;
                            TRB_SA4->A4_NREDUZ,;
                            TRB_SA4->A4_EST,;
                            TRB_SA4->RECNO,;
                            .F.})
                dbSkip()
            EndDo
    	EndIf
    	    
    	oGetD:aCols := _aCols
    	oGetD:nAt := Len(_aCols)
    	
    	oDlg:Refresh()
    
       	TRB_SA4->(dbCloseArea())
	EndIf                              
return