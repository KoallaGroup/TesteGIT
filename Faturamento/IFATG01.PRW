#Include "Protheus.ch"
#Include "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CHECPRC º Autor ³Juscelino Alves dos Santosº Data ³17/07/14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para capturar a ultima nota de entrada de um        º±±
±±º          ³ determinado produto  , utilizada nos gatilhos do Cod.      º±±
±±º          ³ do Produto e Quantidade do Produto na Tela do Pedido de    º±±
±±º          ³ Venda.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ISAPA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function IFATG01()        
Local _aSaveArea:= GetArea()
Local _cfiltra  :=GetMV("MV__TRAFIL",," ")       
Local _cprodut  :=aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})] 
Local _nprcus   :=aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] 
Local _npLoc    :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local _cLocal   :=aCols[n][_npLoc]
Local _ccgc:=MaskCGC(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CGC"))

If Alltrim(_ccgc) $ _cfiltra .And. !Empty(_ccgc)

   _nprcus:=U_Pesultc(_cprodut)
   If Empty(_nprcus)
      _nprcus := Posicione("SB2",1,xFilial("SB2")+_cprodut+_cLocal,"B2_CM1")
   EndIf	

	_nValICM := retICMS(_cprodut, _nprcus)
	
	_nprcus := _nprcus / ((100 - _nValICM)/100)  
	
else
	_nprcus := Posicione("SB2",1,xFilial("SB2")+_cprodut+_cLocal,"B2_CM1")
EndIf

RestArea(_aSaveArea)

Return _nprcus


//* Rotina para gerar uma Query para Rastrear a ultima Nota de Entrada de um Determinado Produto
//
User Function Pesultc(_cprod)
Local _aSaveArea:= GetArea()
Local _nvlcom   :=0
Local _cArqSD1	:= GetNextAlias() 

_cQuery := " SELECT D1_FILIAL, D1_EMISSAO , D1_COD , D1_CUSTO , D1.R_E_C_N_O_  AS REG, D1_QUANT "
_cQuery += " FROM "+ RetSqlName("SD1") + " D1"
_cQuery += " INNER JOIN "+ RetSqlName("SF4") + " F4 ON F4_CODIGO = D1_TES "
_cQuery += " 									   AND F4_FILIAL = '" + xFilial("SF4") + "' "
_cQuery += " 									   AND F4_ESTOQUE = 'S' "
_cQuery += " 									   AND F4_DUPLIC = 'S' "
_cQuery += " 									   AND F4.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE  D1.D_E_L_E_T_ = ' ' "
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "' "
_cQuery += " AND D1_COD = '" + _cprod + "' "
_cQuery += " AND D1_TIPO = 'N' "                   
_cQuery += " AND D1_CUSTO > 0 "
_cQuery += " AND D1.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM "+RetSqlName("SD1") +" D11  "
_cQuery += " WHERE   D11.D_E_L_E_T_ = ' '   AND  D1.D1_FILIAL = D11.D1_FILIAL  AND   D1.D1_COD =  D11.D1_COD) "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cArqSD1,.T.,.T.)

(_cArqSD1)->(DbGotop())
_reg:=0
While (_cArqSD1)->(!Eof())   
  If _reg<(_cArqSD1)->REG           
     _nvlcom := (_cArqSD1)->D1_CUSTO / (_cArqSD1)->D1_QUANT
     _reg:=(_cArqSD1)->REG
  EndIf   
  (_cArqSD1)->(DbSkip())
End-While
(_cArqSD1)->(DbCloseArea())

RestArea(_aSaveArea)

Return _nvlcom



//* Rotina para retirar a mascara do CGC de um Cliente 

Static Function MaskCGC( _cCNPJ )

 Local _cCNPJClea := _cCNPJ
 
 BEGIN SEQUENCE
 
  IF Empty( _cCNPJClea )
   BREAK
  EndIF

  
  _cCNPJClea := StrTran( _cCNPJClea , "." , "" )

  _cCNPJClea := StrTran( _cCNPJClea , "/" , "" )

  _cCNPJClea := StrTran( _cCNPJClea , "-" , "" )

  _cCNPJClea := AllTrim( _cCNPJClea )
  
 END SEQUENCE

Return( _cCNPJClea )



static function retICMS(_cProd, _nprcus)
	
	MaFisSave()
	MaFisEnd()
	MaFisIni(M->C5_CLIENTE,;  				// 1-Codigo Cliente/Fornecedor
			 M->C5_LOJACLI,;           		// 2-Loja do Cliente/Fornecedor
			 "C",;                  		// 3-C:Cliente , F:Fornecedor
			 "N",;                  		// 4-Tipo da NF
			 M->C5_TIPOCLI,;        		// 5-Tipo do Cliente/Fornecedor
			 Nil,;
			 Nil,;
		 	 Nil,;
			 Nil,;
			 "MATA461")
	
	MaFisAdd(_cProd,; 						// 1-Codigo do Produto ( Obrigatorio )
			 "",; 							// 2-Codigo do TES ( Opcional )
			 1,; 		   					// 3-Quantidade ( Obrigatorio )
			 _nprcus,;						// 4-Preco Unitario ( Obrigatorio )
			 0,; 							// 5-Valor do Desconto ( Opcional )
			 "",; 							// 6-Numero da NF Original ( Devolucao/Benef )
			 "",; 							// 7-Serie da NF Original ( Devolucao/Benef )
			 0,; 							// 8-RecNo da NF Original no arq SD1/SD2
			 0,; 							// 9-Valor do Frete do Item ( Opcional )
			 0,; 							// 10-Valor da Despesa do item ( Opcional )
			 0,; 							// 11-Valor do Seguro do item ( Opcional )
			 0,; 							// 12-Valor do Frete Autonomo ( Opcional )
			 _nprcus,;			   			// 13-Valor da Mercadoria ( Obrigatorio )
			 0) 							// 14-Valor da Embalagem ( Opcional )
	    	
	_nAlqICM := MaFisRet(1,"IT_ALIQICM")
	
	MaFisEnd()
	MaFisRestore()

Return _nAlqICM
