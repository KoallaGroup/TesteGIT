#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | ITMKA24 | Autor | Rubens Cruz	- Anadi Soluções   	 | Data | Agosto/2014	 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Criticas Comerciais/Financeiras											     |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
| Parametros | cFilial  = Filial do pedido de venda do CallCenter                            |
|			 | cPedido  = Pedido de venda                                                    |
|			 | cCliente = Código do Cliente                                                  |
|			 | cLoja    = Loja do Cliente                                                    |
|			 | cTipo    = Tipo de Consulta / C - Criticas Comerciais                         |
|			 |								 F - Criticas Financeiras                        |
|			 |								 T - Ambas as Criticas                           |
+------------+-------------------------------------------------------------------------------+
*/

//u_itmka24("03","000461","3795        ","191","C")

User Function ITMKA24(_cFilial,_cPedido,_cCliente,_cLoja,_cTipo,_aCols)
	Local _aArea		:= GetArea()
	Local aButtons		:= {} 
	Local lRet			:= .F.
	Local cTitulo		:= ""
	Local nOpcao		:= 1
	Local cTipPed		:= ""//Posicione("SZF",1,xFilial("SZF")+SUA->UA__TIPPED,"ZF_DESC") 
	Local cCliente		:= _cCliente + _cLoja + " - " + Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_NREDUZ")
	Local cEnd			:= alltrim(SA1->A1_END) + ' - ' + alltrim(SA1->A1_BAIRRO) + ' - ' + SA1->A1_MUN
	Local aCabec		:= {{010,065},;
							{110,135},;
							{185,245}} 
	Default _aCols		:= ""

	
	Private aHeader		:= {}               
	Private aCols		:= {}           
	Private aButtons   	:= {}
	Private oDlg		:= nil
	Private oGetTM1		:= nil
	Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
	Private oFont24		:= tFont():New("Tahoma",,-24,,.t.)

    Do Case
    	Case _cTipo == "C"
           cTitulo := OemToAnsi("CRÍTICA COMERCIAL")    
        Case _cTipo == "F"
           cTitulo := OemToAnsi("CRÍTICA FINANCEIRA")
        Case _cTipo == "T"
           cTitulo := OemToAnsi("CRÍTICA COMERCIAL/FINANCEIRA")
    EndCase                  

	If Select("TRB_Z05") > 0
		DbSelectArea("TRB_Z05")
		DbCloseArea()
	EndIf	
                             
	If(!Empty(_aCols))
		For nX := 1 To Len(_aCols)
			AADD(aCols,{_aCols[nX][6],;
						x3Combo("Z04_TIPO",_aCols[nX][7]),;
						.F.})
		Next nX
	Else
		_cQuery := "SELECT DISTINCT SUA.UA_NUM,                                                                         "
		_cQuery += "        SUA.UA_EMISSAO,                                                                             "
		_cQuery += "        SZF.ZF_DESC,                                                                                "
		_cQuery += "        SA1.A1_NREDUZ,                                                                              "
		_cQuery += "        TRIM(SA1.A1_END) || ' - ' || TRIM(SA1.A1_BAIRRO) || ' - ' || TRIM(SA1.A1_MUN) AS ENDERECO,  "
		_cQuery += "        Z05.Z05_TIPO,                                                                               "
		_cQuery += "        Z05.Z05_DESC                                                                                "
		_cQuery += "FROM " + retSqlName("Z05") + " Z05                                                                  "
		_cQuery += "INNER JOIN " + retSqlName("SUA") + " SUA ON SUA.UA_FILIAL = Z05.Z05_FILIAL AND                     "
		_cQuery += "                         SUA.UA_NUM = Z05.Z05_NUM AND                                               "
		_cQuery += "                         SUA.UA_CLIENTE = Z05.Z05_CLI AND                                           "
		_cQuery += "                         SUA.UA_LOJA = Z05.Z05_LOJA AND                                             "
		_cQuery += "                         SUA.D_E_L_E_T_ = ' '                                                       "
		_cQuery += "INNER JOIN " + retSqlName("SA1") + " SA1 ON SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND            "
		_cQuery += "                         SA1.A1_COD = Z05.Z05_CLI AND                                               "
		_cQuery += "                         SA1.A1_LOJA = Z05.Z05_LOJA AND                                             "
		_cQuery += "                         SA1.D_E_L_E_T_ = ' '                                                       "
		_cQuery += "INNER JOIN " + retSqlName("SZF") + " SZF ON SZF.ZF_FILIAL = '" + xFilial("SZF") + "' AND            "
		_cQuery += "                         SZF.ZF_COD = SUA.UA__TIPPED AND                                            "
		_cQuery += "                         SZF.D_E_L_E_T_ = ' ' 		                                                "
		_cQuery += "WHERE Z05.D_E_L_E_T_ = ' ' AND                                                                      "
		_cQuery += "      Z05.Z05_NUM = '" + _cPedido + "' AND                                                          "
		_cQuery += "      Z05.Z05_CLI = '" + _cCliente + "' AND                                                         "
		_cQuery += "      Z05.Z05_LOJA = '" + _cLoja + "' AND                                                           "
	    Do Case
	    	Case _cTipo == "C"
				_cQuery += "      Z05.Z05_TIPO IN ('1','3') AND                                                         	"
	        Case _cTipo == "F"
				_cQuery += "      Z05.Z05_TIPO IN ('2','3') AND                                                             "
	    EndCase                  
		_cQuery += "      Z05.Z05_FILIAL = '" + _cFilial + "'                                                           "
		_cQuery += "ORDER BY Z05.Z05_TIPO 					                                                            "
		TcQuery _cQuery New Alias "TRB_Z05"
	    TcSetField("TRB_Z05","UA_EMISSAO","D")
	    
		If(!Empty(TRB_Z05->UA_NUM))
			aCols	:= CriaCols("1")
		Else
			Alert(OemToAnsi("ESTE PEDIDO NÃO POSSUI ") + cTitulo)
			return nOpcao
		EndIf
					
		TRB_Z05->(DbCloseArea())

	EndIf

	aHeader := CriaHeader({"Z05_DESC"})
	aAdd(aHeader,{"Tipo", "Tipo","",09,0,"", "" ,"C" , "" ,"","","","","",""}) 
		
	If(!Empty(_aCols))
    	cTipPed := Posicione("SZF",1,xFilial("SZF")+M->UA__TIPPED,"ZF_DESC") 
	Else
    	cTipPed := Posicione("SZF",1,xFilial("SZF")+SUA->UA__TIPPED,"ZF_DESC") 
	EndIf

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Criticas Comerciais") From 000,000 To 500,600 OF oMainWnd PIXEL
	                                           
	@ 010,aCabec[1][1] Say "Pedido :"   			SIZE 80,10 OF oDlg PIXEL FONT oFont 
	@ 010,aCabec[2][1] Say "Data :" 				SIZE 80,10 OF oDlg PIXEL FONT oFont 
	@ 010,aCabec[3][1] Say "Tipo de Pedido :" 		SIZE 80,10 OF oDlg PIXEL FONT oFont 
		
	@ 025,aCabec[1][1] Say "Cliente :" 				SIZE 80,10 OF oDlg PIXEL FONT oFont 
	@ 040,aCabec[1][1] Say "End. Faturam. :" 		SIZE 80,10 OF oDlg PIXEL FONT oFont 
	
	@ 063,005 TO 064,297
	@ 087,005 TO 088,297   
	
    @ 010,aCabec[1][2] MsGet _cPedido		 		when .F. Size 30,10 of oDlg PIXEL FONT oFont 

	If(!Empty(_aCols))
    	@ 010,aCabec[2][2] MsGet DTOC(M->UA__PRVFAT)  when .F. Size 45,10 of oDlg PIXEL FONT oFont 
	Else
    	@ 010,aCabec[2][2] MsGet DTOC(SUA->UA__PRVFAT)  when .F. Size 45,10 of oDlg PIXEL FONT oFont 
	EndIf
	
    @ 010,aCabec[3][2] MsGet cTipPed 				when .F. Size 45,10 of oDlg PIXEL FONT oFont 
	    
    @ 025,aCabec[1][2] MsGet cCliente				when .F. Size 200,10 of oDlg PIXEL FONT oFont 
    @ 040,aCabec[1][2] MsGet cEnd 					when .F. Size 200,10 of oDlg PIXEL FONT oFont 
	   
	@ 060,aCabec[1][1] Say cTitulo Size 280,30 of oDlg PIXEL FONT oFont24 CENTERED

    oGetTM1 := MsNewGetDados():New(095, 0, 220, 303,0, "AllwaysTrue", "AllwaysTrue", "", , , , , , , oDlg, aHeader, aCols)
    
    If(Empty(_aCols))    
		If(_cTipo == "C")
			@ 230,200 Button oButton PROMPT "Itens Criticados"  SIZE 40,15   OF oDlg PIXEL ACTION ITMKA24A(_cFilial,_cPedido,_cCliente,_cLoja,_cTipo)
    	EndIf
    Else
		@ 230,200 Button oButton PROMPT "Finalizar" SIZE 40,15   OF oDlg PIXEL ACTION (nOpcao := 2,oDlg:End())
		@ 230,150 Button oButton PROMPT "Sair"  	SIZE 40,15   OF oDlg PIXEL ACTION (nOpcao := 3,oDlg:End())
    EndIf
    
    @ 230,250 Button oButton PROMPT "Retornar"  	SIZE 40,15   OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED                                                                                 
		
	restArea(_aArea)                                                                                      	
	
