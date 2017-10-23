#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA15				 	| 	Maio de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta de opções no teleatendimento									  	  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ITMKA15()  
Local _aArea := GetArea() 
Local oDlg, oSbtn1, oCombo
Local aItems := {'NF x Cliente','Produto x NF x Cliente'}  
Local cCombo := aItems[1]
Local aButtons := {}

	DEFINE MSDIALOG oDlg TITLE "Consultas" From 0,0 To 140,332 OF oMainWnd PIXEL

	@10,55 Say "Selecione a consulta"		SIZE 55,10 OF oDlg PIXEL
	
 	oCombo := TComboBox():New(30,30,{|u|if(PCount()>0,cCombo:=u,cCombo)},; 
    aItems,100,20,oDlg,,/*bloco codigo quando alterar produto*/,,,,.T.,,,,,,,,,'cCombo')
	
	oSBtn1  := SButton():New( 55,100,1,{|| oDlg:End()},oDlg,,"", )
	oSBtn1  := SButton():New( 55,140,2,{|| cCombo := "",oDlg:End()},oDlg,,"", )
	
	ACTIVATE MSDIALOG oDlg CENTERED
    
	Do Case
	Case cCombo == 'NF x Cliente'
		U_ITMKA15E(M->ADE_CHAVE)
	Case cCombo == 'Produto x NF x Cliente'
		U_ITMKA15F(M->ADE_CHAVE)
	EndCase               

RestArea(_aArea)	

Return                        

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | ITMKA15E | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Maio/2014     |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Consulta de NF x Cliente							  					   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cCliente = Código+Loja do cliente									   		   |
+-------------+--------------------------------------------------------------------------------+
*/        

