#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKA06				 	| 	Abril de 2014				         			    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta Especifica para Kits de Produtos  	  									|
|-----------------------------------------------------------------------------------------------|
*/

User Function ITMKA06(nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)
Local nOpc	   	 := 2 
Local nOptx    	 := nOpc
Local aCampos  	 := {}
Local aAreaATU 	 := GetArea()
Local aButtons 	 := {}
Local cKit  	 := space(TamSX3("B1_COD")[1])
Local nPos_Desc2 := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
Local nPos_Desc3 := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })

Private cKitAlt  := space(TamSX3("B1_COD")[1])
Private _nVlTotK := 0
Private cNome 	 := Space(40)
Private nQtde 	 := 0
Private nDesc2 	 := 0
Private nDesc3 	 := 0, _oKit := _oNome := _oTotVl := Nil
Private cTabPad  := alltrim(GetMV("MV__TABBRA"))
Private aHeaderB := {}
Private aColsB   := {}, _nPUBKit := nPos_CodKit //Posicição da SUB que está o código do Kit
Private oGetTM1  := Nil
Private oDlgTMP  := Nil
Private aSize    := MsAdvSize(.T.)
Private aCpoGet  := {"U1_ACESSOR", "U1_DACESS", "U1_QTD"}
Private aEdit    := {}
Private aRotina  := .F.
Private cLoja    := "", _nQtdKit := nPos_QtdeKit

Private lErroKit := .F.

static _nMaxQtde

default nPos_CodKit := 0

oFont := tFont():New("Tahoma",,-12,,.t.)

CriaHeader()

_lAltera := .F.
_titulo := 'Consulta de Kits'

DEFINE MSDIALOG oDlgTMP TITLE _titulo FROM 0,0 TO 310,1145 PIXEL
oDlgTMP:lMaximized := .F.

@ 6,005 Say "Kit :" SIZE 25,10 OF oDlgTMP PIXEL FONT oFont
@ 5,025 MsGet _oKit Var cKit Picture "@!" F3 "SUG_ACE" Size 50,10 of oDlgTMP PIXEL FONT oFont VALID CriaCols(@cKit,"PROD") 
                                           
@ 6,075 Say "-" SIZE 05,10 OF oDlgTMP PIXEL FONT oFont
@ 5,080 MsGet _oNome Var cNome WHEN _lAltera Size 200,10 of oDlgTMP PIXEL FONT oFont 

@ 6,300 Say "Qtde :" SIZE 25,10 OF oDlgTMP PIXEL FONT oFont
@ 5,325 MsGet nQtde Picture PesqPict("SUB","UB__QTDSOL") Size 40,10 of oDlgTMP PIXEL FONT oFont VALID(verQtde(nQtde) .and. valKit() .and. CriaCols(@cKit,"QTD"))

@ 6,390 Say "%Desc.1 :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont
@ 5,430 MsGet nDesc2 Picture PesqPict("SUB","UB__DESC2") Size 40,10 of oDlgTMP PIXEL FONT oFont

@ 6,490 Say "%Desc.2 :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont
@ 5,530 MsGet nDesc3 Picture PesqPict("SUB","UB__DESC3") Size 40,10 of oDlgTMP PIXEL FONT oFont

