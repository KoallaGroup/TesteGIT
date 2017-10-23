#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATA21			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Aprovação Comercial															  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IFATA21()

	private aButtons   	:= {}
	private _cFilial 	:= SM0->M0_CODFIL
	private _cOrigem 	:= "TMK"          
    private _cRepres	:= space(TamSX3("A3_COD")[1])          
    private _cNRepres	:= space(TamSX3("A3_NOME")[1])          
    private _dData1		:= dDataBase-365
    private _dData2		:= dDatabase
    private _nDesc		:= criavar("UA__DESCAP")
	private oGetTM1    	:= Nil
    private _nNumPed	:= 0
    private _nTotPed	:= criavar("UB_VLRITEM")

	private aTela[0][0],aGets[0],aHeader[0]

	oFont := tFont():New("Tahoma",,-12,,.F.)

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3,3}
	aPosObj := MsObjSize(aInfo, aObjects)	

	DEFINE MSDIALOG oDlg TITLE "Aprovação Comercial" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
                                           
	@ 10,010 Say "Filial :"		   		FONT oFont SIZE 100,10 OF oDlg PIXEL
	@ 10,200 Say "Origem :" 			FONT oFont SIZE 100,10 OF oDlg PIXEL
	@ 10,350 Say "Representante :"	 	FONT oFont SIZE 100,10 OF oDlg PIXEL
	@ 10,440 Say "-"	 				FONT oFont SIZE 100,10 OF oDlg PIXEL
	@ 25,010 Say "A partir da Data :" 	FONT oFont SIZE 100,10 OF oDlg PIXEL
	@ 25,200 Say "Até a Data :" 		FONT oFont SIZE 100,10 OF oDlg PIXEL
	@ 25,350 Say "Desconto Capa :"		FONT oFont SIZE 100,10 OF oDlg PIXEL

    @ 10,070 MsGet _cFilial 	Picture "@!" 	Size 007,10 of oDlg PIXEL FONT oFont F3 "SM0"	VALID(iif (empty(_cFilial), .T., existCpo("SM0",cEmpAnt+_cFilial))) 
    @ 10,250 MsGet _cOrigem 	Picture "@!" 	Size 007,10 of oDlg PIXEL FONT oFont when .F.
    @ 10,400 MsGet _cRepres 	Picture "@!" 	Size 030,10 of oDlg PIXEL FONT oFont F3 "SA3"	VALID(buscaRep())
    @ 10,445 MsGet _cNRepres	Picture "@!" 	Size 100,10 of oDlg PIXEL FONT oFont when .F.
    @ 25,070 MsGet _dData1		Picture "@!" 	Size 060,10 of oDlg PIXEL FONT oFont 			
    @ 25,250 MsGet _dData2	 	Picture "@!" 	Size 060,10 of oDlg PIXEL FONT oFont 
    @ 25,400 MsGet _nDesc	 	Picture "99.99" 	Size 040,10 of oDlg PIXEL FONT oFont 

 	@ 45,245 BUTTON "Processar"	SIZE 80,10 Of oDlg PIXEL FONT oFont ACTION Processa({|| buscaRegs() },"Aguarde! Processando...",,.T.)

	@ aPosObj[1,3]+3,aPosObj[1,2] Say "Total :"		FONT oFont 	SIZE 100,10 OF oDlg PIXEL
    @ aPosObj[1,3]+3,aPosObj[1,2]+40 MsGet _nNumPed	Picture "9999999" 	Size 040,8 of oDlg PIXEL FONT oFont 
	@ aPosObj[1,3]+3,aPosObj[1,2]+90 Say "-"			FONT oFont 	SIZE 100,10 OF oDlg PIXEL
    @ aPosObj[1,3]+3,aPosObj[1,2]+100 MsGet _nTotPed	Picture "@E 99,999,999,999.99"	Size 0100,8 of oDlg PIXEL FONT oFont 

	criaHeader() 

    oGetTM1 := MsNewGetDados():New(060, aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)

	configKey()
	    
 	@ aPosObj[1,3]+3,aPosObj[1,4]-170 BUTTON "F5 - Pedido"			SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION acionaFuncao(5)
 	@ aPosObj[1,3]+3,aPosObj[1,4]-080 BUTTON "Fechar"				SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION oDlg:End()