User Function ITMKA15E(cCliente)
	Local aCampos  := {}
	Local aButtons := {}                                                    
	Local cProdAlt := ""
	Local cNmCli   := ""
	Local cCodCli  := ""
	Local cLojCli  := ""
	Local nQtdCpo   := 0
	Local nCols     := 0                                             
	Local n			:= 0                    
	Local nPos_Doc	:= 0
	Local nPos_Seri := 0
	Local nPos_Emis	:= 0
   	Local nPos_Tipo	:= 0
   	Local nPos_ValB	:= 0

    Private nQtde 		:= 0
    Private nDesc 		:= 0
	Private aHeaderB    := {}
	Private aColsB      := {}
	Private oGetTM1     := Nil
	Private oDlgTMP     := Nil
	Private aSize       := MsAdvSize(.T.)
	Private aEdit       := {}
	Private aRotina     := .F.      
	Private cLoja       := "" 
	Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
	Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)
	
	default cCliente    := "" //space(TAMSX3("B1_COD")[1])

	If(Empty(cCliente))
		alert("Codigo do cliente não preenchido")
		return
	EndIf
	        
	cCodCli  := substr(cCliente,1,TamSX3("A1_COD")[1])
	cLojCli  := substr(cCliente,TamSX3("A1_COD")[1]+1)
	cNmCli   := Posicione("SA1",1,xFilial("SA1")+cCliente,"A1_NREDUZ")
	aObjects := {}
	aInfo	 := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	 := MsObjSize( ainfo, aObjects )

	CriaHeader({"F2_FILIAL","F2_DOC","F2_SERIE","F2_EMISSAO","F2_TIPO","F2_VALBRUT"})
	AADD( aHeaderB, { "Recno WT", "F2_REC_WT", "", 09, 0,,, "N", "SF2", "V"} )
	
	//Cria aCols
	nPos_Fil    := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_FILIAL" })
	nPos_Doc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_DOC" }) 
	nPos_Seri	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_SERIE" })
	nPos_Emis	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_EMISSAO" })
   	nPos_Tipo	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_TIPO"  }) 
   	nPos_ValB	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_VALBRUT"  }) 
	nQtdCpo 	:= Len(aHeaderB)

	If(select("TRB_SF2") > 0)
		TRB_SF2->(DbCloseArea())
	EndIf
    
    _cQuery := "SELECT SF2.F2_FILIAL,SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_EMISSAO,SF2.F2_TIPO, SF2.F2_VALBRUT, SF2.R_E_C_N_O_ AS RECNO  "
    _cQuery += "FROM " + RetSqlName("SF2") + " SF2                                               "
    _cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SF2.F2_CLIENTE AND      "
    _cQuery += "SA1.A1_LOJA = SF2.F2_LOJA AND                                                    "
    _cQuery += "SA1.D_E_L_E_T_ = ' '                                                             "
    _cQuery += "WHERE SF2.D_E_L_E_T_ = ' ' AND                                                   "
    _cQuery += "SA1.A1_COD || SA1.A1_LOJA = '" + cCliente + "'                                   "
	_cQuery := ChangeQuery(_cQuery)                                                              
	TcQuery _cQuery New Alias "TRB_SF2"                                                          
	TCSetField("TRB_SF2","F2_EMISSAO","D")
	
	DbSelectArea("TRB_SF2")
	DbGoTop()
	
	If Eof()
	    AAdd(aColsB, Array(nQtdCpo+1))			
		
		acolsB[1][nPos_Fil]         := space(TamSx3("F2_FILIAL")[1])
		acolsB[1][nPos_Doc] 	 	:= space(TamSx3("F2_DOC")[1])
		acolsB[1][nPos_Seri] 	 	:= space(TamSx3("F2_SERIE")[1])
		acolsB[1][nPos_Emis] 	 	:= CTOD("  /  /  ")
		acolsB[1][nPos_Tipo] 	 	:= space(TamSx3("F2_TIPO")[1])
		acolsB[1][nPos_ValB] 	 	:= 0
		aColsB[1][Len(aHeaderB)]    := TRB_SF2->RECNO
		aColsB[1][Len(aHeaderB)+1]	:= .F.
	    
	Else
		While !(eof())
			n++    
	      	AAdd(aColsB, Array(len(aHeaderB)+1))
	
			AcolsB[n][nPos_Fil]         := TRB_SF2->F2_FILIAL
			AcolsB[n][nPos_Doc] 	 	:= TRB_SF2->F2_DOC
			AcolsB[n][nPos_Seri] 	 	:= TRB_SF2->F2_SERIE
			AcolsB[n][nPos_Emis] 	 	:= DTOC(TRB_SF2->F2_EMISSAO)
			AcolsB[n][nPos_Tipo] 	 	:= TRB_SF2->F2_TIPO
			AcolsB[n][nPos_ValB] 	 	:= TRB_SF2->F2_VALBRUT
			aColsB[n][Len(aHeaderB)]	:= TRB_SF2->RECNO
			aColsB[n][Len(aHeaderB)+1]	:= .F.
				   	  	     
			DbSkip()
		EndDo
    EndIf
 	TRB_SF2->(dbCloseArea())	

	//Cria janela
	
	DEFINE MSDIALOG oDlgTMP TITLE "Consulta de NF x Cliente" FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.       

    @ 5,005 Say "Código: " SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,035 MsGet cCodCli Picture "@!" Size 50,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

    @ 5,095 Say "Loja: " SIZE 30,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,115 MsGet cLojCli Picture "@!" Size 12,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

    @ 5,180 Say "Nome Fantasia: " SIZE 70,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,240 MsGet cNmCli Picture "@!" Size 150,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

    oGetTM1 := MsNewGetDados():New(20, 0, 140, 455, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

	@ 143, 360 BUTTON oButton14 PROMPT "Detalhes" SIZE 037, 012 OF oDlgTMP ACTION {|| ConsNF(oGetTM1:aCols[oGetTM1:nat][Len(aHeaderB)])} PIXEL	
	@ 143, 410 BUTTON oButton14 PROMPT "Fechar"   SIZE 037, 012 OF oDlgTMP ACTION {|| oDlgTMP:End()} PIXEL	

	ACTIVATE MSDIALOG oDlgTMP CENTERED //ON INIT EnchoiceBar(oDlgTMP,{||oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)              
	
Return .T.
          
/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | ITMKA15F | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Maio/2014     |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Consulta de Produto x NF x Cliente					  					   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cCliente = Código+Loja do cliente									   		   |
+-------------+--------------------------------------------------------------------------------+
*/        

User Function ITMKA15F(cCliente)
	Local aCampos  := {}
	Local aButtons := {}                                                    
	Local cProdAlt := ""
	Local cNmCli   := ""
	Local nQtdCpo   := 0
	Local nCols     := 0                                             
	Local nPos_Doc	:= 0
	Local nPos_Seri := 0
	Local nPos_Emis	:= 0
   	Local nPos_Tipo	:= 0
   	Local nPos_ValB	:= 0
    
	Private cCodPro  	:= space(TamSx3("B1_COD")[1])
	Private cDesPro  	:= space(TamSx3("B1_DESC")[1])
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
	
	default cCliente    := "" //space(TAMSX3("B1_COD")[1])

	If(Empty(cCliente))
		alert("Codigo do cliente não preenchido")
		return
	EndIf
	        
	cCodCli  := substr(cCliente,1,TamSX3("A1_COD")[1])
	cLojCli  := substr(cCliente,TamSX3("A1_COD")[1]+1)
//	cNmCli   := Posicione("SA1",1,xFilial("SA1")+cCliente,"A1_NREDUZ")
	aObjects := {}
	aInfo	 := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	 := MsObjSize( ainfo, aObjects )

	//Cria janela
	CriaHeader({"D2_FILIAL","D2_COD","D2_DOC","D2_SERIE","D2_EMISSAO","F2_TIPO","F2_VALBRUT","D2_TOTAL"})
	AADD( aHeaderB, { "Recno WT", "F2_REC_WT", "", 09, 0,,, "N", "SF2", "V"} )
	CriaCols(cCliente)
	
	DEFINE MSDIALOG oDlgTMP TITLE "Consulta de Produtos" FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.       

    @ 5,005 Say "Código: " SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,035 MsGet cCodPro Picture "@!" F3 "SB1LIK" Size 50,10 of oDlgTMP PIXEL FONT oFont14 VALID ITMKA15G(cCodPro)

    @ 5,095 Say "Descrição: " SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 5,140 MsGet cDesPro Picture "@!" Size 130,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

    @ 5,290 Button oButton PROMPT "Consultar"  SIZE 40,10   OF oDlgTMP PIXEL ACTION CriaCols(cCliente,cCodPro)
                                                                                              
    oGetTM1 := MsNewGetDados():New(20, 0, 140, 455, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

	@ 143, 360 BUTTON oButton14 PROMPT "Detalhes" SIZE 037, 012 OF oDlgTMP ACTION {|| ConsNF(oGetTM1:aCols[oGetTM1:nat][Len(aHeaderB)])} PIXEL	
	@ 143, 410 BUTTON oButton14 PROMPT "Fechar"   SIZE 037, 012 OF oDlgTMP ACTION {|| oDlgTMP:End()} PIXEL	

	ACTIVATE MSDIALOG oDlgTMP CENTERED //ON INIT EnchoiceBar(oDlgTMP,{||oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)              
	
Return .T.

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 			| 	Maio de 2014					  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader(aCpoHeader)
	aHeaderB      := {}
	//aCpoHeader   := {"ZT_NMUSR", "ZT_DATA","ZT_HORA","ZT_OBS"}
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

Static Function CriaCols(cCliente,cCodPro)  
Local   n			:= 0                 
Local   nPos_Fil    := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "D2_FILIAL"   })
Local	nPos_Cod 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "D2_COD" 		}) 
Local	nPos_Doc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "D2_DOC" 		}) 
Local	nPos_Seri	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "D2_SERIE" 	})
Local	nPos_Emis	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "D2_EMISSAO" 	})
Local   nPos_Tipo	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_TIPO"		}) 
Local   nPos_ValB	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_VALBRUT"  }) 
Local	nPos_Tot 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "D2_TOTAL" 	}) 
Local	nQtdCpo 	:= Len(aHeaderB)

