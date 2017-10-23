#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETUMFOR  ºAutor  ³Alexandre Caetano   º Data ³  31/Out/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca segunda unidade de medida do produto para o forncedorº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GETUMFOR()
Local cRet	:= Space( AvSx3("A5__UNFOR",3) )
 
if FunName() = "MATA121"  // Pedido de compra 
	cForn	:= M->CA120Forn
  	cLoja 	:= M->CA120Loj
  	cProd	:= gdFieldGet("C7_PRODUTO")
Elseif FunName() = "MATA140" 
	cForn	:= M->CA100For
  	cLoja 	:= M->cLoja
  	cProd	:= gdFieldGet("D1_COD")   
Elseif FunName() = "MATA103"
	cForn	:= M->CA100For
  	cLoja 	:= M->cLoja
  	cProd	:= M->D1_COD  // gdFieldGet("D1_COD")   
Elseif FunName() = "MATA150"  	           
	cForn	:= SC8->C8_FORNECEDOR
  	cLoja 	:= SC8->C8_LOJA
	cProd	:= gdFieldGet("C8_PROODUTO")
Else
    Return cRet   
Endif

SA5->( dbSetOrder(1) ) //FILIAL + FORNCEDOR + LOJA + PRODUTO
if SA5->( dbSeek(xFilial("SA5") + cForn + cLoja + cProd ) )
	cRet	:= SA5->A5__UNFOR
Else 
	cRet	:= Space( AvSx3("A5__UNFOR",3) )
Endif

Return(cRet) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcQtd  ºAutor  ³Alexandre Cetano     º Data ³  31/Out/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula quantidade na primeira unidade de medida            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcQTD()
Local nRet := 0

if FunName() = "MATA121"  // Pedido de compra 
	cUM1	:= avKey(GdFieldget("C7_UM")  ,"ZQ_UM1")
  	cUM2 	:= avKey(GdFieldget("C7_SEGUM"),"ZQ_UM2")
  	nQtd	:= GdFieldget("C7__QTDSEG") 
Elseif FunName() = "MATA140" .or. FunName() == "MATA103"
	cUM1	:= avKey(GdFieldget("D1_UM")   ,"ZQ_UM1")
  	cUM2 	:= avKey(GdFieldget("D1__UNMED2"),"ZQ_UM2")
  	nQtd	:= aCols[n][ASCAN(aHeader,{|x|x[2] = "D1__QTDSEG"})]  // GdFieldget("D1__QTDSEG")  
Elseif FunName() = "MATA150"
	cUM1	:= avKey(GdFieldget("C8_UM")   ,"ZQ_UM1")
  	cUM2 	:= avKey(GdFieldget("C8_SEGUM"),"ZQ_UM2")
  	nQtd	:= GdFieldget("C8__QTDSEG")  
Endif

SZQ->( dbSetOrder(1) )
if SZQ->( dbSeek(xFilial("SZQ") + cUM1 + cUM2) )                
	if SZQ->ZQ_TIPOCON = "M"        // Divide pois estamos convertendo da segunda unidade para a primeira    
		nRet := (nQtd / SZQ->ZQ_CONV)
	Elseif SZQ->ZQ_TIPOCON = "D"    // Multiplica pois estamos convertendo da segunda unidade para a primeira
		nRet := (nQtd * SZQ->ZQ_CONV)
	Endif
Else
	msgAlert("Conversão entre as unidade de medidas não cadastrada","Atenção")
endif

Return(nRet)



// Criado por Luis Carlos em 29/11

User Function CalcQTDUM()
Local nRet := 0

if FunName() = "MATA121"  // Pedido de compra 
	cUM1	:= avKey(GdFieldget("C7_UM")  ,"ZQ_UM1")
  	cUM2 	:= avKey(GdFieldget("C7_SEGUM"),"ZQ_UM2")
  	nQtd	:= GdFieldget("C7_QUANT") 
Elseif FunName() = "MATA140" .or. FunName() == "MATA103"
	cUM1	:= aCols[n][ASCAN(aHeader,{|x|x[2] = "D1_UM"})]		//avKey(GdFieldget("D1_UM")   ,"ZQ_UM1")
  	cUM2 	:= aCols[n][ASCAN(aHeader,{|x|x[2] = "D1__UNMED2"})]  	//avKey(GdFieldget("D1_SEGUM"),"ZQ_UM2")
  	nQtd	:= aCols[n][ASCAN(aHeader,{|x|x[2] = "D1_QUANT"})]    	//GdFieldget("D1_QUANT")  
Elseif FunName() = "MATA150"
	cUM1	:= avKey(GdFieldget("C8_UM")   ,"ZQ_UM1")
  	cUM2 	:= avKey(GdFieldget("C8_SEGUM"),"ZQ_UM2")
  	nQtd	:= GdFieldget("C8_QUANT")  
Endif

SZQ->( dbSetOrder(2) )
if SZQ->( dbSeek(xFilial("SZQ") + cUM2 + cUM1) )
	if SZQ->ZQ_TIPOCON = "M"        // Divide pois estamos convertendo da segunda unidade para a primeira    
		nRet := (SZQ->ZQ_CONV * nQtd)
	Elseif SZQ->ZQ_TIPOCON = "D"    // Multiplica pois estamos convertendo da segunda unidade para a primeira
		nRet := (nQtd / SZQ->ZQ_CONV)
	Endif
Else      
	if ! atisrotina("U_MT103IPC")
		msgAlert("Conversão entre as unidade de medidas não cadastrada","Atenção")
	endif
endif

Return(nRet)