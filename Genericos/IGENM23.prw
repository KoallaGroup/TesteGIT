#INCLUDE "rwmake.ch"

/*/
+---------------------------------------------------------------------------+
| ºPrograma  |IGENM23     | Autor: Elpídio Lima      | Data |  10/04/15     |
+---------------------------------------------------------------------------+
| ºDescricao | Verifica e retorna o valor das comissões calculadas na SE1   |
+---------------------------------------------------------------------------+
| ºUso       | Isapa - Módulo Contabilidade Gerencial                       |
+---------------------------------------------------------------------------+
/*/

User Function IGENM23

//+---------------------------------------------------------------------------+
//| Declaracao de Variaveis                                                   |
//+---------------------------------------------------------------------------+
Local _nComiss := 0
Local _aArea    := getArea()
Local _aAreaSE1 := SE1->(getArea())

//ADICIONADO TRATAMENTO PARA VERIFICACAO DE SEGMENTO DO VENDEDOR
//RAFAEL DOMINGUES - 29/05/15
DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3") + SF2->F2_VEND1)

If AllTrim(A3__SEGISP) == '1' //SEGMENTO 1
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek(xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC)
		do while SF2->F2_SERIE + SF2->F2_DOC = SE1->E1_PREFIXO + SE1->E1_NUM
			_nComiss += (SE1->E1_COMIS1/100) * SE1->E1_BASCOM1
			SE1->(dbSkip())
		enddo
	EndIf
	
Else
	
	//SEGMENTO 2
	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek(xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC)
		do while SF2->F2_SERIE + SF2->F2_DOC = SE1->E1_PREFIXO + SE1->E1_NUM
			_nComiss += SE1->E1_VALCOM1
			SE1->(dbSkip())
		enddo
	EndIf
	
EndIf

restarea(_aAreaSE1)

restarea(_aArea)

Return _nComiss