oGetTM1 := MsNewGetDados():New(20, 0, 140, 575, /* GD_INSERT+GD_DELETE+GD_UPDATE */, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

_oKit:bChange := {|| cNome := Posicione("SB1",1,xFilial("SB1") + cKit,"B1_DESC"), _oNome:Refresh()}

if nPos_CodKit <> 0 .And. !Empty(aCols[n][nPos_CodKit])
	cKit    := iif(len(alltrim(aCols[n][nPos_CodKit])) <> 0 .And. !aCols[n][Len(aHeader) + 1], aCols[n][nPos_CodKit], space(16))
	cKitAlt := iif(len(alltrim(aCols[n][nPos_CodKit])) <> 0 .And. !aCols[n][Len(aHeader) + 1], aCols[n][nPos_CodKit], space(16))
	nQtde   := iif(aCols[n][nPos_Qtde] > 0 .And. !aCols[n][Len(aHeader) + 1]                 , aCols[n][nPos_Qtde]  , 0)
	nDesc2  := iif(nPos_Desc2 > 0 .And. !aCols[n][Len(aHeader) + 1]                 		 , aCols[n][nPos_Desc2] , 0)
	nDesc3  := iif(nPos_Desc3 > 0 .And. !aCols[n][Len(aHeader) + 1]                 		 , aCols[n][nPos_Desc3] , 0) 
	CriaCols(cKit)
endif

@145,270 Say "Total Itens:" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont
@143,325 MsGet _oTotVl Var _nVlTotK Picture PesqPict("SUB","UB_VRUNIT") Size 70,10 of oDlgTMP PIXEL When .f.
@143,450 BUTTON "Confirmar" SIZE 45,10 ACTION {||nOpca := 1, oDlgTMP:End()} OF oDlgTMP PIXEL
@143,510 BUTTON "Fechar"    SIZE 45,10 ACTION {||cKit := "", oDlgTMP:End()} OF oDlgTMP PIXEL

ACTIVATE MSDIALOG oDlgTMP CENTERED //ON INIT EnchoiceBar(oDlgTMP,{||if(valKit(),oDlgTMP:End(), nOpca := 1)},{||cKit := "", oDlgTMP:End()},,aButtons)

if !empty(cKit) .And. nQtde > 0 
	if cKitAlt <> cKit
		MsAguarde({|| atAcols(cKit, nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)}, "Atualizando pedido...")
	else
		MsAguarde({|| alteraAcols(cKit, nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)}, "Atualizando pedido...")
	endif
endif

//If FunName() == "ITMKA271"
If FunName() == "TMKA271" .Or. AtIsRotina("U_ITMKCAL")
    oGetTlv:oBrowse:NAT
    oGetTlv:oBrowse:Refresh()
EndIf

RestArea(aAreaATU)

return cLoja


Static function valKit()
_lRet := .T.

if nQtde == 0
//	msgAlert ("A quantidade precisa ser informada. Favor verificar !!")
//	_lRet := .F.
endif

return _lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 	| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader()
Local _aNome     := {"Itens Kit","Descrição","Qtd. Kit","Prc. Unit.","Disp. Local","Qtd. Solicit."}
//Local aHeaderB   := {}
Local aCpoHeader := {"U1_ACESSOR", "U1_DACESS", "U1_QTDBASE", "UB_VRUNIT", "UB__ESTDSP", "U1_QTD"}
For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {_aNome[_nElemHead],;
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
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaCols(cKit,_cField)

Local nQtdCpo := 0
Local nCols   := 0, _xItemK := ""

Local nPos_U1_ACESSOR  	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "U1_ACESSOR" })
Local nPos_U1_DACESS	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "U1_DACESS"  })
Local nPos_U1_QTD   	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "U1_QTD"     })
Local nPos_B2_QATU   	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__ESTDSP" })
Local nPos_UB_VRUNIT   	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_VRUNIT"  })
Local nPos_U1_BASE   	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "U1_QTDBASE" })
Local _lRet				:=  _lRetx	:=	.T., _cKitSUB := "", _nLinSUB := 0
Local __xKit 			:= cKit

Default _cField := "PROD"

If _nPUBKit > 0
    _nLinSUB := aScan(aCols,{|x| AllTrim(x[_nPUBKit]) == Alltrim(cKit) })
EndIf

If _nLinSUB > 0
    If !aCols[_nLinSUB][Len(aHeader) + 1]
        cKitAlt := cKit
        nQtde   := IIF(nQtde == 0,aCols[_nLinSUB][_nQtdKit],nQtde)
    EndIf
EndIf

lErroKit := .F.

dbSelectArea("SUG")
dbSetOrder(2)
If dbSeek(xFilial("SUG")+cKit) 
	cNome 	:= posicione("SB1",1,xFilial("SB1")+cKit,"B1_DESC")
	cKit 	:= SUG->UG_CODACE
