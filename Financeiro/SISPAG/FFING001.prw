#Include "topconn.ch"
#Include "sigawin.ch"
#Include "protheus.ch"
#Include "rwmake.ch"
#Include "TbiConn.Ch"


//Sispag - Thiago domingues - Anadi - /02/2015

User Function _NumAGCTA()
Local _cAGCTA := ""
Local _cConta := ALLTRIM(SE2->E2_FORCTA)+ IIF(!Empty(SE2->E2_FCTADV),ALLTRIM(SE2->E2_FCTADV),"")
IF ALLTRIM(SE2->E2_FORBCO) == "341"  .OR.  ALLTRIM(SE2->E2_FORBCO) == "409"
	//_cAGCTA:=SUBST(SA2->A2_AGENCIA,1,5) +" 0000000"+SUBSTR(SA2->A2_NUMCON,1,5)+" "+RIGHT(ALLTRIM(SA2->A2_NUMCON),1)    
	_cAGCTA:="0"+SUBSTR(SE2->E2_FORAGE,1,4)+" "+Replicate("0",6) + StrZero(Val(SE2->E2_FORCTA),6,0)+" "+RIGHT(ALLTRIM(SE2->E2_FCTADV),1)
Else
	_cAGCTA:=STRZERO(VAL(SE2->E2_FORAGE),5) +" "+STRZERO(VAL(SUBSTR(_cConta,1,LEN(_cConta)-1)),12)+" "+RIGHT(_cConta,1)
EndIf

Return (_cAGCTA )

User Function _TCODD()
Local _cod := "34191124812351197025570994400003339300000580041 "
U_CFING001(_cod,"1")
Return

User Function _TCODL()
Local _cod := "34198393300000031161124720549423129002527000 "  
U_CFING001(ALLTRIM(_cod),"1") 
Return 

User Function CFING001(_cCodBar,_cTipoProc)

Local _cRetorno := ""
Local _nTam := Len(ALLTRIM(_cCodBar))
//SetPrvt("_cCodBar,_cTipoProc")  
//alert(str(_nTam)+" -> " + _cCodBar)
// Tratamento de boletos com a linha digitável incompleta (sem o valor)
If _nTam < 44
	_cCodBar := ALLTRIM(_cCodBar)+REPLICATE("0",47-_nTam) 
  //	alert(str(Len(ALLTRIM(_cCodBar)))+" > " + _cCodBar)
EndIf
Do Case
	    Case _cTipoProc == 1 //banco
	    	_cRetorno := _banco(_cCodBar)
	    Case _cTipoProc == 2 //moeda
		    _cRetorno := _moeda(_cCodBar)
	    Case _cTipoProc == 3 //dv
			_cRetorno := _DV(_cCodBar)
		Case _cTipoProc == 4 //fator + valor
			_cRetorno := _fvalor(_cCodBar)				
		Case _cTipoProc == 5 //livre
			_cRetorno := _livre(_cCodBar)
	    OtherWise
	    
	    EndCase
//Alert(STR(_nTAM))
Return(_cRetorno) 

Static Function _banco(_cCodBar) 
Local _cBanco :=""       
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cBanco := SUBSTR(_cCodBar,1,3)                                  
	ElseIf _nTam == 47
		_cBanco := SUBSTR(_cCodBar,1,3) 
	EndIf

Return(_cBanco)

Static Function _moeda(_cCodBar)
Local _cMoeda :="" 
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cMoeda := SUBSTR(_cCodBar,4,1)                                                                    
	ElseIf _nTam == 47
		_cMoeda := SUBSTR(_cCodBar,4,1) 
	EndIf

Return(_cMoeda)

Static Function _DV(_cCodBar)
Local _cDV :=""
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44 
    	_cDV := SUBSTR(_cCodBar,5,1)                                                                    
  //  	Alert(_cDV)
	ElseIf _nTam == 47
		_cDV := SUBSTR(_cCodBar,33,1)
	//	Alert(_cDV) 
	EndIf          
//	Alert(_cCodBar)
Return(_cDV)       



Static Function _fvalor(_cCodBar)
Local _cValor :=""
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cValor := STRZERO(VAL(SUBSTR(_cCodBar,6,14)),14)                                                                    
	ElseIf _nTam == 47
		_cValor := SUBSTR(_cCodBar,34,14) 
	EndIf

Return(_cValor)       

Static Function _livre(_cCodBar)
Local _cLivre :="" 
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cLivre := SUBSTR(_cCodBar,20,25)                                                                    
	ElseIf _nTam == 47
		_cLivre := SUBSTR(_cCodBar,5,5) +SUBSTR(_cCodBar,11,10)+SUBSTR(_cCodBar,22,10)
	EndIf

Return(_cLivre)


User Function _Trib1() 


LOCAL __nVal:= ""
Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local nVALOR := 0	

_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)

If SEA->EA_MODELO == "24"
nVALOR :=  STRZERO(ROUND(SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC,2)*100,12)
Else
nVALOR := STRZERO(ROUND(SE2->E2_DECRESC,2)*100,12)
EndIf   
			 
RETURN ( nVALOR )

//--------------------Tipo de Documento - CNAB Safra------------------------------------//

User Function _TipoDoc ()
local _Tipo := ALLTRIM(SE2->E2_TIPO)

Do Case
	case _Tipo == "BOL"
		_Tipo := "BLQ"
    case _Tipo == "NF"
    	_Tipo := "NF"
    case _Tipo == "NP"
    	_Tipo := "NP"
OtherWise
	_Tipo := "OUT"
