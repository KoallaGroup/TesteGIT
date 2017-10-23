#include "PROTHEUS.CH"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|	
|	Programa : F240BORD					| 	Novembro de 2014													|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi																		|
|---------------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para gravar a sinalização dos tipo de pagtos. de titulos						|
|---------------------------------------------------------------------------------------------------------------|	
*/

User Function F240BORD()
	local _aBordero := {}
	Local cProxNum	:= ""
	local _aArea	:= getArea()

	DBSelectArea("SE2TMP")
	dbGotop()
	while ! SE2TMP->(eof())
	     if SE2TMP->E2_OK == cMarca
			_loc := ascan(_aBordero, {|x|x[1] == SE2TMP->E2__MODBORD})   	
			if _loc == 0			
				aadd(_aBordero, {SE2TMP->E2__MODBORD, ""})
			endif
	     endif
	     SE2TMP->(dbSkip())
	enddo
                       
	_aBordero[1][2] := cNumbor
//	cNumborNew := cNumbor
	for x:= 2 to len(_aBordero)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe o mesmo numero de bordero gravado, quando ³
		//³ ocorrer geracao de bordero em usuarios simultaneos.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cProxNum := cNumBor
		Do While !ValBord(cProxNum)
//		Do While !FA240Num( cProxNum, .F. )
			cNumBor  := cProxNum
			cProxNum := Soma1( cNumBor )
		EndDo

//		cNumborNew := soma1(cNumborNew, 6)
		_aBordero[x][2] := cProxNum
		cNumBor := Soma1(cProxNum)
	next x

	for x:= 1 to len(_aBordero)
                
		SE2TMP->(dbGotop())
		while ! SE2TMP->(eof())
		     if SE2TMP->E2_OK == cMarca
				if SE2TMP->E2__MODBORD == _aBordero[x][1]			
                                              
					dbSelectArea("SEA")
					dbSetOrder(1)
					if dbSeek(xFilial("SE2")+_aBordero[1][2]+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)
						if recLock("SEA",.F.)              
							SEA->EA_NUMBOR := _aBordero[x][2]
							SEA->EA_MODELO := _aBordero[x][1]
							SEA->(msUnlock())				
						endif
					else
						alert ("Bordero Não encontrado")
					endif

						
					dbSelectArea("SE2")
					dbSetOrder(6)
					if dbSeek(SE2TMP->E2_FILIAL+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO)        
						if recLock("SE2",.F.) 
							SE2->E2__MODBORD:= _aBordero[x][1]
							SE2->E2_NUMBOR 	:= _aBordero[x][2]							
							SE2->(msUnlock())				
						endif
					else
						alert ("Titulo Não encontrado")
					endif
	
				endif
		     endif   
		     dbSelectArea("SE2TMP")
		     SE2TMP->(dbSkip())
		enddo

	next x

	DBSelectArea("SE2TMP")
	dbGotop()
	while ! SE2TMP->(eof())
	     if SE2TMP->E2_OK == cMarca
	     	dbSelectArea("SE2")
	     	go SE2TMP->NUM_REG

			if recLock("SE2",.F.) 
				SE2->E2_JUROS	:= SE2TMP->E2_JUROS
				SE2->E2_DESCONT	:= SE2TMP->E2_DESCONT
				SE2->E2_CODBAR	:= U_CONVLD(SE2TMP->E2_CODBAR)
				SE2->E2__DTPAG	:= SE2TMP->E2__DTPAG
				SE2->E2__TIPCOD	:= SE2TMP->E2__TIPCOD  
				
				SE2->E2_FORBCO	:= SE2TMP->E2_FORBCO
				SE2->E2_FORAGE	:= SE2TMP->E2_FORAGE
				SE2->E2_FAGEDV	:= SE2TMP->E2_FAGEDV
				SE2->E2_FORCTA	:= SE2TMP->E2_FORCTA
				SE2->E2_FCTADV	:= SE2TMP->E2_FCTADV
	
				SE2->(msUnlock())				
			endif	
	     
	     endif
	     SE2TMP->(dbSkip())
	enddo

	dbSelectArea("SX6")
	GetMv("MV_NUMBORP")
	// Garante que o numero do bordero seja sempre superior ao numero anterior
	If SX6->X6_CONTEUD < cProxNum
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := cProxNum
		msUnlock()
	Endif
        
    _msg := ""
	for x:= 1 to len(_aBordero)
		_msg += _aBordero[x][2]
		if x < len(_aBordero)
			_msg += ", "
		endif
	next x

	DEFINE MSDIALOG _oDlg TITLE "Borderôs Gerados" FROM C(178),C(180) TO C(310),C(480) PIXEL

	@ 05,10 say "Borderôs Gerados :" size 2500,20 PIXEL OF _oDlg                                     	
	@ 20,10 say _msg  size 180,40 PIXEL OF _oDlg
    @ 70,10 Button "Ok" Size 20,10 PIXEL OF _oDlg ACTION {_oDlg:End()}

	ACTIVATE MSDIALOG _oDlg CENTERED 
	
	RestArea(_aArea)
	
return

/*
|---------------------------------------------------------------------------------------------------------------|	
|	Programa : ValBord					| 	Março de 2015														|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																		|
|---------------------------------------------------------------------------------------------------------------|	
|	Descrição : Valida se o Bordero está sendo usado ou já existe												|
|---------------------------------------------------------------------------------------------------------------|	
*/

Static Function ValBord(_cNumBord)
Local _lRet		:= .F.
Local _cQuery	:= ""

If Select("TRB_SEA") > 0
	DbSelectArea("TRB_SEA")
	DbCloseArea()
EndIf

_cQuery := "SELECT *                                       " + Chr(13)
_cQuery += "FROM " + RetSqlName("SEA") + " SEA             " + Chr(13)
_cQuery += "WHERE SEA.D_E_L_E_T_ = ' '                     " + Chr(13)
_cQuery += "      AND SEA.EA_NUMBOR = '" + _cNumBord + "'  "
TcQuery _cQuery New Alias "TRB_SEA"
            
If(TRB_SEA->(eof()))
	//verifica se esta na memoria, sendo usado busca o proximo numero disponivel 
	If MayIUseCode("E2_NUMBOR"+xFilial("SE2")+_cNumBord)
		_lRet := .T.	
	EndIf
EndIf

TRB_SEA->(DbCloseArea())

Return _lRet