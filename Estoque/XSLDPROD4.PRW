#Include 'Protheus.ch' 

/*
+-------------+-----------+--------+------------------------------------------+-------+------------+
| Programa:   | XSLDPROD4 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Julho/2015 |
+-------------+-----------+--------+------------------------------------------+-------+------------+
| Descrição:  | Retorna o calculo do saldo do produto especifico Isapa para um RANGE de armazém    |
|             | das filiais diferentes da que foi informada por parametro						   |
+-------------+------------------------------------------------------------------------------------+
| Parametros  | _cFilial   -> Filial para calculo do saldo										   |
|			  | _cProduto  -> Código do produto para calculo do saldo							   |
|			  | _cLocDe    -> Código do local DE (armazém para calculo do saldo)				   |
|			  | _cCodSUA   -> Código do pedido na SUA para analisar o estoque online			   |
|			  |	_cOriExec  -> Origem da execução												   |
|			  | _cNumSC5   -> Pedido SC5														   |
|			  | _cItmSC6   -> Item pedido SC6													   |
|			  |	_cLocAte   -> Código do local ATE (armazém para calculo do saldo)				   |
+-------------+------------------------------------------------------------------------------------+
| Retorno     | _nSaldo -> Saldo do produto na filial e local informado					   		   |
+-------------+------------------------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         	   		   |
+-------------+------------------------------------------------------------------------------------+
*/

User Function xSldPrd4(_cFilial,_cProduto,_cLocDe,_cCodSUA,_cOriExec,_cNumSC5,_cItmSC6,_cLocAte)

Local _aAreaAtu  := GetArea()
Local _aAreaSB1  := SB1->( GetArea() )
Local _cSegmento := Posicione( "SB1", 1, xFilial( "SB1" ) + _cProduto, "B1__SEGISP" )
Local _nSaldo	:= 0
Local _aResult	:= {}

Default _cCodSUA := Replicate("Z", TamSX3( "Z10_CODSUA" )[1]), _cOriExec := "", _cLocAte := ""
Default _cNumSC5 := Replicate( "Z", TamSX3( "C5_NUM" )[1] ), _cItmSC6 := Replicate( "Z", TamSX3( "C6_ITEM" )[1] )
 
DbSelectArea("Z10")

If Empty(_cLocAte)
	_cLocAte := _cLocDe
EndIf

_aResult := TCSPExec( "SPSLDPRD4",;
					 _cFilial,;
					 _cProduto,;
					 _cLocDe,;
					 _cCodSUA,;
					 _cNumSC5,;
					 _cItmSC6,; 
					 _cLocAte )

If Empty( _aResult )
	MsgStop( "Problema com a SP: " + TCSQLError() )
Else
	_nSaldo := _aResult[1]
Endif

RestArea( _aAreaSB1 )
RestArea( _aAreaAtu )

Return _nSaldo