return nOpcao
                                       
/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | ITMKA24 | Autor | Rubens Cruz	- Anadi Soluções   	 | Data | Agosto/2014	 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Criacao de janela dos itens criticados									     |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
*/

Static Function ITMKA24A (_cFilial,_cPedido,_cCliente,_cLoja,_cTipo)
	Local aButtons		:= {} 
	Local cTipo			:= ""
	Local cTitulo		:= ""
	
	Private aHeaderB	:= {}
	Private aColsB		:= {}           
	Private aButtons   	:= {}
	Private oDlg2		:= nil
	Private oGetTM2		:= nil
	Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
                   
	aSize := MsAdvSize()

    aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{400,400,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)

    Do Case
    	Case _cTipo == "C"
           cTitulo := OemToAnsi("CRÍTICA COMERCIAL")    
        Case _cTipo == "F"
           cTitulo := OemToAnsi("CRÍTICA FINANCEIRA")
        Case _cTipo == "T"
           cTitulo := OemToAnsi("CRÍTICA COMERCIAL/FINANCEIRA")
    EndCase                  

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{400,400,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)

	If Select("TRB_SUB") > 0
		DbSelectArea("TRB_SUB")
		DbCloseArea()
	EndIf	

	_cQuery := "SELECT DISTINCT SUA.UA_DESC1,                                                                  "
	_cQuery += "       SUA.UA_VLRLIQ,                                                                          "
	_cQuery += "	   Z05.Z05_ITEM,                                                             			   "
	_cQuery += "       Z05.Z05_PRODUT,                                                                         "
	_cQuery += "       SB1.B1_DESC,                                                                            "
	_cQuery += "       SUB.UB_QUANT,                                                                           "
	_cQuery += "       SUB.UB_VRUNIT,                                                                          "
	_cQuery += "       SUB.UB__DESC2,                                                                            "
	_cQuery += "       SUB.UB__DESC3,                                                                          "
	_cQuery += "       SUB.UB_VLRITEM                                                                          "
	_cQuery += "FROM " + retSqlName("Z05") + " Z05                                                             "
	_cQuery += "INNER JOIN " + retSqlName("SUB") + " SUB ON SUB.UB__FILIAL = Z05.Z05_FILIAL AND                "
	_cQuery += "                         SUB.UB_NUM = Z05.Z05_NUM AND                                          "
	_cQuery += "                         SUB.UB_ITEM = Z05.Z05_ITEM AND                                        "
	_cQuery += "                         SUB.UB_PRODUTO = Z05.Z05_PRODUT AND                                   "
	_cQuery += "                         SUB.D_E_L_E_T_ = ' '                                                  "
	_cQuery += "INNER JOIN " + retSqlName("SUA") + " SUA ON SUA.UA_FILIAL = SUB.UB_FILIAL AND                  "
	_cQuery += "                         SUA.UA_NUM = SUB.UB_NUM AND                                           "
	_cQuery += "                         SUA.D_E_L_E_T_ = ' '                                                  "
	_cQuery += "INNER JOIN " + retSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND       "
	_cQuery += "                         SB1.B1_COD = Z05.Z05_PRODUT AND                                       "
	_cQuery += "                         SB1.D_E_L_E_T_ = ' '                                                  "
	_cQuery += "WHERE Z05.Z05_FILIAL = '" + _cFilial + "' AND                                                  "
	_cQuery += "      Z05.Z05_NUM = '" + _cPedido + "' AND                                                     "
	_cQuery += "      Z05.Z05_CLI = '" + _cCliente + "' AND                                                    "
	_cQuery += "      Z05.Z05_LOJA = '" + _cLoja + "' AND                                                      "
    Do Case
    	Case _cTipo == "C"
			_cQuery += "      Z05.Z05_TIPO IN ('1','3') AND                                                    "
        Case _cTipo == "F"
			_cQuery += "      Z05.Z05_TIPO IN ('2') AND                                                        "
    EndCase                  
	_cQuery += "      Z05.D_E_L_E_T_ = ' '                                                                     "
	_cQuery += "ORDER BY Z05.Z05_ITEM		                                                                   "
	TcQuery _cQuery New Alias "TRB_SUB"                                                                        
                                                                                                               
	aHeaderB := CriaHeader({"Z05_ITEM",;
 						    "Z05_PRODUT",;
  				            "B1_DESC",;
				       	    "UB_QUANT",;
				       	    "UB_VRUNIT",;
				       	    "UB__DESC2",;
				       	    "UB__DESC3",;
				       	    "UB_VLRITEM"})                                                                        
	aColsB	:= CriaCols("2")

	DEFINE MSDIALOG oDlg2 TITLE "Itens Criticados" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
                                           
	@ 010,010 Say "Perc. Desc. Pedido:"	SIZE 80,10 OF oDlg2 PIXEL FONT oFont 
	@ 010,200 Say "Total Geral:"		SIZE 80,10 OF oDlg2 PIXEL FONT oFont 

    @ 008,095 MsGet TRB_SUB->UA_DESC1  PICTURE "@E 999.99%"    when .F. Size 30,10 of oDlg2 PIXEL FONT oFont 
    @ 008,250 MsGet TRB_SUB->UA_VLRLIQ PICTURE "@E 999,999.99" when .F. Size 45,10 of oDlg2 PIXEL FONT oFont 

    oGetTM2 := MsNewGetDados():New(aPosObj[2,1]-10,aPosObj[2,2],aPosObj[2,3]-10,aPosObj[2,4],0, "AllwaysTrue", "AllwaysTrue", "", , , , , , , oDlg2, aHeaderB, aColsB)

    @ aPosObj[2,3]-5,aPosObj[2,4]-160 Button oButton PROMPT "Críticas"  SIZE 40,15   OF oDlg2 PIXEL ACTION ITMKA24B(_cPedido,oGetTM2:acols[oGetTM2:nat][1],_cTipo)
    @ aPosObj[2,3]-5,aPosObj[2,4]-070 Button oButton PROMPT "Fechar"  	SIZE 40,15   OF oDlg2 PIXEL ACTION oDlg2:End()

	ACTIVATE MSDIALOG oDlg2 CENTERED                                                                                 
	
	TRB_SUB->(DbCloseArea())
	