ElseIf ! empty(cKit)
	_lRet := (_cField != "PROD") //só trava o campo se usuário estiver digitando o código do KIT
	cKit  := Space(TamSX3("B1_COD")[1])
	nQtde := 0
	oGetTM1:aCols := {}         
	oGetTM1:Refresh()
	_nVlTotK := 0
	_oTotVl:Refresh()
	MsgAlert('Produto não possui KIT !!!')
Endif		

If !Empty(cKit) .And. _lRet
	oGetTM1:aCols := {}
	
	nQtdCpo := Len(aHeaderB)
	nn:=0
	
	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlName("SU1") + " SU1 "
	_cQuery += "WHERE U1_CODACE  = '" + cKit + "' "
	_cQuery += "  AND SU1.D_E_L_E_T_ = ' ' "
	
	TcQuery _cQuery New Alias "TRB_SU1"
	
	_nMaxQtde := 0
	_nVlTotK  := 0
	while ! TRB_SU1->(eof())
		AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
		nn++
		
		oGetTM1:Acols[nn][nPos_U1_ACESSOR]	:= TRB_SU1->U1_ACESSOR
		oGetTM1:Acols[nn][nPos_U1_DACESS]	:= posicione("SB1", 1, xFilial("SB1")+TRB_SU1->U1_ACESSOR, "B1_DESC")
		oGetTM1:Acols[nn][nPos_U1_QTD]		:= TRB_SU1->U1_QTD * nQtde // Multiplica com a qtde de Kits
		oGetTM1:Acols[nn][nPos_U1_BASE]		:= TRB_SU1->U1_QTD
		If FunName() == "TMKA271" .Or. AtIsRotina("U_ITMKCAL")
    		oGetTM1:Acols[nn][nPos_B2_QATU]		:= U_xSldProd(M->UA__FILIAL,TRB_SU1->U1_ACESSOR, SB1->B1_LOCPAD, M->UA_NUM ) //Aleatorio(200, 0) // colocar na Produção  
    		oGetTM1:Acols[nn][nPos_UB_VRUNIT]	:= U_ITMKC05(TRB_SU1->U1_ACESSOR,SA1->A1_EST,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.f.)
    	Else
    	   _cCodFil := U_ITMKA19(SA1->A1_COD,SA1->A1_LOJA,SA1->A1__SEGISP)
    	   oGetTM1:Acols[nn][nPos_B2_QATU]     := U_xSldProd(_cCodFil,TRB_SU1->U1_ACESSOR, SB1->B1_LOCPAD)
    	   oGetTM1:Acols[nn][nPos_UB_VRUNIT]   := U_ITMKC05(TRB_SU1->U1_ACESSOR,SA1->A1_EST,"001",SA1->A1_TIPO,"",.f.)
    	EndIf
		
		oGetTM1:Acols[nn][Len(aHeaderB)+1] 	:= .F.
		
		_nVlTotK += TRB_SU1->U1_QTD * oGetTM1:Acols[nn][nPos_UB_VRUNIT] 
		_nMax := round(oGetTM1:Acols[nn][nPos_B2_QATU] / oGetTM1:Acols[nn][nPos_U1_BASE],0)
		//round(oGetTM1:Acols[nn][nPos_B2_QATU] / oGetTM1:Acols[nn][nPos_U1_QTD],0)
		if _nMax < _nMaxQtde .or. _nMaxQtde == 0
			_nMaxQtde := _nMax
		endif
		            
		If oGetTM1:Acols[nn][nPos_B2_QATU] < oGetTM1:Acols[nn][nPos_U1_QTD]
			_lRetx  := .F.
			lErroKit := .T.
			_xItemK := IIF(Empty(_xItemK),"",", ") + alltrim(oGetTM1:Acols[nn][nPos_U1_ACESSOR])
		Endif
		
		If _lRetx
			If Empty( oGetTM1:Acols[nn][nPos_UB_VRUNIT] )
				lErroKit := .T.
			Endif
		Endif
			
		TRB_SU1->(DbSkip())
	enddo

