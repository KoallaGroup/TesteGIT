#Include "RwMake.Ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � AFIN004  篈utor  � MZM - MICROSIGA    � Data �  12/09/07   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     � Grava o digito da conta na coluna 043 do layout de remessa 罕�
北�          � do sispag.                                                 罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篣so       � Layout do SISPAG - SIGAPAGR.PAG                            罕�
北�          � Layout do HSBC   - HSBC_PAG.2PE                            罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function IFIN004()

Local _cDigito := ""

If SEE->EE_CODIGO == "399"
	
	If SA2->A2_BANCO == "399"
		_cDigito := SUBSTR(SA2->A2__DVCONT,2,2)
	ElseIf SA2->A2_BANCO == "479"
		_cDigito := SPACE(2)
	Else
		_cDigito := SUBSTR(SA2->A2__DVCONT,1,1)
	EndIf
EndIf

Return(_cDigito)