Return

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | ITMKA24B | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Agosto/2014	  |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Criacao de janela das criticas por item									      |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function ITMKA24B (_cPedido,_cItem,_cProduto,_cTipo)
	Private aHeaderC	:= {}
	Private aColsC		:= {}           
	Private aButtons   	:= {}
	Private oDlg3		:= nil
	Private oGetTM3		:= nil
	Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)

	If Select("TRB_Z05A") > 0
		DbSelectArea("TRB_Z05A")
		DbCloseArea()
	EndIf	

	_cQuery := "SELECT Z05.Z05_CODIGO,                         "
	_cQuery += "       Z05.Z05_DESC                            "
	_cQuery += "FROM " + retSqlName("Z05") + " Z05             "
	_cQuery += "WHERE Z05.Z05_NUM  = '" + _cPedido + "' AND              "
	_cQuery += "      Z05.Z05_ITEM = '" + _cItem + "' AND                "
    Do Case
    	Case _cTipo == "C"
			_cQuery += "      Z05.Z05_TIPO IN ('1','3') AND    "
        Case _cTipo == "F"
			_cQuery += "      Z05.Z05_TIPO IN ('2') AND        "
    EndCase                  
	_cQuery += "      Z05.D_E_L_E_T_ = ' '                     "
	_cQuery += "ORDER BY Z05.Z05_ITEM	                       "
	TcQuery _cQuery New Alias "TRB_Z05A"
    
	aHeaderC := CriaHeader({"Z05_CODIGO","Z05_DESC"})
	aColsC	 := CriaCols("3")

	DEFINE MSDIALOG oDlg3 TITLE OemToAnsi("CrÍticas do Item") From 000,000 To 300,400 OF oMainWnd PIXEL
                                           
    oGetTM3 := MsNewGetDados():New(0, 0, 120, 203,0, "AllwaysTrue", "AllwaysTrue", "", , , , , , , oDlg3, aHeaderC, aColsC)

    @ 130,140 Button oButton PROMPT "Fechar"  			SIZE 40,15   OF oDlg3 PIXEL ACTION oDlg3:End()

	ACTIVATE MSDIALOG oDlg3 CENTERED                                                                                 
	
	TRB_Z05A->(DbCloseArea())