/*	
	If len(Acols) > 1
		AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
		nn++
		oGetTM1:Acols[nn][nPos_U1_ACESSOR]	:= ''
		oGetTM1:Acols[nn][nPos_U1_DACESS]	:= ''
		oGetTM1:Acols[nn][nPos_U1_QTD]		:= 0
		oGetTM1:Acols[nn][nPos_B2_QATU]		:= 0
		oGetTM1:Acols[nn][nPos_UB_VRUNIT]	:= 0
		oGetTM1:Acols[nn][Len(aHeaderB)+1] 	:= .F.
	Endif
*/
	oGetTM1:nat:=len(oGetTM1:Acols)
	
	TRB_SU1->(dbCloseArea())

	cKit := __xKit	
	oGetTM1:Refresh()
	If  !_lRetx 
		_lRet	:= .F.
		MsgAlert('O(s) item(s) '+_xItemK+' do Kit '+alltrim(__xKit)+' não possui saldo!!!')
		nQtde := 0
		_nVlTotK := 0
		cKit  := Space(TamSX3("B1_COD")[1])
		cNome := Space(40)
		oGetTM1:aCols := {}         
		oGetTM1:Refresh()
		_oTotVl:Refresh()
		_oKit:Refresh()
		_oNome:Refresh()
	Endif
endif

return _lRet



static function verQtde(nQtde)
_lRet := .T.

//if nQtde > _nMaxQtde
//			alert ("Pela quantidade em estoque dos ítens do Kit, você conseguirá usar " + alltrim(str(_nMaxQtde)) + " kits")
//			_lRet := .F.
//endif

return _lRet


/*
|-----------------------------------------------------------------------------------------------|
|   Programa : atACols                 |   Abril de 2014                                        |
|-----------------------------------------------------------------------------------------------|
|   Desenvolvido por Luis Carlos dos Santos Junior - Anadi                                      |
|-----------------------------------------------------------------------------------------------|
*/

Static Function atACols(cKit, nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)

Local nQtdCpo := 0
Local nCols   := 0, _lPesqSA1 := .f.

Local nPos_Valor	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" })
Local nPos_VlrTot	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local nPos_PrcDig   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" })
Local nPos_Desc		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_DESC"    })
Local nPos_Desc2	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
Local nPos_Desc3	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
Local nPos_ValDesc	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VALDESC" })
Local nPos_Quant	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
Local nPos_PrcTab	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
Local nPos_UbLocal	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL"   })
Local nPos_QtdSol	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL" })
Local nPos_VrUnit   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT"  })
Local nPos_CodTes   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_TES"     })
Local nPos_DesPr    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP"  })
Local nPos_DesCP    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCCP" })
Local nPos_Disp     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ESTDSP" })
Local nPos_DEmp     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ESTEMP" })
Local nPos_CAce     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__CODACE" })

Local cCposExc      := "UB_REC_WT/UB_ALI_WT/"
Local cItem         := ""
Local __aColsx		:= {}, _cCodSF4 := ""
Local __zeroCols	:= 0, _lNewLine := .f.

Private _ixz		:= 0

If !Empty(aCols[1][nPos_Codigo])
	_ixz := len(aCols)
Else
	_ixz := 1
Endif		

_nAtual 	:= Len( aCols )
nQtdCpo 	:= Len(aHeader)

if len(aCols) == 1 .And. !aCols[1][Len(aHeader) + 1]
	cItem 	:= aCols[_nAtual][nPos_Item]
    _nKit   := Len(oGetTM1:aCols)
    __zeroCols := 0
else
	_nAtual := Len( aCols )
	cItem 	:= aCols[_nAtual][nPos_Item]
    _nKit   := Len(oGetTM1:aCols) + 1
    __zeroCols := 1
endif

dbSelectArea("SUG")

cNome	:= posicione("SB1",1,xFilial("SB1")+SUG->UG_PRODUTO,"B1_DESC")

