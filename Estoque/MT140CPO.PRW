#include "protheus.ch"
#include "topconn.ch"


user function MT140CPO()

	SetKey( VK_F12 , { || setKeyF12() } )

return .T.

//Importação da NF de transferencia - Luis Carlos - Anadi
static function setKeyF12()
                           
	if Inclui	     

		_nRet 	:= .F.
		_cFilial:= criavar("D1_FILIAL")
		_cNF 	:= criavar("D1_DOC")
		_cSerie := criavar("D1_SERIE")
	
		oFont 	:= tFont():New("Tahoma",,-14,,.t.)
		
		DEFINE MSDIALOG oDlgTMP TITLE "Selecione a NF" FROM 0, 0 TO 150,300 PIXEL  
		oDlgTMP:lMaximized := .F.       
	
	    @ 05,005 Say "Filial :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont 
	    @ 05,040 MsGet _cFilial Picture "99" F3 "SM0" Size 40,10 of oDlgTMP PIXEL FONT oFont 

	    @ 20,005 Say "NF :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont 
	    @ 20,040 MsGet _cNF Size 40,10 of oDlgTMP PIXEL FONT oFont 

	    @ 35,005 Say "Série :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont 
	    @ 35,040 MsGet _cSerie Picture "@!" Size 40,10 of oDlgTMP PIXEL FONT oFont 

		@ 60,030 BUTTON oButton14 PROMPT "Incluir" 	SIZE 037, 012 OF oDlgTMP ACTION {|| _nRet := valNota()} PIXEL	
		@ 60,080 BUTTON oButton14 PROMPT "Fechar" 	SIZE 037, 012 OF oDlgTMP ACTION {|| _nRet := .F.,oDlgTMP:End()} PIXEL	
	
		ACTIVATE MSDIALOG oDlgTMP CENTERED 

		if _nRet 
			cSerie := _cSerie
			buscaReg(SF2->(recno()))
		endif
	
	endif

return 
      

static function valNota()
	_lret := .T.

	dbSelectArea("SF2")
	dbSetOrder(1)
	if ! dbSeek(_cFilial+_cNF+_cSerie)
	    msgAlert ("Nota Fiscal de Transferência não encontrada. Favor verificar !!")
		_lret := .F.
	else   
		_cCNPJ := posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA, "A1_CGC")
		                                                                                  
		if _cCNPJ <> SM0->M0_CGC
		    msgAlert ("Nota Fiscal de Transferência não encontrada. Favor verificar !!")
			_lret := .F.
		else	
			oDlgTMP:End()
		endif
	endif

return _lret


static function buscaReg(_nRecno)

    Local cCposExc      := "D1_REC_WT/D1_ALI_WT/"

	dbSelectArea("SF2")
	go _nRecno

	_cQuery := "SELECT 	D2_FILIAL, "
	_cQuery += "		D2_COD, "
	_cQuery += "		D2_ITEM, "
	_cQuery += "		D2_QUANT, "
	_cQuery += "        D2_LOCAL, "
	_cQuery += "		D2_PRCVEN, "
	_cQuery += "		D2_TOTAL, "
	_cQuery += "		D2_UM "
	_cQuery += "FROM " + retSqlName("SD2") + " SD2 "
	_cQuery += "WHERE D2_DOC = '" + SF2->F2_DOC + "' "
	_cQuery += "  AND D2_SERIE = '" + SF2->F2_SERIE + "' "
	_cQuery += "  AND D2_FILIAL = '" + SF2->F2_FILIAL + "' "
	_cQuery += "  AND D_E_L_E_T_ = ' ' "
	_cQuery += "ORDER BY D2_ITEM "
	
	TCQUERY _cQuery NEW ALIAS "TMPSD2"
	  
	nPos_D1_COD		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_COD" }) 
	nPos_D1_ITEM	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_ITEM" })
	nPos_D1_QUANT	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_QUANT" })
	nPos_D1_VUNIT	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_VUNIT" })
    nPos_D1_TOTAL	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_TOTAL" })
	nPos_D1_UM		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_UM" })
	nPos_D1_LOCAL	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_LOCAL" })
	nPos_D1_TRANSF  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1__TRANSF" }) 
	nPos_D1_DESPRO  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1__DESPRO" })

	nQtdCpo := Len(aHeader)
	nn:=0
	aCols := {}	
	_cItem := StrZero(0,TamSX3("D1_ITEM")[1]) 
	do while ! TMPSD2->(eof())   

		AAdd(aCols, Array(nQtdCpo+1))
		nn++

	    dbSelectArea("SX3")
	    dbSetOrder(2)
	    for x := 1 to len(aHeader)
			if alltrim(aHeader[x,2]) $ cCposExc
	            aCols[nn,x] := ""
	        else
	        	dbSeek(alltrim(aHeader[x,2]))
	            aCols[nn,x] := Criavar(SX3->X3_CAMPO,.T.)
	        endif
		next x
		_cItem := SomaIt(_cItem)
		Acols[nn][nPos_D1_COD] 		:= TMPSD2->D2_COD
		Acols[nn][nPos_D1_ITEM]		:= _cItem //StrZero(Val(TMPSD2->D2_ITEM),TamSX3("D1_ITEM")[1]) 
		Acols[nn][nPos_D1_LOCAL]	:= TMPSD2->D2_LOCAL //posicione("SB1", 1, xFilial("SB1")+TMPSD2->D2_COD, "B1_LOCPAD")
		Acols[nn][nPos_D1_QUANT]	:= TMPSD2->D2_QUANT
		Acols[nn][nPos_D1_VUNIT]	:= TMPSD2->D2_PRCVEN 
		Acols[nn][nPos_D1_TOTAL]	:= TMPSD2->D2_TOTAL
		Acols[nn][nPos_D1_UM]		:= TMPSD2->D2_UM
		Acols[nn][nPos_D1_DESPRO]	:= posicione("SB1", 1, xFilial("SB1")+TMPSD2->D2_COD, "B1_DESC")
		If nPos_D1_TRANSF > 0
            Acols[nn][nPos_D1_TRANSF] := "S"
		EndIf
		
		Acols[nn][Len(aHeader)+1] 	:= .F.
                           
	    M->D1_COD  	:= TMPSD2->D2_COD
	    M->D1_VUNIT	:= TMPSD2->D2_PRCVEN
	    M->D1_QUANT := TMPSD2->D2_QUANT
	
		n := len(Acols)
		if ExistTrigger("D1_COD")
			RunTrigger(2,Len(aCols),,"D1_COD")
		endif
		if ExistTrigger("D1_VUNIT")
			RunTrigger(2,Len(aCols),,"D1_VUNIT")
		endif
		
		Acols[nn][nPos_D1_LOCAL]:= TMPSD2->D2_LOCAL
		
		TMPSD2->(dbSkip())
	enddo                 
	                      
	TMPSD2->(dbCloseArea())
return