#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA14				 	| 	Maio de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta Mix Usual						  	  									|
|-----------------------------------------------------------------------------------------------|	
*/

user Function ITMKA14()
	Local nOpc	   := 2
	Local nOptx    := nOpc
	Local aCampos  := {}
	Local aAreaATU := GetArea()
	Local aButtons := {}
	Local _nRet	   := 0
		
    Private _cCliente	:= M->UA_CLIENTE
    Private _cNomeCli	:= ""
	Private aHeaderB    := {}
	Private aColsB      := {}
	Private oGetTM1    	:= Nil
	Private oDlgTMP     := Nil
	Private aSize       := MsAdvSize(.T.)
	Private aCpoGet     := {}
	Private aEdit       := {}
	Private aRotina     := .F.      
	Private cLoja       := ""
	
	oFont := tFont():New("Tahoma",,-14,,.t.)
                            
	CriaHeader()
	CriaCols()
	
	_lAltera := .F.               
	_titulo := 'Ultimos Produtos Adquiridos pelo Cliente'
		
	aObjects := {}
	aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	:= MsObjSize( ainfo, aObjects )
	
	DEFINE MSDIALOG oDlgTMP TITLE _titulo FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.       

    oGetTM1 := MsNewGetDados():New(20, 0, 140, 455, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)
                  
	_cNomeCli := posicione("SA1",1,"  "+_cCliente,"A1_NOME")
    @ 6,005 Say "Cliente :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont 
    @ 5,040 MsGet _cCliente when .F. Picture "999999" Size 40,10 of oDlgTMP PIXEL FONT oFont 
    @ 5,085 Say "-" SIZE 5,10 OF oDlgTMP PIXEL FONT oFont 
    @ 5,095 MsGet _cNomeCli when .F. Size 200,10 of oDlgTMP PIXEL FONT oFont 

	@ 143, 290 BUTTON oButton14 PROMPT "Fechar" SIZE 037, 012 OF oDlgTMP ACTION {|| _nRet := 0,oDlgTMP:End()} PIXEL	
	@ 143, 350 BUTTON oButton14 PROMPT "Incluir" SIZE 037, 012 OF oDlgTMP ACTION {|| _nRet := 1,oDlgTMP:End()} PIXEL	
	
	ACTIVATE MSDIALOG oDlgTMP CENTERED 

	if _nRet == 1
   	   	atAcols(aColsB[oGetTM1:nat])
	endif

	RestArea(aAreaATU)
	
return cLoja

    

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader()
	aHeaderB      := {}
	aCpoHeader   := {"UB_PRODUTO", "B1_DESC", "UA_EMISSAO", "B2_QATU", "UA_VALMERC", "E4_DESCRI"}
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

	aHeaderB[4][1] := "Saldo em Estoque"
	aHeaderB[6][1] := "Forma de Pagto."
	