EndCase
Return(_Tipo)
//------------------------------------------------------------------------------------//
//--------------------Codigo de Barras - CNAB Safra------------------------------------//
User Function IFING02()
Local _cCodBar := SE2->E2_CODBAR
Local _cRetorno := ""
Local _nTam := Len(ALLTRIM(_cCodBar))
//SetPrvt("_cCodBar,_cTipoProc")  
//alert(str(_nTam)+" -> " + _cCodBar)
// Tratamento de boletos com a linha digitável incompleta (sem o valor)
If _nTam < 44
	_cCodBar := ALLTRIM(_cCodBar)+REPLICATE("0",47-_nTam) 
  //	alert(str(Len(ALLTRIM(_cCodBar)))+" > " + _cCodBar)
EndIf

	_cRetorno := _banco2(_cCodBar) + _moeda2(_cCodBar) + _DV2(_cCodBar) + _fvalor2(_cCodBar) + _livre2(_cCodBar)


//Alert(STR(_nTAM))
Return(_cRetorno) 

Static Function _banco2(_cCodBar) 
Local _cBanco :=""       
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cBanco := SUBSTR(_cCodBar,1,3)                                  
	ElseIf _nTam == 47
		_cBanco := SUBSTR(_cCodBar,1,3) 
	EndIf

Return(_cBanco)

Static Function _moeda2(_cCodBar)
Local _cMoeda :="" 
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cMoeda := SUBSTR(_cCodBar,4,1)                                                                    
	ElseIf _nTam == 47
		_cMoeda := SUBSTR(_cCodBar,4,1) 
	EndIf

Return(_cMoeda)

Static Function _DV2(_cCodBar)
Local _cDV :=""
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44 
    	_cDV := SUBSTR(_cCodBar,5,1)                                                                    
  //  	Alert(_cDV)
	ElseIf _nTam == 47
		_cDV := SUBSTR(_cCodBar,33,1)
	//	Alert(_cDV) 
	EndIf          
//	Alert(_cCodBar)
Return(_cDV)       



Static Function _fvalor2(_cCodBar)
Local _cValor :=""
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cValor := STRZERO(VAL(SUBSTR(_cCodBar,6,14)),14)                                                                    
	ElseIf _nTam == 47
		_cValor := SUBSTR(_cCodBar,34,14) 
	EndIf

Return(_cValor)       

Static Function _livre2(_cCodBar)
Local _cLivre :="" 
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cLivre := SUBSTR(_cCodBar,20,25)                                                                    
	ElseIf _nTam == 47
		_cLivre := SUBSTR(_cCodBar,5,5) +SUBSTR(_cCodBar,11,10)+SUBSTR(_cCodBar,22,10)
	EndIf

Return(_cLivre)
//------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------//
//--------------------Valor do Trillher do segmento A - CNAB Banco do Brasil---------//

User Function _SegA() 
Local _aArea := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _Chv := SEA->EA_FILORIG+SEA->EA_NUMBOR //+ SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local nVALOR := 0	



If (SEA->EA_MODELO $ "01/02/03/41")
	dbselectarea("SE2")
	DbSetOrder(15)
	dbseek(_Chv)

	while (SE2->E2_NUMBOR == SEA->EA_NUMBOR)
		nVALOR += (SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC)*100
		dbskip()
	Enddo

EndIf  			 

RestArea(_aAreaSE2)
RestArea(_aArea)

RETURN ( STRZERO(nVALOR,18) )
//------------------------------------------------------------------------------------//

//--------------------Valor do Trillher do segmento O - CNAB Banco do Brasil---------//

User Function _SegO() 
Local _aArea := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _Chv := SEA->EA_FILORIG+SEA->EA_NUMBOR //+ SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local nVALOR := 0	



If (SEA->EA_MODELO == "13")
	dbselectarea("SE2")
	DbSetOrder(15)
	dbseek(_Chv)

	while (SE2->E2_NUMBOR == SEA->EA_NUMBOR)
		nVALOR += (SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC)*100
		dbskip()
	Enddo

EndIf  			 

RestArea(_aAreaSE2)
RestArea(_aArea)

RETURN ( STRZERO(nVALOR,18) )
//------------------------------------------------------------------------------------//

//--------------------Valor do Trillher do segmento J30 - CNAB Banco do Brasil---------//

User Function _SegJ() 
Local _aArea := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _Chv := SEA->EA_FILORIG+SEA->EA_NUMBOR //+ SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local nVALOR := 0	



If (SEA->EA_MODELO == "30")
	dbselectarea("SE2")
	DbSetOrder(15)
	dbseek(_Chv)

	while (SE2->E2_NUMBOR == SEA->EA_NUMBOR)
		nVALOR += (SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC)*100
		dbskip()
	Enddo

EndIf  			                   

RestArea(_aAreaSE2)
RestArea(_aArea)

RETURN ( STRZERO(nVALOR,18) )
//------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------//

//--------------------Valor do Trillher do segmento J31 - CNAB Banco do Brasil---------//

User Function _SegJ31() 
Local _aArea := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _Chv := SEA->EA_FILORIG+SEA->EA_NUMBOR //+ SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local nVALOR := 0	

If (SEA->EA_MODELO == "31")
	dbselectarea("SE2")
	DbSetOrder(18)
  	dbseek(_Chv)                           

	while (SE2->E2_NUMBOR == SEA->EA_NUMBOR)
		nVALOR += (SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC)*100
		SE2->(dbskip())
	Enddo

EndIf  			                   

RestArea(_aAreaSE2)
RestArea(_aArea)

RETURN ( STRZERO(nVALOR,18) )
//------------------------------------------------------------------------------------//
