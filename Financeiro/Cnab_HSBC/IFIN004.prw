#Include "RwMake.Ch"

/*
�����������������������������������������������������������������������������
���Programa  � AFIN004  �Autor  � MZM - MICROSIGA    � Data �  12/09/07   ���
�����������������������������������������������������������������������������
���Desc.     � Grava o digito da conta na coluna 043 do layout de remessa ���
���          � do sispag.                                                 ���
�����������������������������������������������������������������������������
���Uso       � Layout do SISPAG - SIGAPAGR.PAG                            ���
���          � Layout do HSBC   - HSBC_PAG.2PE                            ���
�����������������������������������������������������������������������������
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