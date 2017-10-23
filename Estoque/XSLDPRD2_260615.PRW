#Include 'Protheus.ch' 

//-------------------------------------------------------------------
/*/{Protheus.doc} XSLDPRD2
Funcão para retornar o calculo do saldo do produto especifico Isapa POR FILIAL

@author Silverio Bastos
@since 10/10/2014
@version P11

@param cFilSld , character, Filial para calculo do saldo
@param cProduto, character, Código do produto para calculo do saldo
@param cCodSUA , character, Código do pedido na SUA para analisar o estoque online

@return nSaldo, numeric, Saldo do produto na filial e local informado
/*/
//-------------------------------------------------------------------
User Function xSldPrd2( _cFilial,cProduto, cCodSUA )

Local aAreaAtu  := GetArea()
Local aAreaSB1  := SB1->( GetArea() )
Local cSegmento := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto, "B1__SEGISP" )
Local nSaldo	:= 0
Local aResult	:= {}

Default cCodSUA := Replicate( "Z", TamSX3( "Z10_CODSUA" )[1] )
DbSelectArea("Z10")

aResult := TCSPExec( "SPSLDPRD2",;
					 _cFilial,;
					 cProduto,;
					 cCodSUA )

If Empty( aResult )
	MsgStop( "Problema com a SP: " + TCSQLError() )
Else
	nSaldo := aResult[1]
Endif

If !Empty( aResult[1] ) .and. _cFilial == "03" .and. cSegmento == "2   "
	aResult := TCSPExec( "SPSLDPRD2",;
						 "05",;
						 cProduto,;
						 cCodSUA )
	If Empty( aResult )
		MsgStop( "Problema com a SP: " + TCSQLError() )
	Else
		nSaldo += aResult[1]
	Endif
				 
Endif

RestArea( aAreaSB1 )
RestArea( aAreaAtu )

Return nSaldo