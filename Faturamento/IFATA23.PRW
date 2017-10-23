#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATA23			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Log de Aprovação															  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IFATA23(_cFilial, _cNum, _cTipo)

	local _aArea		:= getArea()
	
	private aButtons   	:= {}
    private _dEmissao	:= criavar("UA_EMISSAO")
    private _cCliente	:= criavar("UA_CLIENTE")
    private _cNomeCli	:= criavar("A1_NOME")
    private _cEndCli	:= criavar("UA_ENDCOB")  
    private _cTipoPed	:= criavar("UA__TIPPED")

	private aTela[0][0],aGets[0],aHeader[0]

	oFont := tFont():New("Tahoma",,-12,,.F.)

	dbSelectArea("SUA")
	dbSetOrder(12)
	dbSeek(xFilial("SUA")+_cFilial+_cNum)
	
	_dEmissao	:= SUA->UA_EMISSAO 
	_cCliente	:= SUA->UA_CLIENTE
    _cNomeCli	:= posicione("SA1",1,xFilial("SA1")+_cCliente, "A1_NOME")
	_cEndCli	:= SUA->UA_ENDCOB	
	_cTipoPed	:= x3Combo("UA__TIPPED", SUA->UA__TIPPED)
	
	DEFINE MSDIALOG oDlgFAT22 TITLE "Histórico de Aprovação Comercial" From 0,0 To 400,700 OF oMainWnd PIXEL
                                           
	@ 10,010 Say "Pedido :"		   	FONT oFont SIZE 100,10 OF oDlgFAT22 PIXEL
	@ 10,100 Say "Data :"	 		FONT oFont SIZE 100,10 OF oDlgFAT22 PIXEL
	@ 10,200 Say "Tipo de Pedido :"	FONT oFont SIZE 100,10 OF oDlgFAT22 PIXEL
	@ 28,010 Say "Cliente :" 		FONT oFont SIZE 100,10 OF oDlgFAT22 PIXEL
	@ 46,010 Say "End. Faturamento :" FONT oFont SIZE 100,10 OF oDlgFAT22 PIXEL

    @ 08,040 MsGet _cNum 		Size 007,10 of oDlgFAT22 PIXEL FONT oFont when .F.
    @ 08,120 MsGet _dEmissao 	Size 050,10 of oDlgFAT22 PIXEL FONT oFont when .F.
    @ 08,250 MsGet _cTipoPed 	Size 100,10 of oDlgFAT22 PIXEL FONT oFont when .F.

    @ 26,040 MsGet _cCliente 	Size 050,10 of oDlgFAT22 PIXEL FONT oFont when .F.
    @ 26,100 MsGet _cNomeCli 	Size 150,10 of oDlgFAT22 PIXEL FONT oFont when .F.

    @ 43,068 MsGet _cEndCli 	Size 150,10 of oDlgFAT22 PIXEL FONT oFont when .F.

	aHeader 	:= criaHeader()                
	aCols		:= criaAcols(_cFilial, _cNum, _cTipo)     	
	aEdit	:= {}
	
    MsNewGetDados():New(060,0,180,352, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgFAT22, aHeader, aCols)

 	@ 185,280 BUTTON "Fechar"	SIZE 60,10 Of oDlgFAT22 PIXEL FONT oFont ACTION oDlgFAT22:End()
       
	ACTIVATE MSDIALOG oDlgFAT22 CENTERED 

	restArea(_aArea)

return                 


static function criaHeader()     
	aHeader	:= {}
	
	aCpoHeader   := {"Z22_DATA", "Z22_HORA", "Z22_NOME"}

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
							SX3->X3_F3    	 	,;
							SX3->X3_Context		,;
							SX3->X3_Cbox		,;
							SX3->X3_RELACAO		,;
							SX3->X3_WHEN		,;
							SX3->X3_VISUAL})

		Endif
	Next _nElemHead	

return aHeader


static function criaAcols(_cFilial, _cNum, _cTipo)     
	aCols := {}

	nPos_Z22_DATA  	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z22_DATA" }) 
    nPos_Z22_HORA	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z22_HORA" })
    nPos_Z22_NOME	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z22_NOME" })
	
	_cQuery := "SELECT 	* "
	_cQuery += "FROM " + retSqlName("Z22") + " Z22 "
	_cQuery += "WHERE Z22_NUM = '" + _cNum + "' "
	_cQuery += "  AND Z22_FILIAL = '" + _cFilial + "' "   
	_cQuery += "  AND Z22_TIPOAP = '" + _cTipo + "' "   
	_cQuery += "  AND Z22.D_E_L_E_T_ <> '*' "
	_cQuery += "ORDER BY Z22_DATA, Z22_HORA "   
               
	TcQuery _cQuery New Alias "TRB_Z22"
	TcSetField("TRB_Z22", "Z22_DATA"  , "D", 08, 0)

	nn := len(aCols)
	nQtdCpo := Len(aHeader)

	do while ! TRB_Z22->(eof())
		if len(aCols) == 1 .and. empty(acols[NAT][nPos_Z22_NOME])
			nn := NAT
		else
			nn := len(aCols) + 1
			NAT := nn
		   	aadd(aCols, Array(nQtdCpo+1))
		endif


		acols[nn][nPos_Z22_DATA]  	:=  dtoc(TRB_Z22->Z22_DATA)
	    acols[nn][nPos_Z22_HORA]	:=  TRB_Z22->Z22_HORA
	    acols[nn][nPos_Z22_NOME]	:=  TRB_Z22->Z22_NOME  
	
	    acols[nn][Len(aHeader)+1] 	:= .F.

		TRB_Z22->(dbSkip())
	
		NAT := nn
	enddo
	
	TRB_Z22->(dbCloseArea())
	
return aCols





