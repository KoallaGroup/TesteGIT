#include "protheus.ch"       
#INCLUDE "topconn.ch"

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | IESTA07  | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Abril/2014    |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Consulta de similares													   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cProd	= Código do produto											   		   |
|			  | cTab  	= Código da tabela de produto										   |
+-------------+--------------------------------------------------------------------------------+
*/        

User Function IESTA07(cProd,cTab,nPos_Cod,nPos_Desc,lIncl)  //nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit
	Local aCampos  := {}
	Local aAreaATU := GetArea()                                             
	Local aButtons := {}                                                    
	Local cProdAlt := ""
	Local lRet	   := .T. 
	Local x			:= 1            
	Local cCposExc  := "UB_REC_WT/UB_ALI_WT/"
	Local _nAtual 	:= Len(aCols)
	Local cItem     := ""                 
	Local nPos_Item	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" 		})
	Local nPos_QtSl	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL"   })
	Local nPos_Est	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ESTDSP"   })
	Local nPos_Prc  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"    })
	Local nPos_Qtd  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"     })
	Local nPos_Valor:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG"   })
	Local nAlt  	:= 0
	Local nLarg 	:= 0

	Default nPos_Cod	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO"   })
	Default nPos_Desc	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_DESCRI"    })
	
	Private cProDesc := IIF(!Empty(cProd),Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"),space(TAMSX3("B1_DESC")[1]))
    Private cNome := Space(40)
    Private nQtde := 0
    Private nDesc := 0
	Private aHeaderB    := {}
	Private aColsB      := {}
	Private oGetTM1    := Nil
	Private oDlgTMP    := Nil
	Private aSize      := MsAdvSize(.T.)
	Private aEdit      := {}
	Private aRotina    := .F.      
	Private cLoja      := "" 
	Private oFont14	   := tFont():New("Tahoma",,-10,,.t.)
	
	default cProd	   := space(TAMSX3("B1_COD")[1])
	default cTab	   := space(TAMSX3("DA1_CODTAB")[1])
	default nPos_Cod   := 0 
	default nPos_Desc  := 0                              
	default lIncl	   := .F.	
	
	CriaHeader()
//	CriaCols(nOpc, cCliente, cTipo)

	aObjects := {}
	aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	:= MsObjSize( ainfo, aObjects )
	
	DEFINE MSDIALOG oDlgTMP TITLE "Consulta de Similaridade" FROM aSize[7], 300 TO aSize[6]-300,aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.       
	nAlt  := (oDlgTMP:nClientHeight / 2) - 26
	nLarg := (oDlgTMP:nClientWidth  / 2) - 03

    @ 7,005 Say "Produto :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,030 MsGet cProd Picture "@!" F3 "SB1LIK" Size 40,10 of oDlgTMP PIXEL FONT oFont14 VALID CriaCols(cProd,cTab)

    @ 7,075 Say "Descrição :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,105 MsGet cProDesc Picture "@!" Size 100,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F. 
    
    @ 7,210 Say "Tabela :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,235 MsGet cTab F3 "DA0" Size 15,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F. //VALID CriaCols(cProd,cTab)

    oGetTM1 := MsNewGetDados():New(20, 0, nAlt, nLarg, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

	if (!Empty(cProd) .AND. !Empty(cTab))
		CriaCols(cProd,cTab)
	EndIf

	ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{||oDlgTMP:End()},{||lRet := .F.,oDlgTMP:End()},,aButtons)              
	
	RestArea(aAreaATU)  
	
	If(Empty(oGetTM1:Acols[oGetTM1:nAt][1]))
	     alert("Nenhum produto selecionado")
	     return
	EndIf

	If lRet
//		if nPos_Cod > 0	     
		If lIncl
			AAdd( aCols, Array(Len(aHeader)+1) )
			_nAtual++

			dbSelectArea("SX3")
			dbSetOrder(2)
			For x := 1 to len(aHeader)
				if alltrim(aHeader[x,2]) $ cCposExc
					aCols[_nAtual,x] := ""
				else
					dbSeek(alltrim(aHeader[x,2]))
					aCols[_nAtual,x] := Criavar(SX3->X3_CAMPO,.T.)
				endif
			Next x  
			cItem 		:= soma1(aCols[_nAtual-1][nPos_Item])

			aCols[_nAtual][Len( aHeader )]  := 0
			aCols[_nAtual][Len( aHeader )+1]:= .F.
			aCols[_nAtual][nPos_Item] 		:= cItem
			M->UB_PRODUTO                   := oGetTM1:Acols[oGetTM1:nAt][1]
			aCols[_nAtual][nPos_Cod] 		:= oGetTM1:Acols[oGetTM1:nAt][1]
            n := _nAtual               
            TK273Calcula("UB_PRODUTO")
            oGetTlv:oBrowse:NAT := _nAtual
            Eval(bGDRefresh)
            Eval(bRefresh)

			aCols[_nAtual][nPos_Desc] 		:= oGetTM1:Acols[oGetTM1:nAt][2]
			aCols[_nAtual][nPos_Est]        := oGetTM1:Acols[oGetTM1:nAt][3]		
            aCols[_nAtual][nPos_Prc]        := U_ITMKC05(Acols[_nAtual][nPos_Cod],SA1->A1_EST,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.f.)
            aCols[_nAtual][nPos_Valor]      := aCols[_nAtual][nPos_Prc]
/*                                                       
            If ExistTrigger("UB_PRODUTO")  
                RunTrigger(2,Len(aCols),,"UB_PRODUTO")
            EndIf  
*/    
            n := _nAtual
            MaColsToFis(aHeader,    aCols,  _nAtual, "TK273",    .F. )
            n := _nAtual
            MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO )

            n := _nAtual
            U_ITMKC05P("")
            n := _nAtual
            U_ITMKC07I("")
            
            oGetTlv:oBrowse:NAT := _nAtual
            Eval(bGDRefresh)
            Eval(bRefresh)
            
            //Atualiza a gravação online
            U_ITMKGRON("SUB","",_nAtual)
		Else 
		    _nAtual := n
            aCols[_nAtual][Len( aHeader )+1]:= .F.		           
            M->UB_PRODUTO                   := oGetTM1:Acols[oGetTM1:nAt][1]
            aCols[_nAtual][nPos_Cod]        := oGetTM1:Acols[oGetTM1:nAt][1]
            n := _nAtual               
            TK273Calcula("UB_PRODUTO")
            oGetTlv:oBrowse:NAT := _nAtual
            Eval(bGDRefresh)
            Eval(bRefresh)

            aCols[_nAtual][nPos_Desc]       := oGetTM1:Acols[oGetTM1:nAt][2]
            aCols[_nAtual][nPos_Est]        := oGetTM1:Acols[oGetTM1:nAt][3]        
            aCols[_nAtual][nPos_Prc]        := U_ITMKC05(Acols[_nAtual][nPos_Cod],SA1->A1_EST,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.f.)
            aCols[_nAtual][nPos_Valor]      := aCols[_nAtual][nPos_Prc]
