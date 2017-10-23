#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM20			  		| 	Fevereiro/2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta especifica para indicar a referencia externa na tabela SZ2			  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM20()
	Local nX           	:= 0, _nAcao := 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "B1_COD"
	Local nFreeze      	:= 000
	Local nMax         	:= 99999
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
	
	aFieldTit 		:= 				{"Ref. Externa" ,"Filial"	,"Processo"}
	aAlterFields  	:= _aFields := 	{"Z2_PROCISA"	,"Z2_FILIAL","Z2_CODPROC"}
	
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
	
	AADD( _aHeader, { "Recno WT", "Z2_REC_WT", "", 09, 0,,, "N", "SZ2", "V"} )
	           
	//Insere produtos caso exista
	AADD(_aCols,{space(TamSX3("Z2_PROCISA")[1]) 	,;
				space(TamSX3("Z2_FILIAL")[1])		,;
				space(TamSX3("Z2_CODPROC")[1])		,;
				0									,;
				.F.									})
	
	//DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Processo" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Ref. Externa"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	
	@ 007,052 MsGet _cFilter Size 150,010 of ODlg PIXEL VALID (CriaCols(upper(alltrim(_cFilter))))

	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	//CriaCols(upper(alltrim(_cFilter)), '')
	
    @ 188,210 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()} 
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	oDlg:lCentered := .T.
	oDlg:Activate() 
	
	If(_nAcao != 1)
		cCodigo := space(TAMSX3("Z2_PROCISA")[1])	
	EndIf
	
	RestArea(cAliasOrg)
	
Return cCodigo

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM20B			  		| 	Fevereiro/2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Popula variavel Global para retorno da consulta específica					  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static function IGENM20B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols			  		| 	Fevereiro/2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Cria aCols da tela de referencias											  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(_cFilter)
	
	_cQuery := "SELECT Z2_PROCISA,Z2_FILIAL,Z2_CODPROC, MAX(SZ2.R_E_C_N_O_) AS RECSZ2   " + Chr(13)
	_cQuery += "FROM " + retSqlName("SZ2") + " SZ2                             	    	" + Chr(13)
	_cQuery += "WHERE SZ2.D_E_L_E_T_ = ' '                                         		" + Chr(13)
	_cQuery += "      AND Z2_PROCISA != ' '                                        		" + Chr(13)
	_cQuery += "      AND Z2_PROCISA LIKE '%" + _cFilter + "%'                     		" + Chr(13)
	_cQuery += "GROUP BY Z2_PROCISA,Z2_FILIAL,Z2_CODPROC                           		" + Chr(13)
	_cQuery += "ORDER BY Z2_PROCISA,Z2_FILIAL,Z2_CODPROC                           		"
	TCQUERY _cQuery NEW ALIAS "TRB_SZ2"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SZ2")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SZ2->Z2_PROCISA 		,;
					 TRB_SZ2->Z2_FILIAL		,;
					 TRB_SZ2->Z2_CODPROC			,;
					 TRB_SZ2->RECSZ2			,;
					 .F.})
		dbSkip()
	EndDo

	if  (TRB_SZ2->(BOF()) .AND. TRB_SZ2->(EOF()))
		AADD(_aCols,{space(TamSX3("Z2_PROCISA")[1]) 	,;
						space(TamSX3("Z2_FILIAL")[1])		,;
						space(TamSX3("Z2_CODPROC")[1])		,;
						0									,;
					.F.									})
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SZ2->(dbCloseArea())
	                              
return