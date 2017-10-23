#Include 'Protheus.ch' 

//---------------------------------------------------------------------------------------------
/*/{Protheus.doc} XSLDPROD
Funcão para retornar o calculo do saldo do produto especifico Isapa

@author Ivan Morelatto Toré
@since 21/08/2014
@version P11

@param cFilSld   , character, Filial para calculo do saldo
@param cProduto  , character, Código do produto para calculo do saldo
@param cLocal    , character, Código do local (armazém para calculo do saldo)
@param cCodSUA   , character, Código do pedido na SUA para analisar o estoque online
@param _cOriExec , character, Origem da execução
@param _cNumSC5  , character, Pedido SC5
@param _cItmSC6  , character, Item pedido SC6

@return nSaldo, numeric, Saldo do produto na filial e local informado
/*/
//-----------------------------------------------------------------------------------------------
User Function xSldProd( _cFilial,cProduto, cLocal, cCodSUA,_cOriExec, _cNumSC5, _cItmSC6 )

Local aAreaAtu  := GetArea()
Local aAreaSB1  := SB1->( GetArea() )
Local cSegmento := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto, "B1__SEGISP" )
Local nSaldo	:= 0, _lErroSP := .f.
Local aResult	:= {}

Default cCodSUA := Replicate( "Z", TamSX3( "Z10_CODSUA" )[1] ), _cOriExec := "", _cNumSC5 := "", _cItmSC6 := "" 
DbSelectArea("Z10")

aResult := TCSPExec( "SPSLDPRD",;
					 _cFilial,;
					 cProduto,;
					 cLocal,;
					 cCodSUA,;
					 _cNumSC5,;
					 _cItmSC6  )

If Empty( aResult )
	MsgStop( "Problema com a SP: " + TCSQLError() )
	_lErroSP := .t.
Else
	nSaldo := aResult[1]
Endif

//If !Empty( aResult[1] ) .and. _cFilial == "03" .and. Val(cSegmento) == 1 .And. Empty(_cOriExec)
If !_lErroSP .and. _cFilial == "03" .and. Val(cSegmento) == 1 .And. Empty(_cOriExec)
	aResult := TCSPExec( "SPSLDPRD",;
						 "05",;
						 cProduto,;
						 cLocal,;
						 cCodSUA,;
						 _cNumSC5,;
						 _cItmSC6  )
	If Empty( aResult )
		MsgStop( "Problema com a SP: " + TCSQLError() )
		_lErroSP := .t.
	Else
		nSaldo += aResult[1]
	Endif
				 
Endif

RestArea( aAreaSB1 )
RestArea( aAreaAtu )

Return nSaldo

