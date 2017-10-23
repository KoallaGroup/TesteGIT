#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFINA09			  		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Distribuição PA p/ Proc. Importação											  	|
|-----------------------------------------------------------------------------------------------|	
*/


user function IFINA09

	local _aArea		:= getArea()
	
	private aButtons   	:= {}
	private _cPrefixo 	:= SE2->E2_PREFIXO
	private _cNum 		:= SE2->E2_NUM
	private _cParcela	:= SE2->E2_PARCELA
	private _cTipo	 	:= SE2->E2_TIPO
	private _cFornece 	:= SE2->E2_FORNECE
	private _cloja		:= SE2->E2_LOJA          
	private _nTotal		:= SE2->E2_VALOR          
	private _nDistribui	:= 0
	private oDlg		:= nil
	private oGetTM1		:= nil
	
	oFont := tFont():New("Tahoma",,-12,,.t.)

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{400,400,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)

	DEFINE MSDIALOG oDlg TITLE "PA x PROCESSO IMPORTACAO" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
                                           
	@ 10,10  Say "Prefixo :"   	FONT oFont SIZE 80,10 OF oDlg PIXEL
	@ 10,200 Say "Número :" 	FONT oFont SIZE 80,10 OF oDlg PIXEL
	@ 10,400 Say "Parcela :" 	FONT oFont SIZE 80,10 OF oDlg PIXEL
	
	@ 25,10  Say "Tipo :" 		FONT oFont SIZE 80,10 OF oDlg PIXEL
	@ 25,200 Say "Fornecedor :" FONT oFont SIZE 80,10 OF oDlg PIXEL
	@ 25,400 Say "Loja :" 		FONT oFont SIZE 80,10 OF oDlg PIXEL

	@ 40,10  Say "Valor Total :" FONT oFont SIZE 80,10 OF oDlg PIXEL
	@ 40,200 Say "Valor Distribuido :" FONT oFont SIZE 80,10 OF oDlg PIXEL

    @ 10,50  MsGet _cPrefixo 	when .F. Size 07,10 of oDlg PIXEL FONT oFont 
    @ 10,270 MsGet _cNum 		when .F. Size 07,10 of oDlg PIXEL FONT oFont 
    @ 10,450 MsGet _cParcela 	when .F. Size 30,10 of oDlg PIXEL FONT oFont 
    
    @ 25,50  MsGet _cTipo		when .F. Size 30,10 of oDlg PIXEL FONT oFont 
    @ 25,270 MsGet _cFornece	when .F. Size 90,10 of oDlg PIXEL FONT oFont 
    @ 25,450 MsGet _cloja 		when .F. Size 90,10 of oDlg PIXEL FONT oFont 

    @ 40,50  MsGet _nTotal		when .F. Size 60,10 of oDlg PIXEL FONT oFont Picture "9,999,999.99"
    @ 40,270 MsGet _nDistribui	when .F. Size 60,10 of oDlg PIXEL FONT oFont Picture "9,999,999.99"

	lOk := .F.	

	montaAcols()	

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=validar()},{||oDlg:End()},,aButtons) }) 

	restArea(_aArea)
return          