//cKit 	:= SUG->UG_CODACE

//--------------------------------------//
// Pega o conteudo o ultimo item (Valor)//
//--------------------------------------//
/*
If len(Acols) > 0
	_nKit	:= Len(oGetTM1:aCols) + 1
	__zeroCols := 1
Else
	_nKit	:= Len(oGetTM1:aCols)
	__zeroCols := 0
Endif
*/
_aKit	:= aClone(oGetTM1:aCols)
_nValor := ""			    // Get atual do campo

For ix := 1 to Len(_aKit) //_nKit
	_lNewLine := .f.
	_cCodSF4 := ""
	if len(Acols) == 0 .and. !lErroKit
		AAdd(aCols, Array(nQtdCpo+1))
		_lNewLine := .t. 
		_nAtual := 1
	elseif !empty(Acols[_nAtual][nPos_Codigo]) .and. !lErroKit
		cItem := Soma1(cItem,Len(cItem))
		AAdd(aCols, Array(nQtdCpo+1))
		_nAtual ++
		_lNewLine := .t.
	ElseIf Len( aCols ) > 1 .and. empty(Acols[_nAtual][nPos_Codigo]) .and. !lErroKit
		/*
		nSize := Len( aCols ) - 1
		aDel( aCols, Len( aCols ) )
		aSize( aCols, nSize )
		
		n := Len( aCols )
		_nAtual := n
		
		M->UB_PRODUTO := Acols[_nAtual][nPos_Codigo]
		Tk273Calcula("UB_PRODUTO")
		MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO )
		
		oGetTlv:oBrowse:NAT := _nAtual
		Eval(bGDRefresh)
		Eval(bRefresh)
		*/

		 //{ | NSKIP, NOLD | NOLD := SELF:OBROWSE:NAT, SELF:OBROWSE:NAT += NSKIP, SELF:OBROWSE:NAT := MIN( MAX( SELF:OBROWSE:NAT, 1 ), EVAL( SELF:OBROWSE:BLOGICLEN ) ), N := SELF:OBROWSE:NAT,SELF:OBROWSE:NAT-NOLD}
		
		 oGetTlv:GoBottom()
		
		_nAtual := Len( aCols )
		
		cItem := aCols[_nAtual][nPos_Item]
		cItem := Soma1(cItem,Len(cItem))
		AAdd(aCols, Array(nQtdCpo+1))
		_nAtual ++
		_lNewLine := .t.		

	elseif empty(Acols[_nAtual][nPos_Codigo]) .and. !lErroKit
		_nAtual := n
	Endif