default cCodPro 	:= ""

	If(select("TRB_SF2") > 0)
		TRB_SF2->(DbCloseArea())
	EndIf     
	
	if(Empty(cCodPro))
		aColsB := {}
		n++
      	AAdd(aColsB, Array(nQtdCpo+1))

        AcolsB[1][nPos_Fil]         := space(TamSx3("D2_FILIAL")[1])
		aColsB[1][nQtdCpo+1]  	 	:= .F.
		AcolsB[1][nPos_Cod] 	 	:= space(TamSx3("D2_COD")[1])
		AcolsB[1][nPos_Doc] 	 	:= space(TamSx3("D2_DOC")[1])
		AcolsB[1][nPos_Seri] 	 	:= space(TamSx3("D2_SERIE")[1])
		AcolsB[1][nPos_Emis] 	 	:= "  /  /    "
		AcolsB[1][nPos_Tipo] 	 	:= space(TamSx3("D2_TP")[1])
		AcolsB[1][nPos_ValB] 	 	:= 0
		AcolsB[1][nPos_Tot] 	 	:= 0
		AcolsB[1][Len(aHeaderB)] 	:= 0
		aColsB[1][Len(aHeaderB)+1]	:= .F.
	Else                           
	    _cQuery := "SELECT SD2.D2_FILIAL, SD2.D2_COD, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SF2.F2_TIPO, SF2.F2_VALBRUT, SD2.D2_TOTAL, SF2.R_E_C_N_O_ AS RECNO  "
	    _cQuery += "FROM " + RetSqlName("SD2") + " SD2                                                                    "
	    _cQuery += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL                             "
	    _cQuery += "AND SF2.F2_DOC = SD2.D2_DOC                                                                           "
	    _cQuery += "AND SF2.F2_SERIE = SD2.D2_SERIE                                                                       "
	    _cQuery += "AND SF2.D_E_L_E_T_ = ' '                                                                              "
	    _cQuery += "WHERE SD2.D_E_L_E_T_ = ' ' AND                                                                        "
	    _cQuery += "SF2.F2_CLIENTE || SF2.F2_LOJA = '" + cCliente + "' AND                                                "
	    _cQuery += "SD2.D2_COD = '" + cCodpro + "' 																		  "
		_cQuery := ChangeQuery(_cQuery)                                                              
		TcQuery _cQuery New Alias "TRB_SF2"                                                          
		TCSetField("TRB_SF2","D2_EMISSAO","D")
		
		oGetTM1:Acols := {}                              
		
		If(Empty(TRB_SF2->D2_COD))                        
			n++
	      	AAdd(oGetTM1:Acols, Array(nQtdCpo+1))
	
	        oGetTM1:Acols[n][nPos_Fil]          := space(TamSx3("D2_FILIAL")[1])
			oGetTM1:Acols[n][nQtdCpo+1]  	 	:= .F.
			oGetTM1:Acols[n][nPos_Cod]	 	 	:= space(TamSx3("D2_COD")[1])
			oGetTM1:Acols[n][nPos_Doc] 		 	:= space(TamSx3("D2_DOC")[1])
			oGetTM1:Acols[n][nPos_Seri] 	 	:= space(TamSx3("D2_SERIE")[1])
			oGetTM1:Acols[n][nPos_Emis] 	 	:= "  /  /    "
			oGetTM1:Acols[n][nPos_Tipo] 	 	:= space(TamSx3("D2_TP")[1])
			oGetTM1:Acols[n][nPos_ValB] 	 	:= 0
			oGetTM1:Acols[n][nPos_Tot] 	 		:= 0
			oGetTM1:Acols[n][Len(aHeaderB)] 	:= 0
			oGetTM1:Acols[n][Len(aHeaderB)+1]	:= .F.
		EndIf
		
		DbSelectArea("TRB_SF2")
		While !(eof())
			n++    
	      	AAdd(oGetTM1:Acols, Array(nQtdCpo+1))
	
            oGetTM1:Acols[n][nPos_Fil]          := TRB_SF2->D2_FILIAL
			oGetTM1:Acols[n][nQtdCpo+1]  	 	:= .F.
			oGetTM1:Acols[n][nPos_Cod] 	 		:= TRB_SF2->D2_COD
			oGetTM1:Acols[n][nPos_Doc] 	 		:= TRB_SF2->D2_DOC
			oGetTM1:Acols[n][nPos_Seri] 	 	:= TRB_SF2->D2_SERIE
			oGetTM1:Acols[n][nPos_Emis] 	 	:= DTOC(TRB_SF2->D2_EMISSAO)
			oGetTM1:Acols[n][nPos_Tipo] 	 	:= TRB_SF2->F2_TIPO
			oGetTM1:Acols[n][nPos_ValB] 	 	:= TRB_SF2->F2_VALBRUT
			oGetTM1:Acols[n][nPos_Tot] 	 		:= TRB_SF2->D2_TOTAL
			oGetTM1:Acols[n][Len(aHeaderB)]		:= TRB_SF2->RECNO
			oGetTM1:Acols[n][Len(aHeaderB)+1]	:= .F.
				   	  	     
			DbSkip()
		EndDo
	
	 	TRB_SF2->(dbCloseArea())
	EndIf
	
 	if(!Empty(cCodPro))
		oGetTM1:Refresh()
 	EndIf	

Return       

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | ITMKA15G | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Maio/2014     |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Validação produto									  					   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cCliente = Código+Loja do cliente									   		   |
+-------------+--------------------------------------------------------------------------------+
*/     

Static Function ITMKA15G(cCodPro)
Local lRet := .F.

If ExistCpo("SB1",cCodPro)
	cDesPro := posicione("SB1",1,xFilial("SB1")+cCodPro,"B1_DESC")
	lRet := .T.
Else
	cDesPro  	:= space(TamSx3("B1_DESC")[1])
EndIf           

Return lRet

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | ConsNF   | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Maio/2014     |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Validação produto									  					   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | nRecno = Codigo RECNO da SF2												   |
+-------------+--------------------------------------------------------------------------------+
*/                                                                                              

Static Function ConsNF(nRecno)
Local _aArea 	:= GetArea(),_cFilAtu := cFilAnt
Local _aAreaSF2 := SF2->(GetArea())

if(nRecno > 0)
	DBSELECTAREA("SF2")
	DBGOTO(nRecno)
	cFilAnt := SF2->F2_FILIAL   
	MC090Visual()        
EndIf

cFilAnt := _cFilAtu
		                  
RestArea(_aAreaSF2)
RestArea(_aArea)

Return