static function montaAcols()

	private aHeader	:= {}
	private aCols	:= {}
	private aEdit	:= {"ZY_VALOR",  "ZY_PROCISA"}

	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek("ZY_VALOR")
		aadd(aHeader, {Trim(SX3->X3_Titulo),;
						SX3->X3_Campo       ,;
						SX3->X3_Picture     ,;
						SX3->X3_Tamanho     ,;
						SX3->X3_Decimal     ,;
						"u_somaDist()"      ,;
						SX3->X3_Usado       ,;
						SX3->X3_Tipo        ,;
						SX3->X3_F3    	 	,;
						SX3->X3_Context		,;
						SX3->X3_Cbox		,;
						SX3->X3_relacao		,;
						SX3->X3_when})
	Endif

	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek("ZY_PROCISA")
		aadd(aHeader, {Trim(SX3->X3_Titulo),;
						SX3->X3_Campo       ,;
						SX3->X3_Picture     ,;
						SX3->X3_Tamanho     ,;
						SX3->X3_Decimal     ,;
						"u_validaProc('P')"       ,;
						SX3->X3_Usado       ,;
						SX3->X3_Tipo        ,;
						SX3->X3_F3    	 	,;
						SX3->X3_Context		,;
						SX3->X3_Cbox		,;
						SX3->X3_relacao		})
	Endif

	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek("ZY_CODPROC")
		aadd(aHeader, {Trim(SX3->X3_Titulo),;
						SX3->X3_Campo       ,;
						SX3->X3_Picture     ,;
						SX3->X3_Tamanho     ,;
						SX3->X3_Decimal     ,;
						"u_validaProc('I')"       ,;
						SX3->X3_Usado       ,;
						SX3->X3_Tipo        ,;
						SX3->X3_F3    	 	,;
						SX3->X3_Context		,;
						SX3->X3_Cbox		,;
						SX3->X3_relacao		})
	Endif

	aadd( aHeader, {"Recno WT", "ZY_REC_WT", "", 09, 0,,, "N", "SZY", "V"} )

	_cQuery := "SELECT * FROM "	+ retSqlName("SZY") + " SZY "
	_cQuery += "WHERE ZY_FILIAL = "	+ xFilial("SZY")
	_cQuery += "  AND ZY_PREFIXO = '" + _cPrefixo + "' "
	_cQuery += "  AND ZY_NUM = '" + _cNum + "' "
	_cQuery += "  AND ZY_TIPO = '" + _cTipo + "' "
	_cQuery += "  AND ZY_PARCELA = '" + _cParcela + "' "
	_cQuery += "  AND ZY_FORNECE = '" + _cFornece + "' "
	_cQuery += "  AND ZY_LOJA = '" + _cloja + "' "
	_cQuery += "  AND D_E_L_E_T_ <> '*' "

	TcQuery _cQuery New Alias "TRB_SZY"

	do while ! TRB_SZY->(eof())
		aadd (aCols, { TRB_SZY->ZY_VALOR, TRB_SZY->ZY_PROCISA, TRB_SZY->ZY_CODPROC, TRB_SZY->R_E_C_N_O_, .F.})

		_nDistribui += TRB_SZY->ZY_VALOR

		TRB_SZY->(dbSkip())
	enddo                       
	TRB_SZY->(dbCloseArea())
         
    oGetTM1 := MsNewGetDados():New(80, 0, 270, 650, GD_INSERT + GD_UPDATE + GD_DELETE, "U_IFINA09B()", "AllwaysTrue", "", aEdit, , , , , "U_IFINA09D()" , oDlg, aHeader, aCols)

return


user function IFINA09B()
	local _nZY_VALOR	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_VALOR" })
	local _nZY_CODPROC	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_CODPROC" })
	local _nZY_PROCISA	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_PROCISA" })
	local _nZY_REC_WT	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_REC_WT" })

	_lValid := .T.
	
	dbSelectArea("SZ2")
	dbSetOrder(5)
	
	if ! dbSeek(trim(oGetTM1:aCols[n][_nZY_PROCISA]))	
		msgAlert ("Processo não encontrado. Favor verificar !!")
//		_lValid := .F.	
	endif

	if oGetTM1:aCols[n][_nZY_VALOR] == 0	
		msgAlert ("O Valor tem que ser superior a zero. Favor verificar !!")
		_lValid := .F.	
	endif

	for x:=1 to len(oGetTM1:aCols)
		if ! oGetTM1:aCols[x][len(aHeader)+1]
			if oGetTM1:aCols[n][_nZY_PROCISA] == oGetTM1:aCols[x][_nZY_PROCISA] .and. x <> n
				msgAlert ("Este processo já está na lista de distribuição. Favor verificar !!")
				_lValid := .F.	
			endif
		endif
	next x 

	if _lValid  
	
		_lValid := U_somaDist()	

	endif
	
	GETDREFRESH()
return _lValid



user function IFINA09D()
	if ! oGetTM1:aCols[n][len(oGetTM1:aHeader)+1]
		oGetTM1:aCols[n][len(oGetTM1:aHeader)+1] := .T.
	else
		oGetTM1:aCols[n][len(oGetTM1:aHeader)+1] := .F.
	endif

	u_somaDist()

	if ! oGetTM1:aCols[n][len(oGetTM1:aHeader)+1]
		oGetTM1:aCols[n][len(oGetTM1:aHeader)+1] := .T.
	else
		oGetTM1:aCols[n][len(oGetTM1:aHeader)+1] := .F.
	endif

return .T.


user function somaDist()
	local _nZY_VALOR	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_VALOR" })

	_lValid := .T.

	_nValOri	:= _nDistribui 
	nn := n
	_nDistribui := 0
	for x:= 1 to len(oGetTM1:aCols)
		if ! oGetTM1:aCols[x][len(oGetTM1:aHeader)+1]
	        if readvar() == "M->ZY_VALOR" .and. x = oGetTM1:NAT
				_nDistribui += M->ZY_VALOR
	        else
				_nDistribui += oGetTM1:aCols[x][_nZY_VALOR]	
		    endif
		endif
	
		GETDREFRESH(odlg)
	
	next x
	
	if _nTotal < _nDistribui
		msgAlert ("O Valor distribuido não pode ser superior ao total. Favor verificar !!")
		_lValid := .F.	
		_nDistribui := _nValOri
	endif  
	
	n := nn

return _lValid


user function validaProc(_cProc)
	_lValid := .T.

	dbSelectArea("SZ2")
	if _cProc == "I"
		dbSetOrder(3)
		
		if ! dbSeek(xFilial("SZ2")+M->ZY_CODPROC)
 			msgAlert ("Processo não encontrado !!")