/*                                                       
            If ExistTrigger("UB_PRODUTO")  
                RunTrigger(2,Len(aCols),,"UB_PRODUTO")
            EndIf  
*/    
            n := _nAtual
            MaColsToFis(aHeader,    aCols,  _nAtual, "TK273",    .F. )
            n := _nAtual
            MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO )

            n := _nAtual
            U_ITMKC05P("")
            n := _nAtual
            U_ITMKC07I("")
            
            oGetTlv:oBrowse:NAT := _nAtual
            Eval(bGDRefresh)
            Eval(bRefresh)

            //Atualiza a gravação online
            U_ITMKGRON("SUB","",_nAtual)
            
//			RunTrigger(2,n,,,aHeader[nPos_Cod][2])
		EndIf
//		endif
	EndIf
			
Eval(bGDRefresh)
Eval(bRefresh)

RestArea(aAreaATU)
Return                     

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 	| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader()
	aHeaderB    := {}
	aCpoHeader  := {"B1_COD", "B1_DESC" ,"B2_QATU","DA1_PRCVEN"}      
	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
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
	
	aHeaderB[1][3] := "@S10" //Picture do B1_COD

	aHeaderB[3][3] := "@E 999,999,999,999" 
	aHeaderB[3][4] := 12
	aHeaderB[3][5] := 0
	
	aHeaderB[4][3] := "@E 99,999,999.9999" 
	aHeaderB[4][4] := 13
	aHeaderB[4][5] := 4

