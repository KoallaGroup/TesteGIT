#include "protheus.ch"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|	
|	Programa : F240CONF					| 	Novembro de 2014													|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi																		|
|---------------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para sinalizar os tipo de pagtos. de titulos									|
|---------------------------------------------------------------------------------------------------------------|	
*/

user function F240CONF()
	local _lRet		:= .F.
	local _aArea	:= getArea()
    private _aHeader:= {}
    private _aCols	:= {} 
    private _aEdit	:= {"E2__MODBOR", "E2_JUROS", "E2_DESCONT", "E2_CODBAR", "E2__DTPAG", "E2__TIPCOD", "E2_FORBCO", "E2_FORAGE", "E2_FAGEDV", "E2_FORCTA", "E2_FCTADV","E2__TIPBOR", "E2__CODREG"}
	Private oGet1
	Private cGet1 := CTOD("  /  /    ")
	
	oFont := tFont():New("Tahoma",,-12,,.F.)

	_aHeader:= criaHeader() 
	
	_aCols 	:= criaAcols()

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3,3}
	aPosObj := MsObjSize(aInfo, aObjects)	

	DEFINE MSDIALOG oDlg TITLE "Borderô" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
     
    oGetTM1 := MsNewGetDados():New(aPosObj[1,1], aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", _aEdit, , , , , , oDlg, _aHeader, _aCols)
    
	@ aPosObj[1,3]+3,aPosObj[1,4]-450 SAY oSay9 PROMPT "Data Pagamento:" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ aPosObj[1,3]+3,aPosObj[1,4]-400 MSGET oGet1 VAR cGet1 SIZE 060, 008 OF oDlg COLORS 0, 16777215 PIXEL  
    @ aPosObj[1,3]+3,aPosObj[1,4]-335 BUTTON "Replicar Data"	SIZE 70,10 Of oDlg PIXEL FONT oFont ACTION AlteraDt()  

 	@ aPosObj[1,3]+3,aPosObj[1,4]-160 BUTTON "Gerar"	SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION _lRet := U_F240_GER()
 	@ aPosObj[1,3]+3,aPosObj[1,4]-080 BUTTON "Fechar"	SIZE 60,10 Of oDlg PIXEL FONT oFont ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED 

	restArea(_aArea)
return _lRet



static function criaHeader()   
	aCpoHeader   := {"E2_FILIAL", "E2_NOMFOR", "E2_NUM", "E2_PARCELA", "E2_PREFIXO", "E2_VALOR", "E2_TIPO", "E2__MODBOR", "E2__TIPBOR", "E2_CODBAR", "E2__CODREG", "E2_VENCREA", "E2__DTPAG", "E2_JUROS", "E2_DESCONT", "E2_FORBCO", "E2_FORAGE", "E2_FAGEDV", "E2_FORCTA", "E2_FCTADV", "E2_NATUREZ", "E2_PORTADO", "E2_EMISSAO", "E2_TITORIG", "E2__TIPCOD"}

	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			AAdd(_aHeader, {Trim(SX3->X3_Titulo),;
							SX3->X3_Campo       ,;
							SX3->X3_Picture     ,;
							SX3->X3_Tamanho     ,;
							SX3->X3_Decimal     ,;
							iif (SX3->X3_Campo == 'E2__MODBOR', 'U_F240_VAL()' , IIF(Alltrim(SX3->X3_CAMPO) == "E2_CODBAR",SX3->X3_VLDUSER,SX3->X3_VALID)) ,;
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

	AADD( _aHeader, { "Recno WT", "E2_REC_WT", "", 09, 0,,, "N", "SE2", "V"} )

return _aHeader
  


static function criaAcols()
                           
	recPosicao() 
	_aCols := {}    

	nQtdCpo := Len(_aHeader)

	DBSelectArea("SE2TMP")
	dbGotop()
	while ! SE2TMP->(eof())
	     if SE2TMP->E2_OK == cMarca

			nn := len(_aCols) + 1
		   	aadd(_aCols, Array(nQtdCpo+1))

		    _aCols[nn][nE2_NUM]		:= SE2TMP->E2_NUM
		    _aCols[nn][nE2_PARCELA]	:= SE2TMP->E2_PARCELA
		    _aCols[nn][nE2_TIPO]	:= SE2TMP->E2_TIPO
		    _aCols[nn][nE2_NOMFOR]	:= SE2TMP->E2_NOMFOR
		    _aCols[nn][nE2_VENCREA]	:= SE2TMP->E2_VENCREA
		    _aCols[nn][nE2_VALOR]	:= SE2TMP->E2_VALOR
		    _aCols[nn][nE2__MODBOR]	:= SE2TMP->E2__MODBOR
		    _aCols[nn][nE2_REC_WT]	:= SE2TMP->NUM_REG
			_aCols[nn][nE2__TIPBOR]	:= SE2TMP->E2__TIPBOR
			_aCols[nn][nE2__CODREG]	:= SE2TMP->E2__CODREG
		    _aCols[nn][nE2_PREFIXO]	:= SE2TMP->E2_PREFIXO
		    _aCols[nn][nE2_NATUREZ]	:= SE2TMP->E2_NATUREZ
		    _aCols[nn][nE2_PORTADO]	:= SE2TMP->E2_PORTADO
		    _aCols[nn][nE2_FILIAL]	:= SE2TMP->E2_FILIAL
		    _aCols[nn][nE2_JUROS]	:= SE2TMP->E2_JUROS
		    _aCols[nn][nE2_DESCONT]	:= SE2TMP->E2_DESCONT
		    _aCols[nn][nE2_EMISSAO]	:= SE2TMP->E2_EMISSAO
		    _aCols[nn][nE2_TITORIG]	:= SE2TMP->E2_TITORIG
		    _aCols[nn][nE2_CODBAR]	:= SE2TMP->E2_CODBAR   
		    _aCols[nn][nE2__DTPAG]	:= SE2TMP->E2__DTPAG     
		    _aCols[nn][nE2__TIPCOD]	:= SE2TMP->E2__TIPCOD    
		    //_aCols[nn][nE2_FORBCO]	:= iif(empty(SE2TMP->E2_FORBCO), posicione("SA2",1,xFilial("SA2")+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA, "A2_BANCO"), SE2TMP->E2_FORBCO)
		    //_aCols[nn][nE2_FORAGE]	:= iif(empty(SE2TMP->E2_FORAGE), SA2->A2_AGENCIA, SE2TMP->E2_FORAGE)
		    //_aCols[nn][nE2_FAGEDV]	:= iif(empty(SE2TMP->E2_FAGEDV), SA2->A2__DVAGEN, SE2TMP->E2_FAGEDV)
		    //_aCols[nn][nE2_FORCTA]	:= iif(empty(SE2TMP->E2_FORCTA), SA2->A2_NUMCON, SE2TMP->E2_FORCTA)
		    //_aCols[nn][nE2_FCTADV]	:= iif(empty(SE2TMP->E2_FCTADV), SA2->A2__DVCONT, SE2TMP->E2_FCTADV)
		    _aCols[nn][nE2_FORBCO]	:= posicione("SA2",1,xFilial("SA2")+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA, "A2_BANCO")
		    _aCols[nn][nE2_FORAGE]	:= SA2->A2_AGENCIA
		    _aCols[nn][nE2_FAGEDV]	:= SA2->A2__DVAGEN
		    _aCols[nn][nE2_FORCTA]	:= SA2->A2_NUMCON
		    _aCols[nn][nE2_FCTADV]	:= SA2->A2__DVCONT
		    
		    _aCols[nn][Len(_aHeader)+1] 	:= .F.

	     endif
	     SE2TMP->(dbSkip())
	enddo
    
	asort(_aCols, , , { | x,y | x[nE2_NOMFOR] < y[nE2_NOMFOR] })

return _aCols



static function recPosicao() 
	static nE2_NUM		:= 0
	static nE2_PARCELA	:= 0
	static nE2_TIPO		:= 0
	static nE2_NOMFOR	:= 0
    static nE2_VENCREA	:= 0
	static nE2_VALOR	:= 0
	static nE2_REC_WT	:= 0
	static nE2__MODBOR	:= 0
	static nE2__TIPBOR	:= 0
	static nE2__CODREG	:= 0
	static nE2_PREFIXO	:= 0
	static nE2_NATUREZ	:= 0
	static nE2_PORTADO	:= 0
	static nE2_FILIAL	:= 0
	static nE2_JUROS	:= 0
	static nE2_DESCONT	:= 0
	static nE2_EMISSAO	:= 0
	static nE2_TITORIG	:= 0
	static nE2_CODBAR	:= 0   
	static nE2__DTPAG	:= 0
	static nE2__TIPCOD
	static nE2_FORBCO	:= 0
	static nE2_FORAGE	:= 0
	static nE2_FAGEDV	:= 0
	static nE2_FORCTA	:= 0
	static nE2_FCTADV	:= 0
	             
	nE2_NUM  	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_NUM" }) 
    nE2_PARCELA	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_PARCELA" })
    nE2_TIPO	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_TIPO" })
    nE2_NOMFOR	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_NOMFOR" })
    nE2_VENCREA	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_VENCREA" })
	nE2_VALOR	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_VALOR" })
	nE2__MODBOR	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2__MODBOR" })
	nE2_REC_WT	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_REC_WT" })
	nE2_PREFIXO	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_PREFIXO" })
	nE2_NATUREZ	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_NATUREZ" })
	nE2_PORTADO	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_PORTADO" })
	nE2_FILIAL	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_FILIAL" })
	nE2_JUROS	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_JUROS"})
	nE2_DESCONT	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_DESCONT"})
	nE2_EMISSAO	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_EMISSAO" })
	nE2_TITORIG	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_TITORIG" })
	nE2_CODBAR	:= 	ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_CODBAR" })  
	nE2__DTPAG	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2__DTPAG" })  
	nE2__TIPCOD	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2__TIPCOD" })  
	nE2_FORBCO	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_FORBCO" })  
	nE2_FORAGE	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_FORAGE" })  
	nE2_FAGEDV	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_FAGEDV" })  
	nE2_FORCTA	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_FORCTA" })  
	nE2_FCTADV	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2_FCTADV" })  
	nE2__TIPBOR	:= ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2__TIPBOR" })
	nE2__CODREG	:= ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2__CODREG" })
	
return
 


user function F240_VAL()
	local _lRet := .T.
	local _aArea	:= getArea()
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SX5")+"58"+M->E2__MODBOR) .and. ! empty(M->E2__MODBOR)
		msgAlert ("Tipo de Pagamento não encontrado. Favor verificar !!")
		_lRet := .F.	
	endif
		
	restArea(_aArea)
return _lRet



user function F240_GER()
	local _lBranco 	:= .F.
	local _lContinua:= .T.
	
	recPosicao()
	
	for x:=1 to len(oGetTM1:Acols)
		if empty(oGetTM1:Acols[x][nE2__MODBOR])
			_lBranco := .T.
		   exit
		endif		
	next x
        
    if _lBranco    
    	if ! msgYesNo("Os ítens sem definição do tipo de pagamento assumirão a condição inicial, continua ?","Confirme")
       		_lContinua := .F.
    	endif    	
    endif                    

    if _lContinua    	    
		for x:=1 to len(oGetTM1:Acols)
			dbSelectArea("SE2TMP")
			dbGotop()
			while ! SE2TMP->(eof())
			     if SE2TMP->E2_OK == cMarca
		         	if oGetTM1:Acols[x][nE2_REC_WT] == SE2TMP->NUM_REG
		         		if reclock("SE2TMP", .F.)
							if empty(oGetTM1:Acols[x][nE2__MODBOR])
                            	SE2TMP->E2__MODBOR	:= cModPgto //CTIPOPAG
							else
                            	SE2TMP->E2__MODBOR	:= oGetTM1:Acols[x][nE2__MODBOR]
							endif
							SE2TMP->E2_JUROS	:= oGetTM1:Acols[x][nE2_JUROS]
							SE2TMP->E2_DESCONT	:= oGetTM1:Acols[x][nE2_DESCONT]
							SE2TMP->E2_CODBAR	:= oGetTM1:Acols[x][nE2_CODBAR]
							SE2TMP->E2__DTPAG	:= oGetTM1:Acols[x][nE2__DTPAG]
							SE2TMP->E2__TIPCOD	:= oGetTM1:Acols[x][nE2__TIPCOD]

						endif
					endif		
			     endif
			     SE2TMP->(dbSkip())
			enddo
		next x

		for x:=1 to len(oGetTM1:Acols)
			dbSelectArea("SE2TMP")
			dbGotop()
			while ! SE2TMP->(eof())
			     if SE2TMP->E2_OK == cMarca
		         	if oGetTM1:Acols[x][nE2_REC_WT] == SE2TMP->NUM_REG
		         		if reclock("SE2TMP", .F.)
							if empty(oGetTM1:Acols[x][nE2__MODBOR])
                            	SE2TMP->E2__MODBOR	:= cModPgto //CTIPOPAG
							else
                            	SE2TMP->E2__MODBOR	:= oGetTM1:Acols[x][nE2__MODBOR]
							endif
							SE2TMP->E2_JUROS	:= oGetTM1:Acols[x][nE2_JUROS]
							SE2TMP->E2_DESCONT	:= oGetTM1:Acols[x][nE2_DESCONT]
							SE2TMP->E2_CODBAR	:= oGetTM1:Acols[x][nE2_CODBAR]
							SE2TMP->E2__DTPAG	:= oGetTM1:Acols[x][nE2__DTPAG]
							SE2TMP->E2__TIPCOD	:= oGetTM1:Acols[x][nE2__TIPCOD]
							SE2TMP->E2_FORBCO	:= oGetTM1:Acols[x][nE2_FORBCO]
							SE2TMP->E2_FORAGE	:= oGetTM1:Acols[x][nE2_FORAGE]
							SE2TMP->E2_FAGEDV	:= oGetTM1:Acols[x][nE2_FAGEDV]
							SE2TMP->E2_FORCTA	:= oGetTM1:Acols[x][nE2_FORCTA]
							SE2TMP->E2_FCTADV	:= oGetTM1:Acols[x][nE2_FCTADV]
						endif
					endif		
			     endif
			     SE2TMP->(dbSkip())
			enddo
		next x
	    
    	oDlg:End()
    endif

return _lContinua 


*-------------------------
Static Function AlteraDt()
*-------------------------

Local lRdt := .F.
Static nE2__DTPAG	:= 0


nE2__DTPAG	:=  ASCAN(_aHeader, { |x| AllTrim(x[2]) == "E2__DTPAG" })  
       
    	If msgYesNo("Deseja manter as datas de pagamento ja preenchidas?","Confirme")
    		lRdt := .T.
    	EndIf 

		For X:=1 To Len(oGetTM1:Acols)
            If lRdt .And. Empty(oGetTM1:Acols[X][nE2__DTPAG])    
	   	   		oGetTM1:Acols[x][nE2__DTPAG] := cGet1
	   	   	ElseIf !lRdt
	   	   		oGetTM1:Acols[x][nE2__DTPAG] := cGet1
	   	   	EndIf	
        Next
			oGetTM1:Refresh()
			
			MsgInfo("Data de Pagamento Alterada com sucesso!")

Return