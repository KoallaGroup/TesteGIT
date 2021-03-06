#Include "RwMake.Ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � AFIN005  篈utor  � MZM - MICROSIGA    � Data �  12/09/07   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     � Grava a CONTA DO FAVORECIDO na coluna 030 do layout de     罕�
北�          � remessa do sispag.                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篣so       � Layout do SISPAG - SIGAPAGR.PAG                            罕�
北�          � Layout do HSBC   - HSBC_PAG.2PE                            罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function IFIN005()

Local _cConta := 0
Local _nCol   := 0


If SEE->EE_CODIGO == "399"

	If SA2->A2_BANCO == "399"
		_nCol   := ALLTRIM(SE2->E2_FORCTA) + SUBSTR(SE2->E2_FCTADV,1,1)
		//_nCol   := ALLTRIM(SA2->A2_NUMCON) + SUBSTR(SA2->A2__DVCONT,1,1)
		_cConta := STRZERO( VAL(_nCol),12)  //Conta do favorecido com dois digitos.
	Else
		_cConta := STRZERO( VAL(SE2->E2_FORCTA),12) //Conta do favorecido com um digito.
		//_cConta := STRZERO( VAL(SA2->A2_NUMCON),12) //Conta do favorecido com um digito.
	EndIf
EndIf

Return(_cConta)