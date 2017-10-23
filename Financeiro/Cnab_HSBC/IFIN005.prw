#Include "RwMake.Ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ AFIN005  ºAutor  ³ MZM - MICROSIGA    º Data ³  12/09/07   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ Grava a CONTA DO FAVORECIDO na coluna 030 do layout de     º±±
±±º          ³ remessa do sispag.                                         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ Layout do SISPAG - SIGAPAGR.PAG                            º±±
±±º          ³ Layout do HSBC   - HSBC_PAG.2PE                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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