#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA04				 	| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta Especifica para Lojas de Clientes (Tipo Entrega e Tipo Cobrança)  	  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function ITMKA04(_cTipo)

	Local nOpc	    := 4
	Local nOptx    := nOpc
	Local aCampos  := {}
	Local aAreaATU := GetArea()
	Local aButtons := {}
	Private n          := 1
	Private aHeader    := {}
	Private aCols      := {}
	Private oGetTM1    := Nil
	Private oDlgTMP    := Nil
	Private aSize      := MsAdvSize(.T.)
	Private aCpoGet    := {"A1_LOJA", "A1_NREDUZ", "A1_EST", "A1_MUN", "A1_END"}
	Private aEdit      := {}
	Private aRotina    := .F.      
	Private cLoja      := ""
	Default _cTipo 	   := ""

    if funname() == "TMKA271"
        cCliente := M->UA_CLIENTE
    ElseIf FunName() == "ITMKCAL" .Or. AtIsRotina("U_ITMKCAL")
        cCliente := M->PA3_CODCLI
    ElseIf funname() == "TMKA503A"
 		cCliente := M->ADE__CLI 
    ElseIf funname() == "IFATA10"
    	cCliente := M->ZP_CODCLI
    Else 
        cCliente := M->A1_COD
    endif

	CriaHeader()
	CriaCols(nOpc, cCliente, _cTipo)

	if len(Acols) > 0 .and. !empty(Acols[1][1])
		//Roberto Marques - 21/10/2014
		If _cTipo == "F"
			_titulo := 'Loja de Faturamento'
		ElseIf _cTipo == "1"
			_titulo := 'Loja de Entrega'
		Else
			_titulo := 'Loja de Cobrança'
		Endif
			
		aObjects := {}
		aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
		aPosObj	:= MsObjSize( ainfo, aObjects )
		
		DEFINE MSDIALOG oDlgTMP TITLE _titulo FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] Of oMainWnd PIXEL  
		oDlgTMP:lMaximized := .F.
	
	    oGetTM1 := MsNewGetDados():New(0, 0, 140, 455, nOptx, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeader, aCols)
	    oGetTM1:oBrowse:BldBlClick := {|| cLoja := Acols[oGetTM1:nat][1],oDlgTMP:End()}
		ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{|| cLoja := Acols[oGetTM1:nat][1],oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)
	else
		cLoja := M->A1_LOJA
		alert ("Não existem lojas cadastradas !!")
	endif		
		
	RestArea(aAreaATU)
	
return cLoja

    

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader()
	aHeader      := {}
	aCpoHeader   := {"A1_LOJA", "A1_NREDUZ", "A1_EST", "A1_MUN", "A1_END"}
	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			If X3Uso(SX3->X3_Usado) 
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
			EndIf
		Endif
	Next _nElemHead	
	dbSelectArea("SX3")
	dbSetOrder(1)
	
Return Nil


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(nOpcao, cCliente, _cTipo)

	Local nQtdCpo := 0
	Local i       := 0
	Local nCols   := 0                                             

	Local nPos_A1_LOJA  :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_LOJA" }) 
    Local nPos_A1_NREDUZ:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_NREDUZ" })
    Local nPos_A1_EST   :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_EST" })
    Local nPos_A1_MUN   :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_MUN" })
    Local nPos_A1_END   :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_END" })
    
	nQtdCpo := Len(aHeader)
	n:=0                    
	
	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlName("SA1") + " SA1 "
	_cQuery += "WHERE A1_COD = '" + cCliente + "' "
	if _cTipo != 'F' 
	    if funname() == "MATA030"
	        cEstado := M->A1_EST
	    else
	        cEstado := SA1->A1_EST
	    endif
		_cQuery += "  AND A1_EST = '" + cEstado + "' "
	endif
	_cQuery += "  AND D_E_L_E_T_ <> '*' "
		
	TcQuery _cQuery New Alias "TRB_SA1"
	
	if TRB_SA1->(eof())
        AAdd(aCols, Array(nQtdCpo+1))
      	n++
		Acols[n][nPos_A1_LOJA]	:= TRB_SA1->A1_LOJA
	    Acols[n][nPos_A1_NREDUZ]:= TRB_SA1->A1_NREDUZ
        Acols[n][nPos_A1_EST]:= TRB_SA1->A1_EST
        Acols[n][nPos_A1_MUN]:= TRB_SA1->A1_MUN
        Acols[n][nPos_A1_END]:= TRB_SA1->A1_END
	    
	    aCols[n][Len(aHeader)+1] := .F.
	endif
	
   	while ! TRB_SA1->(eof())
      	AAdd(aCols, Array(nQtdCpo+1))
      	n++
      	
		Acols[n][nPos_A1_LOJA]	:= TRB_SA1->A1_LOJA
	    Acols[n][nPos_A1_NREDUZ]:= TRB_SA1->A1_NREDUZ
        Acols[n][nPos_A1_EST]:= TRB_SA1->A1_EST
        Acols[n][nPos_A1_MUN]:= TRB_SA1->A1_MUN
        Acols[n][nPos_A1_END]:= TRB_SA1->A1_END
	    
	    aCols[n][Len(aHeader)+1] := .F.
	    
        TRB_SA1->(DbSkip())
   	enddo
   	
   	TRB_SA1->(dbCloseArea())
	
return .T.


                                                             
user Function ITMKA04V(tipo)
                           
	If ! inclui 		
		if tipo == 1	
			if ! ExistCpo("SA1",M->A1_COD+M->A1__LJAENT)
				return .F.
			endif
		endif		
		if tipo == 2	
			if ! ExistCpo("SA1",M->A1_COD+M->A1__LJACOB)
				return .F.
			endif
		endif		
	Else
        if tipo == 1 .And. M->A1__LJAENT != M->A1_LOJA      
            if ! ExistCpo("SA1",M->A1_COD+M->A1__LJAENT)
                return .F.
            endif
        endif       
        if tipo == 2 .And. M->A1__LJACOB != M->A1_LOJA    
            if ! ExistCpo("SA1",M->A1_COD+M->A1__LJACOB)
                return .F.
            endif
        endif
	EndIf
return .T.

