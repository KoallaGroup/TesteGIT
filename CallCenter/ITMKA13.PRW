#include "protheus.ch"       
#INCLUDE "topconn.ch"

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | ITMKA13  | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Abril/2014    |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Consulta de similares													   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cPed	= Código do pedido do callcenter							   		   |
+-------------+--------------------------------------------------------------------------------+
*/        

User Function ITMKA13(cPed)
	Local aCampos  := {}
	Local aAreaATU := GetArea()                                             
	Local aButtons := {}                                                    
	Local cProdAlt := ""

    Private cNome 		:= Space(40)
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
	
	default cPed	    := space(TAMSX3("B1_COD")[1])

	aObjects := {}
	aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	:= MsObjSize( ainfo, aObjects )
	
	CriaHeader()
	CriaCols(cPed)
	
	if(Empty(aColsB))
		msginfo("Pedido não passou por reativação")
		Return .T.
	EndIf
	
	DEFINE MSDIALOG oDlgTMP TITLE "Log de Abertura de Chamado" FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.       

    @ 6,005 Say "Pedido :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont14 
    @ 6,035 Say cPed Picture "@!" Size 40,10 of oDlgTMP PIXEL FONT oFont14 //VALID CriaCols(cProd,cTab)

//    @ 6,090 Say "Descrição :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14 
//    @ 5,130 MsGet cProDesc Picture "@!" Size 200,10 of oDlgTMP PIXEL FONT oFont14 
    
    oGetTM1 := MsNewGetDados():New(20, 0, 140, 455, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

	ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{||oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)              
	
RestArea(aAreaATU)  

Return .T.

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
	aHeaderB      := {}
	aCpoHeader   := {"ZT_NMUSR", "ZT_DATA","ZT_HORA","ZT_OBS"}
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
|	Programa : CriaCols				 	| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(cPed)
	Local nQtdCpo   := 0
	Local nCols     := 0                                             
	Local n			:= 0                    
	Local nPos_User	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "ZT_NMUSR" }) 
	Local nPos_Data	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "ZT_DATA" })
	Local nPos_Hora	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "ZT_HORA" })
   	Local nPos_Obs	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "ZT_OBS"  }) 

	nQtdCpo := Len(aHeaderB)
	
	If(select("TRB_SZT") > 0)
		TRB_SB1->(DbCloseArea())
	EndIf
    
    _cQuery := "SELECT SZT.ZT_NMUSR,                   "
    _cQuery += "SZT.ZT_DATA,                           "
    _cQuery += "SZT.ZT_HORA,                           "
    _cQuery += "SZT.ZT_OBS                             "
    _cQuery += "FROM " + retSqlname("SZT") + " SZT     "
    _cQuery += "WHERE SZT.D_E_L_E_T_ = ' ' AND         "
    _cQuery += "SZT.ZT_PEDIDO = '" + cPed + "'         "
	_cQuery := ChangeQuery(_cQuery)
	TcQuery _cQuery New Alias "TRB_SZT" 
	TCSetField("TRB_SZT","ZT_DATA","D")
	
	DbSelectArea("TRB_SZT")
	While !(eof())
		n++    
      	AAdd(aColsB, Array(nQtdCpo+1))

		aColsB[n][nQtdCpo+1]  	 	:= .F.
		AcolsB[n][nPos_User] 	 	:= TRB_SZT->ZT_NMUSR
		AcolsB[n][nPos_Data] 	 	:= DTOC(TRB_SZT->ZT_DATA)
		AcolsB[n][nPos_Hora] 	 	:= TRB_SZT->ZT_HORA
		AcolsB[n][nPos_Obs] 	 	:= TRB_SZT->ZT_OBS
	    aColsB[n][Len(aHeaderB)+1]	:= .F.
			   	  	     
		DbSkip()
	EndDo

 	TRB_SZT->(dbCloseArea())
	 
return 