Return Nil


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols()

	Local nQtdCpo := 0
	Local nCols   := 0                                             

	Local nPos_UB_PRODUTO  	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_PRODUTO" }) 
    Local nPos_B1_DESC		:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_DESC" })
    Local nPos_UA_EMISSAO	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_EMISSAO" })
    Local nPos_B2_QATU		:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B2_QATU" })
    Local nPos_UA_VALMERC	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_VALMERC" })
    Local nPos_E4_DESCRI	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "E4_DESCRI" })

	nQtdCpo := Len(aHeaderB)
	nn:=0                    
   
	_nLinhas:= 10
    _cQuery := "SELECT UA_NUM, UA_EMISSAO "
    _cQuery += "FROM " + retSqlName("SUA") + " SUA "
    _cQuery += "WHERE UA_CLIENTE = '" + _cCliente + "' "
    _cQuery += "  AND SUA.D_E_L_E_T_ <> '*' "           
    _cQuery += "  AND UA_FILIAL = '" + xFilial("SUA") + "' "
    _cQuery += "  AND ROWNUM <= '" + alltrim(str(_nLinhas)) + "' "
    _cQuery += "ORDER BY UA_EMISSAO DESC "           
    
	TcQuery _cQuery New Alias "TRB1"
                       
	do while ! TRB1->(eof())
	    _cQuery := "SELECT 	UA_NUM, "
	    _cQuery += "		UB_PRODUTO, "
	    _cQuery += "		UA_EMISSAO, "
	    _cQuery += "		UA_VALMERC, "
	    _cQuery += "		UA_CONDPG, "
	    _cQuery += "		UA__TABPRC, "
	    _cQuery += "		UA_TIPOCLI, "
	    _cQuery += "		UA_ESTE, "
	    _cQuery += "		E4_DESCRI, "
	    _cQuery += "		B2_QATU "
	    _cQuery += "FROM " + retSqlName("SUB") + " SUB " 
	    _cQuery += "INNER JOIN " + retSqlName("SUA") + " SUA ON UA_NUM = UB_NUM " 
	    _cQuery += "									    AND UA_FILIAL = UB_FILIAL "
	    _cQuery += "									    AND SUA.D_E_L_E_T_ <> '*' "
	    _cQuery += "INNER JOIN " + retSqlName("SE4") + " SE4 ON E4_CODIGO = UA_CONDPG " 
	    _cQuery += "									    AND SE4.D_E_L_E_T_ <> '*' "
	    _cQuery += "LEFT JOIN " + retSqlName("SB2") + " SB2 ON B2_COD = UB_PRODUTO " 
//	    _cQuery += "									   AND B2_FILIAL = UB_FILIAL "
	    _cQuery += "									   AND SB2.D_E_L_E_T_ <> '*' "
	    _cQuery += "WHERE SUB.UB_NUM = '" + TRB1->UA_NUM + "' "
	    _cQuery += "  AND SUB.D_E_L_E_T_ <> '*' "           
		    
		TcQuery _cQuery New Alias "TRB"
		TCSetField("TRB","UA_EMISSAO","D")
		
	   	while ! TRB->(eof())
	   		_nRes := ASCAN(aColsB, { |x| alltrim(x[1]) == alltrim(TRB->UB_PRODUTO)}) 
	   		_nRes1:= ASCAN(aCols, { |x| alltrim(x[2]) == alltrim(TRB->UB_PRODUTO)}) 
	   		
	   		if _nRes == 0 .and. _nRes1 == 0
		   		
		      	AAdd(aColsB, Array(nQtdCpo+1))
		      	nn++
		      	
				aColsB[nn][nPos_UB_PRODUTO]	:= TRB->UB_PRODUTO
			    aColsB[nn][nPos_B1_DESC]	:= posicione("SB1", 1, xFilial("SB1")+TRB->UB_PRODUTO, "B1_DESC")
				aColsB[nn][nPos_UA_EMISSAO]	:= TRB->UA_EMISSAO
				aColsB[nn][nPos_B2_QATU]	:= U_xSldProd(xFilial("SUA"),TRB->UB_PRODUTO, posicione("SB1", 1, xFilial("SB1")+TRB->UB_PRODUTO, "B1_LOCPAD"), TRB->UA_NUM ) //TRB->B2_QATU
				aColsB[nn][nPos_UA_VALMERC]	:= U_ITMKC05(TRB->UB_PRODUTO,TRB->UA_ESTE,TRB->UA__TABPRC,TRB->UA_TIPOCLI,"") 
				aColsB[nn][nPos_E4_DESCRI]	:= TRB->E4_DESCRI

			    aColsB[nn][Len(aHeaderB)+1] := .F.
			 endif
			    
	        TRB->(DbSkip())
	   	enddo
	   	TRB->(dbCloseArea())
        TRB1->(DbSkip())
	enddo
	   	
   	TRB1->(dbCloseArea())
	
return .T.



/*
|-----------------------------------------------------------------------------------------------|   
|   Programa : atACols                 |   Maio de 2014                                        	|
|-----------------------------------------------------------------------------------------------|
|   Desenvolvido por Luis Carlos dos Santos Junior - Anadi                                      |
|-----------------------------------------------------------------------------------------------|   
*/