// 	@ aPosObj[1,3]+3,aPosObj[1,4]-270 BUTTON "F2 - Criticas Ped."	SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION acionaFuncao(1)
// 	@ aPosObj[1,3]+3,aPosObj[1,4]-200 BUTTON "F3 - Comissões"		SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION acionaFuncao(2)
// 	@ aPosObj[1,3]+3,aPosObj[1,4]-130 BUTTON "F4 - Indica Sit."		SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION acionaFuncao(3)

	ACTIVATE MSDIALOG oDlg CENTERED 

return                 


static function	configKey()

//	SetKey( VK_F2 , { || acionaFuncao(1) } )
//	SetKey( VK_F3 , { || acionaFuncao(2) } )
//	SetKey( VK_F4 , { || acionaFuncao(3) } )
	SetKey( VK_F5 , { || acionaFuncao(5) } )

return


static function acionaFuncao(_nFunc)
	local _aAreaATU	:= getArea()

	If(Len(oGetTM1:aCols) < 1)
		Alert("Nenhum pedido selecionado")
		Return
	EndIf

	recPosicao()
    cFilAnt := _cFilial
	dbSelectArea("SUA")
	go oGetTM1:acols[oGetTM1:NAT][nPos_UA_REC_WT]

	if _nFunc == 1
    	U_ITMKA24(SUA->UA__FILIAL,SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,"C")
 	elseif _nFunc == 2                              
    	U_ITMKA21(SUA->UA_NUM)
 	elseif _nFunc == 3
    	U_IFATA13(SUA->UA__FILIAL,SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,"C")
 	elseif _nFunc == 4
 		Inclui := .F.
 		Altera := .F.
 		aRotina:= {{"","",0,1},;
	  			   {"","",0,2}}
		TK271CallCenter("SUA",0,2)
	elseif _nFunc == 5                            
		SetKey( VK_F5 , { || } )
        U_ITMKA35(oGetTM1:aCols[oGetTM1:nAt][nPos_UB_NUM],"C")
	endif

	Processa({|| buscaRegs() },"Aguarde! Processando...",,.T.)
    cFilAnt := SM0->M0_CODFIL
	configKey()
	restArea(_aAreaATU)
return

      

static function criaHeader()     
	static aHeader	:= {}
	static aCols	:= {}
	static aEdit	:= {}
	
	aCpoHeader   := {"A1_NOME", /*"A1_NREDUZ",*/ "UB_PRCTAB", "UB_NUM", "UB_DTENTRE", "E4__PRAZOM", "E4_DESCRI", "UA_VEND", "UA__DESCAP"}

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

	AADD( aHeader, { "Recno WT", "UA_REC_WT", "", 09, 0,,, "N", "SUA", "V"} )

	nPos_A1_NOME  	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_NOME" }) 
	nPos_E4_DESCRI	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "E4_DESCRI" })
	nPos_UB_PRCTAB 	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB" }) 
	nPos_UB_NUM 	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_NUM" }) 
	nPos_UB_DTENTRE	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_DTENTRE" }) 
	nPos_UA_VEND	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "UA_VEND" }) 
//	nPos_A1_NREDUZ 	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "A1_NREDUZ" }) 
	nPos_UA__DESCAP	:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "UA__DESCAP" })
	nPos_UA_REC_WT	:= 	ASCAN(aHeader, { |x| AllTrim(x[2]) == "UA_REC_WT" })

	aHeader[nPos_A1_NOME][1]	:= "Cliente"
	aHeader[nPos_A1_NOME][4]	:= 60

	aHeader[nPos_UB_PRCTAB][1]	:= "Valor Itens"
	aHeader[nPos_UB_PRCTAB][3]	:= "@E 9,999,999.99"
	aHeader[nPos_UB_PRCTAB][5]	:= 2

	aHeader[nPos_UB_NUM][1]		:= "Pedido"