return
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 	| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader(aCpoHeader)
Local	aHeader      := {}
	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			AAdd(aHeader, {Trim(SX3->X3_Titulo),;
			SX3->X3_Campo       ,;
			SX3->X3_Picture     ,;
			SX3->X3_Tamanho     ,;
			SX3->X3_Decimal     ,;
			SX3->X3_Valid       ,;
			SX3->X3_Usado       ,;
			SX3->X3_Tipo        ,;
			SX3->X3_Arquivo     ,;
			SX3->X3_Context})
		Endif
	Next _nElemHead	
	dbSelectArea("SX3")
	dbSetOrder(1)
	
Return aHeader


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols				 	| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(cTP,nQtdCpo)
	Local nCols     := 0 
	Local nn		:= 0                                            
	Local aCols		:= {}
	
If cTP == "1"
	DbSelectArea("TRB_Z05")
	DbGoTop()
	
	Do While (!eof())	
        AADD(aCols,{TRB_Z05->Z05_DESC,;
        			x3Combo("Z04_TIPO",TRB_Z05->Z05_TIPO),;
        			.F.})
		DbSkip()
    EndDo
ElseIf cTP == "2"
	DbSelectArea("TRB_SUB")
	DbGoTop()

	Do While (!eof())	
        AADD(aCols,{TRB_SUB->Z05_ITEM,;
        			TRB_SUB->Z05_PRODUT,;
        			TRB_SUB->B1_DESC,;
        			TRB_SUB->UB_QUANT,;
        			TRB_SUB->UB_VRUNIT,;
        			TRB_SUB->UB__DESC2,;
        			TRB_SUB->UB__DESC3,;
        			TRB_SUB->UB_VLRITEM,;
        			.F.})
		DbSkip()
    EndDo
Else
	DbSelectArea("TRB_Z05A")
	DbGoTop()

	Do While (!eof())	
        AADD(aCols,{TRB_Z05A->Z05_CODIGO,;
        			TRB_Z05A->Z05_DESC,;
        			.F.})
		DbSkip()
    EndDo
EndIf

DbGoTop()


return aCols