//			_lValid := .F.	
		endif      
		
	else
		dbSetOrder(5)
		
		if ! dbSeek(M->ZY_PROCISA)
			msgAlert ("Referência não encontrada !!")
//			_lValid := .F.	
		endif
	endif
return _lValid
         

static function validar()
	lOk := .T.		

	if len(oGetTM1:Acols) == 0
		msgAlert ("Nenhuma distribuição efetuada !!")
		lOk := .F.		
	endif

	if lOk        
		IFINA09C()
		oDlg:End()    
	endif
return lOk


static function IFINA09C()

	local _nZY_VALOR	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_VALOR" })
	local _nZY_CODPROC	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_CODPROC" })
	local _nZY_PROCISA	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_PROCISA" })
	local _nZY_REC_WT	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "ZY_REC_WT" })

	dbSelectArea("SZY")
	for x:=1 to len(oGetTM1:Acols)

		if ! oGetTM1:aCols[x][len(oGetTM1:aHeader)+1]
			if oGetTM1:aCols[x][_nZY_REC_WT] == 0
				reclock("SZY", .T.)
	
				SZY->ZY_FILIAL	:= xFilial("SZY")
				SZY->ZY_PREFIXO	:= _cPrefixo
				SZY->ZY_NUM		:= _cNum
				SZY->ZY_PARCELA	:= _cParcela
				SZY->ZY_TIPO	:= _cTipo
				SZY->ZY_FORNECE	:= _cFornece
				SZY->ZY_LOJA	:= _cloja
				SZY->ZY_CODPROC	:= oGetTM1:aCols[x][_nZY_CODPROC]
				SZY->ZY_PROCISA	:= oGetTM1:aCols[x][_nZY_PROCISA]
				SZY->ZY_VALOR	:= oGetTM1:aCols[x][_nZY_VALOR]
	
		        SZY->(msUnlock())
		        
		        dbSelectArea("SZ2")
		        dbSetOrder(3)
		        if dbSeek(xFilial("SZ2")+oGetTM1:aCols[x][_nZY_CODPROC])
					reclock("SZ2", .F.)
					SZ2->Z2_PGANTEC	+= oGetTM1:aCols[x][_nZY_VALOR]				
		        	SZ2->(msUnlock())
		        endif
		    else
				dbSelectArea("SZY")
				go oGetTM1:aCols[x][_nZY_REC_WT]

				_nValOri := SZY->ZY_VALOR
				_cProcOri:= SZY->ZY_CODPROC
				
				reclock("SZY", .F.)
					SZY->ZY_VALOR	:= oGetTM1:aCols[x][_nZY_VALOR]
					SZY->ZY_CODPROC	:= oGetTM1:aCols[x][_nZY_CODPROC]
					SZY->ZY_PROCISA	:= oGetTM1:aCols[x][_nZY_PROCISA]
		        SZY->(msUnlock())
	        
		        dbSelectArea("SZ2")
		        dbSetOrder(3)
				if _cProcOri <> oGetTM1:aCols[x][_nZY_CODPROC]                                  
			        if dbSeek(xFilial("SZ2")+_cProcOri)
						reclock("SZ2", .F.)
						SZ2->Z2_PGANTEC	:= SZ2->Z2_PGANTEC - _nValOri
					endif
			        if dbSeek(xFilial("SZ2")+oGetTM1:aCols[x][_nZY_CODPROC])
						reclock("SZ2", .F.)
						SZ2->Z2_PGANTEC	:= SZ2->Z2_PGANTEC + oGetTM1:aCols[x][_nZY_VALOR]
					endif
				else
			        if dbSeek(xFilial("SZ2")+oGetTM1:aCols[x][_nZY_CODPROC])
						reclock("SZ2", .F.)
						SZ2->Z2_PGANTEC	:= SZ2->Z2_PGANTEC - _nValOri + oGetTM1:aCols[x][_nZY_VALOR]
					endif
				endif
	        	SZ2->(msUnlock())
		   	endif
	    else    
			if oGetTM1:aCols[x][_nZY_REC_WT] > 0
				dbSelectArea("SZY")
				go oGetTM1:aCols[x][_nZY_REC_WT]
				reclock("SZY", .F.)
				SZY->(dbDelete())
	        	SZY->(msUnlock())
		        
		        dbSelectArea("SZ2")
		        dbSetOrder(3)
		        if dbSeek(xFilial("SZ2")+oGetTM1:aCols[x][_nZY_CODPROC])
					reclock("SZ2", .F.)
					SZ2->Z2_PGANTEC	-= oGetTM1:aCols[x][_nZY_VALOR]				
		        	SZ2->(msUnlock())          
		        endif
		   	endif
		endif
	
	next x

return