//	n := len(acols)
    n := _nAtual
    
    If _lNewLine .and. !lErroKit
    	dbSelectArea("SX3")
    	dbSetOrder(2)
    	For nz := 1 to len(aHeader)
    		If dbSeek(alltrim(aHeader[nz,2]))
                aCols[_nAtual,nz] := Criavar(SX3->X3_CAMPO,.T.)
    	    Else
               If aHeader[nz][8]       == "C"
                  aCols[_nAtual][nz]    := SPACE(aHeader[nz][4])
    
               ElseIf aHeader[nz][8]   == "D" 
                  aCols[_nAtual][nz]    := dDataBase
    
               ElseIf aHeader[nz][8]   == "M"
                  aCols[_nAtual][nz]    := ""
    
               ElseIf aHeader[nz][8]   == "N"
                   aCols[_nAtual][nz]   := 0
    
               Else
                  aCols[_nAtual][nz]    := .F.    
               Endif
    	    EndIf
    	Next x
    	aCols[_nAtual][Len( aHeader )+1] := .F.
	EndIf
	//----------------------------------------------------------------------------------------------------//
	// Atualiza o aCols com o acessorio, atualizado o item o produto e a quantidade alem da funcao fiscal //
	//----------------------------------------------------------------------------------------------------//
	If ( (__zeroCols == 0 .And. ix <= _nKit) .Or. ix <= _nKit ) .and. !lErroKit
	
	    n := _nAtual
		aCols[_nAtual][nPos_Item] 	 := cItem
		aCols[_nAtual][nPos_Codigo]  := _aKit[ix][1]
        aCols[_nAtual][nPos_QtdeKit] := iif(nQtde < _nMaxQtde, nQtde, _nMaxQtde)
        aCols[_nAtual][nPos_Qtde]    := _aKit[ix][3] * aCols[_nAtual][nPos_QtdeKit]
        aCols[_nAtual][nPos_CodKit]  := cKit

		If nPos_Valor > 0 .And. (FunName() == "TMKA271" .Or. AtIsRotina("U_ITMKCAL"))
		
            If !_lPesqSA1 
                DbSelectArea("SA1")
                DbSetOrder(1)
                DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)
                _lPesqSA1 := .t.
            EndIf

            M->UB_ITEM      := cItem
            M->UB_PRODUTO   := _aKit[ix][1]

            TK273Calcula("UB_PRODUTO")
                                                       
            If ExistTrigger("UB_PRODUTO")  
                RunTrigger(2,Len(aCols),,"UB_PRODUTO")
            EndIf  
    
            oGetTlv:oBrowse:NAT := _nAtual
            Eval(bGDRefresh)
            Eval(bRefresh)

            if nPos_Desc2 > 0
                Acols[_nAtual][nPos_Desc2]:= nDesc2
            endif
            if nPos_Desc3 > 0
                Acols[_nAtual][nPos_Desc3]:= nDesc3
            endif
		                   
			aCols[_nAtual][nPos_PrcTab]     := U_ITMKC05(Acols[_nAtual][nPos_Codigo],SA1->A1_EST,M->UA__TABPRC,M->UA_TIPOCLI,M->UA__UFTAB,.f.)
			aCols[_nAtual][nPos_Valor]  	:= Round((aCols[_nAtual][nPos_PrcTab] - (aCols[_nAtual][nPos_PrcTab]  * (aCols[_nAtual][nPos_Desc2]/100))),2)            
			//aCols[_nAtual][nPos_Valor]      := aCols[_nAtual][nPos_PrcTab]
			aCols[_nAtual][nPos_Quant]		:= aCols[_nAtual][nPos_Qtde]
            aCols[_nAtual][nPos_CodTes]     := U_IFISA04(M->UA__FILIAL,aCols[_nAtual][nPos_Codigo],M->UA_CLIENTE,M->UA_LOJA,M->UA_TIPOCLI,"C")
                                               U_IFISA04B(aCols[_nAtual][nPos_Codigo],aCols[_nAtual][nPos_CodTes],"SUB")
            M->UB_TES                       := aCols[_nAtual][nPos_CodTes]
			M->UB__QTDSOL 				    := aCols[_nAtual][nPos_Quant]
			M->UB_QUANT                     := aCols[_nAtual][nPos_Quant]
			aCols[_nAtual][nPos_QtdSol]   	:= aCols[_nAtual][nPos_Quant]
			aCols[_nAtual][nPos_CAce]		:= SUG->UG_CODACE

           	n := _nAtual
            MaColsToFis(aHeader,    aCols,  _nAtual, "TK273",    .F. )

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Atualiza a variavel n novamente, pois a funcao Tk273Calcula³
            //³executa um refresh no getDados.                            ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            n := _nAtual
            
            MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO )
            
            oGetTlv:oBrowse:NAT := _nAtual
            Eval(bGDRefresh)
            Eval(bRefresh)

		Endif
		
	Endif
Next ix

_cTab := ""

//Atualiza o preço de todos os itens

___Alias := Alias()
__nAcols := Len(aCols)

