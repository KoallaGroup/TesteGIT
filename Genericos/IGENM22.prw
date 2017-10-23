#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
+------------+---------+--------+------------------------------------------+-------+----------------+
| Programa:  | IGENM22 | Autor: | Rubens Cruz - Anadi Consultoria 		   | Data: | Fevereiro/2015 |
+------------+---------+--------+------------------------------------------+-------+----------------+
| Descrição: | Consulta padrão Ocorrencias bancarias de saida                                       |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function IGENM22()
	Local nX           	:= 0, _nAcao := 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "SX5_CHAVE"
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
	
	aFieldTit 		:= 				{"Codigo"       ,"Descrição"}
	aAlterFields  	:= _aFields := 	{"X5_CHAVE"		,"X5_DESCRI"}
	
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
	           
	//Insere produtos caso exista
	/*
	AADD(_aCols,{space(TamSX3("ZX5_CODIGO")[1]) 	,;
				space(TamSX3("ZX5_DSCITE")[1])		,;
				.F.									})
	*/
	
	
	DEFINE MSDIALOG oDlg TITLE "Regioes de Venda" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oSayD := TSay():New( 009,004,{||"Buscar:"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	
	@ 007,052 MsGet _cFilter Size 150,010 of ODlg PIXEL VALID (CriaCols(upper(alltrim(_cFilter))))

	oFilD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	CriaCols(upper(alltrim(_cFilter)), '')
	
    @ 188,210 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()} 
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	oDlg:lCentered := .T.
	oDlg:Activate() 
	
	If(_nAcao != 1)
		cCodigo := space(TAMSX3("X5_CHAVE")[1])	
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
Local _cSQL := _cTab := ""
	
_cTab := GetNextAlias()
_cSQL := "SELECT DISTINCT SUBSTR(X5_CHAVE,1,2) AS X5_CHAVE, X5_DESCRI   "
_cSQL += "FROM " + RetSqlname("SX5") + " SX5  			                "
_cSQL += "WHERE SX5.D_E_L_E_T_ = ' '                    	      		"
_cSQL += "      AND SX5.X5_TABELA = '10'                    	  		"
_cSQL += "      AND SUBSTR(X5_CHAVE,3,1) = 'E'                			"
_cSQL += "      AND UPPER(X5_DESCRI) Like '%" + _cFilter + "%' 			" 
_cSQL += "ORDER BY X5_CHAVE												" 

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
	
_aCols :={}

DbSelectArea(_cTab)
DbGoTop()

While (!Eof())
	AADD(_aCols,{(_cTab)->X5_CHAVE 		,;
				 (_cTab)->X5_DESCRI		,;
				 .F.})
	dbSkip()
EndDo

if  ((_cTab)->(BOF()) .AND. (_cTab)->(EOF()))
    AADD(_aCols,{space(TamSX3("X5_CHAVE")[1])     ,;
                space(TamSX3("X5_DESCRI")[1])      ,;
                .F.                                 })
EndIf

oGetD:aCols := _aCols
//oGetD:nAt := Len(_aCols)

oDlg:Refresh()

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf
	                              
Return