//-----------------------------------------------------------------------------------------------------
// Procedure compilado no Oracle, sempre que for alterar, colar a nova procedure abaixo
//-----------------------------------------------------------------------------------------------------
/*
CREATE OR REPLACE PROCEDURE SPSLDPRD (
	IN_FILIAL  in CHAR ,
	IN_PRODUTO in CHAR ,
	IN_LOCAL   in CHAR ,
	IN_CODSUA  in CHAR ,
	OUT_SALDO out FLOAT )
	
IS

-- Declara??o de Vari?veis
vcB1__SEGISP CHAR(2);
vnB2_QATU    FLOAT;
vnB2_RESERVA FLOAT;
vnB2_QEMP    FLOAT;
vnB2_QACLASS FLOAT;
vnZ10_QTD    FLOAT;
vnB2__QTDTRA FLOAT;
vnZX_SALDO   FLOAT;
vnC6_QUANT   FLOAT;
vnB2__QTDISP FLOAT;
vnB2_QNPT    FLOAT;
vnB2__ENTPRC FLOAT;
vnB2__SAIPRC FLOAT;

BEGIN
  	
  	-- Zero as Vari?veis
  	vnB2_QATU    := 0;
	vnB2_RESERVA := 0;
	vnB2_QEMP    := 0;
	vnB2_QACLASS := 0;
	vnZ10_QTD    := 0;
	vnB2__QTDTRA := 0;
	vnZX_SALDO   := 0;
	vnC6_QUANT   := 0;
	vnB2__QTDISP := 0;
	vnB2_QNPT    := 0;
	vnB2__ENTPRC := 0;
	vnB2__SAIPRC := 0;
	
	
	-- Seleciona SB1 - Segmento
	BEGIN
		SELECT B1__SEGISP
		  INTO vcB1__SEGISP
		  FROM SB1010
		 WHERE B1_FILIAL  = '  '
		   AND B1_COD     = IN_PRODUTO
		   AND D_E_L_E_T_ = ' ';
	EXCEPTION 
      	WHEN NO_DATA_FOUND THEN NULL;
   	END;
	
	-- Seleciona SB2 - Saldo Atual 
	BEGIN
		SELECT B2_QATU, B2_RESERVA, B2_QEMP, B2_QACLASS, B2__QTDTRA, B2__QTDISP, B2_QNPT, B2__ENTPRC, B2__SAIPRC
		  INTO vnB2_QATU, vnB2_RESERVA, vnB2_QEMP, vnB2_QACLASS, vnB2__QTDTRA, vnB2__QTDISP, vnB2_QNPT, vnB2__ENTPRC, vnB2__SAIPRC
		  FROM SB2010
		 WHERE B2_FILIAL  = IN_FILIAL
		   AND B2_COD     = IN_PRODUTO
		   AND B2_LOCAL   = IN_LOCAL
		   AND D_E_L_E_T_ = ' ';
	EXCEPTION 
      	WHEN NO_DATA_FOUND THEN NULL;
   	END;
   	
   	-- Seleciona Z10 - Digita??o Call Center
   	BEGIN
   		SELECT NVL( SUM( Z10_QTD ), 0 ) Z10_QTD
   		  INTO vnZ10_QTD
   		  FROM Z10010
   		 WHERE Z10_FILIAL  = IN_FILIAL
   		   AND Z10_PROD    = IN_PRODUTO
   		   AND Z10_LOCAL   = IN_LOCAL
   		   AND Z10_CODSUA != IN_CODSUA
   		   AND D_E_L_E_T_  = ' ';
	EXCEPTION 
      	WHEN NO_DATA_FOUND THEN NULL;
   	END;
   	
   	-- Seleciona SZX - Crossdoking
   	BEGIN
   		SELECT NVL( SUM( ZX_SALDO ), 0 ) ZX_SALDO
   		  INTO vnZX_SALDO
   		  FROM SZX010 SZX
   		  JOIN SD1010 SD1 
   		    ON D1_FILIAL  = ZX_FILIAL 
   		   AND D1_DOC     = ZX_DOC
   		   AND D1_SERIE   = ZX_SERIE
   		   AND D1_FORNECE = ZX_FORNECE
   		   AND D1_LOJA    = ZX_LOJA
   		   AND D1_ITEM    = ZX_ITEMNF
   		   AND D1_FORMUL  = ZX_FORMUL
   		   AND SD1.D_E_L_E_T_ = ' '
   		 WHERE ZX_FILIAL  = IN_FILIAL
   		   AND ZX_PRODUTO = IN_PRODUTO
   		   AND D1_LOCAL   = IN_LOCAL
   		   AND SZX.D_E_L_E_T_ = ' ';
	EXCEPTION 
      	WHEN NO_DATA_FOUND THEN NULL;
   	END;
   	
   	-- Seleciona SC6 - Pedidos Crossdoking n?o liberados
   	BEGIN
   		SELECT NVL( SUM( C6_QTDVEN - C6_QTDENT ), 0 ) C6_QTDVEN
   		  INTO vnC6_QUANT
   		  FROM SC6010
   		 WHERE C6_FILIAL   = IN_FILIAL
   		   AND C6_PRODUTO  = IN_PRODUTO
   		   AND C6_LOCAL    = IN_LOCAL
   		   AND C6_ITCROSD != '    '
   		   AND C6_QTDEMP   = 0  
   		   AND D_E_L_E_T_  = ' ';
	EXCEPTION 
      	WHEN NO_DATA_FOUND THEN NULL;
   	END;
   	
   	-- Calcula o Saldo
   	OUT_SALDO := vnB2_QATU - vnB2_RESERVA - vnB2_QEMP + vnB2_QACLASS - vnZ10_QTD + vnB2__QTDTRA - vnZX_SALDO - vnC6_QUANT + vnB2__QTDISP + vnB2__ENTPRC + vnB2__SAIPRC;
   	
   	-- Verifica se deve somar B2_QNPT / A nova chamada com a Filial 05 ocorre dentro da fun??o Protheus
   	IF ( IN_FILIAL = '03' AND vcB1__SEGISP = '1 ' ) OR ( IN_FILIAL = '05' AND vcB1__SEGISP = '2 ' )THEN
   		OUT_SALDO := OUT_SALDO + vnB2_QNPT;
   	END IF;
END;
*/


/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | xSldKit | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Retorna a quantidade disponivel do KIT                                              |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function xSldKit(_cFilial,_cProd,_cLocal,_cCodSUA)
Local _cSQL := _cTab := "", _nQtdKit := 0, _nQtdComp := 0
Default _cFilial := "", _cProd := "", _cLocal := "", _cCodSUA := ""

DbSelectArea("SUG")
SUG->(DbSetOrder(2))
If !DbSeek(xFilial("SUG") + _cProd)
    MsgStop("KIT Não localizado")
    Return _nQtdKit
EndIf

_cTab := GetNextAlias()
_cSQL := "Select U1_ACESSOR,U1_QTD From " + RetSqlName("SU1") + " U1 "
_cSQL += "Inner Join " + RetSqlName("SB1") + " B1 On B1_COD = U1_ACESSOR And B1.D_E_L_E_T_ = ' ' "
_cSQL += "Where U1_FILIAL = '" + xFilial("SU1") + "' And U1_CODACE = '" + SUG->UG_CODACE + "' And U1_QTD > 0 And U1.D_E_L_E_T_ = ' ' "  

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If Eof()
    MsgStop("KIT Não localizado")
    Return _nQtdKit
Else
    While !Eof()
    
        _nQtdComp := U_xSldProd(_cFilial,(_cTab)->U1_ACESSOR,_cLocal,_cCodSUA)
        
        If _nQtdComp <= 0
            _nQtdKit := 0
            Exit
        Else
            _nQtdComp := Int(_nQtdComp/(_cTab)->U1_QTD)
            
            If _nQtdComp <= 0
                _nQtdKit := 0
                Exit
            ElseIf _nQtdKit == 0 .Or. _nQtdKit > _nQtdComp
                _nQtdKit := _nQtdComp  
            EndIf
        EndIf
            
        DbSelectArea(_cTab)
        DbSkip()
    EndDo
EndIf

Return _nQtdKit