/*
If __zeroCols == 0 
	__nAcols := Len(aCols)
Else                      
	__nAcols := Len(aCols) - 1
Endif
*/
If (FunName() == "TMKA271" .Or. AtIsRotina("U_ITMKCAL"))
    For _ix := _ixz To __nAcols
    
            _nAtual := _ix
    
            If !(Alltrim(aCols[_nAtual][nPos_CodKit]) == Alltrim(cKit)) .Or. aCols[_nAtual][Len(aHeader) + 1]
                Loop
            EndIf
    
    		dbSelectArea(___Alias)
        	//n := _ix  		
        	//MaColsToFis(aHeader, aCols, _nAtual, "TK273", .F. )
    		
    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    		//³Atualiza a variavel n novamente, pois a funcao Tk273Calcula³
    		//³executa um refresh no getDados.                            ³
    		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    		n := _ix
    		If M->UA__RESEST == "S"
				U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,Acols[_nAtual][nPos_Item],Acols[_nAtual][nPos_Codigo],Acols[_nAtual][nPos_UbLocal],Acols[_nAtual][nPos_Quant],"I")
            EndIf
            aCols[_nAtual][nPos_Disp]   := U_xSldProd(M->UA__FILIAL,Acols[_nAtual][nPos_Codigo], Acols[_nAtual][nPos_UbLocal])   
            aCols[_nAtual][nPos_DEmp]   := U_IESTA16(M->UA__FILIAL,Acols[_nAtual][nPos_Codigo],Acols[_nAtual][nPos_UbLocal])
            
            n := _ix        
            U_ITMKC05P("")
            n := _ix
            U_ITMKC07I("")	 

            Eval(bGDRefresh)
            Eval(bRefresh)
            n := _ix        
            MaColsToFis(aHeader, aCols, _ix, "TK273", .F.)
            M->UB_PRODUTO := Acols[_nAtual][nPos_Codigo]
            n := _ix            
            MafisRef("IT_PRODUTO",  "TK273",M->UB_PRODUTO)

            ITMKA06GON(_ix)
    Next _ix

    oGetTlv:oBrowse:NAT := n
    Eval(bGDRefresh)
    Eval(bRefresh)

EndIf

n := Len(aCols)

/*
For _ixZ := 1 To __nAcols

	If !aCols[_ixZ][Len(aHeader) + 1] .And. !Empty(aCols[_ixZ][nPos_Codigo])
		n := _ixZ
		_lPrcDig := (aCols[_ixZ][nPos_PrcTab] != aCols[_ixZ][nPos_Valor])
		aCols[_ixZ][nPos_PrcTab] := U_ITMKC05(aCols[_ixZ][nPos_Codigo],SA1->A1_EST,M->UA__TABPRC,M->UA_TIPOCLI,_cTab,.f.)
		aCols[_ixZ][nPos_PrcTab] := U_ITMKA16(.f.) //verifica desconto por UF
		//Mantém o preço digitado e recalcula o desconto 1
		If _lPrcDig
			aCols[_ixZ][nPos_Desc2] := Round((1-(aCols[_ixZ][nPos_Valor]/aCols[_ixZ][nPos_PrcTab])) * 100,2)
			//IIF(aCols[_ixZ][nPos_Desc2] < 0, 0,aCols[_ixZ][nPos_Desc2])
		Else //Mantém o percentual de desconto e calcula o preço digitado
			aCols[_ixZ][nPos_Valor] := Round((aCols[_ixZ][nPos_PrcTab] - (aCols[_ixZ][nPos_PrcTab]  * (aCols[_ixZ][nPos_Desc2]/100))),2)
		EndIf
		n := _ixZ
		U_ITMKC05P("")
		U_ITMKC07I("")
	EndIf

Next _ixZ                                                   

n := Len(aCols)
oGetTlv:oBrowse:NAT := n
Eval(bGDRefresh)
Eval(bRefresh)
*/
return
/*
|-----------------------------------------------------------------------------------------------|
|   Programa : atACols                 |   Abril de 2014                                        |
|-----------------------------------------------------------------------------------------------|
|   Desenvolvido por Luis Carlos dos Santos Junior - Anadi                                      |
|-----------------------------------------------------------------------------------------------|
*/

Static Function alteraACols(cKit, nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)

Local nQtdCpo := 0, _cCodAce := ""
Local nCols   := 0