//	aHeader[nPos_UB_NUM][4]		:= 8

	aHeader[nPos_UB_DTENTRE][1]	:= "Previs. Fat."
//	aHeader[nPos_UB_DTENTRE][4]	:= 15

	aHeader[nPos_E4_DESCRI][1]	:= "Plano de Pagamento"
	aHeader[nPos_E4_DESCRI][4]	:= 30

	aHeader[nPos_UB_DTENTRE][1]	:= "Prev. Fat."

	aHeader[nPos_UA_VEND][1]	:= "Repres."
//	aHeader[nPos_UA_VEND][4]	:= 28

//	aHeader[nPos_A1_NREDUZ][1]	:= "Nome Fantasia"
//	aHeader[nPos_A1_NREDUZ][4]	:= 28

	aHeader[nPos_UA__DESCAP][1]	:= "Desc. Capa"
//	aHeader[nPos_UA__DESCAP][4]	:= 8

	aHeader[nPos_UA_REC_WT][1]	:= "Recno"
//	aHeader[nPos_UA_REC_WT][4]	:= 5
                       
return


static function buscaRegs()     

	recPosicao()

	_cQuery := "SELECT 	SUM(UB_VLRITEM) UB_VLRITEM, "
//	_cQuery += "		MAX(A1_NREDUZ) A1_NREDUZ, "
	_cQuery += "		MAX(A1_NOME) A1_NOME, "
	_cQuery += "		MAX(UB_NUM) UB_NUM, "
	_cQuery += "		MAX(E4__PRAZOM) E4__PRAZOM, "
	_cQuery += "		MAX(E4_DESCRI) E4_DESCRI, "
	_cQuery += "		MAX(UA_VEND) UA_VEND, "
	_cQuery += "		MAX(A3_NREDUZ) A3_NREDUZ, "
	_cQuery += "		MAX(UA__DESCAP) UA__DESCAP, "
	_cQuery += "		MAX(SUA.R_E_C_N_O_) UA_RECNO, "
	_cQuery += "		MAX(UA__PRVFAT) UA__PRVFAT "
	_cQuery += "FROM " + retSqlName("SUA") + " SUA "
	_cQuery	+= "INNER JOIN " + retSqlName("SA1") + " SA1 ON A1_COD = UA_CLIENTE And A1_LOJA = UA_LOJA "
	_cQuery += "										AND SA1.D_E_L_E_T_ = ' ' "
	_cQuery	+= "INNER JOIN " + retSqlName("SE4") + " SE4 ON E4_CODIGO = UA_CONDPG "
	_cQuery += "										AND SE4.D_E_L_E_T_ = ' ' "
	_cQuery	+= "INNER JOIN " + retSqlName("SA3") + " SA3 ON A3_COD = UA_VEND "
	_cQuery += "										AND SA3.D_E_L_E_T_ = ' ' "
	_cQuery	+= "INNER JOIN " + retSqlName("SUB") + " SUB ON UB_FILIAL = UA_FILIAL And UB_NUM = UA_NUM "
	_cQuery += "										AND SUB.D_E_L_E_T_ = ' ' "
	_cQuery += "INNER JOIN " + retSqlName("SZ1") + " SZ1 ON (Z1_SEGISP = UA__SEGISP OR UA__SEGISP = '0') "
	_cQuery += "                         AND Z1_CODUSR = '" + __cUserId + "' "
	_cQuery += "                         AND SZ1.D_E_L_E_T_ = ' ' "
	_cQuery += "WHERE UA__PRVFAT >= '" + dtos(_dData1) + "' "
	_cQuery += "  AND UA__PRVFAT <= '" + dtos(_dData2) + "' "
	_cQuery += "  AND UA_FILIAL = '" + _cFilial + "' "   
	_cQuery += "  AND UA__SITCOM = 'E' "   
	_cQuery += "  AND SUA.D_E_L_E_T_ = ' ' "
	if !empty(_cRepres)
		_cQuery += "  AND UA_VEND = '" + _cRepres + "' "   
	endif
	if _nDesc > 0
		_cQuery += "  AND UA__DESCAP = " + str(_nDesc) + " "
	endif
	_cQuery += "GROUP BY UA_NUM "   
	_cQuery += "ORDER BY UA_NUM "   
               
	TcQuery _cQuery New Alias "TRB_SUA"
	TcSetField("TRB_SUA", "UA__PRVFAT"  , "D", 08, 0)

	nn := len(oGetTM1:aCols)
	nQtdCpo := Len(oGetTM1:aHeader)

    oGetTM1:acols := {}

    _nNumPed	:= 0
    _nTotPed	:= 0

	do while ! TRB_SUA->(eof())
		if len(oGetTM1:aCols) == 1 .and. empty(oGetTM1:acols[oGetTM1:NAT][nPos_A1_NOME])
			nn := oGetTM1:NAT
		else
			nn := len(oGetTM1:aCols) + 1
			oGetTM1:NAT := nn
		   	aadd(oGetTM1:aCols, Array(nQtdCpo+1))
		endif

	    oGetTM1:acols[nn][nPos_A1_NOME]		:= TRB_SUA->A1_NOME
		oGetTM1:acols[nn][nPos_UB_PRCTAB]	:= TRB_SUA->UB_VLRITEM
	    oGetTM1:acols[nn][nPos_UB_NUM]		:= TRB_SUA->UB_NUM
	    oGetTM1:acols[nn][nPos_UB_DTENTRE]	:= dtoc(TRB_SUA->UA__PRVFAT)
	    oGetTM1:acols[nn][nPos_E4__PRAZOM]	:= TRB_SUA->E4__PRAZOM
		oGetTM1:acols[nn][nPos_E4_DESCRI]	:= TRB_SUA->E4_DESCRI
		oGetTM1:acols[nn][nPos_UA_VEND]		:= TRB_SUA->UA_VEND + " - " + TRB_SUA->A3_NREDUZ