Return Nil


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols				 	| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(cProd,cTab)
	Local nQtdCpo   := 0
	Local nCols     := 0  
	Local nn		:= 0                          
	Local nPrcVen	:= 0                             
	Local cEstCli	:= Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST")
	Local nPosProd  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_COD" 	}) 
    Local nPosTab	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_DESC" 	})
    Local nPosSaldo	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B2_QATU" 	})
    Local nPosPrcTb	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
    Local aItens	:= {}
    
    cProDesc := IIF(!Empty(cProd),Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"),space(TAMSX3("B1_DESC")[1]))
    oGetTM1:aCols := {}
    
	nQtdCpo := Len(aHeaderB)
	
	If(select("TRB_SB1") > 0)
		TRB_SB1->(DbCloseArea())
	EndIf
    
	//Query contem funcoes que rodam apenas em ORACLE
/*    _cQuery := "WITH SGIMENU(Filial,Produto,Similar, Descricao, QuantAtu, PrcVend)                          " + Chr(13)                              
    _cQuery += "AS                                                                                          " + Chr(13)       
    _cQuery += "(                                                                                           "  + Chr(13)
    _cQuery += "    SELECT GI_FILIAL, GI_PRODORI,   GI_PRODALT, SB1.B1_DESC,FCSLDPRD('" + M->UA__FILIAL + "',SGI.GI_PRODALT) SALDO,DA1.DA1_PRCVEN      "                    + Chr(13)
    _cQuery += "    FROM " + RetSqlName("SGI") + " SGI                                                      "  + Chr(13)
    _cQuery += "    INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  ' AND                    "  + Chr(13)
    _cQuery += "    									 SB1.B1_COD = SGI.GI_PRODORI AND                    "  + Chr(13)
    _cQuery += "										 SB1.D_E_L_E_T_ = ' '                               "  + Chr(13)
    _cQuery += "    INNER JOIN " + RetSqlName("DA1") + " DA1 ON DA1.DA1_FILIAL = SB1.B1_FILIAL AND          "  + Chr(13)
    _cQuery += "										 DA1.DA1_CODPRO = SGI.GI_PRODORI AND                "  + Chr(13)
    _cQuery += "										 DA1.D_E_L_E_T_ = ' '                               "            + Chr(13)                     
    _cQuery += "    INNER JOIN " + RetSqlName("DA0") + " DA0 ON DA0.DA0_CODTAB = DA1.DA1_CODTAB AND         "  + Chr(13)
    _cQuery += "										 DA0.D_E_L_E_T_ = ' '                               "            + Chr(13)                       
    _cQuery += "    WHERE SGI.D_E_L_E_T_ = ' ' AND                                                          "  + Chr(13)
    _cQuery += "    DA0.DA0_CODTAB = '" + cTab + "' AND                                                     "  + Chr(13)
    _cQuery += "    FCSLDPRD('" + M->UA__FILIAL + "',SGI.GI_PRODALT) > 0 AND                                "         + Chr(13)
    _cQuery += "    DA0.DA0_DATDE <= '" + DTOS(Date()) + "' AND                                             "  + Chr(13)
    _cQuery += "    (DA0.DA0_DATATE >= '" + DTOS(Date()) + "' OR DA0.DA0_DATATE = '        ')               "  + Chr(13)
    _cQuery += ")                                                                                           "  + Chr(13)
    _cQuery += "select distinct *                                                                           "  + Chr(13)
    _cQuery += "  from SGIMENU                                                                              "  + Chr(13)
    _cQuery += " start with PRODUTO = '" + cProd + "'                                                       "  + Chr(13)
    _cQuery += "connect by noCycle (prior SIMILAR   in(Produto,Similar)                                     "  + Chr(13)
    _cQuery += "                 or prior PRODUTO in(Produto,Similar))                                      "  + Chr(13)
    _cQuery += "                and Level <=2                                                               "  */

	aItens := U_IESTA07A(cProd,cTab,cEstCli)  

	If(Len(aItens) = 0)
		AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
			nn++                                                                     
			oGetTM1:Acols[nn][nPosProd]			:= ""
		    oGetTM1:Acols[nn][nPosTab]			:= ""                      
		    oGetTM1:Acols[nn][nPosSaldo]		:= 0
		    oGetTM1:Acols[nn][nPosPrcTb]		:= 0
		    oGetTM1:Acols[nn][Len(aHeaderB)+1] 	:= .F.
	Else
		For nX := 1 To Len(aItens)
	      	AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
			      	
			oGetTM1:Acols[nX][nPosProd]			:= aItens[nX][1]
		    oGetTM1:Acols[nX][nPosTab]			:= aItens[nX][2]
		    oGetTM1:Acols[nX][nPosSaldo]		:= aItens[nX][3]
		    oGetTM1:Acols[nX][nPosPrcTb]		:= aItens[nX][4]
		    oGetTM1:Acols[nX][Len(aHeaderB)+1] 	:= aItens[nX][5]               
		Next nX
	EndIf
	
   	oGetTM1:nat:=len(oGetTM1:Acols)
   	
	oGetTM1:Refresh()
return                                  

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA07A				 	| 	Novembro de 2014					  				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTA07A(cProd,cTab,cEstCli)  
Local aSimilar 	:= {}              
Local _aArea	:= GetArea()
Local _cQuery	:= ""
Local nX		:= 0
Local cPai		:= ""

If(select("TRB_SB1") > 0)
	TRB_SB1->(DbCloseArea())
EndIf

_cQuery := "SELECT GI_PRODORI ORIGEM,                                                              "  + Chr(13)
_cQuery += "       GI_PRODALT SIMILAR,                                                             "  + Chr(13)
_cQuery += "       SB1.B1_DESC DESCRICAO,                                                          "  + Chr(13)
_cQuery += "       FCSLDPRD('" + M->UA__FILIAL + "',SGI.GI_PRODALT) SALDO                          "  + Chr(13)
_cQuery += "FROM " + RetSqlName("SGI") + " SGI                                                     "  + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  ' AND                   "  + Chr(13)
_cQuery += "                         SB1.B1_COD = SGI.GI_PRODALT AND                               "  + Chr(13)
_cQuery += "                         SB1.D_E_L_E_T_ = ' '                                          "  + Chr(13)
_cQuery += "WHERE SGI.D_E_L_E_T_ = ' ' AND                                                         "  + Chr(13)
_cQuery += "      SGI.GI_PRODORI = '" + cProd + "'                                                 "  + Chr(13)
TcQuery _cQuery New Alias "TRB_SB1"

If(Empty(TRB_SB1->Similar))
	TRB_SB1->(DbCloseArea())

	_cQuery := "SELECT GI_PRODALT ORIGEM,                                                              "  + Chr(13)
	_cQuery += "       GI_PRODORI SIMILAR,                                                             "  + Chr(13)
	_cQuery += "       SB1.B1_DESC DESCRICAO,                                                          "  + Chr(13)
	_cQuery += "       SB1.B1_LOCPAD LOCPAD,                                                          "  + Chr(13)
	_cQuery += "       FCSLDPRD('" + M->UA__FILIAL + "',SGI.GI_PRODORI) SALDO                          "  + Chr(13)
	_cQuery += "FROM " + RetSqlName("SGI") + " SGI                                                     "  + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  ' AND                   "  + Chr(13)
	_cQuery += "                         SB1.B1_COD = SGI.GI_PRODALT AND                               "  + Chr(13)
	_cQuery += "                         SB1.D_E_L_E_T_ = ' '                                          "  + Chr(13)
	_cQuery += "WHERE SGI.D_E_L_E_T_ = ' ' AND                                                         "  + Chr(13)
	_cQuery += "      SGI.GI_PRODALT = '" + cProd + "'                                                 "  + Chr(13)
	TcQuery _cQuery New Alias "TRB_SB1"

   	While ! TRB_SB1->(eof())      
   		AAdd(aSimilar, Array(5))
		nX++

		aSimilar[nX][1]		:= TRB_SB1->SIMILAR
	    aSimilar[nX][2]		:= TRB_SB1->DESCRICAO
	    aSimilar[nX][3]		:= U_xSldProd(M->UA__FILIAL,TRB_SB1->SIMILAR, TRB_SB1->LOCPAD)//TRB_SB1->SALDO
	    aSimilar[nX][4]		:= U_ITMKC05(TRB_SB1->SIMILAR,cEstCli,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.F.)
	    aSimilar[nX][5] 	:= .F.
	    
		cPai += TRB_SB1->SIMILAR + ";"
        TRB_SB1->(DbSkip())
   	EndDo                             
   	
	TRB_SB1->(DbCloseArea())
   	cPai := Substr(cPai,1,Len(cPai)-1)
    cPai := FormatIn(cPai,";")
    
	_cQuery := "SELECT DISTINCT GI_PRODALT SIMILAR,                                                    "  + Chr(13)
	_cQuery += "       GI_PRODORI ORIGEM,                                                              "  + Chr(13)
	_cQuery += "       SB1.B1_DESC DESCRICAO,                                                          "  + Chr(13)
	_cQuery += "       FCSLDPRD('" + M->UA__FILIAL + "',SGI.GI_PRODALT) SALDO                          "  + Chr(13)
	_cQuery += "FROM " + RetSqlName("SGI") + " SGI                                                     "  + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  ' AND                   "  + Chr(13)
	_cQuery += "                         SB1.B1_COD = SGI.GI_PRODALT AND                               "  + Chr(13)
	_cQuery += "                         SB1.D_E_L_E_T_ = ' '                                          "  + Chr(13)
	_cQuery += "WHERE SGI.D_E_L_E_T_ = ' '                                                             "  + Chr(13)
	_cQuery += "      AND SGI.GI_PRODORI IN " + cPai + "                                               "  + Chr(13)
	_cQuery += "      AND SGI.GI_PRODALT != '" + cProd + "'                                            "  + Chr(13)
	_cQuery += "ORDER BY GI_PRODALT							                                           "  + Chr(13)
	TcQuery _cQuery New Alias "TRB_SB1"

   	While ! TRB_SB1->(eof())
		AAdd(aSimilar, Array(5))
		nX++

		aSimilar[nX][1]		:= TRB_SB1->SIMILAR
	    aSimilar[nX][2]		:= TRB_SB1->DESCRICAO
	    aSimilar[nX][3]		:= TRB_SB1->SALDO
	    aSimilar[nX][4]		:= U_ITMKC05(TRB_SB1->SIMILAR,cEstCli,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.F.)
	    aSimilar[nX][5] 	:= .F.

        TRB_SB1->(DbSkip())
   	EndDo 

	TRB_SB1->(DbCloseArea())
    
Else
   	While ! TRB_SB1->(eof())
		AAdd(aSimilar, Array(5))
		nX++

		aSimilar[nX][1]		:= TRB_SB1->SIMILAR
	    aSimilar[nX][2]		:= TRB_SB1->DESCRICAO
	    aSimilar[nX][3]		:= TRB_SB1->SALDO
	    aSimilar[nX][4]		:= U_ITMKC05(TRB_SB1->SIMILAR,cEstCli,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.F.)
	    aSimilar[nX][5] 	:= .F.

        TRB_SB1->(DbSkip())
   	EndDo 

	TRB_SB1->(DbCloseArea())
EndIf                       

RestArea(_aArea)

Return aSimilar