Local nPos_Qtde     := nPos_Qtde
Local nQtdeKit  	:= 0
Local nPos_CodKit   := nPos_CodKit
Local nPos_Codigo   := nPos_Codigo

Local nPos_VlrTot   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local nPos_PrcDig   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" })
Local nPos_Desc2    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
Local nPos_Desc3    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
Local nPos_Quant    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
Local nPos_PrcTab   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
Local nPos_QtdSol   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL" })
Local nPos_VrUnit   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT"  })
Local nPos_CodTes   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_TES"     })
Local nPos_UbLocal  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL"   })
Local nPos_Disp     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ESTDSP" })
Local nPos_DEmp     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ESTEMP" })

For x := 1 to len(Acols)
	if Alltrim(Acols[x][nPos_CodKit]) == Alltrim(cKit) .And. !aCols[x][Len(aHeader) + 1]

        dbSelectArea("SUG")
        dbSetOrder(2)
        dbSeek(xFilial("SUG")+cKit) 
        _cCodAce := SUG->UG_CODACE
		
		_cQuery := "SELECT * "
		_cQuery += "FROM " + retSqlName("SU1") + " SU1 "
		_cQuery += "WHERE U1_CODACE  = '" + _cCodAce + "' "
		_cQuery += "  AND U1_ACESSOR = '" + aCols[x][nPos_Codigo] + "' "
		_cQuery += "  AND D_E_L_E_T_ = ' ' "
		
		TcQuery _cQuery New Alias "TRB_SU1"
	   
		If !(TRB_SU1->(Eof()))
    		Acols[x][nPos_QtdeKit] := nQtde
    		Acols[x][nPos_Qtde]   := TRB_SU1->U1_QTD * nQtde
            
            If FunName() == "TMKA271" // campos alimentados apenas quando a chamada for do call center            
                Acols[x][nPos_Desc2]   := nDesc2
                Acols[x][nPos_Desc3]   := nDesc3
                Acols[x][nPos_QtdSol]  := TRB_SU1->U1_QTD * nQtde
                Acols[x][nPos_Quant]   := TRB_SU1->U1_QTD * nQtde
                aCols[x][nPos_PrcDig]  := Round((aCols[x][nPos_PrcTab] - (aCols[x][nPos_PrcTab]  * (aCols[x][nPos_Desc2]/100))),2)            
            
                If M->UA__RESEST == "S"
                    U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,Acols[x][nPos_Item],Acols[x][nPos_Codigo],Acols[x][nPos_UbLocal],Acols[x][nPos_Quant],"I")
                EndIf
                aCols[x][nPos_Disp]   := U_xSldProd(M->UA__FILIAL,Acols[x][nPos_Codigo],Acols[x][nPos_UbLocal])   
                aCols[x][nPos_DEmp]   := U_IESTA16(M->UA__FILIAL,Acols[x][nPos_Codigo],Acols[x][nPos_UbLocal])

                //Tk273Calcula("UB_PRODUTO", x)
        		n := x
                U_ITMKC05P("")
                n := x
                U_ITMKC07I("")
                n := x
                M->UB_PRODUTO := aCols[x][nPos_Codigo]
          		MaColsToFis(aHeader,    aCols,  x, "TK273",    .F. )
          	    //n := x
                //M->UB_PRODUTO := aCols[x][nPos_Codigo]
                //Tk273Calcula("UB_PRODUTO", x)
        		/*
        		n := x
                U_ITMKC05P("")
                n := x
                U_ITMKC07I("")
                n := x
          		MaColsToFis(aHeader,    aCols,  x, "TK273",    .F. )
                */

    	   		ITMKA06GON(x)
            EndIf
        EndIf
		
		TRB_SU1->(dbCloseArea())
	endif
next x

If FunName() == "TMKA271"
    Eval(bGDRefresh)
    Eval(bRefresh)
EndIf

return


//Atualiza a gravação online
Static Function ITMKA06GON(_nx)

//Atualiza a gravação online
U_ITMKGRON("SUB","",_nx)

Return