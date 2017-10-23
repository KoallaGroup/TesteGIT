#include "protheus.ch"
#include "topconn.ch"

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | ICOMA05  | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Maio/2014     |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Consulta de Produto x Fornecedor					  					   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cCliente = Código+Loja do cliente									   		   |
+-------------+--------------------------------------------------------------------------------+
*/        

User Function ICOMA05()
	Local aCampos  := {}
	Local aButtons := {}                                                    
	Local cProdAlt := ""
	Local cNmCli   := ""
	Local nQtdCpo   := 0
	Local nCols     := 0
	Local cCod		:= "" 
    
	Private nQtde 		:= 0
    Private nDesc 		:= 0
	Private aHeaderB    := {}
	Private aColsB      := {}
	Private oGetTM1     := Nil
	Private oDlgTMP     := Nil 
	Private oButton		:= NIL
	Private aSize       := MsAdvSize(.T.)
	Private aEdit       := {}
	Private aRotina     := .F.      
	Private cLoja       := ""       
	Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
	Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)
	
	aObjects := {}
	aInfo	 := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	 := MsObjSize( ainfo, aObjects )

	//Cria janela
	CriaHeader()
	CriaCols()
	
	DEFINE MSDIALOG oDlgTMP TITLE "Consulta de Produtos x Fornecedor" FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.       

    @ 5,005 Say "Fornecedor: " SIZE 50,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,050 MsGet cA120Forn Picture "@!" Size 50,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

    @ 5,105 Say "Loja: " SIZE 50,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,135 MsGet cA120Loj Picture "@!" Size 30,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

//    @ 5,290 Button oButton PROMPT "Consultar"  SIZE 40,10   OF oDlgTMP PIXEL ACTION CriaCols(cCliente,cCodPro)
                                                                                              
    oGetTM1 := MsNewGetDados():New(20, 0, 140, 455, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

//	@ 143, 360 BUTTON oButton14 PROMPT "Detalhes" SIZE 037, 012 OF oDlgTMP ACTION {|| ConsNF(oGetTM1:aCols[oGetTM1:nat][Len(aHeaderB)])} PIXEL	
//	@ 143, 410 BUTTON oButton14 PROMPT "Fechar"   SIZE 037, 012 OF oDlgTMP ACTION {|| oDlgTMP:End()} PIXEL	

	ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{||cCod:=oGetTM1:aCols[oGetTM1:nAt][1],oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)              
	
Return cCod

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 			| 	Maio de 2014					  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader()
	aHeaderB      := {}
	aCpoHeader   := {"A5_PRODUTO","A5_NOMPROD"}
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
	
Return Nil                                                       

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols()  
Local   n			:= 0                 
Local	nPos_Prod 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A5_PRODUTO"	}) 
Local	nPos_DesP 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A5_NOMPROD" 	}) 
Local	nQtdCpo 	:= Len(aHeaderB)
             
	If(select("TRB_SC7") > 0)
		TRB_SC7->(DbCloseArea())
	EndIf     
	
		aColsB := {}

	    _cQuery := "SELECT SA5.A5_PRODUTO, SB1.B1_DESC				"
	    _cQuery += "FROM " + retSqlname("SA5") + " SA5              "
	    _cQuery += "INNER JOIN " + retSqlname("SB1") + " SB1 ON SB1.B1_COD = SA5.A5_PRODUTO AND "
		_cQuery += "					SB1.D_E_L_E_T_ = ' ' 		"
	    _cQuery += "WHERE SA5.D_E_L_E_T_ = ' ' AND                  "
	    _cQuery += "SA5.A5_FORNECE = '" + cA120Forn + "' AND    	"
	    _cQuery += "SA5.A5_LOJA = '" + cA120Loj + "'				"
		_cQuery := ChangeQuery(_cQuery)                                                              
		TcQuery _cQuery New Alias "TRB_SC7"                                                          
		
		If(Empty(TRB_SC7->A5_PRODUTO))                        
			n++
	      	AAdd(aColsB, Array(nQtdCpo+1))
	
			aColsB[n][nQtdCpo+1]  	 	:= .F.
			aColsB[n][nPos_Prod] 	 	:= space(TamSx3("A5_PRODUTO")[1])
			aColsB[n][nPos_DesP] 	 	:= space(TamSx3("A5_NOMPROD")[1])
			aColsB[n][Len(aHeaderB)+1]	:= .F.
		Else		
			DbSelectArea("TRB_SC7")
			While !(eof())
				n++    
		      	AAdd(AcolsB, Array(nQtdCpo+1))
		
				aColsB[n][nQtdCpo+1]  	 	:= .F.
				aColsB[n][nPos_Prod] 	 	:= TRB_SC7->A5_PRODUTO
				aColsB[n][nPos_DesP] 	 	:= TRB_SC7->B1_DESC
				aColsB[n][Len(aHeaderB)+1]	:= .F.
					   	  	     
				DbSkip()
			EndDo
		EndIf
	
	 	TRB_SC7->(dbCloseArea())

Return                                                                   