Static Function atACols(cols)

    Local nQtdCpo 		:= 0
    Local nCols   		:= 0                                             

    Local nPos_Item     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" })
    Local nPos_Codigo   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
    Local nPos_Descricao:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_DESCRI" })
    Local nPos_Valor	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT" })
    Local nPos_Quant	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT" })
	Local nPos_QtdSol 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL" })
    
    Local cCposExc      := "UB_REC_WT/UB_ALI_WT/"

    nQtdCpo 			:= Len(aHeader)
    nAtual 				:= Len(aCols)  
    cItem  				:= aCols[nAtual][nPos_Item]
    
    _cCodProd			:= cols[1]

    _cQuery := "SELECT * "
    _cQuery += "FROM " + retSqlName("SB1") + " SB1 "
    _cQuery += "LEFT JOIN " + retSqlName("DA1") + " DA1  ON DA1_CODTAB = '" + M->UA_TABELA + "' "
    _cQuery += "												AND DA1.DA1_CODPRO = B1_COD "
    _cQuery += "												AND DA1.D_E_L_E_T_ <> '*' "
    _cQuery += "WHERE SB1.B1_COD  = '" + _cCodProd + "' "
    _cQuery += "  AND SB1.D_E_L_E_T_ <> '*' "
        
    TcQuery _cQuery New Alias "TRB_SB1"
    
    If Len(acols) > 1
	    AAdd(aCols, Array(nQtdCpo+1))   
	    nAtual ++
	    n++
    Endif   
        
    dbSelectArea("SX3")
    dbSetOrder(2)
    for x := 1 to len(aHeader)
		if alltrim(aHeader[x,2]) $ cCposExc
            aCols[nAtual,x] := ""
        else
        	dbSeek(alltrim(aHeader[x,2]))
            aCols[nAtual,x] := Criavar(SX3->X3_CAMPO,.T.)
        endif
	next x
 	aCols[nAtual][Len( aHeader )+1] := .F.
                
    cItem                      		:= Soma1( cItem )                
    Acols[nAtual][nPos_Item]		:= cItem
    Acols[nAtual][nPos_Codigo]  	:= TRB_SB1->B1_COD
    Acols[nAtual][nPos_Descricao]  	:= TRB_SB1->B1_DESC
    Acols[nAtual][nPos_Valor]		:= TRB_SB1->DA1_PRCVEN 
    Acols[nAtual][nPos_Quant]       := 1
    Acols[nAtual][nPos_QtdSol]      := 1

    M->UB_PRODUTO  	:= TRB_SB1->B1_COD
    M->UB_VRUNIT	:= TRB_SB1->DA1_PRCVEN 
    M->UB_QUANT     := 1
    M->UB__QTDSOL   := 1

	if ExistTrigger("UB_PRODUTO")
		RunTrigger(2,Len(aCols),,"UB_PRODUTO")
	endif
	if ExistTrigger("UB_QUANT")
		RunTrigger(2,Len(aCols),,"UB_QUANT")
	endif
	if ExistTrigger("UB_VRUNIT")
		RunTrigger(2,Len(aCols),,"UB_VRUNIT")
	endif
	
	M->UB_VLRITEM	:= M->UB_VRUNIT * M->UB_QUANT
	
    n := nAtual
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Depois de alimentar o aCols executa as funcoes fiscais para o calculo dos impostos desse novo tem  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TKP000A(M->UB_PRODUTO,  nAtual, NIL )
        
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Atualiza a variavel n novamente, pois a funcao TKP000A³
    //³executa um refresh no getDados.                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    n := nAtual
        
    TKP000B(M->UB_QUANT,    nAtual )
    MaColsToFis(aHeader,    aCols,  nAtual, "TK273",    .F. )
    Tk273Calcula("UB_PRODUTO",nAtual)                        
        
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Atualiza a variavel n novamente, pois a funcao Tk273Calcula³
    //³executa um refresh no getDados.                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    n := nAtual
        
    MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO )

    Tk273Calcula("UB_VRUNIT")                        
            
    TRB_SB1->(dbCloseArea())
	GETDREFRESH()

return .T.