//	    oGetTM1:acols[nn][nPos_A1_NREDUZ]	:= TRB_SUA->A1_NREDUZ
	    oGetTM1:acols[nn][nPos_UA__DESCAP]	:= TRB_SUA->UA__DESCAP
	    oGetTM1:acols[nn][nPos_UA_REC_WT]	:= TRB_SUA->UA_RECNO

	    oGetTM1:acols[nn][Len(aHeader)+1] 	:= .F.

	    _nNumPed ++
	    _nTotPed += TRB_SUA->UB_VLRITEM
	
		TRB_SUA->(dbSkip())
	enddo
	
	oGetTM1:NAT := nn

	oGetTM1:refresh()

	TRB_SUA->(dbCloseArea())
	
return



static function buscaRep()
	dbSelectArea("SA3")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SA3")+_cRepres) .and. !empty(_cRepres)
		msgAlert ("Representante não encontrado !!")
		return .F.	
	else
		_cNRepres := SA3->A3_NOME
	endif
return .T.



static function recPosicao() 
	static nPos_A1_NOME		:= 0
	static nPos_UB_PRCTAB	:= 0
	static nPos_UB_NUM		:= 0
	static nPos_UB_DTENTRE	:= 0
    static nPos_E4__PRAZOM	:= 0
	static nPos_E4_DESCRI	:= 0
	static nPos_UA_VEND		:= 0
//	static nPos_A1_NREDUZ	:= 0
	static nPos_UA__DESCAP	:= 0
	static nPos_UA_REC_WT	:= 0
	
	nPos_A1_NOME  	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A1_NOME" }) 
    nPos_UB_PRCTAB	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB" })
    nPos_UB_NUM		:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UB_NUM" })
    nPos_UB_DTENTRE	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UB_DTENTRE" })
    nPos_E4__PRAZOM	:= 	ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "E4__PRAZOM" })
	nPos_E4_DESCRI	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "E4_DESCRI" })
	nPos_UA_VEND	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UA_VEND" })
//	nPos_A1_NREDUZ 	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A1_NREDUZ" }) 
	nPos_UA__DESCAP	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UA__DESCAP" })
	nPos_UA_REC_WT	:= 	ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UA_REC_WT" })

return


